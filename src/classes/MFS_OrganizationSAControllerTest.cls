@isTest(seeAllData = false)
public class MFS_OrganizationSAControllerTest {
    @testSetup
    static void setup(){
        RecordType accRetailRT=[select id, name from RecordType where SObjectType='Account' AND Name = 'Global Retail' LIMIT 1];
        RecordType accInstRT=[select id, name from RecordType where SObjectType='Account' AND Name = 'Global Institutional Client' LIMIT 1];
        RecordType accConsRT=[select id, name from RecordType where SObjectType='Account' AND Name = 'Investment Consultant' LIMIT 1];
        //Insert Retail Org
        Account accRet = MFS_TestDataUtility.createAccount();
        accRet.RecordtypeId = accRetailRT.Id;
        accRet.MDM_ID__c = 'RET12345678';
        insert accRet;
        //Insert Inst Org
        Account accInst = MFS_TestDataUtility.createAccount();
        accInst.RecordtypeId = accInstRT.Id;
        accInst.MDM_ID__c = 'INST1234567';
        insert accInst;
        //Insert Consultant Org
        Account accCons = MFS_TestDataUtility.createAccount();
        accCons.RecordtypeId = accConsRT.Id;
        accCons.MDM_ID__c = 'CONS1234567';
        insert accCons;
        //Custom settings Entries
        List<Application_Settings__c> appSettingsList = MFS_TestDataUtility.getappSettingsList();
        insert appSettingsList;
        List<AssetPageAndTableSettings__c> assetTableList = MFS_TestDataUtility.geAssetPageAndTableSettings();
        insert assetTableList;
        List<Currency_Symbol__c> listCurrSymbolList = MFS_TestDataUtility.getCurrSymbolList();
        insert listCurrSymbolList;
        //Retail Records
        GDM_Table_Fields__c gdmTableFieldsRetail = MFS_TestDataUtility.getGDMFieldsRetail();
        insert gdmTableFieldsRetail;
        GDM_Table_Fields__c gdmTableFieldsInst = MFS_TestDataUtility.getGDMFieldsInstitutional();
        insert gdmTableFieldsInst;
        GDM_Table_Fields__c gdmTableFieldsConsultant = MFS_TestDataUtility.getGDMFieldsConsultant();
        insert gdmTableFieldsConsultant;
        //Inser Institutional Record
        Organization_Institutional_Sales__c ois = MFS_TestDataUtility.getOrgInstSalesRec(accInst);
        insert ois;
        User retailUser = MFS_TestDataUtility.createUser('Global Retail External');
        retailUser.UserName = 'unique_test_OrgSATest@mfstest.com';
        retailUser.DefaultCurrencyIsoCode = 'JPY';
        insert retailUser; 
        System.RunAs(retailUser){
            Account accRetail = MFS_TestDataUtility.createAccount();
            accRetail.RecordtypeId = accRetailRT.Id;
            accRetail.MDM_ID__c = 'RET1234567';
            insert accRetail;            
        }
        User X_AdminUser = MFS_TestDataUtility.createUser('X_System Administrator');
        X_AdminUser.UserName = 'unique_test_OrgSATest_XAdmin@mfstest.com';
        X_AdminUser.DefaultCurrencyIsoCode = 'JPY';
        insert X_AdminUser;
    }
    //Test coverage for Retail table
    static testMethod void showOrgSalesAndAssetsForRetail(){        
        Test.startTest();
        Account acc = [select Id from Account where Name = 'TestAccount' and MDM_ID__c = 'RET12345678'];
        PageReference pr =  new PageReference('/'+acc.id);
        pr.getParameters().put('Id',acc.id); 
        test.setCurrentPage(pr);
        MFS_OrgSalesAndAssetsController orgSAControllerObj = new MFS_OrgSalesAndAssetsController(new ApexPages.StandardController(acc));         
        MFS_TestDataUtility.setRetailSalesList();
        orgSAControllerObj.GetSalesAssetsListForRetail();
        System.assert(orgSAControllerObj.SalesWrapperList.size()>0);
        System.assert(orgSAControllerObj.levelOneList.size()>0);
        System.assert(orgSAControllerObj.levelTwoList.size()>0);
        System.assert(orgSAControllerObj.levelThreeMap.size()>0);         
        Test.stopTest();
    }
    //Test coverage for Institutional table
    static testMethod void showOrgSalesAndAssetsForInstitutional(){
        Test.startTest();
        Account acc = [select Id from Account where Name = 'TestAccount' and MDM_ID__c = 'INST1234567'];
        PageReference pr =  new PageReference('/'+acc.id);
        pr.getParameters().put('Id',acc.id); 
        test.setCurrentPage(pr);
        MFS_OrgSalesAndAssetsController orgSAControllerObj = new MFS_OrgSalesAndAssetsController(new ApexPages.StandardController(acc));  
        orgSAControllerObj.lstSalesType = new List<String>{MFS_AllConstants.Mycurr, MFS_AllConstants.ClientCurr};
        orgSAControllerObj.getCategory();
        MFS_Utilities.AssetsDataList = MFS_TestDataUtility.getInstitutionalSalesList();
        orgSAControllerObj.GetSalesAssetsListForInstitutional();
        //System.assert(orgSAControllerObj.SalesWrapperList.size()>0);
        //System.assert(orgSAControllerObj.levelOneList.size()>0);
        //System.assert(orgSAControllerObj.levelTwoList.size()>0); 
        Test.stopTest();
    }
    //Test coverage for Consultant table
    static testMethod void showOrgSalesAndAssetsForConsultant(){
        Test.startTest();
        Account acc = [select Id from Account where Name = 'TestAccount' and MDM_ID__c = 'CONS1234567'];
        PageReference pr =  new PageReference('/'+acc.id);
        pr.getParameters().put('Id',acc.id); 
        test.setCurrentPage(pr);
        MFS_OrgSalesAndAssetsController orgSAControllerObj = new MFS_OrgSalesAndAssetsController(new ApexPages.StandardController(acc));   
        MFS_TestDataUtility.setConsultantSalesList();
        orgSAControllerObj.GetSalesAssetsListForConsultant();
        System.assert(orgSAControllerObj.SalesWrapperList.size()>0);
        System.assert(orgSAControllerObj.levelOneList.size()>0);
        System.assert(orgSAControllerObj.levelTwoMap.size()>0);
        System.assert(orgSAControllerObj.levelThreeMap.size()>0); 
        Test.stopTest();
    }
    
