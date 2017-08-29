/***************************************************************************************************
Apex Class Name    : MFS_CloneExtn 
Version            : 1.0 
Created Date       : 17 August 2016
Function           : Class is used to clone an Campaign
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey               17/8/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_CloneExtn {
    Private Campaign camp;
    //Constructor
    public MFS_CloneExtn(ApexPages.StandardController stdCtrl)
    {
        try{
        camp = [select Id,Name,RecordTypeId from campaign where id =: stdCtrl.getRecord().Id];
        }Catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
    }
     /**
* @Description : Method used to redirect user to Campaign Page
* @Param : N/A
* @return: PageReference
**/   
    public PageReference redirect(){ 
        PageReference pageRef;
        try{
            List<String> listOfFields=new List<String>{'Original_Campaign__c'};
            Map<String,String> fieldMap=MFS_Utilities.getFieldId('Campaign',listOfFields);
            pageRef=new PageReference('/'+camp.Id+'/e?clone=1');
            pageRef.getParameters().put('retURL','/'+camp.Id);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(0)),camp.Name);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(0))+MFS_AllConstants.LK_ID,camp.Id);
          }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
        return pageRef;
    }
    
}