/*
Apex class            :  MFS_Activity360SF1Utility
Version               :  1.0
Created Date          :  16 SEP 2016
Function              :  This Utility class contains all the common methods related to Activity360 and SLDS lookups

Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* Gyanendra Singh            16 SEP 2016              Initial Version
*/
global with sharing class MFS_Activity360SF1Utility {
    
    //Get all the picklist values for the multiselect picklist Activity_Type_for_Instit__c
    public static String getAllActivityType(Event parentEvent){
        String options = '';
        
        try{
            Set<String> valuesFromSchema = new Set<String>();
            
            Schema.Describefieldresult fieldResult = Schema.sObjectType.Event.fields.Activity_Type_for_Instit__c;
            fieldResult = fieldResult.getSObjectField().getDescribe();
            
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                valuesFromSchema.add(f.getLabel());
            }
            
            Set<String> valuesToDisplay = new Set<String>(valuesFromSchema);
            if(!String.isEmpty(parentEvent.Activity_Type_for_Instit__c)){
                List<String> tempList = new List<String>(parentEvent.Activity_Type_for_Instit__c.split(';'));
                Set<String> selectedlang = new Set<String>(tempList);
                valuesToDisplay.clear();
                
                for(String schmaValue : valuesFromSchema){
                    if(!selectedLang.contains(schmaValue)) 
                        valuesToDisplay.add(schmaValue);
                }
            }
            
            for(String val : valuesToDisplay){
                if(String.isEmpty(options))
                    options = val;
                else
                    options = options+','+val;
            }  
        }
        catch(Exception ex){
            system.debug('Exception in getAllActivityType : '+ex.getStackTraceString());
            throw ex;
        }
        
        return options;
    }
    
    //Get all the selected values for the multiselect picklist Activity_Type_for_Instit__c
    public static String getSelectedActivityTypes(Event parentEvent){
        String options = '';
        
        try{
            Set<String> valuesToDisplay = new Set<String>();
            
            if(parentEvent!=null && !String.isEmpty(parentEvent.Activity_Type_for_Instit__c)){
                List<String> tempList = new List<String>(parentEvent.Activity_Type_for_Instit__c.split(';'));
                Set<String> selectedlang = new Set<String>(tempList);
                
                for(String schmaValue : selectedlang){
                    valuesToDisplay.add(schmaValue);
                }
            }
            
            for(String val : valuesToDisplay){
                if(String.isEmpty(options))
                    options = MFS_AllConstants.EVENT_ACTIVITY_TYPE_FOR_INST_VALUES.get(val);
                else
                    options = options+','+MFS_AllConstants.EVENT_ACTIVITY_TYPE_FOR_INST_VALUES.get(val);
            } 
        }
        catch(Exception ex){
            system.debug('Exception in getSelectedActivityTypes : '+ex.getStackTraceString());
            throw ex;
        }
        
        return options;
    }
    /* 
//Get all the picklist values for the multiselect picklist Activity_Type_for_Instit__c for follow up tasks
public static String getAllActivityTypeForFollowUp(Task task){
String options = '';

try{
Set<String> valuesFromSchema = new Set<String>();

Schema.Describefieldresult fieldResult = Schema.sObjectType.task.fields.Activity_Type_for_Instit__c;
fieldResult = fieldResult.getSObjectField().getDescribe();

List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

for( Schema.PicklistEntry f : ple){
valuesFromSchema.add(f.getLabel());
}

Set<String> valuesToDisplay = new Set<String>(valuesFromSchema);
if(task.Activity_Type_for_Instit__c != NULL && !String.isEmpty(task.Activity_Type_for_Instit__c)){
List<String> tempList = new List<String>(task.Activity_Type_for_Instit__c.split(';'));
Set<String> selectedlang = new Set<String>(tempList);
valuesToDisplay.clear();

for(String schmaValue : valuesFromSchema){
if(!selectedLang.contains(schmaValue)) 
valuesToDisplay.add(schmaValue);
}
}

for(String val : valuesToDisplay){
if(String.isEmpty(options))
options = val;
else
options = options+','+val;
}  
}
catch(Exception ex){
throw ex;
}

return options;
}

//Get all the selected values for the multiselect picklist Activity_Type_for_Instit__c for follow up tasks
public static String getSelectedActivityTypesForFollowUp(Task task){
String options = '';

try{
Set<String> valuesToDisplay = new Set<String>();

if(task!=null && !String.isEmpty(task.Activity_Type_for_Instit__c)){
List<String> tempList = new List<String>(task.Activity_Type_for_Instit__c.split(';'));
Set<String> selectedlang = new Set<String>(tempList);

for(String schmaValue : selectedlang){
valuesToDisplay.add(schmaValue);
}
}

for(String val : valuesToDisplay){
if(String.isEmpty(options))
options = val;
else
options = options+','+val;
}  
}
catch(Exception ex){
throw ex;
}
return options;
}
*/
    /***************** All the remote call code starts ********************/
    
    //Remote method to return the list of contact records matching the keyword
    @RemoteAction
    global static List<Contact> queryContacts(String keyword) {
        List<Contact> contactList = new List<Contact>();
        if (keyword != null && keyword.trim() != '') {
            keyword = keyword + '*';
            List<List<SObject>> searchList = [FIND :keyword In NAME FIELDS RETURNING CONTACT(Id, FirstName, LastName LIMIT 20)];
            contactList = (List<Contact>)searchList[0];
        }  
        return contactList;
    }
    
    //Remote method to return the list of User records matching the keyword
    @RemoteAction
    global static List<User> queryUsers(String keyword) { 
        List<User> UserList = new List<User>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            UserList = [Select Id, FirstName, LastName from User where Name like :keyword limit 20];
        }  
        return UserList;
    }
    
    
    //Remote method to return the list of Lead records matching the keyword
    @RemoteAction
    global static List<Lead> queryLeads(String keyword) { 
        List<Lead> leadList = new List<Lead>();
        
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            leadList = [Select Id, FirstName, LastName from Lead where Name like :keyword limit 20];
        }  
        return leadList;
    }
    
    //Remote method to return the list of Account records matching the keyword
    @RemoteAction
    global static List<Account> queryAccounts(String keyword) {
        List<Account> accountList = new List<Account>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            accountList = [Select Id, Name from Account where Name like :keyword limit 20];
        }  
        return accountList;
    }
    
    //Remote method to return the list of Opportunity records matching the keyword
    @RemoteAction
    global static List<Opportunity> queryOpportunities(String keyword) {
        List<Opportunity> opportunityList = new List<Opportunity>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            opportunityList = [Select Id, Name from Opportunity where Name like :keyword limit 20];
        }  
        return opportunityList;
    }
    
    //Remote method to return the list of ClientInvestment records matching the keyword
    @RemoteAction
    global static List<Account__c> queryClientInvestments(String keyword) {
        List<Account__c> ClientInv = new List<Account__c>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%'; 
            ClientInv = [select Id,Name,Portfolio__r.Name from Account__c where Name like :keyword LIMIT 20];
        }  
        return ClientInv;
    }
    
    //Remote method to return the list of POrtfolio records matching the keyword
    @RemoteAction
    global static List<Product2> queryPortfolios(String keyword) {
        List<Product2> ClientInv = new List<Product2>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%'; 
            ClientInv = [select Id,Name from Product2 where Name like :keyword LIMIT 20];
        }
        return ClientInv;
    }
    
    //Remote method to return the list of contact records matching the keyword
    @RemoteAction
    global static List<Campaign> queryCampaign(String keyword) {
        List<Campaign> campList = new List<Campaign>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%'; 
            campList = [select Id,Name from Campaign where Name like :keyword LIMIT 20];
        }  
        return campList;
    }
    
    //Remote method to return the list of Business at Risk records matching the keyword
    @RemoteAction
    global static List<Business_At_Risk__c> queryBAR(String keyword) {
        List<Business_At_Risk__c> barList = new List<Business_At_Risk__c>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%'; 
            barList = [select Id,Name from Business_At_Risk__c where Name like :keyword LIMIT 20];
        }  
        return barList;
    }
    
    //Remote method to return the list of Strategy Plan records matching the keyword
    @RemoteAction
    global static List<Strategy_Plan__c> queryStrategyPlans(String keyword) {
        List<Strategy_Plan__c> spList = new List<Strategy_Plan__c>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%'; 
            spList = [select Id,Name from Strategy_Plan__c where Name like :keyword LIMIT 20];
        }  
        return spList;
    }
    
    //Remote method to return the list of Consultant Rating records matching the keyword
    @RemoteAction
    global static List<Consultant_Rating__c> queryConsultantRating(String keyword) { 
        List<Consultant_Rating__c> conRatingList = new List<Consultant_Rating__c>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            conRatingList = [Select Id, Name from Consultant_Rating__c where Name like :keyword limit 20];
        }  
        return conRatingList;
    }
    
    //Remote method to return the list of Case records matching the keyword
    @RemoteAction
    global static List<Case> queryCase(String keyword) {
        List<Case> cseList = new List<Case>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%'; 
            cseList = [select Id,CaseNUmber from Case where CaseNumber like :keyword LIMIT 20];
        }  
        return cseList;
    }
}