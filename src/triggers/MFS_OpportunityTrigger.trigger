trigger MFS_OpportunityTrigger on Opportunity (after insert, after update){
    //Custom setting value to enable/disable the trigger.
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableOpportunityTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert) {
            MFS_OpportunityHandler.afterInsertEventHandler(trigger.new);
        }
        if(Trigger.isUpdate){
            MFS_OpportunityHandler.afterUpdateEventHandler(trigger.newMap, trigger.oldMap);
        }
    }
}