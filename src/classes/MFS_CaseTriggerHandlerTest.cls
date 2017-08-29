@isTest
public class MFS_CaseTriggerHandlerTest {
    static testmethod void testBusinessDays(){
        Test.StartTest();
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;        
        User us = MFS_TestDataUtility.createUser('System Administrator');
        us.Country = 'Brazil';
        insert us;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;         
        Case csRec = MFS_TestDataUtility.createCase(cont);
        csRec.recordtypeid= Schema.SObjectType.Case.getRecordTypeInfosByName().get('Onboarding').getRecordtypeId();
        csRec.AccountId = acc.Id;
        csRec.Type = 'Cash';
        csRec.Priority = 'Low';
        csRec.Status = 'Service';
        csRec.OwnerId = us.Id;
        csRec.Due_Date__c = System.today();
        insert csRec;
        System.assert(csRec != null);
        Test.StopTest();
    }
    
    static testmethod void testCaseTeam(){
        Test.StartTest();
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;        
        Opportunity opp= MFS_TestDataUtility.createOpportunity(acc.Id);   
        insert opp;
        Opportunity opp1= MFS_TestDataUtility.createOpportunity(acc.Id);   
        insert opp1;
        List<OpportunityTeamMember> oppTmember=[Select id, TeamMemberRole from OpportunityTeamMember where OpportunityId=:opp.id];
        OpportunityTeamMember oppTeamM=oppTmember.get(0);
        oppTeamM.TeamMemberRole='Account Manager';
        update oppTeamM;
        Case csRec = new Case();	
        csRec.RecordTypeId= Schema.SObjectType.Case.getRecordTypeInfosByName().get('Onboarding').getRecordtypeId();
        csRec.AccountId = acc.Id;        
        csRec.Status = 'Service';     
        csRec.Related_To_Opportunity__c=  opp.Id;       
        insert csRec;
        
        Set<Id> caseIds=new Set<id>();
        caseIds.add(csRec.id);
        MFS_CaseTriggerHandler.addTeamMember(caseIds); 
        List<CaseTeamMember> caseTeamMember=[Select id from CaseTeamMember where parentId=:csRec.Id];       
        System.assert(caseTeamMember.size()==1);
        oppTeamM.TeamMemberRole='Institutional Sales';
        update oppTeamM; 
        MFS_CaseTriggerHandler.updateTeamMember(caseIds);
        MFS_Utilities.runReset();
        csRec.Related_To_Opportunity__c=  opp1.Id;
        update csRec;
        Test.StopTest();
    }
    
    
    
}