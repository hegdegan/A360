trigger MFS_PlanAssociationTrigger on Plan_Association__c (after insert, after update) {
 //custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnablePlanAssociationTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
  
  //call the handler class for update and insert association records
   if (Trigger.isAfter){
       if(Trigger.isInsert || Trigger.isUpdate){
      if(MFS_Utilities.runOnce()){
               MFS_AssociationHandler.afterInsertUpdateAssociationHandler(Trigger.New, trigger.newMap);
      }   
       }
   }
}