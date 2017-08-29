@isTest(SeeAllData=false)
public class MFS_NewInstutionalConsOpp_Test {
    
    static testmethod void testRedirect()
    {
        Test.startTest();
        Id accRecordType=Schema.SObjectType.Account.getRecordTypeInfosByName().get(MFS_AllConstants.ACC_CLIENT_RECTYPE).getRecordTypeId();
        Account accRec=MFS_TestDataUtility.createAccount();
        accRec.RecordTypeId=accRecordType;
        insert accRec;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.Id);
        insert oppRec;
        List<StoreFieldIds__c> fieldIds=new List<StoreFieldIds__c>();
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Opportunity','Account','Account'));
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Opportunity','Name','Name'));
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Opportunity','Region','Region'));
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Opportunity','Consultant?','Is_Consultant__c'));
        insert fieldIds;
        List<Opportunity> oppList = new List<Opportunity>{oppRec};
        PageReference pageRef = Page.MFS_NewInstutionalConsOpp;
        pageRef.getParameters().put('Id',accRec.Id);
        Test.setCurrentPage(pageRef);
        MFS_NewInstutionalConsOpp newOpp=new MFS_NewInstutionalConsOpp(new ApexPages.StandardSetController(oppList));   
        PageReference pageURL=newOpp.redirect();    
        System.assert(pageURL!=null);             
        Test.stopTest();
    }
    
}