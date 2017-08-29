@isTest(seeAllData=false)
public class MFS_AccountToBARRedirectControllerTest {
@isTest static void redirectionTest()
    {
        Test.startTest();
        Account acc = MFS_TestDataUtility.createAccount();
        acc.MDM_ID__c = '1234563';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(MFS_AllConstants.RT_GOLABL_INST_CLIENT).getRecordtypeId();
        insert acc;
        
        MFS_AccountToBARRedirectController BAR = new MFS_AccountToBARRedirectController(new ApexPages.StandardController(acc));
        Pagereference redirect = BAR.redirect();
        system.assert(redirect.getUrl().contains('/apex/MFS_BusinessAtRisk?account'));
        
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Global Retail').getRecordtypeId();
        update acc;
        Pagereference redirectRetail = BAR.redirect();
        system.assert(redirectRetail.getUrl().contains('/apex/MFS_BusinessAtRiskRetail?account'));
        
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(MFS_AllConstants.RT_INVST_CONSULTANT).getRecordtypeId();
        update acc;
        Pagereference redirectMessage = BAR.redirect();
        system.assertEquals(null,redirectMessage);
        
        Test.stopTest();
               
    }
}