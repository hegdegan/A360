/*
Apex class            :  MFS_Activity360GeneralUtility
Version               :  1.0
Created Date          :  16 SEP 2016
Function              :  This Utility class contains all the common methods related to Activity360 and the main wrapper class

Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* Gyanendra Singh            16 SEP 2016              Initial Version
*/

public with sharing class MFS_Activity360GeneralUtility {
    private static final String RETAIL_TYPE ='Retail';
    private static final String INST_TYPE = 'Institution';
    private static final String INSTITUTIONAL_TEXT = 'Instit';
    private static final String GLOBAL_CLIENT_SERVICE = 'Global Client Service';
    private static final String GLOBAL_CLIENT_RELATIONS = 'Global Consultant Relations';
    private static final String TASK_TEXT ='Task';
    private static final String EVENT_TEXT = 'Event';
    //Wraper for dropdowns to hold id and label
    public class wSelectOption{
        public String id{get;set;}
        public String label{get;set;}
        
        public wSelectOption(String id, String label){
            this.id = id;
            this.label = label;
        }
    }
    
    //wrapper class to build all the related records
    public class wrapperClass{
        public Task wTask {get;set;}
        public Event wEvent {get;set;}
        public Competitor_Product__c wCompProduct {get;set;}
        public Competitive_Analysis_Request__c wCompAnalysisRequest {get;set;}
        public List<SelectOption> lstNotifiersForCompRequest {get;set;}
        public Competitive_Analysis_Product__c wCompAnalysisProdJn {get;set;}
        public Call_Note_Product__c wProductJNforCA {get;set;}
        public Meeting_Material_Request__c wMMR {get;set;}
        public Account__c mmrClientAsscn{get;set;}
        public Product2 mmrPortfolio{get;set;}
        public Event_Request__c wSpeakerReq {get;set;}
        public Product2 wProduct {get;set;} 
        public Call_Note_Product__c wActivityProdJuncObj {get;set;}
        public boolean Selected {get;set;}
        public List< Competitor_Product__c> lstCompProd {get;set;}
        
        //Attendee variables
        public string Name {get;set;}
        public string Type {get;set;}
        public string comments {get;set;}
        //MMR variables
        public String clientInvName{get;set;}
        public String portfName{get;set;}
        public String portfCode{get;set;}
        public Date portfStartDate{get;set;}
        public Boolean isNew{get;set;}
        public Integer rowNum{get;set;}
        public String labelName{get;set;}
        public String fieldValue{get;set;}
        
        public wrapperClass(Task t, Boolean sel){
            this.wTask = t;
            this.Selected = sel;
        }
        
        /*public wrapperClass(Event e, Boolean sel){
            this.wEvent = e;
            this.Selected = sel;
        }
        */
        public wrapperClass(Competitor_Product__c cProduct, Boolean sel){
            this.wCompProduct = cProduct;
            this.Selected = sel;
        }
        
        //Wrapper for MMR Start
        public wrapperClass(Meeting_Material_Request__c mmReq, Boolean sel){
            this.wMMR = mmReq;
            this.Selected = sel;
        }
        
        
        public wrapperClass(Product2 mmrportfolio, String portfName, String portfCode, Date portfStartDate, Boolean sel, Boolean isNew, Integer rowNum)
        {
            this.mmrportfolio = mmrportfolio;
            this.portfName = portfName;
            this.portfCode = portfCode;
            this.portfStartDate = portfStartDate;
            this.Selected = sel;
            this.isNew = isNew;
            this.rowNum = rowNum;
        }
        public wrapperClass(String labelName, String fieldValue)
        {
            this.labelName = labelName;
            this.fieldValue = fieldValue;
        }
        
        public wrapperClass(Event_Request__c speakerReq, Boolean sel){
            this.wSpeakerReq= speakerReq;
            this.Selected = sel;
        }        
        
        public wrapperClass(Competitive_Analysis_Request__c wCompAnalysisRequest, Boolean sel){
            this.wCompAnalysisRequest = wCompAnalysisRequest;
            this.Selected = sel;
        }
        public wrapperClass(){}
        
    }
    
    //Creates tasks for follow up section automatically based upon some conditions   
    public static void automaticFollowUpTaskCreate(String FollowUpFor,Boolean taskCallNote, Event parentEvent, Task parentTask, List<MFS_Activity360GeneralUtility.wrapperClass> taskWrapperList, Id whoId, Integer dueDateAdvanceBy, string priority){
        try{
            List<Task> taskList = new List<Task>();
            List<Coverage_Team__c> contactCoverageTeam = new List<Coverage_Team__c>([select id,Coverage_Owner__c, Coverage_Owner__r.isActive from Coverage_Team__c where Coverage_Role__c =: MFS_AllConstants.COVERAGE_TEAM_ROLE_DEFAULTVALUE 
                                                                                     AND Contact__c != NULL AND Contact__c =:whoId]);
            
            String subj;
            if(FollowUpFor == 'CAR')
                subj = MFS_AllConstants.FOLLOWUP_TASK_TYPE_FOR_CAR;
            else
            	subj = (taskCallNote) ? parentTask.Subject : parentEvent.Subject;
            
            Set<ID> setAssignedTo = new Set<ID>();
            if(contactCoverageTeam.size()>0){
                for(Coverage_Team__c ct : contactCoverageTeam){
                    if(ct.Coverage_Owner__r.isActive)
                    	setAssignedTo.add(ct.Coverage_Owner__c);
                }
            }
            if(setAssignedTo.size() == 0){
                //If No Internal WholeSalers, assign to current user
                setAssignedTo.add(UserInfo.getUserId());
            }
            
            /*if(taskCallNote){
                if(parentTask.recordtype.Name != null && parentTask.recordtype.Name.containsIgnoreCase(Retail)){
                    Recordtype rt = [select id,Name,SobjectType,DeveloperName from RecordType where id = : parentEvent.RecordTypeId LIMIT 1]
                }
            }
*/          List<Activity_Detail__c> adList = new List<Activity_Detail__c>(); 
            for(ID IdAssignedTo : setAssignedTo){
                
                Activity_Detail__c ad = new Activity_Detail__c();
                ad.Subject__c = subj;
                
                if(ad.Organization__c == null){ 
                    ad.Organization__c= (taskCallNote) ? (!String.isEmpty(parentTask.WhatId) && parentTask.WhatId!=null && (String)((parentTask.WhatId).getSobjectType().getdescribe().getName()) =='Account' ? parentTask.WhatId : null)  : (!String.isEmpty(parentEvent.WhatId) && parentEvent.WhatId!=null && (String)((parentEvent.WhatId).getSobjectType().getdescribe().getName()) =='Account' ? parentEvent.WhatId : null);
                }
                ad.Contact__c= (!String.isEmpty(whoId) && whoId!=null && (String)(((Id)whoId).getSobjectType().getdescribe().getName()) =='Contact') ? whoId : Null;
                ad.Not_An_Orphan_Record__c = true;
                adList.add(ad);
                //upsert ad;
            }
            insert adList;
            System.debug('adList====>'+adList);
            Id tempRecordTypeId;
            if(!taskCallNote){
                RecordType rt = [select id, Name from RecordType where id = :parentEvent.recordTypeId LIMIT 1];              
                if(rt != null && rt.Name.containsIgnoreCase('Retail'))
                    tempRecordTypeId =  [select id from RecordType where DeveloperName = 'Log_a_Call_Retail' LIMIT 1].Id;
                else
                    tempRecordTypeId =  [select id from RecordType where DeveloperName = 'Log_a_Call_Retail' LIMIT 1].Id;
            }
            Integer i = 0;
            for(ID IdAssignedTo : setAssignedTo){
                
                if(adList[i].Id!=null){
                    task t = new task();
                    //Set default values for new task
                    t.OwnerId = IdAssignedTo;
                    t.Status = MFS_AllConstants.TASK_STATUS_FIELD_DEFAULTVALUE; //'Open'
                    if(taskCallNote){
                        t.recordtypeId = parentTask.recordtypeId;
                    }
                    else{
                        t.recordTypeId = tempRecordTypeId;
                    }
                    t.Subject = subj;
                    t.ActivityDate = system.Today() + dueDateAdvanceBy;
                    t.Priority = priority;
                    t.Type = MFS_AllConstants.AUTO_TASK_TYPE_FIELD_DEFAULTVALUE; //'Scheduled Call'
                    if(FollowUpFor == 'CAR'){
                     	t.Follow_up_Type__c = MFS_AllConstants.FOLLOWUP_TASK_TYPE_FOR_CAR;  
                    }
                    t.Activity_Detail__c = adList[i].Id;
                    t.Parent_Activity_Detail_Id__c = (taskCallNote) ? parentTask.Activity_Detail__c : parentEvent.Activity_Detail__c;
                    t.WhoId = whoId;
                    t.WhatId = (taskCallNote) ? (!String.isEmpty(parentTask.WhatId) && parentTask.WhatId!=null ? parentTask.WhatId : null)  : (!String.isEmpty(parentEvent.WhatId) && parentEvent.WhatId!=null ? parentEvent.WhatId : null);
                        
                        taskList.add(t);
                }
                i++;
            }
            if(taskList.size()>0){
                insert taskList;
                for(task t : taskList){ taskWrapperList.add(new wrapperClass(t,false)); }
            }  
        }catch(Exception ex){
            system.debug('Exception in automaticFollowUpTaskCreate : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Create follow up task when Call Direction is Inbound
    public static Boolean automaticFollowUpTaskInbound(Task parentTask, List<MFS_Activity360GeneralUtility.wrapperClass> taskWrapperList){
        try{
            Activity_Detail__c ad = new Activity_Detail__c();
            ad.Subject__c = parentTask.subject;
            
            if(ad.Organization__c == null){ 
                ad.Organization__c= ( !string.isEmpty(parentTask.WhatId) && parentTask.WhatId!=null && (String)((parentTask.WhatId).getSobjectType().getdescribe().getName()) =='Account') ? parentTask.WhatId : Null;
            }
            ad.Contact__c= (!string.isEmpty(parentTask.WhoId) && parentTask.WhoId!=null && (String)((parentTask.WhoId).getSobjectType().getdescribe().getName()) =='Contact') ? parentTask.WhoId : Null;
            ad.Not_An_Orphan_Record__c = true;
            
            upsert ad;
            
            if(ad.Id!=null){
                task t = new task();
                //Set default values for new task
                t.OwnerId = ParentTask.OwnerId;
                t.Status = MFS_AllConstants.TASK_STATUS_FIELD_DEFAULTVALUE; //'Open'
                t.recordtypeId = parentTask.recordtypeId;
                t.Subject = MFS_AllConstants.FOLLOWUP_TASK_SUBJECT_FIELD_DEFAULTVALUE +' '+MFS_AllConstants.TASK_REASON_FOR_CALL_VALUES.get(parentTask.Reason_for_call__c);
                t.ActivityDate = calculateBusinessHours(parentTask.OwnerId, 1);
                t.Priority = MFS_AllConstants.TASK_PRIORITY_DEFAULT;
                t.Follow_up_Type__c = MFS_AllConstants.TASK_INBOUND_FOLLOW_UP_TYPE;
                t.Activity_Detail__c = ad.Id;
                t.Parent_Activity_Detail_Id__c = parentTask.Activity_Detail__c;
                t.WhoId = ParentTask.whoId;
                t.WhatId = parentTask.WhatId;
                insert t;
                taskWrapperList.add(new wrapperClass(t,false)); 
            }
            return TRUE;
        }catch(Exception ex){
            system.debug('Exception in automaticFollowUpTaskCreate : '+ex.getStackTraceString());
            throw ex;
            return FALSE;
        }
    }
    
    //Calculate Scheduled date depending on user's business hours
    public Static Date calculateBusinessHours(Id ownerId, Integer noOfDays) {
        try {
            User usr = [select Country, City from User where Id =:ownerId];
            String userBusinessHour;
            Date newDueDate;
            if(usr.City != null){
                userBusinessHour = usr.Country + ' ' + '(' + usr.City + ')'; 
            }else{
                userBusinessHour = usr.Country;
            }
            List<BusinessHours> bHours = new  List<BusinessHours>();
            bHours = [select Id,Name from BusinessHours where Name =: userBusinessHour Limit 1];
        	if(bHours.size()>0)
            {
                DateTime dueDate = BusinessHours.add(bHours[0].Id,System.now(),Integer.valueOf(1)*24*60*60*1000);
                newDueDate = duedate.Date(); 
                
            }else{
                BusinessHours defHours = [select Id,Name from BusinessHours where isDefault =: true];
                DateTime dueDate = BusinessHours.add(defHours.Id,System.now(),Integer.valueOf(1)*24*60*60*1000);
                newDueDate = duedate.Date();
            }
            return newDueDate;
        }catch(Exception e){
            System.debug('Exception:'+e.getStackTraceString());
            return null;
        }
    }
    //Method to assign Record Type for the record to be created new
    public static RecordType assignActivityRecordType(Boolean isTask, String recType){
        try{
            String activityType;
            String recTypeDevName;
            Profile pro =  [select Name from Profile where id =: Userinfo.getProfileId() LIMIT 1 ];
            if(isTask){
                activityType = TASK_TEXT;
                if(recType != NULL && recType.containsIgnoreCase(RETAIL_TYPE)){
                    recTypeDevName = MFS_AllConstants.RECTYPE_TASK_RETAIL;
                }else if(recType != NULL && recType.containsIgnoreCase(INST_TYPE)){
                    recTypeDevName = MFS_AllConstants.RECTYPE_TASK_INSTIT;
                }else{
                    if(pro.Name.containsIgnoreCase(INSTITUTIONAL_TEXT) || pro.Name.containsIgnoreCase(GLOBAL_CLIENT_SERVICE) || pro.Name.containsIgnoreCase(GLOBAL_CLIENT_RELATIONS)){
                        recTypeDevName = MFS_AllConstants.RECTYPE_TASK_INSTIT; 
                    }else{
                        recTypeDevName = MFS_AllConstants.RECTYPE_TASK_RETAIL;
                    }
                }
            }else{
                activityType = EVENT_TEXT;
                if(recType != NULL && recType.containsIgnoreCase(RETAIL_TYPE)){
                    recTypeDevName = MFS_AllConstants.RECTYPE_EVENT_RETAIL;
                }
                else if(recType != NULL && recType.containsIgnoreCase(INST_TYPE)){
                    recTypeDevName = MFS_AllConstants.RECTYPE_EVENT_INSTIT;
                }
                else{
                    if(pro.Name.containsIgnoreCase(INSTITUTIONAL_TEXT) || pro.Name.containsIgnoreCase(GLOBAL_CLIENT_SERVICE) || pro.Name.containsIgnoreCase(GLOBAL_CLIENT_RELATIONS)){
                        recTypeDevName = MFS_AllConstants.RECTYPE_EVENT_INSTIT; 
                    }else{
                        recTypeDevName = MFS_AllConstants.RECTYPE_EVENT_RETAIL;
                    }
                }
            }
            for(RecordType rt: [select id,Name,SobjectType,DeveloperName from RecordType where DeveloperName=: recTypeDevName and SobjectType=: activityType  LIMIT 1] ){
                return rt;                        
            }  
        }
        catch(Exception ex){
            system.debug('Exception in assignActivityRecordType : '+ex.getStackTraceString());
            throw ex;
        }
        return NULL;
    }
    
    //concatenate date and time
    public static DateTime dateTimeConcat(Date dt, String tm){
        String timePart;
        DateTime dtTm;
        
        try{
            if(tm != NULL){
                if(tm.contains('AM')){
                    tm = tm.replace(' AM', '00');
                    String[] parts = tm.split(':');
                    Integer t1 = Integer.valueOf(parts[0]);
                    t1 = (t1 == 12) ? 00 : t1;
                    String part1 = String.valueOf(t1);
                    String t2= parts[1];
                    t2 = t2.left(2);
                    timePart = part1 + ':' + t2 + ':' + '00';
                }
                if(tm.contains('PM')){
                    tm = tm.replace(' PM', '00');
                    String[] parts = tm.split(':');
                    Integer t1 = Integer.valueOf(parts[0]);
                    t1 = (t1 == 12) ? 12 : t1 + 12;
                    String part1 = String.valueOf(t1);
                    String t2= parts[1];
                    t2 = t2.left(2);
                    timePart = part1 + ':' + t2 + ':' + '00';
                }
            }else{
                timePart = '00:00:00';
            }
            
            String stDateTime = String.valueOf(dt) + ' ' + timePart;
            stDateTime = stDateTime.replaceAll('/','-');
            dtTm = dateTime.valueOf(stDateTime);   
        }
        catch(Exception ex){
            system.debug('Exception in dateTimeConcat : '+ex.getStackTraceString());
            throw ex;
        }
        
        return dtTm;
    }
    
    //Change the value in the standard field Location based upon the change in the value of the custom field Location__c
    public static void changeLocation(Boolean displayPopup, Boolean showEventPopUp, Event parentEvent, Event event){
        
        try{
            if(parentEvent.Location__c == MFS_AllConstants.EVENT_LOCATION_FIELD_DEFAULTVALUE_OFFICE){//} 'MFS Office'){
                User u = [select id,name,MFS_Location__c,Country from user where id =:UserInfo.getUserId() LIMIT 1];
                parentEvent.Location = u.MFS_Location__c;//(u.Country == MFS_AllConstants.EVENT_DEFAULT_COUNTRY) ? MFS_AllConstants.EVENT_DEFAULT_LOCATION : u.MFS_Location__c;
            }
            else if(parentEvent.Location__c == MFS_AllConstants.EVENT_LOCATION_FIELD_DEFAULTVALUE_OFFSITE){// 'Offsite'){
                Boolean flag = false;
                parentEvent.Location = '';
                
                if(!string.isEmpty(parentEvent.Whoid) && parentEvent.Whoid!=null){
                    for(Contact con:[select id, mailingstreet, mailingcity, mailingstate, mailingPostalcode, mailingCountry from Contact where id =: parentEvent.Whoid LIMIT 1]){
                        if(con.mailingcity != NULL){ parentEvent.Location = con.mailingcity + ', '; }
                        if(con.mailingstate != NULL){ parentEvent.Location +=  con.mailingstate + ', '; }
                        if(con.mailingCountry != NULL){ parentEvent.Location +=  con.mailingCountry; }
                        
                        flag = true;
                    } 
                }
                if (!flag)  {parentEvent.Location = '';}
            }
            else{
                parentEvent.Location = '';
            }  
        }catch(Exception ex){
            system.debug('Exception in changeLocation : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //This method is used to convert DateTime into string, breaking it into Date part and Time part
    public static string dateTimeConversion(Datetime dt, boolean isStartDateTime){
        String timePartInString;
        try{
            time localtme = dt.time();
            string onlyTimePart = String.valueOf(localtme);
            String[] parts = onlyTimePart.split('\\.');
            onlyTimePart = parts[0];
            onlyTimePart = onlyTimePart.left(5);
            String[] hhMM = onlyTimePart.split(':');
            Integer hh = Integer.valueOf(hhMM[0]);
            String mm = hhMM[1];
            if(hh >= 12){
                hh = (hh == 12) ? hh : hh - 12;
                timePartInString = String.valueOf(hh) + ':' + mm + ' PM';
            }
            else{
                hh = (hh == 00) ? hh + 12 : hh;
                timePartInString = String.valueOf(hh) + ':' + mm + ' AM';
            } 
        }
        catch(Exception ex){
            system.debug('Exception in dateTimeConversion : '+ex.getStackTraceString());
            throw ex;
        }
        
        return timePartInString;
    }
    
    //This method is used to convert DateTime into string, breaking it into Date part and Time part. This is for institutional Log A Call to advance time by 30 minutes
    public static string dateTimeConversion2(Task parentTask){
        String timePartInString;
        
        try{
            time localtme = system.Now().time();
            string onlyTimePart = String.valueOf(localtme);
            String[] parts = onlyTimePart.split('\\.');
            onlyTimePart = parts[0];
            onlyTimePart = onlyTimePart.left(5);
            String[] hhMM = onlyTimePart.split(':');
            Integer hh = Integer.valueOf(hhMM[0]);
            Integer mm = Integer.valueOf(hhMM[1]);
            boolean advanceDate = false;
            
            if(mm < 30){
                if(hh >= 12){ // afternoon 12 till night 11 PM
                    hh = (hh == 12) ? hh : hh - 12;
                    timePartInString = String.valueOf(hh) + ':' + '30' + ' PM';
                }
                else{ // Mid-night 12 till morning 11 AM
                    hh = (hh == 00) ? hh + 12 : hh;
                    timePartInString = String.valueOf(hh) + ':' + '30' + ' AM';
                }  
            }
            if(mm >= 30){
                if(hh >= 12){ // afternoon 12 till night 11 PM
                    hh = (hh == 12) ? hh - 11 : hh - 11;
                    
                    //check if time is some 11:xx PM as then we need to change PM to AM
                    if(hh == 12){
                        advanceDate = true;
                        timePartInString = String.valueOf(hh) + ':' + '00' + ' AM';
                    }
                    else{
                        timePartInString = String.valueOf(hh) + ':' + '00' + ' PM';
                    }
                }
                
                else{ // Mid-night 12 till morning 11 AM 
                    hh = hh + 1;
                    //check if time is some 11:xx AM as then we need to change AM to PM
                    timePartInString = (hh == 12) ? String.valueOf(hh) + ':' + '00' + ' PM' : String.valueOf(hh) + ':' + '00' + ' AM';
                }
            }
            
            if(advanceDate) {
                parentTask.ActivityDate = parentTask.ActivityDate.addDays(1); 
            }
            parentTask.Called_Time__c = timePartInString; 
        }catch(Exception ex){
            system.debug('Exception in dateTimeConversion2 : '+ex.getStackTraceString());
            throw ex;
        }
        return timePartInString;
    }
    
    //This method is to advance time part by 1 hour from the target time
    public static string advanceTimeByOneHour(Event parentEvent, String tm){
        String endTime;
        
        try{
            String timePart;
            if(tm.contains('AM')){
                tm = tm.replace(' AM', '00');
                String[] parts = tm.split(':');
                Integer startHour = Integer.valueOf(parts[0]);
                String startTime= parts[1];
                startTime = startTime.left(2);
                Integer endHour;
                
                if(startHour == 12){
                    endTime = '1'+ ':' + startTime + ' AM';
                }
                else{
                    endTime = (startHour == 11) ? String.valueOf(startHour + 1) + ':' + startTime + ' PM' : String.valueOf(startHour + 1) + ':' + startTime + ' AM';
                }  
            }
            if(tm.contains('PM')){
                tm = tm.replace(' PM', '00');
                String[] parts = tm.split(':');
                Integer startHour = Integer.valueOf(parts[0]);
                String startTime= parts[1];
                startTime = startTime.left(2);
                Integer endHour;
                
                if(startHour == 12){
                    endTime = '1'+ ':' + startTime + ' PM';
                    parentEvent.Event_End_Date__c = parentEvent.Event_Start_Date__c;
                }
                else{
                    if(startHour == 11){ //To check if after advancing time by 1 hour the next day has come then need to set ActivityDate to next date
                        endTime = String.valueOf(startHour + 1) + ':' + startTime + ' AM';
                        parentEvent.Event_End_Date__c = parentEvent.Event_Start_Date__c.addDays(1); 
                    }
                    else{
                        endTime = String.valueOf(startHour + 1) + ':' + startTime + ' PM';
                        parentEvent.Event_End_Date__c = parentEvent.Event_Start_Date__c;
                    }
                }  
            }
        }
        catch(Exception ex){
            system.debug('Exception in advanceTimeByOneHour : '+ex.getStackTraceString());
            throw ex;
        }
        
        return endTime;
    }
    
    //upload attachments to the parent event or parent task
    public static PageReference uploadAttachment(boolean isSF1, RecordType oRecTypeActivity, Id parentObjectID, boolean isNew, string isConsole, boolean taskCallNote, boolean eventCallNote, blob fileBody, String fileName, Task parentTask, Event parentEvent, Activity_Detail__c callNote){
        PageReference pg;
        
        try{
            Attachment att = new Attachment();       
            att.OwnerId = UserInfo.getUserId();
            att.ParentId = (taskCallNote) ? parentTask.Id : parentEvent.Id; // the record the file is attached to
            att.Body = fileBody;
            att.Name = fileName;
            if(oRecTypeActivity.Name.containsIgnoreCase(RETAIL_TYPE)){
                pg = page.MFS_Activity360RetailPageSF1;
                pg.getParameters().put('RecType', RETAIL_TYPE);
            }
            else{
                pg = page.MFS_Activity360PageSF1;
                pg.getParameters().put('RecType', INST_TYPE);
            }
            
            pg.getParameters().put('id', callNote.Id);
            if(taskCallNote){ pg.getParameters().put('task', 'true'); }
            if(eventCallNote){ pg.getParameters().put('event', 'true'); }
            pg.getParameters().put('returnID', parentObjectID);
            
            pg.setRedirect(true);
            if(isNew){
                pg.getParameters().put('isNew', 'true'); 
            }else{
                pg.getParameters().put('isNew', 'false'); 
            }
            if(isConsole == 'true'){
                pg.getParameters().put('isConsole', 'true'); 
            }
            
            try {
                insert att;
            } catch (DMLException e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
                return pg;
            } finally {
                att = new Attachment(); 
            }
        }
        catch(Exception ex){
            system.debug('Exception in uploadAttachment : '+ex.getStackTraceString());
            throw ex;
        }
        return pg;
    }
    
    //delete the attachments associated to the parent event or parent task
    public static List<Attachment> deleteAttachment(List<Attachment> attachmentList, string individualChildRecordId){
        List<Attachment> tempListToKeep = new  List<Attachment>();
        List<Attachment> tempListToDelete = new  List<Attachment>();
        
        try{
            if(attachmentList.size()>0 && individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                for(Attachment att : attachmentList){
                    if(att.Id == individualChildRecordId) { tempListToDelete.add(att); }
                    if(att.Id != individualChildRecordId) { tempListToKeep.add(att); }
                }
                
                if(tempListToDelete.size() >0 ) { delete tempListToDelete; }
                attachmentList = tempListToKeep;
            }  
        }
        catch(Exception ex){
            system.debug('Exception in deleteAttachment : '+ex.getStackTraceString());
            throw ex;
        }
        
        return attachmentList;
    }
    
}