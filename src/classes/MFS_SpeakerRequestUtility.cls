/*
Apex class           :  MFS_SpeakerRequestUtility
Version               :  1.0
Created Date          :  16 SEP 2016
Function              :  This Utility class contains all methods related to Speaker Request Related List in Activity360

Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* GYANENDRA SINGH          16 SEP 2016              Initial Version
*/

public class MFS_SpeakerRequestUtility {
    
    /*
    ** Method Name     : goToSpeakerRequest
    ** Description     : Method to get all the related Speaker Request records
    ** Used in         : Speaker Request related list (Activity360 page)
    */
    public static List<MFS_Activity360GeneralUtility.wrapperClass> goToSpeakerRequest(id cId, List<MFS_Activity360GeneralUtility.wrapperClass> SpeakerWrapperList){
        List<Event_Request__c> eventRequestList = new List<Event_Request__c>();
        try{
            eventRequestList = new List<Event_Request__c>([select id,Name,Call_Note__c, Overall_Approval_Status__c, Event_Title__c,Event_Types__c,Requester__c,Request_Type__c,TimeZone__c,Speaker_Name__c,Visit_Date__c
                                                           from Event_Request__c where id = :cId]);
            SpeakerWrapperList.clear();
            for(Event_Request__c ev : eventRequestList ){
                SpeakerWrapperList.add(new MFS_Activity360GeneralUtility.wrapperClass(ev,false));
            } 
        } catch(Exception ex){
            system.debug('Exception in goToSpeakerRequest : '+ex.getStackTraceString());
            throw ex;
        }
        return SpeakerWrapperList;
    }
    
    /*
    ** Method Name     : updateSpeakerRequest
    ** Description     :  Method to update the Speaker Request 
    ** Used in         : Save button in Speaker Request PopUp screen after clicking Global Save (Activity360 page)
    */
    public static void updateSpeakerRequest(Event_Request__c speakerRequest,List<MFS_Activity360GeneralUtility.wrapperClass> SpeakerWrapperList){
        MFS_Activity360GeneralUtility.wrapperClass srwc = new MFS_Activity360GeneralUtility.wrapperClass(speakerRequest,false);
        SpeakerWrapperList.add(srwc);
    }
    
    
    /*
    ** Method Name     : deleteSpeakerRequestRecord
    ** Description     :  Method to remove the Speaker Request 
    ** Used in         :  remove hyperlink in Speaker Request Related List (Activity360 page)
    */    
    public static void deleteSpeakerRequestRecord( string individualChildRecordId, List<MFS_Activity360GeneralUtility.wrapperClass> SpeakerWrapperList,Activity_Detail__c callNote){
        List<MFS_Activity360GeneralUtility.wrapperClass> tempSpkrReqstTokeepList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        List<Event_Request__c> tempSpkrReqstToDeleteList = new List<Event_Request__c>();
        try{
            if(SpeakerWrapperList.size()>0 && individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                for(MFS_Activity360GeneralUtility.wrapperClass wc:SpeakerWrapperList){
                    if(wc.wSpeakerReq.Id != individualChildRecordId){ tempSpkrReqstTokeepList.add(wc); }
                    if(wc.wSpeakerReq.Id == individualChildRecordId){ tempSpkrReqstToDeleteList.add(wc.wSpeakerReq); }
                }
                
                /* delete only if already the parent event exsists as there is need to add the speaker request in just the memory 
				for the first time when we are creating the parent event which is not saved until global save is hit */
                if(callNote.Id!=null){
                    if(tempSpkrReqstToDeleteList.size()>0){ delete tempSpkrReqstToDeleteList; }
                }
                SpeakerWrapperList.clear();
                SpeakerWrapperList.addAll(tempSpkrReqstTokeepList);
            }
        } catch(Exception ex){
            system.debug('Exception in deleteSpeakerRequestRecord : '+ex.getStackTraceString());
            throw ex;
        }
    }
}