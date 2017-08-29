trigger MFS_AccountContactRelationTrigger on AccountContactRelation (before insert, after insert, before update, after update)
{
    //custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableAccountContactRelationTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled) 
    {
        return;
    }
    
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            MFS_AccountContactRelationTriggerHandler.beforeInsertAccountContactEventHandler(trigger.new);
        }
        
        if(Trigger.isUpdate)
        {
            MFS_AccountContactRelationTriggerHandler.beforeUpdateAccountContactEventHandler(trigger.oldMap,trigger.newMap);
        }    
    }

    if(Trigger.isAfter)
    {
        if (Trigger.isUpdate)
        {
            MFS_AccountContactRelationTriggerHandler.afterUpdateAccountContactEventHandler(trigger.oldMap, trigger.newMap);
        }
        else if (Trigger.isInsert)
        {
            MFS_AccountContactRelationTriggerHandler.afterInsertAccountContactEventHandler(trigger.newMap);
        }
    }
}