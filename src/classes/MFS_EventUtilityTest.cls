@isTest(seeAllData = false)
public class MFS_EventUtilityTest {
    @testSetup
    static void setup(){
        List<Application_Settings__c> appSettingsList = MFS_TestDataUtility.getappSettingsList();
        insert appSettingsList;
        Account acc = MFS_TestDataUtility.createAccount();
        acc.MDM_ID__c = 'EVETRIG555665';
        insert acc; 
        Contact cont1 = MFS_TestDataUtility.createContact(acc.Id);
        cont1.MDM_ID__c = 'EVETRIG5556CON1';
        insert cont1;
        Contact cont2 = MFS_TestDataUtility.createContact(acc.Id);
        cont2.MDM_ID__c = 'EVETRIG5556CON2';
        insert cont2;
        Opportunity opp = MFS_TestDataUtility.createOpportunity(acc.Id);
        opp.Saleslogix_ID__c = 'ZZXX-SLXTEST#567';
        insert opp;
        Opportunity opp1 = MFS_TestDataUtility.createOpportunity(acc.Id);
        opp1.Saleslogix_ID__c = 'ZZYY-SLXTEST#567';
        insert opp1;
        Event evnt = MFS_TestDataUtility.createEventWithContact(cont1.Id);
        insert evnt;
        Strategy_Plan__c sPlan = MFS_TestDataUtility.createStrategyPlan(acc.Id);
        insert sPlan;
        Activity_Detail__c actDetail = MFS_TestDataUtility.createCallNote(acc.Id);
        insert actDetail;
        Event evntWIthAD = MFS_TestDataUtility.createEventWithContact(cont2.Id);
        evntWIthAD.Activity_Detail__c = actDetail.Id;
        insert evntWIthAD;
        User userRec=MFS_TestDataUtility.createUser('Standard User');
        insert userRec;
        Event_Request__c eventRequest=MFS_TestDataUtility.createEventReq(userRec.Id);
        eventRequest.Call_Note__c = actDetail.Id;
        eventRequest.Overall_Approval_Status__c = 'Confirmed';
        insert eventRequest; 
    }
    static testmethod void PopulateRelatedIdTest(){
        Test.StartTest();
        Account acc = [Select Id from Account where MDM_ID__c = 'EVETRIG555665' LIMIT 1];
        Contact cont1 = [Select Id,AccountId from Contact where MDM_ID__c = 'EVETRIG5556CON1' LIMIT 1];
        Contact cont2 = [Select Id,AccountId from Contact where MDM_ID__c = 'EVETRIG5556CON2' LIMIT 1];
        Event evnt = [Select Id, WhoId, WhatId from Event where WhoId =: cont1.Id LIMIT 1];
        System.assertEquals(cont1.AccountId, evnt.WhatId); 
        evnt.WhoId = cont2.Id;
        MFS_Utilities.runReset();
        update evnt;
        Event evValue2 = [select Id, WhoId, WhatId from Event where Id =: evnt.Id];
        System.assertEquals(cont2.AccountId, evValue2.WhatId);        
        evnt.Type = 'Client Engagement Meeting';
        evnt.WhatId = acc.Id;
        MFS_Utilities.runReset();
        update evnt;        
        Strategy_Plan__c sPlanRecord = [Select Institutional_Portfolio_Manager_Goal_Cou__c, Sr_Investment_Speaker_Goal_Counter__c,
                                        Portfolio_Manager_Meeting_Goal_Counter__c, Consultant_Meeting_Goal_Counter__c, 
                                        Client_Review_Meeting_Goal_Counter__c, Client_Engagement_Counter__c, Analyst_Meeting_Goal_Counter__c,
                                        Sr_Executive_Meeting_Goal_Counter__c, Strategy_Plan_Year__c 
                                        from Strategy_Plan__c where Organization__c =: acc.Id];
        
        if(evnt.Type.equals('Client Review Meetings')){
            if(sPlanRecord.Client_Review_Meeting_Goal_Counter__c == null)
                System.assertEquals(1,sPlanRecord.Client_Review_Meeting_Goal_Counter__c);
        }
        if(evnt.Type.equals('Client Engagement Meeting')){
            if(sPlanRecord.Client_Engagement_Counter__c == null)
                System.assertEquals(1,sPlanRecord.Client_Engagement_Counter__c); 
        }
        evnt.Type = 'Institutional Portfolio Manager Meeting';
        evnt.WhatId = acc.Id;
        MFS_Utilities.runReset();
        update evnt;
        Test.stopTest();
    }
    static testmethod void LastActivityDate(){
        Test.startTest();
        Account acc = [Select Id from Account where MDM_ID__c = 'EVETRIG555665' LIMIT 1];
        Contact cont1 = [Select Id,AccountId from Contact where MDM_ID__c = 'EVETRIG5556CON1' LIMIT 1];
        Opportunity opp = [Select Id,AccountId,Last_Activity_Date__c from Opportunity where AccountId =: acc.Id LIMIT 1];
        Opportunity opp1 = [Select Id,AccountId,Last_Activity_Date__c from Opportunity where AccountId =: acc.Id LIMIT 1];
        Event evnt = [Select Id, WhoId, WhatId from Event where WhoId =: cont1.Id LIMIT 1];
        evnt.WhatId= opp1.Id;
        MFS_Utilities.runReset();
        update evnt;
        Opportunity oppRec1 = [select Last_Activity_Date__c from Opportunity where id =: opp1.Id];
        System.assertEquals(oppRec1.Last_Activity_Date__c, System.Today());
        Test.stopTest();
    }
    Static testmethod void emailnotification(){
        Test.startTest();
        Account acc = [Select Id from Account where MDM_ID__c = 'EVETRIG555665' LIMIT 1];
        Contact cont2 = [Select Id,AccountId from Contact where MDM_ID__c = 'EVETRIG5556CON2' LIMIT 1];        
        Activity_Detail__c actDetail = [Select Id, Organization__c from Activity_Detail__c where Organization__c =: acc.Id];
        Event evntWIthAD = [Select Id, WhoId, WhatId from Event where WhoId =: cont2.Id and Activity_Detail__c =: actDetail.Id LIMIT 1];               
        evntWIthAD.StartDateTime = DateTime.newInstance(2016,11,27,08,00,00);
        evntWIthAD.EndDateTime = DateTime.newInstance(2016,11,27,08,00,00);
        MFS_Utilities.runReset();
        update evntWIthAD;
        Event_Request__c eventRequest = [Select Id from Event_Request__c where Call_Note__c =: actDetail.Id];
        Event_Request__c evValue1 = [select Id,Overall_Approval_Status__c  from Event_Request__c where Id =: eventRequest.Id];
        System.assertEquals('Pending', evValue1.Overall_Approval_Status__c);
        //Disable Trigger Test
        Application_Settings__c appSetting = [Select Name, Value__c from Application_Settings__c where Name = 'EnableEventTrigger' ];
        appSetting.Value__c = 'No';
        update appSetting;
        update evntWIthAD;
        Test.stopTest();
    }
    
