/***************************************************************************************************
Apex Class Name    : MFS_RequestToJoinMFSTeam 
Version            : 1.0 
Created Date       : 10 August 2016
Function           : Class is used to prepopulate fields click of 'Request to Join MFS Team' button from contact related list
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               10/08/2016              Original Version
***************************************************************************************************/

public with sharing class MFS_RequestToJoinMFSTeam {
    //Constructor
    public MFS_RequestToJoinMFSTeam(ApexPages.StandardSetController stdCtrl){
        
    }
    
    /**
    * @Description : Method is used to construct URL for redirection
    * @Param : N/A
    * @return: PageReference
    **/     
    public PageReference redirect(){
        PageReference pageRef=new PageReference('/500/e');
        try {
            AcctTeamAppCustomSettings__c settings = AcctTeamAppCustomSettings__c.getinstance('Default');    
            Contact contactRec=[Select id,Name,Account.Id,Account.Name from Contact where id=:ApexPages.currentPage().getParameters().get('id')];          
            Id caseRecordType=Schema.SObjectType.Case.getRecordTypeInfosByName().get(MFS_AllConstants.Case_TM_RECTYPE).getRecordTypeId();
            List<String> listOfFields=new List<String>{'Contact','Subject','Account','Team_Member__c','Requester__c','Service_Request_Type__c','Sub_Type1__c'};
                Map<String,String> fieldMap=MFS_Utilities.getFieldId('Case',listOfFields);           
            pageRef.getParameters().put(MFS_AllConstants.RETURN_URL,contactRec.Id);
            pageRef.getParameters().put(MFS_AllConstants.RECORD_TYPE,string.valueof(settings.RecordType_Approval__c));
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(0)),contactRec.Name);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(0))+MFS_AllConstants.LK_ID,contactRec.Id);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(1)),Label.Territory_Management_Request);
            pageRef.getParameters().put((fieldMap.get(listOfFields.get(2)))+MFS_AllConstants.LK_ID,contactRec.Account.Id);
            pageRef.getParameters().put((fieldMap.get(listOfFields.get(2))),contactRec.Account.Name);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(3))+MFS_AllConstants.LK_ID,UserInfo.getUserId());
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(3)),UserInfo.getName());
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(4))+MFS_AllConstants.LK_ID,UserInfo.getUserId());
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(4)),UserInfo.getName());
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(5)),System.Label.CT_Choose_Type);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(6)),System.Label.CT_Choose_Sub_Type);
        } catch(Exception exe) {
            system.debug('exe:'+exe.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
        }
        return pageRef;
    }
    
    
}