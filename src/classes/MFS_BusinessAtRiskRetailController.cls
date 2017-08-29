/***************************************************************************************************
Apex Class Name    : MFS_BusinessAtRiskRetailController
Version            : 1.0 
Created Date       : 12 AUG 2016
Function           : This is a Controller for MFS_BusinessatRiskReatil Page
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            08/12/2016              Original Version
***************************************************************************************************/
global with sharing class MFS_BusinessAtRiskRetailController {
    
    public static final String TOTAL_API_START = 'Total_';
    public static final String RET_URL = 'retURL';
    //Controller constants
    public static final String API_NAME_START = 'AUM_';
    public static final String API_NAME_END = '__c';
    public static final String PAGE_TYPE = 'type';
    public static final String DETAIL = 'detail';
    public static final String EDIT = 'edit';
    public static final String RECORD_ID = 'id';
    public static final String VALUE_TRUE = 'true';
    public static final String VALUE_FALSE = 'false';
    public static final String ACCOUNT = 'account';
    private static final String RETAIL = 'Retail';
    private static final String CURRENCY_USD = 'USD';
    private static final MAP<String, String> CURRENCYMAP = new Map<String, String>
    {'AUD' => 'AUD', 'CAD' => 'CAD', 'EUR' => 'EUR', 'JPY' => 'JPY','SGD' => 'SGD', 'USD' => 'USD', 'GBP' => 'GBP'};
        
        //Contoller variables
        @testVisible private Business_at_Risk__c bar;
    private Account acc;
    public List<Portfolio> portFolioLst { get; set; }
    public String changedRow{get;set;}
    public STring userCurrency{get;set;}
    public String AUMUserCurrency{get;set;}
    public string UserCurrencySymbol{get;set;}
    public boolean selectAll{get;set;}
    public Decimal totalValueU{get;set;}
    private Decimal AUM_AUD;
    private Decimal AUM_CAD;
    private Decimal AUM_EUR;
    private Decimal AUM_JPY;
    private Decimal AUM_SGD;
    private Decimal AUM_USD;
    private Decimal AUM_GBP;
    
    public boolean isDetail{get;set;}
    public String erRecordTypeId {get; set;}
    //this is used only in SLDS
    public String orgName{get;set;}
    @TestVisible List<Organization_Retail_Sales__x> portfList = new List<Organization_Retail_Sales__x>();
    
    public MFS_BusinessAtRiskRetailController(ApexPages.StandardController controller)
    {
        try{
            totalValueU=0.00;
            userCurrency = UserInfo.getDefaultCurrency();
            if(!CURRENCYMAP.keySet().contains(userCurrency)){
                userCurrency = CURRENCY_USD;
            }
            UserCurrencySymbol = MFS_Utilities.getCurrSymbol(userCurrency);
            //Currency is a mandatory field on User record. Hence not checking for null here
            AUMUserCurrency = API_NAME_START+userCurrency+API_NAME_END;
            bar = (Business_at_Risk__c)controller.getRecord();
            //Get the parent Organization Id from URL
            String accId = system.currentPageReference().getParameters().get(ACCOUNT);
            //Create Page
            if(!String.isEmpty(accId) && accId != 'null'){
                bar.Organization__c=accId;
                fetchRelatedLists();
                newFAR();
            }
            //Edit or Detail Page
            else{
                //Code from other controller - Detail and Edit logic
                String type = system.currentPageReference().getParameters().get(PAGE_TYPE);
                String url = system.currentPageReference().getParameters().get(RET_URL);
                if((type == DETAIL || String.isempty(url)) && type!='edit'){
                    isDetail=true;
                }
                else{
                    isDetail=false;
                }
                fetchTotalCurrency();
                fetchBARRelatedLists();
            }
            
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    
    //fetch total AUM in user currency from the object
    public void fetchTotalCurrency()
    {
        try{
            Business_At_Risk__c[] bAtRsk = [select id, Total_AUM_AUD__c, Total_AUM_CAD__c, Total_AUM_EUR__c, Total_AUM_JPY__c, Total_AUM_SGD__c, Total_AUM_USD__c, Total_AUM_GBP__c
                                            from Business_At_Risk__c where id= :bar.id];
            if(bAtRsk.size()>0)
                totalValueU = (Decimal)bAtRsk[0].get(TOTAL_API_START + AUMUserCurrency);
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //fetch all the portfolios related to Organization
    public void fetchRelatedLists(){
        try{
            portFolioLst = new List<Portfolio>();
            if(!String.isempty(bar.organization__c)){
                acc = [select Name, MDM_ID__c from Account where id=:bar.organization__c];
                //set the Business at risk name
                orgName = acc.Name;
                bar.Name = acc.Name +' - '+System.TODAY().format();
                bar.Relationship_at_Risk_Date__c = System.TODAY();
                if(!Test.isRunningTest()){
                    portfList = [select AUM_AUD__c, Level__c, AUM_CAD__c, AUM_EUR__c, AUM_JPY__c, AUM_SGD__c, AUM_USD__c, AUM_GBP__c,Source_Portfolio_ID__r.Id,Source_Portfolio_ID__r.Name, Source_Portfolio_ID__r.Strategy__r.Name
                                 from Organization_Retail_Sales__x where Level__c=:System.Label.Level_Product and Organization_MDM_ID__c = :acc.MDM_ID__c];
                }
                Integer row=0;
                for(Organization_Retail_Sales__x pf : portfList){
                    Decimal uc = (Decimal)pf.get(AUMUserCurrency);
                    row=row+1;
                    portFolioLst.add(new Portfolio(pf,uc, row));
                }
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.BAR_Error2+ex.getMessage()+' - '+ex.getLineNumber())); 
        }
    }
    
    
    //fetch portfolios from BAR_Org_Retail_Sales__c
    public void fetchBARRelatedLists()
    {
        try{
            portFolioLst = new List<Portfolio>();
            if(!String.isempty(bar.organization__c))
            {
                acc = [select Name, MDM_ID__c from Account where id=:bar.organization__c];
                List<BAR_Org_Retail_Sales__c> portfList = new List<BAR_Org_Retail_Sales__c>
                    ([select AUM_AUD__c, Level__c, AUM_CAD__c, AUM_EUR__c, AUM_JPY__c, AUM_SGD__c, AUM_USD__c, AUM_GBP__c,Product__r.Name, Product__c, Product__r.Strategy__r.Name,Percentage_At_Risk__c,
                      selected__c from BAR_Org_Retail_Sales__c where Level__c=:System.Label.Level_Product and Business_At_Risk__c=:bar.id]);
                Integer row=0;
                for(BAR_Org_Retail_Sales__c pf : portfList)
                {
                    Decimal uc = (Decimal)pf.get(AUMUserCurrency);
                    row=row+1;
                    portFolioLst.add(new Portfolio(pf,uc, row, pf.Percentage_At_Risk__c));
                }
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    //custom save method for Business at Risk Retail
    public PageReference save()
    {
        if(String.isEmpty(bar.Percentage_at_Risk__c) || String.isEmpty(bar.Reason_at_Risk__c) ||String.isEmpty(bar.Status__c)||bar.Relationship_at_Risk_Date__c==null || bar.Expected_Loss_Date__c ==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.BAR_Mandatory_Fields));
            return null;
        }
        else if(bar.Relationship_at_Risk_Date__c < System.Today())
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.BAR_Relationship_At_Risk_Date));
            return null;
        }
        else if(bar.Expected_Loss_Date__c < System.Today())
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.BAR_Expected_Loss_Date));
            return null;
        }
        else
        {
            calculateTotalAUMs();
            try{
                bar.Total_AUM_AUD__c = AUM_AUD;
                bar.Total_AUM_CAD__c = AUM_CAD;
                bar.Total_AUM_EUR__c = AUM_EUR;
                bar.Total_AUM_JPY__c = AUM_JPY;
                bar.Total_AUM_SGD__c = AUM_SGD;
                bar.Total_AUM_USD__c = AUM_USD;
                bar.Total_AUM_GBP__c = AUM_GBP;
                bar.Status__c = bar.Status__c;
                bar.Type__c = RETAIL;
                
                insert bar;
                
                List<BAR_Org_Retail_Sales__c> BAROrgRetailLst = new List<BAR_Org_Retail_Sales__c>();
                for(Portfolio portf : portFolioLst )
                {
                    if(portf.selected){
                        BAR_Org_Retail_Sales__c BAROrgRetail = new BAR_Org_Retail_Sales__c() ;
                        BAROrgRetail.AUM_USD__c = portf.Portfolio.AUM_USD__c;
                        BAROrgRetail.Level__c = portf.Portfolio.Level__c;
                        BAROrgRetail.MDM_ID__c = acc.MDM_ID__c;
                        BAROrgRetail.AUM_AUD__c = portf.Portfolio.AUM_AUD__c;
                        BAROrgRetail.AUM_CAD__c = portf.Portfolio.AUM_CAD__c;
                        BAROrgRetail.AUM_EUR__c = portf.Portfolio.AUM_EUR__c;
                        BAROrgRetail.AUM_GBP__c = portf.Portfolio.AUM_GBP__c;
                        BAROrgRetail.AUM_JPY__c = portf.Portfolio.AUM_JPY__c;
                        BAROrgRetail.AUM_SGD__c = portf.Portfolio.AUM_SGD__c;
                        BAROrgRetail.Selected__c = portf.Selected;
                        BAROrgRetail.Product__c = portf.Portfolio.Source_Portfolio_ID__r.Id;
                        BAROrgRetail.Percentage_At_Risk__c = portf.PercAtRisk;
                        BAROrgRetail.Business_At_risk__c = bar.id;
                        BAROrgRetailLst.add(BAROrgRetail);
                    }
                }
                isDetail=true;
                insert BAROrgRetailLst;
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.BAR_Error3 +e.getMessage()+' - '+e.getLineNumber()));
            }
            PageReference pr =  Page.MFS_BusinessAtRiskRetailUpdate;
            pr.getParameters().put(PAGE_TYPE,DETAIL);
            pr.getParameters().put(RECORD_ID,bar.id);
            pr.setRedirect(true);
            return pr;
        }
    }
    
    public PageReference updateBAR(){
        //validations for the page
        if(String.isEmpty(bar.Percentage_at_Risk__c) || String.isEmpty(bar.Reason_at_Risk__c) ||String.isEmpty(bar.Status__c)||bar.Relationship_at_Risk_Date__c==null || bar.Expected_Loss_Date__c ==null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.BAR_Mandatory_Fields));
            return null;
        }
        else if(bar.Relationship_at_Risk_Date__c < System.Today())
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.BAR_Relationship_At_Risk_Date));
            return null;
        }
        else if(bar.Expected_Loss_Date__c < System.Today())
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.BAR_Expected_Loss_Date));
            return null;
        }
        else
        {
            try
            {
                calculateBARTotalAUMs();
                bar.Total_AUM_AUD__c = AUM_AUD;
                bar.Total_AUM_CAD__c = AUM_CAD;
                bar.Total_AUM_EUR__c = AUM_EUR;
                bar.Total_AUM_JPY__c = AUM_JPY;
                bar.Total_AUM_SGD__c = AUM_SGD;
                bar.Total_AUM_USD__c = AUM_USD;
                bar.Total_AUM_GBP__c = AUM_GBP;
                update bar;
                List<BAR_Org_Retail_Sales__c> BAROrgRetailLst = new List<BAR_Org_Retail_Sales__c>();
                for(Portfolio portf : portFolioLst )
                {
                    portf.barPortfolio.Percentage_At_risk__c = portf.percAtRisk;
                    BAROrgRetailLst.add(portf.barPortfolio);
                }
                update BAROrgRetailLst;
            }
            catch(Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.BAR_ERROR3));
            }
            //redirect to detail page
            PageReference pr =  Page.MFS_BusinessAtRiskRetailUpdate;
            pr.getParameters().put(PAGE_TYPE,DETAIL);
            pr.getParameters().put(RECORD_ID,bar.id);
            pr.setRedirect(true);
            return pr;
        }
    }
    
    //redirect to edit page
    public Pagereference edit()
    {
        PageReference pr =  Page.MFS_BusinessAtRiskRetailUpdate;
        pr.getParameters().put(PAGE_TYPE,EDIT);
        pr.getParameters().put(RECORD_ID,bar.id);
        pr.setRedirect(true);
        return pr;
        
    }
    //select/unselect all the portfolios and set percentage at risk to 100/0
    public void selectAll()
    {
        try{
            List<Portfolio> tempLst = new List<Portfolio>();
            if(selectAll == true)
            {
                clearTotalAUM();
                for(Portfolio p : portfolioLst)
                {
                    p.selected = true;
                    p.PercAtRisk = 100;
                    tempLst.add(p);
                }
                PortfolioLst = tempLst;
            }
            else
            {
                clearTotalAUM();
                for(Portfolio p : portfolioLst)
                {
                    p.selected = false;
                    p.PercAtRisk = 0;
                    tempLst.add(p);
                }
                PortfolioLst = tempLst;
            }
            calculateTotalAUMs();
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Clear Total AUM Fields
    private void clearTotalAUM()
    {
        totalValueU=0.00;
        AUM_AUD = 0.00;
        AUM_CAD = 0.00;
        AUM_EUR = 0.00;
        AUM_JPY = 0.00;
        AUM_SGD = 0.00;
        AUM_USD = 0.00;
        AUM_GBP = 0.00;
    }
    
    //Calculate Total AUM fields based on selection of portfolios
    public void calculateTotalAUMs()
    {
        try{
            clearTotalAUM();
            for(Portfolio p: portfolioLst)
            {
                if(p.selected)
                {
                    System.debug(p.percAtRisk+'----'+p.userCurrency);
                    Decimal d = Decimal.ValueOf(p.PercAtRisk)/100;
                    totalValueU+= p.userCurrency*d;
                    AUM_AUD+=p.Portfolio.AUM_AUD__c*d;
                    AUM_CAD+=p.Portfolio.AUM_CAD__c*d;
                    AUM_EUR+=p.Portfolio.AUM_EUR__c*d;
                    AUM_JPY+=p.Portfolio.AUM_JPY__c*d;
                    AUM_SGD+=p.Portfolio.AUM_SGD__c*d;
                    AUM_USD+=p.Portfolio.AUM_USD__c*d;
                    AUM_GBP+=p.Portfolio.AUM_GBP__c*d;
                }
            } 
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    public void calculateBARTotalAUMs()
    {
        try{
            clearTotalAUM();
            for(Portfolio p: portfolioLst)
            {
                if(p.selected)
                {
                    System.debug(p.percAtRisk+'----'+p.userCurrency);
                    Decimal d = Decimal.ValueOf(p.PercAtRisk)/100;
                    totalValueU+= p.userCurrency*d;
                    AUM_AUD+=p.barPortfolio.AUM_AUD__c*d;
                    AUM_CAD+=p.barPortfolio.AUM_CAD__c*d;
                    AUM_EUR+=p.barPortfolio.AUM_EUR__c*d;
                    AUM_JPY+=p.barPortfolio.AUM_JPY__c*d;
                    AUM_SGD+=p.barPortfolio.AUM_SGD__c*d;
                    AUM_USD+=p.barPortfolio.AUM_USD__c*d;
                    AUM_GBP+=p.barPortfolio.AUM_GBP__c*d;
                }
            } 
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Set the percentage at risk to 100 when the row is selected
    public void selectRow()
    {
        try{
            List<Portfolio> tempLst = new List<Portfolio>();
            clearTotalAUM();
            for(Portfolio p: portfolioLst)
            {
                if(p.rowNum==Integer.valueOf(changedRow))
                    p.PercAtRisk = p.selected?100:0;
                tempLst.add(p);
            }
            PortfolioLst = tempLst;
            calculateTotalAUMs(); 
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //wrapper to store portfolio
    public class Portfolio
    {
        public Organization_Retail_Sales__x portfolio{get;set;}
        public BAR_Org_retail_Sales__c barPortfolio{ get; set; }
        public Decimal userCurrency{get;set;}
        public boolean selected{get;set;}
        public Integer rowNum{get;set;}
        public Integer percAtRisk{get;set;}
        public Portfolio(Organization_Retail_Sales__x portf,  Decimal uc, Integer row){
            rowNum = row;
            portfolio = portf;
            userCurrency = uc;
            selected = false;
            percAtRisk=0;
        }
        public Portfolio(BAR_Org_retail_Sales__c barPortfolio, Decimal uc, Integer row, Decimal percAtRisk){
            this.barPortfolio = barPortfolio;
            this.userCurrency = uc;
            this.rowNum = row;
            selected = true;
            this.percAtRisk = Integer.valueOf(percAtRisk);
        }
        
    }
    @RemoteAction
    global static List<Account> queryAccounts(String keyword) {
        List<Account> accountList = new List<Account>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            accountList = [Select Id, Name from Account where Name like :keyword limit 5];
        }
        return accountList;
    }
    
    //Below methods are used only for SF1 to mimic standard related list
    public List<Approval_Request__c> getFAR(){
        try{
            List<Approval_Request__c> farList = new List<Approval_Request__c>([select id, Name, Opportunity__r.Name, Opportunity_Product__c, Submission_Date__c,
                                                                               Due_Date__c, Approval_Status__c from Approval_Request__c where Business_At_Risk__c = :bar.id]); 
            return farList;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
            return null;
        }
    }
    
    public void newFAR()
    {
        try{
            erRecordTypeId = (String)Schema.SObjectType.Approval_Request__c.getRecordTypeInfosByName().get('Fee Approval Request').getRecordTypeId();
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    public List<OpenActivity> getOpenActivities()
    {
        List<Business_At_Risk__c> openActBAR = new List<Business_At_Risk__c>([select id,(select id, subject,Who.Name,PrimaryWhoId,WhatId,IsTask,ActivityDate,Status,Priority,Owner.Name from OpenActivities ORDER BY ActivityDate
                                                                                         ASC, LastModifiedDate DESC LIMIT 500)
                                                                              from Business_At_Risk__c where Id=:bar.id]); 
        List<OpenActivity> openAct = new List<OpenActivity>();
        for(Business_At_Risk__c oaBAR : openActBAR )
        {
            for(OpenActivity oa : oaBAR.Openactivities)
            {
                openAct.add(oa);
            }
        }
        return openAct;
    }
    public PageReference newTask()
    {
        String isTaskorEvent = 'task=true'; 
        String isNew = 'isNew=true'; 
        try{
            Activity_Detail__c ad = new Activity_Detail__c(Subject__c = 'Orphan Record');
            insert ad;
            PageReference pr =  new Pagereference('/apex/MFS_Activity360RetailPageSF1?Id='+ad.id+'&'+isTaskorEvent+'&returnID='+bar.Id+'&'+isNew+'&RecType=Retail');
            pr.setRedirect(true);
            return pr;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
            return null;
        }
    }
    public PageReference newMeeting()
    {
        String isTaskorEvent = 'event=true'; 
        String isNew = 'isNew=true';
        try{
            Activity_Detail__c ad = new Activity_Detail__c(Subject__c = 'Orphan Record');
            insert ad;
            PageReference pr =  new Pagereference('/apex/MFS_Activity360RetailPageSF1?Id='+ad.id+'&'+isTaskorEvent+'&returnID='+bar.Id+'&'+isNew+'&RecType=Retail');
            pr.setRedirect(true);
            return pr;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
            return null;
        }
    }
    public List<ActivityHistory> getActivityHistories()
    {
        List<Business_At_Risk__c> actHistBAR = new List<Business_At_Risk__c>([Select (select subject,Who.Name,PrimaryWhoId,WhatId,IsTask,ActivityDate,Owner.Name,LastModifiedDate from 
                                                                                      ActivityHistories ORDER BY ActivityDate DESC, LastModifiedDate DESC LIMIT 500) from Business_At_Risk__c where Id=:bar.id ]); 
        List<ActivityHistory> actHist = new List<ActivityHistory>();
        for(Business_At_Risk__c ahBAR : actHistBAR )
        {
            for(ActivityHistory ah : ahBAR.ActivityHistories)
            {
                actHist.add(ah);
            }
        }
        return actHist;
    }
}