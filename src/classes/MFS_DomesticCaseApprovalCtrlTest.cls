@isTest
public class MFS_DomesticCaseApprovalCtrlTest {
    static testmethod void testDomesticAndAmendmentCase()
    {
        Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec; 
        Contact cont = MFS_TestDataUtility.createContact(accRec.id);
        insert cont;
        Case caseRec = MFS_TestDataUtility.createCase(cont);
        RecordType rt = [select id from RecordType where DeveloperName='Retail_Amendment' and SobjectType='Case' LIMIT 1];
        caseRec.recordtypeid= rt.Id;//Schema.SObjectType.Case.getRecordTypeInfosByName().get('Amendment (URF)').getRecordtypeId();
        caseRec.AccountId = accRec.Id;
        caseRec.Strategic_Alliance_Department_Heads__c = true;
        caseRec.Corporate_Finance_Billing_Approver__c = userinfo.getUserId();
        caseRec.GDS_Acknowledgement__c = userinfo.getUserId();
        caseRec.Compliance_AML_KYC_Approver__c = userinfo.getUserId();
        caseRec.CFO_Onboarding_Retail_Lookup__c = userinfo.getUserId();
        caseRec.Co_Heads_of_Global_Distribution__c = userinfo.getUserId();
        insert caseRec;
        Case caseRec1 = MFS_TestDataUtility.createCase(cont);
        caseRec1.recordtypeid= Schema.SObjectType.Case.getRecordTypeInfosByName().get(MFS_AllConstants.APPROVAL_DOMESTIC_RT).getRecordtypeId();
        caseRec1.Non_US_Questionnaire_Approval_Group__c = false;
        caseRec1.Compliance_AML_KYC__c = true;
        caseRec1.Corporate_Finance__c = true;
        caseRec1.GDS_Acknowledgement__c = userinfo.getUserId();
        caseRec1.Funds_Lawyer__c = userinfo.getUserId(); 
        caseRec1.FATCA_Lawyer__c = userinfo.getUserId();
        caseRec1.Final_Acknowledgement__c = userinfo.getUserId(); 
        caseRec1.Distribution_Lawyer__c = userinfo.getUserId();
        caseRec1.AML_Lawyer__c = userinfo.getUserId();
        insert caseRec1; 
        Test.setCurrentPage(Page.MFS_AmendmentCaseApprovalPage); 
        MFS_DomesticCaseApprovalCtrl caseCtrl=new MFS_DomesticCaseApprovalCtrl(new ApexPages.StandardController(caseRec));  
        PageReference pageRef=caseCtrl.submitForApproval();
        System.assert(pageRef!=null);
        Test.setCurrentPage(Page.MFS_DomesticCaseApprovalPage); 
        MFS_DomesticCaseApprovalCtrl caseCtrl1=new MFS_DomesticCaseApprovalCtrl(new ApexPages.StandardController(caseRec1));  
        PageReference pageRef1=caseCtrl1.submitForApproval();
        System.assert(pageRef1!=null); 
        PageReference pageRef2=caseCtrl.goBack();
        System.assert(pageRef2!=null);
        Test.stopTest();
    }
    
}