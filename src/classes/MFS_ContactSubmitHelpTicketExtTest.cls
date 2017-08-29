@isTest
public class MFS_ContactSubmitHelpTicketExtTest {
static testmethod void testRedirect()
    {
        Test.startTest();
       
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Contact cont = MFS_TestDataUtility.createContact(accRec.Id);
        insert cont;
        
        StoreFieldIds__c sfId = new StoreFieldIds__c(name='979820341',Field_API_Name__c='Requester__c',Field_Id__c='CF00NP00000015qq4',Object_Name__c='Case',Field_Label__c='ERequester');
        insert sfId;
        
        StoreFieldIds__c sfId1 = new StoreFieldIds__c(name='979820337',Field_API_Name__c='Organization__c',Field_Id__c='CF00NP0000000sjA9',Object_Name__c='Case',Field_Label__c='Organization');
        insert sfId1;
        
        StoreFieldIds__c sfId2 = new StoreFieldIds__c(name='1019494569',Field_API_Name__c='Contact',Field_Id__c='cas3',Object_Name__c='Case',Field_Label__c='Contact Name');
        insert sfId2;
        
        Test.setCurrentPage(Page.MFS_ContactSubmitHelpTicket);
        MFS_ContactSubmitHelpTicketExt tkt=new MFS_ContactSubmitHelpTicketExt(new ApexPages.StandardController(cont));   
        PageReference pageURL=tkt.redirect();    
        System.assert(pageURL!=null); 
        MFS_ContactSubmitHelpTicketExt tktchkexc=new MFS_ContactSubmitHelpTicketExt(new ApexPages.StandardController(accRec));
        tktchkexc.redirect();
        Test.stopTest();
    }
    
}