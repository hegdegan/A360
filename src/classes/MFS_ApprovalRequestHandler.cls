/***************************************************************************************************
Apex Class Name    : MFS_FeeApprovalRequestHandler
Version            : 1.0 
Created Date       : 6 JUN 2016
Function           : This is a Handler class for FreeApprovalRequestTrigger
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            06/06/2016              Original Version
* Priya Gupta			  15/09/2016			 Updated with 'beforeTriggerEventHandler'
***************************************************************************************************/
public class MFS_ApprovalRequestHandler {
    
    /**
    * @Description :Method is used to calcualte number of approval obtain for an onboarding case
    * @Param : List of Approval_Request__c
    * @return: N/A
    **/
    public static void beforeTriggerEventHandler(List<Approval_Request__c> newList){
        
        Id recordTypeId=Schema.SObjectType.Approval_Request__c.getRecordTypeInfosByName().get(MFS_AllConstants.APPROVAL_ONBOARDING_RT).getRecordTypeId(); 
        Map<Id,Integer> caseDetails =new Map<Id,Integer>();
        for(Approval_Request__c far: newList){
            if(far.RecordTypeId==recordTypeId && far.Approval_Status__c == MFS_AllConstants.APPROVAL_STATUS_APPROVED){
                if(null!=caseDetails.get(far.Onboarding_Case__c)) {
                    caseDetails.put(far.Onboarding_Case__c,caseDetails.get(far.Onboarding_Case__c)+1);
                } else {
                    caseDetails.put(far.Onboarding_Case__c,1);
                }
            }
        }
        
        List<Case> caseToUpdate=[Select Id,Number_of_Approvals_Received__c from Case where Id in : caseDetails.KeySet()];
        for(Case caseRec:caseToUpdate) {
            if(null!=caseRec.Number_of_Approvals_Received__c) {
                caseRec.Number_of_Approvals_Received__c= caseRec.Number_of_Approvals_Received__c+caseDetails.get(caseRec.Id); 
            } else {
                caseRec.Number_of_Approvals_Received__c= caseDetails.get(caseRec.Id);
            }
        }
        
        if(!caseToUpdate.isEmpty()){ 
            Database.Saveresult[] srList = Database.update(caseToUpdate);
            for(Database.SaveResult sr : srList ){
                if(!sr.isSuccess()){
                    for(Database.Error err : sr.getErrors()){
                        system.debug(System.Label.OB_AP_Req_MSG1+err.getMessage());
                    }
                }
            }
        } 
    }
    
