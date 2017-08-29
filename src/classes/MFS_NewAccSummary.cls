/***************************************************************************************************
Apex Class Name    : MFS_NewAccSummary
Version            : 1.0 
Created Date       : 9 NOV 2016
Function           : Controller used for all onboarding email templates
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey            11/09/2016              Original Version
***************************************************************************************************/

global with Sharing class MFS_NewAccSummary {
    
    private List<Case_Contact_Role__c> caseContactRole;
    public String caseId{get;set;}
    public Case caseRec;
    public String custodyBank{get;set;}
    public String recordKeeper{get;set;}
    
    //Contact Role properties:
    public String portfolioManager {get;set;}
    public String transitionManager {get;set;}
    public String ACSDistributor {get;set;}
    public String relationshipManager {get;set;}
    public String csm {get;set;}
    public String salesperson {get;set;}
    public String institutionalSales{get;set;}
    public String administrator {get;set;}
    public String recKeeper {get;set;}
    // global Case caseRec{get;set;}
    
    global MFS_NewAccSummary(){
        
    }
    
    //Query all Case information
    global Case getCaseRec(){
        try{
            caseRec= [Select
                      id,
                      Account.BillingCountry,
                      Account.Internet_Set_Up_For_Account__c,
                      Account.Distribution_Level__c,
                      Account.Entity_Status__c,
                      AccountId,
                      Account.mdm_ID__c,
                      Account.Name,
                      Account.Id,
                      Account.Organization_Sub_Type__c,
                      Actual_Funding_Date__c,
                      Benchmark_Primary__c,
                      Bill_on_Custodian_Assets__c,
                      Billing_Contact_Name__r.Email,
                      Billing_Contact_Name__r.MailingCity,
                      Billing_Contact_Name__r.MailingCountry,
                      Billing_Contact_Name__r.MailingPostalcode,
                      Billing_Contact_Name__r.MailingState,
                      Billing_Contact_Name__r.MailingStreet,
                      Billing_Contact_Name__r.Name,
                      Billing_Currency__c,
                      Billing_Inception_Date__c,
                      Cash_Flow_Currency__c,
                      Cash_Management__c,
                      Client_Investment__r.Account_Number__c,
                      Client_Investment__r.Plan__r.DC_Plan_Type_if_known__c,
                      Client_Investment__r.Plan__r.Plan_Type__c,
                      Client_Investment__r.Performance_Start_Date__c,
                      Client_Investment__r.Plan__r.Plan_Fiscal_Year_End__c,
                      Client_Legal_Name__c,
                      Client_Service_Manager__c,
                      Consultant_Contact__r.name,
                      CurrencyIsoCode,
                      Directed_Trading__c,
                      Dodd_Frank_Form_Received_Back__c,
                      Effective_Fee_Schedule__c,
                      Expected_Cash_Flows__c,
                      Expected_Funding_Amount__c,
                      Fee_Schedule__c,
                      First_Reporting_Period__c,
                      Freedom_of_Information_Act_Applicable__c,
                      Funding_Method__c,
                      Funding_Source__c,
                      Funding_Date__c,
                      FX_on_Flow__c,
                      FX_on_Repatriation_of_Income_Dividends__c,
                      FX_on_Trading_Activity__c,
                      Internet_set_up_for_your_account__c,
                      Invest_Cash_Short_Term__c,
                      Investment_Share_Class__c,
                      Invoicing_or_Rebate__c,
                      Is_client_allowed_to_trade_Derivatives__c,
                      LEI_Number__c,
                      Model_Portfolio__c,
                      Most_Favored_Nations__c,
                      New_Attribution_Required__c,
                      Omnibus__c,
                      Other_Application_Fees__c,
                      Participate_in_IPOs__c,
                      Performance_Based_Fee__c,
                      Plan_Legal_Name__c,
                      PLSA_Requirement__c,
                      Portfolio_Code__c,
                      Portfolio_Name__r.Name,
                      Portfolio_Name__r.Vehicle__C,
                      Portfolio_s_Country_of_Domicile__c,
                      Portfolio_Valuation_Date_First_NAV__c,
                      Proxy_Voting__c,
                      Qualified_Institutional_Buyer__c,
                      Related_To_Opportunity__r.Client_Contact__r.Contact_Name__c,
                      Relationship_Manager__c,
                      Related_To_Opportunity__r.Consultant__r.Name,
                      Related_To_Opportunity__r.Consultant_Contact__r.Contact_Name__c,
                      Related_To_Opportunity__r.Opportunity_Platform__c,
                      Reporting_Currency__c,
                      Reporting_Name__c,
                      Reporting_Requirements__c,
                      SalesPerson__c,
                      Secondary_Benchmark__c,
                      Sector_Scheme__c,
                      Share_Class__c,
                      Tax_ID_Number_of_Portfolio__c,
                      Tax_Status__c,
                      ERISA__c,
                      Tier__c,Billing_Contact_Name__c,
                      Trade_Date_Investment_on_inflows__c,
                      Trading_Currency__c,
                      Transition_Performance__c,
                      Transition_Range__c,
                      Turnover_Methodology__c,
                      Type,
                      Use_of_Soft_Dollars__c,
                      VAT_Comment__c,
                      VAT_Registration_Number_for_European_ac__c,
                      Effective_date_of_the_agreement__c,
                      Effective_Date__c 
                      from Case where id =:caseId];
            getRoles(caseId);
            getCaseContactRoles(caseId);
            getRelationship(CaseRec.AccountId);
        } catch(Exception ex) {
            System.debug('Exception: '+ex.getStackTraceString());
        }
        return CaseRec;
    }
    
    //Get all Case Team Member Roles (User)
    global void getRoles(Id c){
        try {
            if(c!=null) {
                List<CaseTeamMember> caseContact = [Select MemberId,Member.Name,teamroleId from CaseTeamMember where parentid =: c];
                portfolioManager='';
                institutionalSales='';
                relationshipManager='';
                csm='';
                for(CaseTeamMember ins:caseContact){
                    if(ins.teamroleId !=null && ins.teamroleId==Label.ET_PortfolioManagerId){
                        if(portfolioManager=='') {
                            portfolioManager=ins.Member.Name;
                        } else {
                            portfolioManager+=', '+ins.Member.Name;  
                        }
                    } else if(ins.teamroleId !=null && ins.teamroleId==Label.ET_InstitutionalSalesId){
                        if(institutionalSales=='') {
                            institutionalSales=ins.Member.Name;
                        } else {
                            institutionalSales+=', '+ins.Member.Name;  
                        }
                    } else if(ins.teamroleId !=null && ins.teamroleId==Label.ET_RelationshipManagerId){
                        if(relationshipManager=='') {
                            relationshipManager=ins.Member.Name;
                        } else {
                            relationshipManager+=', '+ins.Member.Name;  
                        }
                    } else if(ins.teamroleId !=null && ins.teamroleId==Label.ET_CsmId){
                        if(csm=='') {
                            csm=ins.Member.Name;
                        } else {
                            csm+=', '+ins.Member.Name;  
                        }
                    }  
                }   
            }
        } catch(Exception ex) {
            System.debug('Exception: '+ex.getStackTraceString());
        }
    }
    
    //Get all Case Contact Roles
    global void getCaseContactRoles(Id c){
        try {
            if(c!=null) {
                List<Case_Contact_role__c> caseContact = [Select Contact__c,Role__c,Contact__r.Name from Case_Contact_role__c where Case__c =: c];
                transitionManager='';
                salesperson='';
                administrator='';
                ACSDistributor='';
                for(Case_Contact_role__c ins:caseContact){
                    if(ins.Role__c!=null && ins.Role__c.contains(Label.ET_Transition_Manager)){
                        if(transitionManager=='') {
                            transitionManager=ins.Contact__r.Name;
                        } else {
                            transitionManager+=', '+ins.Contact__r.Name;  
                        }
                    }
                    if(ins.Role__c!=null && ins.Role__c.contains(Label.ET_Sales_Person)){
                        if(salesperson=='') {
                            salesperson=ins.Contact__r.Name;
                        } else {
                            salesperson+=', '+ins.Contact__r.Name;  
                        }
                    }
                    if(ins.Role__c!=null && ins.Role__c.contains(Label.ET_Administrator)){
                        if(administrator=='') {
                            administrator=ins.Contact__r.Name;
                        } else {
                            administrator+=', '+ins.Contact__r.Name;  
                        }
                    }
                    if(ins.Role__c!=null && ins.Role__c.contains(Label.ET_ACS_Distributor)){
                        if(ACSDistributor=='') {
                            ACSDistributor=ins.Contact__r.Name;
                        } else {
                            ACSDistributor+=', '+ins.Contact__r.Name;  
                        }
                    }   
                }
            }
        } catch(Exception ex) {
            System.debug('Exception: '+ex.getStackTraceString());
        }
    }
    
    //Get Organization Relationship
    global void getRelationship(Id org){
        try {
            if(org!=null) {
                List<Relationship__c> rel = [Select Type__c,Primary_Contact__r.Name,Relationship__r.Name from Relationship__c where Organization__c =:org];
                recordKeeper='';
                custodyBank='';
                for(Relationship__c ins:rel){
                    if(ins.Type__c!=null && ins.Type__c == Label.ET_Record_Keeper){
                        if(recordKeeper=='') {
                            recordKeeper=ins.Primary_Contact__r.Name;
                        } else {
                            recordKeeper+=', '+ins.Primary_Contact__r.Name;  
                        }
                    } else if(ins.Type__c!=null && ins.Type__c == Label.Custodian){
                        if(custodyBank=='') {
                            custodyBank=ins.Relationship__r.Name;
                        } else {
                            custodyBank+=', '+ins.Relationship__r.Name;  
                        }
                    }
                }
            }
        } catch(Exception ex) {
            System.debug('Exception: '+ex.getStackTraceString());
        }
    }
}