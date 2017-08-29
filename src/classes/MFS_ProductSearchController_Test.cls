/***************************************************************************************************
Apex Class Name    : MFS_ProductSearchController_Test 
Version            : 1.0 
Created Date       : 16 MAY 2016
Function           : Test class for MFS_ProductSearchController
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               16/05/2016              Original Version
***************************************************************************************************/
@isTest
public class MFS_ProductSearchController_Test {  
    static testmethod void testUnknownStrategy()
    {
       Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.id);
        insert oppRec;       
        Product2 prodRec=MFS_TestDataUtility.createProduct();
        prodRec.Is_Unknown__c=true;
        insert prodRec;  
        PricebookEntry pbEntry=MFS_TestDataUtility.createPriceBEntry(prodRec);       
        insert pbEntry; 		
        Test.setCurrentPage(Page.MFS_ProductSearch);        
        MFS_ProductSearchController prdSCtrl = new MFS_ProductSearchController(new ApexPages.StandardController(oppRec)); 
        PricebookEntry pbEnt = [select Product2.Name,Product_Vehicle__c,Restricted__c,Asset_Class_Geography__c from PricebookEntry where Id =:pbEntry.Id];
        System.debug('pbEntry:'+pbEnt);        
        prdSCtrl.selectedAssetGeography=pbEnt.Asset_Class_Geography__c; 
        prdSCtrl.addUnknownStrategy();
        //SONAR Fix
        System.assert((prdSCtrl.oppLineItems).size()>0);
        Test.stopTest();
    }
   
     static testmethod void testAddWithFirstStrategy(){
        Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.id);
        insert oppRec;       
        Product2 prodRec=MFS_TestDataUtility.createProduct();
        insert prodRec;  
        PricebookEntry pbEntry=MFS_TestDataUtility.createPriceBEntry(prodRec);       
        insert pbEntry; 		
        Test.setCurrentPage(Page.MFS_ProductSearch);        
        MFS_ProductSearchController prdSCtrl = new MFS_ProductSearchController(new ApexPages.StandardController(oppRec)); 
        PricebookEntry pbEnt = [select Product2.Name,Product_Vehicle__c,Restricted__c,Asset_Class_Geography__c from PricebookEntry where Id =:pbEntry.Id];
        System.debug('pbEntry:'+pbEnt);
        prdSCtrl.searchOpt=pbEnt.Product2.Name; 
        prdSCtrl.selectedAssetGeography=pbEnt.Asset_Class_Geography__c;
        prdSCtrl.selectedVehicle=pbEnt.Product_Vehicle__c;
        prdSCtrl.searchProduct();
        prdSCtrl.toSelect=pbEnt.Product2.Name; 
        prdSCtrl.addToLineItem(); 
        System.assert((prdSCtrl.oppLineItems).size()>0);
        prdSCtrl.oppLineItems[0].Fee_Structure__c='Custom';       
        prdSCtrl.onSave();
        prdSCtrl.onCancel();  
        Test.stopTest();
     }
      
    static testmethod void testRemoveWithFirststrategy()
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
        Test.setCurrentPage(Page.MFS_ProductSearch);        
        MFS_ProductSearchController prdSCtrl = new MFS_ProductSearchController(new ApexPages.StandardController(oppRec)); 
        PricebookEntry pbEnt = [select Product2.Name,Product_Vehicle__c,Restricted__c,Asset_Class_Geography__c from PricebookEntry where Id =:pbEntry.Id];
        System.debug('pbEntry:'+pbEnt);
        prdSCtrl.searchOpt=pbEnt.Product2.Name; 
        prdSCtrl.selectedAssetGeography=pbEnt.Asset_Class_Geography__c;
        prdSCtrl.selectedVehicle=pbEnt.Product_Vehicle__c;
        prdSCtrl.searchProduct();
        prdSCtrl.toSelect=pbEnt.Product2.Name; 
        prdSCtrl.addToLineItem();
        prdSCtrl.toUnselect=pbEntry.Id;   
        prdSCtrl.removeFromLineItem();
        System.assert((prdSCtrl.oppLineItems).size()==0);
        Test.stopTest();
    }
    
    static testmethod void testAddRemoveWithMultiStrategy(){
        Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.id);
        insert oppRec;       
        Product2 prodRec=MFS_TestDataUtility.createProduct();
        insert prodRec;  
        PricebookEntry pbEntry=MFS_TestDataUtility.createPriceBEntry(prodRec);       
        insert pbEntry; 
        OpportunityLineItem oppLi=MFS_TestDataUtility.createOpportunityLineItem(oppRec.id, pbEntry.id);
        oppLi.Is_First_Strategy__c=true;
        insert oppLi;
        Product2 prodRec1=MFS_TestDataUtility.createProduct();
        prodRec1.Name='TestProduct2';
        insert prodRec1;  
        PricebookEntry pbEntry1=MFS_TestDataUtility.createPriceBEntry(prodRec1);       
        insert pbEntry1;
        Test.setCurrentPage(Page.MFS_ProductSearch);        
        MFS_ProductSearchController prdSCtrl = new MFS_ProductSearchController(new ApexPages.StandardController(oppRec)); 
        PricebookEntry pbEnt = [select Product2.Name,Product_Vehicle__c,Restricted__c,Asset_Class_Geography__c from PricebookEntry where Id =:pbEntry1.Id];
        System.debug('pbEntry:'+pbEnt);
        prdSCtrl.searchOpt=pbEnt.Product2.Name; 
        prdSCtrl.searchProduct();
        prdSCtrl.toSelect=pbEnt.Product2.Name; 
        prdSCtrl.addToLineItem(); 
        System.assert((prdSCtrl.oppLineItems).size()>0);
        prdSCtrl.toUnselect=pbEntry.Id;   
        prdSCtrl.removeFromLineItem();
        prdSCtrl.oppLineItems[0].Fee_Structure__c='Standard';
        prdSCtrl.onSave();
        prdSCtrl.onCancel();   
        List<Selectoption> vehicleOpt=prdSCtrl.getVehicleOptions();
        System.assert(vehicleOpt.size()>0);
         List<Selectoption> assetClOpt=prdSCtrl.getGeograhpyOptions();
        System.assert(assetClOpt.size()>0);
        Test.stopTest();
        
     }
    static testmethod void testException(){
        Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.id);
        insert oppRec;       
        Product2 prodRec=MFS_TestDataUtility.createProduct();
        prodRec.Is_Unknown__c=true;
        insert prodRec;  
        PricebookEntry pbEntry=MFS_TestDataUtility.createPriceBEntry(prodRec);       
        insert pbEntry; 
        delete oppRec;
        Test.setCurrentPage(Page.MFS_ProductSearch);        
        MFS_ProductSearchController prdSCtrl = new MFS_ProductSearchController(new ApexPages.StandardController(oppRec)); 
        prdSCtrl.addUnknownStrategy();
        prdSCtrl.onSave();
        prdSCtrl.addToLineItem();
        prdSCtrl.searchProduct();
        //SONAR Fix
        System.assert((prdSCtrl.oppLineItems) == null);
        Test.stopTest();
    }

}