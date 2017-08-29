@isTest(seeAllData=false)
public class MFS_OpportunityComponentControllerTest {
    static testMethod void testOpportunitiesConsole()
    {
        Test.startTest();
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Opportunity opp = MFS_TestDataUtility.createOpportunity(acc.Id);
        insert opp;
        //Call Account related methods
        MFS_OpportunityComponentController cntrl = new MFS_OpportunityComponentController(new ApexPages.StandardController(acc));
        List<Opportunity> oppList = cntrl.getOpportunities();
        System.assertEquals(oppList.size(), 1);
        Integer count = cntrl.getOppCount();
        System.assertEquals(count, 1);
        
        Test.StopTest();
    }
}