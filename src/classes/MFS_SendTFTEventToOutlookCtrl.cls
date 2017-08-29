/*
Apex class           :  MFS_SendTFTEventToOutlookCtrl
Version               :  1.0
Created Date          :  16 NOV 2016
Function              :  This class is used o fetch data to prepare ics file from the custom button
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* Ganesh Hegde         16 NOV 2016              Initial Version
*/
public with sharing class MFS_SendTFTEventToOutlookCtrl{
    public String startDate{get;set;}
    public String endDate{get;set;}
    public String now{get;set;}
    public Event_request__c event {get;set;}
    public String translator{get;set;}
    static String formatStr = 'yyyyMMdd\'T\'HHmmss';
    public MFS_SendTFTEventToOutlookCtrl(ApexPages.StandardController ctrl){
        try{
            event = (Event_Request__c)ctrl.getRecord();
            event=[select id, Start_Date__c, End_Date__c,Translator_Required__c from Event_Request__c where id = :event.Id];
            now = DateTIme.now().format(formatStr);
            startDate = event.Start_Date__c == null ? '':event.Start_Date__c.format(formatStr);
            endDate = event.End_Date__c==null? '' : event.End_Date__c.format(formatStr); 
            if(event.Translator_Required__c)
                translator = 'Yes';
            else
                translator = 'No';
        }Catch(Exception ex){
            System.debug(ex.getMessage()+ex.getLineNUmber());
        }    
    }    
}