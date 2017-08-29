@isTest
public class MFS_MyCampContactsTest {
    static testmethod void myCampTest(){
        List<Account> accList = MFS_TestDataUtility.createBulkAccounts(10);
        insert accList;
        List<Contact> tempConList = MFS_TestDataUtility.createBulkContacts(accList, 10);
        List<Contact> conList = new List<Contact>();
        for(Contact c : tempConList)
        {
            c.Status__c = 'Active';
            c.Contact_Role__c = 'Competitor';
            conList.add(c);
        }
        insert conList;
        Campaign campRec=MFS_TestDataUtility.createCampaign();
        campRec.Other_Contact__c = UserInfo.getUserId();
        insert campRec;
        List<CampaignMember> campMem = new List<CampaignMember>();
        for(Contact con : conList)
        {
            CampaignMember camp = new CampaignMember();
            camp.CampaignId=campRec.Id;
            camp.ContactId=con.Id;
            Camp.Status='Sent';
            campMem.add(camp);
        }
        insert campMem;
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
        Test.setCurrentPageReference(new Pagereference('Page.MFS_MyCampContacts'));
        System.currentPageReference().getParameters().put('isdtp', 'true');
        System.currentPageReference().getParameters().put('selectedTab1', 'true');
        
        MFS_MyCampContacts myContacts = new MFS_MyCampContacts(new ApexPages.StandardController(campRec));
        myContacts.oUser = '';
        myContacts.removeMemId = '';
        System.assertEquals(true, myContacts.isInConsole);
        myContacts.noOfExtRecords = 1;
        myContacts.selectedContact = conList[0].Id+','+conList[1].Id;
        myContacts.checkAndAddStatus();
        myContacts.goBack();
        myContacts.getMyContacts();
        myContacts.getNextContacts();
        myContacts.getpreviousContacts();
        myContacts.searchMCName = '******';
        myContacts.searchMCCountry = 'U';
        myContacts.searchInMyContacts();
        myContacts.searchMCName = 'Test';
        myContacts.searchMCCountry = 'United';
        myContacts.searchMCOrg = 'Test';
        myContacts.searchMCZone = 'Z000';
        myContacts.searchMCContRole = 'Competitor';
        myContacts.searchInMyContacts();
        myContacts.searchMCOrgType = 'Retail';
        myContacts.searchMCRegion = 'North America';
        myContacts.searchInMyContacts();
        myContacts.refreshMyContacts();
        //myContacts.nameSearchSOSL();
        myContacts.size = 2;
        myContacts.getMyContacts();
        
        myContacts.getOtherContact();
        myContacts.campaignRec = campRec;
        //myContacts.Other_Contact__c = UserInfo.getUserId();
        myContacts.getOtherContact();
        
        //myContacts.addAllContacts();
        //myContacts.addAllContactsSF1();
        myContacts.addCampMember();
        myContacts.addCampMemberSF1();
        myContacts.getExistingMember1();
        myContacts.resetMessages();
        myContacts.updateRemoveMembers();
        myContacts.toggleExistingMembers();
        myContacts.selectedOption = 'ACM';
        myContacts.toggleExistingMembers();
        myContacts.selectedMember = campMem[0].Id+','+campMem[1];
        myContacts.updateRemoveMembers();
        myContacts.selectedMember = 'Remove,'+campMem[0].Id;
        myContacts.updateRemoveMembers();
        myContacts.getItems();
        
         //run as institutional User
        User instUsr = MFS_TestDataUtility.createUser('Global Institutional Sales');
        insert instUsr;
        List<AccountTeamMember> atmInstList = MFS_TestDataUtility.createBulkATM(accList, 10, instUsr.Id) ;
        insert atmInstList;
        system.runAs(instUsr)
        {
            MFS_MyCampContacts myInstContacts = new MFS_MyCampContacts(new ApexPages.StandardController(campRec));
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
            MFS_MyCampContacts myRetailContacts = new MFS_MyCampContacts(new ApexPages.StandardController(campRec));
            myRetailContacts.searchInMyContacts();
        }
        Test.stopTest();
    }
    
    static testmethod void testExceptionBlock(){
         Test.startTest();
        Campaign camp = MFS_TestDataUtility.createCampaign();
        MFS_MyCampContacts myCampConts = new MFS_MyCampContacts(new ApexPages.StandardController(camp));
        myCampConts.getApplicableContacts(null,null);
        myCampConts.searchInMyContacts();
        myCampConts.nameSearchSOSL(null,null,null);
        myCampConts.getExistingMember1();
        myCampConts.addCampMemberSF1();
        myCampConts.addCampMember();
        //myCampConts.addAllContactsSF1();
        //myCampConts.addAllContacts();
        //SONAR Fix
        System.assert(myCampConts.myContactsList == null);
        //myCampConts.getOtherContact();
        Test.stopTest();
    }

}