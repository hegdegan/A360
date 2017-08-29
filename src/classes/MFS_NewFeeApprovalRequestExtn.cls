/***************************************************************************************************
Apex Class Name    : MFS_CustomButtonUtilities
Version            : 1.0 
Created Date       : 31 Aug 2016
Function           : This is a Controller for custom button to initiate a new fee approval request from Business at Risk
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* MAhesh Selvaraj            8/31/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_NewFeeApprovalRequestExtn {
    //Constructor
    public MFS_NewFeeApprovalRequestExtn(ApexPages.StandardSetController stdCtrl)
    {
        
    }
    
    public PageReference redirect(){ 
        PageReference pageRef;
        try{
        Business_At_Risk__c [] bars = [select id, name from Business_At_Risk__c where id=:ApexPages.currentPage().getParameters().get('id')];
        Business_At_Risk__c bar;
        if(bars.size()>0) {bar=bars[0];}
        Id appReq = [select id from RecordType where name = 'Fee Approval Request'].id;
        List<String> listOfFields=new List<String>{'Business_At_Risk__c'};
        Map<String,String> fieldMap=MFS_Utilities.getFieldId('Approval_Request__c',listOfFields);
        Schema.DescribeSObjectResult r = Approval_Request__c.sObjectType.getDescribe();
		String keyPrefix = r.getKeyPrefix();    
        pageRef=new PageReference('/'+keyPrefix+'/e');
        pageRef.getParameters().put('retURL',bar.Id);
        pageRef.getParameters().put('RecordType',appReq);
        pageRef.getParameters().put(fieldMap.get(listOfFields.get(0)),bar.Name);
        pageRef.getParameters().put(fieldMap.get(listOfFields.get(0))+'_lkid',bar.id);
        }catch(Exception e){
          system.debug('Exception in redirect : MFS_NewFeeApprovalRequestExtn  '+e.getMessage());      
        }
        return pageRef;
    }
    
}