trigger MFS_DistributionListTrigger on Distribution_List__c (after update) {
 Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableDistributionListTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
             if(MFS_Utilities.runOnce()) {
              MFS_DistributionListHandler.afterUpdateDistListHandler(trigger.newMap, trigger.oldMap);
             }
    }   
}
}