@isTest
public class MFS_RecurringCaseBatchTest {

    static testmethod void recurringBatchTest(){
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        List<case> caseRec = MFS_TestDataUtility.createBulkCase(cont,5,'Monthly');
        insert caseRec;
        List<case> caseRec1 = MFS_TestDataUtility.createBulkCase(cont,5,'Weekly');
        insert caseRec1;
        List<case> caseRecList = new List<case>();
        List<Attachment> attchList = new List<Attachment>();
        for(Case cs : caseRec1)
        {
            cs.Total_No_of_Occurrences__c = 1;
            caseRecList.add(cs);
            Attachment at = new Attachment();
            at.Name = 'Test Attachment';
            Blob bodyBlob = Blob.valueOf('Attachment Body');
            at.body = bodyBlob;
            at.parentId = cs.Id;
            attchList.add(at);
        }
        update caseRecList;
        insert attchList;
        Test.StartTest();
        MFS_RecurringCaseBatch recur = new MFS_RecurringCaseBatch();
        recur.query = 'Select id,AccountId,CaseNumber,ContactId,Origin,Type,Sub_Type__c,Priority,OwnerId,Repeats__c,Repeats_On__c,Ends__c,Total_No_of_Occurrences__c,Occurrence_Number__c,Start_Date__c,Repeat_On__c,Repeat_On_Weekly__c,Next_Case_CreateDate__c,Ends_On__c,Due_In__c,Excludes_Weekends__c from case where Recurring_Case__c =true Limit 5';
        Id batchProcessId = Database.executeBatch(recur);
        MFS_RecurringCaseBatchSchedule sh = new MFS_RecurringCaseBatchSchedule();
        string sch = '0 0 23 * * ?';
        system.schedule('Test Recurring Schedule',sch,sh);
        Test.stopTest();
        System.assertEquals(database.countquery('select count() from case where Recurring_Case__c =true'), 10);
    }
    
}