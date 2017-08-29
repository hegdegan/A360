@isTest(seeAllData = false)
public class MFS_RequestedSpeakerTriggerTest {
    
    static testMethod void showOrgSalesAndAssetsForRetail(){    
        Test.startTest();
        Application_Settings__c appSetting= new Application_Settings__c();
        appSetting.Name='EnableDataLoad';
        appSetting.Value__c='Yes';
        insert appSetting;
         Application_Settings__c appSetting1= new Application_Settings__c();
        appSetting1.Name='IntegrationProfileId';
        appSetting1.Value__c=UserInfo.getProfileId();
        insert appSetting1;
        Account acc1 = MFS_TestDataUtility.createAccount();
        insert acc1; 
        Contact cont1 = MFS_TestDataUtility.createContact(acc1.Id);
        insert cont1;
        
        User demo = MFS_TestDataUtility.createUser('System Administrator');
        insert demo;
        
        Event_Request__c eReq = MFS_TestDataUtility.createEventRequest(demo.Id);
        insert eReq;
        System.assert(eReq != null);
        
        Event_Relation__c reSpeaker = new Event_Relation__c(Speaker_Request__c=eReq.Id);
        insert reSpeaker;
        System.assert(reSpeaker != null);
        reSpeaker.Approval_Status__c = 'Pending';
        update reSpeaker;
        Event_Request__c eReqRec = [Select Overall_Approval_Status__c from Event_Request__c where id =: eReq.Id];
        System.assertEquals('Pending',eReqRec.Overall_Approval_Status__c);
        reSpeaker.Approval_Status__c = 'Approved';
        update reSpeaker;
        Test.stopTest();
        
        
    }
    
}