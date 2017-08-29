@isTest(seeAllData = false)
public class MFS_LinkedInTest {

    static testMethod void testLinkedinButton() {
        Test.startTest();
        Account account = MFS_TestDataUtility.createAccount();
        insert account;
        Contact con = MFS_TestDataUtility.createContact(account.Id);
        insert con;
        MFS_LinkedIn linkedInButton = new MFS_LinkedIn(new ApexPages.StandardController(con));
        pagereference pr = linkedInButton.redirect();
        //SONAR Fix
        system.assert(pr.getUrl() != null);
        Contact con1 = MFS_TestDataUtility.createContact(account.Id);
        con1.firstName= null;
        MFS_LinkedIn linkedInButton1 = new MFS_LinkedIn(new ApexPages.StandardController(con1));
        linkedInButton1.redirect();
        Test.stopTest();
    }
}