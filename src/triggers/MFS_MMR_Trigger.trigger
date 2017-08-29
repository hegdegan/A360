trigger MFS_MMR_Trigger on Meeting_Material_Request__c (after insert) {

    //custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableMMRTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    //call the handler class for insert operation
    if(trigger.isInsert){
        if(trigger.isAfter){
            MFS_MMRTriggerHandler.afterInsertEventHandler(trigger.newMap);
        }
    }
}