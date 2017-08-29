/*
Apex class           :  MFS_FollowUpTaskUtility
Version               :  1.0
Created Date          :  16 SEP 2016
Function              :  This Utility class contains all methods related to Follow Up Related List in Activity360

Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* Gyanendra Singh            16 SEP 2016              Initial Version
*/

public class MFS_FollowUpTaskUtility {
    
    //returns all the task records associated with this Activity Detail record
    public static List<Task> getTaskRecords(string cId){
        List<Task> taskList = new List<Task>(); 
        try{
            MFS_Activity360GeneralUtility.wrapperClass wrp = new MFS_Activity360GeneralUtility.wrapperClass();
            List<MFS_Activity360GeneralUtility.wrapperClass> wrpLst = new List<MFS_Activity360GeneralUtility.wrapperClass>();
            
            taskList = new List<Task>([select id,Subject,OwnerId,ActivityDate,Priority,Status,Description,WhatId, WhoId, Who.Name, What.Name,Type,IsReminderSet,
                                       ReminderDateTime,Reminder_Start_Date__c,Activity_Category__c,Activity_Type__c,Follow_up_Type__c,Activity_Sub_Type__c,Client_Engagement__c,Location__c,Parent_Activity_Detail_Id__c, Activity_Type_for_Instit__c 
                                       from Task where Parent_Activity_Detail_Id__c=:cId]); 
        }
        catch(Exception ex){
            system.debug('Exception in getTaskRecords : '+ex.getStackTraceString());
            throw ex;
        }
        
        return taskList;
    }
    
    //this method is called when a new follow up task is created or an exisiting follow up task is opened
    public static Task showTaskPopUp(Boolean taskCallNote, String currentUserId, String individualChildRecordId, Task parentTask, Event parentEvent, Task task, List<MFS_Activity360GeneralUtility.wrapperClass> taskWrapperList){
        boolean flag;
        Task t = new Task();
        
        try{
            if(individualChildRecordId!=null && !string.isBlank(individualChildRecordId)) {
                for(MFS_Activity360GeneralUtility.wrapperClass wc : taskWrapperList){
                    if(wc.wTask.Id == individualChildRecordId){ 
                        task = wc.wTask; 
                        
                    }
                }
            }
            if(individualChildRecordId==null && string.isBlank(individualChildRecordId)){
                String subject;
                subject = (taskCallNote) ? MFS_AllConstants.TASK_REASON_FOR_CALL_VALUES.get(parentTask.Reason_for_call__c) : MFS_AllConstants.EVENT_METHOD_VALUES.get(parentEvent.Method__c);
                task = new Task();
                task.status =  MFS_AllConstants.TASK_STATUS_FIELD_DEFAULTVALUE; //'Open'
                task.OwnerId = UserInfo.getUserId();
                task.Priority = MFS_AllConstants.FOLLOWUP_TASK_PRIORITY_FIELD_DEFAULTVALUE; //'Low'
                task.Subject = (subject!=null && !string.isEmpty(subject)) ? MFS_AllConstants.FOLLOWUP_TASK_SUBJECT_FIELD_DEFAULTVALUE + ' '+ subject : MFS_AllConstants.FOLLOWUP_TASK_SUBJECT_FIELD_DEFAULTVALUE_1;
                task.WhatId = (taskCallNote) ? ((!string.isEmpty(parentTask.WhatId) && parentTask.WhatId!=null) ? parentTask.WhatId : null) : ((!string.isEmpty(parentEvent.WhatId) && parentEvent.WhatId!=null) ? parentEvent.WhatId : null);
                //task.Activity_Type_for_Instit__c = (taskCallNote) ? null : parentEvent.Activity_Type_for_Instit__c;    
                String recType = Apexpages.currentPage().getParameters().get('RecType');
                RecordType oRecTypeActivity = MFS_Activity360GeneralUtility.assignActivityRecordType(true, recType);
                task.RecordTypeId = oRecTypeActivity.Id;       
            }
            t = task; 
        }
        catch(Exception ex){
            system.debug('Exception in showTaskPopUp : '+ex.getStackTraceString());
            throw ex;
        }
        
        return t; 
    }
    
