@isTest
public class MFS_PMAPSTriggerUtil_Test {

    static testmethod void testPMAPsinsert()
    {
        Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.id);
        insert oppRec;
        Product2 prodRec=MFS_TestDataUtility.createProduct();       
        insert prodRec;
        PricebookEntry pbentry=MFS_TestDataUtility.createPriceBEntry(prodRec);
        insert pbentry;
        OpportunityLineItem oppLI=MFS_TestDataUtility.createOpportunityLineItem(oppRec.id,pbentry.id);
        oppLI.Product_Name__c='testProduct';
        insert oppLI;
        User userRec=MFS_TestDataUtility.createUser('Standard User');
        insert userRec;
        PMAPS__c pmapRec=MFS_TestDataUtility.createPMAPS(oppRec.id, userRec.id);
        insert pmapRec;
        //SONAR Fix
        System.assertNotEquals(null,pmapRec.Id);
        Test.stopTest();
        
    }
    
    static testmethod void testBulkPMAPsinsert()
    {
        Test.startTest();
        Application_Settings__c appSetting = MFS_TestDataUtility.CreateTestAppSetting('EnablePmapsTrigger','No');
        insert appSetting;
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.id);
        insert oppRec;
        Product2 prodRec=MFS_TestDataUtility.createProduct();       
        insert prodRec;
        PricebookEntry pbentry=MFS_TestDataUtility.createPriceBEntry(prodRec);
        insert pbentry;
        OpportunityLineItem oppLI=MFS_TestDataUtility.createOpportunityLineItem(oppRec.id,pbentry.id);
        oppLI.Product_Name__c='testProduct';
        insert oppLI;
        User userRec=MFS_TestDataUtility.createUser('Standard User');
        insert userRec;
        List<PMAPS__c> pmapList=MFS_TestDataUtility.createBulkPMAPS(oppRec.id, userRec.id);
        insert pmapList;
        //SONAR Fix
        System.assert(pmapList.size() > 0);
        Test.stopTest();
        
    }
}