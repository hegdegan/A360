/***************************************************************************************************
Apex Class Name    : MFS_Activity360Controller 
Version            : 1.0 
Created Date       : 10 JUN 2016
Function           : This is a controller for Create Activity(Institutional & Retail) and Log a Call(Institutional & Retail)
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Gyanendra Singh               06/10/2016              Original Version
Ganesh Hegde                 10/10/2016                Updated invitee section, product RL, product search
***************************************************************************************************/
global with sharing class MFS_Activity360Controller 
{
    //Meeting prep sheet
    public String pageURLForDetailSheet{get; set;}
    //Class constants
    private static FINAL String CALL_DETAILS = System.Label.A360_Call_Details;
    private static FINAL String MEETING_DETAILS = System.Label.A360_Meeting_Details;
    private static final String INSTITUTIONAL_TYPE = 'Instit';
    private static final String RETAIL_TYPE ='Retail';
        
    //private variables
    private String inId;
    private String btnName;
    private Id oldAssignedToId;
    private Set<id> existingProdId;
    private Set<Id> portfolioSetToRemove;
    private Map<String, List<MMR_Client_Investment_Association__c>> portfolioMap;
    private Set<Id> removedInvitees;
    private Set<Id> removedInviteePf;
    private Set<Id> portfToBeRemoved;
    private static String defaultUserVehicle;
    
    //public variables
    public Id currentUserId {get;set;}
    public String currentUserName {get;set;}
    public Activity_Detail__c callNote {get;set;}
    public Task parentTask {get;set;}
    public Event parentEvent {get;set;}
    public Task task {get;set;}
    public Event event {get;set;}
    public Boolean isNew{get;set;}
    public Competitive_Analysis_Request__c compRequest {get;set;}
    public Meeting_Material_Request__c MMR {get;set;}
    public Event_Request__c speakerRequest{get;set;}
    public RecordType oRecTypeActivity {get;set;}
    public ID selectedCompProduct {get;set;}
    public String recordId {get;set;}
    public boolean disabled {get;set;}
    public boolean taskCallNote {get;set;}
    public boolean eventCallNote {get;set;}
    public boolean errorFlag {get;set;}
    public string topPageBlockName {get;set;}
    public ID parentObjectID {get;set;}
    public String parentObjectType {get;set;}
    public String EventRequestContactName {get;set;}
    public String EventRequestOrgName {get;set;}
    public boolean showAllRelatedSection {get;set;}
    public boolean showEventInviteeSection {get;set;}
    public string individualChildRecordId {get;set;}
    public String rmMMRPortfRow{get;set;}    
    public boolean popUpInEditMode {get;set;}
    public ID removeInviteeId{get;set;}
    public string isConsole {get;set;}
    public Boolean isFollowupTaskForER {get;set;}
    public String selectedProduct { get; set; }
    public String selectedComProduct { get; set; }
    public String selectedComProductForCA{ get; set; }
    public String eventInstructionRT{get;set;}
    public String jsonSelectedNotifiersForCA{get;set;} 
    public String jsonAvailableNotifiersForCA{get;set;} 
    public String jsonUpdatedNotifiersForCA{get;set;} 
    public boolean showSaveBtnOnPopUp {get;set;}
    public boolean displayPopup {get; set;}
    public boolean showTaskPopUp {get;set;}
    public boolean showEventPopUp {get;set;}
    public boolean showCompAnalysisPopUp {get;set;}
    public boolean showMMRPopUp {get;set;}
    public boolean showSpeakerRequestPopUp {get;set;}
    public boolean showEventRequestPopup {get;set;}
    public boolean editMMROrgName{get;set;}
    public Call_Note_Competitor_Product__c oCompProductJN {get;set;}
    public Call_Note_Product__c oProductJN {get;set;}
    public Competitive_Analysis_Product__c oCAProductJN {get;set;}
    public String searchText {get;set;}
    public String searchTextOrg {get;set;}
    public String searchTextCity {get;set;}
    public String searchTextCountry {get;set;}
    public boolean showEventInviteePopUp {get;set;}
    public string SearchObjects {get;set;}
    public Boolean isParentEvent {get;set;}
    public Event_Request__c placholderEventRequest  {get;set;}
    public string startDateTime {get;set;}
    public string endDateTime {get;set;}
    public string feStartDateTime {get;set;}
    public boolean allDayEvent {get;set;}
    public Date calledDate{get;set;}
    public Event_Relation__c tempEventRelation {get;set;}
    public Event_Relation_Portfolio_Junction__c evRelPort{get;set;}
    public String inviteeId{get;set;}
    public String removePfRowNum{get;set;}
    public Boolean showResponseBtn{get;set;}
    public String productSearchBtnName{get;set;}
    public String erStartTime{get;set;}
    public String erendTime{get;set;}
    public String invIdForPopup{get;set;}
    public String selectedInviteesALJSString{get;set;}
    public String srOrgName{get;set;}
    public String srContName{get;set;}
    public String reminderTime{get;set;}
    public String columnName{get;set;}
    public String sortingOrder {get; set;}
    public String sortingOrgOrder {get; set;}
    public String erRecordTypeId {get;set;}
    public String erObjectId {get;set;}
    public String requestorId {get;set;}
    public String eventTitleId {get;set;}
    public String erOrgId {get;set;}
    public String erContactId {get;set;}
    public String erStDateId {get;set;}
    public String erEndDateId {get;set;}
    public String pageURL{get;set;}
    public String isSelected{get;set;}
    public String selectedProdCount{get;set;}
    public Blob fileBody {get;set;}
    public string fileName {get;set;}
    public String ownerName{get;set;}
    public String whoName{get;set;}
    public String whatName{get;set;}
    public Opportunity op {get;set;}
    public string selectedCoverageTeamMembers {get;set;}
    public string oppAccountName {get;set;}
    public string oppClientContact {get;set;}
    public boolean resInEditMode {get;set;}
    public boolean allowRESRecord {get;set;}
    public boolean rESRecordExists {get;set;}
    public boolean showRESPopUp {get;set;}
    public string oppCurrencyCode {get;set;}
    public string whoIdObjectName {get;set;}
    public string whatIdObjectName {get;set;}
    public String remoteActionQueryURL{get;set;}
    public string followUpTaskWhoIdName {get;set;}
    public string followUpTaskWhatIdName {get;set;}
    public String MMROrgName{get;set;}
    public String searchOpt{
        set{searchOpt=value;}
        get{return searchOpt;}
    }
    public String selectedAssetGeography{
        get{return selectedAssetGeography;}
        set{selectedAssetGeography=value;}
    }
    public String selectedVehicle{
        get{return selectedVehicle;}
        set{selectedVehicle=value;}
    }  
    public String searchCom{
        set{searchCom=value;}
        get{return searchCom;}
    }
    public String firm{
        set{firm=value;}
        get{return firm;}
    }
    public String searchComCA{
        set{searchComCA=value;}
        get{return searchComCA;}
    }
    public String firmCA{
        set{firmCA=value;}
        get{return firmCA;}
    }
    public Set<Id> selectedIds { get; set; }
    public List<Event_Relation__c> evntRelList {get;set;}
    public List<Event_Relation__c> SpeakerList {get;set;}
    public Map<String,List<String>> mActivityTypeVsSubType;
    public List<MFS_Activity360GeneralUtility.wrapperClass> taskWrapperList {get;set;}
    public List<MFS_Activity360GeneralUtility.wrapperClass> eventWrapperList {get;set;}
    public List<MFS_Activity360GeneralUtility.wrapperClass> competitorProdWrapperList {get;set;}
    public List<MFS_Activity360GeneralUtility.wrapperClass> compProdWrapperListForRES {get;set;}
    public List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperList {get;set;}
    public List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperListForRES {get;set;}
    public List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperListForCA {get;set;}
    public List<MFS_Activity360GeneralUtility.wrapperClass> CompProductWrapperListForCA {get;set;}
    public List<MFS_Activity360GeneralUtility.wrapperClass> CompAnalysisWrapperList {get;set;}
    public List<MFS_Activity360GeneralUtility.wrapperClass> SpeakerWrapperList {get;set;}
    public List<MFS_Activity360GeneralUtility.wrapperClass> MMRWrapperList {get;set;}
    public List<MFS_Activity360GeneralUtility.WrapperClass> MMRPortfolioWrapperList{get;set;}
    public List<MMR_Client_Investment_Association__c> portfolioLst{get;set;}
    public List<SearchWrapper> wraplist{get;set;} 
    public List<MFS_Activity360GeneralUtility.WrapperClass> languageFields{get;set;}
    public List<selectOption> lstAvailableCompRequestNotifiers {get;set;}
    public List<String> lstSelectedNotifiersForCA {get;set;}
    Map<String, sObject> leftOptionMap = new Map<String, sObject>();
    Map<String, sObject> rightOptionMap = new Map<String, sObject>();
    public List<String> leftSelectedList {get;set;}
    public List<String> rightSelectedList {get;set;}
    public Map<Id,MFS_EventInviteeUtility.InviteeWrapper> inviteesMap{get;set;}
    public Set<Id> inviteeOrderKeys {get;set;}
    public List<ID> lstAllInviteeIDs {get;set;} 
    public List<ID> lstAllInviteeIDsFollowup {get;set;}
    public List<EventRelation> lstEventRelation{get;set;}    
    public List<EventRelation> lstEventRelationFollowup{get;set;}
    public Set<ID> sExistingRelationIds {get;set;}    
    public Set<ID> sExistingRelationIdsFollowup {get;set;}
    public Map<ID, String> mRightSelected {get;set;}
    public Map<ID, String> mLeftSelected {get;set;}
    public List<SelectOption> lstRightOption {get;set;}
    public List<SelectOption> lstLeftOption {get;set;}
    public List<SelectOption> rightOptionList {get;set;}
    public List<SelectOption> leftOptionList {get;set;}
    public List<Attachment> attachmentList {get;set;}
    
    //Construcor - this will initialize all variables, queries task or event details depending on the URL parameter, constructs related list wrappers for detail page view
    public MFS_Activity360Controller(){
        //Meeting prep sheet
        pageURLForDetailSheet = ApexPages.currentPage().getURL();
        if(!String.isEmpty(pageURLForDetailSheet) && pageURLForDetailSheet.containsIgnoreCase('MFS_Activity360RetailPageSF1'))
            pageURLForDetailSheet = pageURLForDetailSheet.replaceAll('(?i)MFS_Activity360RetailPageSF1','MFS_A360MeetingDetails');
        else if(!String.isEmpty(pageURLForDetailSheet) && pageURLForDetailSheet.containsIgnoreCase('MFS_Activity360PageSF1'))
            pageURLForDetailSheet = pageURLForDetailSheet.replaceAll('(?i)MFS_Activity360PageSF1','MFS_A360MeetingDetails');
        disabled = true;
        showSaveBtnOnPopUp = true;
        showEventRequestPopup = false;
        isParentEvent = true;
        taskCallNote = false;
        eventCallNote = false;
        showAllRelatedSection = false;
        showEventInviteeSection = false;
        showEventInviteePopUp = false;
        displayPopup = false;
        showEventPopUp = false;
        resInEditMode = true;
        allowRESRecord = false;
        rESRecordExists = false;
        showRESPopUp = false;
        parentTask = new Task();
        parentEvent = new Event();
        callNote = new Activity_Detail__c();
        inviteesMap = new Map<Id,MFS_EventInviteeUtility.InviteeWrapper>();
        evRelPort = new Event_Relation_Portfolio_Junction__c ();
        removedInvitees = new Set<Id>();
        removedInviteePf = new Set<Id>();
        portfToBeRemoved = new Set<Id>();
        oldAssignedToId = UserInfo.getUserId();
        currentUserId = UserInfo.getUserId();
        currentUserName  = UserInfo.getName();
        inviteeOrderKeys = new Set<Id>();
        attachmentList = new List<Attachment>();
        taskWrapperList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        eventWrapperList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        CompAnalysisWrapperList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        MMRWrapperList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        SpeakerWrapperList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        competitorProdWrapperList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        compProdWrapperListForRES = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        ProductWrapperList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        ProductWrapperListForRES = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        ProductWrapperListForCA = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        CompProductWrapperListForCA = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        oCompProductJN = new Call_Note_Competitor_Product__c();     
        oProductJN = new Call_Note_Product__c();
        oCAProductJN = new Competitive_Analysis_Product__c();
        oRecTypeActivity = new RecordType();
        MMRPortfolioWrapperList = new List<MFS_Activity360GeneralUtility.WrapperClass>();
        languageFields = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        portfolioLst = new List<MMR_Client_Investment_Association__c>();
        portfolioMap = new Map<String, List<MMR_Client_Investment_Association__c>>(); 
        placholderEventRequest = new Event_Request__c();
        tempEventRelation = new Event_Relation__c();
        portfolioSetToRemove = new Set<Id>();
        wraplist = new List<SearchWrapper>();  
        lstAllInviteeIDs = new List<ID> ();
        sExistingRelationIds = new Set<ID>();
        lstAllInviteeIDsFollowup = new List<ID> ();
        sExistingRelationIdsFollowup = new Set<ID>();  
        lstEventRelation = new List<EventRelation> ();
        lstEventRelationFollowup = new List<EventRelation>();
        mRightSelected = new Map<ID, String>();
        mLeftSelected = new Map<ID, String>();
        lstRightOption = new List<SelectOption>();
        lstLeftOption = new List<SelectOption>();
        leftSelectedList = new List<String>();
        rightSelectedList = new List<String>();
        
        //Read URL parameters
        recordId = Apexpages.currentPage().getParameters().get('id');
        String isTask = Apexpages.currentPage().getParameters().get('task');
        parentObjectID = Apexpages.currentPage().getParameters().get('returnID');
        parentObjectType = parentObjectID.getSObjectType().getDescribe().getName();
        String tstr = Apexpages.currentPage().getParameters().get('isNew');
        isConsole = Apexpages.currentPage().getParameters().get('isConsole');
        isFollowupTaskForER = false;
        
        //Include standard salesforce chatter in the top of the page
        pageURL = '/apex/MFS_Activity360Chatter?id='+recordId;
        
        //"inEditMode" parameter will be passed to URl when "Edit" link is clicked
        String isEdit = Apexpages.currentPage().getParameters().get('inEditMode');
        
        //Decide whether page should be displayed in create mode or detail mode or edit mode
        if(isEdit == 'true'){
            edit();
        }
        if(tstr =='true'){
            isNew = true;
        }else {
            isNew = false;
        }
        
        //Decide whethe its a task or event based on URL parameter
        if(isTask=='true'){
            taskCallNote = true;
            topPageBlockName = CALL_DETAILS;
        }
        String isEvent = Apexpages.currentPage().getParameters().get('event');
        if(isEvent=='true'){
            eventCallNote = true;
            topPageBlockName = MEETING_DETAILS;
        }
        //check if already the parent task or event has been created and we have reached this page clicking already exisiting parent task or event
        if(recordId!=null && !String.isBlank(recordId)){
            showAllRelatedSection = true;
            try{
                callNote = [select id,Name,Not_An_Orphan_Record__c,Additional_Location__c ,Competitive_Information__c,Hot_Button_Issues__c,Other_Notes__c,Past_Relationship__c,Presentation__c,Subject__c,Notes__c,Start_Date_Time__c,End_Date_Time__c,Event_Request__c,Has_RES_Record__c from Activity_Detail__c where Id =:recordId];
            }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() + ex.getLineNumber()));
            }
        }
        
        //Check if the page has just been launched for exisiting record by checking callNote.Not_An_Orphan_Record__c
        if(callNote.Id!=null && callNote.Not_An_Orphan_Record__c)
        {
            try{
                if(taskCallNote)
                {
                    parentTask = [select id,Activity_Detail__c, Parent_Activity_Detail_Id__c, Subject,OwnerId,Owner.Name, Called_Time__c   , ActivityDate,Priority,Status,Description,WhatId,What.Type,what.Name, WhoId, Who.Type,Who.Name,Type,IsReminderSet,ReminderDateTime,
                                  Call_Category__c,Reason_for_Call__c,Method__c,Government_Entity__c,Activity_SubType__c,Activity_Type_for_Instit__c ,Call_Outcome__c,Activity_Category__c,Activity_Type__c,Location__c,
                                  Activity_Sub_Type__c,Client_Engagement__c,Additional_Location__c,Follow_up_Type__c,RecordTypeId ,Meeting_Background__c,Significant_Anticipated_Questions__c,Key_Points_and_Directions_for_Speakers__c,
                                  Inbound_Follow_Up_Created__c from Task where Activity_Detail__c=:callNote.Id LIMIT 1];
                    
                    oRecTypeActivity =  [select id,Name,SobjectType,DeveloperName from RecordType where id = : parentTask.RecordTypeId LIMIT 1]; 
                    //prepopulate the SLDS lookup fields in Log a Call Page
                    whoName = parentTask.who.Name;
                    whatName = parentTask.what.Name;
                    ownerName = parentTask.owner.Name;
                } 
                if(eventCallNote)
                {
                    parentEvent = [select id,Activity_Detail__c,Subject,Description,StartDateTime,EndDateTime,Location,OwnerId,Owner.Name,Type,WhoId,Who.Name,Who.Type,WhatId,What.Name,What.type,
                                   IsAllDayEvent,IsReminderSet,ReminderDateTime,Method__c,Government_Entity__c,Activity_SubType__c,toLabel(Activity_Type_for_Instit__c) ,Notes__c,Activity_Category__c,Activity_Type__c,
                                   Activity_Sub_Type__c,Client_Engagement__c,Location__c,Additional_Location__c,Event_Start_Date__c,Event_End_Date__c,RecordTypeId ,Meeting_Background__c,Significant_Anticipated_Questions__c,Key_Points_and_Directions_for_Speakers__c
                                   from Event where Activity_Detail__c=:callNote.Id LIMIT 1];
                    
                    //Get record type details for event
                    oRecTypeActivity =  [select id,Name,SobjectType,DeveloperName from RecordType where id = : parentEvent.RecordTypeId LIMIT 1];
                    
                    startDateTime = MFS_Activity360GeneralUtility.dateTimeConversion(parentEvent.StartDateTime , true);
                    endDateTime = MFS_Activity360GeneralUtility.dateTimeConversion(parentEvent.EndDateTime , false);
                    //prepopulate the SLDS lookup fields in Create Activity Page
                    ownerName = parentEvent.Owner.Name;
                    whoName = parentEvent.who.Name;
                    whatName = parentEvent.what.Name;
                    if(parentEvent.IsAllDayEvent) { allDayEvent = true; }
                }
            }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
            }
        }
        
        //Check if the page has just been launched and Save button not clicked yet by checking callNote.Not_An_Orphan_Record__c
        else if(callNote.Id!=null && !callNote.Not_An_Orphan_Record__c)
        {
            //If this is a new parent task or event record we are going to create
            disabled = false; 
            parentTask.OwnerId = UserInfo.getUserId();
            parentEvent.OwnerId = UserInfo.getUserId();
            ownerName = userInfo.getName();
            parentTask.Activity_Detail__c = callNote.Id;
            parentEvent.Activity_Detail__c = callNote.Id;
            
            //Set WhoID & WhatID for Activities based on parent object
            if(!(parentObjectType == 'Contact')){
                parentTask.WhatId = parentObjectID;   
                parentEvent.WhatId = parentObjectID;
            }
            else{
                parentTask.WhoId = parentObjectID;   
                parentEvent.WhoId = parentObjectID;
                if(parentObjectType == 'Contact'){
                    //get the whatId
                    List<sObject> sobjList = Database.query('select Accountid from '  + parentObjectType + ' where id = :parentObjectID'); 
                    if(!sobjList.isempty()){
                        parentTask.WhatId = (ID) (sobjList[0].get('Accountid'));
                        parentEvent.WhatId = (ID) (sobjList[0].get('Accountid'));
                    }
                }
            }
            
            //Assign RecordType while creating new Task/Event
            String recType = Apexpages.currentPage().getParameters().get('RecType');
            oRecTypeActivity = MFS_Activity360GeneralUtility.assignActivityRecordType(isTask == 'true', recType);
            if(isTask == 'true')
                parentTask.RecordTypeId = oRecTypeActivity.id;
            else
                parentEvent.RecordTypeId = oRecTypeActivity.id;
            //set Default values 
            parentTask.ActivityDate = System.now().date();
            parentTask.priority = MFS_AllConstants.TASK_PRIORITY_DEFAULT;
            parentTask.Call_Category__c = MFS_AllConstants.TASK_CALLCATEGORY_DEFAULT;
            parentTask.Status = MFS_AllConstants.TASK_STATUS_DEFAULT;
            parentTask.Subject = Label.A360_TASK_SUBJECT_FIELD_DEFAULTVALUE;
            
            if(parentTask.id == NULL && oRecTypeActivity.Name.containsIgnoreCase(INSTITUTIONAL_TYPE) ){
                parentTask.ActivityDate = system.today();
                parentTask.Status = MFS_AllConstants.TASK_STATUS_DEFAULT;
                if(taskCallnote){
                    parentTask.Type = MFS_AllConstants.TASK_TYPE_FIELD_DEFAULTVALUE_INSTITUTIONAL;
                    MFS_Activity360GeneralUtility.dateTimeConversion2(parentTask);
                }
            }
            //Set Default field values for Event
            parentEvent.StartDateTime = datetime.NOW();
            parentEvent.Event_Start_Date__c = system.today();
            parentEvent.Event_End_Date__c = system.today();
            parentEvent.EndDateTime = datetime.NOW().addMinutes(30);
            parentEvent.Type = MFS_AllConstants.EVENT_TYPE_FIELD_DEFAULTVALUE;
            parentEvent.Government_Entity__c = MFS_AllConstants.EVENT_GOVT_ENTITY_DEFAULT;
            
            if(isTask == 'true'){
                parentTask.RecordTypeId = oRecTypeActivity.id;
            }
            else{
                parentEvent.RecordTypeId = oRecTypeActivity.id;
                parentEvent.Method__c = MFS_AllConstants.EVENT_METHOD_FIELD_DEFAULTVALUE;
                
                if(oRecTypeActivity.Name.containsIgnoreCase(INSTITUTIONAL_TYPE)) {
                    parentEvent.Location__c = MFS_AllConstants.EVENT_LOCATION_FIELD_DEFAULTVALUE_OFFSITE;
                    MFS_Activity360GeneralUtility.changeLocation(displayPopup,showEventPopUp,parentEvent,event);
                    parentEvent.Subject = Label.A360_TASK_SUBJECT_FIELD_DEFAULTVALUE_INSTITUTIONAL + MFS_AllConstants.EVENT_METHOD_VALUES.get(parentEvent.Method__c);
                }
                if(oRecTypeActivity.Name.containsIgnoreCase(RETAIL_TYPE)) {
                    parentEvent.Subject = MFS_AllConstants.EVENT_METHOD_VALUES.get(parentEvent.Method__c) + ' ' + '-' + ' ' + MFS_AllConstants.EVENT_TYPE_VALUES.get(parentEvent.Type);
                }
            }
            allDayEvent = false;
            
            //Set What and Who Id Name for Event
            if(eventCallNote){
                if(parentEvent.WhoId!=null && !string.isEmpty(parentEvent.WhoId) ){
                    whoIdObjectName = (String)(parentEvent.WhoId.getSobjectType().getdescribe().getName());
                }
                if(parentEvent.WhatId!=null && !string.isEmpty(parentEvent.WhatId)){
                    whatIdObjectName  = (String)(parentEvent.WhatId.getSobjectType().getdescribe().getName());
                }  
            }
            //Set What and Who Id Name for Task
            if(taskCallNote){
                if(parentTask.WhoId!=null && !string.isEmpty(parentTask.WhoId) ){
                    whoIdObjectName = (String)(parentTask.WhoId.getSobjectType().getdescribe().getName());
                }
                if(parentTask.WhatId!=null && !string.isEmpty(parentTask.WhatId)){
                    whatIdObjectName  = (String)(parentTask.WhatId.getSobjectType().getdescribe().getName());
                }  
            }
            Id tempObjId =(!string.isEmpty(parentTask.whatId) && parentTask.whatId != null) ? parentTask.whatId : parentEvent.whatId;
            List<sObject> tempList;
            if(!string.isEmpty(tempObjId) && tempObjId!=null && whatIdObjectName != 'Case'){
                tempList = Database.query('select Name from '  + whatIdObjectName + ' where id = :tempObjId');
                if(tempList != null && !tempList.isempty()){
                    whatName = (String)(tempList[0].get('Name'));
                }
            }
            
            if(!string.isEmpty(tempObjId) && tempObjId!=null && whatIdObjectName == 'Case'){
                tempList = Database.query('select CaseNumber from '  + whatIdObjectName + ' where id = :tempObjId');
                if(tempList != null && !tempList.isempty()){
                    whatName = (String)(tempList[0].get('CaseNumber'));
                }
            }
            
        }
        remoteActionQueryURL = prepareRemoteActionQueryURL(whatIdObjectName);
        //Build all the related records
        if(callNote.Id!=null){
            goToAttachments();
            goToTask();
            goToCompAnalysisRequest(); 
            goToCompetitorProduct();
            goToProduct();
            goToMMR();
            goToSpeakerRequest();
            createEventRequest();
            
        }
        //The Invitees section should be available for both newly created as well as Existing Activity records
        if(isEvent=='true'){ 
            goToInvitees(); 
        }
    }
    
    //Get all the attachments
    public void goToAttachments(){
        try{
            if(taskCallNote && parentTask.Id!=null)
                attachmentList = new List<Attachment>([select id,name,parentid,BodyLength,LastModifiedDate from Attachment where parentId =:parentTask.Id]);
            if(eventCallNote && parentEvent.Id!=null)
                attachmentList = new List<Attachment>([select id,name,parentid,BodyLength,LastModifiedDate from Attachment where parentId =:parentEvent.Id]);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Get all the followup task records
    public void goToTask(){
        try{
            List<Task> taskList = new List<Task>();
            taskList = MFS_FollowUpTaskUtility.getTaskRecords(callNote.id);
            for(Task tsk:taskList){
                taskWrapperList.add(new MFS_Activity360GeneralUtility.wrapperClass(tsk,false)); 
            }  
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Get all the related competitive analysis records
    public void goToCompAnalysisRequest(){
        try{
            for(Competitive_Analysis_Request__c cp: [select Name, Call_Note__c, Ownerid,Owner.Name, Contact__c, Contact__r.Name, Status__c, Type__c,Description__c,CreatedBy.Name,CreatedDate, Notify__c, Completed_Date__c, Request_completed_in_days__c ,Notes__c ,Request_Report__c from Competitive_Analysis_Request__c where Call_Note__c = :callNote.Id])
            {
                CompAnalysisWrapperList.add(new MFS_Activity360GeneralUtility.wrapperClass(cp,false));
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Get all the related competitor product records
    public void goToCompetitorProduct(){
        try{
            Set<ID> setCompProdID = new Set<ID>();
            for(Call_Note_Competitor_Product__c cProdJN:  [select Competitor_Product__c from Call_Note_Competitor_Product__c where Call_Note__c = : callNote.Id]){
                setCompProdID.add(cProdJN.Competitor_Product__c);
            } 
            if(!setCompProdID.isEmpty()){
                for(Competitor_Product__c cp: [select Name, Firm__c,Firm_Name__c,Is_High_Interest_Product__c from Competitor_Product__c where id in: setCompProdID]) // Firm__r.Name is replaced with Firm_Name__c on 08/Feb/2017 for UAT Defect
                {
                    competitorProdWrapperList.add(new MFS_Activity360GeneralUtility.wrapperClass(cp,false));
                }
            } 
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Get all the related product records
    public void goToProduct(){
        try{
            ProductWrapperList = MFS_ProductActivityUtility.goToProduct(callNote);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Get all the related meeting material request records
    public void goToMMR(){
        try{
            MFS_MeetingMaterialRequestUtility.goToMMR(callNote, MMRWrapperList, portfolioLst, portfolioMap, 'kosko');
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Method to get all the related Speaker Request records
    public void goToSpeakerRequest(){
        try{
            SpeakerWrapperList = MFS_SpeakerRequestUtility.goToSpeakerRequest(callNote.Event_Request__c, SpeakerWrapperList);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Add Selected Competitor Products to Competitor Products Related List in Activity Page
    public void addSelComProduct(){
        try{
            if(!String.isEmpty(selectedComProduct))
            {
                Set<Id> selectedIds1 = new Set<Id>();
                List<String> tempPList = new List<String>(selectedComProduct.split(','));
                for(String s : tempPList)
                {
                    selectedIds1.add((Id)s);
                }
                MFS_CompProductActivityUtility.addingCompetitorProduct(selectedIds1,  competitorProdWrapperList,  callNote);
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Remove competitor product from related list
    public void removingCompetitorProduct()
    {
        try{
            MFS_CompProductActivityUtility.removingCompetitorProduct(individualChildRecordId, oCompProductJN,  competitorProdWrapperList,  callNote);
            oCompProductJN = new Call_Note_Competitor_Product__c();
            individualChildRecordId = null;  
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Add Selected Products to Invitees Section OR Products related list
    public void addSeletedProduct() {
        try{
            if(!String.isEmpty(selectedProduct))
            {
                selectedIds = new Set<Id>();
                List<String> tempPList = new List<String>(selectedProduct.split(','));
                for(String s : tempPList)
                {
                    selectedIds.add((Id)s);
                }
                if(productSearchBtnName == 'SelectInvitee')
                    MFS_EventInviteeUtility.addPortfToInvitee(inviteesMap, invIdForPopup, selectedIds);
                else if(productSearchBtnName == 'MFSPortfolio')
                    MFS_ProductActivityUtility.addingProduct(ProductWrapperList, selectedIds, callNote);
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Method to mark the MFS Product as 'High Interest' Product
    public void highInterestProductCheck(){
        try{
            MFS_ProductActivityUtility.highInterestProductCheck(taskCallNote, parentEvent, parentTask, oRecTypeActivity, taskWrapperList,individualChildRecordId, ProductWrapperList );
            individualChildRecordId = null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }    
    
    //Remove products from activity page
    public void removingProduct()
    {
        try{
            MFS_ProductActivityUtility.removingProduct(individualChildRecordId, ProductWrapperList, oProductJN, callNote );
            oProductJN = new Call_Note_Product__c();
            individualChildRecordId = null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Select competitor product for Comp analysis    
    public void selectCompProductForCA()
    {
        try{
            MFS_CompetitiveAnalysisRequestUtiltiy.selectCompProductForCA( ProductWrapperListForCA, individualChildRecordId,compRequest);
            individualChildRecordId = NULL;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Reset Competitor Product popup search for Competitive Analysis Request
    public void resetCompProdSearchPanelForCA(){
        selectedComProductForCA = '';
        searchComCA = '';
        firmCA = '';
        searchComProductCA();
    }
    
    
    //Add Selected Competitor Products within Competitive Analysis Request popup
    public void addSelComProductForCA(){
        try{
            if(!String.isEmpty(selectedComProductForCA))
            {
                Set<Id> selectedIds = new Set<Id>();
                List<String> tempPList = new List<String>(selectedComProductForCA.split(','));
                for(String s : tempPList)
                {
                    selectedIds.add((Id)s);
                }
                MFS_CompetitiveAnalysisRequestUtiltiy.selectCompProductForCA( ProductWrapperListForCA, individualChildRecordId,compRequest,selectedIds);
                individualChildRecordId = NULL;
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    } 
    //Method to remove the Competitor Product from Competitive Analysis Request   
    public void removeCompProductForCA()
    {
        try{
            MFS_CompetitiveAnalysisRequestUtiltiy.removeCompProductForCA( ProductWrapperListForCA, selectedCompProduct,  individualChildRecordId, compRequest);
            individualChildRecordId = NULL;
            selectedCompProduct = NULL;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Method to delink the Competitor Product bundled under one product       
    public void removingProductForCA()
    {
        try{
            MFS_CompetitiveAnalysisRequestUtiltiy.removingProductForCA( ProductWrapperListForCA,  individualChildRecordId, compRequest);
            individualChildRecordId = NULL;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Method to Save the Competitive Analysis Request and while creating , link the Competitor Products to request 
    public void saveCompAnalysis(){
        Boolean isNewCAR = FALSE;
        
        try{
            if (compRequest.id == NULL){
            isNewCAR  = TRUE;
        	} 
            MFS_CompetitiveAnalysisRequestUtiltiy.saveCompAnalysis( taskCallNote, parentTask, parentEvent,  oRecTypeActivity,  taskWrapperList, callNote, ProductWrapperListForCA, CompAnalysisWrapperList,  compRequest);
            if(isNewCAR){
                
                String account_prefix = Schema.SObjectType.Account.getKeyPrefix();
                ID orgID;
                if(ParentTask.WhatId != null){
                    if(((String)parentTask.WhatID).startsWith(account_prefix)){
                        orgID = parentTask.WhatId;
                    }
                }
                else if(parentEvent.WhatId != null){
                    if(((String)parentEvent.WhatID).startsWith(account_prefix)){
                        orgID = parentEvent.WhatId;
                    }
                } 
                //Post Chatter 
                MFS_CompetitiveAnalysisRequestUtiltiy.postChatterWhenCompRequestCreated(compRequest,orgID, lstSelectedNotifiersForCA);            
            }
            displayPopup = false;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }    
    
    public String prepareRemoteActionQueryURL(String objName)
    {
        String methodName = '';
        if(objName == 'Account')
            methodName = 'Accounts';
        if(objName == 'Opportunity')
            methodName = 'Opportunities';
        if(objName == 'Campaign')
            methodName = 'Campaign';
        if(objName == 'Business_At_Risk__c')
            methodName = 'BAR';
        if(objName == 'Strategy_Plan__c')
            methodName = 'StrategyPlans';
        if(objName == 'Consultant_Rating__c')
            methodName = 'ConsultantRating';
        if(objName == 'Case')
            methodName = 'Cases';
        
        return 'MFS_Activity360Controller.query'+methodName;
    }
    //Opens the page in edit mode
    public void edit(){
        disabled = false;        
        if(eventCallNote && parentEvent.Id!=null && parentEvent.StartDateTime!=null){ startDateTime = MFS_Activity360GeneralUtility.dateTimeConversion(parentEvent.StartDateTime , true); }
        if(eventCallNote && parentEvent.Id!=null && parentEvent.EndDateTime!=null){ endDateTime = MFS_Activity360GeneralUtility.dateTimeConversion(parentEvent.EndDateTime , false); }
        whoName = '';
        whatName = '';
        ownerName = '';
        
        //Set lookup labels for AssignedTo, Name and Related to
        if(parentEvent.Id!=null && eventCallNote){
            if(parentEvent.WhoId!=null && !string.isEmpty(parentEvent.WhoId) ){
                whoIdObjectName = (String)(parentEvent.WhoId.getSobjectType().getdescribe().getName());
                whoName = [select who.Name from Event where id =: parentEvent.Id LIMIT 1].Who.Name;
            }
            if(parentEvent.WhatId!=null && !string.isEmpty(parentEvent.WhatId)){
                whatIdObjectName  = (String)(parentEvent.WhatId.getSobjectType().getdescribe().getName());
                whatName = [select What.Name from Event where id =: parentEvent.Id LIMIT 1].What.Name;
            }
            if(!string.isEmpty(parentEvent.OwnerId) && parentEvent.OwnerId!=null){
                ownerName = [select Owner.Name from Event where id =: parentEvent.Id LIMIT 1].Owner.Name;
            }
        }
        
        if(parentTask.Id!=null && taskCallNote){
            if(parentTask.WhoId!=null && !string.isEmpty(parentTask.WhoId) ){
                whoIdObjectName = (String)(parentTask.WhoId.getSobjectType().getdescribe().getName());
                whoName = [select who.Name from Task where id =: parentTask.Id LIMIT 1].Who.Name;
            }
            if(parentTask.WhatId!=null && !string.isEmpty(parentTask.WhatId)){
                whatIdObjectName  = (String)(parentTask.WhatId.getSobjectType().getdescribe().getName());
                whatName = [select What.Name from Task where id =: parentTask.Id LIMIT 1].What.Name;
            }
            if(!string.isEmpty(parentTask.OwnerId) && parentTask.OwnerId!=null){
                ownerName = [select Owner.Name from Task where id =: parentTask.Id LIMIT 1].Owner.Name;
            }
        }
        if(!String.isEmpty(whatIdObjectName))
            remoteActionQueryURL = prepareRemoteActionQueryURL(whatIdObjectName);
    }
    
    //Cancels the edit mode and make the page go back in detail mode
    public void cancel(){
        disabled = true;
        errorFlag = false;
    }
    
    //Go back to the organization record from where this page was launched
    public PageReference goBack()
    {
        PageReference pf=  new PageReference('/'+parentObjectID);
        return pf;
    }
    
    /*------------------------------- Code for invitee functionality STARTS ------------------------------------------------*/
    
    //Get the invitees for the parent event
    public void goToInvitees(){
        try{
            showEventInviteeSection = true;
            MFS_EventInviteeUtility.goToInvitees(inviteesMap, callNote,showResponseBtn, parentEvent, StartDateTime, endDateTime, lstLeftOption, lstRightOption, mRightSelected, inviteeOrderKeys);
            //show accept/decline buttons only for non speakers
            if((inviteesMap.containsKey(Userinfo.getUserId())&& inviteesMap.get(UserInfo.GetUserId()).evntRel.Host__c == false) &&  (inviteesMap.get(UserInfo.GetUserId()).evntRel.Approval_Status__c == 'New' || inviteesMap.get(UserInfo.GetUserId()).evntRel.Approval_Status__c == 'Approved' || inviteesMap.get(UserInfo.GetUserId()).evntRel.Approval_Status__c == 'Rejected'))
                showResponseBtn=true;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Opens up the invitee pop up for parent event
    public void selectInvitee(){
        showEventInviteePopUp = true;
        isParentEvent = true; 
        selectedInviteesALJSString='';
        searchText = '';
        searchTextOrg='';
        searchTextCity='';
        searchTextCountry='';
        try{
            MFS_EventInviteeUtility.formRightOptionList(inviteesMap,mLeftSelected, mRightSelected, lstRightOption,  lstLeftOption, leftSelectedList, rightSelectedList, parentEvent);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
     public pageReference reset(){
        searchText = '';
        searchTextOrg='';
        searchTextCity='';
        searchTextCountry='';
        if(!String.isEmpty(selectedInviteesALJSString)){
                List<String> tempLst = new List<String>(selectedInviteesALJSString.split(';'));
                Set<String> tempSet = new Set<String>(tempLst);
                
                for(String s : tempLst)
                {
                    if(!mRightSelected.containsKey((Id)s)){
                        mRightSelected.put(s,mLeftSelected.get(s) );
                    }
                }
                lstRightOption.clear();
                for(String s : tempLst)
                {
                    lstRightOption.add(new SelectOption(s, mRightSelected.get(s)));
                }
                for(String s : mRightSelected.keySet())
                {
                    if(!tempSet.contains(s))
                        mRightSelected.remove(s);
                }
            }
            lstLeftOption.clear();
        mLeftSelected.clear();
            if(parentEvent != null && !String.isEmpty(parentEvent.whatId) && parentEvent.whatId.getSobjectType().getDescribe().getName()=='Account'){
            //Load only 1000 contacts in the left side option
            List<Contact> relatedToContacts = new List<Contact>([select id, Name, Account.Name from Contact where accountId = :parentEvent.whatId LIMIT 1000]);
            for(Contact c : relatedToContacts)
            {
                
                if(!mRightSelected.containsKey(c.Id)){
                    mLeftSelected.put(c.id, c.Name +  ' - '+c.Account.Name+' - '+ Label.A360_Contact  );
                    lstLeftOption.add(new SelectOption(c.id, c.Name +  ' - '+c.Account.Name+' - ' + Label.A360_Contact  ));
                }
            } 
        }
        getRightSideInvitees();
            getLeftSideInvitees();
        return NULL;
     }
    //Closes the invitee pop up
    public void closeInviteePopUp(){
        showEventInviteePopUp = false;
        mLeftSelected.clear();
        mRightSelected.clear();
        lstRightOption.clear();
        lstLeftOption.clear();
        leftSelectedList.clear();
        rightSelectedList.clear();
    }
    
    
    //Get the objects which needs to be searched for the invitees
    public List<Selectoption> getInviteeSearchObjects(){
        return MFS_EventInviteeUtility.getInviteeSearchObjects();
        
    }
    
    //Called on click of search button. Searches the invitee based upon the search text
    public void searchInvitee(){
        try{
            if(!String.isEmpty(selectedInviteesALJSString)){
                List<String> tempLst = new List<String>(selectedInviteesALJSString.split(';'));
                Set<String> tempSet = new Set<String>(tempLst);
                
                for(String s : tempLst)
                {
                    if(!mRightSelected.containsKey((Id)s)){
                        mRightSelected.put(s,mLeftSelected.get(s) );
                    }
                }
                lstRightOption.clear();
                for(String s : tempLst)
                {
                    lstRightOption.add(new SelectOption(s, mRightSelected.get(s)));
                }
                for(String s : mRightSelected.keySet())
                {
                    if(!tempSet.contains(s))
                        mRightSelected.remove(s);
                }
            }
            
            MFS_EventInviteeUtility.searchInvitee(parentEvent, SearchText, SearchTextOrg, SearchTextCity,SearchTextCountry, SearchObjects, leftOptionList,mLeftSelected,  lstLeftOption,mRightSelected  );
            getRightSideInvitees();
            getLeftSideInvitees();
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    
    //The invitee list is refreshed, after the invitees are removed/ added from Popup window
    public void addInvitees(){
        
        //Closes the invitee pop up
        showEventInviteePopUp = false;
        try{
            if(!String.isEmpty(selectedInviteesALJSString)){
                List<String> tempLst = new List<String>(selectedInviteesALJSString.split(';'));
                for(String s : tempLst)
                {
                    if(!mRightSelected.containsKey((Id)s)){
                        lstRightOption.add(new SelectOption(s, mLeftSelected.get((Id)s)));
                        mRightSelected.put(s,mLeftSelected.get((Id)s) );
                    }
                    else{
                        lstRightOption.add(new SelectOption(s, mRightSelected.get((Id)s)));
                    }
                }
            }
            MFS_EventInviteeUtility.addInvitees(parentEvent, sExistingRelationIds, lstAllInviteeIDs, inviteesMap, mLeftSelected, mRightSelected,lstRightOption, lstLeftOption, leftSelectedList, rightSelectedList, startDateTime, endDateTime,inviteeOrderKeys);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Add selected portfolios to invitee. User can add multiple portfolios at a time from product search modal
    public void addPortfToInvitee()
    {
        try{
            MFS_EventInviteeUtility.addPortfToInvitee(inviteesMap, inviteeId, selectedIds);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
        
    }
    
    //Remove portfolios from invitee.
    public void removePortfFromInvitee()
    {
        try{
            MFS_EventInviteeUtility.removePortfFromInvitee(inviteesMap, inviteeId, removePfRowNum, callNote, removedInviteePf, portfToBeRemoved);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Change invitee timeslots if parent activity timeslot is changed
    public void changeInviteeTimeSlots(){
        try{
            MFS_EventInviteeUtility.changeInviteeTimeSlots(inviteesMap, parentEvent, startDateTime, endDateTime);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Make the host same as "Assigned To"
    public void changeHostForInvitees()
    {
        try{
            MFS_EventInviteeUtility.changeHostForInvitees(inviteesMap, parentEvent, inviteeOrderKeys, oldAssignedToId);
            oldAssignedToId = parentEvent.OwnerId;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //prepopulate left side of invitee popup with Contacts related to Account
    public void changeLeftOptionList()
    {
        try{
            lstLeftOption.clear();
            if(parentEvent != null && parentEvent.whatId != null && parentEvent.whatId.getSobjectType().getDescribe().getName()=='Account'){
                List<Contact> relatedToContacts = new List<Contact>([select id, Name, Account.Name from Contact where accountId = :parentEvent.whatId]);
                for(Contact c : relatedToContacts)
                {
                    lstLeftOption.add(new SelectOption(c.id, c.Name + ' - '+Account.Name+' - Contact'  ));
                } 
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Sort Invitee Section by Timeslot(only start datetime)
    public void sortInviteesByTime()
    {
        try{
            sortingOrder = MFS_EventInviteeUtility.sortInviteesByTime(inviteesMap, inviteeOrderKeys, columnName, sortingOrder);
            //clear the other column sorting
            sortingOrgOrder = '';
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Sort Invitee Section by Org Name
    public void sortInviteesByOrg()
    {
        try{
            sortingOrgOrder = MFS_EventInviteeUtility.sortInviteesByOrg(inviteesMap, inviteeOrderKeys, columnName, sortingOrgOrder);
            //clear the other column sorting
            sortingOrder = '';
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Accept meeting Invite from home page
    public void acceptInvite()
    {
        try{
            MFS_EventInviteeUtility.acceptInvite(inviteesMap, callNote, parentEvent);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
        
    }
    //Decline meeting invite from home page
    public void declineInvite()
    {
        try{
            MFS_EventInviteeUtility.declineInvite(inviteesMap, callNote, parentEvent);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //get left side Invitees. This is used in Select Attendees popup - SLDS multiselect picklist
    public String getLeftSideInvitees(){
        String jSONString = MFS_EventInviteeUtility.getLeftSideInvitees(lstLeftOption);
        return jSONString;
    }
    
    //get Selected Invitees. This is used in Select Attendees popup - SLDS multiselect picklist
    public String getRightSideInvitees()
    {
        String jSONString = MFS_EventInviteeUtility.getRightSideInvitees(lstRightOption);
        return jSONString;
    }
    
    /*---------------------------------- Code for invitee functionality ENDS -------------------------------------------- */
    /*---------------------------------- The code for the global SAVE button STARTS -----------------------------------------*/ 
    
    // The main Save method. This will save activity/log a call section along with invitee section. Also it will create/link event request to activity
    public void Save(){
        disabled = true;
        errorFlag = false;
        showEventRequestPopup = false;
        tempEventRelation.Speaker_Request__c = NULL;
        if(SpeakerList == NULL){
            SpeakerList = new List<Event_Relation__c>();
        }else{
            SpeakerList.clear();
        }
        boolean newTask = (callNote.Not_An_Orphan_Record__c == false) ? true : false;
        try{
            //if the parent type is TASK
            if(taskCallNote){
                if(oRecTypeActivity.Name.containsIgnoreCase(INSTITUTIONAL_TYPE) || (oRecTypeActivity.Name.containsIgnoreCase(RETAIL_TYPE) &&
                                                                                    (parentTask.Subject!=null && !string.isBlank(parentTask.Subject) && parentTask.OwnerId!=null && parentTask.Status!=null  && 
                                                                                     parentTask.Reason_for_Call__c!=null && !string.isBlank(parentTask.Reason_for_Call__c) && parentTask.Call_Category__c!=null && !string.isBlank(parentTask.Call_Category__c)
                                                                                     && parentTask.Call_Outcome__c!=null && !string.isBlank(parentTask.Call_Outcome__c))))
                {
                    callNote.Subject__c = parentTask.Subject;
                    callNote.Name = parentTask.Subject;
                    if(callNote.Organization__c == null){ 
                        if(parentObjectType == 'Account'){
                            callNote.Organization__c = parentObjectID;
                        }
                    }
                    callNote.Contact__c= (!string.isEmpty(parentTask.WhoId) && parentTask.WhoId!=null && (String)((parentTask.WhoId).getSobjectType().getdescribe().getName()) =='Contact') ? parentTask.WhoId : Null;
                    callNote.Not_An_Orphan_Record__c = true;
                    upsert callNote;
                    
                    //If the Activity detail record has been saved then only do the save operations for the related parent Task record 
                    if(callNote.Id!=null){
                        showAllRelatedSection = true;
                        parentTask.Activity_Detail__c = callNote.Id;
                        
                        //Construct the subject for task
                        if(parentTask.Reason_for_call__c!=null){
                            parentTask.Subject = Label.A360_MAIN_TASK_SUBJECT_START_TEXT + MFS_AllConstants.TASK_REASON_FOR_CALL_VALUES.get(parentTask.Reason_for_call__c);
                        }
                        if(oRecTypeActivity.Name.containsIgnoreCase(RETAIL_TYPE)){
                            changeRetailCallSubject();
                        }
                        //Insert/update parent task
                        upsert parentTask; 
                        
                        string objName = (!string.isEmpty(parentTask.whoId) && parentTask.whoId!=null && parentTask.Id!=null) ? (String)((parentTask.whoId).getSobjectType().getdescribe().getName()) : '';
                        String whoIdLen = (!string.isEmpty(parentTask.whoId) && parentTask.WhoId!=null) ? (String)parentTask.WhoId : '';
                        //Create follow up task for Retail Log a call -- commented on 4/4/2017
                        /*if(newTask && whoIdLen.length() >14 && parentTask.WhoId!=null && oRecTypeActivity.Name.containsIgnoreCase(MFS_AllConstants.RETAIL_RECORDTYPE_SUBTEXT) && parentTask.Id!=null && parentTask.Call_Category__c!=null 
                           && parentTask.Call_Category__c == MFS_AllConstants.TASK_CALLCATEGORY_DEFAULT_INBOUND && objName == 'Contact'){
                               MFS_Activity360GeneralUtility.automaticFollowUpTaskCreate('not CAR',taskCallNote, parentEvent, parentTask, taskWrapperList, parentTask.WhoId,1,MFS_AllConstants.TASK_PRIORITY_DEFAULT);
                               
                           }*/
                        if(!parentTask.Inbound_Follow_Up_Created__c && parentTask.Call_OutCome__c == MFS_AllConstants.TASK_CALLCATEGORY_DEFAULT_INBOUND){
                            Boolean isFollowUpCreated = MFS_Activity360GeneralUtility.automaticFollowUpTaskInbound(parentTask,taskWrapperList);
                            if(isFollowUpCreated){
                                parentTask.Inbound_Follow_Up_Created__c = true;
                                upsert parentTask;
                            }
                                
                        }
                    }
                }
                else{                
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.A360_Required_fields_cannot_be_left_blank));
                    errorFlag = true;
                    disabled = false;
                } 
            }
            
            //if the parent type is EVENT
            if(eventCallNote){
                String sdt = startDateTime == 'None' ? MFS_AllConstants.DEFAULT_ACTIVITY_START_TIME : startDateTime;
                String edt = endDateTime == 'None' ? MFS_AllConstants.DEFAULT_ACTIVITY_END_TIME : endDateTime;
                if(parentEvent.Event_Start_Date__c!=null && startDateTime!=null){
                    parentEvent.StartDateTime = MFS_Activity360GeneralUtility.dateTimeConcat(parentEvent.Event_Start_Date__c,sdt);
                    startDateTime = MFS_Activity360GeneralUtility.dateTimeConversion(parentEvent.StartDateTime , true);
                }
                
                if(parentEvent.Event_End_Date__c!=null && endDateTime!=null){
                    parentEvent.EndDateTime = MFS_Activity360GeneralUtility.dateTimeConcat(parentEvent.Event_End_Date__c,edt);
                    endDateTime = MFS_Activity360GeneralUtility.dateTimeConversion(parentEvent.EndDateTime , false);
                }
                if(parentEvent.StartDateTime > parentEvent.EndDateTime){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.A360_Error_Message_2));
                    errorFlag = true;
                    disabled = false;
                    return;
                }
                if(callNote.Event_Request__c == NULL){
                    //Open Event Request Popup if is not already created.
                    showEventRequestPopup = true;
                    isFollowupTaskForER = true;
                }else{
                    showEventRequestPopup = false;
                }
                //this boolean variable to check the required field which is not common between Retail and Institutional
                boolean requiredFieldNull;
                requiredFieldNull = (oRecTypeActivity.Name != null && oRecTypeActivity.Name.containsIgnoreCase(INSTITUTIONAL_TYPE) && (parentEvent.Location__c==null || string.isEmpty(parentEvent.Location__c))) ? true : false;
                requiredFieldNull = (oRecTypeActivity.Name != null && oRecTypeActivity.Name.containsIgnoreCase(RETAIL_TYPE) && (parentEvent.Type==null || string.isEmpty(parentEvent.Type))) ? true : false;
                
                if(parentEvent.OwnerId!=null && parentEvent.StartDateTime!=null && parentEvent.EndDateTime!=null && parentEvent.Method__c!=null && !requiredFieldNull){
                    callNote.Subject__c = parentEvent.Subject;
                    callNote.Name = parentEvent.Subject;
                    if(callNote.Organization__c == null){
                        if(parentObjectID != NULL && parentObjectType == 'Account'){
                            callNote.Organization__c = parentObjectID;
                        }
                    }
                    callNote.Start_Date_Time__c = parentEvent.StartDateTime;
                    callNote.End_Date_Time__c = parentEvent.endDateTime;
                    callNote.Contact__c= (!string.isEmpty(parentEvent.WhoId) && parentEvent.WhoId!=null && (String)(( parentEvent.WhoId).getSobjectType().getdescribe().getName()) =='Contact') ? parentEvent.WhoId : Null;
                    callNote.Not_An_Orphan_Record__c = true;
                    
                    if(parentEvent.Method__c == MFS_AllConstants.EVENT_METHOD_FIELD_SUBVALUE){ //'Phone Call
                        parentEvent.Activity_Type_for_Instit__c = NULL;
                        parentEvent.Activity_SubType__c = NULL;
                    }
                    upsert callNote;
                    
                    /*If the Activity detail record has been saved then only do the save operations for the parent Event record*/ 
                    if(callNote.Id!=null){
                        showAllRelatedSection = true;
                        parentEvent.Activity_Detail__c = callNote.Id;
                        allDayEvent = (parentEvent.IsAllDayEvent) ? true : false;
                        
                        if(oRecTypeActivity.Name.containsIgnoreCase(RETAIL_TYPE)) {
                            parentEvent.Subject = MFS_AllConstants.EVENT_METHOD_VALUES.get(parentEvent.Method__c) + ' ' + '-' + ' ' + MFS_AllConstants.EVENT_TYPE_VALUES.get(parentEvent.Type);
                        }
                        //Convert picklist labels
                        if(UserInfo.getLanguage() != MFS_AllConstants.USER_DEFAULT_LANGUAGE)
                        {
                            List<String> actTypeForInst = new List<String>();
                            if(!String.isEmpty(parentEvent.Activity_Type_for_Instit__c)){
                                actTypeForInst = parentEvent.Activity_Type_for_Instit__c.split(';');
                                parentEvent.Activity_Type_for_Instit__c = NULL;
                                for(String actType : actTypeForInst){
                                    if(parentEvent.Activity_Type_for_Instit__c == NULL)
                                        parentEvent.Activity_Type_for_Instit__c = MFS_AllConstants.EVENT_ACTIVITY_TYPE_FOR_INST_LABELS.get(actType);
                                    else
                                        parentEvent.Activity_Type_for_Instit__c += ';'+MFS_AllConstants.EVENT_ACTIVITY_TYPE_FOR_INST_LABELS.get(actType);
                                }
                            }
                        }
                        if(!errorFlag){ 
                            upsert parentEvent; 
                            parentEvent = [select id,Activity_Detail__c,Subject,Description,StartDateTime,EndDateTime,Location,OwnerId,Owner.Name,Type,who.type,WhoId,Who.Name,WhatId,What.Name,What.type,
                                           IsAllDayEvent,IsReminderSet,ReminderDateTime,Method__c,Government_Entity__c,Activity_SubType__c,toLabel(Activity_Type_for_Instit__c) ,Notes__c,Activity_Category__c,Activity_Type__c,
                                           Activity_Sub_Type__c,Client_Engagement__c,Location__c,Event_Start_Date__c,Event_End_Date__c,RecordTypeId ,Meeting_Background__c,Significant_Anticipated_Questions__c,Key_Points_and_Directions_for_Speakers__c
                                           from Event where id =: parentEvent.id LIMIT 1];  
                        } 
                    }
                    
                    /******** Save attendee section and create event request(if required)***************/
                    
                    evntRelList = new List<Event_Relation__c>();
                    List<EventRelation> stdEvntRelList = new List<EventRelation>();
                    Set<Id> prodIds= new Set<Id>();
                    List<Event_Relation_Portfolio_Junction__c> eventPortList = new List<Event_Relation_Portfolio_Junction__c>();
                    System.debug('inviteesMap============'+inviteesMap);
                    //Iterate through attendees list and segregate users and contacts
                    for(Id recId : inviteesMap.keySet())
                    {
                        MFS_EventInviteeUtility.InviteeWrapper tempInvitee = inviteesMap.get(recId);
                        if(tempInvitee.evntRel.Activity_Detail__c == null){
                            tempInvitee.evntRel.Activity_Detail__c = callNote.Id;
                        }
                        Id relId = (Id)tempInvitee.evntRel.RelationId__c;
                        if(relId != null && relId.getSobjectType().getDescribe().getName()=='User')
                            tempInvitee.evntRel.Speaker__c = tempInvitee.evntRel.RelationId__c;
                        else
                            tempInvitee.evntRel.Contact__c = tempInvitee.evntRel.RelationId__c;
                        if(relId != null && (relId.getSobjectType().getDescribe().getName()=='Contact' || parentEvent.OwnerId ==recId))
                            tempInvitee.evntRel.Approval_Status__c = MFS_AllConstants.INVITEE_STATUS_APPROVED;
                        // else
                        // tempInvitee.evntRel.Approval_Status__c = MFS_AllConstants.INVITEE_STATUS_NEW;
                        //if Date is not populated inside invitee section make it as default datetime(same as parent datetime)
                        tempInvitee.evntRel.Start_Date__c = tempInvitee.evntRel.Start_Date__c == null ? parentEvent.Event_Start_Date__c : tempInvitee.evntRel.Start_Date__c;
                        tempInvitee.evntRel.End_Date__c = tempInvitee.evntRel.End_Date__c == null ? parentEvent.Event_End_Date__c : tempInvitee.evntRel.End_Date__c;
                        String st = tempInvitee.startTime=='None' ? MFS_AllConstants.DEFAULT_ACTIVITY_START_TIME : tempInvitee.startTime;
                        String et = tempInvitee.endTime=='None' ? MFS_AllConstants.DEFAULT_ACTIVITY_END_TIME : tempInvitee.endTime;
                        tempInvitee.evntRel.Time_Slot_Start__c = MFS_Activity360GeneralUtility.dateTimeConcat(tempInvitee.evntRel.Start_Date__c,st);
                        tempInvitee.evntRel.Time_Slot_End__c = MFS_Activity360GeneralUtility.dateTimeConcat(tempInvitee.evntRel.End_Date__c,et);
                        tempInvitee.evntRel.Org__c = tempInvitee.orgName;
                        evntRelList.add(tempInvitee.evntRel);
                        
                        //add to standard event relation
                        if(parentEvent.OwnerId != recId && tempInvitee.evntRel.Id == null && parentEvent.WhoID != recId &&  relId.getSobjectType().getDescribe().getName()=='User'){
                            EventRelation stdERel = new EventRelation(RelationId = recId, Status=MFS_AllConstants.INVITEE_STATUS_NEW, EventId = parentEvent.Id, isParent = false, isInvitee = true);
                            stdEvntRelList.add(stdERel);
                        }
                        else if(parentEvent.OwnerId != recId && tempInvitee.evntRel.Id == null && parentEvent.WhoID != recId &&  relId.getSobjectType().getDescribe().getName()=='Contact'){
                            //Shared Activities enabled, insert all the contacts with "isParent=true"
                            EventRelation stdERel = new EventRelation(RelationId = recId, Status=MFS_AllConstants.INVITEE_STATUS_NEW, EventId = parentEvent.Id, isParent = true, isInvitee = true); 
                            stdEvntRelList.add(stdERel);
                        }
                    }
                    //Delete all the records from database which are removed from attendee section
                    delete [select Id from Event_Relation__c where relationId__c IN :removedInvitees and Activity_Detail__c = :callNote.Id];
                    //Explicitly delete records from Standard EventRelation because there is no relationship between "Event_Relation__c" & "EventRelation" Objects
                    delete [select Id from EventRelation where relationId IN :removedInvitees and EventId = :parentEvent.Id];
                    delete [select Id from Event_Relation_Portfolio_Junction__c where Id IN :removedInviteePf and Event_Relation__r.Activity_Detail__c = : callNote.Id];
                    
                    upsert evntRelList;
                    insert stdEvntRelList;
                    //Query and assign whoid for event after inserting attendee list.
                    Event tempEvent = [select whoid, Who.Name from Event where id = :parentEvent.Id];
                    if(tempEvent != null)
                    {
                        parentEvent.whoId = tempEvent.whoId;
                        whoName = tempEvent.who.Name;
                    }
                    for(Event_Relation__c evntRel : evntRelList)
                    {
                        MFS_EventInviteeUtility.InviteeWrapper tempInvitee = inviteesMap.get(evntRel.RelationId__c);
                        for(MFS_EventInviteeUtility.EventPortfolioWrapper portf : tempInvitee.evntRelPortLst)
                        {
                            if(portf.evRelPort.Event_Relation__c == null)
                                portf.evRelPort.Event_Relation__c = evntRel.Id;
                            portf.evRelPort.Name = portf.evRelPort.Portfolio__r.Name;
                            eventPortList.add(portf.evRelPort);
                            prodIds.add(portf.evRelPort.Portfolio__c);
                        }
                    }
                    upsert eventPortList;
                    //Remove the portfolios from related list only if it doesn't exist in invitee section. Example: same portfolio is added to 2 invitees. if it gets deleted from one invitee the it should not get removed from related list
                    for(Id prodId : prodIds)
                    {
                        if(portfToBeRemoved.contains(prodId))
                            portfToBeRemoved.remove(prodId);
                    }
                    MFS_ProductActivityUtility.removingProductFromInvitee(ProductWrapperList, portfToBeRemoved, callNote.Id);
                    MFS_ProductActivityUtility.addingProductFromInvitees(ProductWrapperList, prodIds, callNote);
                    removedInvitees.clear();
                    removedInviteePf.clear();
                    
                    placholderEventRequest= new Event_Request__c();
                    Set<ID> speakerIDs = new Set<ID>(); 
                    if(showEventRequestPopup){
                        showEventRequestPopup();
                        popUpInEditMode = true;
                        if(parentEvent.StartDateTime < dateTime.now()){
                            tempEventRelation.Speaker_Request__c = NULL;
                            //Past Event - Add valid speakers from invitee list and show them in Event Request Popup
                            SpeakerList.clear(); 
                            List<ID> erIDs = new List<ID>();
                            for(Event_Relation__c er:evntRelList){
                                //avoid Contacts and Host to add as Speakers
                                if(er.Speaker__c != NULL && !(er.Host__c) ){
                                    erIDs.add(er.Speaker__c);
                                }
                            }
                            
                            //Past Event - Add Speakers only if they are valid Speakers
                            Boolean hasNoSpeaker = true;
                            Map<id,User> mSpeakers = new Map<id,User>([select id from User where id IN: erIDs and Requires_Speaker_Approval__c = true]);
                            for(Event_Relation__c er:evntRelList){
                                if(mSpeakers.containsKey(er.Speaker__c)){
                                    hasNoSpeaker = false;
                                    SpeakerList.add(er);
                                    speakerIDs.add(er.id);
                                }
                            }
                            if(hasNoSpeaker){
                                showEventRequestPopup = false;
                            }                    
                        }
                        else{
                            //If Future Event, create New Event Request with pre populated values
                            placholderEventRequest.Requester__c = parentEvent.OwnerId;
                            placholderEventRequest.Start_Date__c = parentEvent.StartDateTime;
                            placholderEventRequest.End_Date__c = parentEvent.EndDateTime;
                            placholderEventRequest.Event_Start_Date__c = parentEvent.Event_Start_Date__c;
                            placholderEventRequest.Event_End_Date__c = parentEvent.Event_End_Date__c;
                            erStartTime = StartDateTime;
                            erEndTime = endDateTime;
                            if(parentEvent.method__c == MFS_AllConstants.EVENT_METHOD_PHONE_CALL)
                                placholderEventRequest.Method__c = MFS_AllConstants.ER_METHOD_PHONE_CALL;
                            else if(parentEvent.method__c == MFS_AllConstants.EVENT_METHOD_VIDEO_CONFERENCE || parentEvent.method__c == MFS_AllConstants.EVENT_METHOD_WEBINAR)
                                placholderEventRequest.Method__c = MFS_AllConstants.ER_METHOD_VIRTUAL;
                            else
                                placholderEventRequest.Method__c = parentEvent.Method__c;
                            placholderEventRequest.Location__c = parentEvent.Location__c;
                            placholderEventRequest.country__c = MFS_AllConstants.ER_COUNTRY;
                            placholderEventRequest.City__c = MFS_AllConstants.ER_CITY;
                            if(whatIdObjectName == 'Account' && !String.isEmpty(parentEvent.WhatId) && parentEvent.WhatId.getSobjectType().getdescribe().getName() == 'Account'){
                                placholderEventRequest.Organization__c = parentEvent.WhatId;
                                //prepopulate event request lookup field
                                Account acc = [select Name from Account where id=:parentEvent.WhatId];
                                srOrgName = acc.Name;
                            }
                            placholderEventRequest.Event_Title__c = parentEvent.Subject;
                            placholderEventRequest.Contact__c = parentEvent.WhoId;
                            
                            //get the picklist values for Event Type
                            Schema.Describefieldresult fieldResult = Schema.sObjectType.Event_Request__c.fields.Event_Types__c;
                            fieldResult = fieldResult.getSObjectField().getDescribe();
                            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                            Set<String> valuesFromSchema = new Set<String>();
                            for( Schema.PicklistEntry f : ple){
                                valuesFromSchema.add(f.getLabel());
                            }
                            
                            String options = '';
                            if(oRecTypeActivity.Name.containsIgnoreCase(INSTITUTIONAL_TYPE)){
                                Boolean hasMatchingPicklist = false;
                                
                                if(parentEvent.Activity_Type_for_Instit__c != NULL && parentEvent.Activity_Type_for_Instit__c != '' ){
                                    for(String actType: parentEvent.Activity_Type_for_Instit__c.split(';')){
                                        if(actType != NULL && actType != ''){
                                            if(valuesFromSchema.contains(actType)){
                                                hasMatchingPicklist = true;
                                                options +=actType + ';'; 
                                            }
                                        }
                                    }
                                    if(!hasMatchingPicklist){
                                        options = MFS_AllConstants.ER_EVENT_TYPE_OTHER;
                                    }
                                }else{
                                    options = MFS_AllConstants.ER_EVENT_TYPE_OTHER;
                                }
                            }
                            else{
                                if(parentEvent.Type != NULL && parentEvent.Type != ''){
                                    if(valuesFromSchema.contains(parentEvent.Type)){
                                        options =parentEvent.Type; 
                                    }else{
                                        options = MFS_AllConstants.ER_EVENT_TYPE_OTHER;
                                    }
                                }
                                else{
                                    options = MFS_AllConstants.ER_EVENT_TYPE_OTHER;
                                }
                            }
                            placholderEventRequest.Event_Types__c = options;
                            
                            getSelectedEventType();
                            if(!String.isempty(parentEvent.WhoId))
                            {
                                //prepopulate event request lookup field. this needs to be optimized
                                Contact c =[select Name from contact where id=:parentEvent.whoId];
                                srContName = c.Name;
                            }
                            placholderEventRequest.Overall_Approval_Status__c = MFS_AllConstants.ER_APPROVAL_STATUS_DEFAULT;
                            placholderEventRequest.Dress_Code__c = MFS_AllConstants.ER_DRESS_CODE_DEFAULT;
                            
                            //Add valid speakers from invitee list and show them in Event Request Popup 
                            SpeakerList.clear(); 
                            List<ID> erIDs = new List<ID>();
                            for(Event_Relation__c er:evntRelList){
                                //avoid Contacts and Host to add as Speakers
                                if(er.Speaker__c != NULL && !(er.Host__c) ){
                                    erIDs.add(er.Speaker__c);
                                }
                            }
                            
                            //Add Speakers only if they are valid Speakers(if MFS_AllConstants checkbix is selected in user page)
                            Boolean hasNoSpeaker = true;
                            Map<id,User> mSpeakers = new Map<id,User>([select id from User where id IN: erIDs and Requires_Speaker_Approval__c = true]);
                            
                            for(Event_Relation__c er:evntRelList){
                                if(mSpeakers.containsKey(er.Speaker__c)){
                                    hasNoSpeaker = false;
                                    SpeakerList.add(er);
                                    speakerIDs.add(er.id);
                                }
                            }
                            if(hasNoSpeaker){
                                showEventRequestPopup = false;
                            }
                            else{
                                showEventRequestPopup = true;
                                insert placholderEventRequest;
                                //reform speaker request section in main page
                                callNote.Event_Request__c = placholderEventRequest.id;
                                update callNote;                    
                                goToSpeakerRequest(); 
                                for(Event_Relation__c speaker:SpeakerList ){
                                    speaker.Speaker_Request__c = placholderEventRequest.id;
                                }
                            }
                            //Update speakers with Event Request lookup
                            update SpeakerList;
                            
                            //Entry criteria for Submit for Approval - Submit for approval only if Requestor's Business is Retail/Institutional and  Requestor has Speaker Approval role
                            for(User requestor:[select id,Business__c,Speaker_Request_Approval__c from User where id =: placholderEventRequest.Requester__c LIMIT 1]){
                                if(requestor.Business__c != NULL && requestor.Speaker_Request_Approval__c != NULL){
                                    //Submit for Approval
                                    List<Approval.ProcessSubmitRequest> appReqList=new List<Approval.ProcessSubmitRequest>();
                                    for(Event_Relation__c sp:SpeakerList){
                                        Approval.ProcessSubmitRequest appReq=new Approval.ProcessSubmitRequest();
                                        appReq.setObjectId(sp.id);
                                        appReqList.add(appReq);
                                    }
                                    
                                    if(!appReqList.isempty()){
                                        Approval.ProcessResult[] appResults=Approval.process(appReqList);
                                    }                            
                                }
                            }
                        }
                        
                        // reform the speaker list
                        SpeakerList.clear();
                        for(Event_Relation__c sp: [select Id, RelationId__c, Activity_Detail__c, Invitee_Type__c, Name__c, Org__c, Approval_Status__c,
                                                   Time_Slot_Start__c, Start_Date__c, Time_Slot_End__c, End_Date__c, Topic__c, Host__c ,Speaker__c,Speaker__r.Name
                                                   from Event_Relation__c where id IN : speakerIDs ORDER BY Name__c ASC])
                        {
                            SpeakerList.add(sp);
                            //update the wrapper for invitee section
                            MFS_EventInviteeUtility.InviteeWrapper tempInvitee = inviteesMap.get(sp.RelationId__c);
                            tempInvitee.evntRel.Speaker_Request__c = placholderEventRequest.id;
                            tempInvitee.evntRel.Approval_Status__c = sp.Approval_Status__c;
                        }    
                    }
                    else{
                        List<ID> erIDs = new List<ID>();
                        for(Event_Relation__c er:evntRelList){
                            //skip Contacts, Host and existing Speakers while adding
                            if(er.Speaker__c != NULL && !(er.Host__c) && er.Speaker_Request__c == NULL){
                                erIDs.add(er.Speaker__c);
                            }
                        }
                        
                        if(erIDs.size() > 0){
                            //Add Speakers only if they are valid Speakers(if MFS_AllConstants checkbix is selected in user page)
                            Boolean hasNoSpeaker = true;
                            Map<id,User> mSpeakers = new Map<id,User>([select id from User where id IN: erIDs and Requires_Speaker_Approval__c = true]);
                            SpeakerList.clear();
                            for(Event_Relation__c er:evntRelList){
                                if(mSpeakers.containsKey(er.Speaker__c)){
                                    hasNoSpeaker = false;
                                    SpeakerList.add(er);
                                    speakerIds.add(er.Id);
                                }
                            }
                            for(Event_Relation__c speaker:SpeakerList ){
                                speaker.Speaker_Request__c = callNote.Event_Request__c;
                            }
                            
                            update SpeakerList;
                            Event_Request__c eRequest = [select Requester__c from Event_Request__c where id = :callNote.Event_request__c LIMIT 1];
                            if(eRequest != null && eRequest.Requester__c != null){
                                for(User requestor:[select id,Business__c,Speaker_Request_Approval__c from User where id =: eRequest.Requester__c LIMIT 1]){
                                    if(requestor.Business__c != NULL && requestor.Speaker_Request_Approval__c != NULL){
                                        //Submit for Approval
                                        List<Approval.ProcessSubmitRequest> appReqList=new List<Approval.ProcessSubmitRequest>();
                                        for(Event_Relation__c sp:SpeakerList){
                                            Approval.ProcessSubmitRequest appReq=new Approval.ProcessSubmitRequest();
                                            appReq.setObjectId(sp.id);
                                            appReqList.add(appReq);
                                        }
                                        
                                        if(!appReqList.isempty()){
                                            Approval.ProcessResult[] appResults=Approval.process(appReqList);
                                        }                            
                                    }
                                }
                            }
                            for(Event_Relation__c sp: [select Id, RelationId__c, Approval_Status__c, Speaker_Request__c from Event_Relation__c where id IN : speakerIDs])
                            {
                                //update the wrapper for invitee section
                                MFS_EventInviteeUtility.InviteeWrapper tempInvitee = inviteesMap.get(sp.RelationId__c);
                                tempInvitee.evntRel.Speaker_Request__c = sp.Speaker_Request__c;
                                tempInvitee.evntRel.Approval_Status__c = sp.Approval_Status__c;
                            }
                        }
                        //Check the event request, if there are no speakers associated then delete it.
                        else{
                            Integer erCount = [select count() from Event_Relation__c where Speaker_Request__c = :callNote.Event_Request__c ];
                            if(erCount == 0)
                                delete [select id from Event_Request__c where id = :callNote.Event_Request__c];
                            SpeakerWrapperList.clear();
                            callNote.Event_Request__c = null;
                        }
                    }
                    
                    /***********************Attendee and Event request logic ends***************************************/
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.A360_Required_fields_cannot_be_left_blank));
                    errorFlag = true;
                    disabled = false;
                }
            }
        }catch(Exception ex){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    /*---------------------------------- The code for the global SAVE button ENDS -----------------------------------------*/ 
    
    /* ---------------------------------------- Code related to Pop Up window STARTS ---------------------------------------- */
    //Opens up the Pop Up window and display the Meeting Preparation section
    public void showMeetingPrepPopup(){
        
        
        if((callNote.Competitive_Information__c == NULL || callNote.Competitive_Information__c == '' ) &&
           (callNote.Hot_Button_Issues__c == NULL || callNote.Hot_Button_Issues__c == '' ) &&
           (callNote.Other_Notes__c == NULL || callNote.Other_Notes__c == '' ) &&
           (callNote.Past_Relationship__c == NULL || callNote.Past_Relationship__c == '' ) &&
           (callNote.Presentation__c == NULL || callNote.Presentation__c == '' ) &&
           (callNote.Additional_Location__c == NULL || callNote.Additional_Location__c == '' )
          ){
              popUpInEditMode = true;
              showSaveBtnOnPopUp = true;
              if(oRecTypeActivity.Name.containsIgnoreCase(INSTITUTIONAL_TYPE) &&
                 (callNote.Additional_Location__c == NULL || callNote.Additional_Location__c == '' )
                ){
                    callNote.Additional_Location__c = parentEvent.Location;
                    //system.debug
                }
          }else{
              popUpInEditMode = false;
              showSaveBtnOnPopUp = false;
          }
    }
    
    //save the Meeting Preparation field values
    public void updateMeetingPrep(){
        MFS_MeetingPreparationUtility.updateMeetingPreparation(callNote);
        showSaveBtnOnPopUp = false;
    }
    
    //Closes the pop up window. Common for all pop up windows across all related lists 
    public void closePopup(){        
        allPopUpCommonProperties(false,false,false,false,false,false,false);
    }  
    
    //All pop ups common code 
    public void allPopUpCommonProperties(boolean displayPopup1,boolean showTaskPopUp1,boolean showEventPopUp1,boolean showCompAnalysisPopUp1,boolean showSpeakerRequestPopUp1,boolean showMMRPopUp1,boolean showEventRequestPopup1){
        displayPopup = displayPopup1;
        showTaskPopUp = showTaskPopUp1;
        showEventPopUp = showEventPopUp1;
        showCompAnalysisPopUp = showCompAnalysisPopUp1;
        showSpeakerRequestPopUp = showSpeakerRequestPopUp1;
        showMMRPopUp = showMMRPopUp1;
        showEventRequestPopup = showEventRequestPopup1;
    }
    
    //Opens up the Pop Up window and display the TASK section of pop up window
    public void showTaskPopup(){
        try{
            errorFlag = false;
            allPopUpCommonProperties(true,true,false,false,false,false,false);        
            task = MFS_FollowUpTaskUtility.showTaskPopUp(taskCallNote,UserInfo.getUserId(),individualChildRecordId,parentTask,parentEvent,task,taskWrapperList);
            if(String.isEmpty(task.WhoId)){
                task.WhoId = (taskCallNote) ? ((!string.isEmpty(parentTask.WhoId) && parentTask.WhoId!=null) ? parentTask.WhoId : null) : ((!string.isEmpty(parentEvent.WhoId) && parentEvent.WhoId!=null) ? parentEvent.WhoId : null);
                    }
            if(!string.isEmpty(task.WhoId)){
                followUpTaskWhoIdName = [select id, Name from Contact where Id = :task.WhoId LIMIT 1][0].Name;
            }
            if(isFollowupTaskForER){
                task.Subject = Label.A360_TASK_SUBJECT_DEFAULT;
            }
            if(task.ReminderDateTime != null)
                reminderTime= MFS_Activity360GeneralUtility.dateTimeConversion(task.ReminderDateTime , false);
            
            popUpInEditMode = showSaveBtnOnPopUp = (task.Id == null) ? true : false;
            individualChildRecordId = null; 
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Saves the follow up task record
    public void saveFollowUpTask(){
        try{
            taskWrapperList = MFS_FollowUpTaskUtility.saveFollowUpTask(callNote.id,task,callNote,taskWrapperList,reminderTime);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Deletes the selected follow up tasks and/or events. Does not open any pop window
    public void deleteFollowUpTaskEvent(){
        try{
            taskWrapperList = MFS_FollowUpTaskUtility.deleteFollowUpTaskEvent(individualChildRecordId, taskWrapperList);
            individualChildRecordId = null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Opens up the Pop Up window and display the Competitive Analysis section
    public void showCompAnalysisPopup(){ 
        try{
            errorFlag = false;
            allPopUpCommonProperties(true,false,false,true,false,false, false);
            ProductWrapperListForCA.clear();
            CompProductWrapperListForCA.clear();
            //Viewing existing Competitive Analysis Request
            if(individualChildRecordId!=null && !string.isBlank(individualChildRecordId)) {
                popUpInEditMode = false;
                showSaveBtnOnPopUp = false;
                
                for(MFS_Activity360GeneralUtility.wrapperClass wc : CompAnalysisWrapperList){
                    if(wc.wCompAnalysisRequest.Id==individualChildRecordId){ 
                        compRequest = wc.wCompAnalysisRequest; 
                        MFS_CompetitiveAnalysisRequestUtiltiy.loadCompProductsToCARWrapper( compRequest,ProductWrapperListForCA);
                    }
                }
            }
            
            //Creating new Competitive Analysis Request
            if(individualChildRecordId==null && string.isBlank(individualChildRecordId)){
                popUpInEditMode = true;
                showSaveBtnOnPopUp = true;
                //isCARcreateClicked = true;
                compRequest = new Competitive_Analysis_Request__c();
                compRequest.Request_Report__c = TRUE;
                compRequest.Status__c = MFS_AllConstants.COMP_ANANLYSIS_DEFAULT_STATUS;
                if(!oRecTypeActivity.Name.contains(INSTITUTIONAL_TYPE)){
                    for(QueueSObject que: [select id, QueueId, Queue.Name, SObjectType from QueueSObject 
                                           where SObjectType=:  MFS_AllConstants.SOBJECT_NAME_FOR_COMPETITIVE_ANALYSIS_REQUEST and Queue.Name = :System.Label.A360_Queue_for_Competitive_Analysis_Request]){
                                               compRequest.Ownerid = que.QueueId;             
                                           }
                    
                }
                if(taskCallNote){
                    compRequest.Contact__c = parentTask.WhoId;
                }
                else{
                    compRequest.Contact__c = parentEvent.WhoId;
                }
                
                String account_prefix = Schema.SObjectType.Account.getKeyPrefix();
                ID orgID;
                if(ParentTask.WhatId != null)
                {
                    if(((String)parentTask.WhatID).startsWith(account_prefix)){
                        orgID = parentTask.WhatId;
                    }
                }
                else if(parentEvent.WhatId != null)
                {
                    if(((String)parentEvent.WhatID).startsWith(account_prefix)){
                        orgID = parentEvent.WhatId;
                    }
                } 
                if(lstAvailableCompRequestNotifiers == NULL){
                    lstAvailableCompRequestNotifiers = new List<selectOption>();
                }else{
                    lstAvailableCompRequestNotifiers.clear();
                }
                if(lstSelectedNotifiersForCA == NULL){
                    lstSelectedNotifiersForCA = new List<String>();
                }else{
                    lstSelectedNotifiersForCA.clear();
                }
                //When creating new CA request, relate the products associated to Activity to CAR
                Boolean flag = false;
                for(MFS_Activity360GeneralUtility.wrapperClass pwl: ProductWrapperList){
                    List<Competitor_Product__c> lstCompProd = new List<Competitor_Product__c>(); 
                    MFS_Activity360GeneralUtility.WrapperClass wtemp = new MFS_Activity360GeneralUtility.WrapperClass();
                    Competitive_Analysis_Product__c cap = new Competitive_Analysis_Product__c();                
                    wtemp.wCompAnalysisProdJn = new Competitive_Analysis_Product__c();
                    wtemp.wProduct = pwl.wProduct;
                    wtemp.wActivityProdJuncObj = pwl.wActivityProdJuncObj;
                    ProductWrapperListForCA.add(wtemp);
                }
                if(compRequest.Contact__c != NULL || orgID != NULL){
                    MFS_CompetitiveAnalysisRequestUtiltiy.initializeNotifierMultiSelection(orgID,compRequest.Contact__c, lstAvailableCompRequestNotifiers, lstSelectedNotifiersForCA);
                    jsonAvailableNotifiersForCA = MFS_CompetitiveAnalysisRequestUtiltiy.formJsonWithAvailableNotifiers( lstAvailableCompRequestNotifiers,lstSelectedNotifiersForCA);
                    jsonSelectedNotifiersForCA = MFS_CompetitiveAnalysisRequestUtiltiy.formJsonWithSelectedNotifiers( lstAvailableCompRequestNotifiers,  lstSelectedNotifiersForCA );
                }
                
                
                
            } 
            individualChildRecordId = null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Change competitive analysis request type
    public void changeTypeOfCompAnalysis(){
        try{
            MFS_CompetitiveAnalysisRequestUtiltiy.changeTypeOfCompAnalysis(compRequest);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Do an action when "request report " checkbox is checked from Comp Analysis
    public void checkRequestCompAnalysis(){
        try{
            MFS_CompetitiveAnalysisRequestUtiltiy.checkRequestCompAnalysis(compRequest);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }    
    
    //Method to delte the Competitive Analysis Request related to Activity
    public void deleteCompAnalysisRecord(){
        try{
            MFS_CompetitiveAnalysisRequestUtiltiy.deleteCompAnalysisRecord(individualChildRecordId, CompAnalysisWrapperList );
            individualChildRecordId = null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Deletes the speaker request records from the related list. All the selected records are deleted. Does not open any pop window
    public void deleteSpeakerRequestRecord(){        
        try{
            MFS_SpeakerRequestUtility.deleteSpeakerRequestRecord(individualChildRecordId, SpeakerWrapperList, callNote);
            individualChildRecordId = null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Opens up the Pop Up window and display the MMR section
    public void showMMRPopup(){ 
        errorFlag = false;
        allPopUpCommonProperties(true,false,false,false,false,true,false);
        editMMROrgName = false;
        //try{
            if(individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                popUpInEditMode = false;
                showSaveBtnOnPopUp = false;
                for(MFS_Activity360GeneralUtility.wrapperClass wc : MMRWrapperList){
                    if(wc.wMMR.Id==individualChildRecordId)
                    { 
                        MMR = wc.wMMR;
                        MFS_MeetingMaterialRequestUtility.constructMMRRelatedList(MMR,languageFields,PortfolioMap,MMRPortfolioWrapperList);
                    }
                }
            }
            if(string.isEmpty(individualChildRecordId) || string.isBlank(individualChildRecordId)){
                popUpInEditMode = true;
                showSaveBtnOnPopUp = true;
                editMMROrgName = true;
                
                MMR = new Meeting_Material_Request__c();
                MFS_MeetingMaterialRequestUtility.showMMRPopup(MMR, MMRPortfolioWrapperList,ProductWrapperList, parentEvent,editMMROrgName, startDateTime, endDateTime, languageFields, inviteesMap, 'Kosko');
            	MMR.Status__c = 'Requested';
            } 
            individualChildRecordId = null; 
       // }catch(Exception ex){
        //    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        //}
    }
    
    //Method to save the Meeting Material Request
    public void saveMMR(){
        try{
            MFS_MeetingMaterialRequestUtility.saveMMR(MMR, MMRWrapperList, portfolioMap, MMRPortfolioWrapperList, callNote, portfolioLst, portfolioSetToRemove, languageFields, 'Kosko');
            displayPopup = false;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Method to remove the Meeting Material Request.
    public void deleteMMRRecord(){
        try{
            MFS_MeetingMaterialRequestUtility.deleteMMRRecord(individualChildRecordId, MMRWrapperList, callNote, showAllRelatedSection);
            individualChildRecordId = null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
        
    }
    
    //Makes the follow up record in the pop up window to go into edit mode. Common across all related lists
    public void editFollowUpRecord(){
        try{
            popUpInEditMode = true;
            showSaveBtnOnPopUp = true;
            
            if(task!=null && task.Id!=null && task.WhoId!=null && !string.isEmpty(task.WhoId)){
                whoIdObjectName = (String)(task.WhoId.getSobjectType().getdescribe().getName());
                followUpTaskWhoIdName = [select id, Name from Contact where Id =:task.WhoId LIMIT 1][0].Name;
            }
            
            if(task!=null && task.Id!=null && task.WhatId!=null && !string.isEmpty(task.WhatId)){
                whatIdObjectName  = (String)(task.WhatId.getSobjectType().getdescribe().getName());
                if(whatIdObjectName == 'Account'){ followUpTaskWhatIdName = task.What.Name; }
                if(whatIdObjectName == 'Opportunity'){ followUpTaskWhatIdName = task.What.Name; } 
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Makes the follow up record in the pop up window to go back into detail mode. Common across all related lists
    public void cancelFollowUpRecord(){
        popUpInEditMode = false;
        showSaveBtnOnPopUp = false;
    }
    
    //Enable the edit for the selected follow up task record from the related list. Opens up the pop window for the selected record for editing.
    public void editFollowUpTaskRecord(){
        displayPopup = true;
        showSaveBtnOnPopUp = true;
        popUpInEditMode = true;        
        try{
            if(taskWrapperList.size()>0 && individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                for(MFS_Activity360GeneralUtility.wrapperClass tw:taskWrapperList){
                    if(tw.wTask.Id == individualChildRecordId){
                        task = tw.wTask;
                        showTaskPopUp = true;
                        showEventPopUp = false;
                        showCompAnalysisPopUp =  false;
                        showSpeakerRequestPopUp = false;
                    }
                } 
                if(task!=null && task.Id!=null && !string.isEmpty(task.WhoId) && task.WhoId!=null){
                    whoIdObjectName = (String)(task.WhoId.getSobjectType().getdescribe().getName());
                    if(whoIdObjectName == 'Contact'){ followUpTaskWhoIdName = [select id, Name from Contact where Id =:task.WhoId LIMIT 1][0].Name; }
                }
                if(task!=null && task.Id!=null && !string.isEmpty(task.WhatId) && task.WhatId!=null){
                    whatIdObjectName  = (String)(task.WhatId.getSobjectType().getdescribe().getName());
                    if(whatIdObjectName == 'Account'){ followUpTaskWhatIdName  = [select id, Name from Account where Id =:task.WhatId LIMIT 1][0].Name; }
                    if(whatIdObjectName == 'Opportunity'){ followUpTaskWhatIdName  = [select id, Name from Opportunity where Id =:task.WhatId LIMIT 1][0].Name; }
                }
            }
            individualChildRecordId = null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Enable the edit for the selected competitive analysis record from the related list. Opens up the pop window for the selected record for editing.
    public void editCompetitiveAnalysisRecord(){
        displayPopup = true;
        showSaveBtnOnPopUp = true;
        popUpInEditMode = true;
        try{
            if(CompAnalysisWrapperList.size()>0 && individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                for(MFS_Activity360GeneralUtility.wrapperClass ca:CompAnalysisWrapperList){
                    if(ca.wCompAnalysisRequest.Id == individualChildRecordId){
                        compRequest = ca.wCompAnalysisRequest;
                        showTaskPopUp = false;
                        showEventPopUp = false;
                        showCompAnalysisPopUp = true;
                        showSpeakerRequestPopUp = false;
                        ProductWrapperListForCA.clear();
                        MFS_CompetitiveAnalysisRequestUtiltiy.loadCompProductsToCARWrapper( compRequest,ProductWrapperListForCA); 
                    }
                }
            }
            individualChildRecordId = null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Enable the edit for the selected MMR record from the related list. Opens up the pop window for the selected record for editing.
    public void editMMRRecord(){
        displayPopup = true;
        showSaveBtnOnPopUp = true;
        popUpInEditMode = true;
        try{
            if(MMRWrapperList.size()>0 && individualChildRecordId!=null && !string.isBlank(individualChildRecordId) && showAllRelatedSection){
                for(MFS_Activity360GeneralUtility.wrapperClass mw:MMRWrapperList){
                    if(mw.wMMR.Id == individualChildRecordId){
                        MMR = mw.wMMR;
                        constructMMRRelatedList();
                        showTaskPopUp = false;
                        showEventPopUp = false;
                        showCompAnalysisPopUp = false;
                        showMMRPopUp = true;
                        showSpeakerRequestPopUp = false;
                        editMMROrgName = false;
                        showEventRequestPopup = false;
                    }
                }
            }
            individualChildRecordId = null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Display Event Request modal
    public void showEventRequestPopup(){ 
        allPopUpCommonProperties(true,false,false,false,false,false, true);
    }
    
    //Remove the invitee from page, when 'Remove' hyperlink is clicked
    public void removeInvitee(){
        try{
            MFS_EventInviteeUtility.removeInvitee(inviteesMap, removeInviteeId, lstAllInviteeIDs, rightOptionMap, removedInvitees, inviteeOrderKeys );
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Change the Task subject when Reason for Call is changed in UI
    public void changeActivitySubject(){
        try{
            parentTask.Subject = Label.A360_TASK_SUBJECT_FIELD_DEFAULTVALUE + MFS_AllConstants.TASK_REASON_FOR_CALL_VALUES.get(parentTask.Reason_for_call__c);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    public void changeRetailCallSubject(){
        try{
            parentTask.subject = (String.IsEmpty(ParentTask.Call_Outcome__c)) ? '' : MFS_AllConstants.TASK_CALL_OUTCOME_VALUES.get(ParentTask.Call_Outcome__c) +' - ';
            parentTask.subject += Label.A360_TASK_SUBJECT_FIELD_DEFAULTVALUE;
            parentTask.subject +=  (String.IsEmpty(ParentTask.Reason_For_Call__c)) ? '' :' '+ MFS_AllConstants.TASK_REASON_FOR_CALL_VALUES.get(ParentTask.Reason_For_Call__c);                  
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }       
    }
    
    //Change the method for activity
    public void changingEventMethod(){
        try{
            changeEventSubject();
            if(oRecTypeActivity.Name.containsIgnoreCase(INSTITUTIONAL_TYPE)) {
                disableDateTime();            
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Change  name of the event
    public void changingEventWhoId(){
        try{
            changeEventSubject();
            if(oRecTypeActivity.Name != NULL && oRecTypeActivity.Name.containsIgnoreCase(INSTITUTIONAL_TYPE)) {
                MFS_Activity360GeneralUtility.changeLocation(displayPopup,showEventPopUp,parentEvent,event);
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Change location of the event when contact is changed
    public void changeLocation(){
        try{
            MFS_Activity360GeneralUtility.changeLocation(displayPopup,showEventPopUp,parentEvent,event); 
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Change the Event subject when Event Type is changed in UI
    //When Who.Name and Event Type are selected, Display subject in this format: Who.Name - Event.Type
    public void changeEventSubject(){
        
        if(oRecTypeActivity.Name == NULL || oRecTypeActivity.Name.containsIgnoreCase(RETAIL_TYPE)) {
            parentEvent.Subject = MFS_AllConstants.EVENT_METHOD_VALUES.get(parentEvent.Method__c) + ' ' + '-' + ' ' + MFS_AllConstants.EVENT_TYPE_VALUES.get(parentEvent.Type);
        }
        else{
            parentEvent.Subject = Label.A360_TASK_SUBJECT_FIELD_DEFAULTVALUE_INSTITUTIONAL + MFS_AllConstants.EVENT_METHOD_VALUES.get(parentEvent.Method__c); 
        } 
    }    
    
    //Prepare dropdown for Time picklist
    public SelectOption[] getTimeList() 
    {   
        SelectOption[] options = new SelectOption[]{};
            String mins = '30';
        String am = 'AM';
        String pm = 'PM';
        if(!callNote.Not_An_Orphan_Record__c && eventCallNote){
            options.add(new SelectOption('None', 'None'));
        }
        for(Integer i=0; i < 12; i++){
            for(Integer j=0; j < 2; j++){
                mins = (mins == '30') ? '00' : '30';
                Integer hrs;
                if(i==0){ hrs = 12;}
                else { hrs = i; }
                
                String key = hrs + ':' + mins +' '+ am;
                options.add(new SelectOption(key, key));
            }
        }
        
        for(Integer i=0; i < 12; i++){
            for(Integer j=0; j < 2; j++){
                mins = (mins == '30') ? '00' : '30';
                Integer hrs;
                if(i==0){ hrs = 12;}
                else { hrs = i; }
                
                String key = hrs + ':' + mins +' '+ pm;
                options.add(new SelectOption(key, key));
            }
        }
        
        return options;  
    }
    
    //Prepare timelist for invitees
    public SelectOption[] getInviteeTimeList() 
    {   
        SelectOption[] options = new SelectOption[]{};
            String mins = '30';
        String am = 'AM';
        String pm = 'PM';
        if(String.isEmpty(startDateTime) || startDateTime == 'None'){
            options.add(new SelectOption('None', 'None'));
        }
        for(Integer i=0; i < 12; i++){
            for(Integer j=0; j < 2; j++){
                mins = (mins == '30') ? '00' : '30';
                Integer hrs;
                if(i==0){ hrs = 12;}
                else { hrs = i; }
                
                String key = hrs + ':' + mins +' '+ am;
                options.add(new SelectOption(key, key));
            }
        }
        
        for(Integer i=0; i < 12; i++){
            for(Integer j=0; j < 2; j++){
                mins = (mins == '30') ? '00' : '30';
                Integer hrs;
                if(i==0){ hrs = 12;}
                else { hrs = i; }
                
                String key = hrs + ':' + mins +' '+ pm;
                options.add(new SelectOption(key, key));
            }
        }
        
        return options;  
    }
    
    //Prepare timeList for FollowUp
    public SelectOption[] getfollowUpTimeList() 
    {   
        SelectOption[] options = new SelectOption[]{};
            String mins = '30';
        String am = 'AM';
        String pm = 'PM';
        for(Integer i=0; i < 12; i++){
            for(Integer j=0; j < 2; j++){
                mins = (mins == '30') ? '00' : '30';
                Integer hrs;
                if(i==0){ hrs = 12;}
                else { hrs = i; }
                
                String key = hrs + ':' + mins +' '+ am;
                options.add(new SelectOption(key, key));
            }
        }
        
        for(Integer i=0; i < 12; i++){
            for(Integer j=0; j < 2; j++){
                mins = (mins == '30') ? '00' : '30';
                Integer hrs;
                if(i==0){ hrs = 12;}
                else { hrs = i; }
                
                String key = hrs + ':' + mins +' '+ pm;
                options.add(new SelectOption(key, key));
            }
        }
        
        return options;  
    }
    
    //Make all day event true
    public void allDayEventCheck(){
        allDayEvent = (parentEvent.IsAllDayEvent) ? true : false;
    }
    
    //Disable date tie
    public void disableDateTime(){
        allDayEvent = (parentEvent.Method__c == 'Phone Call') ? true : false;
    }    
    
    //Change enddate & time when startdate & time is changed. Also update timeslot in attendee section
    public void startDateTimeChange(){ 
        try{
            parentEvent.Event_End_Date__c = parentEvent.Event_Start_Date__c;
            endDateTime = MFS_Activity360GeneralUtility.advanceTimeByOneHour(parentEvent, startDateTime); 
            changeInviteeTimeSlots();
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Add portfolios to MMR record
    public void addMMRPortfolios(){
        try{
            MFS_MeetingMaterialRequestUtility.addMMRPortfolios(MMR, MMRPortfolioWrapperList);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }    
    
    //Remove portfolios from MMR record
    public void removeMMRPortfolios(){
        try{
            MFS_MeetingMaterialRequestUtility.removeMMRPortfolios(MMRPortfolioWrapperList, rmMMRPortfRow, portfolioSetToRemove );
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    public void removeSingleMMRClientInv()
    {
        MFS_MeetingMaterialRequestUtility.removeSingleMMRClientInv(MMR,MMRPortfolioWrapperList, rmMMRPortfRow, PortfolioMap);
    }
    
    //Add language fields to enter numbe of copies required. 
    public void addLanguageFields(){
        try{
            MFS_MeetingMaterialRequestUtility.addLanguageFields(MMR, languageFields);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Add new translation languages to MMR
    public void addTransLanguage()
    {
        MFS_MeetingMaterialRequestUtility.addTransLanguage(MMR, languageFields);
    }
    
    //Method to construct MMR name as "Material Type - Due Date"
    public void constructMMRName()
    {
        try{
            MFS_MeetingMaterialRequestUtility.constructMMRName(MMR);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Fetch team members from Organization
    public void fetchMMRTeamMembers()
    {
        try{
            MFS_MeetingMaterialRequestUtility.fetchMMRTeamMembers(MMR);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Prepare list to Display available MMR records
    public void constructMMRRelatedList()
    {
        try{
            MFS_MeetingMaterialRequestUtility.constructMMRRelatedList(MMR,languageFields,PortfolioMap,MMRPortfolioWrapperList);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Form multiselect picklist for SLDS
    public String formatToMultiPicklist(List<SelectOption> LstSelectedOptions){
        String str;
        for(SelectOption so: LstSelectedOptions){
            if(so.getValue() != NULL && so.getValue() != ''){
                if(str==NULL){
                    str = so.getValue() + ';';
                }else{
                    str = str+ so.getValue() + ';';
                }
            }
        }
        if(str!= NULL && str.endsWith(';')){
            str = str.substring(0, str.length()-1);
        }
        return str;
    }
    
    //Code to upload attachment
    public PageReference uploadAttachment(){
        PageReference pg = MFS_Activity360GeneralUtility.uploadAttachment(isSF1, oRecTypeActivity, parentObjectID, isNew, isConsole, taskCallNote, eventCallNote, fileBody, fileName, parentTask, parentEvent, callNote);
        return pg;
    }
    
    //Delete attachment from the page
    public void deleteAttachment(){
        try{
            attachmentList = MFS_Activity360GeneralUtility.deleteAttachment(attachmentList, individualChildRecordId);
            individualChildRecordId = null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    // Check if the current context is Salesforce1 or desktop
    public Boolean isSF1 {
        get {                   
            if(String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
               String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
               ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
               (ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL').contains('projectone') )
              ) {
                  return true;
              }else{
                  return false;
              } 
        }
    }
    
    public void editFollowUpRecord1(){
        popUpInEditMode = true;
        showSaveBtnOnPopUp = true;
    }
    
    //Get all the picklist values for the multiselect picklist Translation_Languages__c
    public String getAllLanguages(){
        String options = '';
        options = MFS_MeetingMaterialRequestUtility.getAllLanguages(MMR);
        return options;
    }
    
    //Get all the selected values for the multiselect picklist Translation_Languages__c
    public String getSelectedLanguages(){
        String options = '';
        options = MFS_MeetingMaterialRequestUtility.getSelectedLanguages(MMR);
        return options;
    }
    
    //Get multiselect values for performance period
    public String getPerformancePeriod(){
        String options = '';
        options = MFS_MeetingMaterialRequestUtility.getLeftSideValues(MMR.Performance_Period__c, 'PerformancePeriod');
        return options;
    }
    
    //Get all the selected values for the multiselect picklist Performance_Period__c
    public String getSelectedPerformancePeriod(){
        String options = '';
        String values='';
        /*if(UserInfo.getLanguage() != MFS_AllConstants.USER_DEFAULT_LANGUAGE)
{
if(!String.isEmpty(MMR.Performance_Period__c)){
List<String> tempList = new List<String>(MMR.Performance_Period__c.split(';'));
Set<String> selectedlang = new Set<String>(tempList);

for(String schmaValue : selectedlang){
if(String.isEmpty(values))
values = MFS_AllConstants.MMR_PERFORMANCE_PERIOD_VALUES.get(schmaValue);
else
values = values+','+ MFS_AllConstants.MMR_PERFORMANCE_PERIOD_VALUES.get(schmaValue);
}
}
}
else{

}*/
        values = MMR.Performance_Period__c;
        options = MFS_MeetingMaterialRequestUtility.getRightSideValues(values);
        return options;
    }
    //Get multiselect values for attribution period
    public String getAttrPeriod(){
        String options = '';
        options = MFS_MeetingMaterialRequestUtility.getLeftSideValues(MMR.Attribution_Period__c, 'AttrPeriod');
        return options;
    }
    
    //Get all the selected values for the multiselect picklist Attribution_Period__c
    public String getSelectedAttrPeriod(){
        String options = '';
        String values='';
        /*if(UserInfo.getLanguage() != MFS_AllConstants.USER_DEFAULT_LANGUAGE)
{
if(!String.isEmpty(MMR.Attribution_Period__c)){
List<String> tempList = new List<String>(MMR.Attribution_Period__c.split(';'));
Set<String> selectedlang = new Set<String>(tempList);

for(String schmaValue : selectedlang){
if(String.isEmpty(values))
values = MFS_AllConstants.MMR_ATTRIBUTION_PERIOD_VALUES.get(schmaValue);
else
values = values+','+ MFS_AllConstants.MMR_ATTRIBUTION_PERIOD_VALUES.get(schmaValue);
}
}
}
else{
values = MMR.Attribution_Period__c;
}*/
        values = MMR.Attribution_Period__c;
        options = MFS_MeetingMaterialRequestUtility.getRightSideValues(values);
        return options;
    }
    
    //Get multiselect values for time periods covered
    public String getTimePeriodCovered(){
        String options = '';
        options = MFS_MeetingMaterialRequestUtility.getLeftSideValues(MMR.Time_Periods_Covered__c, 'TimePeriodCovered');
        return options;
    }
    
    //Get all the selected values for the multiselect picklist time periods covered
    public String getSelectedTimePeriodCovered(){
        String options = '';
        String values='';
        
        values = MMR.Time_Periods_Covered__c;
        options = MFS_MeetingMaterialRequestUtility.getRightSideValues(values);
        return options;
    }
    
    //Get all the picklist values for the multiselect picklist Activity_Type_for_Instit__c
    public String getAllActivityType(){
        String options = '';
        options = (eventCallNote) ? MFS_Activity360SF1Utility.getAllActivityType(parentEvent) : '';
        return options;
    }
    
    //Get the selected values for the multiselect picklist Activity_Type_for_Instit__c
    public String getSelectedActivityTypes(){
        String options = '';
        options = (eventCallNote) ? MFS_Activity360SF1Utility.getSelectedActivityTypes(parentEvent) : '';
        return options;
    }
    
    //Get all the picklist values for the multiselect picklist Activity_Type_for_Instit__c for follow up taks
    /* public String getAllActivityTypeForFollowUp(){
String options = '';
options = (eventCallNote) ? MFS_Activity360SF1Utility.getAllActivityTypeForFollowUp(task) : '';
return options;
}

//Get the selected values for the multiselect picklist Activity_Type_for_Instit__c for follow up taks
public String getSelectedActivityTypesForFollowUp(){
String options = '';
options = (eventCallNote) ? MFS_Activity360SF1Utility.getSelectedActivityTypesForFollowUp(task) : '';
return options;
}
*/
    @RemoteAction
    global static List<User> queryUsers(String keyword) { 
        List<User> userList = new List<User>();
        userList = MFS_Activity360SF1Utility.queryUsers(keyword);
        return userList;
    }
    //Remote method to return the list of contacts matching the keyword
    @RemoteAction
    global static List<Contact> queryContacts(String keyword){
        List<Contact> contactList = new List<Contact>();
        contactList = MFS_Activity360SF1Utility.queryContacts(keyword);
        return contactList;
    }
    
    //Remote method to return the list of Leads matching the keyword
    @RemoteAction
    global static List<Lead> queryLeads(String keyword) { 
        List<Lead> leadList = new List<Lead>();
        leadList = MFS_Activity360SF1Utility.queryLeads(keyword);
        return leadList;
    }
    
    //Remote method to return the list of Cases matching the keyword
    @RemoteAction
    global static List<Case> queryCases(String keyword) { 
        List<Case> cseList = new List<Case>();
        cseList = MFS_Activity360SF1Utility.queryCase(keyword);
        return cseList;
    }
    //Remote method to return the list of Accounts matching the keyword
    @RemoteAction
    global static List<Account> queryAccounts(String keyword) {
        List<Account> accountList = new List<Account>();
        accountList = MFS_Activity360SF1Utility.queryAccounts(keyword);
        return accountList;
    }
    
    //Remote method to return the list of Opportunities matching the keyword
    @RemoteAction
    global static List<Opportunity> queryOpportunities(String keyword) {
        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList = MFS_Activity360SF1Utility.queryOpportunities(keyword);
        return opportunityList;
    }
    
    //Remote method to return the list of Opportunities matching the keyword
    @RemoteAction
    global static List<Account__c> queryClientInvestments(String keyword) {
        List<Account__c> ClientInv = new List<Account__c>();
        ClientInv = MFS_Activity360SF1Utility.queryClientInvestments(keyword);
        return ClientInv;
    }
    
    @RemoteAction
    global static List<Product2> queryPortfolios(String keyword) {
        List<Product2> portfolios = new List<Product2>();
        portfolios = MFS_Activity360SF1Utility.queryPortfolios(keyword);
        return portfolios;
    }
    
    //Remote method to return the list of Campaigns matching the keyword
    @RemoteAction
    global static List<Campaign> queryCampaign(String keyword) {
        List<Campaign> campList = new List<Campaign>();
        campList = MFS_Activity360SF1Utility.queryCampaign(keyword);
        return campList;
    }
    
    //Remote method to return the list of BAR matching the keyword
    @RemoteAction
    global static List<Business_At_Risk__c> queryBAR(String keyword) {
        List<Business_At_Risk__c> barList = new List<Business_At_Risk__c>();
        barList = MFS_Activity360SF1Utility.queryBAR(keyword);
        return barList;
    }
    
    //Remote method to return the list of Strategy Plans matching the keyword
    @RemoteAction
    global static List<Strategy_Plan__c> queryStrategyPlans(String keyword) {
        List<Strategy_Plan__c> spList = new List<Strategy_Plan__c>();
        spList = MFS_Activity360SF1Utility.queryStrategyPlans(keyword);
        return spList;
    }
    
    @RemoteAction
    global static List<Event_Request__c> querySpeakerRequests(String keyword) {
        List<Event_Request__c> speakerList = new List<Event_Request__c>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            speakerList = [select Id,Name, Event_Title__c, Location__c, Requester__r.Name, Start_Date__c from Event_Request__c where (Name like :keyword OR Event_Title__c like :keyword OR
                                                                                                                                      Location__c like :keyword OR Event_Types__c INCLUDES(:keyword) OR Requester__r.Name like :keyword) AND Recordtype.DeveloperName= 'Speaker_Request' LIMIT 10];
        }
        return speakerList;
    }
    @RemoteAction
    global static List<Consultant_Rating__c> queryConsultantRating(String keyword) {
        List<Consultant_Rating__c> crList = new List<Consultant_Rating__c>();
        crList = MFS_Activity360SF1Utility.queryConsultantRating(keyword);
        return crList;
    }
    
    //returns the Competitor Product data in JSON format
    public string jsonDataAllUsers{ 
        get{
            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeFieldName('Users');
            gen.writeStartArray();
            
            if(jsonDataAllUsers == null){
                for(User u : [select Id,Name from User where isActive = True]){
                    gen.writeStartObject();
                    gen.writeStringField('Id', u.Id);
                    gen.writeStringField('Name', u.Name);
                    gen.writeEndObject();
                    
                } 
            }
            gen.writeEndArray();
            gen.writeEndObject();
            jsonDataAllUsers = gen.getAsString();
            return jsonDataAllUsers;
        }
        private set; 
    }
    
    public void pullJsonForSelectedNotifiersOfCA(){
        lstSelectedNotifiersForCA.clear();
        for (String s : jsonUpdatedNotifiersForCA.split(',')){
            lstSelectedNotifiersForCA.add(s);
        }
    }
    
    //show RES popup when button is clicked from Retail Page
    public void showRESPopUp(){
        
        op = new Opportunity();
        op.CurrencyIsoCode = UserInfo.getDefaultCurrency();
        op.StageName = 'In Progress';
        op.Probability = 20;
        op.CloseDate = System.Today() + 5;
        
        showRESPopUp = true;
        resInEditMode = true;
        allowRESRecord = true;
        try{
            allowRESRecord = (ProductWrapperList.size() > 0 && !callNote.Has_RES_Record__c) ? true : false;
            rESRecordExists = callNote.Has_RES_Record__c;
            if(allowRESRecord){
                RecordType rt = [select id,Name,SobjectType,DeveloperName from RecordType where DeveloperName='Retail_External_Sales' and SobjectType='Opportunity' LIMIT 1];
                op.RecordTypeId = rt.Id;
                ProductWrapperListForRES.addAll(ProductWrapperList);
                compProdWrapperListForRES.addAll(competitorProdWrapperList);
                if(taskCallNote){
                    if(!String.IsEmpty(parentTask.WhoId) && parentTask.WhoId!=null && ((String)(parentTask.WhoId.getSobjectType().getdescribe().getName()) == 'Contact')){
                        Contact con = [Select Name, Account.Name, AccountId from Contact where Id = :parentTask.WhoId LIMIT 1];
                        op.AccountId = con.AccountId;
                        op.Name = con.Account.Name + ' ' + '-'+ ' ' + system.Today().Format();
                        oppAccountName = con.Account.Name;
                        op.Client_Contact__c = parentTask.WhoId;
                        oppClientContact = con.Name;
                    }
                    if(!String.IsEmpty(parentTask.OwnerId) && parentTask.OwnerId!=null){
                        op.OwnerId = parentTask.OwnerId;
                    }
                }
                
                if(eventCallNote){
                    if(!String.IsEmpty(parentEvent.WhoId) && parentEvent.WhoId!=null && ((String)(parentEvent.WhoId.getSobjectType().getdescribe().getName()) == 'Contact')){
                        Contact con = [Select Name, Account.Name, AccountId from Contact where Id = :parentEvent.WhoId LIMIT 1];
                        op.AccountId = con.AccountId;
                        op.Name = con.Account.Name + ' ' + '-'+ ' ' + system.Today().Format();
                        oppAccountName = con.Account.Name;
                        op.Client_Contact__c = parentEvent.WhoId;
                        oppClientContact = con.Name;
                    }
                    
                    if(!String.IsEmpty(parentEvent.OwnerId) && parentEvent.OwnerId!=null){
                        op.OwnerId = parentEvent.OwnerId;
                    }
                }
            }
            
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    
    public void removeProductFromRES(){
        try{
          MFS_RESUtility.removeProductFromRES(individualChildRecordId, ProductWrapperListForRES);
            individualChildRecordid = null;
        }catch(Exception ex){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    public void removeCompProductFromRES(){
       try{
            MFS_RESUtility.removeCompProductFromRES(individualChildRecordId, compProdWrapperListForRES);
            individualChildRecordid = null;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        } 
    }
    public void saveRESRecord(){
        try{
            if(op.Id==null){
                //resInEditMode = MFS_RESUtility.saveRESRecord(op, selectedCoverageTeamMembers, parentTask, parentEvent, taskCallNote, eventCallNote, taskWrapperList, callNote );
                resInEditMode = MFS_RESUtility.saveRESRecord(op, selectedCoverageTeamMembers, parentTask, parentEvent, taskCallNote, eventCallNote, taskWrapperList, callNote, ProductWrapperListForRES, compProdWrapperListForRES );
                if(!resInEditMode){
                    callNote.Has_RES_Record__c = true;
                    rESRecordExists = callNote.Has_RES_Record__c;
                    upsert callNote;
                } 
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    public void closeRESRecord(){
        showRESPopUp = false;
        allowRESRecord = false;
        op = new Opportunity();
    }
    
    public string getContactCoverageTeamMembers(){
        String options = MFS_RESUtility.getContactCoverageTeamMembers(parentTask, parentEvent, taskCallNote, eventCallNote);
        return options;
    }
    
    public void checkOpportunityStatus(){
        if(op.StageName.contains('Closed')){
            op.closeDate = system.today();
        }
    }
    
    public List<SelectOption> getOppCurrencyCodes(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Opportunity.CurrencyIsoCode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    //Change the Notification Date if the Close Date is changed
    public void changeDates(){
        try{
            MFS_RESUtility.changeDates(op);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //get All event types from activity page. This is used in SLDS multiselect picklist
    public String getEventType(){
        String options = '';
        Schema.DescribeFieldResult fieldResult =Event_Request__c.Event_Types__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<String> tempLst = new List<String>();
        if(!String.isempty(placholderEventRequest.Event_Types__c))
        {
            tempLst= placholderEventRequest.Event_Types__c.split(';');
        }
        Set<String> tempSet = new Set<String>(tempLst);
        for( Schema.PicklistEntry f : ple){
            if(!tempSet.contains(f.getLabel()))
            {
                if(options == '')
                    options = f.getLabel();
                else
                    options += ','+f.getLabel();
            }
        }
        return options;
    }
    
    //get Selected event types from activity page. This is used in SLDS multiselect picklist
    public String getSelectedEventType()
    {
        String options = '';
        if(placholderEventRequest.Event_Types__c != NULL && placholderEventRequest.Event_Types__c != '' ){
            for(String actType: placholderEventRequest.Event_Types__c.split(';')){
                if(options == '')
                    options = actType;
                else
                    options += ','+actType;
            }
        }
        return options;  
    }
    
    public void setContactNameForLkp()
    {
        Contact c = new Contact();
        if(eventCallNote)
            c = [select name from Contact where id=:parentEvent.WhoId];
        if(taskCallNote)
            c = [select name from COntact where id = :parentTask.WhatId];
        whoName = c.Name;
        srContName = c.Name;
    }
    
    //get field ids from Custom Setting. This is used to prepopulate Trading Floor Tour Page
    public void createEventRequest()
    {
        try{
            List<String> erListOfFields=new List<String>{'Requestor__c','Event_Title__c','Organization__c','Contact__c','Start_Date__c','End_Date__c'};
                Map<String,String> fieldMap=MFS_Utilities.getFieldId('Event_Request__c',erListOfFields);
            Schema.DescribeSObjectResult r = Event_Request__c.sObjectType.getDescribe();
            erObjectId = r.getKeyPrefix(); 
            erRecordTypeId = [select id from recordtype where developername='Trading_floor_Tour' and SObjectType = 'Event_Request__c'].Id;
            requestorId = fieldMap.get(erListOfFields.get(0));
            eventTitleId = fieldMap.get(erListOfFields.get(1));
            erOrgId = fieldMap.get(erListOfFields.get(2));
            erContactId = fieldMap.get(erListOfFields.get(3));
            erStDateId = fieldMap.get(erListOfFields.get(4));
            erEndDateId = fieldMap.get(erListOfFields.get(5));
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    /******************************* Product and Competitor Product search seaction Starts ***********************/
    //Get selected products from the modal
    public void getSeletedProduct()
    {
        if(isSelected=='true')
        {
            selectedIds.remove((Id)selectedProduct);
        }
        if(isSelected == 'false')
        {
            selectedIds.add((Id)selectedProduct);
        }
    }
    
    //search product fro the modal
    public void searchProduct(){
        try{
            wraplist = new List<SearchWrapper>();            
            String query=constructQuery(searchOpt,selectedAssetGeography,selectedVehicle);
            List<Product2> pList=Database.query(query);                
            for(Product2 pbRec:pList){  
                wraplist.add( new SearchWrapper(false, pbRec, pbRec.ID, MFS_AllConstants.PRODUCT_ASSET_CLASS_GEOHRAPHY_VALUES.get(pbRec.Asset_Class_by_Geography__c))); 
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Construct query for product search depending on user's entry
    @TestVisible
    private  String constructQuery(String productName,String productGeography,String productVehicle)
    {
        String query='Select Id,Strategy__r.Name,Name,Asset_Class_by_Geography__c,Vehicle__c,Restricted__c, Product_Record_Type__c from Product2 where IsActive=true and Is_Unknown__c =false and Restricted__c=false  '; //Asset_Class_Geography__c field is replace by Asset_Class_by_Geography__c on 01/Feb/2017
        if(productName!='' && productName!=null){
            //query=query+' AND Name like '+'\'%'+String.escapeSingleQuotes(productName)+ '%\' ';
            query=query+' AND (Strategy__r.Name like '+'\'%'+String.escapeSingleQuotes(productName)+ '%\''+' OR Name like '+'\'%'+String.escapeSingleQuotes(productName)+ '%\''+')';
        }
        if(productGeography!='None' && productGeography!=null && productGeography!=''){
            query=query+' AND Asset_Class_by_Geography__c ='+'\''+String.escapeSingleQuotes(productGeography)+'\' ';
        }
        if(productVehicle!='None' && productVehicle!=null && productVehicle!='')
        {
            query=query+' AND Vehicle__c='+'\''+String.escapeSingleQuotes(productVehicle)+'\' ';
            
        }
        if(query.EndsWith('where ')) {
            query = query.removeEnd('where ');
        }
        if(query.EndsWith('AND ')) {
            query = query.removeEnd('AND ');
        }
        query=query+' ORDER BY Product_Record_Type__c,Strategy__r.Name,Name, Vehicle__c ASC Limit 25'; //Limit is changed on 01/Feb/2017
        return query;
    }
    
    //Method is used to get Asset Class-Geography picklist from Product2 object
    public List<Selectoption> getGeograhpyOptions(){
        List<Selectoption>  prodGeograhpy=new List<Selectoption> ();
        prodGeograhpy.add(new SelectOption(MFS_AllConstants.PICKLIST_DEFAULT,'---'+MFS_AllConstants.PICKLIST_DEFAULT+'---'));        
        map<String, Schema.SObjectField> fieldMap = Product2.getSObjectType().getDescribe().fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get(MFS_AllConstants.PRODUCT_GEOGRAPHY).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values)
        { 
            prodGeograhpy.add(new SelectOption(a.getValue(),a.getLabel())); 
        }
        return prodGeograhpy;
    }
    
    //Method is used to get Vehicle picklist from Product2 object  
    public List<Selectoption> getVehicleOptions(){
        List<Selectoption>  prodVehicleList=new List<Selectoption> ();
        prodVehicleList.add(new SelectOption(MFS_AllConstants.PICKLIST_DEFAULT,'---'+MFS_AllConstants.PICKLIST_DEFAULT+'---'));
        Schema.sObjectType objType = Product2.getSObjectType(); 
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> values =     fieldMap.get(MFS_AllConstants.PRODUCT_VEHICLE).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values)
        { 
            prodVehicleList.add(new SelectOption(a.getValue(),a.getLabel())); 
        }
        return prodVehicleList; 
    }
    
    //Search for competitor product from related list modal
    public void searchComProduct(){
        try{
            wraplist = new List<SearchWrapper>();
            String query=constructQueryCom(searchCom,firm);
            List<Competitor_Product__c> pList=Database.query(query);                
            for(Competitor_Product__c pbRec:pList){                  
                wraplist.add( new SearchWrapper(false, pbRec)); 
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Search competitor product within competitive analysis request modal
    public void searchComProductCA(){
        try{
            wraplist = new List<SearchWrapper>();
            String query=constructQueryCom(searchComCA,firmCA);
            List<Competitor_Product__c> pList=Database.query(query);                
            for(Competitor_Product__c pbRec:pList){                  
                wraplist.add( new SearchWrapper(false, pbRec)); 
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //COMPETITOR QUERY
    @TestVisible
    private  String constructQueryCom(String productName,String firm){
        String query='Select Id, Name, Firm_Name__c, Ticker__c from Competitor_Product__c where '; // Firm__r.Name is replaced with Firm_Name__c on 08/Feb/2017 for UAT Defect
        if(productName!='' && productName!=null){
            query=query+' Name like '+'\'%'+String.escapeSingleQuotes(productName)+ '%\' AND ';
        }
        if(firm!='' && firm!=null){
            query=query+' Firm_Name__c like '+'\'%'+String.escapeSingleQuotes(firm)+ '%\' AND ';// Firm__r.Name is replaced with Firm_Name__c on 08/Feb/2017 for UAT Defect
        }
        if(query.EndsWith('where ')) {
            query = query.removeEnd('where ');
        }
        if(query.EndsWith('AND ')) {
            query = query.removeEnd('AND ');
        }
        query=query+' ORDER BY Name ASC Limit 50';
        return query;
    }
    
    
    //Set the variable when "add portfolio" is clicked from invitee section
    public void assignSelectedInviteeId(){
        if(String.isEmpty(defaultUserVehicle))
        {
            User usr = [select Vehicle__c from User where id = :UserInfo.getUserId()];
            defaultUserVehicle = usr.Vehicle__c;
        }
        selectedAssetGeography ='';
        searchOpt = '';
        selectedVehicle = defaultUserVehicle;
        selectedProduct = '';
        searchProduct();
    }
    
    //Reset Competitor Product popup search for Related List
    public void resetCompProdSearchPanel(){
        selectedComProduct = '';
        searchCom = '';
        firm = '';
        searchComProduct();
    }
    
    
    
    //Wrapper for Product Search and Competitor Product Search
    public class SearchWrapper{
        public Product2 prg {get;set;}
        public Id prodId{get;set;}
        public Boolean isSelected { get; set; }
        public Competitor_Product__c comp { get; set; }
        public String assetClassGeoName{get; set; }
        
        //Used for products
        public SearchWrapper( Boolean slct, Product2 pr, Id prId, String assetClassGeoName) {
            this.prg = pr;
            this.prodId = prId;
            this.isSelected = slct;
            this.assetClassGeoName = assetClassGeoName;
        }
        
        //Used for Competitor Products
        public SearchWrapper( Boolean slct, Competitor_Product__c pr) {
            this.comp = pr;
            this.isSelected = slct;
        }
    }
    public void initi() {
        wraplist = new List<SearchWrapper>(); 
    }
    
    /* removed functionality */
    
    //Called on click of right arrow button and moves the invitee from left box to right box
    public void clickRight(){ 
        //MFS_EventInviteeUtility.clickRight(leftSelectedList ,rightSelectedList ,mLeftSelected ,mRightSelected ,lstRightOption , lstLeftOption);
    } 
    
    //Called on click of left arrow button and moves the invitee from right box to left box
    public void clickLeft(){
        //MFS_EventInviteeUtility.clickLeft(leftSelectedList ,rightSelectedList ,mLeftSelected ,mRightSelected ,lstRightOption , lstLeftOption);
    }
    //Used in Competitor product searchbox
    public void addingProduct()
    {
        oProductJN = new Call_Note_Product__c();
    }
    //search box in MFS Competitor Portfolio related section (Activity360 page)
    public void addingCompetitorProduct ()
    {
        oCompProductJN = new Call_Note_Competitor_Product__c();
    }
    //Update Event Request
    public void updateSR(){
        try{
            if(SpeakerWrapperList == NULL){
                SpeakerWrapperList  = new List<MFS_Activity360GeneralUtility.wrapperClass>();
            }else{
                SpeakerWrapperList.clear();
            }
            //Logic for Past Event - it should show a modal to link existing event request
            if(placholderEventRequest.id == NULL){
                if(tempEventRelation.Speaker_Request__c != NULL){
                    callNote.Event_Request__c = tempEventRelation.Speaker_Request__c;
                    update callNote;
                    
                    
                    placholderEventRequest = [select id, Requester__c,Start_Date__c, End_Date__c, Organization__c, Event_Title__c, Contact__c, Overall_Approval_Status__c,Event_Types__c, 
                                              TimeZone__c,Event_Start_Date__c, Event_End_Date__c,Method__c, Speaker_Request_Instructions__c, Speaker_Rationalization__c, Event_Instructions__c, Conference_Room__c,
                                              Hotel__c, Is_Travel_Required__c,City__c, Country__c, State__c, Zip_Code__c, Street__c, Request_Type__c, Location__c, MFS_Contact_for_Presentation_Materials__c,
                                              Channel__c, Audience__c,Dress_Code__c,Call__c,Link_to_presentation_materials__c  from Event_Request__c where id=: callNote.Event_Request__c 
                                              LIMIT 1];
                    MFS_SpeakerRequestUtility.updateSpeakerRequest(placholderEventRequest,SpeakerWrapperList);
                    
                    Set<Id> setApprovedSpeakers = new Set<Id>();
                    for(Event_Relation__c approvedER:[select id,Approval_Status__c,Speaker__c from Event_Relation__c where Speaker_Request__c =:  placholderEventRequest.id and Approval_Status__c = 'Approved']){
                        setApprovedSpeakers.add(approvedER.Speaker__c);
                    }
                    for(Event_Relation__c erel: SpeakerList){
                        erel.Speaker_Request__c = placholderEventRequest.id;
                        if(setApprovedSpeakers.contains(erel.Speaker__c)){
                            erel.Approval_Status__c = 'Approved';
                        }
                    } 
                    if(!SpeakerList.isEmpty()){
                        upsert SpeakerList;
                    }
                    
                    
                }
            }
            //Future Event - it should create a new event request
            else{
                //upsert speakerRequest;
                placholderEventRequest.Start_Date__c = MFS_Activity360GeneralUtility.dateTimeConcat(placholderEventRequest.Event_Start_Date__c,erStartTime);
                placholderEventRequest.End_Date__c = MFS_Activity360GeneralUtility.dateTimeConcat(placholderEventRequest.Event_End_Date__c,erEndTime);
                placholderEventRequest.Event_Instructions__c = eventInstructionRT;
                upsert placholderEventRequest;
                MFS_SpeakerRequestUtility.updateSpeakerRequest(placholderEventRequest,SpeakerWrapperList);
            }
            displayPopup = false;
            popUpInEditMode = true;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    public string getPresentationURL()
    {
        String urlString = 'Not Available';
        if(!String.isEmpty(callNote.Event_Request__c)){
            Event_Request__c er = [select id, link_to_presentation_materials__c from Event_Request__c where id= : callNote.Event_Request__c];
            urlString = (!String.isEmpty(er.link_to_presentation_materials__c)) ? er.link_to_presentation_materials__c : 'Not Available';
        }      
        return urlString;
    }
    
    //to get Default Value for Time Period Covered
    public String getTimePeriodCoveredDefault() {
        String options = '';
        String values='';
        
        values = MMR.Time_Periods_Covered__c;
        
        options = MFS_MeetingMaterialRequestUtility.getRightSideValues(values);
        return options;
    }
    
    
    /*
     * public String getSelectedTimePeriodCovered(){
        String options = '';
        String values='';
        
        values = MMR.Time_Periods_Covered__c;
        options = MFS_MeetingMaterialRequestUtility.getRightSideValues(values);
        return options;
    }
     */
    
}