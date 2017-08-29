/***************************************************************************************************
Apex Class Name    : MFS_BusinessAtRiskController
Version            : 1.0 
Created Date       : 16 JUL 2016
Function           : This is a Controller for MFS_BusinessatRisk Page. This controller will handle Business at risk for institutional profiles
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            07/16/2016              Original Version
***************************************************************************************************/
global with sharing class MFS_BusinessAtRiskController {
    
    //Controller constants
    private static final String API_NAME_START = 'AUM_';
    private static final String API_NAME_END = '__c';
    private static final String CLEAR = 'clear';
    private static final String PLUS = 'plus';
    private static final String MINUS = 'minus';
    private static final String PAGE_TYPE = 'type';
    private static final String DETAIL = 'detail';
    private static final String RECORD_ID = 'id';
    private static final String ACCOUNT = 'account';
    private static final String CURRENCY_USD = 'USD';
    public static final String EDIT = 'edit';
    public static final String RET_URL = 'retURL';
    public static final String TOTAL_API_START = 'Total_';
    public String erRecordTypeId {get; set;}
    private static final MAP<String, String> CURRENCYMAP =  new Map<String, String>{'AUD' => 'AUD', 'CAD' => 'CAD', 'EUR' => 'EUR', 'JPY' => 'JPY','SGD' => 'SGD', 'USD' => 'USD', 'GBP' => 'GBP'};
        
        //Controller variables
        private static final String INSTITUTIONAL = 'Institutional'; 
    private Business_at_Risk__c bar;
    private Account acc;
    public List<Plans> planLst{get;set;}
    private List<Portfolio> portFolioLst;
    public Map<String, List<Portfolio>> portfolioMap { get; set; }
    public String selectedvalue{get;set;}
    public String selectedIcon{get;set;}
    public String childRow{get;set;}
    public STring userCurrency{get;set;}
    public String clientCurrency{get;set;}
    public String AUMUserCurrency{get;set;}
    public String AUMClientCurrency{get;set;}
    public string UserCurrencySymbol{get;set;}
    public string ClientCurrencySymbol{get;set;}
    public boolean selectAll{get;set;}
    public boolean isDetail{get;set;}
    public Decimal totalValueC{get;set;}
    public Decimal totalValueU{get;set;}
    private Decimal AUM_AUD;
    private Decimal AUM_CAD;
    private Decimal AUM_EUR;
    private Decimal AUM_JPY;
    private Decimal AUM_SGD;
    private Decimal AUM_USD;
    private Decimal AUM_GBP;
    //this is used only in SLDS
    public String orgName{get;set;}
    
    //Constructor
    public MFS_BusinessAtRiskController(ApexPages.StandardController controller) {
        try{
            bar = (Business_at_Risk__c)controller.getRecord();
            //get the currency from user profile
            userCurrency = UserInfo.getDefaultCurrency();
            //If user currency doesn't match with Sales and Asset data currency then set it to "USD"
            if(!CURRENCYMAP.keySet().contains(userCurrency)){
                userCurrency = CURRENCY_USD;
            }
            //Currency is a mandatory field on User record. Hence not checking for null here
            AUMUserCurrency = API_NAME_START+userCurrency+API_NAME_END;
            //Get the user currency symbol from custom setting
            UserCurrencySymbol = MFS_Utilities.getCurrSymbol(userCurrency);
            //Get the parent account id for business at risk
            String accId = system.currentPageReference().getParameters().get(ACCOUNT);
            //Create Page
            if(!String.isEmpty(accId) && accId != 'null'){
                bar.organization__c = accId;
                clearTotalAUM();
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
            System.debug(ex.getStackTraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //fetch Plan and Portfolio lists when Organization is changed.
    public void fetchRelatedLists() {
        try{
            planLst = new List<Plans>();
            portfolioMap = new Map<String, List<Portfolio>>();
            if(!String.isempty(bar.organization__c)){
                acc = [select Name, MDM_ID__c from Account where id=:bar.organization__c];
                //set the business at risk name in the vf page
                orgName = acc.Name;
                bar.Name = acc.Name +' - '+System.TODAY().format();
                //set the relationship at risk date in the vf page
                bar.Relationship_at_Risk_Date__c = System.TODAY();
                
                //get all the plans and add it to wrapper list
                List<Organization_Institutional_Sales__c> plan = new List<Organization_Institutional_Sales__c>
                    ([select id,Client_Reporting_Currency_Code__c, AUM_AUD__c, Level__c, AUM_CAD__c, AUM_EUR__c, AUM_JPY__c, AUM_SGD__c, AUM_USD__c, AUM_GBP__c, Plan__c, Plan_id__c,
                      Plan_Name__c from Organization_Institutional_Sales__c where level__c=:System.Label.Level_Plan and Organization_MDM_ID__c =:acc.MDM_ID__c]);
                Set<String> planIds = new Set<String>();
                //get the client reporting curreny code for the organization's Sales and Asset data and set the client currency symbol
                clientCurrency = plan.size()>0 ? plan[0].Client_Reporting_Currency_Code__c : CURRENCY_USD;
                clientCurrencySymbol = MFS_Utilities.getCurrSymbol(clientCurrency);
                AUMClientCurrency = API_NAME_START+clientCurrency+API_NAME_END;
                for(Organization_Institutional_Sales__c pln : plan){
                    Decimal usrCurc = (Decimal)pln.get(AUMUserCurrency);
                    Decimal clientCurc = (Decimal)pln.get(AUMClientCurrency);
                    planLst.add(new Plans(pln, usrCurc, clientCurc));
                    planIds.add(pln.Plan_Id__c);
                }
                
                //get all the portfolios, associate it to parent plans and add it to map (Map<String, List<Wrapper>>())
                Integer row=0;
                List<Organization_Institutional_Sales__c> portfolios = new List<Organization_Institutional_Sales__c>
                    ([select id, AUM_AUD__c,AUM_CAD__c,AUM_EUR__c,AUM_JPY__c,AUM_SGD__c, AUM_USD__c, AUM_GBP__c,Level__c, Plan_id__c,Portfolio__c,
                      Portfolio_Id__c, Plan_Name__c,Portfolio__r.Name, Portfolio__r.Strategy__r.Name from Organization_Institutional_Sales__c where
                      level__c=:System.Label.Level_Portfolio and Plan_id__c IN :planIds and Organization_MDM_ID__c =:acc.MDM_ID__c]);
                //query for portfolios and put it into map
                for(String planId : PlanIds){
                    portFolioLst = new List<Portfolio>();
                    for(Organization_Institutional_Sales__c prtf : portfolios){
                        if(planId == prtf.Plan_Id__c){
                            Decimal usrCur = (Decimal)prtf.get(AUMUserCurrency);
                            Decimal clientCur = (Decimal)prtf.get(AUMClientCurrency);
                            row=row+1;
                            portFolioLst.add(new Portfolio(prtf, usrCur, clientCur, row));//add portfolio details here
                        }
                    }
                    portfolioMap.put(planId, portFolioLst);
                }
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    public void fetchTotalCurrency() {
        try{
            Business_At_Risk__c[] bAtRsk = [select id, Total_AUM_AUD__c, Total_AUM_CAD__c, Total_AUM_EUR__c, Total_AUM_JPY__c, Total_AUM_SGD__c, Total_AUM_USD__c, Total_AUM_GBP__c
                                            from Business_At_Risk__c where id= :bar.id];
            if(bAtRsk.size()>0)
            {
                if(AUMClientCurrency!=null)
                    totalValueC = (Decimal)bAtRsk[0].get(TOTAL_API_START+AUMClientCurrency);
                totalValueU = (Decimal)bAtRsk[0].get(TOTAL_API_START+AUMUserCurrency);
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //fetch Plans and Portfolios for the selected Organization
    public void fetchBARRelatedLists() {
        try{
            acc = [select MDM_ID__c from Account where id=:bar.organization__c];
            List<BAR_Org_Institutional_Sales__c> plan = new List<BAR_Org_Institutional_Sales__c>
                ([select id,Client_Reporting_Currency_Code__c,Selected__c,AUM_AUD__c,Level__c, AUM_CAD__c,AUM_EUR__c,
                  AUM_JPY__c,AUM_SGD__c,AUM_USD__c,  AUM_GBP__c, Plan_id__c, Plan_Name__c,Plan__c, Percentage_At_Risk__c
                  from BAR_Org_Institutional_Sales__c where level__c=:System.Label.Level_Plan and MDM_ID__c =:acc.MDM_ID__c and Business_At_Risk__c =:bar.id] );
            planLst = new List<Plans>();
            Set<String> planIds = new Set<String>();
            if(plan.size()>0)
            {
                clientCurrency = plan[0].Client_Reporting_Currency_Code__c;
                clientCurrencySymbol = MFS_Utilities.getCurrSymbol(clientCurrency);
                AUMClientCurrency = API_NAME_START+clientCurrency+API_NAME_END;
            }     
            fetchTotalCurrency();
            for(BAR_Org_Institutional_Sales__c pln : plan)
            {
                Decimal uc = (Decimal)pln.get(AUMUserCurrency);
                Decimal cc = (Decimal)pln.get(AUMClientCurrency);
                planLst.add(new Plans(pln,uc,cc, pln.Selected__c, pln.Percentage_At_Risk__c));
                planIds.add(pln.Plan_Id__c);
            }
            
            portfolioMap = new Map<String, List<Portfolio>>();
            Integer row=0;
            List<BAR_Org_Institutional_Sales__c> portfolios = [select id,selected__c, AUM_AUD__c,AUM_CAD__c,AUM_EUR__c, Portfolio__c,	AUM_JPY__c, AUM_SGD__c,AUM_USD__c,  AUM_GBP__c,Level__c,
                                                               Plan_id__c, Plan_Name__c, Portfolio__r.Name, Strategy__c, Percentage_At_Risk__c from BAR_Org_Institutional_Sales__c where
                                                               level__c=:System.Label.Level_Portfolio and Plan_id__c IN :planIds and MDM_ID__c =:acc.MDM_ID__c and Business_At_Risk__c =:bar.id];
            
            for(String planId : PlanIds)
            {
                portFolioLst = new List<Portfolio>();
                
                for(BAR_Org_Institutional_Sales__c pln : portfolios)
                {
                    if(planId == pln.Plan_Id__c)
                    {
                        Decimal uc = (Decimal)pln.get(AUMUserCurrency);
                        Decimal cc = (Decimal)pln.get(AUMClientCurrency);
                        row=row+1;
                        portFolioLst.add(new Portfolio(pln, uc, cc, row, pln.Selected__c, pln.Percentage_At_Risk__c));
                    }
                }
                portfolioMap.put(planId, portFolioLst);
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    } 
    
    
    //custom save method for Business At Risk
    public PageReference save()
    {
        System.debug('PortfolioMap======='+PortfolioMap);
        //Validations for the page fields
        if(String.isEmpty(bar.Percentage_at_Risk__c) || String.isEmpty(bar.Reason_at_Risk__c) ||String.isEmpty(bar.Status__c)||bar.Relationship_at_Risk_Date__c==null || bar.Expected_Loss_Date__c ==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.BAR_Mandatory_Fields));
            return null;
        }
        else if(bar.Relationship_at_Risk_Date__c < System.Today()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.BAR_Relationship_At_Risk_Date));
            return null;
        }
        else if(bar.Expected_Loss_Date__c < System.Today()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.BAR_Expected_Loss_Date));
            return null;
        }
        else {
            //Calculate total AUMs and insert Business at Risk record
            calculateTotalAUMs();
            //Business_at_Risk__c insrtBAR = new Business_at_Risk__c();
            try {
                bar.Total_AUM_AUD__c = AUM_AUD;
                bar.Total_AUM_CAD__c = AUM_CAD;
                bar.Total_AUM_EUR__c = AUM_EUR;
                bar.Total_AUM_JPY__c = AUM_JPY;
                bar.Total_AUM_SGD__c = AUM_SGD;
                bar.Total_AUM_USD__c = AUM_USD;
                bar.Total_AUM_GBP__c = AUM_GBP;
                bar.Type__c = INSTITUTIONAL;
                
                insert bar;
                /*Insert selected plans and portfolios to BAR_Org_Institutional_Sales__c object. If any portfolio is selected without a parent plan, then plan should also be inserted with 
value as "unchecked" */
                Map<String, Integer> PARMap = new Map<String, Integer>();
                for(Plans p: planLst) {
                    if(p.selected)
                        PARMap.put(p.Plans.Plan_Id__c, p.PercAtRisk);
                }
                
                List<BAR_Org_Institutional_Sales__c> BAROrgInstLst = new List<BAR_Org_Institutional_Sales__c>();
                BAR_Org_Institutional_Sales__c BAROrgInst;
                Set<String> planIds = new Set<String>();
                
                for(String id: PortfolioMap.keySet()) {
                    List<Portfolio> tempLst = PortfolioMap.get(id);
                    for(Portfolio p : tempLst) {
                        if(p.selected) {
                            BAROrgInst = new BAR_Org_Institutional_Sales__c();
                            BAROrgInst.Plan_Name__c = p.Portfolio.Plan_name__c;
                            BAROrgInst.AUM_USD__c = p.Portfolio.AUM_USD__c;
                            BAROrgInst.Level__c = p.Portfolio.Level__c;
                            BAROrgInst.Plan_ID__c = p.Portfolio.Plan_Id__c;
                            BAROrgInst.Strategy__c = p.Portfolio.Portfolio__r.Strategy__r.Name;
                            BAROrgInst.Portfolio__c = p.Portfolio.Portfolio__c;
                            BAROrgInst.MDM_ID__c = acc.MDM_ID__c;
                            BAROrgInst.Client_Reporting_Currency_Code__c = clientCurrency;
                            BAROrgInst.AUM_AUD__c = p.Portfolio.AUM_AUD__c; 
                            BAROrgInst.AUM_CAD__c = p.Portfolio.AUM_CAD__c;
                            BAROrgInst.AUM_EUR__c = p.Portfolio.AUM_EUR__c;
                            BAROrgInst.AUM_GBP__c = p.Portfolio.AUM_GBP__c;
                            BAROrgInst.AUM_JPY__c = p.Portfolio.AUM_JPY__c;
                            BAROrgInst.AUM_SGD__c = p.Portfolio.AUM_SGD__c;
                            BAROrgInst.Selected__c = p.Selected;
                            BAROrgInst.Business_At_risk__c = bar.id;
                            BAROrgInst.Percentage_At_Risk__c = p.percAtRisk;
                            BAROrgInstLst.add(BAROrgInst);
                            planIds.add(p.Portfolio.Plan_Id__c);
                        }
                    }
                }
                for(Plans plan : planLst ) {
                    if(plan.selected || (planIds.contains(plan.Plans.Plan_Id__c))) {
                        BAROrgInst = new BAR_Org_Institutional_Sales__c();
                        BAROrgInst.plan_name__c = plan.Plans.Plan_Name__c;
                        BAROrgInst.AUM_USD__c = plan.Plans.AUM_USD__c;
                        BAROrgInst.Level__c = plan.Plans.Level__c;
                        BAROrgInst.Plan_ID__c = plan.Plans.Plan_Id__c;
                        BAROrgInst.Plan__c = plan.Plans.Plan__c;
                        BAROrgInst.MDM_ID__c = acc.MDM_ID__c;
                        BAROrgInst.Client_Reporting_Currency_Code__c = clientCurrency;
                        BAROrgInst.AUM_AUD__c = plan.Plans.AUM_AUD__c;
                        BAROrgInst.AUM_CAD__c = plan.Plans.AUM_CAD__c;
                        BAROrgInst.AUM_EUR__c = plan.Plans.AUM_EUR__c;
                        BAROrgInst.AUM_GBP__c = plan.Plans.AUM_GBP__c;
                        BAROrgInst.AUM_JPY__c = plan.Plans.AUM_JPY__c;
                        BAROrgInst.AUM_SGD__c = plan.Plans.AUM_SGD__c;
                        BAROrgInst.Selected__c = plan.Selected;
                        BAROrgInst.Business_At_risk__c = bar.id;
                        BAROrgInst.Percentage_At_Risk__c = plan.percAtRisk;
                        BAROrgInstLst.add(BAROrgInst);
                    }
                }
                if(BAROrgInstLst.size()>0)
                    //Insert records into custom BAR Institutional Sales Object
                    insert BAROrgInstLst;
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.BAR_Error3 + e.getMessage()+' - '+e.getLineNumber()));
            }
            //redirect to a custom Detail Page
            isDetail=true;
            PageReference pr =  Page.MFS_BusinessAtRiskUpdate;
            pr.getParameters().put(PAGE_TYPE,DETAIL);
            pr.getParameters().put(RECORD_ID,bar.id);
            pr.setRedirect(true);
            return pr;
        }
    }
    
    //custom save method for vf page
    public PageReference updateBAR()
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
            System.debug('portfolioMap=======>'+portfolioMap);
            calculateBARTotalAUMs();
            bar.Total_AUM_AUD__c = AUM_AUD;
            bar.Total_AUM_CAD__c = AUM_CAD;
            bar.Total_AUM_EUR__c = AUM_EUR;
            bar.Total_AUM_JPY__c = AUM_JPY;
            bar.Total_AUM_SGD__c = AUM_SGD;
            bar.Total_AUM_USD__c = AUM_USD;
            bar.Total_AUM_GBP__c = AUM_GBP;
            update bar;
            List<BAR_Org_Institutional_Sales__c> BAROrgInstLst = new List<BAR_Org_Institutional_Sales__c>();
            for(Plans p : planLst) {
                p.barPlans.Percentage_At_Risk__c = p.percAtRisk;
                BAROrgInstLst.add(p.barPlans);
                for(Portfolio pf : portfolioMap.get(p.barPlans.Plan_Id__c)) {
                    pf.barPortfolio.Percentage_At_Risk__c = pf.percAtRisk;
                    BAROrgInstLst.add(pf.barPortfolio);
                    System.debug('pf.barPortfolio====>'+pf.barPortfolio);
                }
            }
            update BAROrgInstLst;
            //redirect to custom detail page
            PageReference pr =  Page.MFS_BusinessAtRiskUpdate;
            pr.getParameters().put(PAGE_TYPE,DETAIL);
            pr.getParameters().put(RECORD_ID,bar.id);
            pr.setRedirect(true);
            return pr;
        }
    }
    
    //redirect to custom edit page
    public Pagereference edit()
    {
        PageReference pr =  Page.MFS_BusinessAtRiskUpdate;
        pr.getParameters().put(PAGE_TYPE,EDIT);
        pr.getParameters().put(RECORD_ID,bar.id);
        pr.setRedirect(true);
        return pr;
    }
    
    //Logic for expand and collapse. This is handled through wrapper variable
    public void renderPortf() {
        try{
            List<Plans> tempLst = new List<Plans>();
            if(PLUS.equals(selectedIcon)){
                for(Plans p:planLst){
                    if(p.Plans.Plan_id__c == selectedValue ){
                        p.expand=true;
                    }
                    tempLst.add(p);
                }
                planLst = tempLst;
            }
            if(MINUS.equals(selectedIcon)){
                for(Plans p:planLst){
                    if(p.Plans.Plan_id__c == selectedValue ){
                        p.expand=false;
                    }
                    tempLst.add(p);
                }
                planLst = tempLst;
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //If the plan is selected then lock the portfolios and copy the Percentage at risk values to Portfolios
    public void selectAndLockChildRows() {
        try{
            List<PortFolio> tempVarLst;
            List<Plans> tempPlan = new List<Plans>();
            Map<String, List<Portfolio>> tempPortfolioMap;
            for(Plans p: planLst){
                if(p.selected){
                    p.PercAtRisk = p.PercAtRisk==0 ? 100 : p.PercAtRisk;
                    tempPlan.add(p);
                    List<Portfolio> tempLst = PortfolioMap.get(p.Plans.Plan_Id__c);
                    tempPortfolioMap = PortfolioMap;
                    tempPortfolioMap.remove(p.Plans.Plan_Id__c);
                    tempVarLst = new List<PortFolio>();
                    for(Portfolio pf :tempLst){
                        pf.selected=true;
                        pf.PercAtRisk = p.PercAtRisk;
                        tempVarLst.add(pf);
                    }
                    tempPortfolioMap.put(p.Plans.Plan_Id__c,tempVarLst);                    
                }
                else{
                    p.PercAtRisk = 0;
                    List<Portfolio> tempLst = PortfolioMap.get(p.Plans.Plan_Id__c);
                    tempPortfolioMap = PortfolioMap;
                    tempPortfolioMap.remove(p.Plans.Plan_Id__c);
                    tempVarLst = new List<PortFolio>();
                    for(Portfolio pf :tempLst){
                        pf.selected = pf.manuallySelected==true ? true : false;
                        p.PercAtRisk = pf.selected==true?100:0;
                        pf.PercAtRisk = pf.selected==true ? pf.PercAtRisk : p.PercAtRisk;
                        tempVarLst.add(pf);
                    }
                    tempPlan.add(p);
                    tempPortfolioMap.put(p.Plans.Plan_Id__c,tempVarLst); 
                }
            } 
            PlanLst = tempPlan;
            PortfolioMap = tempPortfolioMap;
            calculateTotalAUMs();
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //If the Percentage at Risk is changed at plan level, copy that to all portfolios
    public void copyToChildRows() {
        try{
            List<PortFolio> tempVarLst;
            Map<String, List<Portfolio>> tempPortfolioMap;
            for(Plans p: planLst){
                if(p.selected){
                    List<Portfolio> tempLst = PortfolioMap.get(p.Plans.Plan_Id__c);
                    tempPortfolioMap = PortfolioMap;
                    tempPortfolioMap.remove(p.Plans.Plan_Id__c);
                    tempVarLst = new List<PortFolio>();
                    for(Portfolio pf :tempLst){
                        pf.PercAtRisk = p.PercAtRisk;
                        tempVarLst.add(pf);
                    }
                    tempPortfolioMap.put(p.Plans.Plan_Id__c,tempVarLst);
                }
            }
            if(tempPortfolioMap!=null)
                portfolioMap = tempPortfolioMap;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Calculate total values and handle parent plans
    public void handleParentRows() {
        try{
            List<PortFolio> tempVarLst;
            Map<String, List<Portfolio>> tempPortfolioMap;
            tempPortfolioMap = new Map<String, List<Portfolio>>();
            for(String id: PortfolioMap.keySet()) {
                List<Portfolio> tempLst = PortfolioMap.get(id);
                tempVarLst = new List<PortFolio>();
                Integer portfSize = 0;
                for(Portfolio p : tempLst) {
                    if(p.rowNum == Integer.valueOf(childRow))
                    {
                        if(p.selected) {
                            p.PercAtRisk = p.PercAtRisk == 0 ? 100 : p.PercAtRisk;
                            p.manuallySelected=true;
                        }
                        else {
                            p.PercAtRisk=0;
                            p.manuallySelected=false;
                        }
                    }
                    tempVarLst.add(p);
                    if(p.selected == true && p.manuallySelected == true) {
                        portfSize+=1;
                        if(tempLst.size() == portfSize) {
                            List<Plans> tempPlnLst = new List<Plans>();
                            for(Plans pl:planLst) {
                                if(pl.Plans.Plan_Id__c == p.Portfolio.Plan_Id__c && p.selected) {
                                    pl.PercAtRisk = 100;
                                }
                                tempPlnLst.add(pl);
                            }
                            planLst = tempPlnLst;
                        }
                    }
                }
                //tempPortfolioMap.put(id, tempVarLst);
            }
            calculateTotalAUMs();
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //When select all checkbox is clicked, check all plans and portfolios and set the percentage at risk to 100
    public void selectAll() {
        try{
            List<Plans> tempLst = new List<Plans>();
            if(selectAll == true) {
                clearTotalAUM();
                for(Plans p:planLst) {
                    p.expand=true;
                    p.selected = true;
                    p.PercAtRisk = 100;
                    tempLst.add(p);
                }
                planLst = tempLst;
                Map<String, List<Portfolio>> tempPortfolioMap;
                tempPortfolioMap = new Map<String, List<Portfolio>>();
                
                for(String id: PortfolioMap.keySet()) {
                    List<Portfolio> tempPortLst = PortfolioMap.get(id);
                    List<PortFolio> tempVarLst = new List<PortFolio>();
                    
                    for(Portfolio pf : tempPortLst) {
                        pf.selected = true;
                        pf.PercAtRisk = 100;
                        tempVarLst.add(pf);
                    }
                    tempPortfolioMap.put(id, tempVarLst);
                }
                PortfolioMap = tempPortfolioMap;
            }
            else {
                clearTotalAUM();
                for(Plans p:planLst) {
                    p.expand=false;
                    p.selected = false;
                    p.PercAtRisk =0;
                    tempLst.add(p);
                }
                planLst = tempLst;
                Map<String, List<Portfolio>> tempPortfolioMap;
                tempPortfolioMap = new Map<String, List<Portfolio>>();
                
                for(String id: PortfolioMap.keySet()) {
                    List<Portfolio> tempPortLst = PortfolioMap.get(id);
                    List<PortFolio> tempVarLst = new List<PortFolio>();
                    
                    for(Portfolio pf : tempPortLst) {
                        pf.selected=false;
                        pf.manuallySelected=false;
                        pf.PercAtRisk =0;
                        tempVarLst.add(pf);
                    }
                    tempPortfolioMap.put(id, tempVarLst);
                }
                PortfolioMap = tempPortfolioMap;
            }
            calculateTotalAUMs();
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Clear total AUMs for all currencies
    private void clearTotalAUM() {
        totalValueC = 0.00;
        totalValueU = 0.00;
        AUM_AUD = 0.00;
        AUM_CAD = 0.00;
        AUM_EUR = 0.00;
        AUM_JPY = 0.00;
        AUM_SGD = 0.00;
        AUM_USD = 0.00;
        AUM_GBP = 0.00;
    }
    //Calculate total AUM in all currencies
    public void calculateTotalAUMs() {
        try{
            //clear the existing value and then calculate
            clearTotalAUM();
            for(Plans p: planLst) {
                /*if(p.selected) {
Decimal d = Decimal.ValueOf(p.PercAtRisk)/100;
totalValueC+= p.clientCurrency*d;
totalValueU+= p.userCurrency*d;
AUM_AUD+=p.Plans.AUM_AUD__c*d;
AUM_CAD+=p.Plans.AUM_CAD__c*d;
AUM_EUR+=p.Plans.AUM_EUR__c*d;
AUM_JPY+=p.Plans.AUM_JPY__c*d;
AUM_SGD+=p.Plans.AUM_SGD__c*d;
AUM_USD+=p.Plans.AUM_USD__c*d;
AUM_GBP+=p.Plans.AUM_GBP__c*d;

}*/
                //else if(PortfolioMap!=null) {
                List<Portfolio> tempLst = PortfolioMap.get(p.Plans.Plan_Id__c);
                for(Portfolio pf :tempLst) {
                    if(pf.selected) {
                        Decimal dpf = Decimal.ValueOf(pf.PercAtRisk)/100;
                        dpf = dpf>1.00?1.00:dpf;
                        totalValueC+= pf.clientCurrency*dpf;
                        totalValueU+= pf.userCurrency*dpf;
                        AUM_AUD+=pf.Portfolio.AUM_AUD__c*dpf;
                        AUM_CAD+=pf.Portfolio.AUM_CAD__c*dpf;
                        AUM_EUR+=pf.Portfolio.AUM_EUR__c*dpf;
                        AUM_JPY+=pf.Portfolio.AUM_JPY__c*dpf;
                        AUM_SGD+=pf.Portfolio.AUM_SGD__c*dpf;
                        AUM_USD+=pf.Portfolio.AUM_USD__c*dpf;
                        AUM_GBP+=pf.Portfolio.AUM_GBP__c*dpf;
                    }
                }
                // }
            } 
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Calculate total AUM in all currencies
    public void calculateBARTotalAUMs() {
        try{
            //clear the existing value and then calculate
            clearTotalAUM();
            for(Plans p: planLst) {
                /*if(p.barPlans.selected__c) {
                    Decimal d = Decimal.valueOf(String.ValueOf(p.percAtRisk))/100;
                    totalValueC+= p.clientCurrency*d;
                    totalValueU+= p.userCurrency*d;
                    AUM_AUD+=p.barPlans.AUM_AUD__c*d;
                    AUM_CAD+=p.barPlans.AUM_CAD__c*d;
                    AUM_EUR+=p.barPlans.AUM_EUR__c*d;
                    AUM_JPY+=p.barPlans.AUM_JPY__c*d;
                    AUM_SGD+=p.barPlans.AUM_SGD__c*d;
                    AUM_USD+=p.barPlans.AUM_USD__c*d;
                    AUM_GBP+=p.barPlans.AUM_GBP__c*d;
                    
                }*/
                //else if(PortfolioMap!=null) {
                    List<Portfolio> tempLst = PortfolioMap.get(p.barPlans.Plan_Id__c);
                    for(Portfolio pf :tempLst) {
                        if(pf.barPortfolio.selected__c) {
                            Decimal dpf = Decimal.valueOf(String.ValueOf(pf.percAtRisk))/100;
                            dpf = dpf>1.00?1.00:dpf;
                            totalValueC+= pf.clientCurrency*dpf;
                            totalValueU+= pf.userCurrency*dpf;
                            AUM_AUD+=pf.barPortfolio.AUM_AUD__c*dpf;
                            AUM_CAD+=pf.barPortfolio.AUM_CAD__c*dpf;
                            AUM_EUR+=pf.barPortfolio.AUM_EUR__c*dpf;
                            AUM_JPY+=pf.barPortfolio.AUM_JPY__c*dpf;
                            AUM_SGD+=pf.barPortfolio.AUM_SGD__c*dpf;
                            AUM_USD+=pf.barPortfolio.AUM_USD__c*dpf;
                            AUM_GBP+=pf.barPortfolio.AUM_GBP__c*dpf;
                        }
                    }
               // }
            } 
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    //wrapper to store Plans
    public class Plans {
        public Organization_Institutional_Sales__c plans{get;set;}
        public BAR_Org_Institutional_Sales__c barPlans { get; set; }
        public Decimal userCurrency{get;set;}
        public Decimal clientCurrency{get;set;}
        public boolean selected{get;set;}
        public boolean expand{get;set;}
        public Integer percAtRisk{get;set;}
        public Plans(Organization_Institutional_Sales__c pln, Decimal uc, Decimal cc) {
            plans = pln;
            userCurrency = uc;
            clientCurrency = cc;
            selected = false;
            expand = false;
            percAtRisk=0;
        }
        public Plans(BAR_Org_Institutional_Sales__c pln, Decimal uc, Decimal cc, Boolean selected, Decimal risk)
        {
            barPlans = pln;
            userCurrency = uc;
            clientCurrency = cc;
            selected = selected;
            percAtRisk = Integer.valueOf(risk);
        }
    }
    
    //wrapper to store Portfolios
    public class Portfolio {
        public Organization_Institutional_Sales__c portfolio{ get; set; }
        public BAR_Org_Institutional_Sales__c barPortfolio { get; set; }
        public Decimal userCurrency{get;set;}
        public Decimal clientCurrency{get;set;}
        public boolean selected{get;set;}
        public boolean manuallySelected{get;set;}
        public Integer rowNum{get;set;}
        public Integer percAtRisk{get;set;}
        public Portfolio(Organization_Institutional_Sales__c portf,  Decimal uc, Decimal cc, Integer row) {
            rowNum = row;
            portfolio = portf;
            userCurrency = uc;
            clientCurrency = cc;
            selected = false;
            manuallySelected=false;
            percAtRisk=0;
        }
        
        public Portfolio(BAR_Org_Institutional_Sales__c portf,  Decimal uc, Decimal cc, Integer row, Boolean sel, Decimal risk)
        {
            rowNum = row;
            barPortfolio = portf;
            userCurrency = uc;
            clientCurrency = cc;
            selected = sel;
            percAtRisk = Integer.valueOf(risk);
        }
    }
    //This method is usind in SLDS to populate lookup field
    @RemoteAction
    global static List<Account> queryAccounts(String keyword) {
        List<Account> accountList = new List<Account>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            accountList = [Select Id, Name from Account where Name like :keyword limit 5];
        }
        return accountList;
    }
    
    //populate Fee Approval Request in SLDS Related List
    public List<Approval_Request__c> getFAR()
    {
        try{
            List<Approval_Request__c> farList = new List<Approval_Request__c>([select id, Name, Opportunity__r.Name, Opportunity_Product__c, Submission_Date__c,
                                                                               Due_Date__c, Approval_Status__c from Approval_Request__c where Business_At_Risk__c = :bar.id]); 
            return farList;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
            return null;
        }
    }
    //Open standard Fee Approval Request Page from SLDS View
    public void newFAR()
    {
        try{
            erRecordTypeId = (String)Schema.SObjectType.Approval_Request__c.getRecordTypeInfosByName().get('Fee Approval Request').getRecordTypeId();
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
        
    }
    //Display Open Activities in SLDS Related List
    public List<OpenActivity> getOpenActivities()
    {
        //Open Activities should be queried with parent record. Direct Query is not allowed.
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
    
    //Create Log a Call(Institutional)
    public PageReference newTask()
    {
        String isTaskorEvent = 'task=true';
        String isNew = 'isNew=true'; 
        try{
            Activity_Detail__c ad = new Activity_Detail__c(Subject__c = 'Orphan Record');
            insert ad;
            PageReference pr =  new Pagereference('/apex/MFS_Activity360PageSF1?Id='+ad.id+'&'+isTaskorEvent+'&returnID='+bar.Id+'&'+isNew+'&RecType=Institutional');
            pr.setRedirect(true);
            return pr;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
            return null;
        }
    }
    //Create 'Create Activity(Institutional)'
    public PageReference newMeeting()
    {
        String isTaskorEvent = 'event=true'; 
        String isNew = 'isNew=true';
        try{
            Activity_Detail__c ad = new Activity_Detail__c(Subject__c = 'Orphan Record');
            insert ad;
            PageReference pr =  new Pagereference('/apex/MFS_Activity360PageSF1?Id='+ad.id+'&'+isTaskorEvent+'&returnID='+bar.Id+'&'+isNew+'&RecType=Institutional');
            pr.setRedirect(true);
            return pr;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
            return null;
        }
    }
    //Display Activity Histories in SLDS Related List
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