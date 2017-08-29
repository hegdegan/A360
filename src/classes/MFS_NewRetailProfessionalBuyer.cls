/***************************************************************************************************
Apex Class Name    : MFS_NewRetailProfessionalBuyer
Version            : 1.0 
Created Date       : 11 Nov 2016
Function           : This is a Controller for the custom button to create new Retail Professional Buyeropportunity from Account
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta            11/11/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_NewRetailProfessionalBuyer {
    
    //Constructor
    public MFS_NewRetailProfessionalBuyer(ApexPages.StandardSetController stdCtrl){
        
    }
    
    /**
    * @Description : Method is used to construct URL for redirection
    * @Param : N/A
    * @return: PageReference
    **/  
    public PageReference redirect() {
        PageReference pageRef=new PageReference('/006/e');
        try {
            Account accRec=[Select id,Name,Distribution_Sub_Channel__c,RecordTypeId from Account where id=:ApexPages.currentPage().getParameters().get('id')];
            Id oppRecordType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(MFS_AllConstants.OPP_BUYER_RECTYPE).getRecordTypeId();           
            List<String> listOfFields=new List<String>{'Name','Account','Region'};
                Map<String,String> fieldMap=MFS_Utilities.getFieldId('Opportunity',listOfFields);           
            pageRef.getParameters().put(MFS_AllConstants.RETURN_URL,accRec.Id);
            pageRef.getParameters().put(MFS_AllConstants.RECORD_TYPE,oppRecordType);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(0)),accRec.Name);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(1)),accRec.Name);
            pageRef.getParameters().put((fieldMap.get(listOfFields.get(1)))+MFS_AllConstants.LK_ID,accRec.Id);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(2)),accRec.Distribution_Sub_Channel__c);
            system.debug('pageRef URL : '+pageRef.getUrl());
        } catch(Exception exe) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
        }
        return pageRef;
    }
    
    
}