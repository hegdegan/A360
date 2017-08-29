@isTest(seeAllData=false)
public class MFS_ContactAndTeamSAControllerTest {
    @testSetup
    static void setup(){
        List<Application_Settings__c> appSettingsList = MFS_TestDataUtility.getappSettingsList();
        insert appSettingsList;
        Account acc = MFS_TestDataUtility.createAccount();
        acc.MDM_ID__c = '1234567';
        insert acc;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        cont.MDM_ID__c = 'MDM3456';
        insert cont;
        Team__c team = new Team__c(name='Team BBT',MDM_Id__c='TM4567');
        insert team;
        //Custom settings Entries
        List<AssetPageAndTableSettings__c> assetTableList = MFS_TestDataUtility.geAssetPageAndTableSettings();
        insert assetTableList;
        List<Currency_Symbol__c> listCurrSymbolList = MFS_TestDataUtility.getCurrSymbolList();
        insert listCurrSymbolList;
        GDM_Table_Fields__c gdmTableFieldsContact = MFS_TestDataUtility.getGDMFieldsTotalSales();
        insert gdmTableFieldsContact;
        GDM_Table_Fields__c gdmTableFieldsContact1 = MFS_TestDataUtility.getGDMFieldsIndividualSales();
        insert gdmTableFieldsContact1;
        User retailUser = MFS_TestDataUtility.createUser('Global Retail External');
        retailUser.UserName = 'unique_test_contactSATest@mfstest.com';
        retailUser.DefaultCurrencyIsoCode = 'JPY';
        insert retailUser; 
        System.RunAs(retailUser){
            RecordType accRt=[select id, name from RecordType where SObjectType='Account' AND Name = 'Global Retail' LIMIT 1];
            Account accRetail = MFS_TestDataUtility.createAccount();
            accRetail.RecordtypeId = accRt.Id;
            accRetail.MDM_ID__c = 'RET1234567';
            insert accRetail;
            RecordType rt=[select id, name from RecordType where SObjectType='Contact' AND Name = 'Retail' LIMIT 1];
            Contact contRet = MFS_TestDataUtility.createContact(accRetail.id);
            contRet.RecordtypeId = rt.Id;
            contRet.MDM_ID__c = 'RETMDM3456';
            insert contRet;
        }
        User X_adminUser = MFS_TestDataUtility.createUser('X_System Administrator');
        X_adminUser.UserName = 'unique_test_contactSATest_XAdmin@mfstest.com';
        X_adminUser.DefaultCurrencyIsoCode = 'JPY';
        insert X_adminUser; 
        
    }
    
    static testMethod void showContactSalesAndAssets(){
        Test.startTest();
        Contact cont = [select Id,MDM_Id__c from Contact where MDM_ID__c = 'MDM3456'];
        PageReference pr =  new PageReference('/'+cont.id);
        pr.getParameters().put('Id',cont.id); 
        test.setCurrentPage(pr);
        MFS_TestDataUtility.setTotalSalesList();
        MFS_ContactAndTeamSalesAssetController contactAndteamSAControllerObj = new MFS_ContactAndTeamSalesAssetController(new ApexPages.StandardController(cont));
        System.assert(contactAndteamSAControllerObj.SalesWrapperList.size()>0);
        System.assert(contactAndteamSAControllerObj.ProductVehicleList.size()>0);
        System.assert(contactAndteamSAControllerObj.ProductList.size()>0);
        //System.assert(contactAndteamSAControllerObj.levelThreeMap.size()>0); 
        contactAndteamSAControllerObj.getCategory();
        contactAndteamSAControllerObj.getSelectedTableName(MFS_AllConstants.LevelTotal);
        contactAndteamSAControllerObj.getSelectedTableName(MFS_AllConstants.SelectedCatIndividual);
        contactAndteamSAControllerObj.getSelectedTableName(MFS_AllConstants.SelectedCatPartnership);
        contactAndteamSAControllerObj.getSelectedTableName(MFS_AllConstants.SelectedCatTeam);
        //Negetive Scenario & Team
        Team__c team = [SELECT Id from Team__c where MDM_ID__c = 'TM4567'];
        PageReference pr1 =  new PageReference('/'+team.id);
        pr1.getParameters().put('Id',team.id); 
        test.setCurrentPage(pr1);
        MFS_ContactAndTeamSalesAssetController contactAndteamSAControllerObj1 = new MFS_ContactAndTeamSalesAssetController(new ApexPages.StandardController(cont));
        System.assert(contactAndteamSAControllerObj1.SalesWrapperList.size()==0);
        System.assert(contactAndteamSAControllerObj1.ProductVehicleList.size()==0);
        System.assert(contactAndteamSAControllerObj1.ProductList.size()==0);
        Test.stopTest();
    }
    static testMethod void testExceptionBlock(){
        Test.startTest();
        Contact cont = [select Id,MDM_ID__c from Contact where MDM_ID__c = 'MDM3456'];
        cont.MDM_ID__c = null;
        update cont;
        PageReference pr =  new PageReference('/'+cont.id);
        pr.getParameters().put('Id',cont.id); 
        test.setCurrentPage(pr);
        MFS_ContactAndTeamSalesAssetController contactAndteamSAControllerObj = new MFS_ContactAndTeamSalesAssetController(new ApexPages.StandardController(cont));
        cont.MDM_ID__c = 'MDM9999';
        update cont;
        MFS_ContactAndTeamSalesAssetController contactAndteamSAControllerObj1 = new MFS_ContactAndTeamSalesAssetController(new ApexPages.StandardController(cont));
        delete cont;
        MFS_ContactAndTeamSalesAssetController contactAndteamSAControllerObj2 = new MFS_ContactAndTeamSalesAssetController(new ApexPages.StandardController(cont));
        System.assert(ApexPages.hasMessages(),Label.Generic_Error); 
        Test.stopTest();
    }
    
    static testMethod void testErrorsAsXAdminForNoRecordsInGDM(){
        Test.startTest();
        User X_adminUser = [Select Id from User where userName = 'unique_test_contactSATest_XAdmin@mfstest.com'];
        System.RunAs(X_adminUser){            
            Contact cont = [select Id,MDM_ID__c from Contact where MDM_ID__c = 'RETMDM3456'];
            //No records from GDM test
            cont.MDM_ID__c = 'XMDM3456';
            update cont;            
            PageReference pr =  new PageReference('/'+cont.id);
            pr.getParameters().put('Id',cont.id); 
            test.setCurrentPage(pr);
            MFS_ContactAndTeamSalesAssetController contactAndteamSAControllerObj = new MFS_ContactAndTeamSalesAssetController(new ApexPages.StandardController(cont));
            System.assert(ApexPages.hasMessages(),Label.SA_No_records_found);            
            //Blank MDM ID Test
            cont.MDM_ID__c = null;
            update cont;            
            MFS_ContactAndTeamSalesAssetController contactAndteamSAControllerObj2 = new MFS_ContactAndTeamSalesAssetController(new ApexPages.StandardController(cont));
            System.assert(ApexPages.hasMessages(),Label.SA_Blank_MDM);            
        }
        Test.stopTest();
    }
    
}