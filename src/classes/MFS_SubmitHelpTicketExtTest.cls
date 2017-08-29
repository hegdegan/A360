@isTest
public class MFS_SubmitHelpTicketExtTest {
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
      
        
        Test.setCurrentPage(Page.MFS_SubmitHelpTicket);
        MFS_SubmitHelpTicketExt tkt=new MFS_SubmitHelpTicketExt(new ApexPages.StandardController(accRec));   
        PageReference pageURL=tkt.redirect();    
        System.assert(pageURL!=null); 
        MFS_SubmitHelpTicketExt tktchkexc=new MFS_SubmitHelpTicketExt(new ApexPages.StandardController(cont));
        
        Account accRec1=MFS_TestDataUtility.createAccount();
        MFS_SubmitHelpTicketExt tkt1=new MFS_SubmitHelpTicketExt(new ApexPages.StandardController(accRec1));   
        PageReference pageURL1=tkt1.redirect();
        Test.stopTest();
    }
}