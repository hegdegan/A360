/***************************************************************************************************
Apex Class Name    : MFS_ProductApproval 
Version            : 1.0 
Created Date       : 01 June 2016
Function           : Class is used to insert Fee approval request for each custom opportunity line items & submit these to approval process.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               01/06/2016              Original Version
* Priya Gupta				30/08/2016				Object API Name changed from  Fee_Approval_Request__c to Approval_Request__c
***************************************************************************************************/

public with sharing class MFS_ProductApproval {
    
    
    public opportunityLineItem[] oppLineItems {get;set;}
    private Map<Id,opportunityLineItem> oppLMap=new Map<Id,opportunityLineItem>();    
    public Id toSelect{get;set;}    
    public Approval_Request__c feeAppRec{get;set;}
    public Opportunity oppRec;
    
    //Constructor
    public MFS_ProductApproval (ApexPages.StandardController controller) {
        try {   
             oppRec =[Select id,CurrencyIsoCode from Opportunity where id=:String.escapeSingleQuotes(controller.getRecord().Id)];            
            if (oppRec != null)
            {  oppLineItems=[select Fee_Structure__c,Approval_Status__c,
                             Approval_Needed__c,Id,Product_Name__c,
                             UnitPrice , PriceBookEntry.Product2Id,
                             PriceBookEntry.Product2.Name,
                             PriceBookEntry.PriceBook2Id,Asset_Class_Geography__c,Product_Vehicle__c,Restricted__c,Portfolio_Name__c
                             from opportunityLineItem 
                             where (OpportunityId=:oppRec.Id and Fee_Structure__c='Custom' and Approval_Status__c='Not Started' )];
             
             for(opportunityLineItem oppLRec:oppLineItems)
             {
                 oppLMap.put(oppLRec.id,oppLRec);                 
                 
             }             
            }
        }
        
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
        }
    }
    
/**
* @Description : Method is used to add fee approval details for opportunity products
* @Param : N/A
* @return: Nothing
**/  
   
    public void refreshPage()
    {   
        Id recordTypeId=Schema.SObjectType.Approval_Request__c.getRecordTypeInfosByName().get(MFS_AllConstants.APPROVAL_REQUEST_RT).getRecordTypeId();
        feeAppRec=new Approval_Request__c(); 
        feeAppRec.CurrencyIsoCode=oppRec.CurrencyIsoCode;
        feeAppRec.RecordTypeId=recordTypeId;
        
    }
    
    /**
* @Description : Method is used to insert fee approval record & submit it to approval process.
* @Param : N/A
* @return: PageReference
**/
    
    public PageReference submitForApproval(){
        try{  
            
            OpportunityLineItem oppLineItem=oppLMap.get(toSelect);
            feeAppRec.Opportunity__c=oppRec.Id;
            feeAppRec.Opportunity_Product__c=oppLineItem.Product_Name__c;             
            feeAppRec.Opportunity_Product_Price__c=oppLineItem.UnitPrice;
            feeAppRec.Opportuinty_ProductId__c=oppLineItem.id;
            feeAppRec.Portfolio_Name__c=oppLineItem.Portfolio_Name__c;
            insert feeAppRec; 
            Approval.ProcessSubmitRequest appReq=new Approval.ProcessSubmitRequest();
            appReq.setObjectId(feeAppRec.id);
            Approval.ProcessResult appResult=Approval.process(appReq);   
            if(appResult.isSuccess())
            {
                oppLineItem.Approval_status__c=MFS_AllConstants.STATUS_PENDING;
                update oppLineItem;
            }
        }
        catch(Exception exe)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
            System.debug('Exception Occured:'+exe.getMessage() +exe.getLineNumber());
        }
        return null;
    }
    
/**
* @Description : Method is used to return to opportunity detail page.
* @Param : N/A
* @return: PageReference
**/
    public PageReference goBack(){
        return new PageReference(MFS_AllConstants.SLASH+oppRec.Id);
    }
    
}