trigger MFS_EventTrigger on Event (before insert,after insert,after update) {
    //custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableEventTrigger', 'Yes') == 'Yes' ? true : false;
    //Boolean isTemporaryEventFlagEnabled = MFS_Utilities.GetAppSettingValue('TemporaryEventFlag', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    System.debug('Total Number of SOQL Queries allowed in this Apex code context: ' +  Limits.getLimitQueries());
    System.debug('Total Number of records that can be queried  in this Apex code context: ' +  Limits.getLimitDmlRows());
    System.debug('Total Number of DML statements allowed in this Apex code context: ' +  Limits.getLimitDmlStatements() );
    System.debug('Total Number of CPU usage time (in ms) allowed in this Apex code context: ' +  Limits.getLimitCpuTime());
    //call the handler class for update operation
    if(trigger.isUpdate){
        //calling the handler method after update operation
        if(trigger.isAfter){
            if(MFS_Utilities.runOnce()){
                MFS_EventTriggerHandler.afterUpdateMapEventTaskHandler(trigger.newMap,trigger.oldMap);
            }
            MFS_EventTriggerHandler.updateADRecords(trigger.oldMap,trigger.newMap);
        }
    }
    //call the handler class for insert operation
    if(trigger.isInsert){
        //calling the handler method before insert operation
        if(trigger.isBefore){
            MFS_EventTriggerHandler.beforeInsertEventTaskHandler(trigger.new);
        }
        //calling the handler method after insert operation
        if(trigger.isAfter){
            MFS_EventTriggerHandler.afterInsertEventTaskHandler(trigger.new);
            //Insert Activity Detail records for those Event loaded via dataloader   
            MFS_EventTriggerHandler.InsertADRecords(trigger.new); 
        }
    }
}