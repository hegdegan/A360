trigger MFS_OrganizationTrigger on Account (before insert, after insert, after update, before update) {
    //Custom setting field to enable/disable trigger
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableOrganizationTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    
    if(trigger.isInsert){
        //Commenting before insert part as the same functionality is implemented in workflow
        if(trigger.isBefore){
            //Calling the Handler method to change the account owner
            MFS_OrganizationTriggerHandler.BeforeInsertEventhandler(trigger.new); 
        } else {
            if(trigger.isAfter){
                //Calling the Handler method for adding Owner as Team Member
                MFS_OrganizationTriggerHandler.AfterInsertEventhandler(trigger.newMap);
            }
        }
    }
    
    if(trigger.isUpdate){
        if(trigger.isAfter){
            //Calling the Handler method to change the associated Contact's address when Organization's address is changed.
            //It also updates the related records when Organization becomes inactive. 
            MFS_OrganizationTriggerHandler.afterUpdateEventHandler(trigger.newMap, trigger.oldMap);
        } else{
            MFS_OrganizationTriggerHandler.BeforeUpdateEventhandler(trigger.oldMap, trigger.newMap);
        }
    }
}