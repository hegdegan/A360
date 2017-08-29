/***************************************************************************************************
Apex Class Name    : MFS_ActivityDetailBatch 
Version            : 1.0 
Created Date       : 18 October 2016
Function           : Batch class to delete Activity detail records,related task,event and Event Request records.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey               18/10/2016              Original Version
***************************************************************************************************/
global with sharing class MFS_ActivityDetailBatch implements Database.Batchable<sObject>{
    global String query;
    //Constructor
    global MFS_ActivityDetailBatch()
    {
        this.query = 'Select Id,CreatedDate from Activity_Detail__c where Not_An_Orphan_Record__c = false';
        System.debug('Queryres'+query);
    }
    //Implement start method of Batchable Interface
    global DataBase.QueryLocator start(Database.BatchableContext batchCon)
    {
        return DataBase.getQueryLocator(query);
    }
    //Implement execute method of Batchable Interface
    global void execute(Database.BatchableContext batchCon,List<sObject> activityList)
    {
        if(!activityList.isEmpty()){
            
            List<Activity_Detail__c> actDetailList = (List<Activity_Detail__C>)activityList;
            Set<Id> activityId = new Set<Id>();
            List<Activity_Detail__c> childActivityDetailRecs = new List<Activity_Detail__c>();
            Set<Id> childActivityIds = new Set<Id>();
            
            for(Activity_Detail__c aDetail : actDetailList){
                Decimal hourDiff = ((System.now().getTime())/1000/60/60) -((aDetail.CreatedDate.getTime())/1000/60/60);
                if(hourDiff >= 1)
                    activityId.add(aDetail.Id);
            }
            
            if(activityId.size() > 0){
                List<Task> tskList = [Select Id,Parent_Activity_Detail_Id__c from Task where Activity_Detail__c IN :activityId OR Parent_Activity_Detail_Id__c IN :activityId];
                List<Event> evntList = [Select Id,Parent_Activity_Detail_Id__c from Event where Activity_Detail__c IN :activityId OR Parent_Activity_Detail_Id__c IN :activityId];
                List<Event_Request__c> erList = [Select Id from Event_Request__c where Call_Note__c IN :activityId];
                
                if(tskList.size()>0){
                    for(Task t : tskList){
                        if(t.Parent_Activity_Detail_Id__c!=null){
                            childActivityIds.add(t.Activity_Detail__c);  
                        }
                    }
                }
                if(evntList.size()>0){
                    for(Event e : evntList){
                        if(e.Parent_Activity_Detail_Id__c!=null){
                            childActivityIds.add(e.Activity_Detail__c);  
                        }
                    }
                }
                if(childActivityIds.size()>0){
                    childActivityDetailRecs = [select id from Activity_Detail__c where Id IN :childActivityIds];
                }
                
                if(!tskList.isEmpty())
                    delete tskList;
                if(!evntList.isEmpty())
                    delete evntList;
                if(!erList.isEmpty())
                    delete erList;
                if(!childActivityDetailRecs.isEmpty())
                    delete childActivityDetailRecs;
                
                delete actDetailList;
            }
        }
    }
    //Implement finish method of Batchable Interface
    global void finish(Database.BatchableContext batchCon)
    {
        
    }
    
}