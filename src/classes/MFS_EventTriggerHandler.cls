/**
Apex Class Name    : MFS_EventTriggerHandler
Version            : 1.0 
Created Date       : 11 MAY 2016
Function           : Handler class that gets called by Event Triggers 
when Event are created,updated and deleted
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              0/11/2016              Original Version
**/
public class MFS_EventTriggerHandler {
    //call Event utilities class before insert
    public static void beforeInsertEventTaskHandler(List<Event> newEventList){
        if(!newEventList.isEmpty())
        {
            MFS_EventUtilities.populateRelatedId(neweventList); 
            System.debug('1. Number of Queries used in this Apex code so far - beforeInsertEventTaskHandler: ' + Limits.getQueries());
            System.debug('2. Number of rows queried in this Apex code so far - beforeInsertEventTaskHandler: ' + Limits.getDmlRows());
            System.debug('3. Number of DML statements used so far - beforeInsertEventTaskHandler: ' +  Limits.getDmlStatements());    
            System.debug('4. Amount of CPU time (in ms) used so far - beforeInsertEventTaskHandler: ' + Limits.getCpuTime());

        }
    }
    //call event utilities class after update and perform update operation on Event 
    public static void afterUpdateMapEventTaskHandler(Map<Id,Event> newEventMap,Map<Id,Event> oldEventMap){
        try{
            if(!newEventMap.isEmpty())
            {
                List<Strategy_Plan__c> splanToUpdateList = MFS_EventUtilities.populateCounterInStrategyPlan(newEventMap,oldEventMap);
                Database.SaveResult[] updSplan = Database.update(splanToUpdateList,false);
                
                List<Event> eventToUpdateList = MFS_EventUtilities.populateRelatedIdAfterUpdate(newEventMap,oldEventMap);
                Database.SaveResult[] updEvent = Database.update(eventToUpdateList,false);
                
                System.debug('4. Amount of CPU time (in ms) used so far - afterUpdateMapEventTaskHandler: ' + Limits.getCpuTime());
            	System.debug('Final number of DML statements used so far - afterUpdateMapEventTaskHandler: ' +  Limits.getDmlStatements());
        		System.debug('Final heap size - afterUpdateMapEventTaskHandler: ' +  Limits.getHeapSize());
            }
            Set<Id> activityDetailId = new Set<Id>();
            List<Event> evntList = new List<Event>([Select StartDateTime,EndDateTime,Activity_Detail__c from Event where Id in : newEventMap.Keyset()]);
            List<Event_Request__c> evReqListToUpdate = new List<Event_Request__c>();
            for(Event event : evntList)
            {
                Event evNew = newEventMap.get(event.Id);
                Event evOld = oldEventMap.get(event.Id);
                if(evNew.StartDateTime != evOld.StartDateTime || evNew.EndDateTime != evOld.EndDateTime)
                {
                    activityDetailId.add(event.Activity_Detail__c);
                }
            }
            if(activityDetailId.size()>0)
            {
                List<Event_Request__c> evRequest = new List<Event_Request__c>([Select Id,Overall_Approval_Status__c from Event_Request__c where Call_Note__c in : activityDetailId]); 
                if(!evRequest.isEmpty())
                {
                    for(Event_Request__c evr : evRequest)
                    {
                        if(evr.Overall_Approval_Status__c == MFS_AllConstants.Confirmed) 
                        {
                            evr.Overall_Approval_Status__c = MFS_AllConstants.Pending;
                            evReqListToUpdate.add(evr);
                        }
                        
                    }
                }
                if(!evReqListToUpdate.isEmpty())
                {
                    update evReqListToUpdate;
                    List<String> idList = new List<String>();
                    List<String> mailToAddresses = new List<String>();
                    Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name =: System.Label.Event_Change_Notify_Public_Group];
                    for (GroupMember gm : g.groupMembers) 
                    {
                        idList.add(gm.userOrGroupId);
                    }
                    User[] usr = [SELECT email FROM user WHERE id IN :idList];
                    for(User u : usr) 
                    {
                        mailToAddresses.add(u.email);
                    }
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(mailToAddresses);
                    mail.setSubject(System.Label.Event_Time_Change_Notification_Subject);
                    mail.setPlainTextBody(System.Label.ER_Notifyuser_Email_Reminder+',\n\n'+ System.Label.Event_Time_Change_Notification);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    
                }
            }
        }Catch(Exception ex)
        {
            System.debug('Exception : '+ex.getStackTraceString());
        }
    }
    
    
    public static void afterInsertEventTaskHandler(List<Event> newEventList){
        if(!newEventList.isEmpty())  
        {
            List<Opportunity> oppToUpdateList = MFS_EventUtilities.populateOpportunityLastActivityDate(newEventList); 
            Database.SaveResult[] updOpp = Database.update(oppToUpdateList,false);
            System.debug('4. Amount of CPU time (in ms) used so far - afterInsertEventTaskHandler: ' + Limits.getCpuTime());
            System.debug('Final number of DML statements used so far - afterInsertEventTaskHandler: ' +  Limits.getDmlStatements());
        	System.debug('Final heap size - afterInsertEventTaskHandler: ' +  Limits.getHeapSize());
            
        }
    }
    // Insert Activity Detail records for dataloads
    public static void InsertADRecords(List<Event> evtList) {
        Boolean isDataLoadEnabledForActivities = MFS_Utilities.GetAppSettingValue('EnableDataLoad', 'Yes') == 'Yes' ? true : false;
        //Check 1 - check if the dataload custom setting enabled
        if(isDataLoadEnabledForActivities){
            //Check 2 - check if the current user is the Informatica user 
            if(MFS_AllConstants.IntegrationProfileId !=null && UserInfo.getProfileId().contains(MFS_AllConstants.IntegrationProfileId.value__c)) {
                system.debug('Im an Informatica user');
                List<Activity_Detail__c> adToInsert = MFS_EventUtilities.insertActivityDetail(evtList);
                Database.SaveResult[] insAd = Database.insert(adToInsert,false);
                System.debug('4. Amount of CPU time (in ms) used so far - InsertADRecords: ' + Limits.getCpuTime());
                System.debug('Final number of DML statements used so far - InsertADRecords: ' +  Limits.getDmlStatements());
                System.debug('Final heap size - InsertADRecords: ' +  Limits.getHeapSize());
            }
        }
    }
    
    // Update Activity Detail records for dataloads
    public static void updateADRecords(Map<Id,Event> oldEventMap, Map<Id,Event> newEventMap) {
        Boolean isDataLoadEnabledForActivities = MFS_Utilities.GetAppSettingValue('EnableDataLoad', 'Yes') == 'Yes' ? true : false;
        //Check 1 - check if the dataload custom setting enabled
        if(isDataLoadEnabledForActivities){
            //Check 2 - check if the current user is the Informatica user 
            if(MFS_AllConstants.IntegrationProfileId !=null && UserInfo.getProfileId().contains(MFS_AllConstants.IntegrationProfileId.value__c)) {
                system.debug('Im an Informatica user');
                List<Activity_Detail__c> adToUpdate = MFS_EventUtilities.updateAD(oldEventMap,newEventMap);
                Database.SaveResult[] updAd = Database.update(adToUpdate,false);
                System.debug('4. Amount of CPU time (in ms) used so far - InsertADRecords: ' + Limits.getCpuTime());
                System.debug('Final number of DML statements used so far - InsertADRecords: ' +  Limits.getDmlStatements());
                System.debug('Final heap size - InsertADRecords: ' +  Limits.getHeapSize());
            }
        }
    }
}