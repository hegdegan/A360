/***************************************************************************************************
Apex Class Name    : MFS_NewRESOpportunity 
Version            : 1.0 
Created Date       : 04 May 2017
Function           : Class is used to prepopulate fields on creation of new RES Opportunity from Contact related list button.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Manoj Parida               05/04/20167             Original Version
***************************************************************************************************/
public class MFS_NewRESOpportunity {

    //Constructor
    public MFS_NewRESOpportunity(ApexPages.StandardSetController stdCtrl)
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
            Contact conRec = [Select id,Name,AccountID from Contact where Id=:ApexPages.currentPage().getParameters().get('id')];    
            Account accRec=[Select id,Name,Distribution_Sub_Channel__c,RecordTypeId from Account where Id =: conRec.AccountId];
            Id oppRecordType=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(MFS_AllConstants.OPP_RES_RECTYPE).getRecordTypeId();
            Id conRecordType=Schema.SObjectType.Contact.getRecordTypeInfosByName().get(MFS_AllConstants.CON_RETAIL_RECTYPE).getRecordTypeId();
            List<String> listOfFields=new List<String>{'Name','Client_Contact__c'};
            Map<String,String> fieldMap=MFS_Utilities.getFieldId('Opportunity',listOfFields);           
            pageRef.getParameters().put(MFS_AllConstants.RETURN_URL,conRec.Id);
            pageRef.getParameters().put(MFS_AllConstants.RECORD_TYPE,oppRecordType);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(0)),accRec.Name);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(1)),conRec.Name);
            pageRef.getParameters().put((fieldMap.get(listOfFields.get(1)))+MFS_AllConstants.LK_ID,conRec.Id);
            pageRef.getParameters().put('opp4',accRec.Name);
            pageRef.getParameters().put('opp4'+MFS_AllConstants.LK_ID,accRec.Id);
            }
            catch(Exception exe)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
            }
            return pageRef;
        }
    
}