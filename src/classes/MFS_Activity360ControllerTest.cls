/***************************************************************************************************
Apex Class Name    : MFS_Activity360ControllerTest 
Version            : 1.0 
Created Date       : 10 JUL 2016
Function           : This is a Test Class for MFS_Activity360Controller and dependent utility Classes
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey               01/07/2016              Original Version
***************************************************************************************************/
@isTest(seeAllData=false) 
public class MFS_Activity360ControllerTest {
    private static FINAL String RET_EVENT =  'Enhanced Event (Retail)';
    private static FINAL String RET_TASK = 'Log a Call (Retail)';
    
    //Test Constructor and related methods
    static testmethod void activity360ControllerTest(){
        //Create test data
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        System.assert(acc != null);
        Activity_Detail__c cNote = MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote; 
        //Create user with System Admin profile
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        insert usr;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        Contact cont1 = MFS_TestDataUtility.createContact(acc.id);
        insert cont1;
        Event_Request__c er= MFS_TestDataUtility.createEventReq(usr.Id);
        er.Call_Note__c = cNote.Id;
        insert er;
        Event evnt = MFS_TestDataUtility.createEventWithContact(cont.Id); 
        evnt.Event_Start_Date__c = system.Today();
        evnt.Event_End_Date__c = system.Today();
        
        evnt.Activity_Detail__c= cNote.Id;
        evnt.WhatId = acc.Id;
        evnt.WhoId = cont.Id;
        evnt.Call_Note_Parent_Task_Event__c = true;
        evnt.recordtypeid= Schema.SObjectType.Event.getRecordTypeInfosByName().get(RET_EVENT).getRecordtypeId();
        evnt.Activity_Type_for_Instit__c = 'MFS Event;Semi-Finals;';
        insert evnt;
        System.assert(evnt!= null);
        Product2 prod = MFS_TestDataUtility.createProduct(); 
        insert prod;
        Competitor_Product__c comProd = MFS_TestDataUtility.createComptrProduct();
        insert comProd;
        Call_Note_Competitor_Product__c comProdjn = new Call_Note_Competitor_Product__c(Competitor_Product__c = comProd.Id, Call_Note__c = cNote.Id );
        insert comProdjn;
        Call_Note_Product__c cProdjn = new Call_Note_Product__c(Product__c = prod.Id, Call_Note__c = cNote.Id);
        insert cProdjn;
        Competitive_Analysis_Request__c cAReq = new Competitive_Analysis_Request__c(Description__c='Test',Contact__c=cont.Id,Call_Note__c=cNote.Id);
        insert cAReq;
        Event evnt2 = MFS_TestDataUtility.createEventWithContact(cont.Id);
        evnt2.Activity_Detail__c= cNote.Id;
        evnt2.Call_Note_Parent_Task_Event__c = true;
        evnt2.WhatId = acc.Id;
        insert evnt2;
        Event evnt3 = MFS_TestDataUtility.createEventWithContact(cont.Id);
        evnt3.Activity_Detail__c= cNote.Id;
        evnt3.Call_Note_Parent_Task_Event__c = false;
        evnt3.WhatId = acc.Id;
        insert evnt3;
        EventRelation evRel1 = new EventRelation(EventId=evnt2.Id,isInvitee=true,RelationId=cont1.Id);
        insert evRel1;
        EventRelation evRel2 = new EventRelation(EventId=evnt2.Id,isInvitee=true,RelationId=usr.Id);
        insert evRel2;
        EventRelation evRel3 = new EventRelation(EventId=evnt.Id,isInvitee=true,RelationId=usr.Id);
        insert evRel3;
        Task tsk2 = MFS_TestDataUtility.createTask(acc.Id);
        tsk2.Activity_Detail__c =cNote.Id;
        tsk2.WhatId = acc.Id;
        tsk2.WhoId = cont.Id;
        tsk2.Call_Note_Parent_Task_Event__c = false;
        tsk2.recordtypeid= Schema.SObjectType.Task.getRecordTypeInfosByName().get(RET_TASK).getRecordtypeId();
        insert tsk2;
        
        //Set the page and URl parameters
        PageReference pg = Page.MFS_Activity360RetailPageSF1;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id',cNote.Id);
        ApexPages.currentPage().getParameters().put('orgId',acc.Id); 
        ApexPages.currentPage().getParameters().put('contId',cont.Id);
        ApexPages.currentPage().getParameters().put('task','false');
        ApexPages.currentPage().getParameters().put('event','true');
        ApexPages.currentPage().getParameters().put('RecType','Retail');
        ApexPages.currentPage().getParameters().put('returnID',acc.Id);
        
        //call the constructor
        MFS_Activity360Controller a360 = new MFS_Activity360Controller();
        //set the variable values
        a360.oProductJN = cProdjn;
        a360.oCompProductJN = comProdjn;
        a360.startDateTime = '1:30 PM';
        a360.endDateTime = '4:30 PM';
        a360.speakerRequest = new Event_Request__c();
        a360.EventRequestContactName = 'Test';
        a360.EventRequestOrgName = 'TestOrg';
        a360.eventInstructionRT = 'Trading Floor Tour';
        a360.feStartDateTime = '';
        a360.isSelected = 'false';
        a360.selectedProdCount = '2';
        a360.oppCurrencyCode = 'USD';
        a360.followUpTaskWhoIdName = 'Test';
        a360.MMROrgName = 'TestOrg';
       	a360.calledDate = system.today();
        a360.invIdForPopup = '';
        a360.mActivityTypeVsSubType = new Map<String,List<String>>();
        
        Test.startTest();
        a360.edit();
        system.assert(a360.whatName!=null);
        a360.cancel();
        a360.closePopup();
        a360.showTaskPopup();
        System.assertNotEquals(null, a360.task);
        a360.showCompAnalysisPopup();
        System.assertEquals(null, a360.individualChildRecordId);
        
        //update the task and test
        tsk2.Subject='Meeting';
        tsk2.Status = 'Open';
        tsk2.Priority = 'Medium';
        tsk2.Reason_for_Call__c = 'Product Call';
        tsk2.Call_Outcome__c = 'Inbound';
        tsk2.Call_Category__c = 'Inbound';
        tsk2.OwnerId = UserInfo.getUserId();
        update tsk2;
        a360.parentTask = tsk2;
        a360.taskCallNote = true;
        a360.Save();
        a360.edit();
        a360.saveFollowUpTask();
        a360.editFollowUpRecord();
        a360.deleteFollowUpTaskEvent();
        a360.editFollowUpTaskRecord();
        a360.saveCompAnalysis();
        a360.individualChildRecordId  = [Select id FROM Competitive_Analysis_Request__c Limit 1].id;
        a360.showCompAnalysisPopup();
        a360.individualChildRecordId = a360.CompAnalysisWrapperList[0].wCompAnalysisRequest.Id;
        a360.editCompetitiveAnalysisRecord();
        a360.individualChildRecordId = er.id;
        a360.deleteSpeakerRequestRecord();
        a360.goBack();
        a360.parentEvent.whoId = cont.Id;        
        a360.highInterestProductCheck();
        a360.removingProductForCA();
        a360.removeCompProductForCA();
        a360.cancelFollowUpRecord();
        a360.changeActivitySubject();
        a360.changeEventSubject();
        a360.changeLocation();
        evnt.Location__c = MFS_AllConstants.EVENT_LOCATION_FIELD_DEFAULTVALUE_OFFICE;
        MFS_Activity360GeneralUtility.changeLocation(FALSE,FALSE,evnt,evnt);
        a360.getTimeList();
        System.assertEquals(48, a360.getTimeList().size());
        a360.allDayEventCheck();
        a360.startDateTimeChange();
        a360.selectCompProductForCA();
        a360.disableDateTime();
        a360.changingEventWhoId();
        a360.changingEventMethod();
        a360.searchText = 'Bob';
        a360.SearchObjects = 'Users';
        a360.searchInvitee();
        a360.addInvitees();
        test.stopTest();
        
        //Change the URL parameters to test Task record
        pg = Page.MFS_Activity360RetailPageSF1;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id',cNote.Id);
        ApexPages.currentPage().getParameters().put('orgId',acc.Id); 
        ApexPages.currentPage().getParameters().put('contId',cont.Id);
        ApexPages.currentPage().getParameters().put('task','true');
        ApexPages.currentPage().getParameters().put('event','false');
        ApexPages.currentPage().getParameters().put('RecType','Retail');
        ApexPages.currentPage().getParameters().put('returnID',cont.Id);
        ApexPages.currentPage().getParameters().put('inEditMode','true');
        a360.task.whoId = cont.Id;
        a360.prepareRemoteActionQueryURL('Opportunity');
        a360.prepareRemoteActionQueryURL('Campaign');
        a360.prepareRemoteActionQueryURL('Business_At_Risk__c');
        a360.prepareRemoteActionQueryURL('Strategy_Plan__c');
        a360.prepareRemoteActionQueryURL('Consultant_Rating__c');
        a360.prepareRemoteActionQueryURL('Case');
        //Test for Not_An_Orphan_Record__c= true block by updating the Activity Detail
        MFS_Activity360Controller Act360TaskRecord = new MFS_Activity360Controller();
        cNote.Not_An_Orphan_Record__c = false;
        update cNote;
        ApexPages.currentPage().getParameters().put('id',cNote.Id);
        MFS_Activity360Controller Act360TaskRecordContact = new MFS_Activity360Controller();
        Act360TaskRecordContact.save();
        
    }
    
