/***************************************************************************************************
Apex Class Name    : MFS_AllConstants
Version            : 1.0 
Created Date       : 05 MAY 2016
Function           : This is a Controller for MFS_AllConstants Page.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta            05/05/2016              Original Version
* Instruction:           None of the Constants to be modified 
***************************************************************************************************/
public class MFS_AllConstants {
    
    //Constants from the Custom Settings - you'll need to add the Integration Profile ID
    public static final Application_Settings__c IntegrationProfileId = Application_Settings__c.getInstance('IntegrationProfileId');
    public static final Application_Settings__c AdminProfileIds = Application_Settings__c.getInstance('AdminProfileIds');
    public static final String REC_TYPE_UNKNOWN = 'UNKNOWN';
    //Contact Constants
    public static final String COMMA = ',';
    public static final String LOCATION = 'location';
    public static final String LATITUDE = 'lat';
    public static final String LONGITUDE  ='lng';
    public static final String TIMEZONDID = 'timeZoneId';
    public static final String GEOKEY = 'AIzaSyC0eNU07gbgQ3t0Heena1LtpGEFK-0VG4E';
    
    //Opportunity Constants
     public static final String SLASH = '/'; 
     public static final String STATUS_PENDING = 'Pending'; 
     public static final String STATUS_APPROVED = 'Approved';
     public static final String STATUS_REJECTED = 'Rejected';
     public static final String PICKLIST_DEFAULT = 'None';
     public static final String PRODUCT_FAMILY = 'Family';
     public static final String PRODUCT_NAME = 'Product2';
     public static final String PRODUCT_GEOGRAPHY = 'Asset_Class_Geography__c';
     public static final String PRODUCT_VEHICLE='Vehicle__c';
     public static final String PRODUCT_STYLE = 'Style__c';
     public static final String FEE_TYPE_STD = 'Standard';
     public static final String FEE_TYPE_CUSTOM = 'Custom';
     public static final String DEFAULT_APP_STATUS='Not Started';
     public static final String DEFAULT_STD_APP_STATUS='Not Required';
     public static final String HELP_URL='https://help.salesforce.com/htviewhelpdoc?id=salesteam_def.htm&siteLang=en_US';
     public static final String EDIT='Edit';
     public static final String READ_ONLY='Read Only';
     public static final String READ_WRITE='Read/Write';
     public static final String READ='Read';
     public static final String STATUS_FUNDED='Funded';
     public static final String OPP_INS_RECTYPE='Institutional New Business';
     public static final String OPP_BUYER_RECTYPE='Retail/Professional Buyer';
     public static final String OPP_RES_RECTYPE='Retail External Sales';
     public static final String LK_ID='_lkid';
     public static final String APPROVAL_REQUEST_RT='Fee Approval Request';
     public static final String APPROVAL_ONBOARDING_RT='Onboarding Approval Request';
     public static final String APPROVAL_DOMESTIC_RT=System.Label.Case_RT_Global_Retail_Onboarding;//'Domestic/Non-US Retail';
    
     //Account Constants
     public static final String ACC_CLIENT_RECTYPE='Global Institutional Client';
    public static final String CON_RETAIL_RECTYPE='Retail';
    
     //Case Constants
     public static final String Case_TM_RECTYPE='User Support';
     
     //SP Goal Constants
     public static final String CLIENT_REVIEW_MEETING = 'Client Review Meetings'; 
     public static final String CLIENT_ENG_MEETING = 'Client Engagement Meeting';
     public static final String ANALYST_MEETING = 'Analyst Meeting';
     public static final String SR_INVSTR_SPKR_MEETING = 'Sr. Investment Speaker Meeting';
     public static final String SR_EX_MEETING = 'Sr. Executive Meeting';
     public static final String PORTFOLIO_MGR_MEETING = 'Portfolio Manager Meeting';
     public static final String CONSULTANT_MEETING = 'Consultant Meeting';
     public static final String INST_PORTFOLIO_MGR_MEETING = 'Institutional Portfolio Manager Meeting';
     
