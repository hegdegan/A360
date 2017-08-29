@isTest
public class MFS_OppTeamController_Test {
    
    static testmethod void testOppTeamWithOneMember(){
        Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.id);
        insert oppRec;
        User userRec=MFS_TestDataUtility.createUser('Standard User');
        userRec.User_Role__c='Portfolio Manager';
        insert userRec;
        Test.setCurrentPage(Page.MFS_AddOppTeamMember);
        MFS_OppTeamController oppTCtrl = new MFS_OppTeamController(new ApexPages.StandardController(oppRec));
        oppTCtrl.getMemberList();
        System.assert(oppTCtrl.oppTeaWlist!=null);
        OpportunityTeamMember oppTeamM =oppTCtrl.oppTeaWlist.get(0).oppTeamMem;
        oppTeamM.userId=userRec.Id;
        oppTCtrl.selectedUserId=userRec.Id;
        oppTCtrl.selectedUserName=userRec.FirstName+' '+userRec.LastName;
        oppTeamM.OpportunityAccessLevel='Read';
        oppTCtrl.selectedRow=0;
        oppTCtrl.getUserRole();
        oppTCtrl.setUserRole();
        oppTCtrl.setOppAccess();
        oppTCtrl.setUserId();
        PageReference pageRef=oppTCtrl.saveTeamMember();
        System.assert(null!=pageRef) ;
        List<SelectOption> accessOpt=MFS_OppTeamController.getAccessLevel();
        System.assert(accessOpt.size()>0);
        
        Test.stopTest();
    }
    
     static testmethod void testOppTeamWithMultiMember(){
        Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.id);
        insert oppRec;
        User userRec=MFS_TestDataUtility.createUser('Standard User');
        userRec.User_Role__c='Portfolio Manager';
        insert userRec;
        Test.setCurrentPage(Page.MFS_AddOppTeamMember);
        OpportunityTeamMember oppTM=new OpportunityTeamMember(userId=userRec.Id,OpportunityId=oppRec.Id,OpportunityAccessLevel='Edit');
         insert oppTM;
        MFS_OppTeamController oppTCtrl = new MFS_OppTeamController(new ApexPages.StandardController(oppRec));
        oppTCtrl.getMemberList();
        System.assert(oppTCtrl.oppTeaWlist!=null);
        OpportunityTeamMember oppTeamM =oppTCtrl.oppTeaWlist.get(0).oppTeamMem;
        oppTeamM.userId=userRec.Id;
        oppTCtrl.selectedUserId=userRec.Id;
        oppTCtrl.selectedUserName=userRec.FirstName+' '+userRec.LastName;
        oppTeamM.OpportunityAccessLevel='Read';
        oppTCtrl.selectedRow=0;
        oppTCtrl.getUserRole();
        oppTCtrl.setUserRole();
        PageReference pageRef=oppTCtrl.saveTeamMember();
        System.assert(null!=pageRef) ;        
        Test.stopTest();
    }

}