    //Test Invitee Utility class and related methods
    static testmethod void eventInviteeUtilityTest(){
        //Setting up data
        Account acc = MFS_TestDataUtility.createAccount(); 
        insert acc;
        Activity_Detail__c cNote=MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote;
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        insert usr;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        //Contact to be added as Invitee
        Contact cont1 = MFS_TestDataUtility.createContact(acc.id);
        insert cont1;
        //User added as invitee
        User usr1 = MFS_TestDataUtility.createUser('System Administrator');
        usr1.UserName = 'unique_test1@mfstest.com';
        insert usr1;
        //User & Contacts to be added as invitee
        User usrToAdd1 = MFS_TestDataUtility.createUser('System Administrator');
        usrToAdd1.UserName = 'unique_test2@mfstest.com';
        usrToAdd1.LastName = 'TestUser1';
		usrToAdd1.City = 'Boston';
		usrToAdd1.MFS_Location__c = 'MFS';
		usrToAdd1.Country='United States';
        usrToAdd1.Speaker_Request_Approval__c = 'Business Approver';
        insert usrToAdd1; 
        User usrToAdd2 = MFS_TestDataUtility.createUser('System Administrator');
        usrToAdd2.UserName = 'unique_test3@mfstest.com';
        usrToAdd1.Speaker_Request_Approval__c = 'Business Approver';
        usrToAdd2.LastName = 'TestUser2';
        insert usrToAdd2;  
        Contact contToAdd1 = MFS_TestDataUtility.createContact(acc.id);
        contToAdd1.LastName = 'TestContact1';
		contToAdd1.MailingCity='New York';
		contToAdd1.MailingCountry='United States';
        insert contToAdd1;
        Event evnt = MFS_TestDataUtility.createEventWithContact(cont.Id); 
        evnt.Event_Start_Date__c = system.today() -1;
        evnt.Event_End_Date__c = system.today() -1;
        evnt.Activity_Detail__c= cNote.Id;
        evnt.WhatId = acc.Id;
        evnt.WhoId = cont.Id;
        evnt.Call_Note_Parent_Task_Event__c = true;
        evnt.recordtypeid= Schema.SObjectType.Event.getRecordTypeInfosByName().get(RET_EVENT).getRecordtypeId();
        evnt.Activity_Type_for_Instit__c = 'MFS Event;';
        evnt.Activity_SubType__c = 'DB Trends;DC Trends';
        insert evnt;
        EventRelation evRel1 = new EventRelation(EventId=evnt.Id,isInvitee=true,RelationId=cont1.Id);
        insert evRel1;
        EventRelation evRel3 = new EventRelation(EventId=evnt.Id,isInvitee=true,RelationId=usr.Id);
        insert evRel3;
        Product2 prodToAdd = MFS_TestDataUtility.createProduct();
        insert prodToAdd;
        //Setting Page URL and calling controller
        ApexPages.currentPage().getParameters().put('id',cNote.Id);
        ApexPages.currentPage().getParameters().put('task','false');
        ApexPages.currentPage().getParameters().put('event','true');
        ApexPages.currentPage().getParameters().put('RecType','Institutional');
        ApexPages.currentPage().getParameters().put('returnID',acc.Id);
        Test.startTest();
        MFS_Activity360Controller a360 = new MFS_Activity360Controller();  
        a360.goToInvitees();
        a360.selectInvitee();
        a360.closeInviteePopUp();
        a360.getInviteeSearchObjects();
        a360.getInviteeSearchObjects();
        a360.selectInvitee();
        //Set the data for SOSL
        Id[] fixedsearchResults = new Id[3];
        fixedsearchResults[0]  = usrToAdd1.id;
        fixedsearchResults[1]  = usrToAdd2.id;
        fixedsearchResults[2]  = contToAdd1.id;
        Test.setFixedSearchResults(fixedsearchResults);
        
         //Search by Org and add one contact
        a360.SearchObjects = 'Contacts';
        a360.searchTextOrg='TestAccount';
        a360.searchInvitee();
        a360.leftSelectedList.clear();
        a360.leftSelectedList.add((string)contToAdd1.id);
        a360.clickRight();
        
        //Search by Name and Org and add one contact
        a360.SearchObjects = 'Contacts';
        a360.searchText='test';
        a360.searchTextOrg='TestAccount';
        a360.searchInvitee();
        a360.leftSelectedList.clear();
        a360.leftSelectedList.add((string)contToAdd1.id);
        a360.clickRight();
        
        //Searching with less than two characters
        a360.SearchObjects = 'Users';
        a360.SearchText = 'T';
        a360.searchInvitee();
        
        //Search by City and add one user
        a360.SearchObjects = 'Users';
		a360.SearchTextCity='Boston';
        a360.searchInvitee();
        a360.leftSelectedList.clear();
        a360.leftSelectedList.add((string)usrToAdd1.id);
        a360.clickRight();
        
        //Search by Country and add one user
        a360.SearchObjects = 'Users';
		a360.SearchTextCountry='United States';
        a360.searchInvitee();
        a360.leftSelectedList.clear();
        a360.leftSelectedList.add((string)usrToAdd1.id);
        a360.clickRight();
        
        //Search by Org Name and add one user
        a360.SearchObjects = 'Users';
		a360.SearchTextOrg='MFS';
        a360.searchInvitee();
        a360.leftSelectedList.clear();
        a360.leftSelectedList.add((string)usrToAdd1.id);
        a360.clickRight();
        
        //Search and add one user
        a360.SearchObjects = 'Users';
        a360.SearchText = 'unique_test';
		a360.SearchTextCity='Boston';
        a360.searchTextOrg='MFS';
        a360.searchTextCountry='United States';
        a360.searchInvitee();
        a360.leftSelectedList.clear();
        a360.leftSelectedList.add((string)usrToAdd1.id);
        a360.clickRight();
        
        //Search and add one user
        a360.SearchObjects = 'Users & Contacts';
        a360.SearchText = 'unique_test';
        a360.searchTextCountry='United States';
        a360.searchInvitee();
        a360.leftSelectedList.clear();
        a360.leftSelectedList.add((string)usrToAdd2.id);
        a360.clickRight();  
        
        a360.selectedInviteesALJSString = (ID)usrToAdd2.Id;
        Map<ID, String> mRS = new MAP<ID, String>();
        mRS.put((String)usrToAdd2.id, (ID)usrToAdd2.Id);
        a360.mRightSelected = mRS;
        a360.reset();
       
        
       //Being Edited for Code Coverage
        
        //remove one user from list
        a360.rightSelectedList.clear();
        a360.rightSelectedList.add((string)usrToAdd1.id);
        a360.clickLeft();
        
        //Clicking done button 
        a360.addInvitees();
        System.assertEquals(2, a360.inviteesMap.size());
        //Global save which calls saveInvitees()
        a360.save();
        a360.removeInviteeId = usrToAdd2.id;
        a360.removeInvitee();
        a360.save();
        //Insert event and related object records and create a wrapper for testing
        List<Event> lstEvt = new List<Event> ();
        EventRelation eRelation = new EventRelation ();
        Event_Relation__c er = new Event_Relation__c(Activity_Detail__c = cNote.Id, RelationId__c = Usr.Id);
        insert er;
        Event evt = new Event ();
        evt.StartDateTime = system.now();
        evt.EndDateTime = system.now();
        Event_Relation_Portfolio_Junction__c evRelPort = new Event_Relation_Portfolio_Junction__c (Name = 'TestProduct', Event_Relation__c = er.Id, Portfolio__c = prodToAdd.Id);
        insert evRelPort;
        MFS_EventInviteeUtility.EventPortfolioWrapper testEpw0 = new MFS_EventInviteeUtility.EventPortfolioWrapper( 'portName',  0,  evRelPort);
        //MFS_EventInviteeUtility.EventPortfolioWrapper testEpw = new MFS_EventInviteeUtility.EventPortfolioWrapper( 'portName',  1,  evRelPort);
        List<MFS_EventInviteeUtility.EventPortfolioWrapper> erLst = new List<MFS_EventInviteeUtility.EventPortfolioWrapper>();
        erlst.add(testEpw0);
        //erlst.add(testEpw);
        MFS_EventInviteeUtility.InviteeWrapper testWie2 = new MFS_EventInviteeUtility.InviteeWrapper( er, 'Test',evRelPort, erlst, '12:00 AM', '11:30 PM');
        a360.inviteesmap.put(usr.Id,testWie2);
        Event_Request__c erRecord = MFS_TestDataUtility.createEventRequest  (usr.id);       
        insert erRecord;
        cNote.Event_Request__c = erRecord.Id;
        update cNote;
        User speaker = MFS_TestDataUtility.createUser('System Administrator');
        speaker.Requires_Speaker_Approval__c = true;
        speaker.UserName = 'speaker123@mfstest.com';
        speaker.Email =  'speaker123@mfstest.com';
        insert speaker;
        Event_Relation__c er1 = new Event_Relation__c(Activity_Detail__c = cNote.Id, RelationId__c = speaker.Id, speaker__c = speaker.Id, host__c = false);
        insert er1;
        Product2 prodToAdd1 = MFS_TestDataUtility.createProduct();
        insert prodToAdd1;
        Event_Relation_Portfolio_Junction__c evRelPort1 = new Event_Relation_Portfolio_Junction__c (Name = 'TestProduct', Event_Relation__c = er1.Id, Portfolio__c = prodToAdd1.Id);
        insert evRelPort1;
        MFS_EventInviteeUtility.EventPortfolioWrapper testEpw2 = new MFS_EventInviteeUtility.EventPortfolioWrapper( 'portName',  0,  evRelPort1);
        List<MFS_EventInviteeUtility.EventPortfolioWrapper> erLst1 = new List<MFS_EventInviteeUtility.EventPortfolioWrapper>();
        erlst1.add(testEpw2);
        MFS_EventInviteeUtility.InviteeWrapper testWie3 = new MFS_EventInviteeUtility.InviteeWrapper( er1, 'Test',evRelPort1, erlst1, '12:00 AM', '11:30 PM');
        a360.inviteesmap.put(speaker.Id,testWie3);
        a360.callNote.Event_Request__c = erRecord.Id;
        a360.save();
        a360.addPortfToInvitee();
        a360.parentEvent = evnt;
        a360.parentEvent.WhoId = cont.Id;
        a360.goToInvitees();
        system.assertEquals(3, a360.inviteesMap.size());
        a360.inviteeId = UserInfo.getUserId();
        a360.removePfRowNum = '0';
        a360.removePortfFromInvitee();
        a360.addPortfToInvitee();
        a360.removeInviteeId = UserInfo.getUserId();
        a360.removeInvitee();
        system.assertEquals(2, a360.inviteesMap.size());
        a360.rightOptionList = new List<SelectOption>();
        //Run as a different user to test accept and decline buttons
        system.runAs(usr){
            a360.acceptInvite();
            a360.declineInvite();
        }
        a360.resetCompProdSearchPanel();
        a360.sortInviteesbyOrg();
        Test.stopTest();
        cNote.Not_An_Orphan_Record__c = false;
        a360.callNote.Not_An_Orphan_Record__c = false;
        a360.goToInvitees();
        //Test for exceptions by making Activity Detail Null
        cNote= null;
        a360.selectedProduct = prodToAdd.id; 
        a360.getPresentationURL();
        a360.callNote = null;
        a360.goToTask();
        a360.goToCompAnalysisRequest();
        a360.goToCompetitorProduct();
        a360.goToProduct();
        a360.goToMMR();
        apexPages.Message[] messages = apexPages.getMessages();
        system.assertNotEquals(0, messages.size());
        a360.CompAnalysisWrapperList = null;
            a360.editCompetitiveAnalysisRecord();
        a360.taskWrapperList = null;
        a360.showTaskPopup();
        a360.editFollowUpTaskRecord();
        a360.MMRWrapperList = null;
        a360.deleteMMRRecord();
        a360.SpeakerWrapperList = null;
        a360.deleteSpeakerRequestRecord();
        a360.goToSpeakerRequest();
        a360.selectedComProduct = '1234,4567';
        a360.addSelComProduct();
        a360.removingCompetitorProduct();
        a360.selectedProduct = '1234,5678';
        a360.addSeletedProduct();
        a360.highInterestProductCheck();
        a360.removingProduct();
        a360.selectedComProductForCA = '1234,5678';
        a360.addSelComProductForCA();
        a360.selectCompProductForCA();
        a360.removeCompProductForCA();
        a360.removingProductForCA();
        a360.goToInvitees();
        a360.selectInvitee();
        a360.addPortfToInvitee(); 
        a360.changeInviteeTimeSlots();
        a360.changeHostForInvitees();
        a360.changeLeftOptionList();
        a360.sortInviteesByTime();
        a360.sortInviteesByOrg();
        a360.acceptInvite();
        a360.declineInvite();
        a360.task = null;
        a360.showTaskPopup();
        a360.saveFollowUpTask();
        a360.taskWrapperList = null;
        a360.deleteFollowUpTaskEvent();
        a360.compRequest = null;
        a360.changeTypeOfCompAnalysis();
        a360.checkRequestCompAnalysis();
        a360.CompAnalysisWrapperList = null;
        a360.deleteCompAnalysisRecord();
        a360.deleteSpeakerRequestRecord();
        a360.saveMMR();
        a360.deleteMMRRecord();
        a360.parentTask = null;
        a360.goToAttachments();
        a360.changeRetailCallSubject();
        a360.changeActivitySubject();
        a360.oRecTypeActivity = null;
        a360.changingEventWhoId();
        a360.changingEventMethod();
        a360.parentEvent.whoId = cont.Id;
        a360.changeLocation();
        a360.parentEvent = null;
        a360.changeLocation();
        a360.startDateTimeChange();
        a360.startDateTime  = '12:00 AM';
        a360.startDateTimeChange();
        a360.inviteesMap = null;
        a360.removeInvitee();
        a360.addPortfToInvitee();
        a360.changeInviteeTimeSlots();
        a360.lstLeftOption = null;
        a360.changeLeftOptionList();
        a360.sortInviteesByTime();
        a360.sortInviteesByOrg();
        a360.ProductWrapperListForCA = null;
        a360.showCompAnalysisPopup();
        a360.selectCompProductForCA();
        a360.removeCompProductForCA();
        a360.removingProductForCA();
        a360.saveCompAnalysis();
        a360.mRightSelected = null;
        a360.selectInvitee();
        a360.placholderEventRequest = null;
        a360.updateSR();
        a360.SpeakerWrapperList = null;
        a360.updateSR();
        a360.competitorProdWrapperList = null;
        a360.removingCompetitorProduct();
        a360.taskWrapperList = null;
        a360.highInterestProductCheck();
        a360.selectedInviteesALJSString = usr.id;
        a360.searchInvitee();
        a360.selectedInviteesALJSString = 'test;test';
        a360.addInvitees();
        a360.inviteesMap = null;
        a360.addPortfToInvitee();
        a360.task = null;
        a360.showTaskPopup();
        
    }
    
