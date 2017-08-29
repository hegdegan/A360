/***************************************************************************************************
Apex Class Name    : MFS_ChatterController
Version            : 1.0 
Created Date       : 1 Nov 2016
Function           : This is a Controller to search competitor product to add to opportunity
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Abhshek Tripathi            11/01/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_CompetitorSearchController {
    
    public List<wrapper> wraplist{get;set;}    
    
    
    //Adde by Abhishek
    private Set<id> existingProdId;
    public Opportunity theOpp {get;set;}
    public String recId {get;set;}
    public String searchCom{
        set{searchCom=value;}
        get{return searchCom;}
    }
    
    public String firm{
        set{firm=value;}
        get{return firm;}
    } 
    
    
    //Constructor
    public MFS_CompetitorSearchController (ApexPages.StandardController controller) {
        recId = Apexpages.currentPage().getParameters().get('addTo');
    }
    
    
    /**
* @Description :Cancel method to return user to original opportunity record
* @Param : N/A
* @return: PageReference
**/
    public PageReference onCancel(){
        return new PageReference(MFS_AllConstants.SLASH + theOpp.ID);
    }
    
    public void searchComProduct(){
        try { 
           
            wraplist = new List<wrapper>();            
            String query=constructQueryCom(searchCom,firm);
            System.debug('query:'+query);
            List<Competitor_Product__c> pList=Database.query(query);                
            for(Competitor_Product__c pbRec:pList){                  
                wraplist.add( new wrapper(false, pbRec)); 
            }
        }
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
        }
    }
    
    
    //COMPETITOR QUERY
    private  String constructQueryCom(String productName,String firm)
    {
        String query='Select Id, Name, Firm_Name__c, Ticker__c from Competitor_Product__c where ';// Firm__r.Name is replaced with Firm_Name__c on 08/Feb/2017 for UAT Defect
        
        if(productName!='' && productName!=null){
            query=query+' Name like '+'\'%'+String.escapeSingleQuotes(productName)+ '%\' AND ';
        }
        
        if(firm!='' && firm!=null){
            query=query+' Firm_Name__c like '+'\'%'+String.escapeSingleQuotes(firm)+ '%\' AND '; // Firm__r.Name is replaced with Firm_Name__c on 08/Feb/2017 for UAT Defect
        }
        
        
        if(query.EndsWith('where ')) {
            query = query.removeEnd('where ');
        }
        
        if(query.EndsWith('AND ')) {
            query = query.removeEnd('AND ');
        }
        
        query=query+' ORDER BY Name ASC Limit 25';
        
        System.debug('query:::::::' +query);
        return query;
    }
    
    /**
* @Description : Method is used to add unknown strategy 
* @Param : N/A
* @return: PageReference
**/
    
    public PageReference addUnknownStrategy(){
        try{
            
            if(wraplist.size() > 0) {
                
                Id oppId = Apexpages.currentPage().getParameters().get('addTo');
                System.debug('oppId:::::::;' + oppId);
        		List<Competitor_Product_Opp_Association__c> compList = new List<Competitor_Product_Opp_Association__c>();
                    
                System.debug('wraplist:::::::;' + wraplist.size());
        		
                for(Wrapper wre : wraplist) {
                
                    if(wre.isSelected) {
                        System.debug('oppId:::::::;' + wre.isSelected);
        		
                        Competitor_Product_Opp_Association__c cpoA = new Competitor_Product_Opp_Association__c();
                        cpoA.Competitor_Product__c = wre.comp.Id;
                        cpoA.Opportunity__c = oppId;
                        compList.add(cpoA);
                    }
                }
                
                System.debug('compList:::::::;' + compList);
        		
				//Check for list
                if(compList.size() > 0) {
                    insert compList;
                    
                    PageReference pf=  new PageReference('/'+oppId);
        			return pf;
                }
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
        public Boolean isSelected { get; set; }
        public Competitor_Product__c comp { get; set; }
        
        //For Competitor
        public wrapper( Boolean slct, Competitor_Product__c pr) {
            this.comp = pr;
            this.isSelected = slct;
        }
    }
    
}