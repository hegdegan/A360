trigger MFS_ContactTrigger on Contact (after insert,after update, before insert, before update) {
    //custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableContactTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    
    if(Trigger.isAfter) {
        //calling the handler method after insert operation 
        if(Trigger.isInsert) {
            //  MFS_ContactHandler.geoNewContactHandler(trigger.new); -- Commented Due to drop off googleAPI
            MFS_ContactHandler.afterInsertContactEventHandler(trigger.newMap);
        }
        
        if(Trigger.isUpdate) {
            //calling the handler method after update operation
            if(MFS_Utilities.runOnce()) {
                //MFS_ContactHandler.geoUpdateContactHandler(trigger.newMap,trigger.oldMap);
                MFS_ContactHandler.afterUpdateContactEventHandler(trigger.newMap,trigger.oldMap);
            }
        }   
    }else{
        if(Trigger.isUpdate) {
            MFS_ContactHandler.beforeUpdateContactEventHandler(trigger.newMap,trigger.oldMap);
        }
    }

    /*Boolean isNonProdTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableNonProdTrigger', 'No') == 'Yes' ? true : false;
    if(isNonProdTriggerEnabled){
        if (Trigger.isBefore)
        {
            /// Run this before insert or update
            MFS_ContactHandler.UpdateContactSensitiveValues(Trigger.New);
        }
    }*/
    
}