@isTest
private class MFS_SendEventToOutlookCtrlTest{
    static testmethod void MFS_SendEventToOutlookCtrlTest(){
         Application_Settings__c appSetting= new Application_Settings__c();
        appSetting.Name='EnableDataLoad';
        appSetting.Value__c='Yes';
        insert appSetting;
         Application_Settings__c appSetting1= new Application_Settings__c();
        appSetting1.Name='IntegrationProfileId';
        appSetting1.Value__c=UserInfo.getProfileId();
        insert appSetting1;
       
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
        Event_Relation__c eventRel = new Event_Relation__c();
        eventRel.Speaker_Request__c = eventReq.Id;
        eventRel.Time_Slot_Start__c = DateTime.now();
        eventRel.Time_Slot_End__c = DateTime.now();
        Insert eventRel;
        Product2 prodRec=MFS_TestDataUtility.createProduct();
        insert prodRec;
        System.assert(prodRec != null);
        Event_Relation_Portfolio_Junction__c  junc = new Event_Relation_Portfolio_Junction__c(Portfolio__c=prodRec.Id,Event_Relation__c=eventRel.Id);
        insert junc;
        Test.startTest();           
        PageReference pref = Page.MFS_SendEventToOutlook;
        test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('eventId',eventRel.Id);
        MFS_SendEventToOutlookCtrl ctrl = new MFS_SendEventToOutlookCtrl();
        Test.stopTest();
    }
}