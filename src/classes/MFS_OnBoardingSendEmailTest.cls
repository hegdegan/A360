@isTest(seeAllData = false)
public class MFS_OnBoardingSendEmailTest {
    static testmethod void testSendReminder(){
        Test.StartTest();
        
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        
        Case csRec = MFS_TestDataUtility.createCase(cont);
        csRec.recordtypeid= Schema.SObjectType.Case.getRecordTypeInfosByName().get('Onboarding').getRecordtypeId();
        csRec.AccountId = acc.Id;
        csRec.Type = 'Cash';
        csRec.Priority = 'Low';
        csRec.Status = 'Service';
        csRec.Due_Date__c = System.today();
        insert csRec;
        
        
        Approval_Request__c appReq = new Approval_Request__c(Approval_Status__c='Not Started',Onboarding_Case__c=csRec.Id);
        appReq.recordtypeid = Schema.SObjectType.Approval_Request__c.getRecordTypeInfosByName().get('Onboarding Approval Request').getRecordtypeId();
        appReq.Approver_Group__c = 'Investment Compliance Group';
        insert appReq;
       
        Test.stopTest();
       
        Approval.ProcessSubmitRequest appPrc=new Approval.ProcessSubmitRequest();
        appPrc.setObjectId(appReq.Id);
        Approval.ProcessResult appResults=Approval.process(appPrc);
        
        
        
        MFS_OnBoardingSendEmail cse = new MFS_OnBoardingSendEmail(new ApexPages.StandardController(appReq));
        cse.createEmailBody();
        Pagereference pg = cse.SendReminder();
        System.assert(pg != null);
       
        
    }

}