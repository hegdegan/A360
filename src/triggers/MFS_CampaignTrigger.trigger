trigger MFS_CampaignTrigger on Campaign (after insert, before insert) {
    //custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableCampaignTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    //call the handler class for insert operation
    if(trigger.isInsert){
         //calling the handler method after insert operation
        if(trigger.isAfter){
            MFS_CampaignTriggerHandler.afterInsertCampaignHandler(trigger.new);
        }
        if(trigger.isBefore){
            MFS_CampaignTriggerHandler.beforeInsertCampaignHandler(trigger.new);
        }
    }

}