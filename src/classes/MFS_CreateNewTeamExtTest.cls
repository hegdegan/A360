@isTest(SeeAllData=false)
public class MFS_CreateNewTeamExtTest {

    static testmethod void testRedirect(){
        Test.startTest();
        List<Team__c> memberList = new List<Team__c>{new Team__c(name='Team1')};
        //PageReference pageRef = Page.MFS_AddContactTeamMember;
        //pageRef.getParameters().put('Id',contactRec.Id);
        //Test.setCurrentPage(pageRef);
        MFS_CreateNewTeamExt addMember=new MFS_CreateNewTeamExt(new ApexPages.StandardSetController(memberList));  
        PageReference pageURL=addMember.redirect(); 
        //SONAR Fix
        system.assert(pageURL.getUrl() != null );
        Test.stopTest();
    }
}