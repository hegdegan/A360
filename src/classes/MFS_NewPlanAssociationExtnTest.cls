@isTest
public class MFS_NewPlanAssociationExtnTest {

    static testMethod void testRedirect(){
        Test.startTest();
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Contact cont = MFS_TestDataUtility.createContact(acc.Id);
        insert cont;
        Plan_Association__c planAsn = new Plan_Association__c(Contact__c=cont.Id);
        List<Plan_Association__c> plnList = new List<Plan_Association__c>();
        plnList.add(planAsn);
        StoreFieldIds__c sfId = new StoreFieldIds__c(name='-1914A728123',Field_API_Name__c='Contact__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='Plan_Association__c',Field_Label__c='Contact');
        insert sfId;
        
        StoreFieldIds__c sfId1 = new StoreFieldIds__c(name='-1914A7B28127',Field_API_Name__c='Organization__c',Field_Id__c='CF00NP0000000smyR',Object_Name__c='Plan_Association__c',Field_Label__c='Organization__c');
        insert sfId1;
        
        
        MFS_NewPlanAssociationExtn hhExtn = new MFS_NewPlanAssociationExtn(new ApexPages.StandardSetController(plnList));   
        PageReference pr =  new PageReference('/'+cont.id);
        pr.getParameters().put('Id',cont.id); 
        test.setCurrentPage(pr);
        PageReference pageURL = hhExtn.redirect();
        System.assert(pageURL!=null);
        Test.stopTest();
        
    }
}