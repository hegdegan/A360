@isTest(seeAllData = false)
private class MFS_SendTFTEventToOutlookCtrlTest{
    static testmethod void MFS_SendTFTEventToOutlookCtrlTest(){
        Test.startTest();
        Account acc1 = MFS_TestDataUtility.createAccount();
        insert acc1;
        System.assert(acc1 != null);
        Contact cont1 = MFS_TestDataUtility.createContact(acc1.Id);
        insert cont1;
        Activity_Detail__c actDetail = MFS_TestDataUtility.createCallNote(acc1.Id);
        insert actDetail;
        Event evnt = MFS_TestDataUtility.createEventWithContact(cont1.Id);
        evnt.Activity_Detail__c = actDetail.Id;
        insert evnt;
        Event_Request__c eventReq = new Event_Request__c();
        eventReq.Call_Note__c = actDetail.Id;
        Insert eventReq;
        System.assert(eventReq != null);
                   
        PageReference pref = Page.MFS_SendTFTEventToOutlook;
        test.setCurrentPage(pref);
        MFS_SendTFTEventToOutlookCtrl ctrl = new MFS_SendTFTEventToOutlookCtrl(new ApexPages.StandardController(eventReq));
        eventReq.Translator_Required__c = true;
        update eventReq;
        ctrl = new MFS_SendTFTEventToOutlookCtrl(new ApexPages.StandardController(eventReq));
        Test.stopTest();
    }
}