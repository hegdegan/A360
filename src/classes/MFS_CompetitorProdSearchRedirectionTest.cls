@isTest
public class MFS_CompetitorProdSearchRedirectionTest {

    static testMethod void testRedirect()
    {
        Test.startTest();
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Opportunity opp = MFS_TestDataUtility.createOpportunity(acc.Id);
        insert opp;
        Test.stopTest();
        MFS_CompetitorProdSearchRedirection cpsr = new MFS_CompetitorProdSearchRedirection(new ApexPages.StandardController(opp));
        PageReference redirect = cpsr.redirect();
        //SONAR Fix
        system.assert(redirect != null );
        }
}