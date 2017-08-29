@isTest(seeAllData = false)
public class MFS_CampaignUtilities_Test {
    //Test for single record
    static testmethod void testCampignInsert()
    {
        Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Contact contactRec=MFS_TestDataUtility.createContact(accRec.id);
        insert contactRec;
        Campaign campRec=MFS_TestDataUtility.createCampaign();
        insert campRec;
        System.assert(campRec != null);
        CampaignMember campMem=MFS_TestDataUtility.createCampaignMember(campRec.Id,contactRec.Id);
        insert campMem;  
        System.assert(campMem != null);
        Campaign campRec1=campRec.clone();
        campRec1.Original_Campaign__c=campRec.Id;
        insert campRec1;
        //Test campaign Trigger Disabled
        Application_Settings__c appSetting = MFS_TestDataUtility.CreateTestAppSetting('EnableCampaignTrigger','No');
        //insert appSetting;
        Campaign campRec2=MFS_TestDataUtility.createCampaign();
        insert campRec2;
        Test.stopTest();
    }
    
    //Test for bulk records
    static testmethod void testBulkCampignInsert()
    {
        Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Contact contactRec=MFS_TestDataUtility.createContact(accRec.id);
        insert contactRec;
        Campaign campRec=MFS_TestDataUtility.createCampaign();
        insert campRec;
        System.assert(campRec != null);
        CampaignMember campMem=MFS_TestDataUtility.createCampaignMember(campRec.Id,contactRec.Id);
        insert campMem; 
        System.assert(campMem != null);
        List<Campaign> campList=new List<Campaign>();
        Campaign campRec1;
        for(Integer i=0;i<5;i++)
        {
            campRec1=new Campaign();
            campRec1=campRec.clone();
            campRec1.Original_Campaign__c=campRec.Id;
            campList.add(campRec1);
        }
        insert campList;
        Test.stopTest();
    }
    
    @testSetup
    public static void dataSetup(){
        List<Application_Settings__c> customSettings = MFS_TestDataUtility.getappSettingsList();
        insert customSettings;
    }
    
}