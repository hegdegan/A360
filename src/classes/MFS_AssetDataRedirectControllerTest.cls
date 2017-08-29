@isTest(seeAllData = false)
public class MFS_AssetDataRedirectControllerTest {
    
    static testMethod void testGlobalInstitutionalRedirection(){    
        Test.startTest();
            PageReference pageURL;
            Account acc = MFS_TestDataUtility.createAccount();
            acc.MDM_ID__c = '1234567';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Global Institutional Client').getRecordtypeId();
            insert acc;
            PageReference pr =  new PageReference('/'+acc.id);
            pr.getParameters().put('Id',acc.id); 
            test.setCurrentPage(pr);
            MFS_AssetDataRedirectController assetDataRedirectCtrl = new MFS_AssetDataRedirectController(new ApexPages.StandardController(acc)); 
            pageURL = assetDataRedirectCtrl.redirect();
            System.assert(pageURL!=null); 
            //Test with Rec Type Retail
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Global Retail').getRecordtypeId();
            update acc;
            pageURL = assetDataRedirectCtrl.redirect();
            System.assert(pageURL!=null); 
        Test.stopTest();
    }
    
    static testMethod void testGlobalRetailRedirection(){ 
        Test.startTest();
            PageReference pageURL;
            Account acc1 = MFS_TestDataUtility.createAccount();
            acc1.MDM_ID__c = '1234';
            acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Global Retail').getRecordtypeId();
            insert acc1;
            PageReference pr =  new PageReference('/'+acc1.id);
            pr.getParameters().put('Id',acc1.id); 
            test.setCurrentPage(pr);
            MFS_AssetDataRedirectController assetDataRedirectCtrl1 = new MFS_AssetDataRedirectController(new ApexPages.StandardController(acc1)); 
            pageURL = assetDataRedirectCtrl1.redirect();
            System.assert(pageURL!=null); 
            //Test with Rec Type Institutional
            acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Global Institutional Client').getRecordtypeId();
            update acc1;
            pageURL = assetDataRedirectCtrl1.redirect();
            System.assert(pageURL!=null);
            //Test with Rec Type Consultant Investment Consultant
            acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Investment Consultant').getRecordtypeId();
            update acc1;
            pageURL = assetDataRedirectCtrl1.redirect();
            System.assert(pageURL!=null);
            //Test with Rec Type Global Institutional Prospect
            acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Global Institutional Prospect').getRecordtypeId();
            update acc1;
            pageURL = assetDataRedirectCtrl1.redirect();
            System.assert(pageURL==null);
            //Test with Rec Type Service Provider
            acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Provider').getRecordtypeId();
            update acc1;
            pageURL = assetDataRedirectCtrl1.redirect();
            System.assert(pageURL==null);
             //Test with Rec Type Null
            acc1.RecordTypeId = null;
            update acc1;
            pageURL = assetDataRedirectCtrl1.redirect();
            System.assert(pageURL==null);
        Test.stopTest();
    }
    
}