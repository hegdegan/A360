@isTest(SeeAllData=false)
public class MFS_NewRESOpportunityTest {
    
    static testmethod void testRedirect(){
        Test.startTest();
        Id accRecordType=Schema.SObjectType.Account.getRecordTypeInfosByName().get(MFS_AllConstants.ACC_CLIENT_RECTYPE).getRecordTypeId();
        Account accRec=MFS_TestDataUtility.createAccount();
        accRec.RecordTypeId=accRecordType;
        insert accRec;
        Contact con = MFS_TestDataUtility.createContact(accRec.Id);
        insert con;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.Id);
        insert oppRec;
        List<StoreFieldIds__c> fieldIds=new List<StoreFieldIds__c>();
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Opportunity','Client Contact','Client_Contact__c'));
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Opportunity','Name','Name'));
        insert fieldIds;
        List<Opportunity> oppList = new List<Opportunity>{oppRec};
        PageReference pageRef = Page.MFS_NewRESOpp;
        pageRef.getParameters().put('Id',con.Id);
        Test.setCurrentPage(pageRef);
        MFS_NewRESOpportunity newOpp=new MFS_NewRESOpportunity(new ApexPages.StandardSetController(oppList));   
        PageReference pageURL=newOpp.redirect();    
        System.assert(pageURL != null);  
        //Exception Case
        pageRef.getParameters().put('Id',accRec.Id);
        Test.setCurrentPage(pageRef);
        MFS_NewRESOpportunity newOpp1=new MFS_NewRESOpportunity(new ApexPages.StandardSetController(oppList));   
        PageReference pageURL1=newOpp1.redirect();
        Test.stopTest();
    }

}