    static testMethod void testInstitutionalClientCurr(){
        Test.startTest();  
        Account acc = [select Id from Account where Name = 'TestAccount' and MDM_ID__c = 'INST1234567'];
        PageReference pr =  new PageReference('/'+acc.id);
        pr.getParameters().put('Id',acc.id); 
        test.setCurrentPage(pr);
        MFS_OrgSalesAndAssetsController orgSAControllerObj = new MFS_OrgSalesAndAssetsController(new ApexPages.StandardController(acc));
        MFS_Utilities.AssetsDataList = MFS_TestDataUtility.getInstitutionalSalesList();
        orgSAControllerObj.selectedCategory = MFS_AllConstants.ClientCurr;
        String ClientCurr = MFS_Utilities.getClientReportingCurr('Organization_Institutional_Sales__c','INST1234567');
        System.assertEquals(ClientCurr,'USD');
        orgSAControllerObj.GetSalesAssetsListForInstitutional();
        Test.stopTest();
        
    }
    //Test coverage for exception block
    static testMethod void testExceptionBlock(){
        Test.startTest(); 
        Account acc1 = [select Id from Account where Name = 'TestAccount' and MDM_ID__c = 'RET12345678'];
        PageReference pr =  new PageReference('/'+acc1.id);
        pr.getParameters().put('Id',acc1.id); 
        test.setCurrentPage(pr);
        delete acc1;
        MFS_OrgSalesAndAssetsController orgSAControllerObj = new MFS_OrgSalesAndAssetsController(new ApexPages.StandardController(acc1)); 
        orgSAControllerObj.selectedCategory = MFS_AllConstants.ClientCurr;
        orgSAControllerObj.GetSalesAssetsListForInstitutional();
        orgSAControllerObj.GetSalesAssetsListForConsultant();
        orgSAControllerObj.GetSalesAssetsListForRetail();
        System.assert(ApexPages.hasMessages(),Label.SA_Blank_MDM);
        Test.stopTest();
    }
    
    //Test Error Codes with Retial Profile
    static testMethod void testErrorsAsAdminForNoRecordsInGDM(){
        Test.startTest();
        User X_AdminUser = [Select Id from User where userName = 'unique_test_OrgSATest_XAdmin@mfstest.com'];
        System.RunAs(X_AdminUser){            
            Account acc = [select Id,MDM_ID__c from Account where MDM_ID__c = 'RET1234567'];
            //No records from GDM test
            acc.MDM_ID__c = 'XMDM3456ACC';
            update acc;            
            PageReference pr =  new PageReference('/'+acc.id);
            pr.getParameters().put('Id',acc.id); 
            test.setCurrentPage(pr);
            MFS_OrgSalesAndAssetsController accountSAControllerObj = new MFS_OrgSalesAndAssetsController(new ApexPages.StandardController(acc));
            accountSAControllerObj.getSalesAssetsListForInstitutional();
            System.assert(ApexPages.hasMessages(),Label.SA_No_records_found); 
            accountSAControllerObj.getSalesAssetsListForRetail();
            System.assert(ApexPages.hasMessages(),Label.SA_No_records_found); 
            accountSAControllerObj.getSalesAssetsListForConsultant();
            System.assert(ApexPages.hasMessages(),Label.SA_No_records_found); 
            //Blank MDM ID Test
            acc.MDM_ID__c = null;
            update acc;            
            MFS_OrgSalesAndAssetsController contactAndteamSAControllerObj2 = new MFS_OrgSalesAndAssetsController(new ApexPages.StandardController(acc));
            contactAndteamSAControllerObj2.getSalesAssetsListForInstitutional();
            System.assert(ApexPages.hasMessages(),Label.SA_Blank_MDM);   
            accountSAControllerObj.getSalesAssetsListForRetail();
            System.assert(ApexPages.hasMessages(),Label.SA_Blank_MDM);
            accountSAControllerObj.getSalesAssetsListForConsultant();
            System.assert(ApexPages.hasMessages(),Label.SA_Blank_MDM);
        }
        Test.stopTest();
    }
}