@isTest(seeAllData = false)
public class MFS_ActivityDetailRedirectControllerTest {
    private static FINAL String RET_EVENT =  'Enhanced Event (Retail)';
    private static FINAL String RET_TASK = 'Log a Call (Retail)';
    static testMethod void testRedirect()
    {
        //Create test data
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        System.assert(acc != null);
        Activity_Detail__c cNote = MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote; 
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        Event evnt = MFS_TestDataUtility.createEventWithContact(cont.Id); 
        evnt.Event_Start_Date__c = system.Today();
        evnt.Event_End_Date__c = system.Today();
        evnt.Activity_Detail__c= cNote.Id;
        evnt.WhatId = acc.Id;
        evnt.WhoId = cont.Id;
        evnt.Call_Note_Parent_Task_Event__c = true;
        evnt.recordtypeid= Schema.SObjectType.Event.getRecordTypeInfosByName().get(RET_EVENT).getRecordtypeId();
        evnt.Activity_Type_for_Instit__c = 'MFS Event;Semi-Finals;';
        insert evnt;
        
        MFS_ActivityDetailRedirectController redCtrl = new MFS_ActivityDetailRedirectController(new ApexPages.StandardController(cNote));
        Activity_Detail__c cNote2 = MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote2;
        Task tsk = MFS_TestDataUtility.createTask(acc.Id);
        tsk.Activity_Detail__c =cNote2.Id;
        tsk.WhatId = acc.Id;
        tsk.WhoId = cont.Id;
        tsk.Call_Note_Parent_Task_Event__c = false;
        tsk.recordtypeid= Schema.SObjectType.Task.getRecordTypeInfosByName().get(RET_TASK).getRecordtypeId();
        insert tsk;
        redCtrl = new MFS_ActivityDetailRedirectController(new ApexPages.StandardController(cNote2));
        redCtrl.redirect();
        //Record without Id
        Activity_Detail__c cNote3 = MFS_TestDataUtility.createCallNote(acc.Id);
        redCtrl = new MFS_ActivityDetailRedirectController(new ApexPages.StandardController(cNote3));
        redCtrl.redirect();
    }
    
    @testSetup
    public static void dataSetup(){
        List<Application_Settings__c> customSettings = MFS_TestDataUtility.getappSettingsList();
        insert customSettings;
    }
}