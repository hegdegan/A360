trigger MFS_ActivityDetailTrigger on Activity_Detail__c (after insert) {
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableActivityDetailTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            MFS_ActivityDetailTriggerHandler.linkADtoEventAndTask(trigger.newMap);
        }   
    }
}