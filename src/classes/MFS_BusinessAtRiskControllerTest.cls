/***************************************************************************************************
Apex Class Name    : MFS_BusinessAtRiskControllerTest
Version            : 1.0 
Created Date       : 16 JUL 2016
Function           : This is a Test class for MFS_BusinessAtRiskController
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            07/16/2016              Original Version
***************************************************************************************************/
@isTest(seeAllData=false)
public class MFS_BusinessAtRiskControllerTest {
    @isTest static void fetchBARTest()
    {
        Test.startTest();
        Business_At_Risk__c br = utility();
        System.assertNotEquals(null, br);
        br.id=null;
        Pagereference prf = Page.MFS_BusinessAtRisk;
        Test.setCurrentPage(prf);
        ApexPages.currentPage().getParameters().put('account', br.Organization__c);
        MFS_BusinessAtRiskController BAR= new MFS_BusinessAtRiskController(new ApexPages.StandardController(br));
        //assert the list and map size
        system.assertEquals(3,BAR.planLst.size());
        system.assertEquals(3,BAR.PortfolioMap.size());
    
        BAR.PlanLst[0].selected = true;
        BAR.PortfolioMap.get('PL-001')[0].selected=true;
        BAR.PortfolioMap.get('PL-002')[0].selected=true;
        PageReference pr = BAR.save();
        system.assert(pr.getUrl().contains('/apex/mfs_businessatriskupdate?'));
        System.assertEquals(BAR.isDetail, true);
        
        BAR.selectedIcon = 'plus';
        BAR.renderPortf();
        BAR.selectedIcon = 'minus';
        BAR.renderPortf();
        
        BAR.selectAndLockChildRows();
        BAR.copyToChildRows();
        BAR.childRow = '1';
        BAR.handleParentRows();
        
        BAR.selectAll=true;
        BAR.selectAll();
        BAR.selectAll=false;
        BAR.selectAll();
        BAR.calculateTotalAUMs();
        
        List<Account> accSrchList = MFS_BusinessAtRiskController.queryAccounts('TestAccount');
        system.assertEquals(1, accSrchList.size());
        
        //Test Validation handling
        br.Expected_Loss_Date__c = System.Today()-1;
        update br;
        BAR.save();
        br.Relationship_at_Risk_Date__c = System.today()-1;
        update br;
        BAR.save();
        br.Percentage_at_Risk__c = '';
        update br;
        BAR.save();
        
        //Test Edit page
        prf = Page.MFS_BusinessAtRiskUpdate;
        Test.setCurrentPage(prf);
        ApexPages.currentPage().getParameters().put('type', 'edit');
        MFS_BusinessAtRiskController edit= new MFS_BusinessAtRiskController(new ApexPages.StandardController(br));
        edit.edit();
        edit.updateBAR();
        Test.stopTest();
    }
    @isTest static void editBARTest()
    {
        Test.startTest();
        Business_At_Risk__c br = utility();
        System.assertNotEquals(null, br);
        Pagereference prf = Page.MFS_BusinessAtRiskUpdate;
        Test.setCurrentPage(prf);
        ApexPages.currentPage().getParameters().put('type', 'edit');
        MFS_BusinessAtRiskController BAR= new MFS_BusinessAtRiskController(new ApexPages.StandardController(br));
        //assert the list and map size
        system.assertEquals(3,BAR.planLst.size());
        system.assertEquals(3,BAR.PortfolioMap.size());
    	
        BAR.PlanLst[0].barPlans.selected__c = true;
        BAR.PortfolioMap.get('PL-001')[0].barPortfolio.selected__c=true;
        BAR.PortfolioMap.get('PL-002')[0].barPortfolio.selected__c=true;
        PageReference pr = BAR.updateBAR();
               BAR.calculateBARTotalAUMs();
        
        //Test Validation handling
        br.Expected_Loss_Date__c = System.Today()-1;
        update br;
        BAR.updateBAR();
        br.Relationship_at_Risk_Date__c = System.today()-1;
        update br;
        BAR.updateBAR();
        br.Percentage_at_Risk__c = '';
        update br;
        BAR.updateBAR();
        BAR.getFAR();
        BAR.newFAR();
        BAR.getOpenActivities();
        BAR.newTask();
        BAR.newMeeting();
        BAR.getActivityHistories();
        Test.stopTest();
        
    }
    //create plan portfolio and BAR
    @isTest static Business_At_Risk__c utility()
    {
        Account acc = MFS_TestDataUtility.createAccount();
        acc.MDM_ID__c = '123456';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Global Institutional Client').getRecordtypeId();
        insert acc;
        System.assertNotEquals(null, acc);
        //create data for plans and portfolios
        List<Organization_Institutional_Sales__c> oisLst = new List<Organization_Institutional_Sales__c>();
        for(Integer i=1 ; i<4; i++)
        {
            Organization_Institutional_Sales__c ois = new Organization_Institutional_Sales__c();
            ois.Organization__c = acc.id;
            ois.AUM_AUD__c = 20.00;
            ois.AUM_CAD__c = 10.00;
            ois.AUM_EUR__c = 5.00;
            ois.AUM_GBP__c = 5.00;
            ois.AUM_JPY__c = 5.00;
            ois.AUM_SGD__c = 5.00;
            ois.AUM_USD__c = 5.00;
            ois.Client_Reporting_Currency_Code__c = 'JPY';
            ois.Plan_ID__c = 'PL-00'+i;
            ois.Plan_Name__c = 'Kaiser Plan'+i;
            ois.Organization_MDM_ID__c = '123456';
            ois.Level__c = 'Plan';
            oisLst.add(ois); 
            for(Integer j=1; j<3; j++)
            {
                Organization_Institutional_Sales__c oisPf = new Organization_Institutional_Sales__c();
                oisPf.Organization__c = acc.id;
                oisPf.AUM_AUD__c = 20.00;
                oisPf.AUM_CAD__c = 10.00;
                oisPf.AUM_EUR__c = 5.00;
                oisPf.AUM_GBP__c = 5.00;
                oisPf.AUM_JPY__c = 5.00;
                oisPf.AUM_SGD__c = 5.00;
                oisPf.AUM_USD__c = 5.00;
                oisPf.Client_Reporting_Currency_Code__c = 'JPY';
                oisPf.Plan_ID__c = 'PL-00'+i;
                oisPf.Portfolio_ID__c = 'PF-00'+j;
                oisPf.Plan_Name__c = 'Kaiser Portfolio'+j;
                oisPf.Organization_MDM_ID__c = '123456';
                oisPf.Level__c = 'Portfolio';
                oisLst.add(oisPf);
            }
        }
        insert oisLst;
        System.assertNotEquals(0, oisLst.size());
        Business_At_Risk__c br = MFS_testDataUtility.createBAR(acc.id);
        insert br;
        List<BAR_Org_Institutional_Sales__c> oisBARLst = new List<BAR_Org_Institutional_Sales__c>();
        for(Integer i=1 ; i<4; i++)
        {
            BAR_Org_Institutional_Sales__c ois = new BAR_Org_Institutional_Sales__c();
            ois.Organization__c = acc.id;
            ois.Business_At_Risk__c = br.id;
            ois.AUM_AUD__c = 20.00;
            ois.AUM_CAD__c = 10.00;
            ois.AUM_EUR__c = 5.00;
            ois.AUM_GBP__c = 5.00;
            ois.AUM_JPY__c = 5.00;
            ois.AUM_SGD__c = 5.00;
            ois.AUM_USD__c = 5.00;
            ois.Client_Reporting_Currency_Code__c = 'JPY';
            ois.Plan_ID__c = 'PL-00'+i;
            ois.Plan_Name__c = 'Kaiser Plan'+i;
            ois.Level__c = 'Plan';
            ois.MDM_ID__c = '123456';
            ois.Percentage_At_Risk__c = 10.00;
            oisBARLst.add(ois); 
            for(Integer j=1; j<3; j++)
            {
                BAR_Org_Institutional_Sales__c oisPf = new BAR_Org_Institutional_Sales__c();
                oisPf.Organization__c = acc.id;
                oisPf.Business_At_Risk__c = br.id;
                oisPf.AUM_AUD__c = 20.00;
                oisPf.AUM_CAD__c = 10.00;
                oisPf.AUM_EUR__c = 5.00;
                oisPf.AUM_GBP__c = 5.00;
                oisPf.AUM_JPY__c = 5.00;
                oisPf.AUM_SGD__c = 5.00;
                oisPf.AUM_USD__c = 5.00;
                oisPf.Client_Reporting_Currency_Code__c = 'JPY';
                oisPf.Plan_ID__c = 'PL-00'+i;
                oisPf.Plan_Name__c = 'Kaiser Portfolio'+j;
                oisPf.Level__c = 'Portfolio';
                oisPf.MDM_ID__c = '123456';
                oispf.Percentage_At_Risk__c = 10.00;
                oisBARLst.add(oisPf);
            }
        }
        insert oisBARLst;
        System.assertNotEquals(0, oisBARLst.size());
        
        
        return br;
    }
}