    static testMethod void testAsIntegrationUser(){
        Test.startTest();
        Account acc = [Select Id from Account where MDM_ID__c = 'EVETRIG555665'];
        Opportunity oppRec = [select Id, Last_Activity_Date__c from Opportunity where Saleslogix_ID__c = 'ZZXX-SLXTEST#567' LIMIT 1]; 
        Opportunity oppRec1 = [select Id, Last_Activity_Date__c from Opportunity where Saleslogix_ID__c = 'ZZYY-SLXTEST#567' LIMIT 1];
        Contact cont2 = [Select Id,AccountId from Contact where MDM_ID__c = 'EVETRIG5556CON2' LIMIT 1]; 
        Contact cont1 = [Select Id,AccountId from Contact where MDM_ID__c = 'EVETRIG5556CON1' LIMIT 1];
        User integrationUser = MFS_TestDataUtility.createUser(System.Label.Integration_Profile_Name);
        integrationUser.UserName = 'unique_test_EventTrigger@mfstest.com';
        insert integrationUser;
        //SONAR Fix
        system.assertNotEquals(null,integrationUser.Id );
        System.RunAs(integrationUser){
            Event ev1 = MFS_TestDataUtility.createEventWithContact(cont2.Id);
            ev1.Saleslogix_ID__c = 'ZZ-ZZEVTTRIGSLX';
            ev1.WhatId = oppRec.Id;
            insert ev1;   
            Event ev2 = MFS_TestDataUtility.createEventWithContact(cont2.Id);       
            insert ev2;
            MFS_Utilities.runReset();
            Event evnt = [Select Id, WhoId, WhatId from Event where Id =: ev2.Id];
            evnt.WhatId = null;
            evnt.WhoId = cont1.Id;
            update evnt;
            
        }
        Test.stopTest();
    }
}