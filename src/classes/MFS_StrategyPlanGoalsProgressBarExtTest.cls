@isTest
public class MFS_StrategyPlanGoalsProgressBarExtTest {

    public static testmethod void progressBar()
    {
        Test.startTest();
        Account recAcc = MFS_TestDataUtility.createAccount();
        insert recAcc;
        Account recLimitAcc = [Select Id from Account where Id = : recAcc.Id];
        System.debug('test account' + recLimitAcc);
        Strategy_Plan__c recSp = MFS_TestDataUtility.createStrategyPlan(recLimitAcc.Id);
        recSp.Institutional__c = '12';
        recSp.Institutional_Portfolio_Manager_Goal_Cou__c = 5;  
        recSp.Consultant_Meeting_Goal__c = '3';
        recSp.Consultant_Meeting_Goal_Counter__c = 7;
        recSp.Portfolio_Manager_Meeting_Goal__c = '5';
        recSp.Portfolio_Manager_Meeting_Goal_Counter__c = 2;
        recSp.Sr_Executive_Meeting_Goal__c = '14';
        recSp.Sr_Executive_Meeting_Goal_Counter__c = 7;
        recSp.Client_Engagement_Goal__c = '25';
        recSp.Client_Engagement_Counter__c = 23; 
        recSp.Client_Review_Meeting_Goal__c = '10';
        recSp.Client_Review_Meeting_Goal_Counter__c =  1; 
        recSp.Analyst_Meeting_Goal__c = '16';
        recSp.Analyst_Meeting_Goal_Counter__c = 9; 
        recSp.Sr_Investment_Speaker_Goal__c = '9';
        recSp.Sr_Investment_Speaker_Goal_Counter__c = 8;
        insert recSp;
        Strategy_Plan__c recLimitSp = [Select id from Strategy_Plan__c where Id = : recSp.Id];
        MFS_SPlanGoalsProgressBarExtension spbe = new MFS_SPlanGoalsProgressBarExtension(new ApexPages.StandardController(recLimitSp));
        spbe.init();
        //SONAR Fix
        System.assert(spbe.lstOutput.size() > 0);
        
        //Exception Test
        recSp.Client_Review_Meeting_Goal__c = '0';
        recSp.Client_Review_Meeting_Goal_Counter__c =  0; 
        recSp.Analyst_Meeting_Goal__c = '0';
        recSp.Analyst_Meeting_Goal_Counter__c = 0; 
        recSp.Sr_Investment_Speaker_Goal__c = '0';
        recSp.Sr_Investment_Speaker_Goal_Counter__c = 0;
        update recSp;
        MFS_SPlanGoalsProgressBarExtension spbe1 = new MFS_SPlanGoalsProgressBarExtension(new ApexPages.StandardController(recLimitSp));
        spbe1.init();
        //SONAR Fix
        System.assert(spbe1.lstOutput.size() > 0);
        
        recSp.Client_Review_Meeting_Goal__c = '0';
        recSp.Client_Review_Meeting_Goal_Counter__c =  0; 
        recSp.Analyst_Meeting_Goal__c = '0';
        recSp.Analyst_Meeting_Goal_Counter__c = 0; 
        recSp.Sr_Investment_Speaker_Goal__c = '1asd';
        recSp.Sr_Investment_Speaker_Goal_Counter__c = 0;
        update recSp;
        MFS_SPlanGoalsProgressBarExtension spbe2 = new MFS_SPlanGoalsProgressBarExtension(new ApexPages.StandardController(recLimitSp));
        spbe2.init();
        //SONAR Fix
        System.assert(spbe2.lstOutput == null);
        Test.stopTest();
    }
}