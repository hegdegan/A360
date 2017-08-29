/***************************************************************************************************
Apex Class Name    : MFS_ContactSalesSummaryCount
Version            : 1.0 
Created Date       : 10 Oct 2016
Function           : This is a Controller for custom button to submit help ticket on Case
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey            10/11/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_ContactSubmitHelpTicketExt {
Private Contact cntct;
    //Constructor
    public MFS_ContactSubmitHelpTicketExt(ApexPages.StandardController controller){
        try{
            cntct = [Select Id,Name,Account.Id,Account.Name from Contact where Id =: controller.getRecord().Id];
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
    }
    
    /**
* @Description : Method used to redirect user to apporipate page based on Contact record
* @Param : N/A
* @return: Pagereference
**/  
    public pagereference redirect(){
        List<String> listOfFields=new List<String>{'Requester__c','Organization__c','Contact'};
        Pagereference url=new pageReference('/500/e?');
        try{
            Map<String,String> fieldMap=MFS_Utilities.getFieldId('Case',listOfFields);   
            Id caseRecordType=Schema.SObjectType.Case.getRecordTypeInfosByName().get(MFS_AllConstants.Case_TM_RECTYPE).getRecordTypeId();
            url.getParameters().put('returl','/'+cntct.Id);            
            url.getParameters().put(MFS_AllConstants.RECORD_TYPE,caseRecordType);
            url.getParameters().put(fieldMap.get(listOfFields.get(0))+MFS_AllConstants.LK_ID,UserInfo.getUserId());
            url.getParameters().put(fieldMap.get(listOfFields.get(0)),UserInfo.getName());
            url.getParameters().put((fieldMap.get(listOfFields.get(1)))+MFS_AllConstants.LK_ID,cntct.Account.Id);
            url.getParameters().put((fieldMap.get(listOfFields.get(1))),cntct.Account.Name);
            url.getParameters().put((fieldMap.get(listOfFields.get(2)))+MFS_AllConstants.LK_ID,cntct.Id);
            url.getParameters().put((fieldMap.get(listOfFields.get(2))),cntct.Name);
        } 
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
         return url;
    }
}