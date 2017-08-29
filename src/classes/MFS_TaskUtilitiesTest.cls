@isTest(seeAllData = false)
public class MFS_TaskUtilitiesTest {
    @testSetup
    static void setup(){
        List<Application_Settings__c> appSettingsList = MFS_TestDataUtility.getappSettingsList();
        insert appSettingsList;
        Account acc = MFS_TestDataUtility.createAccount();
        acc.MDM_ID__c = 'TSKTRIG5555';
        insert acc; 
        Contact cont1 = MFS_TestDataUtility.createContact(acc.Id);
        insert cont1;
        Opportunity opp = MFS_TestDataUtility.createOpportunity(acc.Id);
        opp.Saleslogix_ID__c = 'ZZXX-SLXTEST#567';
        insert opp;
        Opportunity opp1 = MFS_TestDataUtility.createOpportunity(acc.Id);
        opp1.Saleslogix_ID__c = 'ZZYY-SLXTEST#567';
        insert opp1;
        Task tsk = MFS_TestDataUtility.createTask(acc.Id);
        tsk.WhatId = opp.Id;
        insert tsk;
    }
    static testmethod void LastActivityDate(){
        Test.startTest();
        Account acc = [Select Id from Account where MDM_ID__c = 'TSKTRIG5555'];
        Opportunity oppRec = [select Id, Last_Activity_Date__c from Opportunity where Saleslogix_ID__c = 'ZZXX-SLXTEST#567' LIMIT 1]; 
        Opportunity oppRec1 = [select Id, Last_Activity_Date__c from Opportunity where Saleslogix_ID__c = 'ZZYY-SLXTEST#567' LIMIT 1]; 
        System.assertEquals(oppRec.Last_Activity_Date__c, System.Today());
        Task tsk = [select id,WhatId from Task where whatId =: oppRec.Id ];
        tsk.WhatId= oppRec1.Id;
        update tsk;
        //System.assertEquals(oppRec1.Last_Activity_Date__c, System.Today());
        
        //Task Trigger Disabled Test
        Application_Settings__c appSetting = [Select Name, Value__c from Application_Settings__c where Name = 'EnableTaskTrigger' ];
        appSetting.Value__c = 'No';
        update appSetting;        
        Task tsk1 = MFS_TestDataUtility.createTask(acc.Id);
        tsk1.WhatId = oppRec.Id;
        insert tsk1;
        Test.stopTest();
    }
    static testMethod void testAsIntegrationUser(){
        Test.startTest();
        Account acc = [Select Id from Account where MDM_ID__c = 'TSKTRIG5555'];
        Opportunity oppRec = [select Id, Last_Activity_Date__c from Opportunity where Saleslogix_ID__c = 'ZZXX-SLXTEST#567' LIMIT 1]; 
        Opportunity oppRec1 = [select Id, Last_Activity_Date__c from Opportunity where Saleslogix_ID__c = 'ZZYY-SLXTEST#567' LIMIT 1]; 
        User integrationUser = MFS_TestDataUtility.createUser('Integration Profile');
        insert integrationUser;
        System.assertNotEquals(null,integrationUser.Id);
        System.RunAs(integrationUser){
            Task tsk1 = MFS_TestDataUtility.createTask(acc.Id);
            tsk1.Saleslogix_ID__c = 'ZZ-ZZTSKTRIGSLX';
            tsk1.WhatId = oppRec.Id;
            insert tsk1;   
            Task tsk2 = MFS_TestDataUtility.createTask(acc.Id);            
            insert tsk2;
        }
        Test.stopTest();
    }
    
}