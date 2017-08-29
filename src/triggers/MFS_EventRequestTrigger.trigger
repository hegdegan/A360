trigger MFS_EventRequestTrigger on Event_Request__c (before insert,before update,after update) {
    //custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableEventRequestTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    
    if(trigger.isUpdate){
        //calling the handler method after and before update operation
        if(trigger.isAfter){
            MFS_EventRequestTriggerHandler.afterUpdateSRHandler(trigger.newMap,trigger.oldMap);
            } else {
            MFS_EventRequestTriggerHandler.beforeUpdateStartandEndDateNotification(trigger.newMap,trigger.oldMap);
           }
    }
    
    //calling the handler method before insert operation
    if(trigger.isInsert){
        if(trigger.isBefore){
            MFS_EventRequestTriggerHandler.StartandEndDateNotification(trigger.new);
        }
    } 
}