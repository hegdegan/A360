/***************************************************************************************************
Apex Class Name    : MFS_MyContactsController 
Version            : 1.0 
Created Date       : 03 OCT 2016
Function           : Class is used to fetch my contact for the custom page
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
Ganesh Hegde				03 OCT 2016				Original Version
***************************************************************************************************/
global with sharing class MFS_MyContactsController {
    //Controller Constants
    private static final String INSTITUTIONAL = 'Institutional';
    private static final String RETAIL = 'Retail';
    private static final String SYSADMIN = 'System Admin';
    private static final String CLIENT_SERVICE = 'Client Service';
    //My Contacts tab variables
    public transient List<Contact> myContactsList { get; set; }
    private transient Set<Id> contIds;
    @testVisible private Integer contIdSetSize;
    private Set<Id> allContIds;
    public String userType {get;set;}
    Public Integer size {get;set;} 
    private Integer queryLimit;
    public Integer noOfRecords{get; set;}
    public Boolean isInConsole {get;set;}
    private transient List<JSONWrapper> storeAllContacts;
    public String JSONContacts{get;set;}
    @testvisible private String loggedInUser;
    
    public String searchMCName{
        get{ return searchMCName;}
        set{searchMCName = value;}
    }
    public String searchMCCity{
        get{ return searchMCCity;}
        set{searchMCCity = value;}
    }
    public String searchMCState{
        get{ return searchMCState;}
        set{searchMCState = value;}
    }
    public String searchMCCountry{
        get{ return searchMCCountry;}
        set{searchMCCountry = value;}
    }
    public String searchMCEmail{
        get{ return searchMCEmail;}
        set{searchMCEmail = value;}
    }
    public String searchMCOrg{
        get{ return searchMCOrg;}
        set{searchMCOrg = value;}
    }
    public String searchMCZone{
        get{ return searchMCZone;}
        set{searchMCZone = value;}
    }
    
    //Constructor for the custom page
    public MFS_MyContactsController()
    {
        try{
            //Record size for initial load
            size=500;
            contIdSetSize=0;
            loggedInUser = UserInfo.getUserId();
            //check for sales console
            String urlVal = Apexpages.currentPage().getUrl();
            if(urlVal.containsIgnoreCase('isdtp')) {
                isInConsole=true;
            }
            //query 10,000 records while viewing in desktop and 1,000 records while viewing in mobile
           	queryLimit = UserInfo.getUiThemeDisplayed() == 'Theme4t' ? 1000 : 10000;
            contIds = new Set<Id>();
            allContIds = new Set<ID>();
            myContactsList = new List<Contact>();
            storeAllContacts=new  List<JSONWrapper> ();
            String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
            setContactsIdList(profileName);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.My_Cont_Message2 +e.getMessage()));
        }
    }
    
    private void setContactsIdList(String profileName) {
        contIds = new Set<Id>();
        //Get Ids from Institutional Users
        if(profileName.containsIgnoreCase(INSTITUTIONAL) || profileName.containsIgnoreCase(CLIENT_SERVICE) || profileName.containsIgnoreCase('Global Consultant Relations')) {
            List<AccountTeamMember> mfsCovTeam = new List<AccountTeamMember>([Select id, accountId, UserId from AccountTeamMember where userId = :UserInfo.getUserId() LIMIT 10000]);
            for(AccountTeamMember atm : mfsCovTeam) {                
                contIds.add(atm.accountId);
            }
            List<Contact> contToQuery= new List<Contact>([select id from Contact where accountId IN :contIds LIMIT 10000]);
            contIds.clear();
            for(Contact c : contToQuery) {
                contIds.add(c.Id);
            }
            userType = INSTITUTIONAL;
            contIdSetSize = contIds.size();
            getMyContacts();
        }
        //Get Ids for Retail Users
        else if(profileName.containsIgnoreCase(RETAIL)) {
            List<Coverage_Team__c> mfsCovTeam = new List<Coverage_Team__c>([Select id, Contact__c from Coverage_Team__c where Coverage_Owner__c = :UserInfo.getUserId() LIMIT 10000]);
            for(Coverage_Team__c atm : mfsCovTeam) {
                contIds.add(atm.Contact__c);
            }
            userType = RETAIL;
            contIdSetSize = contIds.size();
            getMyContacts();
        }
        //Get Ids for System Admin
        else {
            List<AccountTeamMember> mfsCovTeam = new List<AccountTeamMember>([Select id, accountId, UserId from AccountTeamMember where userId = :UserInfo.getUserId() LIMIT 10000]);
            for(AccountTeamMember atm : mfsCovTeam) {
                contIds.add(atm.accountId);
            }
            List<Contact> tempCont = new List<Contact>([select id from contact where accountId in :contIds LIMIT 10000]);
            contIds.clear();
            for(Contact c : tempCont) {
                contIds.add(c.id);
            }
            List<Coverage_Team__c> contCoverageTeam = new List<Coverage_Team__c>([Select id, Contact__c from Coverage_Team__c where Coverage_Owner__c = :UserInfo.getUserId() LIMIT 10000]);
            for(Coverage_Team__c atm : contCoverageTeam) {
                contIds.add(atm.Contact__c);
            }
            userType = SYSADMIN;
            contIdSetSize = contIds.size();
            getMyContacts();
        }
    }
    
    //fetch the contacts related to Organizations where they have been assigned to Organization's MFS Coverage Team/ Contact coverage team.
    public ApexPages.StandardSetController myInstContacts {
        get {
            if(myInstContacts == null) {
                if(userType == INSTITUTIONAL)                
                    myInstContacts = new ApexPages.StandardSetController(Database.getQueryLocator(
                        [Select Id, Name, LastName,MiddleName, FirstName, AccountId, Account.Name, MailingStreet, MailingCity, MailingState, MailingCountry, YTD_Sales_in_USD__c, LastActivityDate, Email, Phone from Contact where ID IN :contIds AND Status__c = 'Active' LIMIT :queryLimit]));
                else
                    myInstContacts = new ApexPages.StandardSetController(Database.getQueryLocator(
                        [Select Id, Name, LastName,MiddleName, FirstName, AccountId, Account.Name, MailingStreet, MailingCity, MailingState, MailingCountry, YTD_Sales_in_USD__c, LastActivityDate,Email, Phone from Contact where Id IN :contIds AND Status__c = 'Active' LIMIT :queryLimit]));
                myInstContacts.setPageSize(size);  
                noOfRecords = myInstContacts.getResultSize();
            }            
            return myInstContacts;
        }
        set;
    }
    
    //get my contacts records and assign to List/JSON
    public void getMyContacts() {
        searchMCName='';
        searchMCState='';
        searchMCCity = '';
        searchMCCountry='';
        searchMCOrg='';
        searchMCEmail='';
        searchMCZone='';
        storeAllContacts=new  List<JSONWrapper> ();
        myContactsList = new List<Contact>((List<Contact>)myInstContacts.getRecords());        
        for(Contact contRec:myContactsList) 
        {
            storeAllContacts.add(new JSONWrapper(contRec.Id,contRec.FirstName,contRec.MiddleName,contRec.LastName,contRec.AccountId,contRec.Account.Name));
        }
        //Send only first 1000 contacts to mobile page
        while(myInstContacts.getHasNext())
        {
            myInstContacts.next();
            for(Contact contRec:(List<Contact>)myInstContacts.getRecords()) 
            {
                storeAllContacts.add(new JSONWrapper(contRec.Id,contRec.FirstName,contRec.MiddleName,contRec.LastName,contRec.AccountId,contRec.Account.Name));
                break;
            }
        }
        JSONContacts=JSON.serialize(storeAllContacts);
        myInstContacts.first();
    }
    
    //Get next set of contacts
    public void getNextContacts() {
        myInstContacts.next();
        myCOntactsList = new List<Contact>((List<Contact>)myInstContacts.getRecords());
    }
    
    //Get previous set of contacts
    public void getpreviousContacts() {
        myInstContacts.previous();
        myCOntactsList = new List<Contact>((List<Contact>)myInstContacts.getRecords()); 
    }
    
    //Set the page size for pagination
    public PageReference refreshPageSize() {
        myInstContacts.setPageSize(size);
        return null;
    }
    
    //Search is performed using both SOSL and SOQL because of the limitations on encrypted fields
    public void searchInMyContacts() {
        try{
            if(contIdSetSize > 0) {           
                if((!String.isEmpty(searchMCName) && searchMCName.trim().length()>2)
                   || (!String.isEmpty(searchMCOrg) && searchMCOrg.trim().length()>2 )
                   || (!String.isEmpty(searchMCCity) && searchMCCity.trim().length()>2)
                   || (!String.isEmpty(searchMCState) && searchMCState.trim().length()>2 )
                   || (!String.isEmpty(searchMCCountry) && searchMCCountry.trim().length()>2)
                   || (!String.isEmpty(searchMCZone) && searchMCZone.trim().length()>2 )) {
                       
                       Boolean isNameFiltered = false;
                       Boolean isFiltered = false;
                       Map<Id,Contact> tempSearchMap = new Map<Id,Contact>();
                       Map<Id,Contact> filteredMap = new Map<Id,Contact>();
                       String keyword0 = '';
                       String keyword1='';
                       String keyword2='';
                       String keyword3='';
                       String keyword4='';
                       String keyword5 = '';
                       String whereClauseString = '';
                       List<Contact> searchList = new List<Contact>();
                       if(!String.isEmpty(searchMCName) && searchMCName.trim().length() > 2){
                           keyword0 = '%'+searchMCName.Trim()+'%';
                           whereClauseString += ' AND Name__c like :keyword0 ';
                       }
                       if(!String.isEmpty(searchMCOrg) && searchMCOrg.trim().length()>2){
                           keyword1 = '%'+searchMCOrg.Trim()+'%';
                           whereClauseString += ' AND Account.Name like :keyword1 ';
                       }
                       if(!String.isEmpty(searchMCCity) && searchMCCity.trim().length() > 2){
                           keyword2 = '%'+searchMCCity.Trim()+'%';
                           whereClauseString += ' AND (MailingCity like :keyword2 OR OtherCity like :keyword2) ';
                       }
                       if(!String.isEmpty(searchMCState) && searchMCState.trim().length() > 2){
                           keyword3 = '%'+searchMCState.Trim()+'%';
                           whereClauseString += ' AND (MailingState like :keyword3 OR OtherState like :keyword3) ';
                       }
                       if(!String.isEmpty(searchMCCountry) && searchMCCountry.trim().length() > 2){
                           keyword4 = '%'+searchMCCountry.Trim()+'%';
                           whereClauseString += ' AND (MailingCountry like :keyword4 OR OtherCountry like :keyword4) ';
                       }
                       String coverageTeamQueryString = 'select contact__c from coverage_team__c where coverage_owner__c= :loggedInUser and contact__c != null';
                       Boolean skipInstQuery = false;
                       if(!String.isEmpty(searchMCZone) && searchMCZone.trim().length() > 2){
                           skipInstQuery = true;
                           keyword5 = '%'+searchMCZone.Trim()+'%';
                           coverageTeamQueryString += ' AND Zone__c like :keyword5 ';
                       }
                       String searchQuery = 'Select Id, Name,LastName,MiddleName, FirstName, AccountId, Account.Name, MailingStreet, MailingCity, MailingState, MailingCountry, YTD_Sales_in_USD__c, LastActivityDate, Phone, Email  from Contact where Status__c = \'Active\' and ';
                       if(userType== SYSADMIN)
                       {
                           if(!skipInstQuery){
                               String searchQueryInst =  searchQuery + 'AccountId IN (Select accountId from AccountTeamMember where userId = :loggedInUser) '+whereClauseString+' ORDER BY CREATEDDATE DESC LIMIT 1000';
                               searchList.addAll((List<Contact>)Database.query(searchQueryInst));
                           }
                           String searchQueryRet =  searchQuery + 'Id IN ('+coverageTeamQueryString+') '+whereClauseString+' ORDER BY CREATEDDATE DESC LIMIT 1000';
                           searchList.addAll((List<Contact>)Database.query(searchQueryRet));
                       }
                       if(userType== INSTITUTIONAL)
                       {
                           String searchQueryInst = searchQuery + 'AccountId IN (Select accountId from AccountTeamMember where userId = :loggedInUser) '+whereClauseString+' ORDER BY CREATEDDATE DESC LIMIT 1000';
                           searchList.addAll((List<Contact>)Database.query(searchQueryInst));
                       }
                       if(userType == RETAIL)
                       {
                           String searchQueryRet = searchQuery+ 'Id IN ('+coverageTeamQueryString+') '+whereClauseString+' ORDER BY CREATEDDATE DESC LIMIT 1000';
                           searchList.addAll((List<Contact>)Database.query(searchQueryRet));
                       }
                       
                       if(searchList.size()>1000)
                       {
                           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, Label.My_Cont_Message4));
                           return;
                       }
                       else{
                           myContactsList = searchList;
                           noOfRecords = myContactsList.size();
                           List<JSONWrapper> contactJSON=new List<JSONWrapper>();
                           for(Contact contRecord:myContactsList)
                           {
                               contactJSON.add(new JSONWrapper(contRecord.Id,contRecord.FirstName,contRecord.MiddleName,contRecord.LastName,contRecord.AccountId,contRecord.Account.Name));
                           }                          
                           JSONContacts=JSON.serialize(contactJSON); 
                       }  
                   }
                //assign values to page list variable
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, Label.My_Cont_Message1));
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.My_Cont_Message3));
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.My_Cont_Message2 +e.getMessage()+e.getLineNumber()));
        }
    }
    
    public void refreshMyContacts()
    {
        searchMCName='';
        searchMCCity = '';
        searchMCState='';
        searchMCCountry='';
        searchMCOrg='';
        searchMCEmail='';
        searchMCZone='';
        myInstContacts = null;
        String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
        setContactsIdList(profileName);
    }
    
   /* public List<Contact> nameSearchSOSL(String searchKey, String searchType, String tempUserType)
    {
        try
        {
            String keyWord = searchKey+'*';
            List<List<Sobject>> searchList = new List<List<Sobject>>();
            String searchQuery ='Find \''+String.escapeSingleQuotes(keyWord)+'\' in '+searchType+' FIELDS RETURNING Contact(Id, Name,MiddleName, LastName, FirstName, AccountId, Account.Name, MailingStreet, MailingCity, MailingState, MailingCountry, YTD_Sales_in_USD__c, LastActivityDate, Phone, Email ';
            if(tempUserType == INSTITUTIONAL)
            {
                searchQuery += 'Where AccountId IN (Select accountId from AccountTeamMember where userId = :loggedInUser) ';
            }
            if(tempUserType == RETAIL)
            {
                searchQuery += 'Where Id IN (select contact__c from coverage_team__c where coverage_owner__c= :loggedInUser and contact__c != null) ';
            }
            searchQuery +='AND Status__c = \'Active\' ORDER BY CreatedDate DESC)';
            searchList = search.query(searchQuery);
            return (List<Contact>) searchList[0];
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.My_Cont_Message2 +e.getMessage()+e.getLineNumber()));
            return null;
        }
    }
    */
    //Wrapper to create JSON
    public class JSONWrapper
    {
        Id contactId;
        String contactFName;
        String contactMName;
        String contactLName;        
        Id contactOrgId;
        String contactOrgName; 
        
        public JSONWrapper(Id contId,String fName,String mName,String lName,Id orgId,String OrgName)
        {
            contactId=contId;
            contactFName=fName;
            contactMName=mName;
            contactLName=lName;
            contactOrgId=orgId;
            contactOrgName=OrgName;
        }
    }
}