    //Test product utility class and related methods
    static testmethod void productActivityUtilityTest(){
        //Setting up data
        Account acc = MFS_TestDataUtility.createAccount(); 
        insert acc;
        Activity_Detail__c cNote=MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote;
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        insert usr;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;	    
        Product2 prodToAdd = MFS_TestDataUtility.createProduct();
        insert prodToAdd;
        Product2 prodToAdd2 = MFS_TestDataUtility.createProduct();
        insert prodToAdd2;  
        Task tsk=MFS_TestDataUtility.createTask(acc.Id);
        tsk.Activity_Detail__c=cNote.Id;
        tsk.Subject='Meeting';
        tsk.Status='Open';
        tsk.Priority='Medium';
        tsk.Reason_for_Call__c='Product Call';
        tsk.Call_Outcome__c='Voicemail';
        tsk.Call_Category__c='Inbound';
        tsk.Call_Note_Parent_Task_Event__c=true;
        tsk.WhatId = acc.Id;
        tsk.WhoId = cont.Id;	
        tsk.recordtypeId=Schema.SObjectType.Task.getRecordTypeInfosByName().get(RET_TASK).getRecordtypeId();
        insert tsk;
        
        //Setting Page URL and calling controller
        ApexPages.currentPage().getParameters().put('id',cNote.Id);
        ApexPages.currentPage().getParameters().put('task','true');
        ApexPages.currentPage().getParameters().put('event','false');
        ApexPages.currentPage().getParameters().put('RecType','Retail');
        ApexPages.currentPage().getParameters().put('returnID',acc.Id);
        MFS_Activity360Controller a360 = new MFS_Activity360Controller();
        
        Test.startTest();
        //Linking first product with Activity 
        a360.oProductJN.Product__c = prodToAdd.id;
        a360.productSearchBtnName = 'MFSPortfolio';
        a360.selectedProduct = prodToAdd.id;
        a360.addSeletedProduct();
        //Linking second product with Activity 
        a360.oProductJN.Product__c = prodToAdd2.id; 
        a360.oProductJN.High_Interest__c = true;
        a360.productSearchBtnName = 'MFSPortfolio';
        a360.selectedProduct = prodToAdd2.id;        
        a360.addSeletedProduct(); 
        //Linking existing product with Activity 
        a360.oProductJN.Product__c = prodToAdd2.id;
        a360.oProductJN.High_Interest__c = true; 
        a360.productSearchBtnName = 'MFSPortfolio';
        a360.selectedProduct = prodToAdd2.id;        
        a360.addSeletedProduct();
        //Linking first product with Activity 
        a360.oProductJN.Product__c = prodToAdd.id;
        a360.productSearchBtnName = 'SelectInvitee';
        a360.selectedProduct = prodToAdd.id;
        a360.addSeletedProduct();
        //recreate the wrapper
        a360.goToProduct();
        system.assertEquals(2, a360.ProductWrapperList.size());
        //De-linking the Product from Activity
        a360.individualChildRecordId = prodToAdd.id;
        a360.removingProduct();
        system.assertEquals(1, a360.ProductWrapperList.size());
        
        //Checking the product as High Interest
        //a360.highInterestChecked = TRUE;
        a360.individualChildRecordId = prodToAdd2.id;
        a360.highInterestProductCheck();
        a360.getSeletedProduct();
        a360.addingCompetitorProduct ();
        a360.addingProduct ();
        a360.isselected = 'true';
        a360.getSeletedProduct();
        a360.isselected = 'false';
        a360.getSeletedProduct();
        Test.stopTest(); 
    }
    