     public static final String CLIENT_REVIEW_MEETING_GOAL = 'Client Review Meeting Goal';
     public static final String CLIENT_ENG_GOAL = 'Client Engagement Goal';
     public static final String ANALYST_MEETING_GOAL = 'Analyst Meeting Goal';
     public static final String SR_INVSTR_SPKR_MEETING_GOAL = 'Sr. Investment Speaker Goal';
     public static final String SR_EX_MEETING_GOAL = 'Senior Executive Meeting Goal';
     public static final String PORTFOLIO_MGR_MEETING_GOAL = 'Portfolio Manager Meeting Goal';
     public static final String CONSULTANT_MEETING_GOAL = 'Consultant Meeting Goal';
     public static final String INST_PORTFOLIO_MGR_GOAL = 'Institutional Portfolio Manager Goal';
     public static final String INST_PORTFOLIO_MGR ='Institutional Portfolio Manager';

    //Lightning parameters
    public static final String THEME4T = 'Theme4t';
    
    //Case Constants
    public static final String DEFAULT_CASE_STATUS='New';
    
    //Sales and Assets pages Constants
    public static String PageForSortSeq = '';	
	public static final String OrgInsSalesPage = 'OrgInstitutional';
	public static final String TotalSalesLabel = 'Total';
	public static final String OrgRetSalesPage = 'OrgRetail';
	public static final String OrgConSalesPage = 'OrgConsultant';
	public static final String LevelTotal = 'Total';
	public static final String LevelPlan = 'Plan';
	public static final String LevelPortfolio = 'Portfolio';
	public static final String LevelProductVehicle = 'Product Vehicle';
	public static final String LevelProduct = 'Product';
	public static final String LevelShareClass = 'Share Class';
	public static final String LevelStrategy = 'Strategy';
	public static final String LevelVehicle = 'Vehicle';
	public static final String LevelOrg = 'Organization';	
	public static final String OrgInsExId = 'Organization_MDM_ID__c';
	public static final String OrgRetExId = 'Organization_MDM_ID__c';
	public static final String OrgConsExId = 'Consultant_MDM_ID__c';
    public static final String ContactObjApiName = 'Contact';
    public static final String TeamObjApiName = 'Team__c';
    public static final String SelectedCatTotal = 'Total';
    public static final String SelectedCatTeam = 'Team';
    public static final String SelectedCatIndividual = 'Individual';
    public static final String SelectedCatPartnership = 'Partnership';
    public static Map<String,Id> shareClassMap = null;	
	public static final String MyCurr = Label.SA_My_Currency;
	public static final String ClientCurr = Label.SA_Client_Currency;
	public static final String ClientCurrPlaceHolder = 'CLI';
    public static final String YTD = 'YTD';
    public static final String YTDRed = 'YTDRed';
    public static final String YTDNet = 'YTDNet';
    public static final String PY = 'PY';
    public static final String PYRed = 'PYRed';
    public static final String AUM = 'AUM';
    public static final String ORGId = 'OrgId';
    public static final String ORGName = 'OrgName';
    public static final String ShareClass = 'ShareClass';
    public static final String ShareClassId = 'ShareClassId';
    public static final String Level = 'Level';
    public static final String MDM_ID = 'MDM_ID';
    public static final String ProductName = 'ProductName';
    public static final String ProductId = 'ProductId';
    public static final String ProductVehicle = 'ProductVehicle';
    public static final String PlanName = 'PlanName';
    public static final String PlanId = 'PlanId';
    public static final String PortfolioId = 'PortfolioId';
    public static final String VehicleName = 'VehicleName';
    public static final String VehicleId = 'productVehicleId';
    public static final String StrategyName = 'StrategyName';
    public static final String PortfolioName = 'PortfolioName';
    public static final String USDCurr = 'USD';
    public static final String USDCurrSymbol = '$';
    public static final String PortfolioRelation = 'Portfolio__r';
    public static final String ListRowAssignmentError ='List has no rows for assignment';
    public static final String Total_Sales = 'Total_Individual_Sales__x';
    public static final String Individual_Sales = 'Individual_Sales__x';
    public static final String Partnership_Sales = 'Partnership_Sales__x';
    public static final String Retail_Sales = 'Organization_Retail_Sales__x';
    public static final String Consultant_Sales = 'Consultant_Sales__x';
    public static final String Team_Sales = 'Team_Sales__x';
    public static final String Inst_Sales = 'Organization_Institutional_Sales__c';
    public static final String RECTYPE_Consultant = 'Consultant';
    public static final String RECTYPE_InstClient = 'Institutional Client';
    public static final String RECTYPE_Retail = 'Retail';
    public static final String RECTYPE_InstProspect = 'Institutional Prospect';
    public static final String RECTYPE_Service_Provider = 'Service Provider';
    public static final String ASSETPAGE_Institutional = 'MFS_OrgInstitutionalSalesAndAssetsTable';
    public static final String ASSETPAGE_Retail = 'MFS_OrgRetailSalesAndAssetsTable';
    public static final String ASSETPAGE_Consultant = 'MFS_OrgConsultantSalesAndAssetsTable';
    public static final String PROFILE_Retail = 'Retail';
    public static final String PROFILE_Institutional = 'Institutional';
    
