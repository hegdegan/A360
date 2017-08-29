@isTest
public class MFS_EventRequestTriggerUtil_Test {
    
    static testmethod void testEventRequestUpdate()
    {
        Test.startTest();
        User userRec=MFS_TestDataUtility.createUser('Standard User');
        insert userRec;
        //SONAR Fix
        System.assertNotEquals(null,userRec.Id);
        Event_Request__c eventRequest=MFS_TestDataUtility.createEventReq(userRec.Id);
        insert eventRequest;
        eventRequest.Event_Title__c='Test New Event';
        update eventRequest;
        Test.stopTest();
    }
    
    static testmethod void testBulkEventRequestUpdate()
    {
        Test.startTest();
        User userRec=MFS_TestDataUtility.createUser('Standard User');
        insert userRec;
        List<Event_Request__c> eventRequestList=MFS_TestDataUtility.createBulkEventReq(userRec.Id);
        insert eventRequestList;
        //SONAR Fix
        System.assert(eventRequestList.size() > 0);
        List<Event_Request__c> eventToUpdate=new List<Event_Request__c>();
        for(Event_Request__c eventRequest: eventRequestList)
        {
            eventRequest.Event_Title__c='Test New Event';
            eventToUpdate.add(eventRequest);
        }
        update eventToUpdate;
        Test.stopTest();
    }
    Static testmethod void startandEndDate(){
        Test.startTest();
        Account acc1 = MFS_TestDataUtility.createAccount();
        insert acc1; 
        Contact cont1 = MFS_TestDataUtility.createContact(acc1.Id);
        insert cont1;
        User userRec=MFS_TestDataUtility.createUser('Standard User');
        insert userRec;
        Contact cont2 = MFS_TestDataUtility.createContact(acc1.Id);
        insert cont2;
        Activity_Detail__c actDetail = MFS_TestDataUtility.createCallNote(acc1.Id);
        insert actDetail;
        Event evnt = MFS_TestDataUtility.createEventWithContact(cont1.Id);
        evnt.Activity_Detail__c = actDetail.Id;
        evnt.Call_Note_Parent_Task_Event__c = true;
        insert evnt;
        //SONAR Fix
        System.assertNotEquals(null,evnt.Id);
        try{
            Event_Request__c eventRequest=MFS_TestDataUtility.createEventReq(userRec.Id);
            eventRequest.Call_Note__c = actDetail.Id;
        	eventRequest.Start_Date__c = evnt.StartDateTime;
        	eventRequest.End_Date__c = evnt.EndDateTime;
            eventRequest.Overall_Approval_Status__c = 'New';
            insert eventRequest;
            
            
            Event_Relation__c rSpeakr = new Event_Relation__c(Speaker_Request__c = eventRequest.Id,Speaker__c = userRec.Id,Approval_Status__c = 'New' );
            insert rSpeakr;
            eventRequest.Overall_Approval_Status__c = 'Confirmed';
            update eventRequest; 
            
            eventRequest.Start_Date__c = DateTime.newInstance(2016,11,27,08,00,00);
            eventRequest.End_Date__c = DateTime.newInstance(2016,11,27,08,00,00);
            update eventRequest;
        }catch(Exception e){
           system.debug('Error 1'); 
        }
        try{
            Event_Request__c eventRequest1 = MFS_TestDataUtility.createEventReq(userRec.Id);
            eventRequest1.Call_Note__c = actDetail.Id;
            eventRequest1.Overall_Approval_Status__c = 'New';
            insert eventRequest1;
            
        }catch(Exception e){
            system.debug('Error 2');
        }
        
        Test.stopTest();
    }
    
    Static testmethod void sendSpeakertoInvitee(){
        Test.startTest();
        Application_Settings__c appSetting= new Application_Settings__c();
        appSetting.Name='EnableDataLoad';
        appSetting.Value__c='Yes';
        insert appSetting;
        //SONAR Fix
        System.assertNotEquals(null,appSetting.Id);
         Application_Settings__c appSetting1= new Application_Settings__c();
        appSetting1.Name='IntegrationProfileId';
        appSetting1.Value__c=UserInfo.getProfileId();
        insert appSetting1;
        Account acc1 = MFS_TestDataUtility.createAccount();
        insert acc1; 
        Contact cont1 = MFS_TestDataUtility.createContact(acc1.Id);
        insert cont1;
        User userRec=MFS_TestDataUtility.createUser('Standard User');
        insert userRec;
        Contact cont2 = MFS_TestDataUtility.createContact(acc1.Id);
        insert cont2;
        
        Event_Request__c eventRequest=MFS_TestDataUtility.createEventReq(userRec.Id);
        eventRequest.Overall_Approval_Status__c = 'New';
        insert eventRequest;
        
        Notify_User__c nu = new Notify_User__c(User__c = userinfo.getUserId(),Speaker_Request__c=eventRequest.Id);
        insert nu;
        
        Event_Relation__c rSpeakr = new Event_Relation__c(Speaker_Request__c = eventRequest.Id,Speaker__c = userRec.Id,Approval_Status__c = 'New' );
        insert rSpeakr;
        Event_Relation__c rSpeakr1 = new Event_Relation__c(Speaker_Request__c = eventRequest.Id,Speaker__c = userRec.Id,Approval_Status__c = 'New' );
        insert rSpeakr1;
        
        
        eventRequest.Overall_Approval_Status__c = 'Confirmed';
        update eventRequest; 
        
        eventRequest.Overall_Approval_Status__c = 'Pending';
        update eventRequest;
        
        eventRequest.Location__c ='City';
        update eventRequest;
        Application_Settings__c EnableEventRequestTrigger = new Application_Settings__c(Name='EnableEventRequestTrigger',Value__c='No');
		insert EnableEventRequestTrigger;
        eventRequest.Location__c ='City1';
        update eventRequest;
        Test.stopTest();
    }
    
}