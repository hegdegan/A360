@isTest(seeAllData=false)
public class MFS_ActivitiesConsoleControllerTest {
    static testMethod void testActivitiesConsole()
    {
        Test.startTest();
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Contact con = MFS_TestDataUtility.createContact(acc.Id);
        insert con;
        //Call Account related methods
        MFS_ActivitiesConsoleController cntrl = new MFS_ActivitiesConsoleController(new ApexPages.StandardController(acc));
        cntrl.getActivityHistories();
        List<OpenActivity> openActList = new List<OpenActivity> ();
        openActList = cntrl.getOpenActivities();
        //SONAR Fix
        System.assert(openActList.size() == 0);
        //Call Contact Related methods
        MFS_ActivitiesConsoleController conCntrl = new MFS_ActivitiesConsoleController(new ApexPages.StandardController(con));
        conCntrl.getContactActivityHistories();
        conCntrl.getContactOpenActivities();
        Test.StopTest();
    }
}