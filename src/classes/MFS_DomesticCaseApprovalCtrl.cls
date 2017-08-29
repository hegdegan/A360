/***************************************************************************************************
Apex Class Name    : MFS_DomesticCaseApprovalCtrl 
Version            : 1.0 
Created Date       : 7 Nov 2016
Function           : Class used for approval process for Domestic/Ammendment record type
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey               11/07/2016              Original Version
***************************************************************************************************/
public with Sharing class MFS_DomesticCaseApprovalCtrl {
    public  Case caseRecord{get;set;}
    
    //Constructor
    public MFS_DomesticCaseApprovalCtrl(ApexPages.StandardController stdCtrl){
        try {
            caseRecord=[Select id,Approval_Status__c,RecordType.DeveloperName,OwnerId,GDS_Acknowledgement__c,Funds_Lawyer__c,FATCA_Lawyer__c,
                        Final_Acknowledgement__c,Distribution_Lawyer__c,AML_Lawyer__c,Corporate_Finance__c,
                        Compliance_AML_KYC__c,Non_US_Questionnaire_Approval_Group__c,Corporate_Finance_Billing_Approver__c,
                        Compliance_AML_KYC_Approver__c,Strategic_Alliance_Department_Heads__c,CFO_Onboarding_Retail_Lookup__c,
                        Co_Heads_of_Global_Distribution__c,GDS_Acknowledgement__r.Name,Funds_Lawyer__r.Name,FATCA_Lawyer__r.Name,
                        Final_Acknowledgement__r.Name,Distribution_Lawyer__r.Name,AML_Lawyer__r.Name,Corporate_Finance_Billing_Approver__r.Name,
                        Compliance_AML_KYC_Approver__r.Name,CFO_Onboarding_Retail_Lookup__r.Name,Co_Heads_of_Global_Distribution__r.Name
                        from Case where id=:String.escapeSingleQuotes(stdCtrl.getRecord().Id) limit 1];
        } catch(Exception exe) {
            System.debug('Exception occured:'+exe.getMessage()+exe.getLineNumber());
        }
    }
    
    /**
* @Description : Method is used to submit Approval Request records to approval process.
* @Param : N/A
* @return: PageReference
**/
    public PageReference submitForApproval(){
        try {
            List<Approval_Request__c> approvalReqList=createApprovalReqRec(caseRecord);
            DataBase.SaveResult[] saveResults=DataBase.insert(approvalReqList);
            List<Approval.ProcessSubmitRequest> appReqList=new List<Approval.ProcessSubmitRequest>();
            for(DataBase.SaveResult saveRes:saveResults){
                Approval.ProcessSubmitRequest appReq=new Approval.ProcessSubmitRequest();
                appReq.setObjectId(saveRes.getId());
                appReqList.add(appReq);
            }
            Approval.ProcessResult[] appResults=Approval.process(appReqList);
            caseRecord.Approval_Status__c=System.Label.OB_Submitted; 
            for(Approval.ProcessResult appResult :appResults){
                if(!appResult.isSuccess()){
                    caseRecord.Approval_Status__c=System.Label.OB_Not_Started;
                }
            }
            update caseRecord;
            
        } catch(Exception exe) {
            System.debug('Exception occured:'+exe.getMessage()+exe.getLineNumber());
        }
        return new PageReference(MFS_AllConstants.SLASH + caseRecord.ID);
    }
    
    /**
* @Description : Method is used to create Approval Request records
* @Param : Case
* @return: List<Approval_Request__c>
**/
    public  List<Approval_Request__c> createApprovalReqRec(Case caseRec){	
        List<Approval_Request__c> appRecList=new  List<Approval_Request__c>();
        Id recordTypeId=Schema.SObjectType.Approval_Request__c.getRecordTypeInfosByName().get(MFS_AllConstants.APPROVAL_ONBOARDING_RT).getRecordTypeId(); 
        try{
            if(caseRec.Non_US_Questionnaire_Approval_Group__c == true){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Approver_Group__c= Label.OB_DM_Non_US_Questionnaire_Approver_Group;
                appReq.Approver_Group_User__c= Label.OB_DM_Non_US_Questionnaire_Approver_Group;
                appReq.OwnerId=caseRec.OwnerId;
                appRecList.add(appReq);
            } else {
                if(caseRec.Compliance_AML_KYC__c == true){
                    Approval_Request__c appReq =new Approval_Request__c();
                    appReq.Onboarding_Case__c=caseRec.Id;
                    appReq.RecordTypeId=recordTypeId;
                    appReq.Approver_Group__c= Label.OB_DM_Compliance_AML_KYC_Group;
                    appReq.Approver_Group_User__c= Label.OB_DM_Compliance_AML_KYC_Group;
                    appReq.OwnerId=caseRec.OwnerId;
                    appRecList.add(appReq);
                }
                
                if(caseRec.Corporate_Finance__c == true){
                    Approval_Request__c appReq =new Approval_Request__c();
                    appReq.Onboarding_Case__c=caseRec.Id;
                    appReq.RecordTypeId=recordTypeId;
                    appReq.Approver_Group__c= Label.OB_DM_Corporate_Finance_Billing_Group;
                    appReq.Approver_Group_User__c= Label.OB_DM_Corporate_Finance_Billing_Group;
                    appReq.OwnerId=caseRec.OwnerId;
                    appRecList.add(appReq);
                }
                
                if(caseRec.GDS_Acknowledgement__c != null && caseRec.RecordType.DeveloperName == Label.OB_AM_Domestic_NonUS_Retail){
                    Approval_Request__c appReq =new Approval_Request__c();
                    appReq.Onboarding_Case__c=caseRec.Id;
                    appReq.RecordTypeId=recordTypeId;
                    appReq.GDS_Acknowledgement__c=caseRec.GDS_Acknowledgement__c;
                    appReq.Approver_Group_User__c=caseRec.GDS_Acknowledgement__r.Name;
                    appReq.OwnerId=caseRec.OwnerId;
                    appRecList.add(appReq); 
                }
                
                if(caseRec.Funds_Lawyer__c != null){
                    Approval_Request__c appReq =new Approval_Request__c();
                    appReq.Onboarding_Case__c=caseRec.Id;
                    appReq.RecordTypeId=recordTypeId;
                    appReq.Funds_Lawyer__c=caseRec.Funds_Lawyer__c;
                    appReq.Approver_Group_User__c=caseRec.Funds_Lawyer__r.Name;
                    appReq.OwnerId=caseRec.OwnerId;
                    appRecList.add(appReq); 
                }
                
                if(caseRec.FATCA_Lawyer__c != null){
                    Approval_Request__c appReq =new Approval_Request__c();
                    appReq.Onboarding_Case__c=caseRec.Id;
                    appReq.RecordTypeId=recordTypeId;
                    appReq.FATCA_Lawyer__c=caseRec.FATCA_Lawyer__c;
                    appReq.Approver_Group_User__c=caseRec.FATCA_Lawyer__r.Name;
                    appReq.OwnerId=caseRec.OwnerId;
                    appRecList.add(appReq); 
                }
                
                if(caseRec.Final_Acknowledgement__c != null){
                    Approval_Request__c appReq =new Approval_Request__c();
                    appReq.Onboarding_Case__c=caseRec.Id;
                    appReq.RecordTypeId=recordTypeId;
                    appReq.Final_Acknowledgement__c=caseRec.Final_Acknowledgement__c;
                    appReq.Approver_Group_User__c=caseRec.Final_Acknowledgement__r.Name;
                    appReq.OwnerId=caseRec.OwnerId;
                    appRecList.add(appReq); 
                }
                
                if(caseRec.Distribution_Lawyer__c != null){
                    Approval_Request__c appReq =new Approval_Request__c();
                    appReq.Onboarding_Case__c=caseRec.Id;
                    appReq.RecordTypeId=recordTypeId;
                    appReq.Distribution_Lawyer__c=caseRec.Distribution_Lawyer__c;
                    appReq.Approver_Group_User__c=caseRec.Distribution_Lawyer__r.Name;
                    appReq.OwnerId=caseRec.OwnerId;
                    appRecList.add(appReq); 
                }
                
                if(caseRec.AML_Lawyer__c != null){
                    Approval_Request__c appReq =new Approval_Request__c();
                    appReq.Onboarding_Case__c=caseRec.Id;
                    appReq.RecordTypeId=recordTypeId;
                    appReq.AML_Lawyer__c=caseRec.AML_Lawyer__c;
                    appReq.Approver_Group_User__c=caseRec.AML_Lawyer__r.Name;
                    appReq.OwnerId=caseRec.OwnerId;
                    appRecList.add(appReq); 
                }
            }
            
            if(caseRec.Strategic_Alliance_Department_Heads__c == true){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Approver_Group__c= Label.OB_AM_Strategic_Alliance_Department_Heads_Group;
                appReq.Approver_Group_User__c= Label.OB_AM_Strategic_Alliance_Department_Heads_Group;
                appReq.OwnerId=caseRec.OwnerId;
                appRecList.add(appReq);
            }
            
            if(caseRec.Corporate_Finance_Billing_Approver__c != null){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Corp_Finance_Billing_Group__c=caseRec.Corporate_Finance_Billing_Approver__c;
                appReq.Approver_Group_User__c=caseRec.Corporate_Finance_Billing_Approver__r.Name;
                appReq.OwnerId=caseRec.OwnerId;
                appRecList.add(appReq);
            }
            
            if(caseRec.GDS_Acknowledgement__c != null && caseRec.RecordType.DeveloperName == Label.OB_AM_Amendment_URF){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.GDS_Acknowledgement__c=caseRec.GDS_Acknowledgement__c;
                appReq.Approver_Group_User__c=caseRec.GDS_Acknowledgement__r.Name;
                appReq.OwnerId=caseRec.OwnerId;
                appRecList.add(appReq);
            }
            
            if(caseRec.Compliance_AML_KYC_Approver__c != null) {
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Compliance_AML_KYC__c=caseRec.Compliance_AML_KYC_Approver__c;
                appReq.Approver_Group_User__c=caseRec.Compliance_AML_KYC_Approver__r.Name;
                appReq.OwnerId=caseRec.OwnerId;
                appRecList.add(appReq);
            }
        } catch(Exception ex){
            System.debug('Exception'+ex.getStackTraceString());
        }
        
        return appRecList;
    }
    
    /**
* @Description : Cancel method to return user to original case record
* @Param : N/A
* @return: PageReference
**/    
    public PageReference goBack(){
        return new PageReference(MFS_AllConstants.SLASH + caseRecord.ID);
    }
    
}