@isTest(seeAllData=false)
public class MFS_ETDataRequestTest {
    static testmethod void dataRequestTest()
    {
        Account acct = new Account();
        acct = MFS_TestDataUtility.createAccount();
        Test.StartTest();
        insert acct;
        System.assert(acct != null);
        
        Relationship__c rltn1 = new Relationship__c(Type__c='Consultant',Relationship__c=acct.Id,Organization__c=acct.Id,Start_Date__c=System.Today());
        insert rltn1;
        
        Contact cont = MFS_TestDataUtility.createContact(acct.id);
        insert cont;
        
        User demo1 = MFS_TestDataUtility.createUser('Global Institutional Sales');
        insert demo1;
        User demo2 = MFS_TestDataUtility.createUser('System Administrator');
        demo2.UserName = 'unique_test@mfstest.com1';
        insert demo2;
       
        Case cse = MFS_TestDataUtility.createCase(cont);
        insert cse;
        System.assert(cse != null);
        
        Product2 prd = MFS_TestDataUtility.createProduct();
        prd.Portfolio_Code__c = 'ONL';
        prd.Vehicle__c = 'Private Segregated';
        insert prd;
        Product2 prd1 = MFS_TestDataUtility.createProduct();
        prd1.Portfolio_Code__c = 'Test';
        prd1.Vehicle__c = 'Domestic Institutional Trust';
        insert prd1;
        
        Share_Classes__c sc = new Share_Classes__c(Name = 'test');
        insert sc;
        
        Account__c clientInv = new Account__c(Organization__c=acct.Id,Portfolio__c=prd.Id,Share_Class__c=sc.Id,Reporting_Currency__c='USD: United States Dollar');
        insert clientInv;
        Account__c clientInv1 = new Account__c(Organization__c=acct.Id,Portfolio__c=prd1.Id,Share_Class__c=sc.Id,Reporting_Currency__c='USD: United States Dollar');
        insert clientInv1;
        
        Investments_Needing_Service__c ins = new Investments_Needing_Service__c();
        ins.Case__c = cse.id;
        ins.Investment__c = clientInv.Id;
        insert ins;
        Investments_Needing_Service__c ins1 = new Investments_Needing_Service__c();
        ins1.Case__c = cse.id;
        ins1.Investment__c = clientInv1.Id;
        insert ins1;
        
        CaseTeamMember atm1 = new CaseTeamMember(memberId = demo1.Id,parentId=cse.Id,teamRoleId=System.Label.Case_Team_Role_RM);
        insert atm1;
        CaseTeamMember atm2 = new CaseTeamMember(memberId = demo2.Id,ParentId=cse.Id,teamRoleId=System.Label.Case_Team_Role_CSM);
        insert atm2;
        
        Test.StopTest(); 
        
        MFS_ETDataRequest edr = new MFS_ETDataRequest();
        edr.caseId=cse.id;
        edr.getCase();
        Account accTest = edr.getOrgDetails();
        //system.assertEquals(acct.id, accTest.id);
        CaseTeamMember ccr = [Select member.Name from CaseTeamMember where id =: atm1.Id];
        //System.assertEquals(ccr.member.Name, edr.relationshipManager);
        Relationship__c rlc = [Select Relationship__r.Name from Relationship__c where Id =: rltn1.Id];
        //System.assertEquals(rlc.Relationship__r.Name, edr.consultant);
        
    }
}