    //Test competitor product utility and related methods
    static testmethod void compProductActivityUtilityTest(){
        //Setting up data
        Account acc = MFS_TestDataUtility.createAccount(); 
        insert acc;
        Activity_Detail__c cNote=MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote;
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        insert usr;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;	    
        Product2 prodToAdd = MFS_TestDataUtility.createProduct();
        insert prodToAdd;
        Product2 prodToAdd2 = MFS_TestDataUtility.createProduct();
        insert prodToAdd2; 
        Competitor_Product__c comProd1 = MFS_TestDataUtility.createComptrProduct();
        insert comProd1;
        Competitor_Product__c comProd2 = MFS_TestDataUtility.createComptrProduct();
        insert comProd2; 
        Task tsk=MFS_TestDataUtility.createTask(acc.Id);
        tsk.Activity_Detail__c=cNote.Id;
        tsk.Subject='Meeting';
        tsk.Status='Open';
        tsk.Priority='Medium';
        tsk.Reason_for_Call__c='Product Call';
        tsk.Call_Outcome__c='Voicemail';
        tsk.Call_Category__c='Inbound';
        tsk.Call_Note_Parent_Task_Event__c=true;
        tsk.WhatId = acc.Id;
        tsk.WhoId = cont.Id;	
        tsk.recordtypeId=Schema.SObjectType.Task.getRecordTypeInfosByName().get(RET_TASK).getRecordtypeId();
        insert tsk;
        
        //Setting Page URL and calling controller
        ApexPages.currentPage().getParameters().put('id',cNote.Id);
        ApexPages.currentPage().getParameters().put('task','true');
        ApexPages.currentPage().getParameters().put('event','false');
        ApexPages.currentPage().getParameters().put('RecType','Retail');
        ApexPages.currentPage().getParameters().put('returnID',acc.Id);
        MFS_Activity360Controller a360 = new MFS_Activity360Controller();
        
        Test.startTest();
        //Linking first Competitor product with Activity 
        a360.oCompProductJN.Competitor_Product__c = comProd1.id;
        a360.selectedComProduct = comProd1.id;
        a360.addSelComProduct();
        System.assertEquals(1, a360.competitorProdWrapperList.size());
        a360.addingCompetitorProduct();
        //Linking second Competitor product with Activity 
        a360.oCompProductJN.Competitor_Product__c = comProd2.id; 
        a360.selectedComProduct = comProd2.id;
        a360.addSelComProduct();        
        System.assertEquals(2, a360.competitorProdWrapperList.size());
        a360.addingCompetitorProduct(); 
        //recreate the wrapper
        a360.goToCompetitorProduct();
        //De-linking the Competitor Product from Activity
        a360.individualChildRecordId = comProd1.id;
        a360.removingCompetitorProduct();
        Test.stopTest(); 
    }
    
