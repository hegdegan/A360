trigger MFS_ClientInvestmentTrigger on Account__c (after insert, after delete)
{
	//custom setting field to enable/disable trigger
	Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableClientInvestmentTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled)
    {
        return;
    }

	//trigger.new is simply a list of the records being processed by the trigger
	//trigger.newMap is a map of IDs to the new versions of the sObject records (only available in before update, after inserts and
	//after update triggers)
	//trigger.oldMap is a map of IDs to the old versions of the sObject records (only available in update and delete triggers)    
	if (Trigger.isAfter)
    {
        if(MFS_Utilities.runOnce())
        {
            if(trigger.isInsert)
            {
                MFS_ClientInvestmentHandler.afterInsertClientInvestmentHandler(Trigger.new, trigger.newMap);
            }
            if(trigger.isDelete)
            {
                   MFS_ClientInvestmentHandler.afterDeleteClientInvestmentHandler(trigger.old, trigger.oldMap);
            }    
        }
    }
}