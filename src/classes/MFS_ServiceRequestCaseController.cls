public class MFS_ServiceRequestCaseController {
    public Case cse { get; set; }
    public List<PlanWrapper> planList{get;set;}
    public List<InvestmentWrapper> investmentList{get;set;}
    public Map<String, List<InvestmentWrapper>> investmentMap { get; set; }
    public Boolean displayPopup {get;set;}
    private Set<Id> relatedIdsToDelete;
    private Set<Id> selectedIds;
    public MFS_ServiceRequestCaseController(ApexPages.StandardController controller) {
        selectedIds = new Set<Id>();
        cse = (Case)controller.getRecord();
        cse = [select id, accountId from Case where id = :cse.Id];
        getRelatedRecords();
    }
    
    public void getRelatedRecords(){
        try{
            planList = new List<PlanWrapper>();
            investmentList = new List<InvestmentWrapper>();
            List<InvestmentWrapper> invList;
            investmentMap = new Map<String, List<InvestmentWrapper>>();
            List<Investments_Needing_Service__c> plnList = [select id, Plan__c, Plan__r.Name, Plan__r.Plan_ID__c, Plan__r.Plan_Start_Date__c, Plan__r.Plan_Type__c, Plan__r.Plan_Termination_Date__c 
                                                            from Investments_Needing_Service__c where Case__c = :cse.Id AND Investment__c = null];
            for(Investments_Needing_Service__c ins : plnList){
                selectedIds.add(ins.Plan__c);
                planList.add(new PlanWrapper(ins.Plan__r.Name, ins.Plan__c, ins.Plan__r.Plan_Id__c, ins.Plan__r.Plan_Start_Date__c, ins.Plan__r.Plan_Type__c,
                                             ins.Plan__r.Plan_Termination_Date__c, true, ins.Id));
            }
            
            List<Investments_Needing_Service__c> clList = [select id, name, Investment__c, Investment__r.Plan__c, Investment__r.Name, Investment__r.Portfolio__c,Portfolios__c, Portfolio_Code__c, Vehicle__c, Account_Number__c, Investment__r.Account_Start_Date__c, 
                                                           Investment__r.Account_Termination_Date__c from Investments_Needing_Service__c where Case__c = :cse.Id AND Plan__c = null];
            /*for(Investments_Needing_Service__c inv : clList){
                selectedIds.add(inv.Investment__c);
                investmentList.add(new InvestmentWrapper(inv.Investment__r.Name, inv.Investment__c, inv.Portfolios__c, inv.Investment__r.Portfolio__c, inv.Portfolio_Code__c, inv.vehicle__c,
                                                         inv.Account_Number__c, true, inv.Id));
            }*/
            List<InvestmentWrapper> tempInvestmentList;
            tempInvestmentList = new List<InvestmentWrapper>();
            for(Investments_Needing_Service__c inv : clList){
                if(!investmentMap.containsKey(inv.Investment__r.Plan__c)){
                    investmentMap.put(inv.Investment__r.Plan__c, new List<InvestmentWrapper>());
                }
                selectedIds.add(inv.Investment__c);
                //System.debug(pw.recId+'==='+inv.Investment__r.Plan__c);
                investmentMap.get(inv.Investment__r.Plan__c).add(new InvestmentWrapper(inv.Investment__r.Name, inv.Investment__c, inv.Portfolios__c, inv.Investment__r.Portfolio__c, inv.Portfolio_Code__c, inv.vehicle__c,
                                                                 inv.Account_Number__c, true, inv.Id));
            }
            //investmentMap.put(pw.recId, tempInvestmentList);
            System.debug('investmentMap before==>'+investmentMap);
            
            
            List<Plan__c> plansList = [select id, Name, Plan_ID__c, Plan_Start_Date__c, Plan_Type__c, Plan_Termination_Date__c, 
                                       (select id, name, Portfolio__c, Portfolio__r.Name, Portfolio_Code__c, Vehicle__c, Account_ID__c, Account_Start_Date__c, Account_Termination_Date__c from Portfolios__r)
                                       from Plan__c where Organization__c = :cse.AccountId ];
            for(Plan__c pln : plansList){
                if(!selectedIds.contains(pln.id))
                planList.add(new PlanWrapper(pln.Name, pln.Id, pln.Plan_id__c, pln.Plan_Start_Date__c, pln.Plan_Type__c, pln.Plan_Termination_Date__c, false, null));
            }
            
            List<Account__c> clientInvList = [select id, name, Plan__c, Portfolio__c, Portfolio__r.Name, Portfolio_Code__c, Vehicle__c, Account_Number__c, Account_Start_Date__c, Account_Termination_Date__c
                                              from Account__c where Organization__c =: cse.AccountId];
            /*for(Account__c inv : clientInvList){
                if(!selectedIds.contains(inv.id))
                investmentList.add(new InvestmentWrapper(inv.Name, inv.Id, inv.Portfolio__r.Name, inv.Portfolio__c, inv.Portfolio_Code__c, inv.vehicle__c, inv.Account_Number__c, false, null));
            }*/
            for(PlanWrapper pw : planList){
                tempInvestmentList = new List<InvestmentWrapper>();
                if(!investmentMap.containsKey(pw.recId))
                    investmentMap.put(pw.recId, tempInvestmentList);
                
                for(Account__c inv : clientInvList){
                    if(pw.recId == inv.Plan__c){
                        if(!selectedIds.contains(inv.id)){
                            investmentMap.get(pw.recId).add(new InvestmentWrapper(inv.Name, inv.Id, inv.Portfolio__r.Name, inv.Portfolio__c, inv.Portfolio_Code__c, inv.vehicle__c, inv.Account_Number__c, false, null)); 
                        }
                    }
                }
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving the case '+ex.getMessage() ));
        }        
    }
    
    public void closePopup() {
        displayPopup = false;
        
    }
    public Pagereference save(){
        System.debug('investmentMap====>'+investmentMap);
        relatedIdsToDelete = new Set<Id>();
        List<Investments_Needing_Service__c> clList = new List<Investments_Needing_Service__c>();
        Investments_Needing_Service__c cl;
        for(PlanWrapper pw : planList){
            if(pw.selected){
                if(!selectedIds.contains(pw.recId)){
                    cl = new Investments_Needing_Service__c(
                        Case__c = cse.Id,
                        Plan__c = pw.recId);
                    clList.add(cl);
                }
            }
            else{
                if(selectedIds.contains(pw.recId)){
                    relatedIdsToDelete.add(pw.insId);
                }
            }
        }
        for(List<InvestmentWrapper> iwList : investmentMap.values()){
            for(InvestmentWrapper iw: iwList){
                if(iw.selected){
                    if(!selectedIds.contains(iw.recId)){
                        cl = new Investments_Needing_Service__c(
                            Investment__c = iw.recId,
                            Case__c = cse.Id);
                        clList.add(cl);
                    }
                }
                else{
                    if(selectedIds.contains(iw.recId)){
                        relatedIdsToDelete.add(iw.insId);
                    }
                }
            }
        }
        
        if(relatedIdsToDelete.size () > 0){
            delete [select id from Investments_Needing_Service__c where Id IN : relatedIdsToDelete];
        }
        
        if(clList.size() > 0)
            upsert clList;
        return new Pagereference('/'+cse.Id);
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