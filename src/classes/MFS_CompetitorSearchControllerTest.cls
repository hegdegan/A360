@isTest(seeAllData = false)
public class MFS_CompetitorSearchControllerTest {

    static testMethod void testCompProductController(){   
        Test.startTest();
        Competitor_Product__c compProduct = MFS_TestDataUtility.createComptrProduct();
        Account account = MFS_TestDataUtility.createAccount();
        insert account;
        compProduct.Firm__c = account.Id;        
        compProduct.Firm_Name__c = account.Name;
        insert compProduct;
        Opportunity opp = MFS_TestDataUtility.createOpportunity(account.Id);
        insert opp;
        Competitor_Product_Opp_Association__c compProJunction = new Competitor_Product_Opp_Association__c(Competitor_Product__c=compProduct.Id,Opportunity__c=opp.Id);
        MFS_CompetitorSearchController compPrsearchCtrl = new MFS_CompetitorSearchController(new ApexPages.StandardController(compProJunction));
        compPrsearchCtrl.searchCom='AllianzGI NFJ Mid Cap Value 100';
        compPrsearchCtrl.firm = 'TestAccount';
        compPrsearchCtrl.theOpp = opp;
        compPrsearchCtrl.searchComProduct();
        PageReference addUnknownStrategyPr = compPrsearchCtrl.addUnknownStrategy();
        //SONAR Fix
        system.assert(addUnknownStrategyPr == null );
        compPrsearchCtrl.wraplist[0].isSelected = true;
        compPrsearchCtrl.addUnknownStrategy();
        compPrsearchCtrl.onCancel();
        Test.stopTest();
    }
    
    static testMethod void testCompProductControllerNegetiveScenario(){  
        Test.startTest();
        Competitor_Product__c compProduct = MFS_TestDataUtility.createComptrProduct();
        Account account = MFS_TestDataUtility.createAccount();
        insert account;
        compProduct.Firm__c = account.Id;
        compProduct.Firm_Name__c = account.Name;
        insert compProduct;
        Opportunity opp = MFS_TestDataUtility.createOpportunity(account.Id);
        insert opp;
        Competitor_Product_Opp_Association__c compProJunction = new Competitor_Product_Opp_Association__c(Competitor_Product__c=compProduct.Id,Opportunity__c=opp.Id);
        MFS_CompetitorSearchController compPrsearchCtrl = new MFS_CompetitorSearchController(new ApexPages.StandardController(compProJunction));
        compPrsearchCtrl.wraplist = null;
        compPrsearchCtrl.searchCom=null;
        compPrsearchCtrl.firm = null;
        compPrsearchCtrl.theOpp = opp;
        compPrsearchCtrl.searchComProduct();
        compPrsearchCtrl.wraplist[0].isSelected = false;
        PageReference addUnknownStrategyPr = compPrsearchCtrl.addUnknownStrategy();
        //SONAR Fix
        system.assert(addUnknownStrategyPr == null );
        compPrsearchCtrl.onCancel();
        Test.stopTest();
    }
    
    
}