    //Recurring Case Constants
    public static final String RepeatsMonthly = 'Monthly';
    public static final String RepeatsWeekly = 'Weekly';
    public static final String RepeatsQuarterly = 'Quarterly';
    public static final String RepeatsSemiAnnual = 'Semi Annual';
    public static final String RepeatsAnnual = 'Annual';
    public static final String EndsAfter = 'After';
    public static final String EndsNever = 'Never';
    public static final String EndsOn = 'On';
    public static final String BusinessDays = 'Business Days';
    public static final Integer Add_0_Days = 0;
    public static final Integer Add_7_Days = 7;
    public static final Integer Add_1_Month = 1;
    public static final Integer Add_3_Months = 3;
    public static final Integer Add_6_Months = 6;
    public static final Integer Add_12_Months = 12;
    public static final String Default_Days = 'Business Days';
    
    //Event Constants
    public static final String Confirmed = 'Confirmed';
    public static final String Pending = 'Pending';
    public static final String Approved= 'Approved';
    
    //Common Constants
    public static final String RETURN_URL='retURL';
    public static final String RECORD_TYPE='RecordType';
    
    //All Constants for Event Invitee class - MFS_EventInviteeUtility
    public static final Decimal BUSINESS_STARTTIME_HOUR = 7;
    public static final Decimal BUSINESS_ENDTIME_HOUR = 21;

