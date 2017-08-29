/***************************************************************************************************
Apex Class Name    : MFS_OpportunityProductHandler_Test 
Version            : 1.0 
Created Date       : 15 JUNE 2016
Function           : Test Class for MFS_OpportunityProductHandler
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               15/06/2016              Original Version
***************************************************************************************************/
@isTest
public class MFS_OpportunityProductHandler_Test {
    
    static testmethod void testBeforeInsertTriggerHandler(){        
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
        oppLI.Is_First_Strategy__c=true;
        insert oppLI;
        update oppLI;
        
        OpportunityLineItem oppLIUnknow=MFS_TestDataUtility.createOpportunityLineItem(oppRec,pbEntry.Id);
        oppLIUnknow.Is_Unknown__c=true;
        insert oppLIUnknow;
        System.assert(oppLI.id!=null);
        delete oppLIUnknow;
       
    }

}