    //Test Meeting material request utility and related methods
    public static testMethod void testMeetingMaterialRequest(){
        Account acc = MFS_TestDataUtility.createAccount();
        Test.startTest();
        insert acc;
        Activity_Detail__c cNote = MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote;
        Task tsk = MFS_TestDataUtility.createTask(acc.Id);
        tsk.Activity_Detail__c= cNote.Id; 
        tsk.Call_Note_Parent_Task_Event__c=true;
        tsk.recordtypeId=Schema.SObjectType.Task.getRecordTypeInfosByName().get(RET_TASK).getRecordtypeId();
        insert tsk;
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        usr.LanguageLocaleKey = 'ja';
        insert usr;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        Contact cont1 = MFS_TestDataUtility.createContact(acc.id);
        insert cont1;
        Event evnt = MFS_TestDataUtility.createEventWithContact(cont.Id);
        evnt.Event_Start_Date__c = system.Today();
        evnt.Event_End_Date__c = system.Today();
        evnt.Activity_Detail__c= cNote.Id;
        evnt.Call_Note_Parent_Task_Event__c = true;
        evnt.recordtypeid= Schema.SObjectType.Event.getRecordTypeInfosByName().get(RET_EVENT).getRecordtypeId();
        insert evnt;
        Product2 prod = MFS_TestDataUtility.createProduct(); 
        insert prod;
        ApexPages.currentPage().getParameters().put('id',cNote.Id);
        ApexPages.currentPage().getParameters().put('orgId',acc.Id); 
        ApexPages.currentPage().getParameters().put('contId',cont.Id);
        ApexPages.currentPage().getParameters().put('task','true');
        ApexPages.currentPage().getParameters().put('event','true');
        ApexPages.currentPage().getParameters().put('RecType','Institutional');
        ApexPages.currentPage().getParameters().put('returnID',acc.Id);
        String CallNote = cNote.Id;
        String calNote18 = CallNote;
        MFS_Activity360Controller Act360Record = new MFS_Activity360Controller();
        
        Event evnt2 = MFS_TestDataUtility.createEventWithContact(cont.Id);
        evnt2.Activity_Detail__c= Act360Record.callNote.Id;
        evnt2.Call_Note_Parent_Task_Event__c = true;
        evnt2.Event_Start_Date__c = system.Today();
        evnt2.Event_End_Date__c = system.Today();
        insert evnt2;
        Event evnt3 = MFS_TestDataUtility.createEventWithContact(cont.Id);
        evnt3.Activity_Detail__c= Act360Record.callNote.Id;
        evnt3.Call_Note_Parent_Task_Event__c = false;
        insert evnt3;
        EventRelation evRel1 = new EventRelation(EventId=evnt2.Id,isInvitee=true,RelationId=cont1.Id);
        insert evRel1;
        EventRelation evRel2 = new EventRelation(EventId=evnt2.Id,isInvitee=true,RelationId=usr.Id);
        insert evRel2;
        EventRelation evRel3 = new EventRelation(EventId=evnt.Id,isInvitee=true,RelationId=usr.Id);
        insert evRel3;
        Task tsk2 = MFS_TestDataUtility.createTask(acc.Id);
        tsk2.Activity_Detail__c = Act360Record.callNote.Id;
        tsk2.Call_Note_Parent_Task_Event__c = false;
        insert tsk2;
        
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
        List<MMR_Client_Investment_Association__c> MMRCInvList = new List<MMR_Client_Investment_Association__c>();
        for(Integer i=0; i<5 ;i++)
        {
            MMR_Client_Investment_Association__c MMRCInv = new MMR_Client_Investment_Association__c(Meeting_Material_Request__c = MMR.Id, Client_Investment__c = cInvList[i].Id, Portfolio__c = cInvList[i].Portfolio__c);
            MMRCInvList.add(MMRCInv);
            
        }
        insert MMRCInvList;
        System.runAs(usr){
            MFS_Activity360Controller a360 = new MFS_Activity360Controller();
            a360.startDateTime = '1:30 PM';
            a360.endDateTime = '4:30 PM';
            a360.showMMRPopup();
            a360.MMR.Performance_Period__c = '1 Year;2 Years';
            a360.MMR.Attribution_Period__c = 'QTD';
            a360.MMR.Translation_Languages__c = 'French;German';
            a360.saveMMR();
            system.assertEquals(2, a360.MMRWrapperList.size());
            
            a360.individualChildRecordId = (String)MMR.Id;
            a360.showMMRPopup();
            a360.addLanguageFields();
            //2 languages are selcted in isert query
            system.assertEquals(2, a360.languageFields.size());
            
            a360.constructMMRName();
            a360.MMR.Client_Prospect_Name__c = acc.id;
            a360.MMR.Material_Type__c = 'Introductory Transition Call';
            a360.fetchMMRTeamMembers();
            a360.constructMMRRelatedList();
            a360.addMMRPortfolios();
            a360.MMR.Performance_Period__c = '1 Year;2 Years';
            a360.MMR.Attribution_Period__c = 'QTD';
            a360.MMR.Translation_Languages__c = 'French;German';
            a360.getSelectedPerformancePeriod();
            a360.getSelectedAttrPeriod();
            //5 Client Investments are added for MMR
            system.assertEquals(5, a360.MMRPortfolioWrapperList.size());
            
            a360.rmMMRPortfRow = '0';
            a360.removeMMRPortfolios();
            //Deleted 1 Client Investment
            system.assertEquals(4, a360.MMRPortfolioWrapperList.size());
            a360.removeSingleMMRClientInv();
            //Deleted one more
            system.assertEquals(3, a360.MMRPortfolioWrapperList.size());
            a360.saveMMR();
            a360.individualChildRecordId = (String)MMR.Id;
            a360.showAllRelatedSection = true;
            a360.editMMRRecord();
            a360.individualChildRecordId = (String)MMR.Id;
            a360.deleteMMRRecord();
            //Deleted one MMR
            system.assertEquals(1, a360.MMRWrapperList.size());
            a360.showAllRelatedSection = false;
            a360.deleteMMRRecord();
            a360.MMR.Do_materials_need_to_be_printed__c = 'Yes: Hardcopy Required';
            a360.addTransLanguage();
            a360.MMR.Translation_Languages__c = 'French;German;French Canadian;';
            a360.getAllLanguages();
            a360.MMR.Translation_Languages__c = 'French;German;French Canadian;';
            a360.getSelectedLanguages();
            a360.callNote = new Activity_Detail__c();
            a360.MMR = new Meeting_Material_Request__c();
            a360.MMR.Performance_Period__c = '1 Year;2 Years';
            a360.MMR.Attribution_Period__c = 'QTD';
            a360.MMR.Translation_Languages__c = 'French;German';
            a360.saveMMR();
            a360.MMRWrapperList = null;
            a360.editMMRRecord();
            a360.MMR = null;
            a360.addMMRPortfolios();
            a360.MMRPortfolioWrapperList = null;
            a360.removeMMRPortfolios();
            a360.addLanguageFields();
            a360.constructMMRName();
            a360.fetchMMRTeamMembers();
            a360.constructMMRRelatedList();
        }
    }
    
    //Test Competitive Analysis request utility and related methods
    static testmethod void compAnalysisRequestTest(){
        
        //Setting up data
        Account acc = MFS_TestDataUtility.createAccount(); 
        insert acc;
        Activity_Detail__c cNote=MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote;
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        insert usr;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;	
        Coverage_Team__c covTeam = new Coverage_Team__c(Contact__c = cont.Id,Coverage_Owner__c=userinfo.getUserId(),Coverage_Role__c='Internal Wholesaler');
        insert covTeam;  
        Product2 prodToAdd = MFS_TestDataUtility.createProduct();
        insert prodToAdd;
        Product2 prodToAdd2 = MFS_TestDataUtility.createProduct();
        insert prodToAdd2;  
        Call_Note_Product__c cProdjn1 = new Call_Note_Product__c(Product__c = prodToAdd.Id, Call_Note__c = cNote.Id);
        insert cProdjn1;
        Call_Note_Product__c cProdjn2 = new Call_Note_Product__c(Product__c = prodToAdd2.Id, Call_Note__c = cNote.Id);
        insert cProdjn2;
        Competitor_Product__c comProd = MFS_TestDataUtility.createComptrProduct();
        insert comProd;
        Competitor_Product__c comProd2 = MFS_TestDataUtility.createComptrProduct();
        insert comProd2;
        Competitive_Analysis_Request__c cAReq = new Competitive_Analysis_Request__c(Description__c='Test',Contact__c=cont.Id,Call_Note__c=cNote.Id);
        insert cAReq;  
        Competitive_Analysis_Product__c cap1 = new Competitive_Analysis_Product__c(Competitive_Analysis_Request__c = cAReq.id, Competitor_Product__c = comProd.id, Product__c = prodToAdd.Id );
        insert cap1;
        Competitive_Analysis_Product__c cap3 = new Competitive_Analysis_Product__c(Competitive_Analysis_Request__c = cAReq.id, Competitor_Product__c = comProd.id, Product__c = prodToAdd2.Id );
        insert cap3;
        Task tsk=MFS_TestDataUtility.createTask(acc.Id);
        tsk.Activity_Detail__c=cNote.Id;
        tsk.Subject='Meeting';
        tsk.Status='Open';
        tsk.Priority='Medium';
        tsk.Reason_for_Call__c='Product Call';
        tsk.Call_Outcome__c='Voicemail';
        tsk.Call_Category__c='Inbound';
        tsk.Call_Note_Parent_Task_Event__c=true;
        tsk.WhatId = acc.Id;
        tsk.WhoId = cont.Id;	
        tsk.recordtypeId=Schema.SObjectType.Task.getRecordTypeInfosByName().get(RET_TASK).getRecordtypeId();
        insert tsk;
        
        //Setting Page URL and calling controller
        ApexPages.currentPage().getParameters().put('id',cNote.Id);
        ApexPages.currentPage().getParameters().put('task','true');
        ApexPages.currentPage().getParameters().put('event','false');
        ApexPages.currentPage().getParameters().put('RecType','Retail');
        ApexPages.currentPage().getParameters().put('returnID',acc.Id);
        Test.startTest();
        MFS_Activity360Controller a360 = new MFS_Activity360Controller();
        a360.individualChildRecordId = cAReq.id;
        a360.showCompAnalysisPopup();
        a360.compRequest.Request_Report__c = TRUE;
        a360.compRequest.Type__c = 'Matrix Review';
        a360.checkRequestCompAnalysis();        
        a360.compRequest.Type__c = 'FI360';
        a360.checkRequestCompAnalysis();
        a360.compRequest.Request_Report__c = FALSE;
        a360.checkRequestCompAnalysis();
        a360.individualChildRecordId = prodToAdd.Id;
        a360.selectedCompProduct = comProd2.id;
        a360.selectCompProductForCA();
        system.assertEquals(2, a360.ProductWrapperListForCA.size());
        a360.individualChildRecordId = prodToAdd2.Id;
        a360.selectedCompProduct = comProd2.id;
        a360.selectCompProductForCA();
        system.assertEquals(2, a360.ProductWrapperListForCA.size());
        a360.individualChildRecordId = prodToAdd.Id;
        a360.selectedCompProduct = comProd.id;
        a360.removeCompProductForCA();
        system.assertEquals(2, a360.ProductWrapperListForCA.size());
        a360.individualChildRecordId = prodToAdd2.Id;
        a360.removingProductForCA();
        system.assertEquals(1, a360.ProductWrapperListForCA.size());
        a360.saveCompAnalysis();
        a360.individualChildRecordId = cAReq.id;
        a360.deleteCompAnalysisRecord();
        a360.individualChildRecordId = NULL;
        a360.showCompAnalysisPopup();
        a360.saveCompAnalysis();
        
        a360.individualChildRecordId = prodToAdd.Id;
        a360.selectedCompProduct = comProd.id;
        a360.selectedComProductForCA = comProd.id;
        a360.addSelComProductForCA();
        a360.saveCompAnalysis();
        a360.compRequest.Notify__c = usr.id;
        a360.compRequest.Contact__c = cont.id;
        MFS_CompetitiveAnalysisRequestUtiltiy.postChatterWhenCompRequestCreated(a360.compRequest);
        List<String> lstAdditionalIDs = new List<String>();
        lstAdditionalIDs.add(usr.id);
        MFS_CompetitiveAnalysisRequestUtiltiy.postChatterWhenCompRequestCreated(a360.compRequest,acc.id,lstAdditionalIDs);
        List<ID> lstIDs = new List<ID>();
        lstIDs.add(usr.id);
        MFS_ChatterApiUtility.postChatterWithSingleTextMultiMentionAndSingleLink(lstIDs, cont.id, 'chatter text', a360.compRequest.id);
        MFS_ChatterApiUtility.postChatterWithSingleTextSingleMentionAndSingleLink(usr.id,lstIDs,cont.id, 'chatter text', a360.compRequest.id);
        MFS_ChatterApiUtility.postChatterWithSingleTextAndMention(usr.id,cont.id, 'chatter text');
        a360.lstAvailableCompRequestNotifiers = new List<SelectOption>();
        a360.lstSelectedNotifiersForCA = new List<String>();
        MFS_CompetitiveAnalysisRequestUtiltiy.initializeNotifierMultiSelection(NULL,cont.id,  a360.lstAvailableCompRequestNotifiers,  a360.lstSelectedNotifiersForCA);
        Test.stopTest(); 
    }
    
