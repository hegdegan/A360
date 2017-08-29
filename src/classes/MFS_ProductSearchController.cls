/***************************************************************************************************
Apex Class Name    : MFS_ProductSearchController 
Version            : 1.0 
Created Date       : 03 MAY 2016
Function           : Class is Used to search product based on user input & insert selected products as opportunity line item to corresponding opportunity.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               03/05/2016              Original Version
***************************************************************************************************/

public with sharing class MFS_ProductSearchController {    
    public String searchOpt{
        set{searchOpt=value;}
        get{return searchOpt;}
    }
    public Opportunity theOpp {get;set;}
    public opportunityLineItem[] oppLineItems {get;set;} 
    public List<wrapper> wraplist{get;set;}    
    public String toSelect {
        get{return toSelect;}
        set{toSelect=value;}
    }
    public String toUnselect {
        get{return toUnselect;}
        set{toUnselect=value;}
    }
    public String selectedAssetGeography{
        get{return selectedAssetGeography;}
        set{selectedAssetGeography=value;}
    }
    public String selectedVehicle{
        get{return selectedVehicle;}
        set{selectedVehicle=value;}
    }     
    private Boolean isCustomFeeType=false;
    private Set<id> existingProdId;
    private static String defaultUserVehicle;
    
    
    //Constructor
    public MFS_ProductSearchController (ApexPages.StandardController controller) {
        try {
            
            theOpp = [select Id,Name, Pricebook2Id,PriceBook2.Name,StageName,CurrencyISOCode from Opportunity where Id = :String.escapeSingleQuotes(controller.getRecord().Id)];
            if (theOpp != null)
                oppLineItems = [select Id,PricebookEntryId,Product_Name__c,Is_Unknown__c,Asset_Class_Geography__c,UnitPrice ,Approval_Status__c,Discount__c,Fee_Structure__c,Product_Vehicle__c,Restricted__c,Share_Class__c,Portfolio_Name__c,Product_Record_Type__c  from opportunityLineItem where (OpportunityId=:theOpp.Id  )];
        	User usr = [select Vehicle__c from User where id = :UserInfo.getUserId()];
            selectedVehicle = usr.Vehicle__c;
        	searchProduct();
        }
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
        }
    }
    
    
    /**
* @Description : Method is used to search products based on user input
* @Param : N/A
* @return: Nothing
**/
    public void searchProduct (){
        try { 
            existingProdId=getExistingPBEntryId();
            wraplist = new List<wrapper>();            
            String query=constructQuery(searchOpt,selectedAssetGeography,selectedVehicle);
            System.debug('query:'+query);
            List<PricebookEntry> pList=Database.query(query);                
            for(PricebookEntry pbRec:pList){                  
                if(!existingProdId.contains(pbRec.Id)){    
                    wrapper w= new wrapper();           
                    w.prg=pbRec;       
                    w.Pricebookid=pbRec.Pricebook2.ID;
                    wraplist.add(w); 
                }
            }
            
        }
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
        }
    }
    
    /**
* @Description : Method is used to fetch price book entry id for opportunity line items
* @Param : N/A
* @return: Set<Id>
**/
    
    private Set<id> getExistingPBEntryId()
    {
        Set<id> existingProdIds=new Set<id>();
        try{       
            for(opportunityLineItem oppLIRec:oppLineItems)
            {
                existingProdIds.add(oppLIRec.PricebookEntryId);
            }     
        }
        catch(Exception e)
        {
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
            
        }
        return existingProdIds;
    }
    
    /**
* @Description : Method is used to construct query based on user input
* @Param : Product Name,,Product Vehicle,Product Geography
* @return: String
**/
    
    private  String constructQuery(String productName,String productGeography,String productVehicle)
    {
        String query='Select Id,Name,Strategy_Name__c,Portfolio_Name__c,Asset_Class_Geography__c,Product_Vehicle__c,Restricted__c,Pricebook2.Id,Product_Record_Type__c from PricebookEntry where IsActive=true and Is_Unknown__c =false and Restricted__c=false and CurrencyISOCode='+'\''+theOpp.CurrencyISOCode+'\' '; // Restricted__c=false filter is added to query on 08/feb/2017
        
        if(productName!='' && productName!=null)
        {
            
            query=query+'AND (Strategy_Name__c like '+'\'%'+String.escapeSingleQuotes(productName)+ '%\''+' OR Portfolio_Name__c like '+'\'%'+String.escapeSingleQuotes(productName)+ '%\''+')';
        }
        
        if(productGeography!='None' && productGeography!=null)
        {
            query=query+'AND Asset_Class_Geography__c ='+'\''+String.escapeSingleQuotes(productGeography)+'\'';
        }
        if(productVehicle!='None' && productVehicle!=null)
        {
            query=query+'AND Product2.Vehicle__c='+'\''+String.escapeSingleQuotes(productVehicle)+'\'';
            
        }       
        query=query+'ORDER BY Product_Record_Type__c, Strategy_Name__c, Portfolio_Name__c, Product_Vehicle__c ASC limit 50'; //Limit is changed to 50 on 01/Feb/2017
        return query;
    }
    /**
* @Description : Method runs when a user hits "remove" on an item in the "Selected Products" section
* @Param : N/A
* @return: Nothing
**/
    
    public PageReference removeFromLineItem(){
        try {
            Integer count = 0;   
            for(opportunityLineItem removeItem : oppLineItems){
                if((String)removeItem.PriceBookEntryId==toUnselect){
                    
                    if(removeItem.is_first_strategy__c && oppLineItems.size()>1)
                    {
                        opportunityLineItem oppLI=  oppLineItems.get(count+1);
                        oppLI.is_first_strategy__c=true; 
                    }
                    oppLineItems.remove(count);
                    break;
                }
                count++;
            }        
            searchProduct ();        
            
        }
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
            
        }
        return null;
    }
    
    /**
* @Description : Method runs when a user hits "select" button next to a product
* @Param : N/A
* @return: Nothing
**/
    
    public void addToLineItem(){
        try {
            Integer i=0;
            for(wrapper d : wraplist ){
                System.debug('toSelect:'+toSelect);
                if((String)(d.prg.Name)==toSelect)
                {
                    System.debug('prgName:'+d.prg.Name);
                    OpportunityLineItem addItem = new OpportunityLineItem();
                    addItem.OpportunityId= theopp.Id;
                    addItem.Product_Name__c=d.prg.Strategy_Name__c;
                    addItem.Portfolio_Name__c=d.prg.Portfolio_Name__c;
                    addItem.PriceBookEntryId=d.prg.ID; 
                    addItem.Product_Record_Type__c=d.prg.Product_Record_Type__c;
                    addItem.Quantity = 1;   
                    addItem.Asset_Class_Geography__c = d.prg.Asset_Class_Geography__c;  
                    addItem.Product_Vehicle__c=d.prg.Product_Vehicle__c;
                    addItem.Restricted__c=d.prg.Restricted__c;
                    addItem.Approval_Status__c=MFS_AllConstants.DEFAULT_APP_STATUS;    
                    addItem.Fee_Structure__c= MFS_AllConstants.FEE_TYPE_STD;
                    addItem.Is_Unknown__c=false;
                    addItem.UnitPrice=0;
                    System.debug('addItem:'+addItem);
                    if(oppLineItems.size()==0)
                    {
                        addItem.is_first_strategy__c=true;  
                    }
                    oppLineItems.add(addItem);
                    wraplist.remove(i);                 
                    break;
                }                 
                i++;
                
            }           
            
        }
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
        }
    }
    
    /**
* @Description : Method is used to insert opportunity line items for selected products.
* @Param : N/A
* @return: PageReference
**/
    public PageReference onSave(){
        PageReference pageRef;
        try{
            for(OpportunityLineItem oli : oppLineItems){  
                System.debug('oli:'+oli);
                if(oli.Approval_Status__c==MFS_AllConstants.DEFAULT_APP_STATUS && oli.Fee_Structure__c==MFS_AllConstants.FEE_TYPE_CUSTOM )            
                {
                    isCustomFeeType=true;
                }
                else
                {
                    
                    if((MFS_AllConstants.FEE_TYPE_STD).equals(oli.Fee_Structure__c))
                    {
                        oli.Approval_Status__c=MFS_Allconstants.DEFAULT_STD_APP_STATUS; 
                    }
                }
                
            }       
            upsert oppLineItems; 
            if(isCustomFeeType){
                pageRef=    new PageReference('/apex/MFS_ProductApprovalPage?id='+theOpp.ID);
                pageRef.setRedirect(true);
            } else {
                pageRef= new PageReference(MFS_AllConstants.SLASH+theOpp.ID);
            }
        }
        catch(DMLException dexe)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,dexe.getDmlMessage(0)));
            System.debug('Exception Occured:'+dexe.getMessage()+dexe.getLineNumber());
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));  
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
        }  
        
        // After save return the user to the Opportunity 
        
        return pageRef;
        
    }
    
    /**
* @Description :Cancel method to return user to original opportunity record
* @Param : N/A
* @return: PageReference
**/
    public PageReference onCancel(){
        return new PageReference(MFS_AllConstants.SLASH + theOpp.ID);
    }
    
    /**
* @Description : Method is used to add unknown strategy 
* @Param : N/A
* @return: PageReference
**/
    
    public PageReference addUnknownStrategy(){
        try{
            if(selectedAssetGeography!='None' && selectedAssetGeography!=null){
                PricebookEntry unknown=[Select id,Product2.Name,Asset_Class_Geography__c,Product_Vehicle__c,Restricted__c from PricebookEntry where Is_Unknown__c=true limit 1];
                OpportunityLineItem addItem = new OpportunityLineItem();
                addItem.OpportunityId= theopp.Id;
                addItem.Product_Name__c=unknown.Product2.Name;
                addItem.PriceBookEntryId=unknown.id;                    
                addItem.Quantity = 1;   
                addItem.Asset_Class_Geography__c = selectedAssetGeography;  
                addItem.Product_Vehicle__c=selectedVehicle;
                addItem.Restricted__c=unknown.Restricted__c;
                addItem.Fee_Structure__c=MFS_AllConstants.FEE_TYPE_STD;
                addItem.UnitPrice=0;  
                addItem.Is_Unknown__c=true;       
                if(oppLineItems.size()==0)
                {
                    addItem.is_first_strategy__c=true;  
                }
                oppLineItems.add(addItem);   
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.UnknownStrategyRequiredField));
            }
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));  
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber()); 
        }
        return null;
    }
    
    
    /**
* @Description :Wrapper class to display data on page
**/
    
    public class wrapper{
        public PricebookEntry prg {get;set;}
        public Id Pricebookid{get;set;}
        
    }
    /**
* @Description : Method is used to get Asset Class-Geography picklist from Product2 object
* @Param : N/A
* @return: List<Selectoption>
**/
    public List<Selectoption> getGeograhpyOptions(){
        List<Selectoption>  prodGeograhpy=new List<Selectoption> ();
        prodGeograhpy.add(new SelectOption(MFS_AllConstants.PICKLIST_DEFAULT,'---'+MFS_AllConstants.PICKLIST_DEFAULT+'---'));        
        map<String, Schema.SObjectField> fieldMap = Product2.getSObjectType().getDescribe().fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get(MFS_AllConstants.PRODUCT_GEOGRAPHY).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values)
        { 
            prodGeograhpy.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return prodGeograhpy;
    }
    
    /**
* @Description : Method is used to get Vehicle picklist from Product2 object
* @Param : N/A
* @return: List<Selectoption>
**/    
    public List<Selectoption> getVehicleOptions(){
        List<Selectoption>  prodVehicleList=new List<Selectoption> ();
        try{
            prodVehicleList.add(new SelectOption(MFS_AllConstants.PICKLIST_DEFAULT,'---'+MFS_AllConstants.PICKLIST_DEFAULT+'---'));
            Schema.sObjectType objType = Product2.getSObjectType(); 
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            list<Schema.PicklistEntry> values =     fieldMap.get(MFS_AllConstants.PRODUCT_VEHICLE).getDescribe().getPickListValues();
            for (Schema.PicklistEntry a : values)
            { 
                prodVehicleList.add(new SelectOption(a.getLabel(), a.getValue())); 
            }
            return prodVehicleList;
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));  
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber()); 
        }
        return prodVehicleList; 
    }
    
}