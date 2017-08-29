@isTest
private class MFS_OpportunityChevronExtensionTest {
    static testmethod void ChevronTest()
    {
        Account acct = new Account();
        acct = MFS_TestDataUtility.createAccount();
        Test.StartTest();
        insert acct;
        Opportunity opp = new Opportunity();
        opp = MFS_TestDataUtility.createOpportunity(acct.id);
        insert opp;
        Test.StopTest();
        MFS_OpportunityChevronExtension oce = new MFS_OpportunityChevronExtension(new ApexPages.StandardController(opp));
        oce.valsText = '--NONE---:Needs Analysis:Relationship Management/Nurturing:Semi-Finals:'; 
        oce.reload();
        oce.formCompletedStages();
        String cStage = oce.formInprogressStage(); 
        oce.formFutureStages();
        System.assertEquals(opp.StageName,cStage);
        
    }
    
}