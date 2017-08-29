trigger MFS_StrategyPlanTrigger on Strategy_Plan__c (before insert) {
    //custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableStrategyPlanTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    
    if(trigger.isBefore){
        //call the handler method for before insert operation
        if(trigger.isInsert){
            
            MFS_StrategyPlanHandler.beforeInsertEventHandler(trigger.new);
        } 
    }
}