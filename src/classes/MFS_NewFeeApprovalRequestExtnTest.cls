@isTest(seeAllData = false)
public class MFS_NewFeeApprovalRequestExtnTest {
    
    static testMethod void testRedirect(){
        Test.startTest();
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Opportunity opp = MFS_TestDataUtility.createOpportunity(acc.Id);
        insert opp;
        Approval_Request__c appReq = new Approval_Request__c(Opportunity__c=opp.Id);
        List<Approval_Request__c> appReqList = new List<Approval_Request__c>();
        appReqList.add(appReq);
        Business_At_Risk__c bar = MFS_testDataUtility.createBAR(acc.id);
        insert bar;
        StoreFieldIds__c sfId = new StoreFieldIds__c(name='-1914A728127',Field_API_Name__c='Business_At_Risk__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='Approval_Request__c',Field_Label__c='Business_At_Risk__c');
        insert sfId;
        MFS_NewFeeApprovalRequestExtn hhExtn = new MFS_NewFeeApprovalRequestExtn(new ApexPages.StandardSetController(appReqList));   
        PageReference pr =  new PageReference('/'+bar.id);
        pr.getParameters().put('Id',bar.id); 
        test.setCurrentPage(pr);
        PageReference result = hhExtn.redirect();
        //SONAR Fix
        System.assertNotEquals(null,result.getUrl());
        Test.stopTest();
        
    }
    
}