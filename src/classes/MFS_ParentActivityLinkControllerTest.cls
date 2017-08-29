@isTest(seeAllData=false)
public class MFS_ParentActivityLinkControllerTest {
    private static FINAL String RET_TASK = 'Log a Call (Retail)';
    static testmethod void activityLinkTest(){
        //Create test data
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        System.assert(acc != null);
        Activity_Detail__c cNote = MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote;
        Activity_Detail__c cNote2 = MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote2;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        Task tsk = MFS_TestDataUtility.createTask(acc.Id);
        tsk.Activity_Detail__c =cNote.Id;
        tsk.WhatId = acc.Id;
        tsk.WhoId = cont.Id;
        tsk.Call_Note_Parent_Task_Event__c = false;
        tsk.recordtypeid= Schema.SObjectType.Task.getRecordTypeInfosByName().get(RET_TASK).getRecordtypeId();
        tsk.Parent_Activity_Detail_Id__c = cNote2.Id;
        insert tsk;
        
        PageReference pg = Page.MFS_ParentActivityLink;
        Test.setCurrentPage(pg);
        MFS_ParentActivityLinkController ctrl = new MFS_ParentActivityLinkController(new ApexPages.StandardController(tsk));
    }
    
    @testSetup
    public static void dataSetup(){
        List<Application_Settings__c> customSettings = MFS_TestDataUtility.getappSettingsList();
        insert customSettings;
    }
}