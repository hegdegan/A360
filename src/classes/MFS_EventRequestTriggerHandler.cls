/**
Apex Class Name    : MFS_EventRequestTriggerHandler
Version            : 1.0 
Created Date       : 17 Aug 2016
Function           : Handler class that gets called by Event Triggers 
when Event Request records are updated
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              17/08/2016              Original Version
**/  
public class MFS_EventRequestTriggerHandler {
   
     //Call EventRequestUtility class after update
     //On change of Overall Approval Status to confirmed,all related Event Relations Approval Status changed to be Approved and Status as Accepted
    public static void afterUpdateSRHandler(Map<Id,Event_Request__c> newMap,Map<Id,Event_Request__c> oldMap){
        try{
            if(!newMap.isEmpty() && !oldMap.isEmpty()){
                MFS_EventRequestUtilities.emailNotificationToUsers(newMap,oldMap);
                Set<Id> evId = new Set<Id>();
                Set<Id> evIdPend = new Set<Id>();
                List<EventRelation> evntRelList = new List<EventRelation>();
                List<Event_Request__c> eReq = new List<Event_Request__c>([Select Id,Overall_Approval_Status__c,Call_Note__c from Event_Request__c where Id in : newMap.Keyset()]);
                for(Event_Request__c evReq : eReq){
                    Event_Request__c erNew = newMap.get(evReq.Id);
                    Event_Request__c erOld = oldMap.get(evReq.Id);
                    if(erNew.Overall_Approval_Status__c != erOld.Overall_Approval_Status__c){
                        if(evReq.Overall_Approval_Status__c == MFS_AllConstants.Confirmed){
                            evId.add(evReq.Id);
                        }
                         if(evReq.Overall_Approval_Status__c == MFS_AllConstants.Pending){
                            evIdPend.add(evReq.Id);
                        }
                    }
                }
                
                if(evId.size()>0){
                    List<Event_Relation__c> reqSpkr = new List<Event_Relation__c>([Select Id,Approval_Status__c from Event_Relation__c where Speaker_Request__c in : evId]);
                    List<Event_Relation__c> reqSpkrList = new List<Event_Relation__c>();
                    
                    if(!reqSpkr.isEmpty())
                    {
                        for(Event_Relation__c eReltn : reqSpkr)
                        {
                            eReltn.Approval_Status__c = MFS_AllConstants.Approved;
                            reqSpkrList.add(eReltn);
                        }
                        Database.SaveResult[] updReqSpkr = Database.update(reqSpkrList,false);  
                    }
                    
                }
                if(evIdPend.size()>0){
                    List<Event_Relation__c> reqSpkrPending = new List<Event_Relation__c>([Select Id,Approval_Status__c from Event_Relation__c where Speaker_Request__c in : evIdPend]);
                    List<Event_Relation__c> reqSpkrListUpdToPend = new List<Event_Relation__c>();
                     if(!reqSpkrPending.isEmpty())
                    {
                        for(Event_Relation__c eRel : reqSpkrPending)
                        {
                            eRel.Approval_Status__c = MFS_AllConstants.Pending;
                            reqSpkrListUpdToPend.add(eRel);
                        }
                        Database.SaveResult[] updReqSpkr = Database.update(reqSpkrListUpdToPend,false);  
                    }
                }
            }
        }catch(Exception ex){
            System.debug('Exception'+ex.getStackTraceString());
        }
    }
    
    //to show error before insert on the Event Request page if StartDate and EndDate is different from Activity Dates
    public static void StartandEndDateNotification(List<Event_Request__c> erList){
        Set<Id> activityId = new Set<Id>();
        try{
            for(Event_Request__c er : erList){
                if(er.Call_Note__c != null){
                    activityId.add(er.Call_Note__c);
                }
            }
            if(activityId.size()>0){
                String dtString;
                String etString;
                List<Event> evnt = new List<Event>([select id,StartDateTime,EndDateTime,Activity_Detail__c from Event where Activity_Detail__c IN : activityId AND Call_Note_Parent_Task_Event__c = True]);
                
                for(Event_Request__c er : erList){
                    for(Event ev : evnt){
                        if(er.Call_Note__c == ev.Activity_Detail__c){
                            if(er.Start_Date__c != ev.StartDateTime || er.End_Date__c != ev.EndDateTime){
                                dtString = ev.StartDateTime.format('MM/dd/YYYY hh:mm a'); 
                                etString = ev.EndDateTime.format('MM/dd/YYYY hh:mm a');
                                String errorMessg = System.Label.ER_Start_and_End_Date_Change_Message+' '+dtString +' '+System.Label.ER_Start_and_End_Date_Change_Message1+' '+System.Label.ER_Start_and_End_Date_Change_Message2+' '+etString; 
                                er.AddError(errorMessg);
                            }
                        }
                    }
                }
            }
        } catch(Exception ex){
            System.debug('Execption occured:'+ex.getStackTraceString());  
        }
    } 
    
    //to show error before update on the Event Request page if StartDate and EndDate is different from Activity Dates
    public static void beforeUpdateStartandEndDateNotification(Map<Id,Event_Request__c> erNewList, Map<Id,Event_Request__c> erOldList){
        
        Set<Id> activityId = new Set<Id>();
        try {
            for(Event_Request__c er : erNewList.values()){
                if(er.Call_Note__c != null) {
                    activityId.add(er.Call_Note__c);
                }
            }
            if(activityId.size()>0){
                String dtString;
                String etString;
                List<Event> evnt = new List<Event>([select id,StartDateTime,EndDateTime,Activity_Detail__c from Event where Activity_Detail__c IN : activityId AND Call_Note_Parent_Task_Event__c = True]);
                List<Event_Request__c> evntReq = new List<Event_Request__c>([Select Start_Date__c,End_Date__c from Event_Request__c where Id in : erNewList.keySet()]);
                for(Event_Request__c er : evntReq){
                    Event_Request__c evReqNew = erNewList.get(er.Id);
                    Event_Request__c evReqOld = erOldList.get(er.Id);
                    System.debug('evReqNew'+evReqNew+'evReqOld'+evReqOld);
                    for(Event ev : evnt){
                        
                        if(evReqNew.Call_Note__c == ev.Activity_Detail__c){
                            
                            if(evReqNew.Start_Date__c != evReqOld.Start_Date__c || evReqNew.End_Date__c != evReqOld.End_Date__c){
                                if(evReqNew.Start_Date__c != ev.StartDateTime || evReqNew.End_Date__c != ev.EndDateTime){
                                    dtString = ev.StartDateTime.format('MM/dd/YYYY hh:mm a'); 
                                    etString = ev.EndDateTime.format('MM/dd/YYYY hh:mm a');
                                    String errorMessg = System.Label.ER_Start_and_End_Date_Change_Message+' '+dtString +' '+System.Label.ER_Start_and_End_Date_Change_Message1+' '+System.Label.ER_Start_and_End_Date_Change_Message2+' '+etString; 
                                    evReqNew.AddError(errorMessg);
                                }
                            } 
                        }
                    }
                }
            }
        } catch(Exception ex) {
            System.debug('Execption occured:'+ex.getStackTraceString());  
        }
    }  
}