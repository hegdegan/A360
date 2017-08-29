public class MFS_ServiceRequestRelatedListController {
    private Case cse;
    private Id caseId;
    private id accountId;
    public List<PlanWrapper> planList{get;set;}
    public List<InvestmentWrapper> investmentList{get;set;}
    public Map<String, List<InvestmentWrapper>> investmentMap { get; set; }
    private Set<Id> selectedIds;
    public MFS_ServiceRequestRelatedListController(ApexPages.StandardController controller){
        
        Id recId = ApexPages.currentPage().getParameters().get('id');
        if(recId != null && recId.getSobjectType().getDescribe().getName() == 'Case'){
            caseId = recId;
        }
        else{
            PMAPS__c pmaps = [select id, service_request__c from PMAPS__C where id = :recId];
            if(pmaps.service_request__c != null){
                caseId = pmaps.service_request__c;
            }
        }
        Case[] caseList = [select id, accountId from Case where id = :caseId];
        if(caseList != null && caseList.size() > 0){
            accountId = caseList[0].accountId;
        }
        getRelatedRecords();
    }
    
    
	public void getRelatedRecords(){
        try{
            selectedIds = new Set<Id>();
            planList = new List<PlanWrapper>();
            investmentList = new List<InvestmentWrapper>();
            List<InvestmentWrapper> invList;
            investmentMap = new Map<String, List<InvestmentWrapper>>();
            List<Investments_Needing_Service__c> plnList = [select id, Plan__c, Plan__r.Name, Plan__r.Plan_ID__c, Plan__r.Plan_Start_Date__c, Plan__r.Plan_Type__c, Plan__r.Plan_Termination_Date__c 
                                                            from Investments_Needing_Service__c where Case__c = :caseId AND Investment__c = null];
            for(Investments_Needing_Service__c ins : plnList){
                //selectedIds.add(ins.Plan__c);
                planList.add(new PlanWrapper(ins.Plan__r.Name, ins.Plan__c, ins.Plan__r.Plan_Id__c, ins.Plan__r.Plan_Start_Date__c, ins.Plan__r.Plan_Type__c,
                                             ins.Plan__r.Plan_Termination_Date__c, true, ins.Id));
                if(!investmentMap.containsKey(ins.Plan__c)){
                    investmentMap.put(ins.Plan__c, new List<InvestmentWrapper>());
                    system.debug('added from plan=====');
                }
            }
            
            List<Investments_Needing_Service__c> clList = [select id, name, Investment__c, Investment__r.Plan__c, Investment__r.Name, Investment__r.Portfolio__c,Portfolios__c, Portfolio_Code__c, Vehicle__c, Account_Number__c, Investment__r.Account_Start_Date__c, 
                                                           Investment__r.Account_Termination_Date__c from Investments_Needing_Service__c where Case__c = :caseId AND Plan__c = null];
            List<InvestmentWrapper> tempInvestmentList;
            tempInvestmentList = new List<InvestmentWrapper>();
            for(Investments_Needing_Service__c inv : clList){
                if(!investmentMap.containsKey(inv.Investment__r.Plan__c)){
                    investmentMap.put(inv.Investment__r.Plan__c, new List<InvestmentWrapper>());
                    selectedIds.add(inv.Investment__r.Plan__c);
                }
                
                //System.debug(pw.recId+'==='+inv.Investment__r.Plan__c);
                investmentMap.get(inv.Investment__r.Plan__c).add(new InvestmentWrapper(inv.Investment__r.Name, inv.Investment__c, inv.Portfolios__c, inv.Investment__r.Portfolio__c, inv.Portfolio_Code__c, inv.vehicle__c,
                                                                                       inv.Account_Number__c, true, inv.Id));
            }
            //investmentMap.put(pw.recId, tempInvestmentList);
            System.debug('investmentMap before==>'+investmentMap.keySet());
            
            
            List<Plan__c> plansList = [select id, Name, Plan_ID__c, Plan_Start_Date__c, Plan_Type__c, Plan_Termination_Date__c, 
                                       (select id, name, Portfolio__c, Portfolio__r.Name, Portfolio_Code__c, Vehicle__c, Account_ID__c, Account_Start_Date__c, Account_Termination_Date__c from Portfolios__r)
                                       from Plan__c where Organization__c = :accountId ];
            for(Plan__c pln : plansList){
                if(investmentMap.containskey(pln.id) && selectedIds.contains(pln.Id))
                    planList.add(new PlanWrapper(pln.Name, pln.Id, pln.Plan_id__c, pln.Plan_Start_Date__c, pln.Plan_Type__c, pln.Plan_Termination_Date__c, false, null));
            }
            
            
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving the case '+ex.getMessage()+ex.getLineNumber() ));
        }        
    }
    
    public class PlanWrapper{
        //public Plan__c plan { get; set; }
        public String PlanLegalName { get; set; }
        public ID recId { get; set; }
        public String PlanId { get; set; }
        public Date PlanStartDate { get; set; }
        public String PlanType { get; set; }
        public Date PlanTerminationDate { get; set; }
        public Boolean selected { get; set; }
        public Id insId { get; set; }
        public PlanWrapper(String PlanLegalName, ID recId, String planId, Date planStartDate, String planType, Date planTerminationDate, Boolean selected, Id insId ){
            this.planLegalName = planLegalName;
            this.recId = recId;
            this.planId = planId;
            this.planStartDate = planStartDate;
            this.planType = planType;
            this.planTerminationDate = planTerminationDate;
            this.selected = selected;
            this.insId = insId;
        }
    }
    public class InvestmentWrapper{
        //public Account__c investment { get; set; }
        public String investmentName { get; set; }
        public Id recId { get; set; }
        public String portfolio { get; set; }
        public Id portfolioId { get; set; }
        public String portfolioCode { get; set; }
        public String vehicle { get; set; }
        public String accountNumber { get; set; }
        
        public Boolean selected { get; set; }
        public Id insId { get; set; }
        public InvestmentWrapper(String investmentName, Id recId, String portfolio, Id portfolioId, String portfolioCode, String vehicle, String accountNumber, Boolean selected, Id insId){
            this.investmentName = investmentName;
            this.recId = recId;
            this.portfolio = portfolio;
            this.portfolioId = portfolioId;
            this.portfolioCode = portfolioCode;
            this.vehicle = vehicle;
            this.accountNumber = accountNumber;
            this.selected = selected;
            this.insId = insId;
        }
    }
}