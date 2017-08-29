@isTest(seeAllData = false)
public class MFS_UserTriggerUtilityTest {
    
    static testMethod void testCampaignCreationOnUserInsert(){
        //Custom settings Entries
        List<Application_Settings__c> appSettingsList = MFS_TestDataUtility.getappSettingsList();
        insert appSettingsList;
        User retailUser = MFS_TestDataUtility.createUser('Global Retail External');
        retailUser.UserName = 'campaign_test_OrgMFS@mfstest.com';
        retailUser.DefaultCurrencyIsoCode = 'USD';
        insert retailUser; 
        system.debug('USer id in test class MFS_UserTriggerUtilityTest :'+retailUser.Id);
    }
}