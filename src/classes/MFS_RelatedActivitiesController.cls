global class MFS_RelatedActivitiesController {
    private String recId;
    public SearchKeyWrapper wSearchKey {get;set;}
    public string SearchObjects {get;set;}
    public Transient List<sObject> activitiesList{get;set;}
    public Map<ID, Activity_Detail__c> mapActIdToActDetail {get;set;}
    public string isConsole {get;set;}
    public Boolean t_rue {get;set;}
    public Map<id, Event> mapFilteredEvents {get;set;}
    public Map<id, Task> mapFilteredTasks {get;set;}    
    public List<WrapperForSearchableProducts> wlSearchedProducts {get;set;} 
    public String parentObject {get;set;}
    private String parentObjectType ;
    
    public String selectedAttendeeHidden {get;set;}
    public DateTime stime {get;set;}
    public DateTime etime {get;set;}
    //Constructor
    public  MFS_RelatedActivitiesController(){
        stime = System.now();
        isConsole = Apexpages.currentPage().getParameters().get('isConsole');
        recId = Apexpages.currentPage().getParameters().get('Id');
        if(!String.isBlank(recId)){
            parentObjectType = (Id.valueOf(recId)).getSObjectType().getDescribe().getName() ;
        }
        t_rue = TRUE;
        wSearchKey = new SearchKeyWrapper();
        wlSearchedProducts = new List<WrapperForSearchableProducts>();
        wSearchKey.product = new Product2();
        wSearchKey.sProductIds = new Set<Id>();
        wSearchKey.sMethods = new Set<String>();
        wSearchKey.sAttendeeIds = new Set<Id>();
        wSearchKey.method = '';
        wSearchKey.selectedmethods = '';
        //initialize wrapper fields related to attendee modal window
        wSearchKey.wAttendees = new AttendeeSearchKeyWrapper();
        wSearchKey.wAttendees.searchText = '';
        wSearchKey.wAttendees.searchTextorg = '';
        wSearchKey.wAttendees.searchTextCity = '';
        wSearchKey.wAttendees.searchTextCountry = '';
        wSearchKey.wAttendees.lstRightOption = new List<SelectOption> ();
        wSearchKey.wAttendees.lstLeftOption = new List<SelectOption> ();
        wSearchKey.wAttendees.rightOptionList  = new List<SelectOption> ();
        wSearchKey.wAttendees.leftOptionList  = new List<SelectOption> ();
        wSearchKey.wAttendees.mRightSelected  = new Map<ID, String> ();
        wSearchKey.wAttendees.mLeftSelected   = new Map<ID, String> ();
        wSearchKey.wAttendees.leftSelectedList   = new List< String> ();
        wSearchKey.wAttendees.rightSelectedList    = new List< String> ();
        
        activitiesList = new List<sObject>();
        mapFilteredEvents = new Map<id, Event>();
        mapFilteredTasks = new Map<id, Task>();
        mapActIdToActDetail = new Map<ID, Activity_Detail__c>();
        
        //Set default search key values
        //wSearchKey.timeframe = 'All Time'; 3 Months
        wSearchKey.timeframe = '1 Year';
        wSearchKey.method = '';
        wSearchKey.idAssignedTo = NULL;
        wSearchKey.sProductIds = new Set<ID>();
        wSearchKey.methodOptions = new List<SelectOption>();
        wSearchKey.methodOptions.add(new SelectOption('','--Select--'));
        for(String s: MFS_AllConstants.ACTIVITY_METHOD_LABELS.keyset()){
            wSearchKey.methodOptions.add(new SelectOption(s,s));
        }
        
        FilterActivity();
        etime = System.now();
    }
    
    public void init(){
        FilterActivity();
    }
    
    //This method filters the related activities based on filter conditions selected. This method is executed when 'Search' button clicked from UI
    public void FilterActivity(){
        system.debug('--01--start of filteractivity'+system.now());
        Map<ID, ID> mapActDetailIdToActId = new Map<ID, ID>();
        List<SObject> lstOpenAct;
        List<SObject> lstActHist;
        List<OpenActivity> openActList = new List<OpenActivity>();
        List<ActivityHistory> ActHistList = new List<ActivityHistory>();
        activitiesList = new List<SObject>();
        mapActDetailIdToActId.clear();
        mapActDetailIdToActId.clear();
        mapActIdToActDetail.clear();
        activitiesList.clear();
        addSeletedProduct();
        addSeletedAttendees();
        selectedAttendeeHidden = '';
        Set<Id> sAllActivityIds = new Set<Id>(); 
        
        List<SObject> SobjectWithOpenAct = Database.query(formActivityQuery(wSearchKey, TRUE));
        for(SObject oaList :SobjectWithOpenAct)
        {
            parentObject =(String) oaList.get('Name');
            lstOpenAct = oaList.getSObjects('OpenActivities');
            if(lstOpenAct != NULL && lstOpenAct.size()  !=0){
                for(OpenActivity oa : (List<OpenActivity>)oaList.getSObjects('OpenActivities')){
                    //Loop through all the queried Open Activities and segregate IDs for later processing
                    mapActDetailIdToActId.put(oa.Activity_Detail__c,oa.id);
                    sAllActivityIds.add(oa.id);
                }
            }
        }
        
        List<SObject> s = Database.query(formActivityQuery(wSearchKey, FALSE)); 
        for(SObject oaList :s)//Database.query(formActivityQuery(wSearchKey, FALSE))
        {
            lstActHist = oaList.getSObjects('ActivityHistories');
            if(lstActHist != NULL && lstActHist.size()  !=0){
                for(ActivityHistory oa : (List<ActivityHistory>) oaList.getSObjects('ActivityHistories')){
                    //Loop through all the queried Activity Histories and segregate IDs for later processing
                    mapActDetailIdToActId.put(oa.Activity_Detail__c,oa.id);
                    sAllActivityIds.add(oa.id);
                }
            }
        } 
        
        //Events and Tasks are queried in order to get the values for field (Type, RecordType.Name, Activity_Type_for_Instit__c) 
        mapFilteredEvents = new Map<id, Event>( [select id, Type,(select id, RelationId, Relation.Name, Relation.Type from EventRelations where isWhat != TRUE), RecordType.Name,Activity_Type_for_Instit__c from Event where id IN : sAllActivityIds]);
        mapFilteredTasks = new Map<id, Task>( [select id, Type,Follow_up_Type__c, RecordType.Name from Task where id IN : sAllActivityIds]);
        //The Standard Activities are linked to Other Objects (like Products, Competitive Analysis, Attendees) through the Custom Object Activity_Detail__c. Hence, the Activity_Detail__c records are queried along with its related child records.
        for(Activity_Detail__c ad: [select id, Notes__c,Other_Notes__c,
                                    (select id, Name__c, RelationId__c, Invitee_Type__c from Invitees__r ),
                                    (select id, Product__c, Product__r.Name from Products__r),
                                    (select id from Competitive_Analysis__r)
                                    from Activity_Detail__c 
                                    where id in : mapActDetailIdToActId.keyset()]){
                                        if(ad.Notes__c != NULL){
                                            //The Striped Rich Text field value is stored temporarily in Other_Notes__c 
                                            ad.Other_Notes__c = ad.Notes__c.stripHtmlTags().abbreviate(256).trim();
                                            if(ad.Other_Notes__c.isWhiteSpace()){
                                                ad.Other_Notes__c = NULL; 
                                            }
                                        }else{
                                            ad.Other_Notes__c = '';
                                        }
                                        mapActIdToActDetail.put(mapActDetailIdToActId.get(ad.id),ad);
                                    }
        for(SObject oaList :s)//Database.query(formActivityQuery(wSearchKey, FALSE))
        {
            lstActHist = oaList.getSObjects('ActivityHistories');
            //Only A360 activities have related custom record; Hence, for other std activities, the dummy custom record is passed in order to avoid VF page error(optional).
            for(Id sid: sAllActivityIds){
                if(!mapActIdToActDetail.containskey(sid)){
                    Activity_Detail__c dummyAD = new Activity_Detail__c();
                    mapActIdToActDetail.put(sid, dummyAD);
                }
            }
            if(lstOpenAct != NULL && lstOpenAct.size()  !=0){
                for(SObject oaListOpenAct :SobjectWithOpenAct)
                {
                    for(OpenActivity oa : (List<OpenActivity>)oaListOpenAct.getSObjects('OpenActivities')){
                        if(mapActIdToActDetail.containsKey(oa.id)){
                            Activity_Detail__c oActivityDetail = mapActIdToActDetail.get(oa.id);
                            //Add to the display list only if selected attendee and product matches.
                            if(checkIfSelectedAttendeeMatching(wSearchKey.sAttendeeIds, oActivityDetail) &&
                               (checkIfSelectedProductMatching(wSearchKey.sProductIds, oActivityDetail))){
                                   openActList.add(oa);
                               }    
                        }
                    }
                }
            }
            
            if(lstActHist != NULL && lstActHist.size()  !=0){
                for(ActivityHistory oa : (List<ActivityHistory>)oaList.getSObjects('ActivityHistories')){
                    if(mapActIdToActDetail.containsKey(oa.id)){
                        Activity_Detail__c oActivityDetail = mapActIdToActDetail.get(oa.id);
                        //Add to the display list only if selected attendee and product matches.
                        if(checkIfSelectedAttendeeMatching(wSearchKey.sAttendeeIds, oActivityDetail) &&
                           (checkIfSelectedProductMatching(wSearchKey.sProductIds, oActivityDetail))){
                               ActHistList.add(oa);
                           }
                        
                    }
                }
            }
            
            Boolean isDescOrder;
            if(wSearchKey.timeframe == System.Label.A360_Upcoming_3_Months){
                isDescOrder = FALSE;
            }else{
                isDescOrder = TRUE;
            }
            //Merge the sorted Open Activities and Activities History to one common display list of type List<SObject>.
            activitiesList=mergeSortActivities(openActList, ActHistList, isDescOrder);
        }
        
        
        
        system.debug('--01--end of filteractivity'+system.now());
    }
    
    //This method merges the sorted 'Open Activities' and 'Activities History' to one common display list of type List<SObject>.
    public List<SObject> mergeSortActivities(List<OpenActivity> openActList, List<ActivityHistory> ActHistList, Boolean isDescOrder){
        Integer indexOpentAct = 0;
        Integer indexActHist = 0;
        List<SObject> activitiesListNew = new List<SObject>();
        while(openActList.size() > indexOpentAct || ActHistList.size() > indexActHist){
            OpenActivity tempOA ;
            ActivityHistory tempAH ;
            if(openActList.size() > indexOpentAct){
                tempOA = openActList.get(indexOpentAct);
            }
            if(ActHistList.size() > indexActHist){
                tempAH = ActHistList.get(indexActHist);
            }
            if(tempOA != NULL && tempAH != NULL){
                if( (tempOA.ActivityDate == NULL) ||
                   ((!isDescOrder) && (tempOA.ActivityDate <= tempAH.ActivityDate)) ||
                   ((isDescOrder) && (tempOA.ActivityDate >= tempAH.ActivityDate)) 
                  ){
                      activitiesListNew.add((SObject)tempOA);
                      indexOpentAct++;
                  }else{
                      activitiesListNew.add((SObject)tempAH);
                      indexActHist++;
                  }
                
            }else if(tempOA != NULL && tempAH == NULL){
                activitiesListNew.add((SObject)tempOA);
                indexOpentAct++;
            }else if(tempOA == NULL && tempAH != NULL){
                activitiesListNew.add((SObject)tempAH);
                indexActHist++;
            }  
        }
        return activitiesListNew;  
    }
    
    
    //This method form the dynamic soql query to retrieve the parent object along with its activities. 
    //The Time frame, Method and Assigned Person filter conditions are handled through Query and he Product and Attendee filters are handled through code logic.
    public String formActivityQuery( SearchKeyWrapper wSearchKey, Boolean isOpenActivities){
        String query = 'select id, Name, ';     
        String queryrepeatbefore = ' (select id, subject,Who.Name,PrimaryWhoId,WhatId,IsTask, ActivityDate,Location,  Status,Priority,Owner.Name, Method__c, Activity_Type__c,Activity_Type_for_Instit__c, Activity_Detail__c from ';
        String queryrepeatafter = '';
        
        //Filter by Time Frame
        if (wSearchKey.timeframe != 'All Time'){
            queryrepeatafter = ' AND ';
        }
        if (wSearchKey.timeframe == 'Upcoming 3 Months'){
            queryrepeatafter += ' ((ActivityDate = TODAY) OR (ActivityDate = NEXT_N_DAYS:90))  ' ;
        }else if (wSearchKey.timeframe == '1 Month'){
            queryrepeatafter += ' ActivityDate =  LAST_N_DAYS:30 ' ;
        }else if (wSearchKey.timeframe == '3 Months'){
            queryrepeatafter += ' ActivityDate =  LAST_N_DAYS:90 ' ;
        }else if (wSearchKey.timeframe == '6 Months'){
            queryrepeatafter += ' ActivityDate =  LAST_N_DAYS:180 ' ;
        }else if (wSearchKey.timeframe == '1 Year'){
            queryrepeatafter += ' ActivityDate =  LAST_N_DAYS:365 ' ;
        }else if (wSearchKey.timeframe == '2 Years'){
            queryrepeatafter += ' (ActivityDate =  LAST_N_DAYS:730 ) ' ;
        }else if (wSearchKey.timeframe == '3 Years'){
            queryrepeatafter += ' (ActivityDate =  LAST_N_DAYS:1095 ) ' ;
        }else {
            
        }
        if(String.isblank(wSearchKey.selectedmethods)){
            
        }else {
            //Filter by Method Field
            queryrepeatafter += 'AND (Method__c IN (' + wSearchKey.selectedmethods + ') ';
            if( wSearchKey.selectedmethods.containsignorecase('Phone Call')){
                //include all tasks if method is 'Phone Call'
                queryrepeatafter += ' OR isTask = TRUE ';
            }
            queryrepeatafter += ') ';
        }
        
        //Filter by Assigned To Person
        if(!String.isBlank(wSearchKey.idAssignedTo)){
            queryrepeatafter += ' AND Ownerid = \'' + wSearchKey.idAssignedTo + '\' ';
        }
        
        //Order based on time frame selection
        String queryOrder = ' DESC ';
        if (wSearchKey.timeframe == 'Upcoming 3 Months'){
            queryOrder = ' ASC ';
        }
        
        String queryrepeatafterActHist =  queryrepeatafter + ' ORDER BY ActivityDate '+queryOrder+ ' , LastModifiedDate DESC LIMIT 400) ';
        queryrepeatafter +=' ORDER BY ActivityDate '+queryOrder+ ' , LastModifiedDate DESC LIMIT 400) ';
        
        if(isOpenActivities){
            query += queryrepeatbefore + ' OpenActivities where Activity_Detail__c != NULL ' + queryrepeatafter  ;
        }else{
            query +=  queryrepeatbefore + ' ActivityHistories where Activity_Detail__c != NULL ' + queryrepeatafterActHist ; 
        }        
        query += ' from ' + parentObjectType + ' where Id=\'' + recId + '\'';
        return query;
    }
    
    
    //Wrapper to hold all the search keys entered through UI
    public class SearchKeyWrapper{
        public String timeframe{get;set;} //selected timeframe
        public String method{get;set;} //
        public List<SelectOption> methodoptions {get;set;} //Method options available in UI
        public String selectedmethods {get;set;} //comma separated selected methods
        public Set<String> sMethods {get;set;} //all selected Method values
        public Id idAssignedTo {get;set;}
        
        public Set<Id> sProductIds {get;set;} //all selected product IDs
        public Product2 product {get;set;} //search key in modal popup
        public String selectedProduct{get;set;} //comma separated Product Ids
        
        public Set<Id> sAttendeeIds {get;set;} //all selected Attendee IDs
        public AttendeeSearchKeyWrapper wAttendees {get;set;} //search keys for attendee
        public String selectedAttendee {get;set;} //comma separated Attendee Ids
        
    }
    
    //This wrapper holds the search keys related to Attendee selection popup
    public class AttendeeSearchKeyWrapper{
        public String searchText {get;set;}
        public String searchTextOrg {get;set;}
        public String searchTextCity {get;set;}
        public String searchTextCountry {get;set;}
        public List<SelectOption> lstRightOption {get;set;}
        public List<SelectOption> lstLeftOption {get;set;} 
        public List<SelectOption> rightOptionList {get;set;}
        public List<SelectOption> leftOptionList {get;set;} 
        public Map<ID, String> mRightSelected {get;set;}
        public Map<ID, String> mLeftSelected {get;set;}
        public List<String> leftSelectedList {get;set;}
        public List<String> rightSelectedList {get;set;}         
    }
    
    //Remote method to return the list of Leads matching the keyword
    @RemoteAction
    global static List<User> queryUsers(String keyword) { 
        List<User> userList = new List<User>();
        userList = MFS_Activity360SF1Utility.queryUsers(keyword);
        return userList;
    }
    
    //Remote method to return the list of contacts matching the keyword
    @RemoteAction
    global static List<Contact> queryContacts(String keyword){
        List<Contact> contactList = new List<Contact>();
        contactList = MFS_Activity360SF1Utility.queryContacts(keyword);
        return contactList;
    }    
    //Remote method to return the list of Products matching the keyword
    @RemoteAction
    global static List<Product2> queryPortfolios(String keyword) {
        List<Product2> portfolios = new List<Product2>();
        portfolios = MFS_Activity360SF1Utility.queryPortfolios(keyword);
        return portfolios;
    }   
    
    //This wrapper holds the queried product records which are available in product selection popup 
    public class WrapperForSearchableProducts{
        public product2 p {get;set;}
        public Boolean isSelected {get;set;}
        public WrapperForSearchableProducts (Boolean isSelected,product2 p){
            this.p = p;
            this.isSelected = isSelected ;
        }
        public WrapperForSearchableProducts (){
            this.p = new Product2();
            this.isSelected = false ;
        }
    }
    
    //Construct query for product search depending on user's entry
    @TestVisible
    private  String constructProductQuery(Product2 prodToSearch)
    {
        String query='Select Id,Name,Strategy__r.Name,Asset_Class_by_Geography__c,Vehicle__c,Restricted__c, Product_Record_Type__c from Product2 where IsActive=true and Is_Unknown__c =false and Restricted__c=false  '; //Asset_Class_Geography__c field is replace by Asset_Class_by_Geography__c on 01/Feb/2017
        if(prodToSearch.Name!='' && prodToSearch.Name!=null){
            query=query+' AND (Strategy__r.Name like '+'\'%'+String.escapeSingleQuotes(prodToSearch.Name)+ '%\''+' OR Name like '+'\'%'+String.escapeSingleQuotes(prodToSearch.Name)+ '%\''+')';
        }
        if( prodToSearch.Asset_Class_Geography__c !='None' && prodToSearch.Asset_Class_Geography__c !=null && prodToSearch.Asset_Class_Geography__c !=''){
            query=query+' AND Asset_Class_by_Geography__c ='+'\''+String.escapeSingleQuotes(prodToSearch.Asset_Class_Geography__c )+'\' ';
        }
        if(prodToSearch.Vehicle__c!='None' && prodToSearch.Vehicle__c !=null && prodToSearch.Vehicle__c!='')
        {
            query=query+' AND Vehicle__c='+'\''+String.escapeSingleQuotes(prodToSearch.Vehicle__c)+'\' ';
            
        }
        if(query.EndsWith('where ')) {
            query = query.removeEnd('where ');
        }
        if(query.EndsWith('AND ')) {
            query = query.removeEnd('AND ');
        }
        query=query+' ORDER BY Product_Record_Type__c,Strategy__r.Name,Name, Vehicle__c ASC Limit 25'; //Limit is changed on 01/Feb/2017
        return query;
    }      
    
    //This method executed when Product Search window opens
    public void OpenProductSearchModal(){
        wSearchKey.sProductIds = new Set<ID>();
        wSearchKey.product = new Product2();
        wSearchKey.selectedProduct = '';
        searchProduct();
    }
    
    //This method executed when Product Search window opens
    public void OpenAttendeeSearchModal(){
        wSearchKey.sAttendeeIds = new Set<ID>();
        //initially clear the maps to reform it
        wSearchKey.wAttendees.mLeftSelected.clear();
        wSearchKey.wAttendees.mRightSelected.clear();
        wSearchKey.wAttendees.lstRightOption.clear();
        wSearchKey.wAttendees.lstLeftOption.clear();
        wSearchKey.wAttendees.leftSelectedList.clear();
        wSearchKey.wAttendees.rightSelectedList.clear();
        wSearchKey.wAttendees.rightOptionList.clear();
        wSearchKey.wAttendees.leftOptionList.clear();
        wSearchKey.wAttendees.searchText='';
        wSearchKey.wAttendees.searchTextOrg='';
        wSearchKey.wAttendees.searchTextCity='';
        wSearchKey.wAttendees.searchTextCountry='';
        wSearchKey.selectedAttendee = '';
        selectedAttendeeHidden ='';
        searchInvitee();
    }
    
    
    //This method displays the filtered out products in Product popup
    public void searchProduct(){
        try{
            wlSearchedProducts.clear();    
            String query=constructProductQuery(wSearchKey.product);
            List<Product2> pList=Database.query(query);                
            for(Product2 pbRec:pList){                  
                wlSearchedProducts.add( new WrapperForSearchableProducts(false, pbRec)); 
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }   
    
    //Add Selected Products to Invitees Section OR Products related list
    public void addSeletedProduct() {
        try{
            wSearchKey.sProductIds.clear();
            if(!String.isEmpty(wSearchKey.selectedProduct))
            {
                
                List<String> tempPList = new List<String>(wSearchKey.selectedProduct.split(','));
                for(String s : tempPList)
                {
                    wSearchKey.sProductIds.add(Id.Valueof(s));
                }
                
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Add Selected Products to Invitees Section OR Products related list
    public void addSeletedAttendees() {
        try{
            wSearchKey.sAttendeeIds.clear();
            if(!String.isEmpty(selectedAttendeeHidden))
            {
                
                List<String> tempPList = new List<String>(selectedAttendeeHidden.split(','));
                for(String s : tempPList)
                {
                    wSearchKey.sAttendeeIds.add(Id.Valueof(s));
                }
                
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Get the objects which needs to be searched for the invitees
    public List<Selectoption> getInviteeSearchObjects(){
        return MFS_EventInviteeUtility.getInviteeSearchObjects();
        
    }
    
    //get left side Invitees. This is used in Select Attendees popup - SLDS multiselect picklist
    public String getLeftSideInvitees(){
        String jSONString = MFS_EventInviteeUtility.getLeftSideInvitees(wSearchKey.wAttendees.lstLeftOption);
        return jSONString;
    }
    
    //get Selected Invitees. This is used in Select Attendees popup - SLDS multiselect picklist
    public String getRightSideInvitees()
    {
        String jSONString = MFS_EventInviteeUtility.getRightSideInvitees(wSearchKey.wAttendees.lstRightOption);
        return jSONString;
    }
    //Called on click of search button. Searches the invitee based upon the search text
    public void searchInvitee(){
        //try{
        if(!String.isEmpty(selectedAttendeeHidden)){
            List<String> tempLst = new List<String>(selectedAttendeeHidden.split(','));
            Set<String> tempSet = new Set<String>(tempLst);
            
            for(String s : tempLst)
            {
                if(!wSearchKey.wAttendees.mRightSelected.containsKey(Id.ValueOf(s))){
                    wSearchKey.wAttendees.mRightSelected.put(s,wSearchKey.wAttendees.mLeftSelected.get(s) );
                }
            }
            wSearchKey.wAttendees.lstRightOption.clear();
            for(String s : tempLst)
            {
                if(!String.isBlank(s) && wSearchKey.wAttendees.mRightSelected.containskey(s)){
                    if(!String.isBlank(wSearchKey.wAttendees.mRightSelected.get(s)))
                        wSearchKey.wAttendees.lstRightOption.add(new SelectOption(s, wSearchKey.wAttendees.mRightSelected.get(s)));
                }
            }
            for(String s : wSearchKey.wAttendees.mRightSelected.keySet())
            {
                if(!tempSet.contains(s))
                    wSearchKey.wAttendees.mRightSelected.remove(s);
            }
        }
        Event parentEvent = new Event();
        System.debug('lstRightOption...'+wSearchKey.wAttendees.lstRightOption);
        MFS_EventInviteeUtility.searchInvitee(parentEvent, wSearchKey.wAttendees.SearchText,  wSearchKey.wAttendees.SearchTextOrg, wSearchKey.wAttendees.SearchTextCity, wSearchKey.wAttendees.SearchTextCountry, SearchObjects, wSearchKey.wAttendees.leftOptionList,wSearchKey.wAttendees.mLeftSelected,  wSearchKey.wAttendees.lstLeftOption,wSearchKey.wAttendees.mRightSelected  );
        getRightSideInvitees();
        getLeftSideInvitees();
    }
    
    public pageReference reset(){
        wSearchKey.wAttendees.searchText = '';
        wSearchKey.wAttendees.searchTextOrg='';
        wSearchKey.wAttendees.searchTextCity='';
        wSearchKey.wAttendees.searchTextCountry='';
        try{
            if(!String.isEmpty(selectedAttendeeHidden)){
                List<String> tempLst = new List<String>(selectedAttendeeHidden.split(','));
                Set<String> tempSet = new Set<String>(tempLst);
                
                for(String s : tempLst)
                {
                    if(! wSearchKey.wAttendees.mRightSelected.containsKey((Id)s)){
                        wSearchKey.wAttendees.mRightSelected.put(s, wSearchKey.wAttendees.mLeftSelected.get(s) );
                    }
                }
                wSearchKey.wAttendees.lstRightOption.clear();
                for(String s : tempLst)
                {
                    wSearchKey.wAttendees.lstRightOption.add(new SelectOption(s,  wSearchKey.wAttendees.mRightSelected.get(s)));
                }
                for(String s :  wSearchKey.wAttendees.mRightSelected.keySet())
                {
                    if(!tempSet.contains(s))
                        wSearchKey.wAttendees.mRightSelected.remove(s);
                }
            }
            wSearchKey.wAttendees.lstLeftOption.clear();
            wSearchKey.wAttendees.mLeftSelected.clear();
            
            getRightSideInvitees();
            getLeftSideInvitees();
        }catch(Exception e){
            
        }
        return NULL;
    }
    
    //This method returns TRUE if the attendees of an activity matches with the filter selection
    public Boolean checkIfSelectedAttendeeMatching(Set<Id> setSelectedAttendee, Activity_Detail__c oActivityDetail ){
        //If no attendee selection is made, display the item by default
        if( setSelectedAttendee == NULL || setSelectedAttendee.isEmpty()){
            return TRUE;
        }else if(oActivityDetail == NULL || oActivityDetail.Invitees__r.isEmpty())
        {
            return FALSE;
        }else{
            for(Event_Relation__c er: oActivityDetail.Invitees__r){
                if(setSelectedAttendee.contains(er.RelationId__c)){
                    return TRUE;
                }
            }
        }
        return FALSE;
    }
    
    
    //This method returns TRUE if the related products of an activity matches with the filter selection
    public Boolean checkIfSelectedProductMatching(Set<Id> setSelectedProduct, Activity_Detail__c oActivityDetail ){
        //If no Product selection is made, display the item by default
        if( setSelectedProduct == NULL || setSelectedProduct.isEmpty()){
            return TRUE;
        }else if(oActivityDetail == NULL || oActivityDetail.Products__r.isEmpty())
        {
            return FALSE;
        }else{
            for(Call_Note_Product__c er: oActivityDetail.Products__r){
                if(setSelectedProduct.contains(er.Product__c)){
                    return TRUE;
                }
            }
        }
        return FALSE;
    }
}