    //this method saves the newly created or exisiting follow up task
    public static List<MFS_Activity360GeneralUtility.wrapperClass> saveFollowUpTask(string cId, Task task, Activity_Detail__c callNote, List<MFS_Activity360GeneralUtility.wrapperClass> taskWrapperList, String reminderTime){
        
        List<MFS_Activity360GeneralUtility.wrapperClass> tempList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        
        try{
            if(callNote.Id!=null){ 
                
                boolean errorMsg = false;
                
                //if it is edit of exisiting follow up task record
                if(task.Id!=null){
                    string whoIdObjectName = ( !string.isEmpty(task.whoId) && task.whoId!=null) ? (String)((task.whoId).getSobjectType().getdescribe().getName()) : '';
                    String whatIdLen = (task.WhatId!=null) ? (String)task.WhatId : '';
                    if(whoIdObjectName == 'Lead' && whatIdLen.length() >14 && !string.isEmpty(task.whatId) && task.whatId!=null){ 
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Prospect cannot be linked if Related To field has value'));
                        errorMsg = true;
                    }
                    
                    if(!errorMsg){
                        if(task.Reminder_Start_Date__c != null)
                            task.ReminderDateTime = MFS_Activity360GeneralUtility.dateTimeConcat(task.Reminder_Start_Date__c, reminderTime);
                        upsert task; }
                }
                
                //if this is new follow up task creation
                else if(task.Id == null){
                    Activity_Detail__c ad = new Activity_Detail__c();
                    
                    ad.Subject__c = task.Subject;
                    if(ad.Organization__c == null){ 
                        ad.Organization__c= ( !string.isEmpty(task.WhatId) && task.WhatId!=null && (String)((task.WhatId).getSobjectType().getdescribe().getName()) =='Account') ? task.WhatId : Null;
                    }
                    ad.Contact__c= (!string.isEmpty(task.WhoId) && task.WhoId!=null && (String)((task.WhoId).getSobjectType().getdescribe().getName()) =='Contact') ? task.WhoId : Null;
                    ad.Not_An_Orphan_Record__c = true;
                    
                    upsert ad;
                    
                    if(ad.Id!=null){
                        
                        //Assign RecordType while creating new Task/Event
                        String recType = Apexpages.currentPage().getParameters().get('RecType');
                        RecordType oRecTypeActivity = MFS_Activity360GeneralUtility.assignActivityRecordType(true, recType);
                        System.debug('oRecTypeActivity========'+oRecTypeActivity);
                        task.Activity_Detail__c = ad.Id;
                        task.Parent_Activity_Detail_Id__c = cId;
                        task.RecordTypeId = oRecTypeActivity.Id;
                        if(task.Reminder_Start_Date__c!=null)
                            task.ReminderDateTime = MFS_Activity360GeneralUtility.dateTimeConcat(task.Reminder_Start_Date__c, reminderTime);
                        if(task.IsReminderSet && task.ActivityDate != null ){
                            
                            if(task.ActivityDate == system.today())
                            {
                                task.ReminderDateTime = system.now().addMinutes(30);
                            }
                            else
                            {
                                task.ReminderDateTime= DateTime.newInstance(task.ActivityDate.year(),task.ActivityDate.month(),task.ActivityDate.day() );
                                task.ReminderDateTime = task.ReminderDateTime.addMinutes(30);
                            }
                            task.Reminder_Start_Date__c = task.ActivityDate;
                        }
                        
                        string whoIdObjectName = ( !string.isEmpty(task.whoId) && task.whoId!=null) ? (String)((task.whoId).getSobjectType().getdescribe().getName()) : '';
                        String whatIdLen = (task.WhatId!=null) ? (String)task.WhatId : '';
                        if(whoIdObjectName == 'Lead' && whatIdLen.length() >14 && !string.isEmpty(task.whatId) && task.whatId!=null){ 
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Prospect cannot be linked if Related To field has value'));
                            errorMsg = true;
                        }
                        
                        if(!errorMsg){ upsert task; }
                    }
                    
                    if(task.Id!=null){
                        MFS_Activity360GeneralUtility.wrapperClass twc = new MFS_Activity360GeneralUtility.wrapperClass(task,false);
                        taskWrapperList.add(twc);
                    }
                }  
            }
            
            tempList = taskWrapperList;  
        }
        catch(Exception ex){
            system.debug('Exception in saveFollowUpTask : '+ex.getStackTraceString());
            throw ex;
        }
        
        return tempList;
    }
    
    //deletes the exisiting follow up task
    public static List<MFS_Activity360GeneralUtility.wrapperClass> deleteFollowUpTaskEvent(String individualChildRecordId, List<MFS_Activity360GeneralUtility.wrapperClass> taskWrapperList){
        
        List<MFS_Activity360GeneralUtility.wrapperClass> tempTaskToKeepList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        List<Task> tempTaskToDeleteList = new List<Task>();
        List<MFS_Activity360GeneralUtility.wrapperClass> tempEventToKeepList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        
        try{
            if(taskWrapperList.size()>0 && individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                for(MFS_Activity360GeneralUtility.wrapperClass tw:taskWrapperList){
                    if(tw.wTask.Id != individualChildRecordId) { tempTaskToKeepList.add(tw); }
                    if(tw.wTask.Id == individualChildRecordId) { tempTaskToDeleteList.add(tw.wTask); }
                }
                if(tempTaskToDeleteList.size()>0){ delete tempTaskToDeleteList; }
                taskWrapperList = tempTaskToKeepList;
            } 
        }
        catch(Exception ex){
            system.debug('Exception in deleteFollowUpTaskEvent : '+ex.getStackTraceString());
            throw ex;
        }
        
        return taskWrapperList;
    }
    
    
}