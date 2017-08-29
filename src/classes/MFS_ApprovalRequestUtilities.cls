/***************************************************************************************************
Apex Class Name    : MFS_FeeApprovalRequestUtilities
Version            : 1.0 
Created Date       : 16 JUN 2016
Function           : This is a Utility class for FreeApprovalRequestTrigger
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            06/16/2016              Original Version
***************************************************************************************************/
public class MFS_ApprovalRequestUtilities {
    //This utility method will replicate the Opportunity Line Item Status as in Fee Approval Request
    public static List<OpportunityLineItem> updateLineItemStatus(List<OpportunityLineItem> oppLinItemsLst, Map<String, String> oppProdMap)
    {
        List<OpportunityLineItem> oppLinItemsToUpdate = new List<OpportunityLineItem>();
    	for(OpportunityLineItem oli : oppLinItemsLst)
        {
            oli.Approval_Status__c = oppProdMap.get(oli.id);
            oppLinItemsToUpdate.add(oli);
        }
        return oppLinItemsToUpdate;
    }
    public static void submitForApproval(Approval_request__c far)
    {
        Approval.ProcessSubmitRequest appReq=new Approval.ProcessSubmitRequest();
        appReq.setObjectId(far.id);
        appReq.setNextApproverIds(new Id[] {far.Next_Approver__c});   
        Approval.ProcessResult appResult=Approval.process(appReq);
    }
    //Follow-up approval process based on domestic case record
    public static void approvalProcessDomestic(Map<String, String> cseProdMap)
    {
        List<Approval_Request__c> appRecList=new  List<Approval_Request__c>();
        Id recordTypeId=Schema.SObjectType.Approval_Request__c.getRecordTypeInfosByName().get(MFS_AllConstants.APPROVAL_ONBOARDING_RT).getRecordTypeId();
        List<Case> caseList = [Select id,Approval_Status__c,RecordType.DeveloperName,OwnerId,GDS_Acknowledgement__c,Funds_Lawyer__c,FATCA_Lawyer__c,
                    Final_Acknowledgement__c,Distribution_Lawyer__c,AML_Lawyer__c,Corporate_Finance__c,
                    Compliance_AML_KYC__c,Non_US_Questionnaire_Approval_Group__c,Corporate_Finance_Billing_Approver__c,
                    Compliance_AML_KYC_Approver__c,Strategic_Alliance_Department_Heads__c,CFO_Onboarding_Retail_Lookup__c,
                    Co_Heads_of_Global_Distribution__c,GDS_Acknowledgement__r.Name,Funds_Lawyer__r.Name,FATCA_Lawyer__r.Name,
                    Final_Acknowledgement__r.Name,Distribution_Lawyer__r.Name,AML_Lawyer__r.Name,Corporate_Finance_Billing_Approver__r.Name,
                    Compliance_AML_KYC_Approver__r.Name,CFO_Onboarding_Retail_Lookup__r.Name,Co_Heads_of_Global_Distribution__r.Name
                    from Case where id in : cseProdMap.keySet() ];
         for(Case caseRec : caseList)
        {
           if(caseRec.Compliance_AML_KYC__c == true)
            {
              Approval_Request__c appReq =new Approval_Request__c();
         	  appReq.Onboarding_Case__c=caseRec.Id;
         	  appReq.RecordTypeId=recordTypeId;
              appReq.Approver_Group__c= System.Label.OB_Compliance_AML_KYC_Group;
              appReq.Approver_Group_User__c= System.Label.OB_Compliance_AML_KYC_Group;
              appReq.OwnerId=caseRec.OwnerId;
         	  appRecList.add(appReq);
            }
             if(caseRec.Corporate_Finance__c == true)
            {
              Approval_Request__c appReq =new Approval_Request__c();
         	  appReq.Onboarding_Case__c=caseRec.Id;
         	  appReq.RecordTypeId=recordTypeId;
              appReq.Approver_Group__c= System.Label.OB_Corporate_Finance_Billing_Group;
              appReq.Approver_Group_User__c=System.Label.OB_Corporate_Finance_Billing_Group;
              appReq.OwnerId=caseRec.OwnerId;
         	  appRecList.add(appReq);
            }
            if(caseRec.GDS_Acknowledgement__c != null && caseRec.RecordType.DeveloperName == System.Label.OB_AM_Domestic_NonUS_Retail)
            {
              Approval_Request__c appReq =new Approval_Request__c();
         	  appReq.Onboarding_Case__c=caseRec.Id;
         	  appReq.RecordTypeId=recordTypeId;
              appReq.GDS_Acknowledgement__c=caseRec.GDS_Acknowledgement__c;
              appReq.Approver_Group_User__c=caseRec.GDS_Acknowledgement__r.Name;
              appReq.OwnerId=caseRec.OwnerId;
         	  appRecList.add(appReq); 
            }
            if(caseRec.Funds_Lawyer__c != null)
            {
              Approval_Request__c appReq =new Approval_Request__c();
         	  appReq.Onboarding_Case__c=caseRec.Id;
         	  appReq.RecordTypeId=recordTypeId;
              appReq.Funds_Lawyer__c=caseRec.Funds_Lawyer__c;
              appReq.Approver_Group_User__c=caseRec.Funds_Lawyer__r.Name;
              appReq.OwnerId=caseRec.OwnerId;
         	  appRecList.add(appReq); 
            }
            if(caseRec.FATCA_Lawyer__c != null)
            {
              Approval_Request__c appReq =new Approval_Request__c();
         	  appReq.Onboarding_Case__c=caseRec.Id;
         	  appReq.RecordTypeId=recordTypeId;
              appReq.FATCA_Lawyer__c=caseRec.FATCA_Lawyer__c;
              appReq.Approver_Group_User__c=caseRec.FATCA_Lawyer__r.Name;
              appReq.OwnerId=caseRec.OwnerId;
         	  appRecList.add(appReq); 
            }
            if(caseRec.Final_Acknowledgement__c != null)
            {
              Approval_Request__c appReq =new Approval_Request__c();
         	  appReq.Onboarding_Case__c=caseRec.Id;
         	  appReq.RecordTypeId=recordTypeId;
              appReq.Final_Acknowledgement__c=caseRec.Final_Acknowledgement__c;
              appReq.Approver_Group_User__c=caseRec.Final_Acknowledgement__r.Name;
              appReq.OwnerId=caseRec.OwnerId;
         	  appRecList.add(appReq); 
            }
            if(caseRec.Distribution_Lawyer__c != null)
            {
              Approval_Request__c appReq =new Approval_Request__c();
         	  appReq.Onboarding_Case__c=caseRec.Id;
         	  appReq.RecordTypeId=recordTypeId;
              appReq.Distribution_Lawyer__c=caseRec.Distribution_Lawyer__c;
              appReq.Approver_Group_User__c=caseRec.Distribution_Lawyer__r.Name;
              appReq.OwnerId=caseRec.OwnerId;
         	  appRecList.add(appReq); 
            }
            if(caseRec.AML_Lawyer__c != null)
            {
              Approval_Request__c appReq =new Approval_Request__c();
         	  appReq.Onboarding_Case__c=caseRec.Id;
         	  appReq.RecordTypeId=recordTypeId;
              appReq.AML_Lawyer__c=caseRec.AML_Lawyer__c;
              appReq.Approver_Group_User__c=caseRec.AML_Lawyer__r.Name;
              appReq.OwnerId=caseRec.OwnerId;
         	  appRecList.add(appReq); 
            }
        }
        if(!appRecList.isEmpty())
        {
            DataBase.SaveResult[] saveResults=DataBase.insert(appRecList);
        List<Approval.ProcessSubmitRequest> appReqList=new List<Approval.ProcessSubmitRequest>();
        for(DataBase.SaveResult saveRes:saveResults)
        {
            Approval.ProcessSubmitRequest appReq=new Approval.ProcessSubmitRequest();
            appReq.setObjectId(saveRes.getId());
            appReqList.add(appReq);
        }
         Approval.ProcessResult[] appResults=Approval.process(appReqList);
         List<Case> caseListToBeUpd = new List<Case>();
           for(Case caseRecord : caseList)
           {
            caseRecord.Approval_Status__c=System.Label.OB_Submitted; 
            for(Approval.ProcessResult appResult :appResults)
            {
                if(!appResult.isSuccess())
                {
                     caseRecord.Approval_Status__c=System.Label.OB_Not_Started;
                }
            }
            caseListToBeUpd.add(caseRecord);
            //update caseRecord; 
           }
           update caseListToBeUpd;
        }
      }
    //Follow-up approval process for Amendment case record
    public static void approvalProcessAmendment(Set<Id> caseId)
    {
        List<Approval_Request__c> appRecList=new  List<Approval_Request__c>();
        Integer totalNoOfRecords = 0;
        Id recordTypeId=Schema.SObjectType.Approval_Request__c.getRecordTypeInfosByName().get(MFS_AllConstants.APPROVAL_ONBOARDING_RT).getRecordTypeId();
        List<Approval_Request__c> appReqList = [Select Id,Approval_Status__c,Co_Heads_of_Global_Distribution__c from Approval_Request__c where Onboarding_Case__c in : caseId];
        for(Approval_Request__c appreq : appReqList)
        {
            if(appreq.Approval_Status__c == MFS_AllConstants.STATUS_APPROVED && appreq.Co_Heads_of_Global_Distribution__c == null)
               totalNoOfRecords++;
        }
        List<Case> caseList = [Select OwnerId,Outside_Guidelines__c,CFO_Onboarding_Retail_Lookup__r.Name,Co_Heads_of_Global_Distribution__r.Name,
                               RecordType.DeveloperName,CFO_Onboarding_Retail_Lookup__c,
                               Co_Heads_of_Global_Distribution__c from case where ID in : caseId];
        if(totalNoOfRecords == appReqList.size())
        {
            for(Case caseRec : caseList) 
            {
                if(caseRec.Outside_Guidelines__c == true && caseRec.CFO_Onboarding_Retail_Lookup__r.Name == System.Label.OB_User_Amrit_Kanwal)
                {
                    Approval_Request__c appReq =new Approval_Request__c();
                    appReq.Onboarding_Case__c=caseRec.Id;
                    appReq.RecordTypeId=recordTypeId;
                    appReq.CFO_Acknowledgement__c=caseRec.CFO_Onboarding_Retail_Lookup__c;
                    appReq.Approver_Group_User__c=caseRec.CFO_Onboarding_Retail_Lookup__r.Name;
                    appReq.OwnerId=caseRec.OwnerId;
                    appRecList.add(appReq);
                    Approval_Request__c appReq1 =new Approval_Request__c();
                    appReq1.Onboarding_Case__c=caseRec.Id;
                    appReq1.RecordTypeId=recordTypeId;
                    appReq1.Co_Heads_of_Global_Distribution__c=caseRec.Co_Heads_of_Global_Distribution__c;
                    appReq1.Approver_Group_User__c=caseRec.Co_Heads_of_Global_Distribution__r.Name;
                    appReq1.OwnerId=caseRec.OwnerId;
                    appRecList.add(appReq1);
                }
                if(caseRec.Outside_Guidelines__c != true && caseRec.CFO_Onboarding_Retail_Lookup__r.Name != System.Label.OB_User_Amrit_Kanwal)
                {
                    Approval_Request__c appReq =new Approval_Request__c();
                    appReq.Onboarding_Case__c=caseRec.Id;
                    appReq.RecordTypeId=recordTypeId;
                    appReq.Co_Heads_of_Global_Distribution__c=caseRec.Co_Heads_of_Global_Distribution__c;
                    appReq.Approver_Group_User__c=caseRec.Co_Heads_of_Global_Distribution__r.Name;
                    appReq.OwnerId=caseRec.OwnerId;
                    appRecList.add(appReq);
                }
            }
            if(!appRecList.isEmpty())
            {
                DataBase.SaveResult[] saveResults=DataBase.insert(appRecList);
                List<Approval.ProcessSubmitRequest> appProcessList=new List<Approval.ProcessSubmitRequest>();
                for(DataBase.SaveResult saveRes:saveResults)
                {
                    Approval.ProcessSubmitRequest appReq=new Approval.ProcessSubmitRequest();
                    appReq.setObjectId(saveRes.getId());
                    appProcessList.add(appReq);
                }
                Approval.ProcessResult[] appResults=Approval.process(appProcessList);
                List<Case> caseListToBeUpdated = new List<Case>();
                for(Case caseRecord : caseList)
                {
                    caseRecord.Approval_Status__c=System.Label.OB_Submitted; 
                    for(Approval.ProcessResult appResult :appResults)
                    {
                        if(!appResult.isSuccess())
                        {
                            caseRecord.Approval_Status__c=System.Label.OB_Not_Started;
                        }
                    }
                    //update caseRecord; 
                    caseListToBeUpdated.add(caseRecord);
                }
                update caseListToBeUpdated;
            }
            
        } 
    }
}