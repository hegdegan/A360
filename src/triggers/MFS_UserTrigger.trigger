trigger MFS_UserTrigger on User (before update, after update, after insert) {
    //custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableUserTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    
    if(Trigger.isBefore){
        if(trigger.isUpdate)
            UserTriggerHandler.processUserEmailRecords(trigger.new);
    }
    
    //Added for new campaign record creation per user
    if(trigger.isAfter){
        if(trigger.isInsert){
            MFS_UserTriggerHandler.createCampaignOnUserCreation(trigger.newMap); 
        }
        if(Trigger.isUpdate){
            MFS_UserTriggerHandler.updateUserCampaign(trigger.newMap, trigger.oldMap);
        }
    }
}