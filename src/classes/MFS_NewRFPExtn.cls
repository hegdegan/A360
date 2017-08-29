/***************************************************************************************************
Apex Class Name    : MFS_NewRFPExtn
Version            : 1.0 
Created Date       : 8 Sep 2016
Function           : This is a Controller for the custom button to create new RFP from opportunity
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Manoj Parida           8/9/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_NewRFPExtn {
    
    public MFS_NewRFPExtn(ApexPages.StandardSetController stdCtrl){
        
    }
    
    public PageReference redirect(){ 
        PageReference pageRef;
        Opportunity opp;
        Case cse;
        String id = ApexPages.currentPage().getParameters().get('id');
        try {
            if(id!=null && id.startsWith('006')){
                opp = [select id, name, account.id, account.name, owner.id, owner.name from opportunity where id=:ApexPages.currentPage().getParameters().get('id')];
            }else{
                cse = [select id, caseNumber, accountid, account.name, owner.id, owner.name from Case where id=:ApexPages.currentPage().getParameters().get('id')];
            }
            
            
            List<String> listOfFields=new List<String>{'Service_Request__c','Org_Name__c','Sales_Person_Relationship_Manager__c',
                'Business_Type__c','Secondary_MFS_Contact__c','Opportunity__c'};
                Map<String,String> fieldMap=MFS_Utilities.getFieldId('PMAPS__c',listOfFields);
            system.debug('fieldMap====='+fieldMap);
            Schema.DescribeSObjectResult r = PMAPS__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();			
            pageRef=new PageReference('/'+keyPrefix+'/e');
            if(opp != null && id!=null && id.startsWith('006')){
                pageRef.getParameters().put('retURL',opp.Id);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(5)),opp.Name);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(5))+'_lkid',opp.Id);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(1)),opp.account.name);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(1))+'_lkid',opp.accountid);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(2)),opp.owner.name);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(3)),'New Business');
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(4)),UserInfo.getName());
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(4))+'_lkid',UserInfo.getUserId()); 
            }else{
                pageRef.getParameters().put('retURL',cse.Id);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(0)),cse.caseNumber);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(0))+'_lkid',cse.Id);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(1)),cse.account.name);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(1))+'_lkid',cse.accountid);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(2)),cse.owner.name);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(3)),'New Business');
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(4)),UserInfo.getName());
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(4))+'_lkid',UserInfo.getUserId()); 
            }
            
        } catch(Exception e){
            system.debug('Exception in redirect : MFS_NewRFPExtn  '+e.getMessage()+e.getLineNumber()+e.getStackTraceString());
        }
        return pageRef;
    }
    
}