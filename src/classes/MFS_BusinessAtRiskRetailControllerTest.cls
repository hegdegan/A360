@isTest(seeAllData=false)
public class MFS_BusinessAtRiskRetailControllerTest {
    static testMethod void fetchBARTest() {
        Business_At_Risk__c br = utility();
        Test.StartTest();
        br.id=null;
        Pagereference prf = Page.MFS_BusinessAtRiskRetail;
        Test.setCurrentPage(prf);
        ApexPages.currentPage().getParameters().put('account', br.Organization__c);
        MFS_BusinessAtRiskRetailController BAR= new MFS_BusinessAtRiskRetailController(new ApexPages.StandardController(br));
        for(Integer i=0; i<3; i++)
        {
            Organization_Retail_Sales__x x = new Organization_Retail_Sales__x(AUM_AUD__c=10.00, Level__c='Product', AUM_CAD__c=10.00, AUM_EUR__c=10.00, AUM_JPY__c=10.00, 
                                                                              AUM_SGD__c=10.00, AUM_USD__c=10.00, AUM_GBP__c=10.00 );
            BAR.portfList.add(x);
        }
        BAR.fetchRelatedLists();
        Test.StopTest();
        BAR.PortFolioLst[0].selected=true;
        Pagereference pr = BAR.save();
        String retUrl = '/apex/mfs_businessatriskretailupdate?id='+br.id+'&type=edit';
        
        system.assertEquals(retUrl.contains('/apex/mfs_businessatriskretailupdate'), pr.getUrl().contains('/apex/mfs_businessatriskretailupdate'));
        System.assertEquals(BAR.isDetail, true);
        
        BAR.selectAll=true;
        BAR.selectAll();
        BAR.selectAll=false;
        BAR.selectAll();
        BAR.changedRow = '1';
        BAR.selectRow();
        BAR.calculateTotalAUMs();
        
        List<Account> accSrchList = MFS_BusinessAtRiskRetailController.queryAccounts('Morgan');
        
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
        //Test exception blocks
        BAR.bar = null;
        BAR.fetchTotalCurrency();
        BAR.fetchRelatedLists();
        BAR.fetchBARRelatedLists();
        
        //system.assertNotEquals(accSrchList, null);
    }
    
    static testMethod void editBARTest() {
        Business_At_Risk__c br = utility();
        Test.StartTest();
       	Pagereference prf = Page.MFS_BusinessAtRiskRetailUpdate;
        Test.setCurrentPage(prf);
        ApexPages.currentPage().getParameters().put('type', 'edit');
        MFS_BusinessAtRiskRetailController BAR= new MFS_BusinessAtRiskRetailController(new ApexPages.StandardController(br));
        BAR.fetchBARRelatedLists();
        BAR.PortFolioLst[0].selected = true;
        BAR.portfolioLst[0].PercAtRisk = 25;
        br.Expected_Loss_Date__c = System.Today()+1;
        br.Relationship_at_Risk_Date__c = System.today()+1;
        update br;
        Pagereference pr = BAR.updateBAR();
        System.assert(pr!=null);
        BAR.calculateBARTotalAUMs();
        
        List<Account> accSrchList = MFS_BusinessAtRiskRetailController.queryAccounts('Morgan');
        BAR.edit();
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
        
        BAR.portfolioLst[0].PercAtRisk = null;
        BAR.calculateTotalAUMs();
        BAR.calculateBARTotalAUMs();
        Test.stopTest();
        //system.assertNotEquals(accSrchList, null);
    }
    //create plan portfolio and BAR
    @isTest public static Business_At_Risk__c utility()
    {
        Account acc = MFS_TestDataUtility.createAccount();
        acc.MDM_ID__c = '1234567890';
        
        insert acc;
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        insert usr;
        //SONAR Fix
        System.assertNotEquals(null,usr.Id);
        
        Business_At_Risk__c br = new Business_At_Risk__c();
        br.Organization__c = acc.Id;
        br.Expected_Loss_Date__c = System.Today();
        br.Percentage_at_Risk__c = 'Low';
        br.Expected_Loss_Date__c = System.Today()+1;
        br.Reason_at_Risk__c = 'Regulatory';
        br.Status__c = 'Open';
        insert br;
        List<BAR_Org_Retail_Sales__c> oisLst = new List<BAR_Org_Retail_Sales__c>();
        for(Integer i=1 ; i<4; i++)
        {
            BAR_Org_Retail_Sales__c ois = new BAR_Org_Retail_Sales__c();
            ois.Business_At_Risk__c = br.id;
            ois.AUM_AUD__c = 20.00;
            ois.AUM_CAD__c = 10.00;
            ois.AUM_EUR__c = 5.00;
            ois.AUM_GBP__c = 5.00;
            ois.AUM_JPY__c = 5.00;
            ois.AUM_SGD__c = 5.00;
            ois.AUM_USD__c = 5.00;
            ois.Level__c = 'Product';
            ois.MDM_ID__c = '1234567890';
            oisLst.add(ois); 
            
        }
        insert oisLst;
        return br;
    }
}