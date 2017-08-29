/**
Apex Class Name    : MFS_ActivityDetailTriggerHandler
Version            : 1.0 
Created Date       : 16 JAN 2017
Function           : Handler class for Actvity Detail Trigger
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Manoj Parida              16/01/20167             Original Version
**/
public class MFS_ActivityDetailTriggerHandler {
    
    public static void linkADtoEventAndTask(Map<Id,Activity_Detail__c> newADTriggerMap) {
        Boolean isDataLoadEnabledForActivities = MFS_Utilities.GetAppSettingValue('EnableDataLoad', 'Yes') == 'Yes' ? true : false;
        if(isDataLoadEnabledForActivities && !newADTriggerMap.isEmpty()){
                List<SObject> activityList = new List<SObject> ();
                activityList = MFS_ActivityDetailUtilities.linkADtoEventAndTask(newADTriggerMap);
                Database.SaveResult[] actvityUpdate = Database.update(activityList,false);
               //update activityList;
            } 
    }
    
}