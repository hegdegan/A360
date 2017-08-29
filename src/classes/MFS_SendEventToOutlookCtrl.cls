/***************************************************************************************************
Apex Class Name    : MFS_SendEventToOutlookCtrl
Version            : 1.0 
Created Date       : 3 Nov 2016
Function           : Controller to create outlook ics file 
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Manoj Parida            11/3/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_SendEventToOutlookCtrl{
    public String startDate{get;set;}
    public String endDate{get;set;}
    public String localStartTime{get;set;}
    public String mStartDate{get;set;}
    public String mEndDate{get;set;}
    public String now{get;set;}
    public String rcCode{get;set;}
    public Event event {get;set;}
    public String portfolios{get;set;}
    public String vehicleTypes{get;set;}
    public Event_Relation__c eventRel{get;set;}
    static String formatStr = 'yyyyMMdd\'T\'HHmmss';
    public String detailURL{get;set;}
    public String linkText {get; set; }
    public MFS_SendEventToOutlookCtrl(){
        String baseURl = URL.getSalesforceBaseUrl().toExternalForm();
        Id eventId = ApexPages.currentPage().getParameters().get('eventId');
        linkText = 'N/A';
        try{
            eventRel = [Select Activity_Detail__c,Time_Slot_Start__c, Time_Slot_End__c, Speaker__r.Email, Speaker_Request__r.Call__c, Speaker_Request__r.Location__c,
                        Speaker__r.Employee_ID__c, Topic__c, Speaker_Request__r.TimeZone__c, Speaker_Request__r.Event_Title__c, Speaker_Request__r.Requester__c,
                        Speaker_Request__r.Requester__r.Name, Speaker_Request__r.Event_Types__c, Speaker_Request__r.Audience__c, Speaker_Request__r.Dress_Code__c,
                        Speaker_Request__r.Tier__c, Speaker_Request__r.Asset_Class__c, Speaker_Request__r.Organization__r.Name, Speaker__r.Name,Speaker_Request__r.Organization__r.Type,
                        Speaker_Request__r.MFS_Contact_for_Presentation_Materials__r.Name, Speaker_Request__r.Link_to_presentation_materials__c,
                        Speaker_Request__r.Speaker_Expense_RC_Code__c, Speaker_Request__r.Event_Instructions__c, Speaker_Request__r.Call_Note__c, CreatedBy.Name
                        from Event_Relation__c where Id =: eventId];
            now = DateTIme.now().format(formatStr);
            startDate = eventRel.Time_Slot_Start__c == null ? '':eventRel.Time_Slot_Start__c.format(formatStr);
            endDate = eventRel.Time_Slot_End__c==null? '' : eventRel.Time_Slot_End__c.format(formatStr);
            String eventTimeZone = (eventRel.Speaker_Request__r.TimeZone__c == null) ? 'EST' : eventRel.Speaker_Request__r.TimeZone__c.subString(1,10).replace('UTC','GMT');
            System.debug('eventTimeZone'+eventTimeZone);
            localStartTime = eventRel.Time_Slot_Start__c == null ? '':eventRel.Time_Slot_Start__c.format('MM/dd/yyyy hh:mm a',eventTimeZone);
            mStartDate = eventRel.Time_Slot_Start__c == null ? '':eventRel.Time_Slot_Start__c.format('MM/dd/yyyy hh:mm a',UserInfo.getTimeZone().getId());
            mendDate = eventRel.Time_Slot_End__c == null ? '':eventRel.Time_Slot_End__c.format('MM/dd/yyyy hh:mm a',UserInfo.getTimeZone().getId());
            event = new Event();
            event = [Select IsAllDayEvent from Event where Activity_Detail__c =:eventRel.Speaker_Request__r.Call_Note__c Limit 1];
            
            List<Event_Relation_Portfolio_Junction__c> portfList = new List<Event_Relation_Portfolio_Junction__c>([select Portfolio__r.Name, Portfolio__r.Vehicle__c from Event_Relation_Portfolio_Junction__c where Event_Relation__c = :eventId]);
            portfolios = '';
            for(Event_Relation_Portfolio_Junction__c erpj : portfList)
            {
                if(String.isempty(portfolios))
                    portfolios = erpj.Portfolio__r.Name;
                else
                    portfolios += ', '+erpj.Portfolio__r.Name;
                if(String.isEmpty(vehicleTypes))
                    vehicleTypes = erpj.Portfolio__r.Vehicle__c;
                else
                    vehicleTypes += ', '+erpj.Portfolio__r.Vehicle__c;
            }
            User usr = [select RC_Code__c from User where Id = :eventRel.Speaker_Request__r.Requester__c];
            rcCode = usr.RC_Code__c;
            if(eventRel != null && !String.isEmpty(eventRel.activity_Detail__c)){
                Event ev = [select id, recordtype.DeveloperName, WhatId from Event where activity_Detail__c = :eventRel.activity_Detail__c ORDER BY createddate ASC LIMIT 1 ];
                if(ev != null && !String.isEmpty(ev.recordtype.DeveloperName)){
                    linkText = Label.Outlook_Click_Here;
                    detailURL = baseURl+'/apex/MFS_A360MeetingDetails?id='+eventRel.Activity_Detail__c+'&nooverride=1&returnID='+ev.whatId+'&event=true';
                }
            }
        }
        Catch(Exception ex){
            System.debug(ex.getMessage()+ex.getLineNUmber());
        }    
    }    
}