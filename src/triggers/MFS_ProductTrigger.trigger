/***************************************************************************************************
Apex Class Name    : MFS_ProductTrigger 
Version            : 1.0 
Created Date       : 16 June 2016
Function           : Product2 Trigger
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               16/06/2016              Original Version
***************************************************************************************************/

trigger MFS_ProductTrigger on Product2 (after insert) {
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableProduct2Trigger', 'Yes') == 'Yes' ? true : false;
        if(!isTriggerEnabled){
            return;
        }
        if(Trigger.isAfter && Trigger.isInsert)
        {
            MFS_ProductTriggerHandler.createPBEntry(Trigger.New);
        }
    	
      
}