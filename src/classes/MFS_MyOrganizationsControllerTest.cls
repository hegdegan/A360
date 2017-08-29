@isTest(seeAllData=false)
public class MFS_MyOrganizationsControllerTest {
    static testMethod void myOrgsTest()
    {
        List<Account> accList = MFS_TestDataUtility.createBulkAccounts(10);
        insert accList;
        List<AccountTeamMember> atmList = MFS_TestDataUtility.createBulkATM(accList, 10, UserInfo.getUserId()) ;
        insert atmList;
        Test.startTest();
        //Set page for controller
        Test.setCurrentPageReference(new Pagereference('Page.MFS_MyOrganizationConsole'));
        MFS_MyOrganizationsController myOrgs = new MFS_MyOrganizationsController();
        
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(accList);
        myOrgs.size = 2;
        myOrgs.getOrgList();
        System.assertNotEquals(0, myOrgs.myOrgsList.size());
        myOrgs.getNextOrgs();
        myOrgs.getpreviousOrgs();
        myOrgs.refreshPageSize();
        Test.stopTest();
    }
}