    //Test Speaker Request
    static testmethod void speakerRequestTest(){
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        usr.LanguageLocaleKey = 'ja';
        insert usr;         
        Event_Request__c er = MFS_TestDataUtility.createEventRequest  (usr.id);       
        insert er;
        User speaker = MFS_TestDataUtility.createUser('System Administrator');
        speaker.Requires_Speaker_Approval__c = true;
        speaker.UserName = 'speaker@mfstest.com';
        speaker.Email =  'speaker@mfstest.com';
        insert speaker;         
        System.assert(acc != null);
        Activity_Detail__c cNote = MFS_TestDataUtility.createCallNote(acc.Id);
        cNote.Subject__c = 'Orphan Record';
        insert cNote;
        Id usrId = usr.Id;
        Contact cont = MFS_TestDataUtility.createContact(acc.id); 
        insert cont;
        Product2 prod = MFS_TestDataUtility.createProduct();
        insert prod;
        Competitor_Product__c comProd = MFS_TestDataUtility.createComptrProduct();
        insert comProd;
        
        //Set test page and URL parameters
        PageReference pf = Page.MFS_Activity360PageSF1;
        Test.setCurrentPage(pf);
        ApexPages.currentPage().getParameters().put('Id',cNote.Id);
        ApexPages.currentPage().getParameters().put('isConsole','false');
        ApexPages.currentPage().getParameters().put('returnID',acc.Id);
        ApexPages.currentPage().getParameters().put('RecType','Institutional');
        ApexPages.currentPage().getParameters().put('isNew','true');
        ApexPages.currentPage().getParameters().put('event','true');
        
        MFS_Activity360Controller a360 = new MFS_Activity360Controller();
        
        //Future Event
        a360.parentEvent.StartDateTime = system.now().addDays(1);
        a360.parentEvent.EndDateTime = a360.parentEvent.StartDateTime.addMinutes(60);
        //Add Speaker as invitee for the Event
        a360.mRightSelected.put(speaker.id,speaker.Name + '-User');
        Test.startTest();
        a360.addInvitees();
        System.runAs(usr){
            a360.parentEvent.Activity_Type_for_Instit__c = 'Semi-Finals';
            a360.save();
        }
        
        //Once saved, Speaker REquest Popup window will appear to update the request
        a360.placholderEventRequest.TimeZone__c = 'IST India Standard Time GMT+5:30';
        a360.placholderEventRequest.City__c = 'New York';
        ID tempID = a360.placholderEventRequest.id;
        a360.updateSR();
        //Followup task to update request later
        a360.isFollowupTaskForER = true;
        a360.showTaskPopup();
        a360.saveFollowUpTask();
        a360.individualChildRecordId = tempID;
        a360.deleteSpeakerRequestRecord();
        Test.stopTest();
        cNote.Event_Request__c = er.id;
        a360.save();
        MFS_Activity360Controller Act360past = new MFS_Activity360Controller();
        //Past Event
        Act360past.parentEvent.StartDateTime = system.now().addDays(-1);
        Act360past.parentEvent.EndDateTime = a360.parentEvent.StartDateTime.addMinutes(60);
        //Add Speaker as invitee for the Event
        Act360past.mRightSelected.put(speaker.id,speaker.Name + '-User');
        Act360past.addInvitees();
        Act360past.save();
        //Once saved, Speaker REquest Popup window will appear to select the existing Event Request
        Act360past.tempEventRelation.Speaker_Request__c = er.id;
        Act360past.updateSR();
    }
    
    //Test for RES Opportunity Button
    static testmethod void Activity360RESTest1(){
        Account acc = MFS_TestDataUtility.createAccount(); 
        Test.startTest();
        insert acc;
        System.assert(acc != null);
        Activity_Detail__c cNote = MFS_TestDataUtility.createCallNote(acc.Id);
        cNote.Has_RES_Record__c = false;
        insert cNote; 
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        insert usr;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        Contact cont1 = MFS_TestDataUtility.createContact(acc.id);
        insert cont1;
        Opportunity opp = MFS_TestDataUtility.createOpportunity(acc.Id); 
        insert opp;
        Event_Request__c er= MFS_TestDataUtility.createEventReq(usr.Id);
        er.Call_Note__c = cNote.Id;
        insert er;
        Event evnt = MFS_TestDataUtility.createEventWithContact(cont.Id); 
        evnt.Event_Start_Date__c = system.Today();
        evnt.Event_End_Date__c = system.Today();
        evnt.Activity_Detail__c= cNote.Id;
        evnt.WhatId = acc.Id;
        evnt.WhoId = cont.Id;
        evnt.Call_Note_Parent_Task_Event__c = true;
        evnt.recordtypeid= Schema.SObjectType.Event.getRecordTypeInfosByName().get(RET_EVENT).getRecordtypeId();
        evnt.Activity_Type_for_Instit__c = 'MFS Event;Semi-Finals;';
        evnt.Activity_SubType__c = 'DB Trends;DC Trends';
        evnt.WhoId = cont.Id;
        evnt.WhatId = acc.Id;
        insert evnt;
        System.assert(evnt!= null);
        Product2 prod = MFS_TestDataUtility.createProduct(); 
        insert prod;
        PricebookEntry pbEntry=MFS_TestDataUtility.createPriceBEntry(prod);  
        pbEntry.currencyisocode = 'USD';
        insert pbEntry; 
        Competitor_Product__c comProd = MFS_TestDataUtility.createComptrProduct();
        insert comProd;
        Call_Note_Competitor_Product__c comProdjn = new Call_Note_Competitor_Product__c(Competitor_Product__c = comProd.Id, Call_Note__c = cNote.Id );
        insert comProdjn;
        Call_Note_Product__c cProdjn = new Call_Note_Product__c(Product__c = prod.Id, Call_Note__c = cNote.Id);
        insert cProdjn;
        Competitive_Analysis_Request__c cAReq = new Competitive_Analysis_Request__c(Description__c='Test',Contact__c=cont.Id,Call_Note__c=cNote.Id);
        insert cAReq;
        PageReference pg = Page.MFS_Activity360RetailPageSF1;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id',cNote.Id);
        ApexPages.currentPage().getParameters().put('orgId',acc.Id); 
        ApexPages.currentPage().getParameters().put('optId',opp.Id);
        ApexPages.currentPage().getParameters().put('contId',cont.Id);
        ApexPages.currentPage().getParameters().put('event','true');
        ApexPages.currentPage().getParameters().put('RecType','Retail');
        ApexPages.currentPage().getParameters().put('returnID',acc.Id);
        
        MFS_Activity360Controller a360 = new MFS_Activity360Controller();
        a360.initi();
        a360.oProductJN = cProdjn;
        a360.oCompProductJN = comProdjn;
        a360.startDateTime = '1:30 PM';
        a360.endDateTime = '4:30 PM';
        a360.parentEvent.WhoId = cont.id;
        a360.parentEvent = evnt;
        a360.save();
        a360.edit();
        a360.showRESPopUp();
        a360.op.name = 'opp name';
        a360.op.Stagename = 'In Progress';
        a360.op.AccountId = acc.Id;
        a360.op.Probability = 20;
        a360.op.Client_Contact__c = cont.id;
        a360.op.CloseDate = system.today();
        a360.op.Notification_Date__c= system.today();
        a360.selectedCoverageTeamMembers = usr.Id;
        a360.saveRESRecord();
        a360.closeRESRecord();
        test.stopTest();
    }
    