    //All Constants for Activity360 Controller    
    public static final String TASK_PRIORITY_DEFAULT = 'Normal';
    public static final String RES_FOLLOW_UP_TASK_DEFAULT_STATUS = 'In Progress';
    public static final String TASK_PRIORITY_DEFAULT_HIGH = 'High';
    public static final String TASK_CALLCATEGORY_DEFAULT = 'outbound';
    public static final String TASK_CALLCATEGORY_DEFAULT_INBOUND = 'Inbound';
    public static final String TASK_STATUS_DEFAULT = 'Completed';
    public static final String RECTYPE_TASK_INSTIT = 'Log_a_Call_Institutional';
    public static final String RECTYPE_TASK_RETAIL = 'Log_a_Call_Retail';
    public static final String RECTYPE_EVENT_INSTIT = 'Enhanced_Event_Institutional';
    public static final String RECTYPE_EVENT_RETAIL = 'Enhanced_Event_Retail';
    public static final String	EVENT_TYPE_FIELD_DEFAULTVALUE = 'Other';
    public static final String	TASK_SUBJECT_FIELD_DEFAULTVALUE = Label.A360_TASK_SUBJECT_FIELD_DEFAULTVALUE;//'Phone Call -';
    public static final String	TASK_SUBJECT_FIELD_DEFAULTVALUE_INSTITUTIONAL = Label.A360_TASK_SUBJECT_FIELD_DEFAULTVALUE_INSTITUTIONAL;//'Meeting - ';
    public static final String	TASK_CALLOUTCOME_FIELD_DEFAULTVALUE = 'Live Phone Call';
    public static final String	TASK_TYPE_FIELD_DEFAULTVALUE_INSTITUTIONAL = 'Live Call';
	public static final String	EVENT_METHOD_FIELD_DEFAULTVALUE = 'In Person Meeting';//A360_EVENT_METHOD_FIELD_DEFAULTVALUE
    //public static final String EVENT_METHOD_FIELD_DEFAULTVALUE = Label.A360_EVENT_METHOD_FIELD_DEFAULTVALUE;
	public static final String	EVENT_LOCATION_FIELD_DEFAULTVALUE_OFFICE = 'MFS Office';
    public static final String	EVENT_METHOD_FIELD_SUBVALUE = 'Phone Call';
	public static final String EVENT_LOCATION_FIELD_DEFAULTVALUE_OFFSITE = 'Offsite';
	public static final String	INSTITUTIONAL_RECORDTYPE_SUBTEXT = 'Instit';
	public static final String	RETAIL_RECORDTYPE_SUBTEXT = 'Retail';
	public static final String	TASK_STATUS_FIELD_DEFAULTVALUE = 'Open';
	public static final String	FOLLOWUP_TASK_SUBJECT_FIELD_DEFAULTVALUE = Label.A360_FOLLOWUP_TASK_SUBJECT_FIELD_DEFAULTVALUE;//'Follow up - ';
    public static final String	FOLLOWUP_TASK_SUBJECT_FIELD_DEFAULTVALUE_1 = Label.A360_FOLLOWUP_TASK_SUBJECT_FIELD_DEFAULTVALUE_1;//'Follow up';
    public static final String	FOLLOWUP_TASK_PRIORITY_FIELD_DEFAULTVALUE = 'Low';    
	public static final String  SOBJECT_NAME_FOR_COMPETITIVE_ANALYSIS_REQUEST = 'Competitive_Analysis_Request__c';      
    public static final String  MMR_SECTOR_FIELD_DEFAULT_VALUE = 'Strategy';
    public static final String  MMR_BENCHMARK_FIELD_DEFAULT_VALUE = 'Strategy';
    public static final String  PARENTOBJECTTYPE_DEFAULTVALUE = 'Account';    
    public static final String  COVERAGE_TEAM_ROLE_DEFAULTVALUE = 'Internal Wholesaler';
    public static final String	AUTO_TASK_TYPE_FIELD_DEFAULTVALUE = 'Scheduled Call';
    public static final String	COMP_ANANLYSIS_DEFAULT_STATUS = 'Generate';
	public static final String EVENT_GOVT_ENTITY_DEFAULT ='No';  
    public static final String TASK_SUBJECT_DEFAULT ='Follow up - Complete Speaker Request form';
    public static final String MAIN_TASK_SUBJECT_START_TEXT ='Phone Call - ';
    public static final String DEFAULT_ACTIVITY_START_TIME = '12:00 AM';
    public static final String DEFAULT_ACTIVITY_END_TIME = '11:30 PM';
    public static final String INVITEE_STATUS_APPROVED = 'Approved';
    public static final String INVITEE_STATUS_ACCEPTED = 'Accepted';
    public static final String INVITEE_STATUS_REJECTED = 'Rejected';
    public static final String INVITEE_STATUS_DECLINED = 'Declined';
    public static final String INVITEE_STATUS_NEW = 'New';
    public static final String ER_METHOD_PHONE_CALL ='Phone Call';
    public static final String ER_METHOD_VIRTUAL ='Virtual';
    public static final String EVENT_METHOD_PHONE_CALL ='Conference Call';
    public static final String EVENT_METHOD_VIDEO_CONFERENCE ='Video Conference';
    public static final String EVENT_METHOD_WEBINAR ='Customized Webinar';
    public static final String EVENT_METHOD_VIRTUAL_MEETING ='Virtual Meeting';
    public static final String ER_COUNTRY ='United States';
    public static final String ER_CITY ='Boston';
    public static final String ER_EVENT_TYPE_OTHER = 'Other';
    public static final String ER_APPROVAL_STATUS_DEFAULT = 'Pending';
    public static final String ER_DRESS_CODE_DEFAULT = 'Business';
    public static final String EVENT_DEFAULT_COUNTRY ='United States';
    public static final String EVENT_DEFAULT_LOCATION =Label.A360_EVENT_DEFAULT_LOCATION;//'MFS Boston';
    public static final String TASK_INBOUND_FOLLOW_UP_TYPE = 'Schedule Follow up Meeting/Call';
    
