/***************************************************************************************************
Apex Class Name    : MFS_NewClientInvestmentObj 
Version            : 1.0 
Created Date       : 09 August 2016
Function           : Class is used to prepopulate fields on creation of new client investment record from strategy Plan related list button.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               09/08/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_NewClientInvestmentObj {
    
//Constructor 
    public MFS_NewClientInvestmentObj(ApexPages.StandardSetController stdCtrl)
        {
            
        }
  
/**
* @Description : Method is used to construct URL for redirection
* @Param : N/A
* @return: PageReference
**/    
    public PageReference redirect()
        {
            Schema.DescribeSObjectResult r = Client_Investment_Objective__c.sObjectType.getDescribe();
			String keyPrefix = r.getKeyPrefix();	
             PageReference pageRef=new PageReference('/'+keyPrefix+'/e');
            try{
                Strategy_Plan__c strategyPlan=[Select id,Name, Organization__r.Id,Organization__r.Name from Strategy_Plan__c where id=:ApexPages.currentPage().getParameters().get('id')];
                List<String> listOfFields=new List<String>{'Client_Strategy_Plan__c','Organization__c'};
                Map<String,String> fieldMap=MFS_Utilities.getFieldId('Client_Investment_Objective__c',listOfFields);   
                pageRef.getParameters().put('retURL',strategyPlan.id);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(0)),strategyPlan.Name);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(0))+MFS_AllConstants.LK_ID,strategyPlan.Id);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(1)),strategyPlan.Organization__r.Name);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(1))+MFS_AllConstants.LK_ID,strategyPlan.Organization__r.Id);
                system.debug('pageRef:'+pageRef);
            }
            catch(Exception exe)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
            }
            return pageRef;


        }}