    //Test additional logic for RES
    static testmethod void Activity360RESTest2(){
        //Setup the test data
        Account acc = MFS_TestDataUtility.createAccount(); 
        Test.startTest();
        insert acc;
        System.assert(acc != null);
        Activity_Detail__c cNote = MFS_TestDataUtility.createCallNote(acc.Id);
        cNote.Has_RES_Record__c = false;
        insert cNote; 
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        insert usr;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        Contact cont1 = MFS_TestDataUtility.createContact(acc.id);
        insert cont1;
        Opportunity opp = MFS_TestDataUtility.createOpportunity(acc.Id); 
        insert opp;
        Event_Request__c er= MFS_TestDataUtility.createEventReq(usr.Id);
        er.Call_Note__c = cNote.Id;
        insert er;
        Coverage_Team__c covTeam = new Coverage_Team__c(Contact__c = cont.Id,Coverage_Owner__c=userinfo.getUserId(),Coverage_Role__c='Internal Wholesaler');
        insert covTeam;
        Task tsk = MFS_TestDataUtility.createTask(acc.Id);
        tsk.Activity_Detail__c= cNote.Id; 
        tsk.Subject='Meeting';
        tsk.Status = 'Open';
        tsk.Priority = 'Medium';
        tsk.Reason_for_Call__c = 'Product Call';
        tsk.Call_Outcome__c = 'voicemail';
        tsk.Call_Category__c = 'Inbound';
        tsk.Call_Note_Parent_Task_Event__c=true;
        tsk.WhoId = cont.Id;
        tsk.WhatId = acc.Id;
        tsk.recordtypeId=Schema.SObjectType.Task.getRecordTypeInfosByName().get(RET_TASK).getRecordtypeId();
        insert tsk;
        System.assert(tsk!= null);
        
        Product2 prod = MFS_TestDataUtility.createProduct(); 
        insert prod;
        PricebookEntry pbEntry=MFS_TestDataUtility.createPriceBEntry(prod);  
        pbEntry.currencyisocode = 'USD';
        insert pbEntry;
        Competitor_Product__c comProd = MFS_TestDataUtility.createComptrProduct();
        insert comProd;
        Call_Note_Competitor_Product__c comProdjn = new Call_Note_Competitor_Product__c(Competitor_Product__c = comProd.Id, Call_Note__c = cNote.Id );
        insert comProdjn;
        Call_Note_Product__c cProdjn = new Call_Note_Product__c(Product__c = prod.Id, Call_Note__c = cNote.Id);
        insert cProdjn;
        Competitive_Analysis_Request__c cAReq = new Competitive_Analysis_Request__c(Description__c='Test',Contact__c=cont.Id,Call_Note__c=cNote.Id);
        insert cAReq;
        
        PageReference pg = Page.MFS_Activity360RetailPageSF1;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id',cNote.Id);
        ApexPages.currentPage().getParameters().put('orgId',acc.Id); 
        ApexPages.currentPage().getParameters().put('optId',opp.Id);
        ApexPages.currentPage().getParameters().put('contId',cont.Id);
        ApexPages.currentPage().getParameters().put('task','true');
        ApexPages.currentPage().getParameters().put('RecType','Retail');
        ApexPages.currentPage().getParameters().put('returnID',acc.Id);
        MFS_Activity360Controller a360 = new MFS_Activity360Controller();
        a360.parentTask.Id = tsk.id;
        a360.parentTask.Call_Outcome__c = 'Voicemail';
        a360.showRESPopUp();
        a360.op.name = 'opp name';
        a360.op.Stagename = 'In Progress';
        a360.op.AccountId = acc.Id;
        a360.op.Probability = 20;
        a360.op.Client_Contact__c = cont.id;
        a360.op.CloseDate = system.today();
        a360.op.Notification_Date__c= system.today();
        a360.selectedCoverageTeamMembers = usr.Id;
        a360.saveRESRecord();
        a360.individualChildRecordId = a360.ProductWrapperListForRES[0].wProduct.Id;
        a360.removeProductFromRES();
        a360.individualChildRecordId = a360.compProdWrapperListForRES[0].wCompProduct.Id;
        a360.removeCompProductFromRES();
        a360.closeRESRecord();
        a360.op = null;
        a360.changeDates();
        a360.ProductWrapperList = null;
        a360.showRESPopUp();
        a360.removingProduct();
        test.stopTest();
        //exception
        a360.ProductWrapperListForRES = null;
        a360.removeProductFromRES();
        a360.compProdWrapperListForRES = null;
        a360.removeCompProductFromRES();
    }
    
    //Test follow up task
    static testmethod void followUpTest(){
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        insert usr;         
        Event_Request__c er = MFS_TestDataUtility.createEventRequest  (usr.id);       
        insert er;
        User speaker = MFS_TestDataUtility.createUser('System Administrator');
        Test.startTest();
        System.assert(acc != null);
        Activity_Detail__c cNote = MFS_TestDataUtility.createCallNote(acc.Id);
        cNote.Subject__c = 'Orphan Record';
        insert cNote;
        Id usrId = usr.Id;
        Contact cont = MFS_TestDataUtility.createContact(acc.id); 
        insert cont;
        //Set the pag efor testing
        PageReference pf = Page.MFS_Activity360PageSF1;
        Test.setCurrentPage(pf);
        ApexPages.currentPage().getParameters().put('Id',cNote.Id);
        ApexPages.currentPage().getParameters().put('isConsole','false');
        ApexPages.currentPage().getParameters().put('returnID',acc.Id);
        ApexPages.currentPage().getParameters().put('RecType','Institutional');
        ApexPages.currentPage().getParameters().put('isNew','true');
        ApexPages.currentPage().getParameters().put('event','true');
        MFS_Activity360Controller a360 = new MFS_Activity360Controller();
        
        //Future Event
        a360.parentEvent.StartDateTime = system.now().addDays(1);
        a360.parentEvent.EndDateTime = a360.parentEvent.StartDateTime.addMinutes(60);
        a360.save();
        a360.showTaskPopup();
        Task tsk = MFS_TestDataUtility.createTask(acc.Id);
        tsk.Activity_Detail__c= cNote.Id; 
        tsk.Subject='Meeting';
        tsk.Status = 'Open';
        tsk.Priority = 'Medium';
        tsk.Reason_for_Call__c = 'Product Call';
        tsk.Call_Outcome__c = 'voicemail';
        tsk.Call_Category__c = 'Inbound';
        tsk.Call_Note_Parent_Task_Event__c=true;
        tsk.Parent_Activity_Detail_Id__c=cNote.id;
        tsk.recordtypeId=Schema.SObjectType.Task.getRecordTypeInfosByName().get(RET_TASK).getRecordtypeId();
        insert tsk;
        a360.task = tsk;
        a360.saveFollowUpTask();
        a360.individualChildRecordId =tsk.id; 
        a360.taskWrapperList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        a360.taskWrapperList.add(new MFS_Activity360GeneralUtility.wrapperClass(tsk,false)); 
        a360.editFollowUpTaskRecord();
        a360.individualChildRecordId =tsk.id; 
        a360.showTaskPopup();
        a360.individualChildRecordId =tsk.id; 
        a360.deleteFollowUpTaskEvent();
        a360.createEventRequest();
        Test.stopTest();	
    }
    
