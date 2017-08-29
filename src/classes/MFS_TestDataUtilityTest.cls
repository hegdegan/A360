@isTest(seeAllData = false)
public class MFS_TestDataUtilityTest {
    
    static testMethod void testAllTestMethodsForCodeCoverage(){    
        
        Test.startTest();
        User u = MFS_TestDataUtility.createUser('Global Institutional Sales');
        insert u;
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        MFS_TestDataUtility.createStrategyPlan(acc.Id);
        Plan__c pl = MFS_TestDataUtility.createPlan(acc.Id);
        insert pl;
        Distribution_List__c dlc = MFS_TestDataUtility.createDistributionList(acc.Id);
        insert dlc;
        Opportunity opp = MFS_TestDataUtility.createOpportunity(acc.Id);
        insert opp;
        MFS_TestDataUtility.createEventRequest(u.Id);
        Contact con = MFS_TestDataUtility.createContact(acc.Id);
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Retail').getRecordtypeId();
        insert con;
        MFS_TestDataUtility.createPlanAsscn(con.Id);
        MFS_TestDataUtility.createPlanAsscnwithPlan(con.Id, pl.Id);
        MFS_TestDataUtility.createPlanAsscnwithDistList(acc.Id, dlc.Id);
        MFS_TestDataUtility.createEventWithContact(con.Id);
        MFS_TestDataUtility.createTask(acc.Id);
        Product2 pr = MFS_TestDataUtility.createProduct();
        insert pr;
        List<Product2> pp= MFS_TestDataUtility.createBulkPortfolioProduct();
        insert pp;
        List<Product2> ProdList = new List<Product2>();
        for(Product2 prod: pp)
        {
            ProdList.add(prod);  
        }
        MFS_TestDataUtility.createBulkClientInvestment(acc.Id, pl.Id,ProdList);
        
        PricebookEntry pb = MFS_TestDataUtility.createPriceBEntry(pr);
        insert pb;        
        MFS_TestDataUtility.createBulkPriceBEntry(pr,2);
        List<FeedItem> fiList = MFS_TestDataUtility.createFeedItem(acc.Id,2);
        MFS_TestDataUtility.createFeedComment(fiList.get(0).Id,2);
        MFS_TestDataUtility.createFeeApprovalRequest(opp.Id,pr.Id,u.id);
        MFS_TestDataUtility.createCase(con);
        MFS_TestDataUtility.createBulkCase(con, 2, 'Wednesday');
        MFS_TestDataUtility.createCallNote(acc.Id);
        MFS_TestDataUtility.createComptrProduct();
        MFS_TestDataUtility.createPlatform(acc.Id);
        MFS_TestDataUtility.createClientInverstment(acc.Id);
        MFS_TestDataUtility.createFieldForButton('A','B','C','D');
        MFS_TestDataUtility.createConsRating(acc.Id,pr.Id);
        MFS_TestDataUtility.createFieldIDData('A','B','C');
        MFS_TestDataUtility.createPMAPS(opp.Id,u.Id);
        MFS_TestDataUtility.createBulkPMAPS(opp.Id,u.Id);
        MFS_TestDataUtility.createEventReq(u.Id);
        MFS_TestDataUtility.createBulkEventReq(u.Id);
        Campaign cam = MFS_TestDataUtility.createCampaign();
        insert cam;
        MFS_TestDataUtility.createCampaignMember(cam.Id, con.Id);
        MFS_TestDataUtility.createBAR(acc.Id);
        MFS_TestDataUtility.setRetailSalesList();
        MFS_TestDataUtility.getInstitutionalSalesList();
        MFS_TestDataUtility.getTableName('A','B');
        MFS_TestDataUtility.getCurrSymbolList();
        MFS_TestDataUtility.getGDMFieldsInstitutional();
        MFS_TestDataUtility.getGDMFieldsRetail();
        MFS_TestDataUtility.getGDMFieldsConsultant();
        MFS_TestDataUtility.getGDMFieldsTotalSales();
        MFS_TestDataUtility.setConsultantSalesList();
        MFS_TestDataUtility.setTotalSalesList();
        MFS_TestDataUtility.getSalesAndWrapperList();
        MFS_TestDataUtility.getSalesAndWrapperListPerObjectType(MFS_AllConstants.OrgInsSalesPage);
        MFS_TestDataUtility.getSalesAndWrapperListPerObjectType(MFS_AllConstants.OrgConSalesPage);
        MFS_TestDataUtility.getSalesAndWrapperListPerObjectType('Exception');
        MFS_TestDataUtility.getSalesAndWrapperListPerObjectType(MFS_AllConstants.OrgRetSalesPage);
        List<Account> acclist = new List<Account>();
        acclist.add(acc);
        MFS_TestDataUtility.createBulkATM(acclist,2,u.Id);
        MFS_TestDataUtility.createOpportunityLineItem(opp.id,pb.Id);
        MFS_TestDataUtility.createOpportunityLineItem(opp,pb.Id);
        MFS_TestDataUtility.createBulkAccounts(2);
        //MFS_TestDataUtility.createBulkOpportunities();
        MFS_TestDataUtility.createBulkContacts(acclist,2);
        MFS_TestDataUtility.createBulkRelationships(acclist,2);
        MFS_TestDataUtility.createBulkEvents(acclist,2);
        MFS_TestDataUtility.createBulkSplan(acclist,2);
        MFS_TestDataUtility.createBulkGoal(2);
        MFS_TestDataUtility.CreateTestAppSetting('A','B');
        MFS_TestDataUtility.createGeoURL('A','B');
        MFS_TestDataUtility.CreateTestApplicationSettings('A','B','C','D');
        Id id =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Global Institutional Client').getRecordtypeId();
        MFS_TestDataUtility.createBulkOpportunities(acc.Id,2,id);
        List<Id> userIdList = new List<Id>();
        userIdList.add(u.Id);
        MFS_TestDataUtility.createOppTeam(opp.Id,userIdList);
        List<Contact> contactList = new List<Contact>();
        contactList.add(con);
        MFS_TestDataUtility.createBulkCCT(contactList,2,u.Id);
        MFS_TestDataUtility.getappSettingsList();
        MFS_TestDataUtility.getOrgInstSalesRec(acc);
        MFS_TestDataUtility.setIndividualSalesList();
        MFS_TestDataUtility.setPartnershipSalesList();
        MFS_TestDataUtility.getGDMFieldsIndividualSales();
        MFS_TestDataUtility.getGDMFieldsPartnershipSales();
        MFS_TestDataUtility.geAssetPageAndTableSettings();
        MFS_TestDataUtility.createBulkProduct();
        Test.stopTest();
    }
    
}