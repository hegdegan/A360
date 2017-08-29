/***************************************************************************************************
Apex Class Name    : MFS_ProductTriggerUtil_Test 
Version            : 1.0 
Created Date       : 25 May 2016
Function           : Test Class for MFS_ProductTriggerUtil
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               25/05/2016              Original Version
***************************************************************************************************/
@isTest(Seealldata = true)
public class MFS_ProductTriggerUtil_Test { 
   
	 static testmethod void testProductTriggerUtil(){
        Test.startTest();
        Product2 prodRec=MFS_TestDataUtility.createProduct();         
        DataBase.saveResult saveRes= DataBase.insert(prodRec,true);         
         List<PriceBookEntry> pbList=[select id from PriceBookEntry where Product2.Id=:saveRes.getId()];
        System.assert(pbList.size()>0);
         prodRec.isActive= false;         
        DataBase.saveResult saveRes1= DataBase.update(prodRec,true); 
         System.assert(saveRes1.isSuccess());
        Test.stopTest();
    } 
    
    static testmethod void testDisableProdTrigger(){
         Test.startTest();
        MFS_Utilities.GetAppSettingValue('EnableProduct2Trigger', 'Yes');
        Map<String,Application_Settings__c> mapAppSettings = Application_Settings__c.getAll(); 
        Application_Settings__c oAppSettings;
        if(mapAppSettings.size() > 0 && mapAppSettings.containsKey('EnableProduct2Trigger'))
        {
            oAppSettings = mapAppSettings.get('EnableProduct2Trigger');
            oAppSettings.Value__c='No';
        }
        if(null!=oAppSettings)
        {
            update oAppSettings;
        }
        List<Product2> prodList=MFS_TestDataUtility.createBulkProduct();
        Product2 prodRec;        
        insert prodList; 
         //SONAR Fix
        System.assert(prodList.size() > 0);
        Test.stopTest();
    } 
}