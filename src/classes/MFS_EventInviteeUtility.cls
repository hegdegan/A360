/*
Apex class           :  MFS_EventInviteeUtility
Version               :  1.0
Created Date          :  16 SEP 2016
Function              :  This Utility class contains all methods related to Customization of Event Invitee section in Activity360
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* Maheshkumar            16 SEP 2016              Initial Version
*Ganesh Hegde           14 OCT 2016             Added search, gotoInvitee, Addportfolio, remove portfolio, sortwrappers
*/

public with sharing class MFS_EventInviteeUtility {
    
    private static final String CONTACT_TEXT = 'Contact';
    private static final String USER_TEXT = 'User';
    private static final String ASC_ORDER = 'ASC';
    private static final String DESC_ORDER = 'DESC';
    private static final String STATUS_APPROVED = 'Approved';
    private static final String STATUS_ACCEPTED = 'Accepted';
    private static final String STATUS_REJECTED = 'Rejected';
    private static final String STATUS_DECLINED = 'Declined';
    private static final String STATUS_NEW = 'New';
    private static final String NOT_APPLICABLE = 'N/A';
    private static final String MFS_TEXT ='MFS';
    private static final String DEFAULT_SORT_TIME = '12:00 AM';
    
    public static String sortingOrder;
    public static String sortingOrgOrder;
    
    //Wrapper to hold invitees list
    public Class InviteeWrapper{
        public Event_Relation__c evntRel{get;set;}
        public String orgName{get;set;}
        public String startTime{get;set;}
        public String endTime{get;set;}
        public Event_Relation_Portfolio_Junction__c evRelPort{get;set;}
        public List<EventPortfolioWrapper> evntRelPortLst{get;set;}
        public InviteeWrapper(Event_Relation__c evntRel, String orgName, Event_Relation_Portfolio_Junction__c evRelPort, List<EventPortfolioWrapper> evntRelPortLst, String startTime, String endTime)
        {
            this.evntRel = evntRel;
            this.orgName = orgName;
            this.evRelPort = evRelPort;
            this.evntRelPortLst = evntRelPortLst;
            this.startTime = startTime;
            this.endTime = endTime;
        }
    }
    
    //wrapper to hold portfolios related to invitee/attendee
    public Class EventPortfolioWrapper{
        public String portName{get;set;}
        public Integer pRowNum{get;set;}
        public Event_Relation_Portfolio_Junction__c evRelPort{get;set;}
        public EventPortfolioWrapper(String portName, Integer pRowNum, Event_Relation_Portfolio_Junction__c evRelPort)
        {
            this.portName= portName;
            this.pRowNum = pRowNum;
            this.evRelPort = evRelPort;
        }
    }
    
    //wrapper to sort attendees based on timeslot
    public Class InviteeSortWrapper implements Comparable
    {
        public Id invId;
        public DateTime invStartTime;
        public DateTime invEndTime;
        public InviteeSortWrapper(Id invId, DateTime invStartTime, DateTime invEndTime)
        {
            this.invId = invId;
            this.invStartTime = invStartTime;
            this.invEndTime = invEndTime;
        }
        public Integer compareTo(Object compareTo) {
            InviteeSortWrapper compareToInv = (InviteeSortWrapper)compareTo;
            if(MFS_EventInviteeUtility.sortingOrder == ASC_ORDER)
            {
                if (invStartTime == compareToInv.invStartTime)
                {
                    if(invEndTime == compareToInv.invEndTime) return 0;
                    if(invEndTime > compareToInv.invEndTime) return 1;
                }    
                if (invStartTime > compareToInv.invStartTime) return 1;
                return -1; 
            }
            else
            {
                if (invStartTime == compareToInv.invStartTime)
                {
                    if(invEndTime == compareToInv.invEndTime) return 0;
                    if(invEndTime > compareToInv.invEndTime) return -1;
                }
                if (invStartTime > compareToInv.invStartTime) return -1;
                return 1;  
            }
        }
    }
    
    //wrapper to sort attendees based on organization
    public Class InviteeOrgSortWrapper implements Comparable
    {
        public Id invId;
        public String orgName;
        public InviteeOrgSortWrapper(Id invId, String orgName)
        {
            this.invId = invId;
            this.orgName = orgName;
        }
        public Integer compareTo(Object compareTo) {
            InviteeOrgSortWrapper compareToInv = (InviteeOrgSortWrapper)compareTo;
            if(MFS_EventInviteeUtility.sortingOrgOrder == ASC_ORDER)
            {
                if (orgName == compareToInv.orgName) return 0;
                if (orgName > compareToInv.orgName) return 1;
                return -1; 
            }
            else
            {
                if (orgName == compareToInv.orgName) return 0;
                if (orgName > compareToInv.orgName) return -1;
                return 1;  
            }
        }
    }
    
    //wrapper to sort attendees based on last name
    public Class InviteeLastNameSortWrapper implements Comparable
    {
        public Id invId;
        public String firstName;
        public String lastName;
        public String OrgName;
        public String attendeeType;
        public InviteeLastNameSortWrapper(Id invId, String firstName, String lastName, String orgName,String attendeeType)
        {
            this.invId = invId;
            this.firstName=firstName;
            this.lastName=lastName;
            this.orgName = orgName;
            this.attendeeType=attendeeType;
        }
        public Integer compareTo(Object compareTo) {
            InviteeLastNameSortWrapper compareToInv = (InviteeLastNameSortWrapper)compareTo;
            
                if (lastName== compareToInv.lastName) return 0;
                if (lastName> compareToInv.lastName) return 1;
                return -1; 
            
            
        }
    }
    
    //Method to get Attendee type, this is used in Select Attendee popup
    public static List<Selectoption> getInviteeSearchObjects(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Users & Contacts',Label.A360_Users_Contacts));
        options.add(new SelectOption('Users',Label.A360_Users));
        options.add(new SelectOption('Contacts',Label.A360_Contacts)); 
        return options;
    }
    
    //fetch all the invitees and related portfolios. Construct a wrapper list here
    public static void goToInvitees(Map<Id,MFS_EventInviteeUtility.InviteeWrapper> inviteesMap, Activity_Detail__c callNote,Boolean showResponseBtn, Event parentEvent, String StartDateTime, String endDateTime, List<SelectOption> lstLeftOption, List<SelectOption> lstRightOption, Map<ID, String> mRightSelected, Set<Id> inviteeOrderKeys)
    {
        try{
            List<Event_Relation__c> tempERList = new List<Event_Relation__c>([select Id, RelationId__c, Activity_Detail__c, Invitee_Type__c, Name__c, Org__c, Speaker_Request__c, Time_Slot_Start__c,Time_Slot_End__c, Start_Date__c, End_Date__c, Approval_Status__c, Topic__c, Host__c, (Select Id,Event_Relation__c, Portfolio__c, Portfolio__r.Name from Event_Relation__r) from Event_Relation__c where Activity_Detail__c = :callNote.Id ORDER BY Name__c ASC]);
            Set<Id> tempIds = new Set<Id>();
            Id hostID;
            List<Id> tempinviteeOrderKeys = new List<Id>();
            for(Event_Relation__c er : tempERList) 
            {
                List<MFS_EventInviteeUtility.EventPortfolioWrapper> tempPortList = new List<MFS_EventInviteeUtility.EventPortfolioWrapper>();
                Integer pRowNum = 0;
                for(Event_Relation_Portfolio_Junction__c erpj : er.Event_Relation__r)
                {
                    tempPortList.add(new MFS_EventInviteeUtility.EventPortfolioWrapper(erpj.Portfolio__r.Name, pRowNum, erpj));
                    //Assign row numbers to the record so that while deleting it will be easy to identify
                    pRowNum++;
                }
                if(er.Host__c)
                {
                    if(tempInviteeOrderKeys.size() > 0)
                        tempInviteeOrderKeys.add(0,er.RelationId__c);
                    else
                        tempInviteeOrderKeys.add(er.RelationId__c);
                }
                //If invitee timeslot is null, the take it from parent activity timeslot
                Datetime timeSlotStart = er.Time_Slot_Start__c==null ? parentEvent.StartDateTime : er.Time_Slot_Start__c;
                Datetime timeSlotEnd = er.Time_Slot_End__c==null ? parentEvent.endDateTime : er.Time_Slot_End__c;
                String startTime = MFS_Activity360GeneralUtility.dateTimeConversion(timeSlotStart, true);
                String endTime = MFS_Activity360GeneralUtility.dateTimeConversion(timeSlotStart, true);
                inviteesMap.put(er.RelationId__c, new MFS_EventInviteeUtility.InviteeWrapper(er, er.Org__c, new Event_Relation_Portfolio_Junction__c(), tempPortList, startTime, endTime));         
                tempInviteeOrderKeys.add(er.RelationId__c);
                lstLeftOption.clear();
            }
            InviteeOrderKeys.addAll(tempInviteeOrderKeys);
            
            //If the event is not saved
            if(callNote != null && callNote.Not_An_Orphan_Record__c == false){
                if(parentEvent.OwnerId != NULL){
                    User usr;
                    for(User u: [Select Name from User where Id = :parentEvent.OwnerId]){
                        usr = u;
                    }
                    inviteesMap.put(parentEvent.OwnerId, new MFS_EventInviteeUtility.InviteeWrapper(new Event_Relation__c(RelationId__c = parentEvent.OwnerId, Invitee_Type__c = USER_TEXT, Approval_Status__c = STATUS_APPROVED, Name__c = usr.Name, Start_Date__c = System.Today(), End_Date__c = System.Today(), Host__c = true), 'MFS', new Event_Relation_Portfolio_Junction__c(), new List<MFS_EventInviteeUtility.EventPortfolioWrapper>(), StartDateTime, EndDateTime));             
                    inviteeOrderKeys.add(parentEvent.OwnerId);
                }
                if(parentEvent != null && parentEvent.whoId != null && parentEvent.whoId.getSobjectType().getDescribe().getName() == CONTACT_TEXT){
                    Contact relatedToContact = [select id, Name, Account.Name from Contact where Id = :parentEvent.whoId];
                    inviteesMap.put(parentEvent.whoId, new MFS_EventInviteeUtility.InviteeWrapper(new Event_Relation__c(RelationId__c = parentEvent.whoId, Invitee_Type__c = CONTACT_TEXT, Approval_Status__c = STATUS_APPROVED, Name__c = relatedToContact.Name, Start_Date__c = System.Today(), End_Date__c = System.Today(), Host__c = false, Topic__c = 'N/A'), relatedToContact.Account.Name, new Event_Relation_Portfolio_Junction__c(), new List<MFS_EventInviteeUtility.EventPortfolioWrapper>(), StartDateTime, EndDateTime));             
                    inviteeOrderKeys.add(parentEvent.whoId);
                    mRightSelected.put(parentEvent.whoId, relatedToContact.Name + ' - '+relatedToContact.Account.Name+' - ' + CONTACT_TEXT);
                    lstRightOption.add(new SelectOption(parentEvent.whoId, relatedToContact.Name + ' - '+relatedToContact.Account.Name+' - ' + CONTACT_TEXT));
                }
            }
        }catch(Exception ex){
            system.debug('Exception in goToInvitees : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Add portfolios to invitee. portfolios will be selected from modal window
    public static void addPortfToInvitee(Map<Id, MFS_EventInviteeUtility.InviteeWrapper> inviteesMap, String inviteeId, Set<Id> prodIds)
    {
        try{
            MFS_EventInviteeUtility.InviteeWrapper tempEventPortfJnList = inviteesMap.get((Id)inviteeId);
            List<MFS_EventInviteeUtility.EventPortfolioWrapper> tempPortlist = tempEventPortfJnList.evntRelPortLst;
            List<Product2> prodList = new List<Product2>([select id, name from Product2 where id IN :prodIds]);
            
            List<MFS_EventInviteeUtility.EventPortfolioWrapper> tempPortlistNew = new List<MFS_EventInviteeUtility.EventPortfolioWrapper>();
            Integer pRowNum = 0;
            Set<Id> existingPfs = new Set<Id>();
            for(MFS_EventInviteeUtility.EventPortfolioWrapper wc : tempPortlist){
                wc.pRowNum = pRowNum;
                tempPortlistNew.add(wc);
                existingPfs.add(wc.evRelPort.Portfolio__c);
                pRowNum++;
            }
            for(Product2 prod :prodList ){
                //add only if new portfolio is selected. 
                if(!existingPfs.contains(prod.id))
                    tempPortlistNew.add(new MFS_EventInviteeUtility.EventPortfolioWrapper(prod.Name, tempPortlistNew.size(), new Event_Relation_Portfolio_Junction__c(Portfolio__c = prod.Id)));   
            }
            tempEventPortfJnList.evntRelPortLst = tempPortlistNew;
            inviteesMap.remove((Id)inviteeId);
            inviteesMap.put((Id)inviteeId,tempEventPortfJnList);
        }catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage()));
        }
    }
    
    //Populate right side of multiselect in Select Attendee Modal
    public static void formRightOptionList(Map<Id,InviteeWrapper> inviteesMap, Map<ID, String> mLeftSelected, Map<ID, String> mRightSelected, List<SelectOption> lstRightOption, List<SelectOption> lstLeftOption, List<String> leftSelectedList, List<String> rightSelectedList, Event parentEvent){
        //initially clear the maps to reform it
        mLeftSelected.clear();
        mRightSelected.clear();
        lstRightOption.clear();
        lstLeftOption.clear();
        leftSelectedList.clear();
        rightSelectedList.clear();        
        
        for (MFS_EventInviteeUtility.InviteeWrapper wInvitee: inviteesMap.values()){
            if(wInvitee.evntRel != NULL && wInvitee.evntRel.RelationId__c != NULL && wInvitee.evntRel.Host__c == false){
                String sname,acctName,stype;
                
                sname = wInvitee.evntRel.Name__c;
                stype = wInvitee.evntRel.Invitee_Type__c;
                acctName = wInvitee.orgName;
                //display format is name - accountname - type
                mRightSelected.put(wInvitee.evntRel.RelationId__c, sname + ' - '+acctName+' - ' + stype);
                lstRightOption.add(new SelectOption( wInvitee.evntRel.RelationId__c, sname + ' - '+acctName+' - '+ stype ));
            }
        }  
        lstLeftOption.clear();
        mLeftSelected.clear();
        //list<InviteeLastNameSortWrapper> nameWrapperList=new list<InviteeLastNameSortWrapper>();
        if(parentEvent != null && !String.isEmpty(parentEvent.whatId) && parentEvent.whatId.getSobjectType().getDescribe().getName()=='Account'){
            //Load only 1000 contacts in the left side option
            List<Contact> relatedToContacts = new List<Contact>([select id, Name, FirstName, LastName, Account.Name from Contact where accountId = :parentEvent.whatId ORDER BY LastName ASC LIMIT 1000]);
            for(Contact c : relatedToContacts) {
                if(!mRightSelected.containsKey(c.Id)){
                    //nameWrapperList.add(new InviteeLastNameSortWrapper(c.id, c.firstName, c.lastName, ' - ' +c.Account.Name+ ' - ', Label.A360_Contact));
                    mLeftSelected.put(c.id, c.FirstName+' '+c.LastName +  ' - '+c.Account.Name+' - '+ Label.A360_Contact  );
                    lstLeftOption.add(new SelectOption(c.id, c.FirstName+' '+c.LastName +  ' - '+c.Account.Name+' - ' + Label.A360_Contact  ));
                }
            } 
        }
        /*nameWrapperList.sort();
        for(InviteeLastNameSortWrapper nameWrpr : nameWrapperList){
            mleftSelected.put(nameWrpr.invId, nameWrpr.firstName+' '+nameWrpr.lastName + nameWrpr.OrgName + nameWrpr.attendeeType);
            lstLeftOption.add(new SelectOption(nameWrpr.invId, nameWrpr.firstName+' '+nameWrpr.lastName + nameWrpr.OrgName + nameWrpr.attendeeType));
        }*/
    }
    
    /*
** Method Name     : searchInvitee
** Description     :  method to search the invitees to add.
** Used in         : 'Find' button in Invitee Popup screen (in Activity360 screen).
*/    
    public static void searchInvitee(Event e, String SearchText,String SearchTextOrg, String SearchTextCity, String SearchTextCountry, string SearchObjects, List<SelectOption> leftOptionList,Map<ID, String> mLeftSelected, List<SelectOption> lstLeftOption,Map<ID, String> mRightSelected  ){
        string TempSearchText;
        string tempSearchInObject;
        Boolean AlreadyFiltered=false;
        Map<Id,Contact> tempSearchContactMap = new Map<Id,Contact>();
        Map<Id,Contact> filteredContactMap = new Map<Id,Contact>();
        Map<Id,User> tempSearchUserMap = new Map<Id,User>();
        Map<Id,User> filteredUserMap = new Map<Id,User>();
        List<User> userList = new List<User>();
        //List<Contact> contactList = new List<Contact>();
        leftOptionList = new List<SelectOption>();
        try{
            
            if((!String.isEmpty(searchText) && searchText.trim().length()>2)
               || (!String.isEmpty(searchTextOrg) && searchTextOrg.trim().length()>2 )
               || (!String.isEmpty(searchTextCity) && searchTextCity.trim().length()>2)
               || (!String.isEmpty(searchTextCountry) && searchTextCountry.trim().length()>2 )){
                   Boolean isFiltered = false;
                   
                   if(SearchObjects!=null && !string.isBlank(SearchObjects)){
                       if(SearchObjects=='Users' || SearchObjects=='Users & Contacts'){
                           String queryString='SELECT id,firstName,lastName,Speaker_Request_Approval__c FROM User ';
                           if(!String.isEmpty(searchText) && searchtext.trim().length()>2){
                               String tempName='%'+searchText+'%';
                               queryString+=' where Name Like :tempName ';
                           }
                           if(!String.isEmpty(searchTextCity) && searchtextCity.trim().length()>2){
                               String tempCity='%'+searchTextCity+'%';
                               if(!queryString.contains('where')){
                                   queryString+='where City Like :tempCity ';
                               }
                               else{
                                   queryString+='and City Like :tempCity ';
                               }
                           }
                           if(!String.isEmpty(searchTextCountry) ){
                               String tempCountry='%'+searchTextCountry+'%';
                               if(!queryString.contains('where')){
                                   queryString+='where Country Like :tempCountry ';
                               }
                               else{
                                   queryString+='and Country Like :tempCountry ';
                               }
                           }
                           if(!String.isEmpty(searchTextOrg) && searchtextOrg.trim().length()>2){
                               String temporg='%'+searchTextOrg+'%';
                               if(!queryString.contains('where')){
                                   queryString+='where MFS_Location__c Like :tempOrg ';
                               }
                               else{
                                   queryString+='and MFS_Location__c Like :tempOrg ';
                               }
                           }
                           queryString+=' LIMIT 1000';
                           userList=database.query(queryString);
                           for(User u:userList){
                               tempSearchUserMap.put(u.id,u);
                           }
                       }
                       
                       
                       if(SearchObjects=='Contacts' || SearchObjects=='Users & Contacts'){
                           String keyword0 = '';
                           String keyword1='';
                           String keyword2='';
                           String keyword3='';
                           String keyword4='';
                           String keyword5 = '';
                           String whereClauseString = '';
                           if(!String.isEmpty(searchText) && searchText.trim().length() > 2){
                               keyword0 = '%'+searchText.Trim()+'%';
                               whereClauseString += ' AND Name__c like :keyword0 ';
                           }
                           if(!String.isEmpty(searchTextOrg) && searchTextOrg.trim().length()>2){
                               keyword1 = '%'+searchTextOrg.Trim()+'%';
                               whereClauseString += ' AND Account.Name like :keyword1 ';
                           }
                           if(!String.isEmpty(searchTextCity) && searchTextCity.trim().length() > 2){
                               keyword2 = '%'+searchTextCity.Trim()+'%';
                               whereClauseString += ' AND (MailingCity like :keyword2 OR OtherCity like :keyword2) ';
                           }
                           if(!String.isEmpty(searchTextCountry) && searchTextCountry.trim().length() > 2){
                               keyword3 = '%'+searchTextCountry.Trim()+'%';
                               whereClauseString += ' AND (MailingCountry like :keyword3 OR OtherCountry like :keyword3) ';
                           }
                           System.debug('whereClauseString======>'+whereClauseString);
                           if(whereClauseString.startsWithignoreCase(' AND'))
                               whereClauseString = whereClauseString.removeStartIgnoreCase(' AND');
                           String contactQueryString = 'Select id, firstName, lastName, Account.Name from Contact Where '+whereClauseString+' LIMIT 1000';
                           list<Contact> contactList = new list<Contact>();
                           contactList = Database.query(contactQueryString);
                           for(Contact c:ContactList){
                               tempSearchContactMap.put(c.id,c);
                           }
                       }
                   }
                   
                   //If Name field is not empty
                  /* if(!String.isEmpty(searchText) && searchtext.trim().length()>2) {
                       
                       list<Contact> contactList = new list<Contact>();
                       List<Contact> pcontactList = new List<Contact>();
                       tempSearchText = ( SearchText!=null && !string.isBlank(SearchText)) ? '*'+ String.escapeSingleQuotes(SearchText) +'*' : '';
                       
                       if(SearchObjects!=null && !string.isBlank(SearchObjects)){
                           if(SearchObjects=='Contacts' || SearchObjects=='Users & Contacts'){
                               tempSearchInObject = 'Contact(id,firstName,lastName, Account.Name)';
                               String searchquery = 'FIND \''+tempSearchText+'\' IN NAME FIELDS RETURNING' +' '+ tempSearchInObject;
                               List<List<SObject>> searchList = search.query(searchquery);
                               contactList=(Contact[])searchList[0];
                               //pcontactList = [select id, firstname, lastName, Account.Name from Contact where Preferred_Name__c = :tempSearchText];
                               if(contactList.isEmpty()){
                                   AlreadyFiltered=true;
                               }
                               for(Contact c:ContactList){
                                   tempSearchContactMap.put(c.id,c);
                               }
                               if(!contactList.isEmpty()){
                                   if(!tempSearchContactMap.isEmpty()){
                                       AlreadyFiltered=true;
                                   }
                               }
                           }
                       }
                   }    
                   
                   if((!String.isEmpty(searchTextOrg) && searchtextOrg.trim().length()>2) && String.isEmpty(searchTextCity) && String.isEmpty(searchTextCountry))
                   {
                       String tempSearchName;
                       list<contact>contactList = new list<Contact>();
                       if(!String.isEmpty(searchTextOrg)) {
                           tempSearchText ='%'+searchTextOrg+'%';
						}
                       
                       if(SearchObjects!=null && !string.isBlank(SearchObjects)){
                           
                           if(SearchObjects=='Contacts' || SearchObjects=='Users & Contacts'){
                               if(String.isEmpty(searchText)){
                                   contactlist=[SELECT ID,FirstName,lastName,Account.Name FROM CONTACT where Account.Name LIKE:tempSearchtext LIMIT 1000];
                               }
                               else{
                                   tempSearchName = searchText.contains(' ')? '%'+searchText.substring(0,searchText.indexOf(' '))+'%' : '%'+searchText+'%';
                                  // tempSearchName = '%'+searchText+'%';
                                   contactlist=[SELECT ID,firstName,lastName,Account.Name FROM CONTACT where Name LIKE:tempSearchName AND Account.Name LIKE:tempSearchtext LIMIT 10000];
								}
                               if(contactList.isEmpty()){
                                   AlreadyFiltered=true;
                               }
                               
                               
                               filteredContactMap.clear();
                               Map<Id,Contact>tempContactMap=new map<Id,Contact>();
                               
                               for(Contact c:contactList){
                                   if(!tempSearchContactMap.isEmpty() && tempSearchContactMap.containsKey(c.Id)){
                                       filteredContactMap.put(c.Id,c);
                                       isFiltered=true;
                                   }
                                   else if(!AlreadyFiltered){
                                       tempContactMap.put(c.Id,c);
                                   }
                                   
                               }
                               if(isFiltered){     
                                   tempSearchContactMap=new Map<Id,Contact>(filteredContactMap);
                               }
                               else{
                                   tempSearchContactMap=tempContactMap;
                               }
                               if(!contactList.isEmpty()){
                                   if(!tempSearchContactMap.isEmpty()){
                                       AlreadyFiltered=true;
                                   }
                               }
                           }
                           
                       }   
                       
                   }
                   
                   
                   
                   //If City Field or Country field  is not empty
                   if((!String.isEmpty(searchTextCity) && searchtextCity.trim().length()>2) || (!String.isEmpty(searchTextCountry) ))
                   {
                       
                       list<contact>contactList = new list<Contact>();
                       if(!String.isEmpty(searchTextCity) && String.isEmpty(searchTextCountry)) {
                           tempSearchText ='*'+ String.escapeSingleQuotes(SearchTextCity) +'*';
                       }
                       if(String.isEmpty(searchTextCity) && !String.isEmpty(searchTextCountry)) {
                           tempSearchText ='*'+ String.escapeSingleQuotes(SearchTextCountry) +'*';
                       }
                       if(!String.isEmpty(searchTextCity) && !String.isEmpty(searchTextCountry)) {
                           String tempText=String.escapeSingleQuotes(SearchTextCity)+' '+String.escapeSingleQuotes(SearchTextCountry);
                           tempSearchText ='*'+ tempText +'*';
                       }
                       
                       if(SearchObjects!=null && !string.isBlank(SearchObjects)){
                           
                           if(SearchObjects=='Contacts' || SearchObjects=='Users & Contacts'){
                               if(String.isEmpty(searchTextOrg)){
                                   tempSearchInObject = 'Contact(id,firstName,lastName, Account.Name)';
                                   
                               }
                               else{
                                   String tempOrg='%'+searchTextOrg+'%';
                                   tempSearchInObject = 'Contact(id,firstname,lastName, Account.Name where Account.Name LIKE :tempOrg LIMIT 2000)';
                               }
                               
                               
                               String searchquery = 'FIND \''+tempSearchText+'\' IN ALL FIELDS RETURNING' +' '+ tempSearchInObject;
                               
                               
                               
                               List<List<SObject>> searchList = search.query(searchquery);
                               
                               if(SearchObjects=='Contacts' || SearchObjects=='Users & Contacts'){
                                   
                                   contactList=(Contact[])searchList[0];
                                   if(contactList.isEmpty()){
                                       AlreadyFiltered=true;
                                   }
                               }
                               
                               filteredContactMap.clear();
                               Map<Id,Contact>tempContactMap=new map<Id,Contact>();
                               
                               for(Contact c:contactList){
                                   if(!tempSearchContactMap.isEmpty() && tempSearchContactMap.containsKey(c.Id)){
                                       filteredContactMap.put(c.Id,c);
                                       isFiltered=true;
                                   }
                                   else if(!AlreadyFiltered ){
                                       tempContactMap.put(c.Id,c);
                                   }
                                   
                               }
                               if(isFiltered){     
                                   tempSearchContactMap=new Map<Id,Contact>(filteredContactMap);
                               }
                               else{
                                   tempSearchContactMap=tempContactMap;
                               }
                               
                           }
                           
                       }    
                       
                   }
                   */
                   
                   
               }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Enter at least two characters'));
            }  
            
            //Add the search results to list and map to display on the page
            mLeftSelected.clear();
            lstLeftOption.clear();
            list<InviteeLastNameSortWrapper> nameWrapperList=new list<InviteeLastNameSortWrapper>();
            for (User u : tempSearchUserMap.values()) {
                //Add to list only if not already added and not parent assignee
                if(!mRightSelected.containsKey(u.id) && (e.OwnerId != u.id )){
                    //mLeftSelected.put(u.id, u.firstname +u.lastName+ ' - MFS - '+ Label.A360_User  );
                    nameWrapperList.add(new InviteeLastNameSortWrapper(u.id,u.firstName,u.lastName,' - MFS - ','User'));
                }
            }
            for (Contact c : tempSearchContactMap.values()) {
                if(!mRightSelected.containsKey(c.id)){
                    //mLeftSelected.put(c.id, c.firstName +c.lastName+ ' - '+c.Account.Name+' - ' + Label.A360_Contact  );
                    nameWrapperList.add(new InviteeLastNameSortWrapper(c.id,c.firstName,c.lastName,' - '+c.Account.Name+' - ','Contact'));
                }
            }
            
            nameWrapperList.sort();
            for(InviteeLastNameSortWrapper nameWrpr:nameWrapperList){
                mleftSelected.put(nameWrpr.invId,nameWrpr.firstName+' '+nameWrpr.lastName+nameWrpr.OrgName+nameWrpr.attendeeType);
                lstLeftOption.add(new SelectOption(nameWrpr.invId,nameWrpr.firstName+' '+nameWrpr.lastName+nameWrpr.OrgName+nameWrpr.attendeeType));
                
            }
        }catch(Exception ex){
            system.debug('Exception in searchInvitee : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    
  //Remove attendees from the list
    public static void removeInvitee(Map<Id,MFS_EventInviteeUtility.InviteeWrapper> inviteesMap, ID removeInviteeId, List<ID> lstAllInviteeIDs, map<String, sObject> rightOptionMap, Set<Id> removedInvitees, Set<Id> inviteeOrderKeys )
    {
        try{
            if(inviteesMap.containsKey(removeInviteeId)){
                inviteesMap.remove(removeInviteeId);
                inviteeOrderKeys.remove(removeInviteeId);
                removedInvitees.add(removeInviteeId);
                Set<ID> sIDtemp = new Set<ID>(lstAllInviteeIDs);
                if(sIDtemp.contains(removeInviteeId)){
                    sIDtemp.remove(removeInviteeId);
                    lstAllInviteeIDs.clear();
                    lstAllInviteeIDs.addall(sIDtemp);
                }
            }  
            if(rightOptionMap.containsKey(removeInviteeId)){
                rightOptionMap.remove(removeInviteeId);
            }
        }catch(Exception ex){
            system.debug('Exception in removeInvitee : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
       
    //Add invitees to list after closing the popup
    public static void addInvitees(Event parentEvent, Set<ID> sExistingRelationIds, List<ID> lstAllInviteeIDs, Map<Id,MFS_EventInviteeUtility.InviteeWrapper> inviteesMap, Map<ID, String> mLeftSelected, Map<ID, String> mRightSelected,
                                   List<SelectOption> lstRightOption, List<SelectOption> lstLeftOption, List<String> leftSelectedList, List<String> rightSelectedList, String startDateTime, String endDateTime, Set<Id> inviteeOrderKeys)
    {
        
        try{
            /*List<Event_Relation__c> tempERList = new List<Event_Relation__c>([select Id, RelationId__c from Event_Relation__c where Activity_Detail__c = :parentEvent.Id]);
            Set<String> tempIds = new Set<String>();
            for(Event_Relation__c er : tempERList) 
            {
               tempIds.add(er.RelationId__c);
            }*/
            Set<Id> contIds = new Set<Id>();
            Set<Id> usrIds = new Set<Id>();
            //Separate users and contacts from the Attendee list
            for(Id selId: mRightSelected.keySet())
            {
                if(selId.getSobjectType().getDescribe().getName()=='Contact')
                    contIds.add(selId);
                else
                    usrIds.add(selId);
            }
            Map<Id, Contact> orgForContactsMap = new Map<Id, Contact>([select AccountId, Account.Name from Contact where ID in :contIds]);
            Map<Id,User> approvalForUsers = new Map<Id, User>([Select id, Requires_Speaker_Approval__c from User where ID IN :usrIds]);
            
            for(Id selId: mRightSelected.keySet())
            {
                //Split the array and assign name and type to the attendee list
                String[] nameAndType = mRightSelected.get(selId).split('-');
                if(!inviteesMap.containsKey(selId)){
                    if(selId.getSobjectType().getDescribe().getName() == CONTACT_TEXT){
                        inviteesMap.put(selId, new MFS_EventInviteeUtility.InviteeWrapper(new Event_Relation__c(RelationId__c = selId, Name__c = nameAndType[0], Approval_Status__c = STATUS_APPROVED, Topic__c = NOT_APPLICABLE, Invitee_Type__c = CONTACT_TEXT, Org__c = orgForContactsMap.get(selId).AccountId, Start_Date__c = parentEvent.Event_Start_Date__c, End_Date__c = parentEvent.Event_End_Date__c), orgForContactsMap.get(selId).Account.Name, new Event_Relation_Portfolio_Junction__c(), new List<MFS_EventInviteeUtility.EventPortfolioWrapper>(), startDateTime, endDateTime));         
                        inviteeOrderKeys.add(selId);
                    }
                    else{
                        inviteesMap.put(selId, new MFS_EventInviteeUtility.InviteeWrapper(new Event_Relation__c(RelationId__c = selId, Name__c = nameAndType[0], Approval_Status__c = STATUS_NEW, Invitee_Type__c = USER_TEXT, Start_Date__c = parentEvent.Event_Start_Date__c, End_Date__c = parentEvent.Event_End_Date__c), MFS_TEXT, new Event_Relation_Portfolio_Junction__c(), new List<MFS_EventInviteeUtility.EventPortfolioWrapper>(), startDateTime, endDateTime));             
                        inviteeOrderKeys.add(selId);
                    }
                }
            }
            //Clear list
            mRightSelected.clear();
            mLeftSelected.clear();
            lstRightOption.clear();
            lstLeftOption.clear();
            leftSelectedList.clear();
            rightSelectedList.clear();
        }catch(Exception ex){
            system.debug('Exception in addInvitees : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Remove portfolios from attendees
    public static void removePortfFromInvitee(Map<Id,MFS_EventInviteeUtility.InviteeWrapper> inviteesMap, String inviteeId, String removePfRowNum, Activity_Detail__c callNote, Set<Id> removedInviteePf, Set<Id> portfToBeRemoved)
    {
        try{
            MFS_EventInviteeUtility.InviteeWrapper tempEventPortfJnList = inviteesMap.get((Id)inviteeId);
            List<MFS_EventInviteeUtility.EventPortfolioWrapper> tempPortlist = tempEventPortfJnList.evntRelPortLst;
            
            List<MFS_EventInviteeUtility.EventPortfolioWrapper> tempPortlistNew = new List<MFS_EventInviteeUtility.EventPortfolioWrapper>();
            if(callNote!=null && callNote.Not_An_Orphan_Record__c == true)
            {
                removedInviteePf.add(tempPortlist[Integer.valueOf(removePfRowNum)].evRelPort.Id);
                portfToBeRemoved.add(tempPortlist[Integer.valueOf(removePfRowNum)].evRelPort.Portfolio__c);
            }
            tempPortlist.remove(Integer.valueOf(removePfRowNum));
            Integer pRowNum = 0;
            for(MFS_EventInviteeUtility.EventPortfolioWrapper wc : tempPortlist)
            {
                wc.pRowNum = pRowNum;
                tempPortlistNew.add(wc);
                pRowNum++;
            }
            tempEventPortfJnList.evntRelPortLst = tempPortlistNew;
            inviteesMap.remove((Id)inviteeId);
            inviteesMap.put((Id)inviteeId,tempEventPortfJnList);  
        }catch(Exception ex){
            system.debug('Exception in removePortfFromInvitee : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Change attendee time slots when parent activity datetime is changed
    public static void changeInviteeTimeSlots(Map<Id,MFS_EventInviteeUtility.InviteeWrapper> inviteesMap, Event parentEvent, String startDateTime, String endDateTime)
    {
        try{
            Map<Id, MFS_EventInviteeUtility.InviteeWrapper> tempImviteesMap = new Map<Id, MFS_EventInviteeUtility.InviteeWrapper>();
            MFS_EventInviteeUtility.InviteeWrapper tempInvitees;
            for(Id selId : inviteesMap.keySet())
            {
                tempInvitees = inviteesMap.get(selId);
                tempInvitees.evntRel.Start_Date__c = parentEvent.Event_Start_Date__c;
                tempInvitees.evntRel.End_Date__c = parentEvent.Event_End_Date__c;
                tempInvitees.startTime = startDateTime;
                tempInvitees.endTime = endDateTime;
                tempImviteesMap.put(selId,tempInvitees);
            }
            inviteesMap = tempImviteesMap;
        }catch(Exception ex){
            system.debug('Exception in changeInviteeTimeSlots : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Change host for attendees
    public static void changeHostForInvitees(Map<Id,MFS_EventInviteeUtility.InviteeWrapper> inviteesMap, Event parentEvent, Set<Id> inviteeOrderKeys, Id oldAssignedToId)
    {
        try{
            Map<Id, MFS_EventInviteeUtility.InviteeWrapper> tempImviteesMap = new Map<Id, MFS_EventInviteeUtility.InviteeWrapper>();
            MFS_EventInviteeUtility.InviteeWrapper tempInvitees = inviteesMap.get(oldAssignedToId);
            tempInvitees.evntRel.RelationId__c  = parentEvent.OwnerId;
            User usr = [select Name from User where ID = :parentEvent.OwnerId];
            tempInvitees.evntRel.Name__c = usr.Name;
            inviteesMap.remove(oldAssignedToId);
            inviteesMap.put(parentEvent.OwnerId,tempInvitees);
            inviteeOrderKeys.clear();
            inviteeOrderKeys.add(parentEvent.OwnerId);
            for(Id newId : inviteesMap.keySet())
            {
                inviteeOrderKeys.add(newId);
            }
        }  catch(Exception ex){
            system.debug('Exception in changeHostForInvitees : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Return JSON for searched attendees(left side of multiselect)
    public static String getLeftSideInvitees(List<SelectOption> lstLeftOption){
        String jSONString;
        try{
            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartArray();
            for(SelectOption s : lstLeftOption)
            {
                gen.writeStartObject();
                gen.writeStringField('id', s.getValue());
                gen.writeStringField('label', s.getLabel());
                gen.writeEndObject();
            }
            gen.writeEndArray();
            jSONString = gen.getAsString();
        }catch(Exception ex){
            system.debug('Exception in getLeftSideInvitees : '+ex.getStackTraceString());
            throw ex;
        }
        return jSONString;
    }
    
    //Return JSON string for selected attendees
    public Static String getRightSideInvitees(List<SelectOption> lstRightOption)
    {
        String jSONString;
        try{
            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartArray();
            for(SelectOption s : lstRightOption)
            {
                gen.writeStartObject();
                gen.writeStringField('id', s.getValue());
                gen.writeStringField('label', s.getLabel());
                gen.writeEndObject();
            }
            gen.writeEndArray();
            jSONString = gen.getAsString();
        }catch(Exception ex){
            system.debug('Exception in getRightSideInvitees : '+ex.getStackTraceString());
            throw ex;
        }  
        return jSONString;
    }
    
    //Method to prepare sorted list(sort by timeslot) of attendees. This will call campareTo method
    public static String sortInviteesByTime(Map<Id, MFS_EventInviteeUtility.InviteeWrapper> inviteesMap, Set<Id> inviteeOrderKeys, String columnName, String sOrder){
        try{
            List<InviteeSortWrapper> tempList = new List<InviteeSortWrapper>();
            for(Id invId : inviteesMap.keySet()){
                //if timeslot is empty then set the default time
                String st = inviteesMap.get(invId).startTime == 'None' ? DEFAULT_SORT_TIME : inviteesMap.get(invId).startTime;
                String et = inviteesMap.get(invId).endTime == 'None' ? DEFAULT_SORT_TIME : inviteesMap.get(invId).endTime;
                tempList.add(new InviteeSortWrapper(invId, MFS_Activity360GeneralUtility.dateTimeConcat(inviteesMap.get(invId).evntRel.Start_Date__c,st), MFS_Activity360GeneralUtility.dateTimeConcat(inviteesMap.get(invId).evntRel.End_Date__c,et)));
            }
            if(sOrder == ASC_ORDER)
                sortingOrder = DESC_ORDER;
            else
                sortingOrder = ASC_ORDER;
            tempList.sort();
            inviteeOrderKeys.clear();
            for(InviteeSortWrapper isw : tempList){
                inviteeOrderKeys.add(isw.invId);
            }
        }catch(Exception ex){
            system.debug('Exception in sortInviteesByTime : '+ex.getStackTraceString());
            throw ex;
        }
        return sortingOrder;
    }
    
    //Method to prepare sorted list(sort by Organization) of attendees. This will call campareTo method
    public static String sortInviteesByOrg(Map<Id, MFS_EventInviteeUtility.InviteeWrapper> inviteesMap, Set<Id> inviteeOrderKeys, String columnName, String sOrder)
    {
        try{
            List<InviteeOrgSortWrapper> tempList = new List<InviteeOrgSortWrapper>();
            for(Id invId : inviteesMap.keySet())
            {
                tempList.add(new InviteeOrgSortWrapper(invId, inviteesMap.get(invId).orgName));
            }
            if(sOrder == ASC_ORDER)
                sortingOrgOrder = DESC_ORDER;
            else
                sortingOrgOrder = ASC_ORDER;
            tempList.sort();
            inviteeOrderKeys.clear();
            for(InviteeOrgSortWrapper isw : tempList)
            {
                inviteeOrderKeys.add(isw.invId);
            }
        }catch(Exception ex){
            system.debug('Exception in sortInviteesByOrg : '+ex.getStackTraceString());
            throw ex;
        }
        return sortingOrgOrder;
    }
    
    //When Accept button is clicked from page it will update the database
    public static void acceptInvite(Map<Id, MFS_EventInviteeUtility.InviteeWrapper> inviteesMap, Activity_Detail__c callNote, Event parentEvent)
    {
        try{
            Event_Relation__c evRel = [select id,Approval_Status__c, RelationId__c from Event_Relation__c where RelationId__c =: UserInfo.getUserId() and Activity_Detail__c = :callNote.Id];
            EventRelation stdEnRel= [select id, RelationId from EventRelation where RelationId = :UserInfo.getUserId() and eventId = :parentEvent.Id];
            evRel.Approval_Status__c = STATUS_APPROVED;
            stdEnRel.Status = STATUS_ACCEPTED;
            update evRel;
            inviteesMap.get(UserInfo.getUserId()).evntRel.Approval_Status__c = STATUS_APPROVED;
        }catch(Exception ex){
            system.debug('Exception in acceptInvite : '+ex.getStackTraceString());
            throw ex;
        }        
    }
    
    //When Decline button is clicked from page it will update the database
    public static void declineInvite(Map<Id, MFS_EventInviteeUtility.InviteeWrapper> inviteesMap, Activity_Detail__c callNote, Event parentEvent)
    {
        try{
            Event_Relation__c evRel = [select id,Approval_Status__c, RelationId__c from Event_Relation__c where RelationId__c =: UserInfo.getUserId() and Activity_Detail__c = :callNote.Id];
            EventRelation stdEnRel= [select id, RelationId from EventRelation where RelationId = :UserInfo.getUserId() and eventId = :parentEvent.Id];
            evRel.Approval_Status__c = STATUS_REJECTED;
            stdEnRel.Status = STATUS_DECLINED;
            update evRel;
            inviteesMap.get(UserInfo.getUserId()).evntRel.Approval_Status__c = STATUS_REJECTED;
        }catch(Exception ex){
            system.debug('Exception in declineInvite : '+ex.getStackTraceString());
            throw ex;
        }
    }
}