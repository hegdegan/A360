/***************************************************************************************************
Apex Class Name    : MFS_NewRequestedSpeakerExt
Version            : 1.0 
Created Date       : 22 Sep 2016
Function           : This is a Controller for the custom button to create new requested speaker
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey            9/22/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_NewRequestedSpeakerExt {
    
    //Private Event_Request__c er;
    public MFS_NewRequestedSpeakerExt(ApexPages.StandardsetController controller){
        
    }
    
    public PageReference redirect(){ 
        PageReference pageRef;
        try {
            String dtString;
            String enddtDtring;
            Event_Request__c er = [select id, Name,Start_Date__c, End_Date__c from Event_Request__c where id=:ApexPages.currentPage().getParameters().get('id')];
            List<String> listOfFields=new List<String>{'Speaker_Request__c','Time_Slot_Start__c','Time_Slot_End__c'};
                Map<String,String> fieldMap=MFS_Utilities.getFieldId('Event_Relation__c',listOfFields);
            Schema.DescribeSObjectResult r = Event_Relation__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            pageRef=new PageReference('/'+keyPrefix+'/e');
            pageRef.setRedirect(true);
            pageRef.getParameters().put('retURL',er.Id);
            if(er.Start_Date__c != null )
                dtString = er.Start_Date__c.format('MM/dd/YYYY hh:mm a');
            if(er.End_Date__c != null)
                enddtDtring = er.End_Date__c.format('MM/dd/YYYY hh:mm a');
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(0)),er.Name);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(0))+'_lkid',er.Id);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(1)),dtString);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(2)),enddtDtring);
        } catch(Exception e){
            system.debug('Exception in redirect : '+e.getMessage());
        }
        return pageRef;
    }
    
}