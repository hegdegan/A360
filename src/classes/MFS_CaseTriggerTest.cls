@isTest(seeAllData = false)
public class MFS_CaseTriggerTest {
    
    static testMethod void testCaseTrigger(){
        Test.startTest();
        Account  acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Contact con = MFS_TestDataUtility.createContact(acc.Id);
        insert con;
        Opportunity opp = MFS_TestDataUtility.createOpportunity(acc.Id);
        insert opp;
        Case cs = MFS_TestDataUtility.createCase(con);
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Onboarding').getRecordtypeId();
        cs.Funding_Date__c = system.today();
        cs.Related_To_Opportunity__c = opp.Id;
        MFS_Utilities.runReset();
        insert cs;
        Opportunity opp1 = MFS_TestDataUtility.createOpportunity(acc.Id);
        insert opp1;
        cs.Related_To_Opportunity__c = opp1.Id;
        MFS_Utilities.runReset();
        update cs;
        try{
          List<CaseTeamMember> caseTeamList = new List<CaseTeamMember>([Select Id from CaseTeamMember where parentId =:cs.Id ]);
            system.assert(caseTeamList.size() == 0 );
        }catch(Exception e){
           system.debug('Excption in Case trigger Test'); 
        }
        
        Test.stopTest();
    }

}