@isTest(seeAllData = false)
public class MFS_StrategyRatingControllerTest {
    public static testMethod void testStrategyProcess(){
        Pagereference prf = Page.MFS_StrategyRating;
        Test.setCurrentPage(prf);
        ApexPages.currentPage().getParameters().put('isInConsole', 'true');
        MFS_StrategyRatingController srCtrl = new MFS_StrategyRatingController();
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Product2 prod = MFS_TestDataUtility.createProduct();
        prod.Restricted__c = false;
        prod.Is_Unknown__c = false;
        insert prod;
        Strategy_Rating_Process__c srp = MFS_testDataUtility.createStrategyRatingProcess(acc.Id, prod.Id);
        insert srp;
        srCtrl.getFormTag();
        srCTrl.getTextBox();
        srCtrl.constructQuery('test','test','test');
		
        MFS_StrategyRatingController exCtrl = new MFS_StrategyRatingController(new ApexPages.StandardController(srp));
        exCtrl.getGeograhpyOptions();
        exCtrl.getVehicleOptions();
        exCtrl.loadProducts();
        exCtrl.searchOpt = 'testProduct';
        exCtrl.selectedAssetGeography = 'Emerging Markets (diversified) Equity';
        exCtrl.selectedVehicle = 'Domestic Mutual Fund';
        exCtrl.searchproduct();
        System.assertEquals(0, exCtrl.wraplist.size());
        exCtrl.searchOpt = '';
        exCtrl.selectedAssetGeography = '';
        exCtrl.selectedVehicle = '';
        exCtrl.searchproduct();
        MFS_StrategyRatingController.queryAccounts('Test');
        System.assertEquals(1, exCtrl.wraplist.size());
    }
}