    //This method will handle after update events. The method is bulkified.   
    public static void afterTriggerEventHandler(Map<Id, Approval_Request__c> newMap, Map<Id, Approval_Request__c> oldMap ){
        
        List<OpportunityLineItem> oppLinItemsToUpdate = new List<OpportunityLineItem>();
        Map<String, String> oppProdMap = new Map<String, String>();
        Map<String, String> caseProdMap = new Map<String, String>();
        Set<Id> caseId = new Set<Id>();
        //Get the Approval Status and Opportunity Line Item Id from Fee Approval request
        List<Approval_Request__c> feeAppReqLst = new List<Approval_Request__c>([select id, Approver_Group__c, RecordType.DeveloperName, Onboarding_Case__r.RecordType.DeveloperName, Approval_Status__c, Onboarding_Case__c, Amount__c, Discount__c, Last_Approver_Id__c, next_Approver__c, Opportuinty_ProductId__c from Approval_Request__c
                                                                                where Id IN :newMap.keySet()]);	
        //If the approval sttaus is changed, then add the values into a Map
        for(Approval_Request__c far : feeAppReqLst){
            Approval_Request__c newFar = newMap.get(far.id); 
            Approval_Request__c oldFar = oldMap.get(far.id);
            
            if(newFar.Approval_Status__c != oldFar.Approval_Status__c){              

                //Storing the values in a map as there is no relationship between objects
                oppProdMap.put(far.Opportuinty_ProductId__c , newFar.Approval_Status__c );
                if(newFar.Approval_Status__c == MFS_AllConstants.STATUS_APPROVED && newFar.Approver_Group__c == System.Label.OB_Non_US_QAG)
                    caseProdMap.put(newfar.Onboarding_Case__c,newFar.Id);
                if(newFar.Approval_Status__c == MFS_AllConstants.STATUS_APPROVED && Far.Onboarding_Case__r.RecordType.DeveloperName == System.Label.OB_AMM_URF)
                    caseId.add(newfar.Onboarding_Case__c);
            }
            //MFS_ApprovalRequestUtilities.approvalProcessDomestic(caseProdMap);
            //MFS_ApprovalRequestUtilities.approvalProcessAmendment(caseId);
            //Criteria to decide whether the Strategy required Level 2 approval
            if((( newFar.Amount__c >=MFS_AllConstants.APPROVAL_AMT_ZERO && newFar.Amount__c <=MFS_AllConstants.APPROVAL_AMT_50M && newFar.Discount__c >MFS_AllConstants.APPROVAL_AMT_FIVE ) || 
                ( newFar.Amount__c >MFS_AllConstants.APPROVAL_AMT_50M && newFar.Amount__c <=MFS_AllConstants.APPROVAL_AMT_100M && newFar.Discount__c >MFS_AllConstants.APPROVAL_AMT_TEN ) || 
                ( newFar.Amount__c >MFS_AllConstants.APPROVAL_AMT_100M && newFar.Amount__c <=MFS_AllConstants.APPROVAL_AMT_200M && newFar.Discount__c >MFS_AllConstants.APPROVAL_AMT_FIFTEEN ) ||
                (newFar.Amount__c >MFS_AllConstants.APPROVAL_AMT_200M && newFar.Discount__c >MFS_AllConstants.APPROVAL_AMT_TWENTY )) ){
                    /* if(newFar.discount__c != oldFar.discount__c)
                    {
                    far.Approval_status__c = 'Pending';
                    if(oldFar.discount__c!=null)
                    {
                    far.Next_Approver__c=null;
                    
                    }
                    update far;
                    } */
                    if(String.isEmpty(newFar.next_Approver__c)){
                        newFar.addError(System.Label.OB_AP_Req_MSG2);
                    }
                    else if(!String.isEmpty(newFar.next_Approver__c) && (newFar.next_Approver__c!=oldFar.next_Approver__c)){
                        if(far.Last_Approver_Id__c!=null && UserInfo.getUserId().contains(far.Last_Approver_Id__c) ){
                            MFS_ApprovalRequestUtilities.submitForApproval(newFar);
                        } else {
                            newFar.addError(System.Label.OB_AP_Req_MSG3);
                        }
                    }
                }
        }
        MFS_ApprovalRequestUtilities.approvalProcessDomestic(caseProdMap);
            MFS_ApprovalRequestUtilities.approvalProcessAmendment(caseId);
        //Get all Opportunity Line Items which requires status update.
        List<OpportunityLineItem> oppLinItemsLst = new List<OpportunityLineItem> ([select id, Approval_Status__c from OpportunityLineItem
                                                                                   where Id IN : oppProdMap.keySet() ]);
        //Prepare a list of Opportunity Line Items with new status.
        oppLinItemsToUpdate = MFS_ApprovalRequestUtilities.updateLineItemStatus(oppLinItemsLst, oppProdMap);
        Database.Saveresult[] srList = Database.update(oppLinItemsToUpdate,false);
        
        for(Database.SaveResult sr : srList ){
            if(!sr.isSuccess()){
                for(Database.Error err : sr.getErrors()){
                    //we should not through error(object.addError()) here because it will prevent user from approving the record. Hence printing it in debug logs
                    system.debug(System.Label.OB_AP_Req_MSG4+err.getMessage());
                }
            }
        }
    }
}