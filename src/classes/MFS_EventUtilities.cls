/**
Apex Class Name    : MFS_EventUtilities
Version            : 1.0 
Created Date       : 11 MAY 2016
Function           : Utility class that gets called by Event Triggers 
when Events are created,updated and deleted
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              25/04/2016              Original Version
**/
public with sharing class MFS_EventUtilities { 
    
    //Create Activity Detail if not already created for Event Loads
    public static List<Activity_Detail__c> insertActivityDetail (List<Event> eventList) {
        List<Activity_Detail__c> adList = new List<Activity_Detail__c>();
        Activity_Detail__c ad;
        if (eventList.size() > 0) {
            try {
                for(Event evt : eventList){
                    ad = new Activity_Detail__c();
                    if(evt.WhatId!= null && String.ValueOf(evt.WhatId).startsWith('001')){
                        ad.Organization__c = evt.WhatId;  
                    }else if(evt.WhatId!= null && String.ValueOf(evt.WhatId).startsWith('006')){
                        ad.Opportunity__c = evt.WhatId;    
                    }  
                    if(evt.Saleslogix_ID__c!=null){
                        ad.Saleslogix_ID__c = evt.Saleslogix_ID__c; 
                    }
                    ad.Contact__c = evt.Whoid;
                    ad.Subject__c = evt.Subject;
                    ad.Activity_ID__c = Id.valueOf(evt.id);
                    ad.Not_An_Orphan_Record__c = true;
                    ad.name = evt.Subject;
                    adList.add(ad);
                }
            } catch(Exception ex){
                System.debug('Execption occured:'+ ex.getMessage());
            }
        }
        return adList;
    }
    
    //incrementing meeting counter in Strategy Plan based on type of meetings
    public static List<Strategy_Plan__c> populateCounterInStrategyPlan(Map<Id,Event> eventMap,Map<Id,Event> oldEventMap)
    {
        //system.debug('Evetnt Map in Event Trigger : '+eventMap);
        List<Strategy_Plan__c> strategyPlanAddToList = new List<Strategy_Plan__c>(); 
        try{
            String account_prefix = Schema.SObjectType.Account.getKeyPrefix();
            List<Id> relatedIdSet = new List<Id>();
            
            for(Event ev : eventMap.values()){
                Event newEvntRec = eventMap.get(ev.Id);
                Event oldEvntRec = oldEventMap.get(ev.Id);
                if(newEvntRec.Type != oldEvntRec.Type)
                {
                    if(ev.WhatId!=null){
                        if(((String)ev.WhatID).startsWith(account_prefix)){
                            relatedIdSet.add(ev.WhatID);
                        }  
                    } 
                }
            }
            Map<Id,Strategy_Plan__c> sPlanMap;
            map<String,Application_Settings__c> mapAppSettings = Application_Settings__c.getAll();
            Application_Settings__c appSettingRec;
            if(relatedIdSet.size() > 0){
                sPlanMap = new Map<Id,Strategy_Plan__c>([Select Organization__c, Institutional_Portfolio_Manager_Goal_Cou__c, Sr_Investment_Speaker_Goal_Counter__c,
                                                         Portfolio_Manager_Meeting_Goal_Counter__c, Consultant_Meeting_Goal_Counter__c, 
                                                         Client_Review_Meeting_Goal_Counter__c, Client_Engagement_Counter__c, Analyst_Meeting_Goal_Counter__c,
                                                         Sr_Executive_Meeting_Goal_Counter__c, Strategy_Plan_Year__c 
                                                         from Strategy_Plan__c where Organization__c in : relatedIdSet and Strategy_Plan_Year__c != null ]);
            }
            if(sPlanMap != null && sPlanMap.size() > 0) {
                for(Event ev : eventMap.values()){
                    for( Strategy_Plan__c plan : sPlanMap.values()){
                        if(Integer.valueof(plan.Strategy_Plan_Year__c) == ev.EndDateTime.Year() ){
                            if(ev.EndDateTime < System.now()){
                                if(mapAppSettings.containsKey(ev.Type)) 
                                {
                                    appSettingRec = mapAppSettings.get(ev.Type);
                                    String fName = appSettingRec.value__c;
                                    if(plan.get(fName) != null && !''.equals(plan.get(fName))){
                                        plan.put(fName,Integer.valueOf(plan.get(fName)) + 1);
                                    }else {
                                        plan.put(fName,1);
                                    }
                                    System.debug('Fname..'+plan.get(fName));
                                }
                                if(ev.Type.equals(MFS_AllConstants.INST_PORTFOLIO_MGR_MEETING))
                                {
                                    String type = MFS_AllConstants.INST_PORTFOLIO_MGR;
                                    if(mapAppSettings.containsKey(type)) 
                                    {
                                        appSettingRec = mapAppSettings.get(type);
                                        String fName = appSettingRec.value__c;
                                        if(plan.get(fName) != null && !''.equals(plan.get(fName))){
                                            plan.put(fName,Integer.valueOf(plan.get(fName)) + 1);
                                        }else {
                                            plan.put(fName,1);
                                        }
                                    }
                                }
                                strategyPlanAddToList.add(plan);
                            }
                        }
                    }
                }
            }
        }
        catch(Exception exe)
        {
            System.debug('Execption occured:'+exe.getMessage());
        }
        return strategyPlanAddToList;
    }
    //Populating RelatedId field for event before insert
    public static void populateRelatedId(List<Event> eventList){
        try{
            Set<Id> contIdSet= new Set<Id>();
            for(Event eve : eventList){
                contIdSet.add(eve.WhoId);
            }
            
            if(contIdSet.size()>0){
                Map<Id,Contact> mapcon = new Map<Id,Contact>([select Id, AccountId from Contact where Id in : contIdSet ]);
                
                for(Event eve : eventList){
                    if(eve.WhatId == null){
                        if(mapcon.containsKey(eve.whoId)){
                            Contact co = mapcon.get(eve.whoId);
                            eve.WhatId = co.AccountId;
                        } 
                    }
                }
            }
        }
        catch(Exception exe)
        {
            System.debug('Execption occured:'+exe.getMessage());
        }
    }
    //Populating RelatedId after update based on Name field
    //Populating Last Activity Date on Opportunity object when whatId of event containing opportunity is updated
    public static List<Event> populateRelatedIdAfterUpdate(Map<Id,Event> newEventMap,Map<Id,Event> oldEventMap){
        Map<Id,Event> dupEventMap = new Map<Id,Event> ([Select Id, WHatID,WhoId from Event where id in : newEventMap.keySet()]);
        List<Event> eventList = new List<Event>();
        Set<Id> contIdSet= new Set<Id>();
        String opp_prefix = Schema.SObjectType.Opportunity.getKeyPrefix();
        Set<Id> oppIdSet = new set<Id>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Opportunity> oppListUpdate = new List<Opportunity>();
        
        try{
            for(Event eve : dupEventMap.values()){
                Event newEv = dupEventMap.get(eve.Id);
                Event oldEv = oldEventMap.get(eve.Id);
                if(newEv.WhoId != oldEv.WhoId || eve.WhatId == null){
                    contIdSet.add(eve.WhoId);
                }
                if(newEv.WhatId != oldEv.WhatId){
                    if(eve.WhatID != null && ((String)eve.WhatID).startsWith(opp_prefix)){
                        oppIdSet.add(eve.WhatID);
                    }  
                }
            }
            if(contIdSet.size()>0){
                Map<Id,Contact> mapcon = new Map<Id,Contact>([select Id, AccountId from Contact where Id in : contIdSet ]);
                
                for(Event eve : dupEventMap.values()){
                    if(eve.WhatId == null){
                        if(mapcon.containsKey(eve.whoId)){
                            Contact co = mapcon.get(eve.whoId);
                            eve.WhatId = co.AccountId;
                            eventList.add(eve);
                        } 
                    }
                }
            }
            if(oppIdSet.size()>0){
                oppList = [select Id,Last_Activity_Date__c from Opportunity where Id in : oppIdSet];
                for(Opportunity opp : oppList){
                    opp.Last_Activity_Date__c = System.Today();
                    oppListUpdate.add(opp);
                }
            }
        } 
        catch(Exception exe)
        {
            System.debug('Execption occured:'+exe.getStackTraceString());
        }
        
        Database.SaveResult[] updOpp = Database.update(oppListUpdate,false);
        return eventList;
        
    } 
    
    //Populate Opportunity Last Activity date
    public static List<Opportunity> populateOpportunityLastActivityDate(List<Event> evntList){
        String opp_prefix = Schema.SObjectType.Opportunity.getKeyPrefix();
        Set<Id> oppIdSet = new set<Id>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Opportunity> oppListUpdate = new List<Opportunity>();
        
        try{
            for(Event ev : evntList){
                if(ev.WhatId!=null){
                    if(((String)ev.WhatID).startsWith(opp_prefix)){
                        oppIdSet.add(ev.WhatID);
                    }  
                }  
            }
            if(oppIdSet.size()>0){
                oppList = [select Id,Last_Activity_Date__c from Opportunity where Id in : oppIdSet];
                for(Opportunity opp : oppList){
                    opp.Last_Activity_Date__c = System.Today();
                    oppListUpdate.add(opp);
                }
            }
        }
        Catch(Exception exe){
            System.debug('Execption occured:'+exe.getMessage());
        }
        
        return oppListUpdate;
    }
    
    //Update Activity Detail to take the copy Saleslogix ID of Task if its not Null
    public static List<Activity_Detail__c> updateAD (Map<Id,Event> oldEventMap, Map<Id,Event> newEventMap) {
        List<Activity_Detail__c> adsToUpdate = new List<Activity_Detail__c>();
        Event newEvent;
        Event oldEvent;
        try {
            List<Activity_Detail__c> adRecords = new List<Activity_Detail__c>([Select Id,Saleslogix_ID__c,Activity_ID__c from Activity_Detail__c where Activity_ID__c in :newEventMap.keyset()]);
            for(Activity_Detail__c ad : adRecords){
                if(newEventMap.containsKey(ad.Activity_ID__c)){
                    newEvent = newEventMap.get(ad.Activity_ID__c); 
                    oldEvent = oldEventMap.get(ad.Activity_ID__c);
                    if(newEvent.Saleslogix_ID__c != oldEvent.Saleslogix_ID__c || newEvent.Saleslogix_ID__c !=null){
                        ad.Saleslogix_ID__c = newEvent.Saleslogix_ID__c;
                        ad.name = newEvent.Subject;
                        adsToUpdate.add(ad);
                    } 
                }
            }
        } catch(Exception ex){
            System.debug('Exception occured while updating activity detail:'+ ex.getMessage());
        }
        return adsToUpdate;
    } 
}