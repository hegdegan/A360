trigger MFS_TaskTrigger on Task (after insert, after update) {
    //custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableTaskTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    System.debug('Total Number of SOQL Queries allowed in this Apex code context: - inside Task Trigger' +  Limits.getLimitQueries());
    System.debug('Total Number of records that can be queried  in this Apex code context: - inside Task Trigger' +  Limits.getLimitDmlRows());
    System.debug('Total Number of DML statements allowed in this Apex code context: - inside Task Trigger' +  Limits.getLimitDmlStatements() );
    System.debug('Total Number of CPU usage time (in ms) allowed in this Apex code context: - inside Task Trigger' +  Limits.getLimitCpuTime());

    //call the handler class for update operation
    if(trigger.isUpdate){
        //calling the handler method after update operation
        if(trigger.isAfter){
            if(MFS_Utilities.runOnce()){
               MFS_TaskTriggerHandler.afterUpdateTaskHandler(trigger.newMap,trigger.oldMap); 
                MFS_TaskTriggerHandler.updateADRecords(trigger.oldMap,trigger.newMap);
            }
            
        }
    }
    //call the handler class for insert operation
    if(trigger.isInsert){
         //calling the handler method after insert operation
        if(trigger.isAfter){
            MFS_TaskTriggerHandler.afterInsertTaskhandler(trigger.new);
            
         //Insert Activity Detail records for those Tasks loaded via dataloader   
           MFS_TaskTriggerHandler.InsertADRecords(trigger.new);
        }
    }
}