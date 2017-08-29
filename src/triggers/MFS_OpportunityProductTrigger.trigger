trigger MFS_OpportunityProductTrigger on OpportunityLineItem (before insert, after insert, after update, after delete){
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableOpptyProductTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    /*if(Trigger.isBefore && Trigger.isInsert)
    {      
    MFS_OpportunityProductHandler.beforeInsertTriggerHandler(Trigger.new);
    }
    
    if(Trigger.isBefore)
    {      
    MFS_OpportunityProductHandler.beforeInsertTriggerHandler(Trigger.new);
    }*/
        
    if(Trigger.isafter){
        if(Trigger.isInsert){
            MFS_OpportunityProductHandler.afterInsertTriggerhandler(Trigger.new);
        }
        if(Trigger.isUpdate){    
            MFS_OpportunityProductHandler.afterUpdateTriggerhandler(Trigger.oldMap, Trigger.newMap);
        }
        if(Trigger.isDelete){    
            MFS_OpportunityProductHandler.afterDeleteTriggerhandler(Trigger.oldMap);
        }
    }
}