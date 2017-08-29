@isTest
private class MFS_StrategyPlanUtilitiesTest {
    static testmethod void populateGoalDetailsInStrategyPlanTest(){
        List<Account> accRec = new List<Account>();
        accRec = MFS_TestDataUtility.createBulkAccounts(3);
        Test.startTest();
        insert accRec;
        List<Goal__c> goalRec = new List<Goal__c>();
        goalRec = MFS_TestDataUtility.createBulkGoal(3);
        insert goalRec;
        List<Strategy_Plan__c> spRec = new List<Strategy_Plan__c>();
        spRec = MFS_TestDataUtility.createBulkSplan(accRec, 2);
        for(Strategy_Plan__c addRec : spRec)
        {
            for(Integer j=0; j<goalRec.size(); j++)
            {
                Goal__c gol = goalRec[j];
                for(Integer k=0; k<spRec.size(); k++)
                {
                    addRec.Goal__c = gol.Id; 
                }
            }
        }
        insert spRec;
        Test.stopTest();
        spRec = [select Client_Engagement_Goal__c,Institutional__c,Consultant_Meeting_Goal__c,Client_Review_Meeting_Goal__c,Portfolio_Manager_Meeting_Goal__c,Analyst_Meeting_Goal__c,Sr_Executive_Meeting_Goal__c,
                 Sr_Investment_Speaker_Goal__c from Strategy_Plan__c where id in : spRec];
        goalRec = [select Client_Engagement__c,Institutional_Portfolio_Manager__c,Consultant_Meetings__c,Client_Review_Meetings__c,Portfolio_Manager__c,Analyst_Meeting__c,
                   Sr_Executive_Meeting__c,Sr_Investment_Speaker_Client_Events__c from Goal__c where Id in : goalRec ];
        for(Strategy_Plan__c sp : spRec)
        {
            for(Goal__c go : goalRec)
            {
                 System.assertEquals(go.Client_Engagement__c,sp.Client_Engagement_Goal__c);
                 System.assertEquals(go.Institutional_Portfolio_Manager__c,sp.Institutional__c);
                 System.assertEquals(go.Consultant_Meetings__c,sp.Consultant_Meeting_Goal__c);
                 System.assertEquals(go.Client_Review_Meetings__c,sp.Client_Review_Meeting_Goal__c);
                 System.assertEquals(go.Portfolio_Manager__c,sp.Portfolio_Manager_Meeting_Goal__c);
                 System.assertEquals(go.Analyst_Meeting__c,sp.Analyst_Meeting_Goal__c);
                 System.assertEquals(go.Sr_Executive_Meeting__c,sp.Sr_Executive_Meeting_Goal__c);
                 System.assertEquals(go.Sr_Investment_Speaker_Client_Events__c,sp.Sr_Investment_Speaker_Goal__c);
            }
        }
       
        
    }
}