/***************************************************************************************************
Apex Class Name    : MFS_OnBoardingCaseApprovalCtrl 
Version            : 1.0 
Created Date       : 31 AUGUST 2016
Function           : Class is to create approval request records for onbaording case & submit these to approval process.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               31/08/2016              Original Version
***************************************************************************************************/

public with sharing class MFS_OnBoardingCaseApprovalCtrl {
    public  Case caseRecord{get;set;}
    
    //Constructor
    public MFS_OnBoardingCaseApprovalCtrl(ApexPages.StandardController stdCtrl) {
        try {
            caseRecord=[Select id,Funding_Date__c,OwnerId,GIS_Risk_Group__c,Portfolio_Compliance_Back_End_Group__c,Number_of_PM_Approvals_Required__c,Portfolio_Management_Approver1__c,Portfolio_Management_Approver2__c,Portfolio_Management_Approver3__c,Client_Service_Approver__c,Approval_Status__c,
                        Corporate_Finance_Billing_Approver__c,Compliance_AML_KYC_Approver__c,Legal_Approver__c,Compliance_Code_of_Ethics_Group__c,GIS_Transition_Management_Group__c,
                        Insurance_Group__c,MFSI_Management_Group__c,Performance_Information_Management_Group__c,Reporting__c,Trading_Equity_Group__c,Trading_Fixed_Income_Group__c,Investment_Compliance_Group__c,
                        Portfolio_Management_Approver1__r.FirstName,Portfolio_Management_Approver1__r.LastName,Portfolio_Management_Approver2__r.FirstName,Portfolio_Management_Approver3__r.FirstName,
                        Portfolio_Management_Approver2__r.LastName,Portfolio_Management_Approver3__r.LastName,Client_Service_Approver__r.FirstName,Client_Service_Approver__r.LastName,
                        Corporate_Finance_Billing_Approver__r.FirstName,Corporate_Finance_Billing_Approver__r.LastName,Compliance_AML_KYC_Approver__r.FirstName,
                        Compliance_AML_KYC_Approver__r.LastName,Legal_Approver__r.FirstName,Legal_Approver__r.LastName
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
    public  PageReference submitForApproval(){
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
            for(Approval.ProcessResult appResult :appResults) {
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
        
        try { 
            Id recordTypeId=Schema.SObjectType.Approval_Request__c.getRecordTypeInfosByName().get(MFS_AllConstants.APPROVAL_ONBOARDING_RT).getRecordTypeId(); 
            
            //based on the approver selected in the page construct the list
            if(null!=caseRec.Portfolio_Management_Approver1__c || null!=caseRec.Portfolio_Management_Approver2__c ||null!=caseRec.Portfolio_Management_Approver3__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Number_of_PM_Approvals_Required__c= Integer.valueOf(caseRec.Number_of_PM_Approvals_Required__c);
                appReq.Portfolio_Management_Approver1__c=caseRec.Portfolio_Management_Approver1__c;
                appReq.Portfolio_Management_Approver2__c=caseRec.Portfolio_Management_Approver2__c;
                appReq.Portfolio_Management_Approver3__c=caseRec.Portfolio_Management_Approver3__c;
                appReq.Approver_Group__c=System.Label.OB_Portfolio_Management_Group;
                if(caseRec.Portfolio_Management_Approver1__c!=null )
                    appReq.Approver_Group_User__c=caseRec.Portfolio_Management_Approver1__r.FirstName+' '+caseRec.Portfolio_Management_Approver1__r.LastName +',';
                if(caseRec.Portfolio_Management_Approver2__c!=null)
                    appReq.Approver_Group_User__c=appReq.Approver_Group_User__c+caseRec.Portfolio_Management_Approver2__r.FirstName+' '+caseRec.Portfolio_Management_Approver2__r.LastName +',';
                if(caseRec.Portfolio_Management_Approver3__c!=null)
                    appReq.Approver_Group_User__c=appReq.Approver_Group_User__c+caseRec.Portfolio_Management_Approver3__r.FirstName+' '+caseRec.Portfolio_Management_Approver3__r.LastName;
                (appReq.Approver_Group_User__c).RemoveEnd(','); 
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appReq.OwnerId=caseRec.OwnerId;
                appRecList.add(appReq);
            }
            if(null!=caseRec.Client_Service_Approver__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Client_Service_Approver__c=caseRec.Client_Service_Approver__c;
                appReq.Approver_Group__c=System.Label.OB_Client_Service_Group;
                appReq.Approver_Group_User__c=caseRec.Client_Service_Approver__r.FirstName+' '+caseRec.Client_Service_Approver__r.LastName;
                appReq.OwnerId=caseRec.OwnerId;
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appRecList.add(appReq);
            }
            if(null!=caseRec.Corporate_Finance_Billing_Approver__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Corporate_Finance_Billing_Approver__c=caseRec.Corporate_Finance_Billing_Approver__c;
                appReq.Approver_Group__c=System.Label.OB_Corporate_Finance_Billing_Group;
                appReq.Approver_Group_User__c=caseRec.Corporate_Finance_Billing_Approver__r.FirstName+' '+caseRec.Corporate_Finance_Billing_Approver__r.LastName;
                appReq.OwnerId=caseRec.OwnerId;
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appRecList.add(appReq);
            }
            if(null!=caseRec.Compliance_AML_KYC_Approver__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Compliance_AML_KYC_Approver__c=caseRec.Compliance_AML_KYC_Approver__c;
                appReq.Approver_Group__c=System.Label.OB_Compliance_AML_KYC_Group;
                appReq.Approver_Group_User__c=caseRec.Compliance_AML_KYC_Approver__r.FirstName+' '+caseRec.Compliance_AML_KYC_Approver__r.LastName;
                appReq.OwnerId=caseRec.OwnerId;
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appRecList.add(appReq);
            }
            if(null!=caseRec.Legal_Approver__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Legal_Approver__c=caseRec.Legal_Approver__c;
                appReq.Approver_Group__c=System.Label.OB_Legal_Group;
                appReq.Approver_Group_User__c=caseRec.Legal_Approver__r.FirstName+' '+caseRec.Legal_Approver__r.LastName;
                appReq.OwnerId=caseRec.OwnerId;
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appRecList.add(appReq);
            }
            if(caseRec.Compliance_Code_of_Ethics_Group__c)
            {
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Approver_Group__c=System.Label.OB_Compliance_Code_of_Ethics_Group;
                appReq.Approver_Group_User__c=System.Label.OB_Compliance_Code_of_Ethics_Group;
                appReq.OwnerId=caseRec.OwnerId;
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appRecList.add(appReq);
            }
            if(caseRec.Investment_Compliance_Group__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Approver_Group__c=System.Label.OB_Investment_Compliance_Group;
                appReq.Approver_Group_User__c=System.Label.OB_Investment_Compliance_Group;
                appReq.OwnerId=caseRec.OwnerId;
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appRecList.add(appReq);
            } 
            if(caseRec.GIS_Transition_Management_Group__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Approver_Group__c=System.Label.OB_GIS_Transition_Management_Group;
                appReq.Approver_Group_User__c=System.Label.OB_GIS_Transition_Management_Group;
                appReq.OwnerId=caseRec.OwnerId;
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appRecList.add(appReq);
            }
            if(caseRec.Insurance_Group__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Approver_Group__c=System.Label.OB_Insurance_Group;
                appReq.Approver_Group_User__c=System.Label.OB_Insurance_Group;
                appReq.OwnerId=caseRec.OwnerId;
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appRecList.add(appReq);
            }
            if(caseRec.MFSI_Management_Group__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Approver_Group__c=System.Label.OB_MFSI_Management_Group;
                appReq.Approver_Group_User__c=System.Label.OB_MFSI_Management_Group;
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appReq.OwnerId=caseRec.OwnerId;
                appRecList.add(appReq);
            }
            if(caseRec.Performance_Information_Management_Group__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;
                appReq.Legal_Approver__c=caseRec.Legal_Approver__c;
                appReq.Approver_Group__c=System.Label.OB_Performance_Information_Management_Group;
                appReq.Approver_Group_User__c=System.Label.OB_Performance_Information_Management_Group;
                appReq.OwnerId=caseRec.OwnerId;  
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appRecList.add(appReq);
            }
            if(caseRec.Reporting__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;              
                appReq.Approver_Group__c=System.Label.OB_Reporting;
                appReq.Approver_Group_User__c=System.Label.OB_Reporting;
                appReq.OwnerId=caseRec.OwnerId;
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appRecList.add(appReq);
            }
            if(caseRec.Trading_Equity_Group__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;              
                appReq.Approver_Group__c=System.Label.OB_Trading_Equity_Group;
                appReq.Approver_Group_User__c=System.Label.OB_Trading_Equity_Group;
                appReq.OwnerId=caseRec.OwnerId;
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appRecList.add(appReq);
            }
            if(caseRec.Trading_Fixed_Income_Group__c){
                Approval_Request__c appReq =new Approval_Request__c();
                appReq.Onboarding_Case__c=caseRec.Id;
                appReq.RecordTypeId=recordTypeId;              
                appReq.Approver_Group__c=System.Label.OB_Trading_Fixed_Income_Group;
                appReq.Approver_Group_User__c=System.Label.OB_Trading_Fixed_Income_Group;
                appReq.OwnerId=caseRec.OwnerId;
                appReq.Due_Date__C=caseRec.Funding_Date__c;
                appRecList.add(appReq);
            }
        } catch(Exception exe) {
            System.debug('Exception occured:'+exe.getMessage()+exe.getLineNumber());
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