    //Approval Request Constants
     public static final String APPROVAL_STATUS_APPROVED = 'Approved'; 
     public static final String APPROVAL_STATUS_PENDING = 'Pending'; 
     public static final long APPROVAL_AMT_ZERO = 0;
     public static final long APPROVAL_AMT_50M = 50000000;
     public static final long APPROVAL_AMT_100M = 100000000;
     public static final long APPROVAL_AMT_FIVE = 5;
     public static final long APPROVAL_AMT_TEN = 10;
     public static final long APPROVAL_AMT_200M = 200000000;
     public static final long APPROVAL_AMT_TWENTY = 20;
     public static final long APPROVAL_AMT_FIFTEEN = 15;
    
    // Rec Types and profiles
    public static final String RT_GOLABL_INST_CLIENT= 'Global Institutional Client';
    public static final String RT_INVST_CONSULTANT= 'Investment Consultant';
    
    public static final Map<String,String> EVENT_METHOD_VALUES = getPickListValues('Event', 'Method__c');
    public static final Map<String,String> EVENT_TYPE_VALUES = getPickListValues('Event', 'Type');
    public static final Map<String, String> TASK_REASON_FOR_CALL_VALUES = getPickListValues('Task', 'Reason_for_call__c');
    public static final Map<String, String> EVENT_ACTIVITY_TYPE_FOR_INST_LABELS = getPickListLabels('Event', 'Activity_Type_for_Instit__c');
    public static final Map<String, String> EVENT_ACTIVITY_TYPE_FOR_INST_VALUES = getPickListVALUES('Event', 'Activity_Type_for_Instit__c');
	
    public static final String FOLLOWUP_TASK_TYPE_FOR_CAR = 'Follow Up - Competitive Analysis Request';
    public static final String FOLLOWUP_TASK_TYPE_FOR_MIM = 'Follow Up - Money In Motion';
    public static final String FOLLOWUP_TASK_TYPE_FOR_DCILead = 'Follow Up - DCI Lead';
    public static final Map<String, String> FOLLOWUP_TASK_TYPE_LABELS = getPickListLabels('Task', 'Follow_up_Type__c');
    public static final Map<String, String> FOLLOWUP_TASK_TYPE_VALUES = getPickListVALUES('Task', 'Follow_up_Type__c');

    
    public static final Map<String, String> ACTIVITY_METHOD_LABELS = getPickListLabels('Event', 'Method__c');
    public static final Map<String, String> ACTIVITY_METHOD_VALUES = getPickListVALUES('Event', 'Method__c');
    
    public static final Map<String, String> MMR_PERFORMANCE_PERIOD_VALUES = getpicklistValues('Meeting_Material_Request__c','Performance_Period__c');
    public static final Map<String, String> MMR_PERFORMANCE_PERIOD_LABELS = getpicklistLabels('Meeting_Material_Request__c','Performance_Period__c');
    
    public static final Map<String, String> MMR_ATTRIBUTION_PERIOD_VALUES = getpicklistValues('Meeting_Material_Request__c','Attribution_Period__c');
    public static final Map<String, String> MMR_ATTRIBUTION_PERIOD_LABELS = getpicklistValues('Meeting_Material_Request__c','Attribution_Period__c');
    
