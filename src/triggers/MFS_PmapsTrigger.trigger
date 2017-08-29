trigger MFS_PmapsTrigger on PMAPS__c (after insert) {
    //custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnablePmapsTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    //Call Handler class after insert event
    if(trigger.isInsert){
        if(trigger.isAfter){
            MFS_PmapsTriggerHandler.afterInsertAddRLPmaps(trigger.new);
        }
    }

}