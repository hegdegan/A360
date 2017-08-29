/***************************************************************************************************
Apex Class Name    : MFS_TaskUtilities
Version            : 1.0 
Created Date       : 27 Jul 2016
Function           : Trigger utility for Task
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey            7/27/2016              Original Version
***************************************************************************************************/
public class MFS_TaskUtilities {
    
    //Create Activity Detail if not already created for Task Loads
    public static List<Activity_Detail__c> insAD (List<Task> taskList) {
        List<Activity_Detail__c> adList = new List<Activity_Detail__c>();
        Activity_Detail__c ad ;
        if (taskList.size() > 0) {
            try {
                for(Task tsk : taskList){
                    ad = new Activity_Detail__c();
                    if(tsk.WhatId!= null && String.ValueOf(tsk.WhatId).startsWith('001')){
                        ad.Organization__c = tsk.WhatId;  
                    }else if(tsk.WhatId!= null && String.ValueOf(tsk.WhatId).startsWith('006')){
                        ad.Opportunity__c = tsk.WhatId;    
                    }
                    if(tsk.Saleslogix_ID__c!=null){
                        ad.Saleslogix_ID__c = tsk.Saleslogix_ID__c; 
                    }
                    ad.Contact__c = tsk.Whoid;
                    ad.Subject__c = tsk.Subject;
                    ad.Activity_ID__c = Id.valueOf(tsk.id);
                    ad.Not_An_Orphan_Record__c = true;
                    ad.name = tsk.Subject;
                    adList.add(ad);
                    System.debug('1. Number of Queries used in this Apex code so far: - Inside Task Utility - Insert AD' + Limits.getQueries());
                    System.debug('2. Number of rows queried in this Apex code so far: - Inside Task Utility - Insert AD' + Limits.getDmlRows());
                    System.debug('3. Number of DML statements used so far: - Inside Task Utility - Insert AD' +  Limits.getDmlStatements());    
                    System.debug('4. Amount of CPU time (in ms) used so far: - Inside Task Utility - Insert AD' + Limits.getCpuTime());
                    
                }
            } catch(Exception ex){
                System.debug('Execption occured:'+ ex.getMessage());
            }
        }
        return adList;
    }
    
    //Update Activity Detail to take the copy Saleslogix ID of Task if its not Null
    public static List<Activity_Detail__c> updateAD (Map<Id,Task> oldTaskMap, Map<Id,Task> newTaskMap) {
        List<Activity_Detail__c> adsToUpdate = new List<Activity_Detail__c>();
        Task newTsk;
        Task oldTsk;
        try {
            List<Activity_Detail__c> adRecords = new List<Activity_Detail__c>([Select Id,Saleslogix_ID__c,Activity_ID__c from Activity_Detail__c where Activity_ID__c in :newTaskMap.keyset()]);
            for(Activity_Detail__c ad : adRecords){
                if(newTaskMap.containsKey(ad.Activity_ID__c)){
                    newTsk = newTaskMap.get(ad.Activity_ID__c); 
                    oldTsk = oldTaskMap.get(ad.Activity_ID__c);
                    if(newTsk.Saleslogix_ID__c != oldTsk.Saleslogix_ID__c || newTsk.Saleslogix_ID__c !=null){
                        ad.Saleslogix_ID__c = newTsk.Saleslogix_ID__c;
                        ad.name = newTsk.Subject;
                        adsToUpdate.add(ad);
                    } 
                }
            }
        } catch(Exception ex){
            System.debug('Exception occured while updating activity detail:'+ ex.getMessage());
        }
        return adsToUpdate;
    } 
    
    //Populate Last Activity Date on related Opportunity of Task Object
    public static List<Opportunity> populateLastActivityDate(List<Task> taskList){
        String opp_prefix = Schema.SObjectType.Opportunity.getKeyPrefix();
        Set<Id> oppId = new set<Id>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Opportunity> oppListUpdate = new List<Opportunity>();
        
        try{
            for(Task tsk : taskList){
                if(tsk.WhatId!=null){
                    if(((String)tsk.WhatID).startsWith(opp_prefix)){
                        oppId.add(tsk.WhatID);
                    }  
                }  
            }
            
            if(oppId.size()>0){
                oppList = [select Id,Last_Activity_Date__c from Opportunity where Id in : oppId];
                for(Opportunity opp : oppList){
                    opp.Last_Activity_Date__c = System.Today();
                    oppListUpdate.add(opp);
                }
            }
            System.debug('1. Number of Queries used in this Apex code so far: - Inside Task Utility - populate last activity' + Limits.getQueries());
            System.debug('2. Number of rows queried in this Apex code so far: - Inside Task Utility- populate last activity' + Limits.getDmlRows());
            System.debug('3. Number of DML statements used so far: - Inside Task Utility- populate last activity' +  Limits.getDmlStatements());    
            System.debug('4. Amount of CPU time (in ms) used so far: - Inside Task Utility- populate last activity' + Limits.getCpuTime());
            
            
        } catch(Exception exe){
            System.debug('Execption occured:'+exe.getMessage());
        }
        
        return oppListUpdate;
    }
    
    //Populate Last Activity Date on related Opportunity of Task Object when WhatId field updated
    public static List<Opportunity> populateRelatedIdAfterUpdate(Map<Id,Task> taskList,Map<Id,Task> oldTask){
        
        String opp_prefix = Schema.SObjectType.Opportunity.getKeyPrefix();
        Set<Id> oppId = new set<Id>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Opportunity> oppListUpdate = new List<Opportunity>();
        
        try{
            List<Task> tskRecord = new  List<Task>([Select Id,WhoId,WhatId,Saleslogix_ID__c from Task where Id in : taskList.keyset() ]);
            for(Task tsk : tskRecord){
                Task newTsk = taskList.get(tsk.Id);
                Task oldTsk = oldTask.get(tsk.Id);
                
                if(newTsk.WhatId != oldTsk.WhatId){
                    if(((String)tsk.WhatID).startsWith(opp_prefix)){
                        oppId.add(tsk.WhatID);
                    }  
                }
                
            }
            
            if(oppId.size()>0){
                oppList = [select Id,Last_Activity_Date__c from Opportunity where Id in : oppId];
                for(Opportunity opp : oppList){
                    opp.Last_Activity_Date__c = System.Today();
                    oppListUpdate.add(opp);
                }
            }
            System.debug('1. Number of Queries used in this Apex code so far: - Inside Task Utility' + Limits.getQueries());
            System.debug('2. Number of rows queried in this Apex code so far: - Inside Task Utility' + Limits.getDmlRows());
            System.debug('3. Number of DML statements used so far: - Inside Task Utility' +  Limits.getDmlStatements());    
            System.debug('4. Amount of CPU time (in ms) used so far: - Inside Task Utility' + Limits.getCpuTime());
            
        } catch(Exception exe) {
            System.debug('Execption occured:'+exe.getMessage());
        }
        
        return oppListUpdate;
    }
    
    
    
}