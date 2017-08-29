@isTest(seeAllData=false)
public class MFS_MyContactsControllerTest {
    static testMethod void myContactsTest()
    {
        List<Account> accList = MFS_TestDataUtility.createBulkAccounts(10);
        insert accList;
        List<Contact> tempConList = MFS_TestDataUtility.createBulkContacts(accList, 10);
        List<Contact> conList = new List<Contact>();
        for(Contact c : tempConList)
        {
            c.Status__c = 'Active';
            conList.add(c);
        }
        insert conList;
        List<AccountTeamMember> atmList = MFS_TestDataUtility.createBulkATM(accList, 10, UserInfo.getUserId()) ;
        insert atmList;
        List<Coverage_Team__c> cctList = MFS_TestDataUtility.createBulkCCT(conList, 10, UserInfo.getUserId());
        insert cctList;
        Test.startTest();
        //set SOSL results
        Id [] fixedSearchResults= new Id[10];
        for(Integer i=0;i<10;i++)
        {
            fixedSearchResults[i] = conList[i].Id; 
        }
        Test.setFixedSearchResults(fixedSearchResults);
        //Set page for controller
        Test.setCurrentPageReference(new Pagereference('Page.MFS_MyContacts'));
        System.currentPageReference().getParameters().put('isdtp', 'true');
        
        MFS_MyContactsController myContacts = new MFS_MyContactsController();
        
        System.assertEquals(true, myContacts.isInConsole);
        myContacts.searchInMyContacts();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Search criteria must contain atleast 3 characters')) b = true;
        }
        system.assert(b);
        //Set standard Set Controller
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(conList);
        myContacts.size = 2;
        myContacts.getMyContacts();
        myContacts.getNextContacts();
        myContacts.getpreviousContacts();
        myContacts.searchMCName = 'ConFirst';
        myContacts.searchInMyContacts();
        myContacts.searchMCName = 'Test';
        myContacts.searchMCCity = 'Boston';
        myContacts.searchMCState = 'Massachusetts';
        myContacts.searchMCCountry = 'United States';
        myContacts.searchMCOrg = 'Test';
        myContacts.searchMCZone = 'Z000';
        myContacts.searchInMyContacts();
        myContacts.contIdSetSize = 0;
        myContacts.searchInMyContacts();
        myContacts.refreshMyContacts();
        myContacts.refreshPageSize();
        Test.stopTest();
        //run as institutional User
        User instUsr = MFS_TestDataUtility.createUser('Global Institutional Sales');
        insert instUsr;
        List<AccountTeamMember> atmInstList = MFS_TestDataUtility.createBulkATM(accList, 10, instUsr.Id) ;
        insert atmInstList;
        system.runAs(instUsr)
        {
            MFS_MyContactsController myInstContacts = new MFS_MyContactsController();
            stdSetController = new ApexPages.StandardSetController(conList);
            myInstContacts.searchMCName = 'Test';
            myInstContacts.searchMCName = 'Test';
            myInstContacts.searchMCCountry = 'United';
            myInstContacts.searchMCOrg = 'Test';
            myInstContacts.searchMCZone = 'Z000';
            myInstContacts.searchInMyContacts();
        }
        //run as retail user
        Profile prf = [select id from Profile where name = 'Global Retail External'];
        User retailUsr = new User(UserName = 'unique_test2@mfstest.com', Lastname = 'Last', FirstName = 'First', Email = 'test@mfs.com', ProfileId = prf.id, Alias = 'test', 
                            TimeZoneSidKey = 'GMT', LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US' );
        insert retailUsr;
        List<Coverage_Team__c> cctRetList = MFS_TestDataUtility.createBulkCCT(conList, 10, retailUsr.Id);
        insert cctRetList;
        system.runAs(retailUsr)
        {
            MFS_MyContactsController myRetailContacts = new MFS_MyContactsController();
            stdSetController = new ApexPages.StandardSetController(conList);
            myRetailContacts.searchMCName = 'Test';
            myRetailContacts.searchMCName = 'Test';
            myRetailContacts.searchMCCountry = 'United';
            myRetailContacts.searchMCOrg = 'Test';
            myRetailContacts.searchMCZone = 'Z000';
            myRetailContacts.searchInMyContacts();
            myRetailContacts.loggedInUser = 't';
            myRetailContacts.searchInMyContacts();
            //myRetailContacts.nameSearchSOSL('t','t','t');
        }
        
    }
    
   /* static testmethod List<Contact> createData()
    {
        List<Account> accList = MFS_TestDataUtility.createBulkAccounts(10);
        insert accList;
        List<Contact> tempConList = MFS_TestDataUtility.createBulkContacts(accList, 10);
        List<Contact> conList = new List<Contact>();
        for(Contact c : tempConList)
        {
            c.Status__c = 'Active';
            conList.add(c);
        }
        insert conList;
        List<AccountTeamMember> atmList = MFS_TestDataUtility.createBulkATM(accList, 10) ;
        insert atmList;
        List<Coverage_Team__c> cctList = MFS_TestDataUtility.createBulkCCT(conList, 10);
        insert cctList;
        Test.startTest();
        //set SOSL results
        Id [] fixedSearchResults= new Id[10];
        for(Integer i=0;i<10;i++)
        {
            fixedSearchResults[i] = conList[i].Id; 
        }
        Test.setFixedSearchResults(fixedSearchResults);
        //Set page for controller
        Test.setCurrentPageReference(new Pagereference('Page.MFS_MyContacts'));
        System.currentPageReference().getParameters().put('isdtp', 'true');
        return conList;
    }*/
}