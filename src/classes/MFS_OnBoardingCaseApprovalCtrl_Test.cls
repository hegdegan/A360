/***************************************************************************************************
Apex Class Name    : MFS_OnBoardingCaseApprovalCtrl_Test 
Version            : 1.0 
Created Date       : 06 SEPT 2016
Function           : Test class for MFS_OnBoardingCaseApprovalCtrl
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               06/09/2016              Original Version
***************************************************************************************************/
@isTest
public class MFS_OnBoardingCaseApprovalCtrl_Test {
    
    static testmethod void testOnBoardingCase()
    {
        Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec; 
        Contact cont = MFS_TestDataUtility.createContact(accRec.id);
        insert cont;
        User testUser=MFS_TestDataUtility.createUser('Standard User');
        insert testUser;
        Case caseRec = MFS_TestDataUtility.createCase(cont);
        caseRec.recordtypeid= Schema.SObjectType.Case.getRecordTypeInfosByName().get('Onboarding').getRecordtypeId();
        caseRec.AccountId = accRec.Id;
        caseRec.Type = 'Cash';
        caseRec.Priority = 'Low';
        caseRec.Status = 'Service';
        caseRec.Portfolio_Management_Approver1__c = userinfo.getUserId();
        caseRec.Client_Service_Approver__c = userinfo.getUserId();
        caseRec.Corporate_Finance_Billing_Approver__c = userinfo.getUserId();
        caseRec.Compliance_AML_KYC_Approver__c = userinfo.getUserId();
        caseRec.Legal_Approver__c = userinfo.getUserId();
        caseRec.Compliance_Code_of_Ethics_Group__c = true;
       // caseRec.GIS_Risk_Group__c = true;
        caseRec.GIS_Transition_Management_Group__c = true;
        caseRec.Insurance_Group__c = true;
        caseRec.MFSI_Management_Group__c = true;
        caseRec.Performance_Information_Management_Group__c = true;
       // caseRec.Portfolio_Compliance_Back_End_Group__c = true;
        caseRec.Investment_Compliance_Group__c = true;
        caseRec.Reporting__c = true;
        caseRec.Trading_Equity_Group__c = true;
        caseRec.Trading_Fixed_Income_Group__c = true;
        caseRec.Number_of_PM_Approvals_Required__c = '3';
        caseRec.Due_Date__c = System.today();
        insert caseRec;
        Test.setCurrentPage(Page.MFS_OnBoardingCaseApprovalPage); 
        MFS_OnBoardingCaseApprovalCtrl caseCtrl=new MFS_OnBoardingCaseApprovalCtrl(new ApexPages.StandardController(caseRec));
        PageReference pageRef=caseCtrl.submitForApproval();
        System.assert(pageRef!=null);
        caseRec=[Select id,Approval_Status__c from Case where id=:caseRec.Id];
        PageReference pageRef1=caseCtrl.goBack();
        System.assert(pageRef1!=null);
        Test.stopTest();
        
    }
    
}