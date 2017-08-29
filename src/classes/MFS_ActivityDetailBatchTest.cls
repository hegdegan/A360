@isTest
public class MFS_ActivityDetailBatchTest {
    static testmethod void activityBatchTest()
    {
        
        List<Account> accList = new List<Account>();
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        accList.add(acc);
        Account acc1 = MFS_TestDataUtility.createAccount();
        insert acc1;
        accList.add(acc1);
        User demo = MFS_TestDataUtility.createUser('System Administrator');
        insert demo;
        Activity_Detail__c actDetail = MFS_TestDataUtility.createCallNote(acc.Id);
        actDetail.Not_An_Orphan_Record__c = false;
        insert actDetail;
        DateTime yesterday = DateTime.Now().addDays(-1);
        Test.setCreatedDate(actDetail.Id,yesterday); 
        System.assert(actDetail != null);
        Task tsk = MFS_TestDataUtility.createTask(acc.Id);
        tsk.Activity_Detail__c = actDetail.Id;
        insert tsk;
        Task tsk1 = MFS_TestDataUtility.createTask(acc.Id);
        tsk1.Activity_Detail__c = actDetail.Id;
        insert tsk1;
        Test.startTest();
        List<Event> evntList = new List<Event>();
        List<Event> evnt = MFS_TestDataUtility.createBulkEvents(accList,10);
        insert evnt;
        for(Event event : evnt)
        {
            event.Activity_Detail__c = actDetail.Id;  
            evntList.add(event);
        }
        update evntList;
        List<Event_Request__c> evReqList = new List<Event_Request__c>();
        List<Event_Request__c> evReq = MFS_TestDataUtility.createBulkEventReq(demo.Id);
        insert evReq;
        for(Event_request__c er : evReq)
        {
            er.Call_Note__c = actDetail.Id;
            evReqList.add(er);
        }
        update evReqList;
        System.assert(evReqList != null);
        MFS_ActivityDetailBatch batch = new MFS_ActivityDetailBatch();
        batch.query ='Select id,CreatedDate from Activity_Detail__c where Not_An_Orphan_Record__c = false';
        Id batchProcessId = Database.executeBatch(batch);
        System.assert(batchProcessId != null);
        MFS_ActivityDetailBatchSchedule sh = new MFS_ActivityDetailBatchSchedule();
        string sch = '0 0 23 * * ?';
        system.schedule('Test Recurring Schedule',sch,sh);
        Test.stopTest();
        System.assertEquals(database.countquery('select count() from Activity_Detail__c where Not_An_Orphan_Record__c =false'), 0);
    }
    @testSetup
    public static void dataSetup(){
        List<Application_Settings__c> customSettings = MFS_TestDataUtility.getappSettingsList();
        insert customSettings;
    }
}