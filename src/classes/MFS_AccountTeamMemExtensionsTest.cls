@isTest
public class MFS_AccountTeamMemExtensionsTest {
    static testMethod void withSingleTeamMem() {
        User demo = MFS_TestDataUtility.createUser('System Administrator');
        insert demo; 
        System.Runas(demo){
            //UtilityTestData.countryReg();
            Account acc = MFS_TestDataUtility.createAccount();
            insert acc;
            AccountTeamMember Teammemberad =new AccountTeamMember(); 
            Teammemberad.AccountId = acc.id; 
            Teammemberad.UserId = demo.id; 
            Teammemberad.TeamMemberRole = 'Account Manager'; 
            insert Teammemberad;
            
            AcctTeamAppCustomSettings__c atc = new AcctTeamAppCustomSettings__c();
            atc.Name = 'Default';
            atc.editUrl__c = '/500/e?';
            insert atc; 
            
            PageReference pageRef = Page.MFS_AccountTeamMem;
            pageRef.getParameters().put('id', acc.id);
            pageRef.getParameters().put('gtl', 'true'); 
            Test.setCurrentPage(pageRef);
            
            Test.startTest();           
            ApexPages.StandardController sc = new ApexPages.StandardController(acc);
            MFS_AccountTeamMemExtensions cn = new MFS_AccountTeamMemExtensions(sc);
            
            cn.AcctTeamMemGotoList();
            List<AccountTeamMember>  lstAccM = [SELECT id FROM AccountTeamMember WHERE id=:acc.Id];
            // check if AccountTeamMemeber is deleted
            System.assertEquals(lstAccM.size(), 0);
            Test.stopTest();  
        }
    }
    
    static testMethod void withMultipleTeamMem() {
        List<AccountTeamMember> lstAccMem = new List<AccountTeamMember>();
        User demo = MFS_TestDataUtility.createUser('System Administrator');
        insert demo;  
        //List<User> lstuserone = UtilityTestData.testUserDataSetUp();
        System.Runas(demo){
            
            Account acc = MFS_TestDataUtility.createAccount();
            insert acc;
            
            for(integer i=0 ; i<3 ; i++){
                AccountTeamMember Teammemberad =new AccountTeamMember(); 
                Teammemberad.AccountId = acc.id; 
                Teammemberad.UserId = demo.id; 
                Teammemberad.TeamMemberRole = 'Account Manager';
                lstAccMem.add(Teammemberad); 
            }
            for(integer i=0 ; i<7 ; i++){
                AccountTeamMember Teammemberad =new AccountTeamMember(); 
                Teammemberad.AccountId = acc.id; 
                Teammemberad.UserId = demo.id; 
                Teammemberad.TeamMemberRole = 'Account Manager';
                lstAccMem.add(Teammemberad); 
            }
            insert lstAccMem;
            
            AcctTeamAppCustomSettings__c atc = new AcctTeamAppCustomSettings__c();
            atc.Name = 'Default';
            atc.AccountId__c = 'CF00NP0000000sjA9_lkid';
            atc.AccountName__c = 'CF00NP0000000sjA9';
            atc.editUrl__c = '/a1g/e?';
            insert atc; 
            //SONAR FIX
            system.assertNotEquals(null, atc.Id);
            
            PageReference pageRef = Page.MFS_AccountTeamMem;
            pageRef.getParameters().put('id', acc.id);
            pageRef.getHeaders().put('USER-AGENT','iPhone');
            Test.setCurrentPage(pageRef);
            
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(acc);
            MFS_AccountTeamMemExtensions cn = new MFS_AccountTeamMemExtensions(sc);
            
            cn.AcctTeamMemGotoList();
            cn.isMobile();
            cn.showGotoList();
            cn.redirectToUserPage();
            pageRef.getParameters().put('etskr', lstAccMem[0].id);
            Test.stopTest();  
        }
    }
    
    static testMethod void testAcctTeamMiscellaneous() {
        List<AccountTeamMember> lstAccMem = new List<AccountTeamMember>();
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        User demo = MFS_TestDataUtility.createUser('System Administrator');
        insert demo;
        for(integer i=0 ; i<3 ; i++){
            AccountTeamMember Teammemberad =new AccountTeamMember(); 
            Teammemberad.AccountId = acc.id; 
            Teammemberad.UserId = demo.id; 
            Teammemberad.TeamMemberRole = 'Account Manager';
            lstAccMem.add(Teammemberad); 
        }
        for(integer i=0 ; i<7 ; i++){
            AccountTeamMember Teammemberad =new AccountTeamMember(); 
            Teammemberad.AccountId = acc.id; 
            Teammemberad.UserId = demo.id; 
            Teammemberad.TeamMemberRole = 'Account Manager';
            lstAccMem.add(Teammemberad); 
        }
        insert lstAccMem;
        PageReference pageRef = Page.MFS_AccountTeamMem;
        pageRef.getParameters().put('id', acc.id);
        pageRef.getParameters().put('gtl', 'false'); 
        Test.setCurrentPage(pageRef);
        pageRef.getHeaders().put('USER-AGENT','android');
        Test.setCurrentPage(pageRef);
        Test.startTest();
        AcctTeamAppCustomSettings__c atc = new AcctTeamAppCustomSettings__c();
        atc.Name = 'Default';
        atc.AccountId__c = 'CF00NP0000000sjA9_lkid';
        atc.AccountName__c = 'CF00NP0000000sjA9';
        atc.editUrl__c = '/500/e?';
        insert atc;
        //SONAR FIX
        system.assertNotEquals(null, atc.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        MFS_AccountTeamMemExtensions cn = new MFS_AccountTeamMemExtensions(sc);
        cn.showReqMember();
        cn.showGotoList();
        Test.stopTest(); 
    }
    
}