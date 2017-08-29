trigger MFS_RequestedSpeakerTrigger on Event_Relation__c (after insert, after update) {
    //custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableRequestedSpeakerTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    
    //calling the handler method after update operation
    if(trigger.isUpdate) {
        if(trigger.isAfter) {
            MFS_RequestedSpeakerHandler.afterUpdateRequestedSpeakerHandler(trigger.newMap,trigger.oldMap);
        }
    }
    if(trigger.isInsert){
        if(trigger.isAfter){
            MFS_RequestedSpeakerHandler.afterDataLoadInsert(trigger.newMap);
        }
    }
}