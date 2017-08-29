/***************************************************************************************************
Apex Class Name    : MFS_MyCampContacts 
Version            : 1.0 
Created Date       : 03 OCT 2016
Function           : Class is used to fetch my contact & existing members for custom Campaign Page.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               03/10/2016              Original Version
Ganesh Hegde                13/10/2016              Changed the logic for Search
Ganesh hegde                17/10/2016              Added radio button toggle logic for existing members tab
Ganesh Hegde                20/10/2016              Added new searchboxes and columns
***************************************************************************************************/
global with sharing class MFS_MyCampContacts {
    
    //Controller Constants
    private static final String INSTITUTIONAL = 'Institutional';
    private static final String RETAIL = 'Retail';
    private static final String SYSADMIN = 'System Admin';
    private static final String DEFAULTTAB = 'myContacts';
    private static final String DEFAULTRADIO = 'MCM';
    //MyContact Variables
    private Integer contIdSetSize;
    public  transient List<ContactsWrapper> myContactsList { get; set; }
    /*public String searchMCName{get;set;}
    public String searchMCState{get;set;}
    public String searchMCCountry{get;set;}    
    public String searchMCOrg{get;set;}
    public String searchMCCity{get;set;}
    public String searchMCContRole{get;set;}
    public String searchMCZone{get;set;}*/
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
    public String searchMCContRole{
        get{ return searchMCContRole;}
        set{searchMCContRole = value;}
    }
    public String searchMCOrgType{
        get{ return searchMCOrgType;}
        set{searchMCOrgType = value;}
    }
    public String searchMCRegion{
        get{ return searchMCRegion;}
        set{searchMCRegion = value;}
    }
    private transient Set<Id> contIds;
    private List<List<Id>> contIdsList;
    public String userType {get;set;}
    Public Integer size {get;set;} 
    Public Integer noOfRecords{get; set;}
    Public Integer noOfExtRecords{get; set;}
    public String selectedContact{get;set;}
    public String oUser{get;set;}
    public Campaign campaignRec{get;set;}
    Public Campaign campRec{get;set;}
    public Id selectUser{get;set;}
    public String selectedUserName{get;set;}
    private List<JSONWrapper> storeAllContacts;
    public String JSONContacts{get;set;} 
    public String JSONMembers{get;set;}
    private List<ExistingMembersWrapper> storeAllMembers;
    
    //ExistingMember Variables
    public String removeMemId{get;set;}    
    public String selectedMember{get;set;}
    public transient List<CampMemberWrapper> existingMemList{get;set;}   
    public string selectedTab {get;set;}
    public Boolean showMessage{get;set;}
    public Boolean isInConsole{get;Set;}
    public String selectedOption{get;set;}
    
    //Constructor
    public MFS_MyCampContacts(ApexPages.StandardController stdCtrl) {
        try{
            selectedTab = DEFAULTTAB; 
            if(Null!=ApexPages.currentPage().getParameters().get('selectedTab1'))
            {
                selectedTab= ApexPages.currentPage().getParameters().get('selectedTab1');
            }  
            storeAllContacts=new  List<JSONWrapper> ();
            selectedOption = DEFAULTRADIO;
            String urlVal = Apexpages.currentPage().getUrl();
            if(urlVal.containsIgnoreCase('isdtp'))
                isInConsole=true; 
            campRec=[Select id,Name from Campaign where id=:stdCtrl.getRecord().Id];       
            size=500;       
            campaignRec=new Campaign();
            selectUser=UserInfo.getUserId();
            selectedUserName = UserInfo.GetName();
            //checkAndAddStatus();
            contIds = new Set<Id>();
            String profileName=[Select Profile.Name FROM user where id=:selectUser].Profile.Name;
            myContactsList = new List<ContactsWrapper>();
            contIds = getApplicableContacts(selectUser, profileName);
            getMyContacts();
            getExistingMember1();
        }
        catch(Exception exe)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, Label.MyCamp_Message1+' - '+exe.getLineNumber()));  
        }
    }
    
    //Check the status picklist. Add 'Not Sent' Status only if it is not present
    public void checkAndAddStatus() {
        List<CampaignMemberStatus> statusValue = new List<CampaignMemberStatus>([Select Label from CampaignMemberStatus where CampaignId = :campRec.Id and Label='Not Sent']);
        if(statusValue.size() == 0){
            CampaignMemberStatus newStatus = new CampaignMemberStatus(CampaignID=campRec.Id,  Label='Not Sent',IsDefault=false,HasResponded=false,SortOrder=4);
            insert newStatus;
        }
    }
    
    //Hyperlink to GoBack to campaign page
    public PageReference goBack() {
        PageReference pageRef=new PageReference('/'+campRec.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
        /**
    * @Description : Method is used to get applicable Contact Ids 
    * @Param : User Id & Profile Name
    * @return: Nothing
    **/
    public Set<Id> getApplicableContacts(Id userId,String profileName) {       
        Set<id> appContIds = new Set<Id>();
        try{
            if(profileName.containsIgnoreCase(INSTITUTIONAL) || profileName.containsIgnoreCase('Client Service') || profileName.containsIgnoreCase('Global Consultant Relations'))
            {
                List<AccountTeamMember> mfsCovTeam = new List<AccountTeamMember>([Select id, accountId, UserId from AccountTeamMember where userId =:userId LIMIT 10000]);
                for(AccountTeamMember atm : mfsCovTeam)
                {
                    appContIds.add(atm.accountId);
                }
                userType = INSTITUTIONAL;
            }
            else if(profileName.containsIgnoreCase(RETAIL))
            {
                List<Coverage_Team__c> mfsCovTeam = new List<Coverage_Team__c>([Select id, Contact__c from Coverage_Team__c where Coverage_Owner__c = :userId LIMIT 10000]);
                for(Coverage_Team__c atm : mfsCovTeam)
                {
                    appContIds.add(atm.Contact__c);
                }
                userType = RETAIL;
            }
            else
            {
                List<AccountTeamMember> mfsCovTeam = new List<AccountTeamMember>([Select id, accountId, UserId from AccountTeamMember where userId = :userId LIMIT 10000]);
                for(AccountTeamMember atm : mfsCovTeam)
                {
                    appContIds.add(atm.accountId);
                }
                List<Contact> tempCont = new List<Contact>([select id from contact where accountId in :appContIds LIMIT 10000]);
                appContIds.clear();
                for(Contact c : tempCont)
                {
                    appContIds.add(c.id);
                }
                List<Coverage_Team__c> contCoverageTeam = new List<Coverage_Team__c>([Select id, Contact__c from Coverage_Team__c where Coverage_Owner__c = :userId LIMIT 10000]);
                for(Coverage_Team__c atm : contCoverageTeam)
                {
                    appContIds.add(atm.Contact__c);
                }
                userType = SYSADMIN;
            }
            contIdSetSize = appContIds.size();
        }
        catch(Exception exe)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, Label.MyCamp_Message1+' - '+exe.getLineNumber()));  
            System.debug('Exception Occured:'+exe.getMessage()+exe.getLineNumber());
        }
        return appContIds;
    }
    
    //fetch the contacts related to Organizations where they have been assigned to Organization's MFS Coverage Team/Contact Coverage team.
    public ApexPages.StandardSetController myInstContacts {
        get {
            if(myInstContacts == null) {
                if(userType == INSTITUTIONAL)                
                    myInstContacts = new ApexPages.StandardSetController(Database.getQueryLocator(
                        [Select Id, Name,FirstName,MiddleName, LastName, AccountId, Account.Name, MailingCity, MailingState, MailingCountry,MailingStreet,YTD_Sales_in_USD__c, LastActivityDate, Email, Phone, Key_RM_Contact__c, Key_CSM_Contact__c, Key_Sales_Contact__c,Contact_Role__c, Org_Type__c, Region__c, Unsubscribe__c from Contact where ACCOUNTID IN :contIds and Unsubscribe__c =false and Status__c = 'Active' LIMIT 2000]));
                else
                    myInstContacts = new ApexPages.StandardSetController(Database.getQueryLocator(
                        [Select Id, Name,FirstName,MiddleName,LastName, AccountId, Account.Name, MailingCity, MailingState, MailingCountry,MailingStreet,YTD_Sales_in_USD__c, LastActivityDate, Email, Phone, Key_RM_Contact__c, Key_CSM_Contact__c, Key_Sales_Contact__c,Contact_Role__c, Org_Type__c, Region__c, Unsubscribe__c from Contact where  Id in: contIds and Unsubscribe__c =false and Status__c = 'Active' LIMIT 2000])); //id in: contIds and
                myInstContacts.setPageSize(size);  
                noOfRecords = myInstContacts.getResultSize();
            }            
            return myInstContacts;
        }
        set;
    }
    
        /**
    * @Description : Method is used to get data for My Contact Tab
    * @Param : N/A
    * @return: Nothing
    **/
    public void getMyContacts() {
        Set<id> contIdsSet=new Set<Id>();
        resetSearchBoxes();
        List<Contact> contList = new List<Contact>((List<Contact>)myInstContacts.getRecords());
        myContactsList=new List<ContactsWrapper>();
        storeAllContacts=new  List<JSONWrapper> ();
        for(Contact contRec: contList) {
            myContactsList.add(new ContactsWrapper(contRec, false));
            storeAllContacts.add(new JSONWrapper(contRec.Id,contRec.FirstName,contRec.MiddleName,contRec.LastName,contRec.AccountId,contRec.Account.Name, contRec.YTD_Sales_in_USD__c,
                                                 contRec.Contact_Role__c, contRec.Org_Type__c, contRec.region__c, ''));
        }
        //Create JSON for mobile
        JSONContacts=JSON.serialize(storeAllContacts);
    }
    
    //Get next set of contacts for pagination
    public void getNextContacts() {
        myInstContacts.next();
        myCOntactsList = new List<ContactsWrapper>(); 
        for(Contact cont: (List<Contact>)myInstContacts.getRecords())
        {
            myCOntactsList.add(new ContactsWrapper(cont,false));
        }
    }
    
    //Get previous set of contacts for pagination
    public void getpreviousContacts() {
        myInstContacts.previous();
        myCOntactsList = new List<ContactsWrapper>(); 
        for(Contact cont: (List<Contact>)myInstContacts.getRecords())
        {
            myCOntactsList.add(new ContactsWrapper(cont,false));
        }
    }
    
    //Search method for all the searchboxes displayed in apage
    public void searchInMyContacts() {
        //try{
            if(contIdSetSize > 0) {           
                if((!String.isEmpty(searchMCName) && searchMCName.trim().length()>2)
                   || (!String.isEmpty(searchMCOrg) && searchMCOrg.trim().length()>2 )
                   || (!String.isEmpty(searchMCCity) && searchMCCity.trim().length()>2)
                   || (!String.isEmpty(searchMCState) && searchMCState.trim().length()>2 )
                   || (!String.isEmpty(searchMCCountry) && searchMCCountry.trim().length()>2)
                   || (!String.isEmpty(searchMCZone) && searchMCZone.trim().length()>2 )
                   || (!String.isEmpty(searchMCContRole) && searchMCContRole.trim().length()>2 )
                   ||  (!String.isEmpty(searchMCOrgType) && searchMCOrgType.trim().length()>2 )
                   ||  (!String.isEmpty(searchMCRegion) && searchMCRegion.trim().length()>2 ))
                {
                    Boolean isFiltered = false;
                    Map<Id,Contact> tempSearchMap = new Map<Id,Contact>();
                    myContactsList = new List<ContactsWrapper>();
                    Map<Id,Contact> filteredMap = new Map<Id,Contact>();
                  /*  if(!String.isEmpty(searchMCName))
                    {
                        if(userType == SYSADMIN)
                        {
                            for(Contact c : nameSearchSOSL(searchMCName.trim(), 'NAME', RETAIL)){
                                tempSearchMap.put(c.Id, c);
                            }
                            for(Contact c : nameSearchSOSL(searchMCName.trim(), 'NAME', INSTITUTIONAL)){
                                tempSearchMap.put(c.Id, c);
                            } 
                        }
                        else{
                            for(Contact c : nameSearchSOSL(searchMCName.trim(), 'NAME', UserType)){
                                tempSearchMap.put(c.Id, c);
                            }
                        }
                    }
                    if(!String.isEmpty(searchMCOrg))
                    {
                        searchMCOrg = searchMCOrg.removeEnd('*');
                        String keyword = '%'+searchMCOrg.Trim()+'%';
                        List<Contact> searchList = new List<Contact>();
                        String searchQuery = 'Select Id, Name,FirstName,MiddleName,LastName, AccountId, Account.Name, MailingStreet, MailingCity, MailingState, MailingCountry, YTD_Sales_in_USD__c, LastActivityDate, Phone, Email, Key_RM_Contact__c, Key_CSM_Contact__c, Key_Sales_Contact__c,Contact_Role__c,Org_Type__c, Region__c from Contact where ';
                        if(userType== SYSADMIN)
                        {
                            String searchQueryInst =  searchQuery + 'AccountId IN (Select accountId from AccountTeamMember where userId = :selectUser) AND Account.Name like :keyword ORDER BY CREATEDDATE DESC LIMIT 1000';
                            searchList.addAll((List<Contact>)Database.query(searchQueryInst));
                            String searchQueryRet =  searchQuery + 'Id IN (select contact__c from coverage_team__c where coverage_owner__c= :selectUser and contact__c != null) AND Account.Name like :keyword ORDER BY CREATEDDATE DESC LIMIT 1000';
                            searchList.addAll((List<Contact>)Database.query(searchQueryRet));
                        }
                        if(userType== INSTITUTIONAL)
                        {
                            String searchQueryInst = searchQuery + 'AccountId IN (Select accountId from AccountTeamMember where userId = :selectUser) AND Account.Name like :keyword ORDER BY CREATEDDATE DESC LIMIT 1000';
                            searchList.addAll((List<Contact>)Database.query(searchQueryInst));
                        }
                        if(userType == RETAIL)
                        {
                            String searchQueryRet = searchQuery+ 'Id IN (select contact__c from coverage_team__c where coverage_owner__c= :selectUser and contact__c != null) AND Account.Name like :keyword ORDER BY CREATEDDATE DESC LIMIT 1000';
                            searchList.addAll((List<Contact>)Database.query(searchQueryRet));
                        }
                        filteredMap.clear();
                        Map<Id, Contact> tempMap = new Map<Id, Contact>();
                        for(Contact c : searchList)
                        {
                            if(!tempSearchMap.isEmpty() && tempSearchMap.containsKey(c.Id))
                            {
                                filteredMap.put(c.Id, c);
                                isFiltered=true;
                            }
                            else
                                tempMap.put(c.Id, c);
                        }
                        if(isFiltered)
                            tempSearchMap = new Map<Id, Contact>(filteredMap);
                        else
                            tempSearchMap = tempMap;
                        
                    }
                    if(!String.isEmpty(searchMCState) || !String.isEmpty(searchMCCountry) || !String.isEmpty(searchMCCity))
                    {
                        String allSearch = searchMCCity+' '+searchMCState+' '+searchMCCountry;
                        if(allSearch.trim().length()>2)
                        {
                            Map<Id, Contact> tempMap = new Map<Id, Contact>();
                            filteredMap.clear();
                            if(userType== SYSADMIN)
                            {
                                for(Contact c : nameSearchSOSL(allSearch.trim(), 'ALL', RETAIL))
                                {
                                    if(!tempSearchMap.isEmpty() && tempSearchMap.containsKey(c.Id))
                                    {
                                        filteredMap.put(c.Id, c);
                                        isFiltered=true;
                                    }
                                    else
                                        tempMap.put(c.Id, c);
                                }
                                for(Contact c : nameSearchSOSL(allSearch.trim(), 'ALL', INSTITUTIONAL))
                                {
                                    if(!tempSearchMap.isEmpty() && tempSearchMap.containsKey(c.Id))
                                    {
                                        filteredMap.put(c.Id, c);
                                        isFiltered=true;
                                    }
                                    else
                                        tempMap.put(c.Id, c);
                                } 
                            }
                            else{
                                for(Contact c : nameSearchSOSL(allSearch.trim(), 'ALL', UserType))
                                {
                                    if(!tempSearchMap.isEmpty() && tempSearchMap.containsKey(c.Id))
                                    {
                                        filteredMap.put(c.Id, c);
                                        isFiltered=true;
                                    }
                                    else
                                        tempMap.put(c.Id, c);
                                }
                            }
                            if(isFiltered)
                                tempSearchMap = new Map<Id, Contact>(filteredMap);
                            else
                                tempSearchMap = tempMap;
                        }
                        else
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Search criteria must contain atleast 3 characters'));
                        }
                    }
                    if(!String.isEmpty(searchMCZone) && searchMCZone.trim().length()>2)
                    {
                        String searchQuery = 'Select Id, Name,LastName,MiddleName, FirstName, AccountId, Account.Name, MailingStreet, MailingCity, MailingState, MailingCountry, YTD_Sales_in_USD__c, LastActivityDate, Phone, Contact_Role__c, Email, Key_RM_Contact__c, Key_CSM_Contact__c, Key_Sales_Contact__c, Org_type__c, region__c  from Contact where Status__c = \'Active\' And Id IN (select contact__c from coverage_team__c where coverage_owner__c= :selectUser and contact__c != null and Zone__c like \'%' + searchMCZone.Trim() + '%\') ORDER BY CREATEDDATE DESC LIMIT 1000';
                        List<Contact> searchList = Database.query(searchQuery);
                        filteredMap.clear();
                        Map<Id, Contact> tempMap = new Map<Id, Contact>();
                        for(Contact c : searchList)
                        {
                            if(!tempSearchMap.isEmpty() && tempSearchMap.containsKey(c.Id))
                            {
                                filteredMap.put(c.Id, c);
                                isFiltered=true;
                            }
                            else
                                tempMap.put(c.Id, c);
                        }
                        if(isFiltered)
                            tempSearchMap = new Map<Id, Contact>(filteredMap);
                        else
                            tempSearchMap = tempMap;
                    }
                    if(!String.isEmpty(searchMCContRole) || !String.isEmpty(searchMCOrgType) || !String.isEmpty(searchMCRegion))
                    {
                        String profileName=[Select Profile.Name FROM user where id=:selectUser].Profile.Name;
                        Set<Id> tempContIds = getApplicableContacts(selectUser,profileName);
                        
                        String searchQuery = 'Select Id, Name,FirstName,MiddleName,LastName, AccountId, Account.Name, MailingStreet, MailingCity, MailingState, MailingCountry, YTD_Sales_in_USD__c, LastActivityDate, Phone,Key_RM_Contact__c, Key_CSM_Contact__c, Key_Sales_Contact__c, Contact_Role__c, Email, Org_Type__c, Region__c  from Contact where Id IN :tempContIds ';
                        if(!String.isEmpty(searchMCContRole)){
                            searchQuery += 'AND Contact_Role__c INCLUDES (:searchMCContRole) ';
                        }
                        if(!String.isEmpty(searchMCOrgType)){
                            searchQuery += 'AND Org_Type__c INCLUDES (:searchMCOrgType) ';
                        }
                        if(!String.isEmpty(searchMCRegion)){
                            searchQuery += 'AND Region__c like \'%' + searchMCRegion.Trim() + '%\' ';
                        }
                        searchQuery += ' ORDER BY CREATEDDATE DESC LIMIT 1000';
                        List<Contact> searchList = Database.query(searchQuery);
                        filteredMap.clear();
                        Map<Id, Contact> tempMap = new Map<Id, Contact>();
                        for(Contact c : searchList)
                        {
                            if(!tempSearchMap.isEmpty() && tempSearchMap.containsKey(c.Id))
                            {
                                filteredMap.put(c.Id, c);
                                isFiltered=true;
                            }
                            else
                                tempMap.put(c.Id, c);
                        }
                        if(isFiltered)
                            tempSearchMap = new Map<Id, Contact>(filteredMap);
                        else
                            tempSearchMap = tempMap;
                        List<JSONWrapper> contactJSON=new List<JSONWrapper>();
                        for(Contact contRecord:tempSearchMap.values())
                        {
                            contactJSON.add(new JSONWrapper(contRecord.Id,contRecord.FirstName,contRecord.MiddleName,contRecord.LastName,contRecord.AccountId,contRecord.Account.Name,contRecord.YTD_Sales_in_USD__c,
                                                            contRecord.Contact_Role__c, contRecord.Org_Type__c, contRecord.region__c, ''));
                        }                          
                        JSONContacts=JSON.serialize(contactJSON); 
                    }
                    */
                    String keyword0 = '';
                    String keyword1='';
                    String keyword2='';
                    String keyword3='';
                    String keyword4='';
                    String keyword5 = '';
                    String keyword6 = '';
                    String keyword7 = '';
                    String keyword8 = '';
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
                    if(!String.isEmpty(searchMCContRole) && searchMCContRole.trim().length() > 2){
                        keyword6 = searchMCContRole.Trim();
                        whereClauseString += ' AND Contact_Role__c INCLUDES (:keyword6) ';
                    }
                    if(!String.isEmpty(searchMCOrgType) && searchMCOrgType.trim().length() > 2){
                        keyword7 = searchMCOrgType.Trim();
                        whereClauseString += ' AND Org_Type__c INCLUDES (:keyword7) ';
                    }
                    if(!String.isEmpty(searchMCRegion) && searchMCRegion.trim().length() > 2){
                        keyword8 = '%'+searchMCRegion.Trim()+'%';
                        whereClauseString += ' AND Region__c like :keyword8 ';
                    }
                       String coverageTeamQueryString = 'select contact__c from coverage_team__c where coverage_owner__c= :selectUser and contact__c != null';
                       Boolean skipInstQuery = false;
                       if(!String.isEmpty(searchMCZone) && searchMCZone.trim().length() > 2){
                           skipInstQuery = true;
                           searchMCZone = searchMCZone.removeEnd('*');
                           keyword5 = '%'+searchMCZone.Trim()+'%';
                           coverageTeamQueryString += ' AND Zone__c like :keyword5 ';
                       }
                       String searchQuery = 'Select Id, Name,FirstName,MiddleName,LastName, AccountId, Account.Name, MailingStreet, MailingCity, MailingState, MailingCountry, YTD_Sales_in_USD__c, LastActivityDate, Phone,Key_RM_Contact__c, Key_CSM_Contact__c, Key_Sales_Contact__c, Contact_Role__c, Email, Org_Type__c, Region__c  from Contact where Status__c = \'Active\' and ';
                       if(userType== SYSADMIN)
                       {
                           if(!skipInstQuery){
                               String searchQueryInst =  searchQuery + 'AccountId IN (Select accountId from AccountTeamMember where userId = :selectUser) '+whereClauseString+' ORDER BY CREATEDDATE DESC LIMIT 1000';
                              searchList.addAll((List<Contact>)Database.query(searchQueryInst));
                           }
                           String searchQueryRet =  searchQuery + 'Id IN ('+coverageTeamQueryString+') '+whereClauseString+' ORDER BY CREATEDDATE DESC LIMIT 1000';
                           searchList.addAll((List<Contact>)Database.query(searchQueryRet));
                       }
                       if(userType== INSTITUTIONAL)
                       {
                           String searchQueryInst = searchQuery + 'AccountId IN (Select accountId from AccountTeamMember where userId = :selectUser) '+whereClauseString+' ORDER BY CREATEDDATE DESC LIMIT 1000';
                           searchList.addAll((List<Contact>)Database.query(searchQueryInst));
                       }
                       if(userType == RETAIL)
                       {
                           String searchQueryRet = searchQuery+ 'Id IN ('+coverageTeamQueryString+') '+whereClauseString+' ORDER BY CREATEDDATE DESC LIMIT 1000';
                           searchList.addAll((List<Contact>)Database.query(searchQueryRet));
                       }
                       
                    //assign values to page list variable
                    if(searchList.size()>1000) {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Search result contains more than 1000 records. Please refine the query'));
                        return;
                    }
                    else{
                        List<JSONWrapper> contactJSON=new List<JSONWrapper>();
                        for(Contact conRec: searchList)
                            {
                                myContactsList.add(new ContactsWrapper(conRec,false));
                                contactJSON.add(new JSONWrapper(conRec.Id,conRec.FirstName,conRec.MiddleName,conRec.LastName,conRec.AccountId,conRec.Account.Name,conRec.YTD_Sales_in_USD__c,
                                                                conRec.Contact_Role__c, conRec.Org_Type__c, conRec.region__c, ''));
                            }
                        JSONContacts=JSON.serialize(contactJSON); 
                    }
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Search criteria must contain atleast 3 characters'));
                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'There are no contacts found'));
            }
       /* }
        catch(Exception e)
        {
            System.debug(e.getMessage()+e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error while searching for Contacts : '+e.getMessage() + e.getLineNumber())); 
        }*/
    }
    
    
    public void refreshMyContacts() {
        resetSearchBoxes();
        myInstContacts = null;
        String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
        contIds = getApplicableContacts(selectUser,profileName);
        getMyContacts();
        
    }
    
    //SOSL to search either name or All fields
    public List<Contact> nameSearchSOSL(String searchKey,  String searchType, String tempUserType) {
        try {
            String keyWord = searchKey+'*';
            String nameSearch = 'NAME';
            String searchQuery ='Find \''+String.escapeSingleQuotes(keyWord)+'\' in '+searchType+' FIELDS RETURNING Contact(Id, Name, MiddleName,LastName, FirstName, AccountId, Account.Name, MailingStreet, MailingCity, MailingState, MailingCountry, YTD_Sales_in_USD__c, LastActivityDate, Phone,Key_RM_Contact__c, Key_CSM_Contact__c, Key_Sales_Contact__c,Contact_Role__c, Org_Type__c, Region__c, Email ';
            if(tempUserType=='Institutional')
            {
                searchQuery += 'Where AccountId IN (Select accountId from AccountTeamMember where userId = :selectUser) ';
            }
            if(tempUserType == 'Retail')
            {
                searchQuery += 'Where Id IN (select contact__c from coverage_team__c where coverage_owner__c= :selectUser and contact__c != null) ';
            }
            searchQuery +='AND Status__c = \'Active\' ORDER BY CreatedDate DESC)';
            List<List<Sobject>> searchList = search.query(searchQuery);
            return (List<Contact>) searchList[0];
        }catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error while searching for Contacts : '+e.getMessage()));
            return null;
        }
    }
    
    //wrapper Class for Contact Records
    public Class ContactsWrapper {
        public boolean isSelected{get;set;}
        public Contact cont{get;set;}
        public ContactsWrapper(Contact cont, Boolean selected)
        {
            this.isSelected = selected;
            this.cont = cont;
        }
    }
    
    /**
* @Description : Method is used to get contact of other users 
* @Param : N/A
* @return: Nothing
**/
    public void getOtherContact() {
        try{
            if( Null!=campaignRec.Other_Contact__c) {
                selectUser=campaignRec.Other_Contact__c;
                selectedUserName = [Select Name from USer where id=:selectUser].Name;
                String profileName=[Select Profile.Name FROM user where id=:selectUser].Profile.Name;
                contIds = new Set<Id>();
                contIds= getApplicableContacts(selectUser,profileName);         
                myInstContacts = null;
            }
        }
        catch(Exception exe)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, Label.MyCamp_Message1+' - '+exe.getLineNumber()));  
            System.debug('Exception Occured:'+exe.getMessage()+exe.getLineNumber());
        }
        getMyContacts();
    }
    
    /**
* @Description : Method is used to Add All Contacts as campaign members
* @Param : N/A
* @return: PageReference
**/
   /* public PageReference addAllContacts() {
        PageReference pageRef;
        try{
            if(storeAllContacts.size()>0) {
                selectedContact=[Select label from CampaignMemberStatus where campaignId=:campRec.id and IsDefault=true limit 1].label;
                for(JSONWrapper contRec:storeAllContacts)
                {
                    selectedContact=selectedContact+','+contRec.contactId;
                }   
                pageRef= addCampMember();
            }
        }
        catch(Exception exe) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, Label.MyCamp_Message1+' - '+exe.getLineNumber()));  
            System.debug('Exception Occured:'+exe.getMessage()+exe.getLineNumber());
        }
        return pageRef;
    }
    
    public void addAllContactsSF1() {
        try{
            if(storeAllContacts.size()>0)
            {
                selectedContact=[Select label from CampaignMemberStatus where campaignId=:campRec.id and IsDefault=true limit 1].label;
                for(JSONWrapper contRec:storeAllContacts)
                {
                    selectedContact=selectedContact+','+contRec.contactId;
                }   
                addCampMember();
            }
       	}catch(Exception exe)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, Label.MyCamp_Message1+' - '+exe.getLineNumber()));  
            System.debug('Exception Occured:'+exe.getMessage()+exe.getLineNumber());
        }
    }
    
    
*/    
    /**
* @Description : Method is used to Add selected Contacts as campaign members
* @Param : N/A
* @return: PageReference
**/
    public PageReference addCampMember() {
        PageReference pageRef;
        try{
            checkAndAddStatus();
            String [] selectedIds=selectedContact.split(',');    
            String selectedStatus=selectedIds[0];
            selectedIds.remove(0);
            if(!selectedIds.isEmpty())
            {
                List<CampaignMember> campMemList=new  List<CampaignMember>();
                Map<String,CampaignMember> existingCampMem=new Map<String,CampaignMember>();
                for(CampaignMember eCampMem:[Select ContactId,Status,Id,Belong_To__c from CampaignMember where CampaignId=:campRec.Id and ContactId!=null])
                {
                    existingCampMem.put(eCampMem.ContactId,eCampMem);
                }
                for(String contId:selectedIds)
                {
                    CampaignMember campMRec;
                    if(existingCampMem.containsKey(contId.trim()))
                    {
                        campMRec=existingCampMem.get(contId);
                        if(campMRec.Status!=selectedStatus)
                        {
                            campMRec.Status=selectedStatus;
                            campMemList.add(campMRec);
                        }
                    }
                    else if(!existingCampMem.containsKey(contId)) { 
                        campMRec=new CampaignMember();
                        campMRec.CampaignId=campRec.Id;
                        campMRec.ContactId=contId;
                        campMRec.Status=selectedStatus;
                        campMRec.Belong_To__c = selectUser;
                        campMemList.add(campMRec);
                    }
                }
                if(!campMemList.isEmpty()) {
                    upsert(campMemList);
                }
            }
            pageRef=new PageReference('/apex/MFS_MyCampCon?id='+campRec.Id+'&selectedTab1=extMember&addedM='+selectedIds.size());
            pageRef.setRedirect(true);
            System.debug('pageRef'+pageRef);   
        }
        catch(Exception exe) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, Label.MyCamp_Message1+' - '+exe.getLineNumber()));  
            System.debug('Exception Occured:'+exe.getMessage()+exe.getLineNumber());
        }
        return pageRef;
    }
    
    //Adding members from SF1
    public void  addCampMemberSF1() {
        try{
            checkAndAddStatus();
            String [] selectedIds=selectedContact.split(',');    
            String selectedStatus=selectedIds[0];
            selectedIds.remove(0);
            if(!selectedIds.isEmpty())
            {
                List<CampaignMember> campMemList=new  List<CampaignMember>();
                Map<String,CampaignMember> existingCampMem=new Map<String,CampaignMember>();
                for(CampaignMember eCampMem:[Select ContactId,Status,Id,Belong_To__c from CampaignMember where CampaignId=:campRec.Id and ContactId!=null])
                {
                    existingCampMem.put(eCampMem.ContactId,eCampMem);
                }
                for(String contId:selectedIds)
                {
                    CampaignMember campMRec;
                    if(existingCampMem.containsKey(contId.trim())) {
                        campMRec=existingCampMem.get(contId);
                        if(campMRec.Status!=selectedStatus) {
                            campMRec.Status=selectedStatus;
                            campMemList.add(campMRec);
                        }
                    }
                    else if(!existingCampMem.containsKey(contId)) { 
                        campMRec=new CampaignMember();
                        campMRec.CampaignId=campRec.Id;
                        campMRec.ContactId=contId;
                        campMRec.Status=selectedStatus;
                        campMRec.Belong_To__c = selectUser;
                        campMemList.add(campMRec);
                    }
                }
                
                if(!campMemList.isEmpty()) {
                    upsert(campMemList);
                }
			}
        }
        catch(Exception exe) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, Label.MyCamp_Message1+' - '+exe.getLineNumber()));  
            System.debug('Exception Occured:'+exe.getMessage()+exe.getLineNumber());
        }
    }
    
    /**
* @Description : Method is used to fetch existing campaign Members
* @Param : N/A
* @return: PageReference
**/ 
    public void getExistingMember1() {
        try{
            List<CampaignMember> existingMem;
            if(selectedOption == 'ACM')
            {
                existingMem=[select Id, FirstName,LastName,CompanyOrAccount,ContactId,Contact.MailingCity,Contact.MailingStreet,Contact.MailingState, Contact.MailingCountry ,Contact.YTD_Sales_in_USD__c,Contact.LastActivityDate,Status,Contact.Email from CampaignMember where CampaignId=:campRec.Id and ContactId!=null Limit 500];
            }
            else if(selectedOption == 'MCM')
            {
                existingMem=[select Id, FirstName,LastName,CompanyOrAccount,ContactId,Contact.MailingCity,Contact.MailingStreet,Contact.MailingState,Contact.MailingCountry ,Contact.YTD_Sales_in_USD__c,Contact.LastActivityDate,Status,Contact.Email from CampaignMember where CampaignId=:campRec.Id and ContactId!=null and Belong_To__c = :selectUser Limit 500];
            }
            
            existingMemList=new List<CampMemberWrapper>();
            storeAllMembers = new List<ExistingMembersWrapper>();
            for(CampaignMember campMem:existingMem) {
                existingMemList.add(new CampMemberWrapper(campMem,false));
                storeAllMembers.add(new ExistingMembersWrapper(campMem.ContactId,campMem.FirstName,campMem.LastName,campMem.CompanyOrAccount, campMem.Contact.YTD_Sales_in_USD__c,
                                                               campMem.Contact.Email, campMem.Status, campMem.Id));
            } 
        }
        catch(Exception exe) {
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, Label.MyCamp_Message1+' - '+exe.getLineNumber()));  
            System.debug('Exception Occured:'+exe.getMessage()+exe.getLineNumber());
        }
        
        JSONMembers = JSON.Serialize(storeAllMembers);
    }
    
    //Wrapper to create JSON. this is used in SF1
    public class JSONWrapper {
        Id contactId;
        String contactFName;
        String contactMName;
        String contactLName;        
        Id contactOrgId;
        String contactOrgName; 
        Decimal YTDSales;
        String CRole;
        String orgType;
        String region;
        String status;
        
        public JSONWrapper(Id contId,String fName,String mName,String lName,Id orgId,String OrgName, Decimal YTD, String role,String otype,String cregion,String cstatus) {
            contactId=contId;contactFName=fName;contactMName=mName;contactLName=lName;contactOrgId=orgId;contactOrgName=OrgName;
            YTDSales = YTD;
            CRole = role;
            orgType = oType;
            region = cregion;
            status = cstatus;
        }
    }
    
    //Wrapper class to store existing camapign members
    public class ExistingMembersWrapper {
        Id contactId;
        String FirstName;
        String LastName;        
        String CompanyOrAccount;
        Decimal YTDSales;
        String Email;
        String status;
        Id campId;
        
        public ExistingMembersWrapper(Id contId,String fName,String lName,String OrgName, Decimal cYTDSales, String cEmail,String cstatus, Id eCampId) {
            contactId=contId;FirstName=fName;LastName=lName;CompanyOrAccount=OrgName;
            YTDSales = cYTDSales;
            Email = cEmail;
            status = cstatus;
            campId = eCampId;
        }
    }
    
    //Campaign Member Wrapper  
    public Class CampMemberWrapper {
        public boolean isSelected{get;set;}
        public CampaignMember campMem{get;set;}
        public CampMemberWrapper(CampaignMember campMember, Boolean selected)
        {
            this.isSelected = selected;
            this.campMem = campMember;
        }
    }

    //Reset pagemessages
    public PageReference resetMessages() {
        showMessage = true;
        PageReference pageRef=new PageReference('/apex/MFS_MyCampCon?id='+campRec.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /**
* @Description : Method is used to update or remove selected members
* @Param : N/A
* @return: PageReference
**/    
    public void updateRemoveMembers() {
        try{
            checkAndAddStatus();
            String successMessage;       
            String [] selectedMemIds=selectedMember.split(',');   
            String selectedMemStatus=selectedMemIds[0];
            selectedMemIds.remove(0);
            if('Remove'==selectedMemStatus && selectedMemIds.size()>0)
            {
                List<CampaignMember> memberToRemove=[Select Id from CampaignMember where id in:selectedMemIds];
                delete memberToRemove;
                getExistingMember1();
                successMessage = 'removed ';
            }
            else  if(selectedMemIds.size()>0)
            {
                List<CampaignMember> memberToUpdate=[Select Id,status from CampaignMember where id in:selectedMemIds];
                List<CampaignMember> membersToUpdate=new List<CampaignMember>();
                for(CampaignMember campMem :memberToUpdate)
                {
                    if(campMem.status!=selectedMemStatus)
                    {
                        campMem.status=selectedMemStatus;
                        membersToUpdate.add(campMem);
                    }
                }
                if(!membersToUpdate.isEmpty())
                    update membersToUpdate;
                getExistingMember1();
                successMessage='updated ';
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm, 'You have successfully '+successMessage+selectedMemIds.size()+' member(s).'));
        }
        catch(Exception exe)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, Label.MyCamp_Message1+' - '+exe.getLineNumber()));  
            System.debug('Exception Occured:'+exe.getMessage()+exe.getLineNumber());
        }
        
    }
    
    //Switch between my campaign members and all campaign members
    public void toggleExistingMembers() {
        if(selectedOption == 'ACM')
        {
            List<CampaignMember> existingMem=[select Id, FirstName,LastName,CompanyOrAccount,ContactId,Contact.MailingCity,Contact.MailingStreet,Contact.Email,Contact.MailingState,Contact.MailingCountry ,Contact.YTD_Sales_in_USD__c,Contact.LastActivityDate,Status, Email from CampaignMember where CampaignId=:campRec.Id and ContactId!=null Limit 500];
            existingMemList=new List<CampMemberWrapper>();
            storeAllMembers = new List<ExistingMembersWrapper>();
            for(CampaignMember campMem:existingMem)
            {
                existingMemList.add(new CampMemberWrapper(campMem,false));
                storeAllMembers.add(new ExistingMembersWrapper(campMem.ContactId,campMem.FirstName,campMem.LastName,campMem.CompanyOrAccount, campMem.Contact.YTD_Sales_in_USD__c,
                                                               campMem.Contact.Email, campMem.Status, campMem.Id));
            } 
        }
        else if(selectedOption == 'MCM')
        {
            List<CampaignMember> existingMem=[select Id, FirstName,LastName,CompanyOrAccount,ContactId,Contact.MailingCity,Contact.MailingStreet,Contact.Email,Contact.MailingState,Contact.MailingCountry ,Contact.YTD_Sales_in_USD__c,Contact.LastActivityDate,Status, Email from CampaignMember where CampaignId=:campRec.Id and ContactId!=null and Belong_To__c = :selectUser Limit 500];
            existingMemList=new List<CampMemberWrapper>();
            storeAllMembers = new List<ExistingMembersWrapper>();
            for(CampaignMember campMem:existingMem)
            {
                existingMemList.add(new CampMemberWrapper(campMem,false));
                storeAllMembers.add(new ExistingMembersWrapper(campMem.ContactId,campMem.FirstName,campMem.LastName,campMem.CompanyOrAccount, campMem.Contact.YTD_Sales_in_USD__c,
                                                               campMem.Contact.Email, campMem.Status, campMem.Id));
            }
        }
        //JSON for SF1
        JSONMembers = JSON.serialize(storeAllMembers);
    }
    
    //Get values for radio button
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('MCM','My Contact\'s Campaign Members')); 
        options.add(new SelectOption('ACM','All Campaign Members')); 
        
        return options; 
    }
    
    //Reset all searchboxes
    private void resetSearchBoxes() {
        searchMCName='';
        searchMCCity = '';
        searchMCState='';
        searchMCCountry='';
        searchMCOrg='';     
        searchMCZone='';
        searchMCContRole='';
        searchMCOrgType = '';
        searchMCRegion = '';
    }
}