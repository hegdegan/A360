@isTest(SeeAllData=false)
public class MFS_AddTeamMember_Test {

     static testmethod void testRedirect(){
        Test.startTest();
       
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Contact contactRec=MFS_TestDataUtility.createContact(accRec.Id);
        insert contactRec;
        List<StoreFieldIds__c> fieldIds=new List<StoreFieldIds__c>();
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Team_Member__c','Contact','Contact__c'));       
        insert fieldIds;
        List<Team_Member__c> memberList = new List<Team_Member__c>{new Team_Member__c()};
        PageReference pageRef = Page.MFS_AddContactTeamMember;
        pageRef.getParameters().put('Id',contactRec.Id);
        Test.setCurrentPage(pageRef);
        MFS_AddTeamMember addMember=new MFS_AddTeamMember(new ApexPages.StandardSetController(memberList));   
        PageReference pageURL=addMember.redirect();    
        System.assert(pageURL!=null);             
        Test.stopTest();
    }
    
}