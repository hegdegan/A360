/***************************************************************************************************
Apex Class Name    : MFS_TaskTriggerHandler
Version            : 1.0 
Created Date       : 27 Jul 2016
Function           : Trigger handler for Task
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey            7/27/2016              Original Version
***************************************************************************************************/
public class MFS_TaskTriggerHandler {
    //Call MFS_TaskUtilities class on after insert event of Task record to populate Last Activity Date on related Opportunity record
    public static void afterInsertTaskhandler(List<Task> tskList){
        if(!tskList.isEmpty()){
            List<Opportunity> oppToUpdate = MFS_TaskUtilities.populateLastActivityDate(tskList);
            
            Database.SaveResult[] updOpp = Database.update(oppToUpdate,false);
            System.debug('Amount of CPU time (in ms) used so far: - Inside Task Utility- populate last activity - afterInsertTaskhandler' + Limits.getCpuTime());
            System.debug('Final number of DML statements used so far: -afterInsertTaskhandler' +  Limits.getDmlStatements());
            System.debug('Final heap size: -afterInsertTaskhandler' +  Limits.getHeapSize());
            
        } 
    }
    
    //Call MFS_TaskUtilities class on after update event of Task record to populate Last Activity Date on related Opportunity record
    public static void afterUpdateTaskHandler(Map<Id,Task> newtaskList,Map<Id,Task> oldtaskList){
        if(!newtaskList.isEmpty()){
            List<Opportunity> oppToUpdate = MFS_TaskUtilities.populateRelatedIdAfterUpdate(newtaskList, oldtaskList);
            Database.SaveResult[] updOpp = Database.update(oppToUpdate,false);
            System.debug('Amount of CPU time (in ms) used so far: - Inside Task Utility- populate last activity - afterUpdateTaskHandler' + Limits.getCpuTime());
            System.debug('Final number of DML statements used so far: - afterUpdateTaskHandler' +  Limits.getDmlStatements());
            System.debug('Final heap size: - afterUpdateTaskHandler' +  Limits.getHeapSize());
        }   
    }
    
    // Insert Activity Detail records for dataloads
    public static void InsertADRecords(List<Task> tskList) {
        Boolean isDataLoadEnabledForActivities = MFS_Utilities.GetAppSettingValue('EnableDataLoad', 'Yes') == 'Yes' ? true : false;
        //Check 1 - check if the dataload custom setting enabled
        if(isDataLoadEnabledForActivities){
            //Check 2 - check if the current user is the Informatica user 
            if(MFS_AllConstants.IntegrationProfileId !=null && UserInfo.getProfileId().contains(MFS_AllConstants.IntegrationProfileId.value__c)) {
                system.debug('Im an Informatica user');
                List<Activity_Detail__c> adToInsert = MFS_TaskUtilities.insAD(tskList);
                Database.SaveResult[] insAd = Database.insert(adToInsert,false);
                System.debug('Amount of CPU time (in ms) used so far: - Inside Task Utility- populate last activity - InsertADRecords' + Limits.getCpuTime());
                System.debug('Final number of DML statements used so far:  - InsertADRecords' +  Limits.getDmlStatements());
                System.debug('Final heap size: - InsertADRecords' +  Limits.getHeapSize());   
            }
        }
    }
    // Update Activity Detail records for dataloads
    public static void updateADRecords(Map<Id,Task> oldTaskMap, Map<Id,Task> newTaskMap) {
        Boolean isDataLoadEnabledForActivities = MFS_Utilities.GetAppSettingValue('EnableDataLoad', 'Yes') == 'Yes' ? true : false;
        //Check 1 - check if the dataload custom setting enabled
        if(isDataLoadEnabledForActivities){
            //Check 2 - check if the current user is the Informatica user 
            if(MFS_AllConstants.IntegrationProfileId !=null && UserInfo.getProfileId().contains(MFS_AllConstants.IntegrationProfileId.value__c)) {
                system.debug('Im an Informatica user');
                List<Activity_Detail__c> adToUpdate = MFS_TaskUtilities.updateAD(oldTaskMap,newTaskMap);
                Database.SaveResult[] updAd = Database.update(adToUpdate,false);
            }
        }
    }
}