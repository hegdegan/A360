trigger MFS_ApprovalRequestTrigger on Approval_Request__c (before update, after update) {
    //Custom setting value to enable/disable the trigger.
    Boolean isTriggerEnabled = MFS_Utilities.GetAppSettingValue('EnableFeeApprovalRequestTrigger', 'Yes') == 'Yes' ? true : false;
    if(!isTriggerEnabled){
        return;
    }
    
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            List<Approval_Request__c> appReqlist=new List<Approval_Request__c>();
            for(Approval_Request__c appReq:Trigger.new){
                if(appReq.Approval_Status__c!=(Trigger.oldMap).get(appReq.Id).Approval_Status__c && appReq.Approval_Status__c==MFS_AllConstants.APPROVAL_STATUS_APPROVED){
                    appReqlist.add(appReq);
                }
            }
            if(!appReqlist.isEmpty())
                MFS_ApprovalRequestHandler.beforeTriggerEventHandler(appReqlist);
        }
    }
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            MFS_ApprovalRequestHandler.afterTriggerEventHandler(trigger.newMap, trigger.oldMap);
        }
    }
}