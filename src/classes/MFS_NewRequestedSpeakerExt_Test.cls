@isTest
public class MFS_NewRequestedSpeakerExt_Test {
  static testmethod void newrequestedSpeakerButtonTest()
  {
      Test.startTest();
      User usr = MFS_TestDataUtility.createUser('System Administrator');
      insert usr;
      Event_Request__c eReq = MFS_TestDataUtility.createEventRequest(usr.Id);
      insert eReq;
      Event_Relation__c reqSpkr = new Event_Relation__c(Speaker_Request__c = eReq.Id);
      List<Event_Relation__c> reqSpkrList = new List<Event_Relation__c>();
      reqSpkrList.add(reqSpkr);
      StoreFieldIds__c sfId = new StoreFieldIds__c(name='979820338',Field_API_Name__c='Speaker_Request__c',Field_Id__c='CF00NP0000000zoLz',Object_Name__c='Event_Relation__c',Field_Label__c='Speaker Request');
        insert sfId;
        
        StoreFieldIds__c sfId1 = new StoreFieldIds__c(name='979820339',Field_API_Name__c='Time_Slot_Start__c',Field_Id__c='00NP0000000zoOP',Object_Name__c='Event_Relation__c',Field_Label__c='Time Slot Start');
        insert sfId1;
        
        StoreFieldIds__c sfId2 = new StoreFieldIds__c(name='979820340',Field_API_Name__c='Time_Slot_End__c',Field_Id__c='00NP0000000zoOU',Object_Name__c='Event_Relation__c',Field_Label__c='Time Slot End');
        insert sfId2;
 
      MFS_NewRequestedSpeakerExt spkrExt = new MFS_NewRequestedSpeakerExt(new ApexPages.StandardSetController(reqSpkrList));
      PageReference pr =  new PageReference('/'+eReq.id);
      pr.getParameters().put('Id',eReq.id); 
      test.setCurrentPage(pr);
      PageReference result = spkrExt.redirect();
      //SONAR Fix
      System.assertNotEquals(null,result.getUrl());
      Test.StopTest();
  }
}