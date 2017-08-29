/***************************************************************************************************
Apex Class Name    : MFS_SubmitHelpTicketExt
Version            : 1.0 
Created Date       : 7 Oct 2016
Function           : Controller for custom button to create help ticket
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey            10/7/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_SubmitHelpTicketExt {
    Private Account acnt;
    //Constructor
    public MFS_SubmitHelpTicketExt(ApexPages.StandardController controller){
        try{
            acnt = [Select Id,Name from Account where Id =: controller.getRecord().Id];
        } catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
    }
    
    /**
    * @Description : Method used to redirect user to apporipate page based on Account record
    * @Param : N/A
    * @return: Pagereference
    **/  
    public pagereference redirect(){
        List<String> listOfFields=new List<String>{'Requester__c','Account','Type__c','Sub_Type1__c'};
        Pagereference url=new pageReference('/500/e?');
        try{
            Map<String,String> fieldMap=MFS_Utilities.getFieldId('Case',listOfFields);   
            Id caseRecordType=Schema.SObjectType.Case.getRecordTypeInfosByName().get(MFS_AllConstants.Case_TM_RECTYPE).getRecordTypeId();
            url.getParameters().put('returl','/'+acnt.Id);            
           /// url.getParameters().put('recordType','/'+acnt.Id);
            url.getParameters().put(MFS_AllConstants.RECORD_TYPE,caseRecordType);
            url.getParameters().put(fieldMap.get(listOfFields.get(0))+MFS_AllConstants.LK_ID,UserInfo.getUserId());
            url.getParameters().put(fieldMap.get(listOfFields.get(0)),UserInfo.getName());
            url.getParameters().put((fieldMap.get(listOfFields.get(1)))+MFS_AllConstants.LK_ID,acnt.Id);
            url.getParameters().put((fieldMap.get(listOfFields.get(1))),acnt.Name);
            
        } catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
        System.debug('url:'+url);
        return url;
    }
    
}