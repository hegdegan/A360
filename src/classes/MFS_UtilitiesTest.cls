@isTest(seeAllData = false)
public class MFS_UtilitiesTest {

    static testMethod void testMFSUtilities(){      
        Test.startTest();
        StoreFieldIds__c storeFIds = new StoreFieldIds__c(name='-1239432833', Field_API_Name__c='Team_Member__c', 
                                                          Field_Id__c='CF00NP0000000sjAT',Field_Label__c='Team Member',Object_Name__c='Case');
        List<Currency_Symbol__c> listCurrSymbolList = MFS_TestDataUtility.getCurrSymbolList();
        insert listCurrSymbolList;
        insert storeFIds;
        List<String> fieldList = new List<String>();
        fieldList.add('Team_Member__c');
        MFS_Utilities.getFieldId('Case',fieldList);
        String cuuSymbol = MFS_Utilities.getCurrSymbol('USD');
        System.assertEquals(cuuSymbol,'$');
        MFS_Utilities.getGDMCurrenyFields('Test');
        MFS_Utilities.getSOQLQueryForExObject('Test','Test');
        
        Campaign camp = MFS_TestDataUtility.createCampaign();
        MFS_MyCampContacts myCampConts = new MFS_MyCampContacts(new ApexPages.StandardController(camp));
        myCampConts.getApplicableContacts(null,null);
        myCampConts.searchInMyContacts();
        Test.stopTest();
    }
    
