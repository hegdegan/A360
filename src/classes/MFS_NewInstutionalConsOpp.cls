/***************************************************************************************************
Apex Class Name    : MFS_NewInstutionalConsOpp 
Version            : 1.0 
Created Date       : 08 August 2016
Function           : Class is used to prepopulate fields on creation of new Opportunity from Account related list button.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               08/08/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_NewInstutionalConsOpp {  

    //Constructor
    public MFS_NewInstutionalConsOpp(ApexPages.StandardSetController stdCtrl)
        {
            
        }
    
/**
* @Description : Method is used to construct URL for redirection
* @Param : N/A
* @return: PageReference
**/  
    public PageReference redirect()
        {
             PageReference pageRef=new PageReference('/006/e');
            try{
            Account accRec=[Select id,Name,Distribution_Sub_Channel__c,RecordTypeId from Account where id=:ApexPages.currentPage().getParameters().get('id')];
            Id oppRecordType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(MFS_AllConstants.OPP_INS_RECTYPE).getRecordTypeId();
            Id accRecordType=Schema.SObjectType.Account.getRecordTypeInfosByName().get(MFS_AllConstants.ACC_CLIENT_RECTYPE).getRecordTypeId();
            List<String> listOfFields=new List<String>{'Name','Account','Region','Is_Consultant__c'};
            Map<String,String> fieldMap=MFS_Utilities.getFieldId('Opportunity',listOfFields);           
            pageRef.getParameters().put(MFS_AllConstants.RETURN_URL,accRec.Id);
            pageRef.getParameters().put(MFS_AllConstants.RECORD_TYPE,oppRecordType);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(0)),accRec.Name);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(1)),accRec.Name);
            pageRef.getParameters().put((fieldMap.get(listOfFields.get(1)))+MFS_AllConstants.LK_ID,accRec.Id);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(2)),accRec.Distribution_Sub_Channel__c);
            if(accRecordType.equals(accRec.RecordTypeId))
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(3)),'No');
            }
            catch(Exception exe)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
            }
            return pageRef;
        }
    

}