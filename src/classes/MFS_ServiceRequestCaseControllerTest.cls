@isTest(seeAllData=false)
public class MFS_ServiceRequestCaseControllerTest {
    public static testMethod void testController(){
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Plan__c plan = MFS_TestDataUtility.createPlan(acc.Id);
        insert plan;
        Plan__c plan2 = MFS_TestDataUtility.createPlan(acc.Id);
        insert plan2;
        List<Product2> prodList = MFS_testDataUtility.createBulkProduct();
        insert prodList;
        List<Account__c> clInvList =  MFS_testDataUtility.createBulkClientInvestment(acc.Id, plan.Id, prodList);
        insert clInvList;
        List<Account__c> clInvList1 =  MFS_testDataUtility.createBulkClientInvestment(acc.Id, plan2.Id, prodList);
        insert clInvList1;
        Contact cont = MFS_testDataUtility.createContact(acc.Id);
        insert cont;
        Case cse = MFS_testDataUtility.createCase(cont);
        insert cse;
        Investments_Needing_Service__c inv = MFS_testDataUtility.createInvestments(cse.Id);
        inv.Investment__c = clInvList[0].Id;
        insert inv;
        Investments_Needing_Service__c pln = MFS_testDataUtility.createInvestments(cse.Id);
        pln.Plan__c = plan.Id;
        insert pln;
        
        Pagereference prf = Page.MFS_ServiceRequestCase;
        Test.setCurrentPage(prf);
        ApexPages.currentPage().getParameters().put('Id', cse.id);
        MFS_ServiceRequestCaseController ctrl = new MFS_ServiceRequestCaseController(new ApexPages.StandardController(cse));
        System.assertEquals(2, ctrl.planList.size());
        System.assertEquals(2, ctrl.investmentMap.size());
        ctrl.closePopup();
        ctrl.save();
        
        ctrl.planList[1].selected = true;
        ctrl.investmentMap.get(plan2.id)[0].selected = true;
        ctrl.save();
        
        PMAPS__c pmap = new PMAPS__c(Service_Request__c=cse.Id, Date_Received__c = System.TODAY(), Date_Due__c = System.TODAY().addDays(10));
        insert pmap;
        
        //Test Case related List
        Pagereference prf1 = Page.MFS_ServiceRequestRelatedList;
        Test.setCurrentPage(prf1);
        ApexPages.currentPage().getParameters().put('Id', cse.id);
        
        //Test Pmaps related List
        MFS_ServiceRequestRelatedListController relatedCtrl = new MFS_ServiceRequestRelatedListController(new ApexPages.StandardController(cse));
        Pagereference prf2 = Page.MFS_ServiceRequestRelatedList;
        Test.setCurrentPage(prf2);
        ApexPages.currentPage().getParameters().put('Id', pmap.id);
        relatedCtrl = new MFS_ServiceRequestRelatedListController(new ApexPages.StandardController(pmap));
    }
}