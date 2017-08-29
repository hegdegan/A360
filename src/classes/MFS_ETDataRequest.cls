/***************************************************************************************************
Apex Class Name    : MFS_ETDataRequest
Version            : 1.0 
Created Date       : 29 JUN 2016
Function           : Controller used for all onboarding email templates
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey            06/29/2016              Original Version
***************************************************************************************************/
global with Sharing class MFS_ETDataRequest {
    
    private Case cse;
    public String caseId{get;set;}
    // private String portfolioCode;
    public String portfolioCode{get;set;}
    public String fundName{get;set;}
    public String vehicle{get;set;}
    public String shareClass{get;set;}
    public String reportingCurrency{get;set;}
    public String portfolios{get;set;}
    public String relationshipManager{get;set;}
    public String csm{get;set;}
    public String consultant{get;set;}
    public Account orgDetails;
    Public Case cseDetails; 
    
    //Constructor
    global MFS_ETDataRequest() {   
    }
    
    //Get Case details
    public Case getCase(){
        try{
            cseDetails=[select id,Due_Date__c,Purpose__c,Service_Provider_Org_Name__c,Additional_Details__c,Start_Date__c,Service_Provider_Org_Name__r.Name, accountid, RecordType.DeveloperName from case where id=:caseId and RecordType.DeveloperName=: Label.ET_Service_Request];
            getInvestmentNeedingServices(caseId);
            getRoles(caseId); 
        } catch(Exception ex) {
            System.debug('Exception Occured'+ex.getStackTraceString());
        }
        return cseDetails;
    }
    
    //Get related Organization details
    global Account getOrgDetails(){
        try {
            Case c=getCase();
            orgDetails= [select id,Distribution_Level__c, Distribution_Sub_Channel__c, Name, Institutional_Tier__c,US_Retail_Tier__c,Non_US_Retail_Tier__c, BillingCountry from Account where id=:c.AccountId];
            List<Relationship__c> rel = [Select Type__c,Primary_Contact__r.Name,Relationship__r.Name from Relationship__c where Organization__c =: c.AccountId];
            consultant='';
            for(Relationship__c ins:rel){
                if(ins.Type__c!=null && ins.Type__c == Label.ET_Org_Consultant){
                    if(consultant=='') {
                        consultant=ins.Relationship__r.Name;
                    } else {
                        consultant+=', '+ins.Relationship__r.Name;  
                    }
                } 
            } 
        } catch(Exception ex) {
            System.debug('Exception Occured'+ex.getStackTraceString());
        }
        return orgDetails;
    }
    
    //Get related Investment needing services details
    global void getInvestmentNeedingServices(Id caseId){
        try {
            if(caseId != null) {
                List<Investments_Needing_Service__c> FundList = new List<Investments_Needing_Service__c>([select Portfolio_code__c,Investment__r.Name,vehicle__c,Share_Class__c,Reporting_Currency__c,Portfolios__c from Investments_Needing_Service__c where Case__c =:caseId]);
                portfolioCode='';
                fundName='';
                vehicle=''; 
                shareClass='';
                reportingCurrency='';
                portfolios='';
                for(Investments_Needing_Service__c ins:fundList){
                    
                    if(ins.Portfolio_code__c!=null){
                        if(portfolioCode=='') {
                            portfolioCode=ins.Portfolio_code__c;
                        } else {
                            portfolioCode+=', '+ins.Portfolio_code__c;
                            
                        }
                    }
                    
                    if(ins.Investment__r.Name!=null){
                        if(fundName=='') {
                            fundName+=ins.Investment__r.Name;
                        } else {
                            fundName+=', '+ins.Investment__r.Name; 
                        }
                    }
                    
                    if(ins.vehicle__c!=null){
                        if(vehicle=='') {
                            vehicle=ins.vehicle__c;
                        } else {
                            vehicle+=', '+ins.vehicle__c;
                        }
                    }
                    
                    if(ins.Share_Class__c!=null){
                        if(shareClass=='') {
                            shareClass=ins.Share_Class__c;
                        } else {
                            shareClass+=', '+ins.Share_Class__c;
                        }
                    }
                    
                    if(ins.Reporting_Currency__c!=null){
                        if(reportingCurrency=='') {
                            reportingCurrency=ins.Reporting_Currency__c;
                            
                        } else {
                            reportingCurrency+=', '+ins.Reporting_Currency__c;
                            
                        }
                    }
                    
                    if(ins.Portfolios__c!=null){
                        if(portfolios=='') {
                            portfolios=ins.Portfolios__c;  
                        } else {
                            portfolios+=', '+ins.Portfolios__c;
                            
                        }
                    }
                }
            }
        } catch(Exception ex) {
            System.debug('Exception Occured'+ex.getStackTraceString());
        }
    }
    //Get related CaseTeamMember details
    global void getRoles(Id caseId){
        try {
            if(caseId!=null) {
                List<CaseTeamMember> caseContact = [Select MemberId,Member.Name,teamroleId from CaseTeamMember where parentid =: caseId];
                relationshipManager='';
                csm='';
                for(CaseTeamMember ins:caseContact){
                    if(ins.teamroleId !=null && ins.teamroleId==Label.ET_RelationshipManagerId){
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
            System.debug('Exception Occured'+ex.getStackTraceString());
        }
    }
    
    public Case getTerminationCase(){
        Case tCase = new Case();
        try{
            tCase=[select id, Account.Name, Portfolio_Name__r.Style__c, Portfolio_Name__r.Name, Portfolio_Name__r.Portfolio_Code__c, Termination_Reason__c,
                   Consultant_Contact__r.Account.Name, Consultant_Contact__r.Name, MFS_Contracting_Entity__c,
                   Current_Assets__c, Stop_Buying_Date__c, Stop_Sell_Date__c, Closing_Termination_Date__c, Liquidation_Requested__c, When_are_proceeds_needed__c, 
                   Special_Trading_Instructions__c, Last_Reporting_Date__c, Last_Valuation_Date__c, Last_Billing_Date__c, Original_Funding_Date__c, Termination_Reviewer__r.name,
                   Can_manual_reporting_be_ceased__c, Others_still_in_share_class_vehicle__c, Other_Accounts_with_Client__c from case where id=:caseId];
        } catch(Exception ex) {
            System.debug('Exception Occured'+ex.getStackTraceString());
        }
        return tCase;
    }
    
}