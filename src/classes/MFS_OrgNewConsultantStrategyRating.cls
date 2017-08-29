/***************************************************************************************************
Apex Class Name    : MFS_OrgNewConsultantStrategyRating
Version            : 1.0 
Created Date       : 21 JUL 2016
Function           : Controller for custom button to create new strategy rating from Account
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey            07/21/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_OrgNewConsultantStrategyRating {
    
    public MFS_OrgNewConsultantStrategyRating(ApexPages.StandardSetController stdCtrl) {
        
    }
    
    /**
    * @Description : Method used to redirect user to apporipate page based on Account record
    * @Param : N/A
    * @return: Nothing
    **/  
    public pagereference redirect(){
        Account acnt = [Select Id,Name from Account where Id =: ApexPages.currentPage().getParameters().get('id')];
        List<String> listOfFields=new List<String>{'Name','Consultant__c'};
        Schema.DescribeSObjectResult r = Strategy_Rating_Process__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
           PageReference url=new PageReference('/'+keyPrefix+'/e');
        try{
            Map<String,String> fieldMap=MFS_Utilities.getFieldId('Strategy_Rating_Process__c',listOfFields);           
            url.getParameters().put('returl','/'+acnt.Id);            
            url.getParameters().put(fieldMap.get(listOfFields.get(0)),acnt.Name);
            url.getParameters().put(fieldMap.get(listOfFields.get(1)),acnt.Name);
            url.getParameters().put(fieldMap.get(listOfFields.get(1))+MFS_AllConstants.LK_ID,acnt.Id);
        } catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
        System.debug('url:'+url);
        return url;
    }
    
}