    public static final Map<String, String> MMR_TRANSLATION_LANGUAGES_VALUES = getpicklistValues('Meeting_Material_Request__c','Translation_Languages__c');
    public static final Map<String, String> MMR_TRANSLATION_LANGUAGES_LABELS = getpicklistLabels('Meeting_Material_Request__c','Translation_Languages__c');
    
    public static final Map<String, String> MMR_TIME_PERIOD_COVERED_VALUES = getpicklistValues('Meeting_Material_Request__c','Time_Periods_Covered__c');
    public static final Map<String, String> MMR_TIME_PERIOD_COVERED_LABELS = getpicklistLabels('Meeting_Material_Request__c','Time_Periods_Covered__c');
    
    public static final Map<String, String> PRODUCT_ASSET_CLASS_GEOHRAPHY_VALUES = getpicklistValues('Product2','Asset_Class_Geography__c');
    
    public static final Map<String, String> TASK_CALL_OUTCOME_VALUES = getpicklistValues('Task','Call_Outcome__c');
    
    
    public static final String USER_DEFAULT_LANGUAGE = 'en_US';
    
    
    //Org Record Type Change
    public static final String TYPE_CLIENT_PROSPECT= 'Client/Prospect';
    public static final String TYPE_COMPETITOR= 'Competitor';
    public static final String TYPE_SERVICE_PROVIDER = 'Service Provider';
    public static final String TYPE_SPCL_DEALER= 'Special Dealerpetitor';
    public static final String TYPE_INVST_CONSUL= 'Investment Consultant';
    public static final String DL_US_RETAIL= 'US Retail';
    public static final String DL_NON_US_RETAIL= 'Non-US Retail';
    public static final String DL_GL_INST= 'Global Institutional';
    public static final String RT_GLOBAL_INSTITUTIONAL_CLIENT = 'Global_Institutional_Client';
    public static final String RT_GLOBAL_INSTITUTIONAL_CLIENT_VERIFIED = 'Global_Institutional_Client_Verified';
    public static final String RT_GLOBAL_INSTITUTIONAL_PROSPECT = 'Global_Institutional_Prospect';
    public static final String RT_GLOBAL_INSTITUTIONAL_PROSPECT_VERIFIED = 'Global_Institutional_Prospect_Verified';
    public static final String RT_GLOBAL_RETAIL = 'Global_Retail';
    public static final String RT_GLOBAL_RETAIL_VERIFIED = 'Global_Retail_Verified';
    public static final String RT_INVESTMENT_CONSULTANT = 'Investment_Consultant';
    public static final String RT_INVESTMENT_CONSULTANT_VERIFIED = 'Investment_Consultant_Verified';
    public static final String RT_SERVICE_PROVIDER = 'Service_Provider';
    public static final String RT_SERVICE_PROVIDER_VERIFIED = 'Service_Provider_Verified';
    public static final String RT_UNKNOWN = 'UNKNOWN';
    public static final String ST_PRSPT = 'Prospect';
    public static final String ST_CLIENT = 'Client';
    
    private static Map<String,String> getPickListValues(String ObjName, String fieldName)
    {
        DescribeSobjectResult objType = Schema.getGlobalDescribe().get(ObjName).getDescribe();
        Schema.DescribeFieldResult fieldResult = objType.fields.getMap().get(fieldName).getDescribe();
        Map<String,String> pickListMap = new Map<String,String>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            pickListMap.put(f.getValue(),f.getLabel());
        }
        return pickListMap;
    }
    
    private static Map<String,String> getPickListLabels(String ObjName, String fieldName)
    {
        DescribeSobjectResult objType = Schema.getGlobalDescribe().get(ObjName).getDescribe();
        Schema.DescribeFieldResult fieldResult = objType.fields.getMap().get(fieldName).getDescribe();
        Map<String,String> pickListMap = new Map<String,String>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            pickListMap.put(f.getLabel(),f.getValue());
        }
        return pickListMap;
    }
}