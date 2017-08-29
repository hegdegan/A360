@isTest(seeAllData=false)
public class MFS_CaseChevronExtensionTest {
 	static testmethod void ChevronTest()
    {
        Account acct = new Account();
        acct = MFS_TestDataUtility.createAccount();
        Test.StartTest();
        insert acct;
        Contact cont = MFS_TestDataUtility.createContact(acct.id);
        insert cont;
        Case cse = MFS_TestDataUtility.createCase(cont);
        insert cse;
        Test.StopTest();
        MFS_CaseChevronExtension oce = new MFS_CaseChevronExtension(new ApexPages.StandardController(cse));
        oce.valsText = '--NONE---:Closed'; 
        oce.reload();
        oce.getCompletedStages();
        String cStage = oce.getInprogressStage();
        //SONAR Fix
        System.assertEquals(null,cStage);
        oce.getFutureStages();
    }
}