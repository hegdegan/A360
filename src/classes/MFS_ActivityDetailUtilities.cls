/**
Apex Class Name    : MFS_ActvityDetailUtilities
Version            : 1.0 
Created Date       : 16 JAN 2017
Function           : Utility class for Actvity Detail Trigger
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Manoj Parida              16/01/20167             Original Version
**/
public class MFS_ActivityDetailUtilities {
    
    //Update Event or Task to link to new Activity Detail
    public static List<SObject> linkADtoEventAndTask(Map<Id,Activity_Detail__c> activityDetailMap) {
        Map<Id,SObject> activityMap = new Map<Id,SObject>();
        List<SObject> activityList = new List<SObject>();
        Set<Id> activityIdSet = new Set<Id>();
        try{
            for(Activity_Detail__c ad : activityDetailMap.values()){
                if(ad.Activity_ID__c !=null){
                    activityIdSet.add(ad.Activity_ID__c);  
                }
            }
            if(activityIdSet.size() > 0){
                List <SObject> evList = new List<Event>([Select id,Activity_Detail__c from Event where id IN:activityIdSet]);
                if(evList.size() > 0) activityMap.putAll(evList); 
                List <SObject> tskList = new List<Task>([Select id,Activity_Detail__c from Task where id IN:activityIdSet]); 
                if(tskList.size() > 0) activityMap.putAll(tskList); 
            }
            for(Activity_Detail__c ad : activityDetailMap.values()){
              if(activityMap.containsKey(ad.Activity_ID__c)){
                  If(ad.Activity_ID__c.startswith('00U')) {
                      Event ev = (Event)activityMap.get(ad.Activity_ID__c);
                      ev.Activity_Detail__c = ad.Id;
                      activityList.add(ev);
                  }else{
                      Task tsk = (Task)activityMap.get(ad.Activity_ID__c);
                      tsk.Activity_Detail__c = ad.Id;
                      activityList.add(tsk);
                  }
              }  
            }
        }catch(Exception ex){
            System.debug('Execption occured:'+ ex.getMessage()); 
        }
        return activityList;
    }
    
}