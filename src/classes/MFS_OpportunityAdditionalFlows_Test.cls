@isTest
public class MFS_OpportunityAdditionalFlows_Test {
    
    static testmethod void testOppRedirectError()
    {
         Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.id);        
        Test.setCurrentPage(Page.MFS_OpportunityAdditionalFlows);        
        MFS_OpportunityAdditionalFlows oppAFCtrl1= new MFS_OpportunityAdditionalFlows(new ApexPages.StandardController(oppRec));
        insert oppRec;
        MFS_OpportunityAdditionalFlows oppAFCtrl = new MFS_OpportunityAdditionalFlows(new ApexPages.StandardController(oppRec));
        pagereference pageRef=oppAFCtrl.redirect();
        System.assert(pageRef==null);       
        Test.stopTest();
    }
    
	static testmethod void testOppRedirection()
    {
        Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.id);        
        insert oppRec; 
        Product2 prodRec=MFS_TestDataUtility.createProduct();
        insert prodRec;       
        PricebookEntry pbEntry=MFS_TestDataUtility.createPriceBEntry(prodRec);       
        insert pbEntry; 
        OpportunityLineItem oppLI=MFS_TestDataUtility.createOpportunityLineItem(oppRec,pbEntry.Id);
        insert oppLI;
        oppRec.StageName='Funded'; 
        update oppRec;
        MFS_OpportunityAdditionalFlows oppAFCtrl = new MFS_OpportunityAdditionalFlows(new ApexPages.StandardController(oppRec));
        pagereference pageRef=oppAFCtrl.redirect();        
        pageRef=oppAFCtrl.redirect();
        System.assert(pageRef!=null);
        Test.stopTest();
    }
}