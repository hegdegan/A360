/***************************************************************************************************
Apex Class Name    : OrganizationUtilitiesTest
Version            : 1.0 
Created Date       : 12 MAY 2016
Function           : Test class for Account Triggers, Account Handler class and Account utility class.
Pages Utilized     : 
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              12/05/2016              Original Version
***************************************************************************************************/
@isTest(seeAllData=false)
private class MFS_OrganizationUtilitiesTest {
    //test for Account owner while creating a record
    static testmethod void ChangeAccountOwnerOnInsert(){
        List<Application_Settings__c> appSettingList = MFS_TestDataUtility.getappSettingsList();
        insert appSettingList;
        Profile integrationProfile = [Select Id from Profile where Name = 'System Administrator'];
        User integrationUser = [Select Id from User where Id =: System.Label.MFS_Owner_User_Id Limit 1];
        Profile salesUserProfile = [Select Id from Profile where Name = 'Global Institutional Sales'];
        User demo = MFS_TestDataUtility.createUser('Global Institutional Sales');
        insert demo;
        User salesUser = [Select Id from User where Id =: demo.Id];  
        List<Application_Settings__c> appSetting = new List<Application_Settings__c>();
        appSetting = MFS_TestDataUtility.CreateTestApplicationSettings(String.valueOf(integrationUser.Id),'Edit', 'Read', 'Edit');
        insert appSetting;
        Test.StartTest();
        Account testAccount;
        system.runAs(salesUser){
           testAccount = MFS_TestDataUtility.createAccount();
           testAccount.ShippingCountryCode = 'IN';
            testAccount.Type__c = 'Client/Prospect';
           insert testAccount;  
        }
       List<AccountTeamMember> ATM = new List<AccountTeamMember>([select Account.Id, Account.OwnerId, UserId, Id, TeamMemberRole from AccountTeamMember where UserId =: integrationUser.Id and AccountId =: testAccount.Id ]);
       List<AccountShare> aShare = new List<AccountShare>([select Id, UserorGroupId, AccountId, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel from AccountShare where UserorGroupId =: salesUser.Id and AccountId =: testAccount.Id]);
        if(!ATM.isEmpty()){
            System.assertEquals(salesUser.Id, ATM.get(0).UserId);
            //System.assertEquals();
        } 
        Test.StopTest();
    } 
    
    //Test for Organization address change functionality
    static testMethod void changeOrgAddressTest()
    {
        List<Application_Settings__c> appSettingsList = MFS_TestDataUtility.getappSettingsList();
        insert appSettingsList;
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        Contact cont1 = MFS_TestDataUtility.createContact(acc.id);
        insert cont1;
        acc.ShippingCity = 'newtestCity';
        update acc;
        
        List<Contact> conList = [select id, MailingCity from Contact where AccountId = :acc.Id];
		for(Contact con : conList) 
		{
            system.assertEquals(acc.ShippingCity, con.MailingCity);
        }
    }
    
    //test for updating related contact,opportunity and task records when Account status changed to Inactive
    static testMethod void UpdateWhenOrganizationBecomeInactiveTest(){
         Account acc = MFS_TestDataUtility.createAccount();
         insert acc;
         Test.startTest();
         List<Account> bulkAcnts = MFS_TestDataUtility.createBulkAccounts(5);
         insert bulkAcnts;
         List<Contact> bulkConts = MFS_TestDataUtility.createBulkContacts(bulkAcnts,7);
         insert bulkconts;
         Test.stopTest();
         Opportunity opp = MFS_TestDataUtility.createOpportunity(acc.id);
         insert opp;
         Task tsk = MFS_TestDataUtility.createTask(acc.id);
         insert tsk;
         acc.Entity_Status__c = 'Inactive';
         update acc;
         List<Account> updAccount = new List<Account>();
         for(Account acStatus : bulkAcnts){
            acStatus.Entity_Status__c = 'Inactive';
             updAccount.add(acStatus);  
         }
         update updAccount;
         List<Contact> conRecord = new List<Contact>([select Status__c from contact]);
         for(Contact con : conRecord){
            System.assertEquals('Inactive', con.Status__c); 
         }
       
        Task tskRecord = [select Status from Task where Id =: tsk.Id];
        if(tskRecord.Status.equals('Open')){
                            system.assertEquals('Completed',tskRecord.Status); 
                        }
         
    }
}