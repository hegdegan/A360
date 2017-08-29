/*
* TestDataUtility
* Class with methods for creating test data
* 
*/

public class MFS_TestDataUtility {

	static Integer s_num = 1;    
    
    //Create single user record
    public static User createUser(String profileName){
        Profile prf = [select id from Profile where name = :profileName];
        User usr = new User(UserName = 'unique_test@mfstest.com', Lastname = 'Last', FirstName = 'First', Email = 'test@mfs.com', ProfileId = prf.id, Alias = 'test', 
                            TimeZoneSidKey = 'GMT', LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8', LocaleSidKey = 'en_US' );
        return usr;
    }
    
    
    
    //Create single Account record
    public static Account createAccount(){
        Account acc = new Account(Name = 'TestAccount', BillingStreet = 'testStreet', BillingState = '', BillingCity = 'testcity', BillingPostalCode = '0000', BillingCountry = 'India', 
                                  ShippingStreet = 'testStreet', ShippingState = '', ShippingCity = 'tstcity', ShippingPostalCode = '1111', ShippingCountry = 'India',Type__c='Special Dealer');
        return acc; 
    }
    //Create single strategy Plan record
    public static Strategy_Plan__c createStrategyPlan(Id acctId)
    {
        Strategy_Plan__c sp = new Strategy_Plan__c(Name='TestStrategy', Organization__c = acctid, Strategy_Plan_Year__c = '2016');
        return sp;
    }
    
    //Create single distribution list record
    public static Distribution_List__c createDistributionList(Id acctId)
    {
        Distribution_List__c dlc = new Distribution_List__c(Name='TestDistributionList', Organization__c = acctid, Type__c = 'Email List', Email_Address__c = 'TestDist@test.com', Status__c = 'Active');
        return dlc;
    }
    
    //Create single Plan record
    public static Plan__c createPlan(Id acctId)
    {
        Plan__c pl = new Plan__c(Name='TestPlan', Organization__c = acctid);
        return pl;
    }
    
    //Create Client Investment records
    public static List<Account__c> createBulkClientInvestment(Id acctId, Id planId, List<Product2> prodList)
    {
        List<Account__c> ac = new List<Account__c>();
        for(Product2 pt: prodList)
        { 
            ac.add(new Account__c(plan__c = planId, portfolio__c = pt.Id, organization__c= acctId));  
        }
        return ac;  
    }
    
    //create Opportunity record
    public static Opportunity createOpportunity(Id acctId)
    {
        Opportunity op = new Opportunity(Name='TestOpportunity', StageName ='Needs Analysis', CloseDate=Date.newInstance(2016,08,20), AccountId = acctid, Amount__c=55000000000.00);
        return op;
    }
    
    //create opportunityLineItem record 
    public static Event_Request__c createEventRequest(Id userId)
    {
        Event_Request__c evReq = new Event_Request__c(Requester__c=userId,Event_Title__c='Test Event',TimeZone__c='(UTC-06:00) Central time (US & Canada)',Start_Date__c=DateTime.newInstance(2016,09,27,08,00,00),End_Date__c=DateTime.newInstance(2016,04,20,08,00,00),Event_Types__c='Internal Meeting',City__c='Test City',Country__c='United States');
        return evReq;
    }
    public static OpportunityLineItem createOpportunityLineItem(Opportunity oppRec,Id pbId)
    {
        OpportunityLineItem opli = new OpportunityLineItem(OpportunityId=oppRec.id,
                                                           PriceBookEntryId=pbId,UnitPrice=2000,
                                                           Quantity=1,Fee_Structure__c='Custom',
                                                           Product_Name__c='test');
        return opli;
    }
    //create Account records in bulk
    public static List<Account> createBulkAccounts(Integer numAccount)
    {
        List<Account> acct = new List<Account>();
        for(Integer i=0; i<numAccount; i++){
            Account a = new Account(Name='TestAccount' + i, BillingStreet = 'testStreet', BillingCity = 'testcity', BillingPostalCode = '0000', BillingCountry = 'India',
                                    ShippingStreet = 'testStreet', ShippingState = '', ShippingCity = 'tstcity', ShippingPostalCode = '1111', ShippingCountry = 'India',Type__c='Special Dealer');
            acct.add(a);
        }
        return acct;
    }
    //Create Opportunity records in bulk
    public static List<Opportunity> createBulkOpportunities(Id acctid, Integer numOppties, Id recordType)
    {
        List<Opportunity> opptyLst = new List<Opportunity>();
        for(Integer i=0; i<numOppties; i++)
        {
            opptyLst.add(new Opportunity(RecordtypeId = recordType, Name='TestOpportunity', StageName ='Needs Analysis', CloseDate=Date.newInstance(2016,08,20), AccountId = acctid, Amount__c=55000000000.00));
        }
        return opptyLst;
    }
    //create contact records in bulk
    public static List<Contact> createBulkContacts(List<Account> recAcc, Integer numContacts)
    {
        List<Contact> conRec = new List<Contact>();
        for(Integer j=0; j<recAcc.size(); j++)
        {
            Account acct = recAcc[j];
            for(Integer k=numContacts*j; k<numContacts*(j+1); k++)
            {
                conRec.add(new Contact(FirstName = 'ConFirst' + k ,LastName = 'Con' + k, Email = 'con1' + k + '@gmail.com', AccountId = acct.ID,Phone = '9999999999',
                                       MailingCity = 'Boston', MailingStreet = 'New Street', MailingState = '', MailingCountry = '', MailingPostalCode = '123456'));
            }
        }
        return conRec;
    }
    //create relationship records in bulk
    public static List<Relationship__c> createBulkRelationships(List<Account> recAcc, Integer numRelation)
    {
        List<Relationship__c> relRec = new List<Relationship__c>();
        for(Integer j=0; j<recAcc.size(); j++)
        {
            Account acct = recAcc[j];
            for(Integer k=numRelation*j; k<numRelation*(j+1); k++)
            {
                relRec.add(new Relationship__c(Organization__c = acct.ID));
            }
        }
        return relRec;
    }
    //create event records in bulk
    public static List<Event> createBulkEvents(List<Account> recAcc, Integer numEvent)
    {
        List<Event> relEvnt = new List<Event>();
        for(Integer j=0; j<recAcc.size(); j++)
        {
            Account acct = recAcc[j];
            for(Integer k=numEvent*j; k<numEvent*(j+1); k++)
            {
                relEvnt.add(new Event(Subject = 'Meeting', StartDateTime = DateTime.newInstance(2016,04,20,08,00,00), EndDateTime = DateTime.newInstance(2016,04,22,08,00,00), WhatId = acct.ID) );
                relEvnt.add(new Event(Subject = 'Meeting' + k, StartDateTime = DateTime.newInstance(2016,04,18,08,00,00), EndDateTime = DateTime.newInstance(2016,04,19,08,00,00), WhatId = acct.ID) );
            }
        }
        return relEvnt;
    }
    //create strategy Plan records in bulk
    public static List<Strategy_Plan__c> createBulkSplan(List<Account> recAcc, Integer numSplan)
    {
        List<Strategy_Plan__c> relSpln = new List<Strategy_Plan__c>();
        for(Integer j=0; j<recAcc.size(); j++)
        {
            Account acct = recAcc[j];
            for(Integer k=0; k<numSplan; k++)
            {
                relSpln.add(new Strategy_Plan__c(Name='TestStrategy' + k, Organization__c=acct.ID));            }
        }
        return relSpln;
    }
    //create goal records in bulk
    public static List<Goal__c> createBulkGoal(Integer numGoal)
    {
        List<Goal__c> relGoal = new List<Goal__c>();
        for(Integer j=0; j<numGoal; j++)
        {  
            relGoal.add(new Goal__c(Name='TestGoal' + j)); 
        }
        return relGoal;
    }
    //create custom settings record
    public static Application_Settings__c CreateTestAppSetting(String Key, String value){
        Application_Settings__c appSetting = new Application_Settings__c();
        appSetting.Name = Key;
        appSetting.Value__c = value;
        return appSetting;
    }
    
    
    
    //create custom setting record
    public static GEO_EndPoint_URL__c createGeoURL(String Key, String value){
        GEO_EndPoint_URL__c url = new GEO_EndPoint_URL__c();
        url.Name = key;
        url.End_Point_URL__c = value;
        return url;
    }
    //create custom setting records
    public static List<Application_Settings__c> CreateTestApplicationSettings(String IntegrationUserId, 
                                                                              String AccountAccessLevel, String OpportunityAccessLevel, String CaseAccessLevel){
                                                                                  
                                                                                  List<Application_Settings__c> appSetting = new List<Application_Settings__c>();
                                                                                  Application_Settings__c app = CreateTestAppSetting('IntegrationUserId', IntegrationUserId); 
                                                                                  appSetting.add(app);                     
                                                                                  app = CreateTestAppSetting('AccountAccessLevel', AccountAccessLevel); 
                                                                                  appSetting.add(app);
                                                                                  app = CreateTestAppSetting('OpportunityAccessLevel', OpportunityAccessLevel); 
                                                                                  appSetting.add(app);
                                                                                  app = CreateTestAppSetting('CaseAccessLevel', CaseAccessLevel); 
                                                                                  appSetting.add(app);                    
                                                                                  return appSetting;                    
                                                                              }
    //create contact record
    public static Contact createContact(Id accountId)
    {
        RecordType rt=[select id, name from RecordType where SObjectType='Contact' AND Name = 'Consultant' LIMIT 1];
        Contact cont = new Contact (FirstName = 'ConFirst', RecordtypeId = rt.id , LastName = 'Test' , AccountId = accountId, Email = 'test@mfs.com', Phone = '9999999999',
                                    MailingCity = 'Hartford', MailingStreet = '151 Farmington Avenue', MailingState = '', MailingCountryCode = 'US', MailingPostalCode = '123456');
        return cont;
        
    }
    //create plan association record
    public static Plan_Association__c createPlanAsscn(Id contactId)
    {
        Plan_Association__c planAsscn = new Plan_Association__c(Contact_Role__c='Accounting',Contact__c = contactId, CRT__c = true, Contact_Relationship_Start_Date__c = System.TODAY(), Role__c = 'Investment Consultant');
        return planAsscn;
    }
    
    public static Plan_Association__c createPlanAsscnwithDistList(Id acctId, Id DistListId)
    {
        Plan_Association__c planAsscn = new Plan_Association__c(Organization1__c = acctId, Distribution_List__c = DistListId, CRT__c = true, Contact_Relationship_Start_Date__c = System.TODAY(), Role__c = 'Investment Consultant');
        return planAsscn;
    }
    
    //create plan association record with plan
    public static Plan_Association__c createPlanAsscnwithPlan(Id contactId, Id planId)
    {   Plan_Association__c planAsscn = new Plan_Association__c(Contact_Role__c='Accounting',Contact__c = contactId, Plan__c = planId, CRT__c = true, Contact_Relationship_Start_Date__c = System.TODAY(), Role__c = 'Investment Consultant');   
     return planAsscn;
    }
    //create event with contact record
    public static Event createEventWithContact(Id contactId)
    {
        Event relEvnt = new Event(Subject = 'Meeting', StartDateTime = DateTime.newInstance(2016,04,20,08,00,00), EndDateTime = DateTime.newInstance(2016,04,20,08,00,00), WhoId = contactId, Type = 'Client Review Meetings');
        return relEvnt;
    }
    //create task record
    public static Task createTask(Id accountId)
    {
        Task relTask = new Task(Subject = 'MEETING FOR TEST CLASS COVERAGE', WhatId = accountId, Priority = 'Normal',Status = 'Open');
        return relTask;
    }
    //create Product record
    public static Product2 createProduct()
    {
        String recordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Strategy').getRecordtypeId();
        Product2 prodRec=new Product2(Name='testProduct',IsActive=true,Family='Intl Equity',Style__c='Growth',Asset_Class_Geography__c='Emerging Markets (diversified) Equity',
                                      Vehicle__c='Domestic Mutual Fund',Restricted__c=false,Asset_Class__c='Equity',Geography__c='US',RecordTypeId=recordTypeId,Is_Valid_Product__c=true);         
        return prodRec;
    }
    //create product in bulks
    public static List<Product2> createBulkProduct()
    {
        String recordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Strategy').getRecordtypeId();
        List<Product2> prodList=new List<Product2>();
        for(integer i=0;i<10;i++)
        {
            Product2 prodRec=new Product2(Name='testProduct'+i,IsActive=true,Family='Intl Equity',Style__c='Non-US Dev',Asset_Class_Geography__c='Emerging Markets (diversified) Equity',
                                          Vehicle__c='Domestic Mutual Fund',Restricted__c=true,Asset_Class__c='Equity',Geography__c='US',RecordTypeId=recordTypeId,Is_Valid_Product__c=true);  
            prodList.add(prodRec);
        }
        return prodList;
    }
    
    //create portfolio product in bulks
    public static List<Product2> createBulkPortfolioProduct()
    {
        String recordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Portfolio').getRecordtypeId();
        List<Product2> prodList=new List<Product2>();
        for(integer i=0;i<3;i++)
        {
            Product2 prodRec=new Product2(Name='testPortfolio'+i,IsActive=true,Family='Intl Equity',Style__c='Non-US Dev',
                                          Vehicle__c='Domestic Mutual Fund',Restricted__c=true,Asset_Class__c='Equity',Geography__c='US',RecordTypeId=recordTypeId,Is_Valid_Product__c=true);  
            prodList.add(prodRec);
        }
        return prodList;
    }
    
    //create PriceBookEntry record
    public static PricebookEntry createPriceBEntry(Product2 prdRec)
    {
        
        PricebookEntry pbRec=new PricebookEntry(Product2Id=prdRec.id,Pricebook2Id=Test.getStandardPricebookId(),UnitPrice=0,isActive=True);  
        return pbRec;
    }
    //create PriceBookEntry records in bulk
    public static List<PricebookEntry> createBulkPriceBEntry(Product2 prdRec,Integer prBookEntryNum)
    {
        List<PricebookEntry> pbEntry = new List<PricebookEntry>();
        for(Integer k=0;k<prBookEntryNum;k++)
        {
            pbEntry.add(new PricebookEntry(Product2Id=prdRec.id,Pricebook2Id=Test.getStandardPricebookId(),UnitPrice=0 + k,isActive=True));  
        }
        return pbEntry;
    }
    //create FeedItem record
    public static List<FeedItem> createFeedItem(Id accountId,Integer numFeed)
    {
        List<FeedItem> fItem = new List<FeedItem>();
        for(Integer k=0;k<numFeed;k++)
            fItem.add(new FeedItem(Body = 'HelloTest' + k,ParentId = accountId));
        return fItem;
    }
    //create FeedComment record
    public static List<FeedComment> createFeedComment(Id FeedItmId,Integer numComment)
    {
        List<FeedComment> fComment = new List<FeedComment>();
        for(Integer k=0;k<numComment;k++)
            fComment.add(new FeedComment(CommentBody = 'HelloComment'+k, FeedItemId = FeedItmId));
        return fComment;
    }
    //Create OpportunityLineItem
    public static OpportunityLineItem createOpportunityLineItem(Id oppId, Id pbEntryId)
    {
        OpportunityLineItem oppLinItem = new OpportunityLineItem(OpportunityId = oppId, PriceBookEntryId = pbEntryId, UnitPrice=1.00, Quantity = 1, Approval_Status__c='Pending' );
        return oppLinItem;
    }
    //Create Fee Approval request
    public static Approval_Request__c createFeeApprovalRequest(Id oppId, Id prodId, Id usrId)
    {
        Approval_Request__c far = new Approval_Request__c(Opportunity__c = oppId, Opportuinty_ProductId__c = prodId, Approval_Status__c = 'Pending',
                                                          Last_Approver_Id__c=usrId);
        return far;
    }
    //Create Case record
    public static Case createCase(Contact conRec)
    {
        String recordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordtypeId();
        Case cs = new Case(ContactID = conRec.Id, Origin = 'Phone', Type = 'Amendment',recordTypeId=recordTypeId);
        return cs;
    }
    //Create bulk Case records
    public static List<Case> createBulkCase(Contact conRec,Integer numOfCases,String repeats)
    {
        List<Case> cas = new List<Case>();
        for(Integer k=0;k<numOfCases;k++)
        {
            cas.add(new Case(ContactID = conRec.Id, Origin = 'Phone', Type = 'Amendment', Repeats__c = repeats, Start_Date__c = System.Today(),Repeats_On__c = System.Today())); 
        }
        
        return cas;
    }
    
    //Create Call Notes i.e Activity Details
    public static Activity_Detail__c createCallNote(Id orgID)
    {
        Activity_Detail__c cNote = new Activity_Detail__c(Subject__c='CallTest',Organization__c=orgID);
        return cNote;
    }
    
    //Create Competitor Product
    public static Competitor_Product__c createComptrProduct()
    {
        Competitor_Product__c comProd = new Competitor_Product__c(Name='AllianzGI NFJ Mid Cap Value 100'); 
        return comProd;
    }
    //Create platforms for accounts
    public static Platform__c createPlatform(Id acctId)
    {
        Platform__c pltform = new Platform__C(Name = 'TestPlatform', Organization__c = acctId);
        return pltform;
    }
    //Create Client_Investment_Objective__c
    public static Client_Investment_Objective__c createClientInverstment(Id acctId)
    {
        Client_Investment_Objective__c clientObj = new Client_Investment_Objective__c(Name = 'TestClientObj', Organization__c = acctId,Plan__c='DB Plan',Plan_Identification__c='US DB Plan',
                                                                                      Investment_Objective__c='Income',Investment_Objective_Detail__c='test');
        return clientObj;
    }
    //Create custom setting data
    public static FieldsUsedInButton__c createFieldForButton(String objName,String feldName,String fieldLabel,String fieldType)
    {
        FieldsUsedInButton__c objField=new FieldsUsedInButton__c(Object_Name__c=objName,Field_Name__c=feldName,Field_Label__c=fieldLabel,Field_Type__c=fieldType, Name=String.valueOf(Math.random()*10));
        return objField;         
    }
    
    //Create Consultant Rating
    public static Consultant_Rating__c createConsRating(Id accId,id prdId)
    {
        Consultant_Rating__c consRatin=new Consultant_Rating__c(Name='Test',Consultant__c=accId,Product__c=prdId);
        return consRatin;
    }
    
    //Custom Settign Data
    public static StoreFieldIds__c createFieldIDData(String objName,String fieldLabel,String fieldAPI)
    {
        StoreFieldIds__c fieldId=new StoreFieldIds__c(Name=String.valueOf((objName+'.'+fieldLabel).hashCode()),Object_Name__c=objName,Field_Label__c=fieldLabel,Field_API_Name__c=fieldAPI,Field_Id__c=String.valueOf((objName+'.'+fieldLabel).hashCode()));
        return fieldId;
    }
    
    //Create PMAPS
    public static PMAPS__c createPMAPS(Id oppid,Id userId)
    {
        PMAPS__c pmapRec=new PMAPS__c(Sales_Person_Relationship_Manager__c=userId,Opportunity__c=oppid,Date_Received__c=System.today(),Date_Due__c=System.today()+7);
        return pmapRec;
    }
    
    public static List<PMAPS__c> createBulkPMAPS(Id oppid,Id userId)
    {
        List<PMAPS__c> pmapslist=new List<PMAPS__c>();
        for(Integer i=0;i<5;i++)        
        {
            pmapslist.add(new PMAPS__c(Sales_Person_Relationship_Manager__c=userId,Opportunity__c=oppid,Date_Received__c=System.today(),Date_Due__c=System.today()+i));
        }
        return pmapslist;
    }
    
    //Create Event Request
    public static Event_Request__c createEventReq(Id userId)
    {
        Event_Request__c eventReq=new Event_Request__c(Requester__c=userId,Event_Title__c='Test Event',TimeZone__c='(UTC-06:00) Central time (US & Canada)',Start_Date__c=System.now(),Event_Types__c='Other',City__c='Boston');
        return eventReq;
    }
    
    //Create Event Request
    public static List<Event_Request__c> createBulkEventReq(Id userId)
    {
        List<Event_Request__c> eventReqlist=new List<Event_Request__c>();
        for(integer i=0;i<5;i++)
        {
            eventReqlist.add(new Event_Request__c(Requester__c=userId,Event_Title__c='Test Event'+i,TimeZone__c='(UTC-06:00) Central time (US & Canada)',Start_Date__c=System.now(),Event_Types__c='Other',City__c='Boston'));
        }
        return eventReqlist;
    }
    
    //Create Campaign
    public static Campaign createCampaign()
    {
        
        Campaign campaignRec=new Campaign(Name='Test Campaign',Type='Reminder',StartDate=System.Today(),Campaign_Delivery__c='Email', Description__c ='Test Campaign');            
        return campaignRec;
    }
    
    
    //Create Campaign member
    public static CampaignMember createCampaignMember(Id campRec,Id contactRec)
    {
        CampaignMember campaigMem=new CampaignMember(CampaignId=campRec,ContactId=contactRec,Status='Sent');               
        return campaigMem;
    }
    
    //Create onBoarding Case
    /* public static Case createOnBoardingCase(Account accRec,User userRec)
{
String recordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Onboarding').getRecordtypeId();
Case cs = new Case(AccountId = accRec.Id, Origin = 'Phone', Type = 'Amendment',RecordTypeId=recordTypeId,
Due_Date__c=System.today()+7,Approval_Required_From__c='Compliance - Code of Ethics Group;GIS - Risk Group',
Portfolio_Management_Approver__c=userRec.Id,Client_Service_Approver__c=userRec.id,Corporate_Finance_Billing_Approver__c=userRec.id,
Compliance_AML_KYC_Approver__c=userRec.id,Legal_Approver__c=userRec.id);
return cs;
}*/
    
    //Create Business at Risk
    public static Business_At_Risk__c createBAR(Id accId)
    {
        Business_At_Risk__c br = new Business_At_Risk__c(Organization__c = accId, Relationship_at_Risk_Date__c = System.Today(), Percentage_at_Risk__c = 'Low', Expected_Loss_Date__c = System.Today()+1,
                                                         Reason_at_Risk__c = 'Regulatory', Status__c = 'Open');
        return br;
        
    }
    
    public static void setRetailSalesList(){
        
        for(Integer i=0; i<3; i++){
            Organization_Retail_Sales__x exObj = new Organization_Retail_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',
                                                                                  Level__c='Product', Source_Portfolio_ID__c = 'MFS Aggressive Growth Allocation Fund', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, Organization_MDM_ID__c='1234567',YTD_Sales_USD__c=10.00,
                                                                                  YTD_Redemptions_USD__c=10.00);
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        
        for(Integer i=0; i<10; i++){
            Organization_Retail_Sales__x exObj = new Organization_Retail_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',
                                                                                  Level__c='Share Class', Source_Portfolio_ID__c='MFS Aggressive Growth Allocation Fund', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, Organization_MDM_ID__c='1234567',YTD_Sales_USD__c=10.00,
                                                                                  YTD_Redemptions_USD__c=10.00,Share_Class_Code__c='I');
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        
        for(Integer i=0; i<=1; i++){
            Organization_Retail_Sales__x exObj = new Organization_Retail_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',
                                                                                  Level__c='Product Vehicle', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, Organization_MDM_ID__c='1234567',YTD_Sales_USD__c=10.00,
                                                                                  YTD_Redemptions_USD__c=10.00);
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        
        for(Integer i=0; i<=1; i++){
            Organization_Retail_Sales__x exObj = new Organization_Retail_Sales__x(Level__c='Total', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, Organization_MDM_ID__c='1234567',YTD_Sales_USD__c=10.00,
                                                                                  YTD_Redemptions_USD__c=10.00);
            MFS_Utilities.AssetsDataList.add(exObj);
        }
    }
    
    public static List<Organization_Institutional_Sales__c> getInstitutionalSalesList(){
        Account acc = MFS_TestDataUtility.createAccount();
        acc.MDM_ID__c = '123456';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Global Institutional Client').getRecordtypeId();
        insert acc;
        List<Organization_Institutional_Sales__c> oisLst = new List<Organization_Institutional_Sales__c>();
        for(Integer i=1 ; i<4; i++)
        {
            Organization_Institutional_Sales__c ois = new Organization_Institutional_Sales__c();
            ois.Organization__c = acc.id;
            ois.AUM_AUD__c = 20.00;
            ois.AUM_CAD__c = 10.00;
            ois.AUM_EUR__c = 5.00;
            ois.AUM_GBP__c = 5.00;
            ois.AUM_JPY__c = 5.00;
            ois.AUM_SGD__c = 5.00;
            ois.AUM_USD__c = 5.00;
            ois.Client_Reporting_Currency_Code__c = 'USD';
            ois.Plan_ID__c = 'PL-00'+i;
            ois.Plan_Name__c = 'Kaiser Plan'+i;
            ois.Organization_MDM_ID__c = '123456';
            ois.Level__c = 'Plan';
            oisLst.add(ois); 
            for(Integer j=1; j<3; j++)
            {
                Organization_Institutional_Sales__c oisPf = new Organization_Institutional_Sales__c();
                oisPf.Organization__c = acc.id;
                oisPf.AUM_AUD__c = 20.00;
                oisPf.AUM_CAD__c = 10.00;
                oisPf.AUM_EUR__c = 5.00;
                oisPf.AUM_GBP__c = 5.00;
                oisPf.AUM_JPY__c = 5.00;
                oisPf.AUM_SGD__c = 5.00;
                oisPf.AUM_USD__c = 5.00;
                oisPf.Client_Reporting_Currency_Code__c = 'USD';
                oisPf.Plan_ID__c = 'PL-00'+i;
                oisPf.Portfolio_ID__c = 'PF-00'+j;
                oisPf.Plan_Name__c = 'Kaiser Portfolio'+j;
                oisPf.Organization_MDM_ID__c = '123456';
                oisPf.Level__c = 'Portfolio';
                oisLst.add(oisPf);
            }
        }
        return oisLst;
    }
    
    public static AssetPageAndTableSettings__c getTableName(String name, String table){
        AssetPageAndTableSettings__c  astPGTable = new AssetPageAndTableSettings__c(name=name,TableName__c=table);
        return astPGTable;
    }
    
    public static List<AssetPageAndTableSettings__c> geAssetPageAndTableSettings(){
        List <AssetPageAndTableSettings__c>  assetPageAndTableSettingsList = new List <AssetPageAndTableSettings__c>();
        assetPageAndTableSettingsList.add(new AssetPageAndTableSettings__c(name='OrgRetail',TableName__c='Organization_Retail_Sales__x'));
        assetPageAndTableSettingsList.add(new AssetPageAndTableSettings__c(name='OrgInstitutional',TableName__c='Organization_Institutional_Sales__c'));
        assetPageAndTableSettingsList.add(new AssetPageAndTableSettings__c(name='OrgConsultant',TableName__c='Consultant_Sales__x'));
        assetPageAndTableSettingsList.add(new AssetPageAndTableSettings__c(name='Total',TableName__c='Total_Individual_Sales__x'));
        assetPageAndTableSettingsList.add(new AssetPageAndTableSettings__c(name='Individual',TableName__c='Individual_Sales__x'));
        assetPageAndTableSettingsList.add(new AssetPageAndTableSettings__c(name='Partnership',TableName__c='Partnership_Sales__x'));
        return assetPageAndTableSettingsList;
    }
    
    public static List<Currency_Symbol__c> getCurrSymbolList(){
        List<Currency_Symbol__c> listCurrSymbolList = new List<Currency_Symbol__c> ();
        Currency_Symbol__c  currSymbol = new Currency_Symbol__c(name='USD',Symbol__c='$');
        listCurrSymbolList.add(currSymbol);
        return listCurrSymbolList;
    }
    
    public static GDM_Table_Fields__c getGDMFieldsInstitutional(){
        GDM_Table_Fields__c gdmTableInst = new GDM_Table_Fields__c(name='OrgInstSales#USD', AUM__C='AUM:AUM_USD__c', LEVEL__C='Level:Level__c', 
                                                                   MDM_ID__C='MDM_ID:Organization_MDM_ID__c',PORTFOLIO_NAME__C='PortfolioName:Portfolio__r.name',PY__C='PY:Prior_Year_Sales_USD__c',
                                                                   PY_RED__C='PYRed:Prior_Year_Redemptions_USD__c',YTD__C='YTD:YTD_Sales_USD__c',YTD_NET__C='YTDNet:YTD_Net_USD__c',
                                                                   YTD_RED__C='YTDRed:YTD_Net_USD__c',PLANID__C='PlanId:Plan__r.Id',PLANNAME__C='PlanName:Plan__r.name',
                                                                   PORTFOLIOID__C='PortfolioId:Portfolio__c');
        return gdmTableInst;
    }
    public static GDM_Table_Fields__c getGDMFieldsRetail(){
        
        GDM_Table_Fields__c gdmTableRetail = new GDM_Table_Fields__c (name='Organization_Retail_Sales__x#USD',AUM__C='AUM:AUM_USD__c',LEVEL__C='Level:Level__c',
                                                                      MDM_ID__C='MDM_ID:Organization_MDM_ID__c',PRODUCT__C='ProductName:Source_Portfolio_ID__r.name',
                                                                      PRODUCT_VEHICLE__C='ProductVehicle:Product_Vehicle__c',PRODUCT_ID__C='ProductId:Source_Portfolio_ID__r.Id',
                                                                      PY__C='PY:Prior_Year_Sales_USD__c',PY_RED__C='PYRed:Prior_Year_Redemptions_USD__c',YTD__C='YTD:YTD_Sales_USD__c',
                                                                      YTD_RED__C='YTDRed:YTD_Redemptions_USD__c',PORTFOLIOID__C='PortfolioId:Source_Portfolio_ID__c',SHARECLASS__C='ShareClass:Share_Class_Code__c');
        return gdmTableRetail;
    }
    
    public static GDM_Table_Fields__c getGDMFieldsConsultant(){
        
        GDM_Table_Fields__c gdmTableConsultant= new GDM_Table_Fields__c (name='Consultant_Sales__x#USD',AUM__C='AUM:AUM_USD__c',LEVEL__C='Level:Level__c',
                                                                         MDM_ID__C='MDM_ID:Consultant_MDM_ID__c',PRODUCT__C='ProductName:Source_Portfolio_ID__r.name',
                                                                         PRODUCT_VEHICLE__C='ProductVehicle:Product_Vehicle__c',PRODUCT_ID__C='ProductId:Source_Portfolio_ID__r.Id',
                                                                         PY__C='PY:Prior_Year_Sales_USD__c',PY_RED__C='PYRed:Prior_Year_Redemptions_USD__c',YTD__C='YTD:YTD_Sales_USD__c',
                                                                         YTD_RED__C='YTDRed:YTD_Redemptions_USD__c',PORTFOLIOID__C='PortfolioId:Source_Portfolio_ID__c',SHARECLASS__C='ShareClass:Share_Class_Code__c');
        return gdmTableConsultant;
    }
    
    public static GDM_Table_Fields__c getGDMFieldsTotalSales(){
        
        GDM_Table_Fields__c gdmTableTotalSales = new GDM_Table_Fields__c (name='Total_Individual_Sales__x#USD',AUM__C='AUM:AUM_USD__c',LEVEL__C='Level:Level__c',
                                                                          MDM_ID__C='MDM_ID:MDM_ID__c',PRODUCT__C='ProductName:Source_Product_ID__r.name',
                                                                          PRODUCT_VEHICLE__C='ProductVehicle:Product_Vehicle__c',PRODUCT_ID__C='ProductId:Source_Product_ID__r.Id',
                                                                          PY__C='PY:Prior_Year_Sales_USD__c',PY_RED__C='PYRed:Prior_Year_Redemptions_USD__c',YTD__C='YTD:YTD_Sales_USD__c',
                                                                          YTD_RED__C='YTDRed:YTD_Redemptions_USD__c',SHARECLASS__C='ShareClass:ShareClassCode__c',PORTFOLIOID__C='PortfolioId:Source_Product_ID__c');
        return gdmTableTotalSales;
    }
    
    public static void setConsultantSalesList(){
        
        
        for(Integer i=0; i<3; i++){
            Consultant_Sales__x exObj = new Consultant_Sales__x(Product_Vehicle_Code__c='ACC',
                                                                Level__c='Product', Source_Portfolio_ID__c = 'ACC', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, Organization_MDM_ID__c='123456',YTD_Sales_USD__c=10.00,
                                                                YTD_Redemptions_USD__c=10.00,Consultant_Salesforce_ID__c='1234567');
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        
        for(Integer i=0; i<10; i++){
            Consultant_Sales__x exObj = new Consultant_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',Product_Vehicle_Code__c='ACC',
                                                                Level__c='Organization', Source_Portfolio_ID__c='ACC', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, Organization_MDM_ID__c='123456',YTD_Sales_USD__c=10.00,
                                                                YTD_Redemptions_USD__c=10.00,Share_Class_Code__c='I',Consultant_Salesforce_ID__c='1234567');
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        
        for(Integer i=0; i<=1; i++){ 
            Consultant_Sales__x exObj = new Consultant_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',Product_Vehicle_Code__c='ACC',Source_Portfolio_ID__c = 'ACC',
                                                                Level__c='Product Vehicle', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, Organization_MDM_ID__c='123456',YTD_Sales_USD__c=10.00,
                                                                YTD_Redemptions_USD__c=10.00,Consultant_Salesforce_ID__c='1234567');
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        
        for(Integer i=0; i<=1; i++){
            Consultant_Sales__x exObj = new Consultant_Sales__x(Level__c='Total', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, Organization_MDM_ID__c='123456',YTD_Sales_USD__c=10.00,
                                                                YTD_Redemptions_USD__c=10.00,Consultant_Salesforce_ID__c='1234567');
            MFS_Utilities.AssetsDataList.add(exObj);
        }
    }
    
    public static void setTotalSalesList(){
        for(Integer i=0; i<3; i++){
            Total_Individual_Sales__x exObj = new Total_Individual_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',
                                                                            Level__c='Product', Source_Product_ID__c = 'MFS Aggressive Growth Allocation Fund', AUM_USD__c=10.00, 
                                                                            Prior_Year_Sales_USD__c=10.00, MDM_ID__c='MDM3456',YTD_Sales_USD__c=10.00,
                                                                            YTD_Redemptions_USD__c=10.00);
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        for(Integer i=0; i<10; i++){
            Total_Individual_Sales__x exObj = new Total_Individual_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',
                                                                            Level__c='Share Class', Source_Product_ID__c='MFS Aggressive Growth Allocation Fund', AUM_USD__c=10.00, 
                                                                            Prior_Year_Sales_USD__c=10.00, MDM_ID__c='MDM3456',YTD_Sales_USD__c=10.00,
                                                                            YTD_Redemptions_USD__c=10.00,ShareClassCode__c='I');
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        for(Integer i=0; i<=1; i++){
            Total_Individual_Sales__x exObj = new Total_Individual_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',
                                                                            Level__c='Product Vehicle', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, MDM_ID__c='MDM3456',YTD_Sales_USD__c=10.00,
                                                                            YTD_Redemptions_USD__c=10.00);
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        for(Integer i=0; i<=1; i++){
            Total_Individual_Sales__x exObj = new Total_Individual_Sales__x(Level__c='Total', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, MDM_ID__c='MDM3456',
                                                                            YTD_Sales_USD__c=10.00,  YTD_Redemptions_USD__c=10.00);
            MFS_Utilities.AssetsDataList.add(exObj);
        }
    }
    
    public static List<MFS_SalesAssetsWrapper> getSalesAndWrapperList(){
        List <MFS_SalesAssetsWrapper> saWrapList= new List<MFS_SalesAssetsWrapper>();
        MFS_SalesAssetsWrapper saArap;
        for(integer i = 0 ; i < 5 ; i ++){
            saArap = new MFS_SalesAssetsWrapper();
            saArap.MDM_ID = '123456'+i;
            saArap.Level = 'Product';
            saArap.ProductFamily = 'Hospita MF'+i;
            saArap.ProductName = 'Equity'+i;
            saArap.ShareClass = 'A'+i;
            saArap.YTD = 1234+i;
            saArap.YTDRed = 2345+i;
            saArap.YTDNet = 2345+i;
            saArap.PY = 34567+i;
            saArap.PYRed = 45678+i;
            saArap.AUM = 45678+i;
            saArap.ExternalId = '1234567'+i;
            saArap.ProductId = 'ARG'+i;
            saArap.ShareClassId = '123'+i;
            saArap.PlanName = 'MFS MF'+i;
            saArap.PortfolioName = 'ARG'+i;
            saArap.PlanId = 'AE3'+i;
            saArap.PortfolioId = 'AFR'+i;
            saArap.StrategyId = 'AQW'+i;
            saArap.StrategyName = 'Japan Retail Equity'+i;
            saArap.VehicleId = 'EDR'+i;
            saArap.VehicleName = 'GTH'+i;
            saArap.OrgId = '123458'+i;
            saArap.OrgName  = 'Aon Hewitt'+i;
            saArap.ProductVehicle = 'HTG'+i;
            saArap.ProductVehicleId = 'GTR'+i;
            saArap.ClientCurr = 'USD'+i;
            saWrapList.add(saArap);
        }
        return saWrapList;
    }
    
    public static List<MFS_SalesAssetsWrapper> getSalesAndWrapperListPerObjectType(String obj){
        List <MFS_SalesAssetsWrapper> saWrapList= new List<MFS_SalesAssetsWrapper>();
        MFS_SalesAssetsWrapper sw1;
        if(obj.equals(MFS_AllConstants.OrgInsSalesPage)){
            sw1 = new MFS_SalesAssetsWrapper();
            sw1.planName = 'AE3';
            sw1.portfolioName = '';
            saWrapList.add(sw1);
            for(integer i = 0 ; i < 3 ; i ++){
                sw1 = new MFS_SalesAssetsWrapper();
                sw1.planName = 'AE3';
                sw1.portfolioName = 'ARG'+i;
                saWrapList.add(sw1);
            }
        }else if (obj.equals(MFS_AllConstants.OrgConSalesPage)){
            sw1 = new MFS_SalesAssetsWrapper();
            sw1.strategyName = 'AE3';
            sw1.vehicleName = '';
            sw1.orgName = '';
            saWrapList.add(sw1);
            for(integer i = 0 ; i < 3 ; i ++){
                sw1 = new MFS_SalesAssetsWrapper();
                sw1.strategyName = 'AE3';
                sw1.vehicleName = 'ARG'+i;
                sw1.orgName = '';
                saWrapList.add(sw1);
                for(integer j = 0 ; j < 3 ; j ++){
                    sw1 = new MFS_SalesAssetsWrapper();
                    sw1.strategyName = 'AE3';
                    sw1.vehicleName = 'ARG'+i;
                    sw1.orgName = 'Aon Hewitt'+j;
                    saWrapList.add(sw1); 
                }
            }
        }else if(obj.equals('Exception')){
            sw1 = new MFS_SalesAssetsWrapper();
            sw1.productVehicle = 'AE3';
            saWrapList.add(sw1);
            for(integer i = 0 ; i < 3 ; i ++){
                sw1 = new MFS_SalesAssetsWrapper();
                sw1.productVehicle = 'AE3';
                saWrapList.add(sw1);
            }
        }else {
            sw1 = new MFS_SalesAssetsWrapper();
            sw1.productVehicle = 'AE3';
            sw1.productName = '';
            sw1.shareClass = '';
            saWrapList.add(sw1);
            for(integer i = 0 ; i < 3 ; i ++){
                sw1 = new MFS_SalesAssetsWrapper();
                sw1.productVehicle = 'AE3';
                sw1.productName = 'ARG'+i;
                sw1.shareClass = '';
                saWrapList.add(sw1);
                for(integer j = 0 ; j < 3 ; j ++){
                    sw1 = new MFS_SalesAssetsWrapper();
                    sw1.productVehicle = 'AE3';
                    sw1.productName = 'ARG'+i;
                    sw1.shareClass = 'A'+j;
                    saWrapList.add(sw1); 
                }
            }
        }
        return saWrapList;
    }
    //create AccountTeamMember in bulk
    public static List<AccountTeamMember> createBulkATM(List<Account> recAcc, Integer numATM, Id userId)
    {
        List<AccountTeamMember> ATM = new List<AccountTeamMember>();
        for(Integer j=0; j<recAcc.size(); j++)
        {
            Account acct = recAcc[j];
            for(Integer k=numATM*j; k<numATM*(j+1); k++)
            {
                ATM.add(new AccountTeamMember(userId = userId, accountId = acct.id));
            }
        }
        return ATM;
    }
    
    //create Contact Coverage Team in bulk
    public static List<Coverage_Team__c> createBulkCCT(List<Contact> recCont, Integer numATM, Id userId)
    {
        List<Coverage_Team__c> CCT = new List<Coverage_Team__c>();
        for(Integer j=0; j<recCont.size(); j++)
        {
            Contact acct = recCont[j];
            for(Integer k=numATM*j; k<numATM*(j+1); k++)
            {
                CCT.add(new Coverage_Team__c(Coverage_Owner__c = userId, Contact__c = acct.id, Zone__c = 'Z000'));
            }
        }
        return CCT;
    }
    
    public static List<OpportunityTeamMember> createOppTeam(Id oppId,List<Id> usersId)
    {
        List<OpportunityTeamMember> oppTeamMList = new List<OpportunityTeamMember>();
        for(Id memId:usersId)
        {
            OpportunityTeamMember oppTeamM=new OpportunityTeamMember();
            oppTeamM.OpportunityId=oppId;
            oppTeamM.TeamMemberRole='Account Manager';
            oppTeamM.UserId=memId;
            oppTeamM.OpportunityAccessLevel='Read';
            oppTeamMList.add(oppTeamM);
        }
        return oppTeamMList;
    }
    
    public static List<Application_Settings__c> getappSettingsList(){
        List <Application_Settings__c> appSeetingList = new List<Application_Settings__c>();
        appSeetingList.add(new Application_Settings__c (name='Analyst Meeting',Value__c='Analyst_Meeting_Goal_Counter__c'));
        appSeetingList.add(new Application_Settings__c (name='Client Engagement Meeting',Value__c='Client_Engagement_Counter__c'));
        appSeetingList.add(new Application_Settings__c (name='Client Review Meetings',Value__c='Client_Review_Meeting_Goal_Counter__c'));
        appSeetingList.add(new Application_Settings__c (name='Consultant Meeting',Value__c='Consultant_Meeting_Goal_Counter__c'));
        appSeetingList.add(new Application_Settings__c (name='DefaultAccountTeamAccountAccessLevel',Value__c='Edit'));
        appSeetingList.add(new Application_Settings__c (name='DefaultAccountTeamCaseAccessLevel',Value__c='Edit'));
        appSeetingList.add(new Application_Settings__c (name='DefaultAccountTeamOpptunityAccessLevel',Value__c='Edit'));
        appSeetingList.add(new Application_Settings__c (name='EnableAccountTriggerAddDefaultAccTeam',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableAccountTriggerAddOwnerAsATM',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableAccountTriggerAddSystemRef',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableAccountTriggerChangeOwner',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableCampaignTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableContactTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnablePlanAssociationTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableEventRequestTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableEventTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableFeeApprovalRequestTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableFeedCommentTrigger',Value__c='No'));
        appSeetingList.add(new Application_Settings__c (name='EnableFeedItemTrigger',Value__c='No'));
        appSeetingList.add(new Application_Settings__c (name='EnableNonProdTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableOpportunityTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableOpptyProductTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableOrganizationTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnablePmapsTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableProduct2Trigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableRequestedSpeakerTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableShareClSearchByName',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableStrategyPlanTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableTaskTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='Institutional Portfolio Manager',Value__c='Institutional_Portfolio_Manager_Goal_Cou__c'));
        appSeetingList.add(new Application_Settings__c (name='IntegrationProfileId',Value__c=System.Label.MFS_Integration_Profile_ID));
        appSeetingList.add(new Application_Settings__c (name='MFSGenericUserId',Value__c=System.Label.MFS_Owner_User_Id));
        appSeetingList.add(new Application_Settings__c (name='Portfolio Manager Meeting',Value__c='Portfolio_Manager_Meeting_Goal_Counter__c'));
        appSeetingList.add(new Application_Settings__c (name='Role',Value__c='Institutional Sales'));
        appSeetingList.add(new Application_Settings__c (name='Sr. Executive Meeting',Value__c='Sr_Executive_Meeting_Goal_Counter__c'));
        appSeetingList.add(new Application_Settings__c (name='Sr. Investment Speaker Meeting',Value__c='Sr_Investment_Speaker_Goal_Counter__c'));
        appSeetingList.add(new Application_Settings__c (name='EnableDataLoad',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='AdminProfileIds',Value__c=System.Label.MFS_Admin_profile_Ids));
        appSeetingList.add(new Application_Settings__c (name='EnableClientInvestmentTrigger',Value__c='Yes'));
        appSeetingList.add(new Application_Settings__c (name='EnableUserTrigger',Value__c='Yes'));
        return appSeetingList;
        
    }  
    
    public static Organization_Institutional_Sales__c getOrgInstSalesRec(Account acc){
        Organization_Institutional_Sales__c ois = new Organization_Institutional_Sales__c();
        ois.Organization__c = acc.id;
        ois.AUM_AUD__c = 20.00;
        ois.AUM_CAD__c = 10.00;
        ois.AUM_EUR__c = 5.00;
        ois.AUM_GBP__c = 5.00;
        ois.AUM_JPY__c = 5.00;
        ois.AUM_SGD__c = 5.00;
        ois.AUM_USD__c = 5.00;
        ois.Client_Reporting_Currency_Code__c = 'USD';
        ois.Plan_ID__c = 'PL-00';
        ois.Plan_Name__c = 'Kaiser Plan';
        ois.Organization_MDM_ID__c = acc.MDM_ID__c;
        ois.Level__c = 'Plan';
        return ois;
    }
    
    public static void setIndividualSalesList(){
        for(Integer i=0; i<3; i++){
            Individual_Sales__x exObj = new Individual_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',
                                                                            Level__c='Product', Source_Product_ID__c = 'MFS Aggressive Growth Allocation Fund', AUM_USD__c=10.00, 
                                                                            Prior_Year_Sales_USD__c=10.00, Contact_MDM_ID__c='MDM3456',YTD_Sales_USD__c=10.00,
                                                                            YTD_Redemptions_USD__c=10.00);
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        for(Integer i=0; i<10; i++){
            Individual_Sales__x exObj = new Individual_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',
                                                                            Level__c='Share Class', Source_Product_ID__c='MFS Aggressive Growth Allocation Fund', AUM_USD__c=10.00, 
                                                                            Prior_Year_Sales_USD__c=10.00, Contact_MDM_ID__c='MDM3456',YTD_Sales_USD__c=10.00,
                                                                            YTD_Redemptions_USD__c=10.00,ShareClassCode__c='I');
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        for(Integer i=0; i<=1; i++){
            Individual_Sales__x exObj = new Individual_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',
                                                                            Level__c='Product Vehicle', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, 
                                                                            Contact_MDM_ID__c='MDM3456',YTD_Sales_USD__c=10.00,
                                                                            YTD_Redemptions_USD__c=10.00);
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        for(Integer i=0; i<=1; i++){
            Individual_Sales__x exObj = new Individual_Sales__x(Level__c='Total', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, Contact_MDM_ID__c='MDM3456',
                                                                            YTD_Sales_USD__c=10.00,  YTD_Redemptions_USD__c=10.00);
            MFS_Utilities.AssetsDataList.add(exObj);
        }        
    }
    public static void setPartnershipSalesList(){
        for(Integer i=0; i<3; i++){
            Partnership_Sales__x exObj = new Partnership_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',
                                                                            Level__c='Product', Source_Product_ID__c = 'MFS Aggressive Growth Allocation Fund', AUM_USD__c=10.00, 
                                                                            Prior_Year_Sales_USD__c=10.00, Contact_MDM_ID__c='MDM3456',YTD_Sales_USD__c=10.00,
                                                                            YTD_Redemptions_USD__c=10.00);
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        for(Integer i=0; i<10; i++){
            Partnership_Sales__x exObj = new Partnership_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',
                                                                            Level__c='Share Class', Source_Product_ID__c='MFS Aggressive Growth Allocation Fund', AUM_USD__c=10.00, 
                                                                            Prior_Year_Sales_USD__c=10.00, Contact_MDM_ID__c='MDM3456',YTD_Sales_USD__c=10.00,
                                                                            YTD_Redemptions_USD__c=10.00,ShareClassCode__c='I');
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        for(Integer i=0; i<=1; i++){
            Partnership_Sales__x exObj = new Partnership_Sales__x(Product_Vehicle__c='MFS Family of Funds (US)',
                                                                            Level__c='Product Vehicle', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, 
                                                                            Contact_MDM_ID__c='MDM3456',YTD_Sales_USD__c=10.00,
                                                                            YTD_Redemptions_USD__c=10.00);
            MFS_Utilities.AssetsDataList.add(exObj);
        }
        for(Integer i=0; i<=1; i++){
            Partnership_Sales__x exObj = new Partnership_Sales__x(Level__c='Total', AUM_USD__c=10.00, Prior_Year_Sales_USD__c=10.00, Contact_MDM_ID__c='MDM3456',
                                                                            YTD_Sales_USD__c=10.00,  YTD_Redemptions_USD__c=10.00);
            MFS_Utilities.AssetsDataList.add(exObj);
        }
    }
    
    public static GDM_Table_Fields__c getGDMFieldsIndividualSales(){
        
        GDM_Table_Fields__c gdmTableIndividualSales = new GDM_Table_Fields__c (name='Individual_Sales__x#USD',AUM__C='AUM:AUM_USD__c',LEVEL__C='Level:Level__c',
                                                                          MDM_ID__C='MDM_ID:Contact_MDM_ID__c',PRODUCT__C='ProductName:Source_Product_ID__r.name',
                                                                          PRODUCT_VEHICLE__C='ProductVehicle:Product_Vehicle__c',PRODUCT_ID__C='ProductId:Source_Product_ID__r.Id',
                                                                          PY__C='PY:Prior_Year_Sales_USD__c',PY_RED__C='PYRed:Prior_Year_Redemptions_USD__c',YTD__C='YTD:YTD_Sales_USD__c',
                                                                          YTD_RED__C='YTDRed:YTD_Redemptions_USD__c',SHARECLASS__C='ShareClass:ShareClassCode__c');
        return gdmTableIndividualSales;
    }
    public static GDM_Table_Fields__c getGDMFieldsPartnershipSales(){
        
        GDM_Table_Fields__c gdmTableIPartnershipSales = new GDM_Table_Fields__c (name='Partnership_Sales__x#USD',AUM__C='AUM:AUM_USD__c',LEVEL__C='Level:Level__c',
                                                                          MDM_ID__C='MDM_ID:Contact_MDM_ID__c',PRODUCT__C='ProductName:Source_Product_ID__r.name',
                                                                          PRODUCT_VEHICLE__C='ProductVehicle:Product_Vehicle__c',PRODUCT_ID__C='ProductId:Source_Product_ID__r.Id',
                                                                          PY__C='PY:Prior_Year_Sales_USD__c',PY_RED__C='PYRed:Prior_Year_Redemptions_USD__c',YTD__C='YTD:YTD_Sales_USD__c',
                                                                          YTD_RED__C='YTDRed:YTD_Redemptions_USD__c',SHARECLASS__C='ShareClass:ShareClassCode__c');
        return gdmTableIPartnershipSales;
    }
    
	public static String getFakeId(Schema.SObjectType sot)
	{
		String result = String.valueOf(s_num++);
		return sot.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
	}  
    
    public static Strategy_Rating_Process__c createStrategyRatingProcess(Id accountId, Id prodId){
        Strategy_Rating_Process__c srp = new Strategy_Rating_Process__c(Name = 'Test', Product__c = prodId, Consultant__c = accountId);
        return srp;
    }
    
    public static Investments_Needing_Service__c createInvestments(Id caseId){
        Investments_Needing_Service__c inv = new Investments_Needing_Service__c(Case__c = caseId);
        return inv;
    }
}