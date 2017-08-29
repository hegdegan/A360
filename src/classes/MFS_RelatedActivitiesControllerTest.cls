@isTest 
public class MFS_RelatedActivitiesControllerTest {
    private static FINAL String RET_EVENT =  'Enhanced Event (Retail)';
    private static FINAL String RET_TASK = 'Log a Call (Retail)';
    static testmethod void RelatedActivitiesInitialLoad(){
        
        //Create account
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        
        //Create Contact
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        
        //Create Product
        Product2 prod = MFS_TestDataUtility.createProduct();
        prod.IsActive = true;
        prod.Is_Unknown__c =false;
        prod.Restricted__c=false;
        insert prod;
        
        //Create callNote
        Activity_Detail__c cNote = MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote;
        //Create Activity360
        Event e = new Event ();
        e.Activity_Detail__c = cNote.id;
        //e.StartDateTime = datetime.NOW();
        //e.EndDateTime = datetime.NOW().addMinutes(30);
        e.ActivityDate = system.Today();
        e.IsAllDayEvent = true;
        e.Method__c = 'In Person Meeting';
        e.Activity_Type_for_Instit__c = 'Finals';
        e.Type = 'Meeting';
        e.whoid = cont.id;
        e.whatid = acc.id;
        e.recordtypeid= Schema.SObjectType.Event.getRecordTypeInfosByName().get(RET_EVENT).getRecordtypeId();
        insert e;
		system.debug('event e='+e);
        //Create callNote
        Activity_Detail__c cNote1 = MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote1;
        //Create Activity360
        Event e1 = new Event ();
        e1.Activity_Detail__c = cNote1.id;
        e1.StartDateTime = datetime.NOW().addDays(-2);
        e1.EndDateTime = e1.StartDateTime.addMinutes(30);
        e1.Method__c = 'In Person Meeting';
        e1.Activity_Type_for_Instit__c = 'Finals';
        e1.Type = 'Meeting';
        e1.whoid = cont.id;
        e1.whatid = acc.id;
        e1.recordtypeid= Schema.SObjectType.Event.getRecordTypeInfosByName().get(RET_EVENT).getRecordtypeId();
        insert e1;
        
        List<OpenActivity> lstOA = new List<OpenActivity>();
List<ActivityHistory> lstAH = new List<ActivityHistory>();

OpenActivity oa1 = new OpenActivity();
//oa1.ActivityDate = system.Today().addDays(-2);
lstOA.add(oa1);

ActivityHistory ah1 = new ActivityHistory();
//ah1.ActivityDate = system.Today().addDays(-1);
lstAH.add(ah1);
        
Set<Id> setSelectedAttendee = new Set<Id>();
setSelectedAttendee.add(cont.id);
        Set<Id> setSelectedProduct = new Set<Id>();
setSelectedProduct.add(prod.id);
        
        system.debug('select id, (select id from OpenActivities), (select id from ActivityHistories) from Account where id = acc.id'+ [select id, (select id from OpenActivities), (select id from ActivityHistories) from Account where id =: acc.id]);
        
        PageReference pg = Page.MFS_RelatedActivities;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id',acc.id);
        Test.startTest();
	MFS_RelatedActivitiesController rac = new MFS_RelatedActivitiesController();
	
        
        
        rac.wSearchKey.timeframe = 'Upcoming 3 Months'; 
        rac.wSearchKey.selectedmethods = '\'In Person Meeting\'';
        rac.FilterActivity();
        rac.wSearchKey.timeframe = '1 Month'; 
        rac.wSearchKey.selectedmethods = '\'Virtual Meeting\'';
        rac.FilterActivity();
        rac.wSearchKey.timeframe = '3 Months'; 
        rac.wSearchKey.selectedmethods = '\'Phone Call\'';
        rac.FilterActivity();
        rac.wSearchKey.timeframe = '6 Months'; 
        rac.FilterActivity();
        rac.wSearchKey.timeframe = '1 Year'; 
        rac.FilterActivity();
        rac.wSearchKey.timeframe = '2 Years'; 
        rac.FilterActivity();
        rac.wSearchKey.timeframe = '3 Years'; rac.FilterActivity();
   	     rac.wSearchKey.timeframe = 'All Time'; 
        rac.wSearchKey.selectedmethods = '';
        rac.FilterActivity();
        rac.init();
        
        //Testing Assigned to selection
        rac.wSearchKey.idAssignedTo = UserInfo.getUserId();
		rac.FilterActivity();
        //Attendee selection test
        rac.OpenAttendeeSearchModal();
        rac.wSearchKey.wAttendees.SearchText = 'test';
        rac.getInviteeSearchObjects();
        rac.SearchObjects = 'Users & Contacts';
        rac.wSearchKey.selectedAttendee = String.valueOf(cont.id);
        rac.wSearchKey.sAttendeeIds.add(cont.id);
        rac.selectedAttendeeHidden = cont.Id;
        rac.searchInvitee();
        rac.reset();
        rac.wSearchKey.selectedAttendee = String.valueOf(cont.id);
        rac.addSeletedAttendees();
        rac.wSearchKey.selectedAttendee = String.valueOf(cont.id);
        rac.wSearchKey.sAttendeeIds.add(cont.id);
        rac.FilterActivity();
        
        
        //Product selection tests
        rac.OpenProductSearchModal();
        rac.wSearchKey.product.Name='testProduct';
		rac.wSearchKey.product.Vehicle__c = 'Domestic Mutual Fund'; 
		rac.wSearchKey.product.Asset_Class_Geography__c='Emerging Markets (diversified) Equity';
    	rac.searchProduct();
        rac.addSeletedProduct();
        rac.wSearchKey.selectedProduct = prod.id;
        rac.FilterActivity();
        
		rac.mergeSortActivities(lstOA, lstAH, TRUE);
        rac.checkIfSelectedAttendeeMatching(setSelectedAttendee, cNote );
        rac.checkIfSelectedProductMatching(setSelectedProduct, cNote );
        
        MFS_RelatedActivitiesController.queryPortfolios('keyword');
            MFS_RelatedActivitiesController.queryContacts('keyword');
            MFS_RelatedActivitiesController.queryUsers('keyword');
        
        //Exception tests
        rac.wlSearchedProducts = NULL;
        rac.searchProduct();
        rac.wSearchKey.sProductIds = NULL;
        rac.addSeletedProduct();
        rac.wSearchKey.sAttendeeIds = NULL;
		rac.addSeletedAttendees();
        Test.stopTest();
    }
}