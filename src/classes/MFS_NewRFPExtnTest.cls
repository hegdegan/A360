@isTest
public class MFS_NewRFPExtnTest {
    
    static testMethod void testRedirectCase(){
        Test.startTest();
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Contact con = MFS_TestDataUtility.createContact(acc.Id);
        insert con;
        Case cse = MFS_TestDataUtility.createCase(con);
        insert cse;
        PMAPS__c pmap = new PMAPS__c(Service_Request__c=cse.Id);
        List<PMAPS__c> pmapList = new List<PMAPS__c>();
        pmapList.add(pmap);
        StoreFieldIds__c sfId = new StoreFieldIds__c(name='-1914A7281271',Field_API_Name__c='Opportunity__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='PMAPS__c',Field_Label__c='Opportunity__c');
        insert sfId;
        StoreFieldIds__c sfId1 = new StoreFieldIds__c(name='-1914A7B281272',Field_API_Name__c='Org_Name__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='PMAPS__c',Field_Label__c='Org_Name__c');
        insert sfId1;
        StoreFieldIds__c sfId2 = new StoreFieldIds__c(name='-1914AC7281273',Field_API_Name__c='Sales_Person_Relationship_Manager__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='PMAPS__c',Field_Label__c='Sales_Person_Relationship_Manager__c');
        insert sfId2;
        StoreFieldIds__c sfId3 = new StoreFieldIds__c(name='-1914A7D281274',Field_API_Name__c='Business_Type__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='PMAPS__c',Field_Label__c='Business_Type__c');
        insert sfId3;
        StoreFieldIds__c sfId4 = new StoreFieldIds__c(name='-1914A7D281275',Field_API_Name__c='Service_Request__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='PMAPS__c',Field_Label__c='Business_Type__c');
        insert sfId4;
        
        MFS_NewRFPExtn hhExtn = new MFS_NewRFPExtn(new ApexPages.StandardSetController(pmapList));   
        PageReference pr =  new PageReference('/'+cse.id);
        pr.getParameters().put('Id',cse.id); 
        test.setCurrentPage(pr);
        PageReference pageURL = hhExtn.redirect();
        //System.assert(pageURL!=null); 
        Test.stopTest();
        
    }
    
    static testMethod void testRedirectOpportunity(){
        Test.startTest();
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Opportunity opp = MFS_TestDataUtility.createOpportunity(acc.Id);
        insert opp;
        PMAPS__c pmap = new PMAPS__c();
        List<PMAPS__c> pmapList = new List<PMAPS__c>();
        pmapList.add(pmap);
        StoreFieldIds__c sfId = new StoreFieldIds__c(name='-1914A7281271',Field_API_Name__c='Opportunity__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='PMAPS__c',Field_Label__c='Opportunity__c');
        insert sfId;
        StoreFieldIds__c sfId1 = new StoreFieldIds__c(name='-1914A7B281272',Field_API_Name__c='Org_Name__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='PMAPS__c',Field_Label__c='Org_Name__c');
        insert sfId1;
        StoreFieldIds__c sfId2 = new StoreFieldIds__c(name='-1914AC7281273',Field_API_Name__c='Sales_Person_Relationship_Manager__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='PMAPS__c',Field_Label__c='Sales_Person_Relationship_Manager__c');
        insert sfId2;
        StoreFieldIds__c sfId3 = new StoreFieldIds__c(name='-1914A7D281274',Field_API_Name__c='Business_Type__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='PMAPS__c',Field_Label__c='Business_Type__c');
        insert sfId3;
        StoreFieldIds__c sfId4 = new StoreFieldIds__c(name='-1914A7D281275',Field_API_Name__c='Service_Request__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='PMAPS__c',Field_Label__c='Business_Type__c');
        insert sfId4;
        
        MFS_NewRFPExtn hhExtn = new MFS_NewRFPExtn(new ApexPages.StandardSetController(pmapList));   
        PageReference pr =  new PageReference('/'+opp.id);
        pr.getParameters().put('Id',opp.id); 
        test.setCurrentPage(pr);
        PageReference pageURL = hhExtn.redirect();
        //System.assert(pageURL!=null); 
        Test.stopTest();
        
    }
}