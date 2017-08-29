@isTest(seeAllData = false)
public class MFS_CampaignBatchTest {
    @testSetup
    static void setup(){
        RecordType accRetailRT=[select id, name from RecordType where SObjectType='Account' AND Name = 'Global Retail' LIMIT 1];
        RecordType accInstRT=[select id, name from RecordType where SObjectType='Account' AND Name = 'Global Institutional Client' LIMIT 1];
        RecordType accConsRT=[select id, name from RecordType where SObjectType='Account' AND Name = 'Investment Consultant' LIMIT 1];
        //Custom settings Entries
        List<Application_Settings__c> appSettingsList = MFS_TestDataUtility.getappSettingsList();
        insert appSettingsList;
        List<Account> accList = New List<Account>();
        //Insert Retail Org
        Account accRet = MFS_TestDataUtility.createAccount();
        accRet.RecordtypeId = accRetailRT.Id;
        accRet.MDM_ID__c = 'RET12345678';
        accList.add(accRet);
        //Insert Inst Org
        Account accInst = MFS_TestDataUtility.createAccount();
        accInst.RecordtypeId = accInstRT.Id;
        accInst.MDM_ID__c = 'INST1234567';
        accList.add(accInst);
        //Insert Consultant Org
        Account accCons = MFS_TestDataUtility.createAccount();
        accCons.RecordtypeId = accConsRT.Id;
        accCons.MDM_ID__c = 'CONS1234567';
        accList.add(accCons);
        insert accList;
    }
    static testMethod void testCampaignBatchForContactSyncToLinkPoint_RetailUser(){
        Test.startTest();
        User retailUser = MFS_TestDataUtility.createUser('Global Retail External');
        retailUser.UserName = 'campaign_test_Ret_User_OrgMFS@mfstest.com';
        retailUser.DefaultCurrencyIsoCode = 'USD';
        insert retailUser;
        List<Account> allAccounts = new List<Account>([select Id, Name from Account where MDM_ID__c in ('RET12345678', 'INST1234567', 'CONS1234567')]);
        List<Contact> contactList = MFS_TestDataUtility.createBulkContacts(allAccounts,10);
        insert contactList;
        List<Coverage_Team__c> covTeamList = new List<Coverage_Team__c>();
        Coverage_Team__c coverageTeam;
        Integer i =0;
        for(Contact con : contactList){            
            coverageTeam = new Coverage_Team__c(Contact__c = con.Id, Coverage_Owner__c = retailUser.Id, Organization__c = con.AccountId);              
            covTeamList.add(coverageTeam);
        }
        if(covTeamList.size() > 0){
            insert covTeamList;
        }
        MFS_MyCampaignBatch campBatch = new MFS_MyCampaignBatch();
        Database.executeBatch(campBatch, 1);
        Test.stopTest();
    }
    
    static testMethod void testCampaignBatchForContactSyncToLinkPoint_InstitutionalUser(){
        Test.startTest();
        List<user> userList = new List<User>();
        User institutionalUser = MFS_TestDataUtility.createUser('Global Institutional Sales');
        institutionalUser.UserName = 'campaign_test_Inst_User_OrgMFS@mfstest.com';
        institutionalUser.DefaultCurrencyIsoCode = 'USD';
        userList.add(institutionalUser);
        insert userList;
        List<AccountTeamMember> accTeamList = new List<AccountTeamMember>();
        Account accInstitutional = [Select Id, Name from Account where MDM_ID__c =: 'INST1234567'];
        List<User> instUserList = new List<User> ([select Id, Name from User where userName =: ('campaign_test_Inst_User_OrgMFS@mfstest.com' )]);
        for(User user : instUserList){
            AccountTeamMember acTeamMem = new AccountTeamMember(userId = user.Id, accountId = accInstitutional.id);
            accTeamList.add(acTeamMem);
        }
        if(accTeamList.size() > 0){
            insert accTeamList;
        }
        MFS_MyCampaignBatch campBatch = new MFS_MyCampaignBatch();
        Database.executeBatch(campBatch, 1);
        Test.stopTest();
    }
    
    static testMethod void testCampaignBatchForContactSyncToLinkPoint_SysAdmin(){
        Test.startTest();
        List<user> userList = new List<User>();
        User sysAdminUser = MFS_TestDataUtility.createUser('X_System Administrator');
        sysAdminUser.UserName = 'campaign_test_SysAdmin_User_OrgMFS@mfstest.com';
        sysAdminUser.DefaultCurrencyIsoCode = 'USD';
        userList.add(sysAdminUser);
        insert userList;
        List<AccountTeamMember> accTeamList = new List<AccountTeamMember>();
        Account accInstitutional = [Select Id, Name from Account where MDM_ID__c =: 'INST1234567'];
        List<User> instUserList = new List<User> ([select Id, Name from User where userName =: ('campaign_test_SysAdmin_User_OrgMFS@mfstest.com' )]);
        for(User user : instUserList){
            AccountTeamMember acTeamMem = new AccountTeamMember(userId = user.Id, accountId = accInstitutional.id);
            accTeamList.add(acTeamMem);
        }
        if(accTeamList.size() > 0){
            insert accTeamList;
        }
        MFS_MyCampaignBatch campBatch = new MFS_MyCampaignBatch();
        Database.executeBatch(campBatch, 1);
        Test.stopTest();
    }
    
    static testMethod void testCampaignBatchForContactSyncToLinkPoint_SysAdmin2(){
        Test.startTest();
        User retailUser = MFS_TestDataUtility.createUser('X_System Administrator');
        retailUser.UserName = 'campaign_test_SysAdmin2_OrgMFS@mfstest.com';
        retailUser.DefaultCurrencyIsoCode = 'USD';
        insert retailUser;
        List<Account> allAccounts = new List<Account>([select Id, Name from Account where MDM_ID__c in ('RET12345678', 'INST1234567', 'CONS1234567')]);
        List<Contact> contactList = MFS_TestDataUtility.createBulkContacts(allAccounts,10);
        insert contactList;
        List<Coverage_Team__c> covTeamList = new List<Coverage_Team__c>();
        Coverage_Team__c coverageTeam;
        Integer i =0;
        for(Contact con : contactList){            
            coverageTeam = new Coverage_Team__c(Contact__c = con.Id, Coverage_Owner__c = retailUser.Id, Organization__c = con.AccountId);              
            covTeamList.add(coverageTeam);
        }
        if(covTeamList.size() > 0){
            insert covTeamList;
        }
        MFS_MyCampaignBatch campBatch = new MFS_MyCampaignBatch();
        Database.executeBatch(campBatch, 1);
        Test.stopTest();
    }
    
}