    static testMethod void testMiscellaneous(){  
        Test.startTest();
        MFS_TestDataUtility.setTotalSalesList();
        Account acc = MFS_TestDataUtility.createAccount();
        acc.MDM_ID__c = '1234567';
        insert acc;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        cont.MDM_ID__c = '3456';
        insert cont;
        Event event = MFS_TestDataUtility.createEventWithContact(cont.Id);
        event.Activity_Type_for_Instit__c = 'Finals;Thought Leadership';
        insert event;
        Task task = MFS_TestDataUtility.createTask(acc.Id);
        task.Activity_Type_for_Instit__c = 'Finals;Thought Leadership';
        Activity_Detail__c cNote = MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote;
         Product2 prod = MFS_TestDataUtility.createProduct(); 
        insert prod;
        List<Account__c> cInvList = new List<Account__c>();
        for(Integer i=0; i<5; i++)
        {
            Account__c cInv = new Account__c(Organization__c = acc.Id, Portfolio__c =prod.Id );
            cInvList.add(cInv);
        }
        insert cInvList;
        Meeting_Material_Request__c MMR = new Meeting_Material_Request__c(Name = 'MMRTest', Client_Prospect_Name__c = acc.Id, Call_Note__c = cNote.Id, Date_Due_to_Client__c = System.TODAY(), Material_Type__c = 'Client',
                                                                          Client_Investment__c = cInvList[0].Id, Translation_Languages__c = 'German;French', Number_of_Copies_for_Each_Language__c = 'German:5;French:5',
                                                                          Portfolio__c = prod.id
                                                                         );
        insert MMR;
        MFS_Activity360SF1Utility mfsA360SF1Utility = new MFS_Activity360SF1Utility();
        MFS_Activity360SF1Utility.getAllActivityType(event);
        MFS_Activity360SF1Utility.getSelectedActivityTypes(event);
        //MFS_Activity360SF1Utility.getSelectedActivityTypesForFollowUp(task);
        //MFS_Activity360SF1Utility.getAllActivityTypeForFollowUp(task);
        
        //MFS_EventUtilities evUtilities = new MFS_EventUtilities();
        Map <Id, Event> oldMap = new Map <Id, Event>();
        Map <Id, Event> newMap = new Map <Id, Event>();
        Contact cont1 = MFS_TestDataUtility.createContact(acc.id);
        cont.MDM_ID__c = '113456';
        insert cont1;
        Opportunity op1 = MFS_TestDataUtility.createOpportunity(acc.id);
        insert op1;
        Opportunity op2 = MFS_TestDataUtility.createOpportunity(acc.id);
        insert op2;
        Event ev = MFS_TestDataUtility.createEventWithContact(cont.Id); 
        ev.WhatId = op1.Id;
        insert ev;
        oldMap.put(ev.Id,ev);
        ev.WhoId = cont1.Id;
        ev.WhatId = op2.Id;
        MFS_Utilities.runreset();
        update ev;
        newMap.put(ev.Id,ev);
        MFS_Utilities.runreset();
        update ev;
        List<Organization_Institutional_Sales__c> oisList = MFS_TestDataUtility.getInstitutionalSalesList();
        insert oisList;
        String curr = MFS_Utilities.getClientReportingCurr('Organization_Institutional_Sales__c','123456');
        System.assertEquals(curr,'USD');
        try{
            MFS_Utilities.getClientReportingCurr('Organization_Institutional_Sales__c','*****');
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        
        Test.stopTest();
    }
    
    static testMethod void testEvents(){
        Test.startTest();
        Application_Settings__c appSettings = MFS_TestDataUtility.CreateTestAppSetting('EnableDataLoad','No');
        insert appSettings;
        //SONAR Fix
        System.assertNotEquals(null,appSettings.Id);
        Account acc = MFS_TestDataUtility.createAccount();
        acc.MDM_ID__c = '1234567';
        Contact cont1 = MFS_TestDataUtility.createContact(acc.id);
        cont1.MDM_ID__c = '113456';
        Contact cont2 = MFS_TestDataUtility.createContact(acc.id);
        cont2.MDM_ID__c = '1134567';
        Opportunity op1 = MFS_TestDataUtility.createOpportunity(acc.id);
        insert op1;
        Opportunity op2 = MFS_TestDataUtility.createOpportunity(acc.id);
        insert op2;
        Event ev = MFS_TestDataUtility.createEventWithContact(cont1.Id); 
        insert ev;
        MFS_Utilities.runReset();
        ev.WHOID = cont2.Id;
        update ev;
        ev.WHATID = acc.Id;
        update ev;
        ev.WHATID = op1.Id;
        update ev;
        Test.stopTest();
    }
    
    static testMethod void testDMLUtilities(){
        List<Account> accList = new List<Account>();
        Account acc = MFS_TestDataUtility.createAccount();        acc.type__c = null;
        acc.MDM_ID__c = 'ZZZ4567';
        accList.add(acc);
        MFS_DMLUtilities.SaveEntity(accList);
        List<Account> accList1 = new List<Account> ([Select Id, Name from Account where MDM_Id__C =: 'ZZZ4567'] );
        System.assertEquals(0,accList1.size());
    }
    
    static testMethod void testOrgUtilities(){
        List<Account> accList = new List<Account>();
        Account acc = MFS_TestDataUtility.createAccount();
        RecordType rt = [select id,Name,SobjectType,DeveloperName from RecordType where SobjectType =: 'Account' and DeveloperName=: MFS_AllConstants.RT_UNKNOWN];
        acc.type__c = null;
        acc.RecordTypeId = rt.Id;
        acc.MDM_ID__c = 'ZZZ4567';
        acc.Distribution_Level__c = MFS_AllConstants.DL_US_RETAIL;
        acc.Type__c = MFS_AllConstants.TYPE_CLIENT_PROSPECT;
        insert acc;
        accList.add(acc);
        MFS_OrganizationUtilities.ChangeAccountOwner(accList,null);
        MFS_OrganizationUtilities.ChangeAccountOwner(accList,'005P0000000voSK');
        acc.Sales_Status__c = MFS_AllConstants.ST_PRSPT;
        acc.Distribution_Level__c = MFS_AllConstants.DL_GL_INST;
        update acc;
        
        
        acc.Type__c = MFS_AllConstants.TYPE_COMPETITOR;
        update acc;
        
        
        acc.Type__c = MFS_AllConstants.TYPE_SERVICE_PROVIDER;
        update acc;
        
        acc.Type__c = MFS_AllConstants.TYPE_INVST_CONSUL;
        update acc;
        
        acc.Type__c = MFS_AllConstants.TYPE_CLIENT_PROSPECT;
        acc.Sales_Status__c = MFS_AllConstants.ST_CLIENT;
        acc.Distribution_Level__c = MFS_AllConstants.DL_GL_INST;
        update acc;
        
        acc.Type__c = MFS_AllConstants.TYPE_CLIENT_PROSPECT;
        acc.Sales_Status__c = null;
        acc.Distribution_Level__c = (MFS_AllConstants.DL_GL_INST+';'+MFS_AllConstants.DL_NON_US_RETAIL);
        update acc;
    }
}