    static testmethod void additionalMethodsTest(){
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        insert usr;         
        Event_Request__c er = MFS_TestDataUtility.createEventRequest  (usr.id);       
        insert er;
        User speaker = MFS_TestDataUtility.createUser('System Administrator');
        speaker.Requires_Speaker_Approval__c = true;
        speaker.UserName = 'speaker@mfstest.com';
        speaker.Email =  'speaker@mfstest.com';
        insert speaker;         
        Test.startTest();
        System.assert(acc != null);
        Activity_Detail__c cNote = MFS_TestDataUtility.createCallNote(acc.Id);
        cNote.Subject__c = 'Orphan Record';
        insert cNote;
        Id usrId = usr.Id;
        Contact cont = MFS_TestDataUtility.createContact(acc.id); 
        insert cont;
        Coverage_Team__c covTeam = new Coverage_Team__c(Contact__c = cont.Id,Coverage_Owner__c=userinfo.getUserId(),Coverage_Role__c='Internal Wholesaler');
        insert covTeam;
        Product2 prod = MFS_TestDataUtility.createProduct();
        prod.IsActive=true;
        prod.Is_Unknown__c =false;
        prod.Restricted__c=false;
        insert prod;
        Competitor_Product__c comProd = MFS_TestDataUtility.createComptrProduct();
        insert comProd;
        Event evnt = MFS_TestDataUtility.createEventWithContact(cont.Id); 
        evnt.Event_Start_Date__c = system.Today();
        evnt.Event_End_Date__c = system.Today();
        evnt.Activity_Detail__c= cNote.Id;
        evnt.recordtypeid= Schema.SObjectType.Event.getRecordTypeInfosByName().get(RET_EVENT).getRecordtypeId();
        insert evnt;
        //Set test page and URL parameters
        PageReference pf = Page.MFS_Activity360PageSF1;
        Test.setCurrentPage(pf);
        ApexPages.currentPage().getParameters().put('id',cNote.Id);
        ApexPages.currentPage().getParameters().put('isConsole','false');
        ApexPages.currentPage().getParameters().put('returnID',acc.Id);
        ApexPages.currentPage().getParameters().put('RecType','Retail');
        ApexPages.currentPage().getParameters().put('isNew','true');
        ApexPages.currentPage().getParameters().put('event','true');
        MFS_Activity360Controller a360 = new MFS_Activity360Controller();
        MFS_Activity360Controller.queryCases('keyword');
        MFS_Activity360Controller.queryUsers('keyword');
        MFS_Activity360Controller.queryContacts('keyword');
        MFS_Activity360Controller.queryLeads('keyword');
        MFS_Activity360Controller.queryAccounts('keyword');
        MFS_Activity360Controller.queryOpportunities('keyword');
        MFS_Activity360Controller.queryClientInvestments('keyword');
        MFS_Activity360Controller.queryPortfolios('keyword');
        MFS_Activity360Controller.queryCampaign('keyword');
        MFS_Activity360Controller.queryBAR('keyword');
        MFS_Activity360Controller.queryStrategyPlans('keyword');
        MFS_Activity360Controller.querySpeakerRequests('keyword');
        MFS_Activity360Controller.queryConsultantRating('keyword');
        Boolean testisSF1 = a360.isSF1;
        
        a360.getInviteeTimeList();
        a360.getfollowUpTimeList();
        a360.MMR = new Meeting_Material_Request__c();
        a360.MMR.Performance_Period__c = '1 Year;2 Years';
        a360.MMR.Attribution_Period__c = 'QTD;YTD';
        a360.MMR.Translation_Languages__c = 'French;German;French Canadian;';
        a360.MMR.Time_Periods_Covered__c = '';
        a360.addTransLanguage();
        a360.uploadAttachment();
        a360.deleteAttachment();
        a360.editFollowUpRecord1();
        a360.getAllLanguages();
        //a360.getSelectedLanguages();
        a360.getPerformancePeriod();
        a360.getTimePeriodCovered();
        a360.getSelectedTimePeriodCovered();
        a360.getTimePeriodCoveredDefault();
        a360.getAttrPeriod();
        //a360.getSelectedAttrPeriod();
        a360.parentEvent.Activity_Type_for_Instit__c = 'Presentation';
        a360.getAllActivityType();
        a360.getSelectedActivityTypes();
        a360.task = new Task();
        a360.task.Activity_Type_for_Instit__c = 'Presentation';
        //a360.getAllActivityTypeForFollowUp();
        //a360.getSelectedActivityTypesForFollowUp();     
        
        String testjsonDataAllUsers =  a360.jsonDataAllUsers;
        a360.lstSelectedNotifiersForCA = new List<String>();
        a360.jsonUpdatedNotifiersForCA = '';
        a360.pullJsonForSelectedNotifiersOfCA();
        a360.showRESPopUp();
        a360.selectedCoverageTeamMembers = usr.Id;
        a360.saveRESRecord();
        a360.removeProductFromRES();
        a360.removeCompProductFromRES();
        a360.closeRESRecord();
        a360.getContactCoverageTeamMembers();
        a360.op = new Opportunity(StageName = 'Closed');
        a360.checkOpportunityStatus();
        a360.getOppCurrencyCodes();
        a360.changeDates();
        a360.changeHostForInvitees();
        a360.changeLeftOptionList();
        a360.parentEvent.StartDateTime = system.now().addDays(1);
        a360.parentEvent.EndDateTime = a360.parentEvent.StartDateTime.addMinutes(60);
        //Add Speaker as invitee for the Event
        a360.mRightSelected.put(speaker.id,speaker.Name + '-User');
        a360.addInvitees();  
        a360.parentEvent.whoId = cont.id;
       	a360.save();
        a360.sortInviteesByTime();
        a360.sortingOrder = 'ASC';
        a360.sortInviteesByTime();
        a360.sortInviteesByOrg();
        a360.sortingOrgOrder = 'ASC';
        a360.sortInviteesByOrg();
        a360.searchProduct();
        String testConstructQuery = a360.constructQuery('productName','productGeography','productVehicle');
        a360.getGeograhpyOptions();
        a360.getVehicleOptions();
        a360.searchComProduct();
        String testconstructQueryCom = a360.constructQueryCom('productName', 'firm');
        a360.assignSelectedInviteeId();
        a360.resetCompProdSearchPanelForCA();
        a360.addSeletedProduct();
        a360.addSelComProduct();
        a360.addSelComProductForCA();
        a360.getEventType();
        a360.setContactNameForLkp(); 
        a360.attachmentList = null;
        a360.deleteAttachment();
        a360.taskCallNote = true;
        a360.parentTask.whoId = cont.Id;
        a360.getContactCoverageTeamMembers();
        a360.parentEvent = evnt;
        a360.edit();
        a360.showMeetingPrepPopup();
        a360.updateMeetingPrep();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectOption('Test','Test'));
        a360.formatToMultiPicklist(options);
        a360.getPresentationURL();
        a360.callNote.Competitive_Information__c = 'test';
        a360.showMeetingPrepPopup();
        MFS_Activity360GeneralUtility.advanceTimeByOneHour(evnt, '12:30 AM');
        MFS_Activity360GeneralUtility.wrapperClass agUtility = new MFS_Activity360GeneralUtility.wrapperClass();
        agUtility.wEvent = null;
        agUtility.lstNotifiersForCompRequest = null;
        agUtility.wProductJNforCA = null;
        agUtility.mmrClientAsscn = null;
        agUtility.name = null;
        agUtility.type = null;
        agUtility.comments = null;
        agUtility.clientInvName = null;
        Test.stopTest();
    }
    @testSetup
    static void dataSetup(){
        List<Application_Settings__c> customSettings = MFS_TestDataUtility.getappSettingsList();
        insert customSettings;
    }
    
}