@isTest(SeeAllData=false)
public class MFS_RequestToJoinMFSTeam_Test {

     static testmethod void testRedirect()
    {
        Test.startTest();
       
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Contact contactRec=MFS_TestDataUtility.createContact(accRec.Id);
        insert contactRec;
         List<StoreFieldIds__c> fieldIds=new List<StoreFieldIds__c>();
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Case','Contact','Contact'));
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Case','Subject','Subject'));
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Case','Organization','Account'));
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Case','Team Member','Team_Member__c'));
        //fieldIds.add(MFS_TestDataUtility.createFieldIDData('Case','Organization','Account'));
        insert fieldIds;
        
        AcctTeamAppCustomSettings__c accSettings  = new AcctTeamAppCustomSettings__c(name='Default',AccountId__c='',AccountName__c='',Admin_Profile_Id__c='',
                                                                                    editUrl__c='',RecordType_Approval__c='',RecordType_Removal__c='',
                                                                                    Requester__c='',Team_Member__c='',Team_Member_lkid__c='');
        insert accSettings;
        
        List<Coverage_Team__c> coverageList = new List<Coverage_Team__c>{new Coverage_Team__c()};
        PageReference pageRef = Page.MFS_RequestToJoinMFSTeam;
        pageRef.getParameters().put('Id',contactRec.Id);
        Test.setCurrentPage(pageRef);
        MFS_RequestToJoinMFSTeam coverageRequest=new MFS_RequestToJoinMFSTeam(new ApexPages.StandardSetController(coverageList));   
        PageReference pageURL=coverageRequest.redirect();    
        System.assert(pageURL!=null);             
        Test.stopTest();
    }
    
    
}