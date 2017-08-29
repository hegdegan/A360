@isTest
public class MFS_NewAccSummary_Test {
    
    static testmethod void testEmailtemplate()
    {
        Account acct = new Account();
        acct = MFS_TestDataUtility.createAccount();
        Test.StartTest();
        insert acct;
        System.assert(acct != null);
        List<User> userList = new List<User>();
        User demo1 = MFS_TestDataUtility.createUser('Global Institutional Sales');
        userList.add(demo1);
        User demo2 = MFS_TestDataUtility.createUser('System Administrator');
        demo2.UserName = 'unique_test@mfstest.com1';
        userList.add(demo2);
        User demo3 = MFS_TestDataUtility.createUser('Standard User');
        demo3.UserName = 'unique_test@mfstest.com2';
        userList.add(demo3);
        User demo4 = MFS_TestDataUtility.createUser('Global Institutional Sales');
        demo4.UserName = 'unique_test@mfstest.com3';
        userList.add(demo4);
        User demo5 = MFS_TestDataUtility.createUser('Standard User');
        demo5.UserName = 'unique_test@mfstest.com4';
        userList.add(demo5);
        User demo6 = MFS_TestDataUtility.createUser('Standard User');
        demo6.UserName = 'unique_test@mfstest.com5';
        userList.add(demo6);
        User demo7 = MFS_TestDataUtility.createUser('Standard User');
        demo7.UserName = 'unique_test@mfstest.com6';
        userList.add(demo7);
        insert userList;
        
        List<Relationship__c> relationshipList = new List<Relationship__c>();
        Relationship__c rltn1 = new Relationship__c(Type__c='Record Keeper',Relationship__c=acct.Id,Organization__c=acct.Id,Start_Date__c=System.Today());
        relationshipList.add(rltn1);
        Relationship__c rltn2 = new Relationship__c(Type__c='Custody Bank',Relationship__c=acct.Id,Organization__c=acct.Id,Start_Date__c=System.Today());
        relationshipList.add(rltn2);
        Relationship__c rltn3 = new Relationship__c(Type__c='Record Keeper',Relationship__c=acct.Id,Organization__c=acct.Id,Start_Date__c=System.Today());
        relationshipList.add(rltn3);
        insert relationshipList;
        
        Opportunity opp = MFS_TestDataUtility.createOpportunity(acct.Id);
        insert opp;
        System.assert(opp != null);
        List<Contact> contactList = new List<Contact>();
        Contact cont1 = MFS_TestDataUtility.createContact(acct.id);
        cont1.Contact_role__c = 'Transition Manager';
        contactList.add(cont1);
        Contact cont2 = MFS_TestDataUtility.createContact(acct.id);
        cont2.Contact_role__c = 'ACS Distributor';  
        contactList.add(cont2);
        Contact cont3 = MFS_TestDataUtility.createContact(acct.id);
        cont3.Contact_role__c = 'Sales Person';  
        contactList.add(cont3);
        Contact cont4 = MFS_TestDataUtility.createContact(acct.id);
        cont4.Contact_role__c = 'Transition Manager';
        contactList.add(cont4);
        Contact cont5 = MFS_TestDataUtility.createContact(acct.id);
        cont5.Contact_role__c = 'ACS Distributor'; 
        contactList.add(cont5);
        Contact cont6 = MFS_TestDataUtility.createContact(acct.id);
        cont6.Contact_role__c = 'Sales Person';  
        contactList.add(cont6);
        insert contactList;
        
        Case cse = MFS_TestDataUtility.createCase(cont1);
        cse.Related_To_Opportunity__c = opp.Id;
        insert cse;
        System.assert(cse != null);
        
        List<CaseTeamMember> caseTeamMemList = new List<CaseTeamMember>();
        CaseTeamMember atm1 = new CaseTeamMember(memberId = demo1.Id,ParentId=cse.Id,teamRoleId=System.Label.Case_Team_Role_PM);
        caseTeamMemList.add(atm1);
        CaseTeamMember atm2 = new CaseTeamMember(memberId = demo2.Id,ParentId=cse.Id,teamRoleId=System.Label.Case_Team_Role_RM);
        caseTeamMemList.add(atm2);
        CaseTeamMember atm3 = new CaseTeamMember(memberId = demo3.Id,parentId=cse.Id,teamRoleId=System.Label.Case_Team_Role_IS);
        caseTeamMemList.add(atm3);
        CaseTeamMember atm4 = new CaseTeamMember(memberId = demo4.Id,ParentId=cse.Id,teamRoleId=System.Label.Case_Team_Role_CSM);
        caseTeamMemList.add(atm4);
        CaseTeamMember atm5 = new CaseTeamMember(memberId = userinfo.getuserId(),ParentId=cse.Id,teamRoleId=System.Label.Case_Team_Role_IS);
        caseTeamMemList.add(atm5);
        CaseTeamMember atm6 = new CaseTeamMember(memberId = demo5.Id,ParentId=cse.Id,teamRoleId=System.Label.Case_Team_Role_PM);
        caseTeamMemList.add(atm6);
        CaseTeamMember atm7 = new CaseTeamMember(memberId = demo6.Id,ParentId=cse.Id,teamRoleId=System.Label.Case_Team_Role_RM);
        caseTeamMemList.add(atm7);
        CaseTeamMember atm8 = new CaseTeamMember(memberId = demo7.Id,ParentId=cse.Id,teamRoleId=System.Label.Case_Team_Role_CSM);
        caseTeamMemList.add(atm8);
        insert caseTeamMemList;
        
        List<Case_Contact_Role__c> caseContRoleList = new List<Case_Contact_Role__c>();
        Case_Contact_Role__c ccr1 = new Case_Contact_role__c(Contact__c=cont1.Id,Case__c=cse.Id);
        caseContRoleList.add(ccr1);
        Case_Contact_Role__c ccr2 = new Case_Contact_role__c(Contact__c=cont2.Id,Case__c=cse.Id);
        caseContRoleList.add(ccr2);
        Case_Contact_Role__c ccr3 = new Case_Contact_role__c(Contact__c=cont3.Id,Case__c=cse.Id);
        caseContRoleList.add(ccr3);
        Case_Contact_Role__c ccr4 = new Case_Contact_role__c(Contact__c=cont4.Id,Case__c=cse.Id);
        caseContRoleList.add(ccr4);
        Case_Contact_Role__c ccr5 = new Case_Contact_role__c(Contact__c=cont5.Id,Case__c=cse.Id);
        caseContRoleList.add(ccr5);
        Case_Contact_Role__c ccr6 = new Case_Contact_role__c(Contact__c=cont6.Id,Case__c=cse.Id);
        caseContRoleList.add(ccr6);
        insert caseContRoleList;
        
        Test.StopTest();
        
        MFS_NewAccSummary eTemplate = new MFS_NewAccSummary();
        eTemplate.CaseId = cse.Id;
        eTemplate.getCaseRec();
        
        Relationship__c rlc = [Select Relationship__r.Name from Relationship__c where Id =: rltn2.Id];
        //System.assertEquals(rlc.Relationship__r.Name, eTemplate.custodyBank);
        
        //exception Coverage
        eTemplate.CaseId = null;
        eTemplate.getCaseRec();
    }
    
    
}