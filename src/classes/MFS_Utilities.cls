/**
Apex Class Name    : MFS_Utilities
Version            : 1.0 
Created Date       : 11 MAY 2016
Function           : Utility class that gets called by any classes or triggers 
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              11/05/2016              Original Version
* Manoj Parida            22/09/2016              V 1.2
**/
public class MFS_Utilities { 
    public static Map<String, Schema.SObjectType> mSchema = new Map<String,Schema.SObjectType>();
    public static Map<String, Schema.SObjectField> mFields = null;
    static Set<String> discardFieldSet = new Set<String>{'Id', 'IsDeleted','Name','SetupOwnerId','CreatedDate', 'CreatedById','LastModifiedDate','LastModifiedById', 'SystemModstamp','CurrencyIsoCode'};
    static final String shareClassPrefix = 'Share Class ';
    public Static Boolean run = true;
    public static MFS_SalesAssetsWrapper swTotalforAssign;
    @TestVisible public static List<SObject> assetsDataList = new List<SObject>();
    private static final Map<String, String> objectNameMap = new Map<String, String>{'Organization_Institutional_Sales__c' => 'OrgInstSales', 'Consultant_Sales__x' => 'Consultant_Sales__x',         
        'Individual_Sales__x' => 'Individual_Sales__x', 'Organization_Retail_Sales__x' => 'Organization_Retail_Sales__x',
        'Partnership_Sales__x' => 'Partnership_Sales__x', 'Team_Sales__x' => 'Team_Sales__x', 'Total_Individual_Sales__x' => 'Total_Individual_Sales__x'};
            
            //Avoid recursive trigger
            public static Boolean runOnce(){
                if(run){
                    run = false;
                    return true;
                }else{
                    return run;
                }
            }
    
    public static void runReset(){
        run = true;
    }
    //Get value from custom setting
    public static string GetAppSettingValue(String key, String defaultValue){
        String appSettingvalue = defaultValue;
        map<String,Application_Settings__c> mapAppSettings = Application_Settings__c.getAll();
        Application_Settings__c oAppSettings;
        if(mapAppSettings.size() > 0 && mapAppSettings.containsKey(key))
        {
            oAppSettings = mapAppSettings.get(Key);
            appSettingValue = oAppSettings.Value__c;
        }
        return appSettingValue;
    }
    //Get value from custom setting
    public static string GetAppSettingValue(Map<String, Application_Settings__c> mapAppSettings, string key, string defaultValue){
        String appSettingValue = defaultValue;
        Application_Settings__c oAppSettings;
        if(mapAppSettings.size() > 0 && mapAppSettings.containsKey(key))
        {
            oAppSettings = mapAppSettings.get(Key);
            appSettingValue = oAppSettings.Value__c;
        }
        return appSettingValue;
    }
    
    /**
* @Description : Method is used to get the external object field names from custom settings for the dynamic query to be formed.
* @Param : key in the format 'ex_Table#Currency' 
* @return: Map<String,String>
**/	
    public static Map<String , String> getGDMCurrenyFields(String key){   
        Map<String, String> cuRRFieldsAndAPIMap = new MAp<String,String>();
        try { 
            Map<String, GDM_Table_Fields__c> GDMCurrFieldsMap = GDM_Table_Fields__c.getAll();
            GDM_Table_Fields__c GDM_Curr;            
            if (GDMCurrFieldsMap != null && GDMCurrFieldsMap.size() > 0 && GDMCurrFieldsMap.containsKey(Key)) {       
                GDM_Curr = GDMCurrFieldsMap.get(Key);             
            }
            Map<String, Schema.SObjectField> GDMCurrfldObjMap = schema.SObjectType.GDM_Table_Fields__c.fields.getMap();
            List<Schema.SObjectField> GDMCurrfldObjValues = GDMCurrfldObjMap.values();
            for(Schema.SObjectField s : GDMCurrfldObjValues){
                String GDMCurrFName = s.getDescribe().getName();
                String value;
                if(GDM_Curr !=null && !discardFieldSet.contains(GDMCurrFName.trim())){
                    value = (String)GDM_Curr.get(GDMCurrFName);
                }            
                if(value != null && !''.equals(value)){
                    cuRRFieldsAndAPIMap.put(value.split(':')[0],value.split(':')[1]);
                }
            }          
        }
        catch(Exception e){
            system.debug('Exception in : '+e.getStackTraceString());
            system.debug('Exception : GetMFS_SalesAssetsWrapperList '+e.getMessage());
            throw e;
        }
        return cuRRFieldsAndAPIMap;
    }
    
    /**
* @Description : Method is used to construct the dynamic query for the external objects.
* @Param : MDM Id of the record, page name, currency, external id field name of the object
* @return: String
**/
    public static String getSOQLQueryForExObject(String page, String curr){
        String SOQL = 'SELECT Id, ';
        try {
            Map<String, AssetPageAndTableSettings__c> AssetPageAndTableMap = AssetPageAndTableSettings__c.getAll();
            String ExObjName;            
            if(AssetPageAndTableMap.size() > 0 && AssetPageAndTableMap.containsKey(page)){
                ExObjName = AssetPageAndTableMap.get(page).TableName__c;
            }
            Map<String , String> GDMCurrFields = getGDMCurrenyFields(objectNameMap.get(ExObjName)+'#'+curr);  
            SOQL = SOQL + String.join( GDMCurrFields.values(), ', ');
            SOQL = SOQL + ' FROM ' + ExObjName;            
        }
        catch(Exception e){
            system.debug('Exception in : '+e.getStackTraceString());
            system.debug('Exception : getSOQLQueryForExObject '+e.getMessage());
            throw e;
        } 
        return SOQL;
    }
    
    /**
* @Description : Method is used to get the list of records from GDM tables
* @Param : mdm Id, page name, currency, external Id field
* @return: List of SObjects
**/
    public static List<SObject> getSalesAndAssetsRecordsFromExTable(String MDM_Id, String page, String curr, String externalIdField){
        try{ 
            String SOQL = getSOQLQueryForExObject(page,curr);
            SOQL = SOQL + ' WHERE '+ externalIdField + ' =  \''+   String.escapeSingleQuotes(MDM_Id) + '\' ';
            system.debug('SOQL::'+SOQL);
            if(SOQL != null){
                if(!Test.isRunningTest()){
                    for(SObject sObj : Database.query(SOQL)){
                        assetsDataList.add(sObj);
                    }
                }                
            }
        }catch(Exception e){
            system.debug('Exception in : '+e.getStackTraceString());
            system.debug('Exception in MFS_Utilities : getSalesAndAssetsRecordsFromExTable '+e.getMessage());
            throw e;
        }
        return assetsDataList;
    }
    
    /**
* @Description : Method is used to currency symbols
* @Param : currency name
* @return: String
**/
    public static String getCurrSymbol(String curr){
        try {
            Map<String, Currency_Symbol__c> currSymbolMap = Currency_Symbol__c.getAll();
            if(curr != null && currSymbolMap.containsKey(curr.trim())){
                return currSymbolMap.get(curr.trim()).Symbol__c;                
            }else return null;
        }
        catch (exception ex){
            system.debug('Exception in : '+ex.getStackTraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));   
            return null;
        }
        
    }
    
    /**
* @Description : Method is used to get client reporting currency for the GDm table
* @Param : table name, mdm Id
* @return: String
**/
    public static String getClientReportingCurr(String tableName, String mdmId){
        String SOQL = 'select Client_Reporting_Currency_Code__c from ' + tableName + ' where Organization_MDM_ID__c '+' =  \''+  mdmId + '\' '+ ' limit 1';
        system.debug('Reporting Curr SQL: '+SOQL);
        SObject sObj;
        try{
            sObj = Database.query(SOQL);            
        }catch(Exception e){
            system.debug('Exception in : '+e.getStackTraceString());
            system.debug('Exception in MFS_Utilities : getClientReportingCurr '+e.getMessage());
            throw e;
        }
        if(sObj != null && sObj.get('Client_Reporting_Currency_Code__c') != null && !''.equals(sObj.get('Client_Reporting_Currency_Code__c'))){
            system.debug('ex.Client_Reporting_Currency_Code__c>>>>>>>>>>>>'+sObj.get('Client_Reporting_Currency_Code__c'));
            return (String)sObj.get('Client_Reporting_Currency_Code__c');
        }else return '';
        
    }
    
    /**
* @Description : Method is used to create wrapper from the record retrieved from GDM table
* @Param : SObject, field map retrieved from custom setting for the combination of table name and currency
* @return: MFS_SalesAssetsWrapper
**/
    public static MFS_SalesAssetsWrapper getWrapper(SObject sObj, Map<String,String> fieldMap){  
        MFS_SalesAssetsWrapper sWrap = new MFS_SalesAssetsWrapper();
        try{   
            sWrap.level = (String)sObj.get(fieldMap.get(MFS_AllConstants.Level));  
            sWrap.mdm_Id = (String)sObj.get(fieldMap.get(MFS_AllConstants.MDM_ID));   
            //Portfolio parameters
            sWrap.portfolioName = (fieldMap.containsKey(MFS_AllConstants.PortfolioName) && sObj.getSObject(MFS_AllConstants.PortfolioRelation) != null) ? (String)sObj.getSObject(MFS_AllConstants.PortfolioRelation).get('name') : '';             
            sWrap.portfolioId = (fieldMap.containsKey(MFS_AllConstants.PortfolioId) && sObj.get(fieldMap.get(MFS_AllConstants.PortfolioId)) != null) ? (String)sObj.get(fieldMap.get(MFS_AllConstants.PortfolioId)) : null;
            //Plan parameters
            String [] planFNameArr = fieldMap.containsKey(MFS_AllConstants.PlanName) ? fieldMap.get(MFS_AllConstants.PlanName).split('\\.') : new List<String> ();
            String planFName = planFNameArr.size() > 0 ? planFNameArr[0] : null;
            sWrap.planName = (fieldMap.containsKey(MFS_AllConstants.PlanName) && sObj.getSObject(planFName ) != null) ? (String)sObj.getSObject(planFName).get('name') : '';
            sWrap.planId = (fieldMap.containsKey(MFS_AllConstants.PlanId) && sObj.getSObject(planFName) != null) ? (String)sObj.getSObject(planFName).get('Id') : null; 
            
            //sWrap.productVehicle = fieldMap.containsKey(MFS_AllConstants.ProductVehicle)?(String)sObj.get(fieldMap.get(MFS_AllConstants.ProductVehicle)):null;
            sWrap.productVehicle = (fieldMap.containsKey(MFS_AllConstants.ProductVehicle) && ((String)sObj.get(fieldMap.get(MFS_AllConstants.ProductVehicle)) != null)) ? (String)sObj.get(fieldMap.get(MFS_AllConstants.ProductVehicle)) : '';
            
            //Product parameters
            String [] productFNameArr = fieldMap.containsKey(MFS_AllConstants.ProductName) ? fieldMap.get(MFS_AllConstants.ProductName).split('\\.') : new List<String> ();
            String productFName = productFNameArr.size() > 0 ? productFNameArr[0] : null;
            sWrap.productName = (fieldMap.containsKey(MFS_AllConstants.ProductName) && sObj.getSObject(productFName ) != null) ? (String)sObj.getSObject(productFName).get('name') : '';
            sWrap.productId = (fieldMap.containsKey(MFS_AllConstants.ProductId) && sObj.getSObject(productFName) != null) ? (String)sObj.getSObject(productFName).get('Id') : null; 
            if(GetAppSettingValue('EnableShareClSearchByName','No').equalsIgnoreCase('Yes')){
                if (  fieldMap.containsKey(MFS_AllConstants.ShareClass)) {                    
                    sWrap.shareClassId = MFS_AllConstants.shareClassMap.get( ( (String)sObj.get(fieldMap.get(MFS_AllConstants.ShareClass))) );
                    sWrap.shareClass = (String)sObj.get(fieldMap.get(MFS_AllConstants.ShareClass))!=null ? (shareClassPrefix+(String)sObj.get(fieldMap.get(MFS_AllConstants.ShareClass))) : '';
                }else{
                    sWrap.shareClass = '';
                }                
            }else {		
                String [] sClsFNameArr =  fieldMap.get(MFS_AllConstants.ShareClass).split('\\.');
                String sClsFName = sClsFNameArr[0];				
                sWrap.shareClassId = (fieldMap.containsKey(MFS_AllConstants.ShareClassId) && sObj.getSObject(sClsFName) != null) ? (String)sObj.getSObject(sClsFName).get('Id') : null;
                sWrap.shareClass = (fieldMap.containsKey(MFS_AllConstants.ShareClass) && sObj.getSObject(sClsFName) != null) ? (shareClassPrefix+(String)sObj.getSObject(sClsFName).get('name')) : ''; 
            }
            
            //Strategy parameters
            String [] strategyFNameArr = fieldMap.containsKey(MFS_AllConstants.StrategyName) ? fieldMap.get(MFS_AllConstants.StrategyName).split('\\.') : new List<String> ();
            String strategyFName = strategyFNameArr.size() > 0 ? strategyFNameArr[0] : null;
            sWrap.strategyName = (fieldMap.containsKey(MFS_AllConstants.StrategyName) && sObj.getSObject(strategyFName ) != null) ? (String)sObj.getSObject(strategyFName).get('name') : '';
            sWrap.vehicleName = (fieldMap.containsKey(MFS_AllConstants.VehicleName) && ((String)sObj.get(fieldMap.get(MFS_AllConstants.VehicleName)) != null)) ?(String)sObj.get(fieldMap.get(MFS_AllConstants.VehicleName)):'';             
            sWrap.productVehicleId = (fieldMap.containsKey(MFS_AllConstants.VehicleId) && ((String)sObj.get(fieldMap.get(MFS_AllConstants.VehicleId)) != null)) ?(String)sObj.get(fieldMap.get(MFS_AllConstants.VehicleId)):'';             
            
            String [] orgFNameArr =  fieldMap.containsKey(MFS_AllConstants.ORGName) ? fieldMap.get(MFS_AllConstants.ORGName).split('\\.') : new List<String>();
            String orgFName = (orgFNameArr.size()) > 0 ? orgFNameArr[0] : null ; 
            sWrap.orgId = (fieldMap.containsKey(MFS_AllConstants.ORGId) && sObj.getSObject(orgFName) != null) ? (String)sObj.getSObject(orgFName).get('Id') : null; 
            sWrap.orgName = (fieldMap.containsKey(MFS_AllConstants.ORGName) && sObj.getSObject(orgFName) != null) ? (String)sObj.getSObject(orgFName).get('name') : '';                    
            //Asset parameters
            sWrap.ytd = fieldMap.containsKey(MFS_AllConstants.YTD)?(decimal)(sObj.get(fieldMap.get(MFS_AllConstants.YTD))) : null;
            sWrap.ytdRed = fieldMap.containsKey(MFS_AllConstants.YTDRed)?(decimal)(sObj.get(fieldMap.get(MFS_AllConstants.YTDRed))):null;
            sWrap.ytdNet = fieldMap.containsKey(MFS_AllConstants.YTDNet)?(decimal)(sObj.get(fieldMap.get(MFS_AllConstants.YTDNet))):null;
            sWrap.py = fieldMap.containsKey(MFS_AllConstants.PY)?(decimal)(sObj.get(fieldMap.get(MFS_AllConstants.PY))):null;
            sWrap.pyRed = fieldMap.containsKey(MFS_AllConstants.PYRed)?(decimal)(sObj.get(fieldMap.get(MFS_AllConstants.PYRed))):null;
            sWrap.aum = fieldMap.containsKey(MFS_AllConstants.AUM)?(decimal)(sObj.get(fieldMap.get(MFS_AllConstants.AUM))):null;
        }catch(Exception ex){
            system.debug('Exception in MFS_SalesAssetsWrapper getWrapper: '+ex.getMessage());
            system.debug('Exception in MFS_SalesAssetsWrapper getWrapper: '+ex.getStackTraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));   
        }
        return sWrap;
    }
    
    
    /**
* @Description : Method is used to get the Salesforce id for the share classes
* @Param : None
* @return: void
**/ 
    public static void getShareClassIdMap(){
        try{
            List<Share_Classes__c> sCLsList = new List<Share_Classes__c>([select id, name from Share_Classes__c LIMIT 1000]);
            MFS_AllConstants.shareClassMap = new Map<String,Id>();
            for(Share_Classes__c scls : sCLsList){
                MFS_AllConstants.shareClassMap.put(scls.name,scls.Id);
            }
        }catch(Exception e){
            system.debug('Exception in : '+e.getStackTraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));    
        }
    }
    
    /**
* @Description : Method is used to get the Salesforce id for the share classes
* @Param : mdmId, assetPage,userCurrency, exIdField
* @return: List of MFS_SalesAssetsWrapper
**/
    public static List<MFS_SalesAssetsWrapper> GetMFS_SalesAssetsWrapperList(String mdmId, String assetPage, String userCurrency, String exIdField){        
        List<MFS_SalesAssetsWrapper> salesWrapperList = new List<MFS_SalesAssetsWrapper>();
        MFS_SalesAssetsWrapper sWrapper;
        List<SObject> exObjectRecList = new List<SObject>();
        try{
            exObjectRecList = MFS_Utilities.getSalesAndAssetsRecordsFromExTable(mdmId,assetPage,userCurrency, exIdField);
            String ExObjName = AssetPageAndTableSettings__c.getAll().get(assetPage).TableName__c;
            Map<String , String> currFieldMap = MFS_Utilities.getGDMCurrenyFields(objectNameMap.get(ExObjName)+'#'+userCurrency);
            if(exObjectRecList != null && exObjectRecList.size() > 0){
                for(SObject salesData : exObjectRecList){
                    sWrapper = MFS_Utilities.getWrapper(salesData,currFieldMap);
                    if(sWrapper != null && sWrapper.Level != null && !sWrapper.Level.equalsIgnoreCase(MFS_AllConstants.TotalSalesLabel)){
                        salesWrapperList.add(sWrapper);
                    }
                    else if(sWrapper != null && sWrapper.Level != null && sWrapper.Level.equalsIgnoreCase(MFS_AllConstants.TotalSalesLabel)) {
                        swTotalforAssign = sWrapper;
                    }
                }
            }
            if(exObjectRecList != null && salesWrapperList.size()>0){ 
                salesWrapperList.sort();
            }
        }catch(Exception e){
            system.debug('Exception : GetMFS_SalesAssetsWrapperList '+e.getMessage());
            throw e;
        }
        return salesWrapperList;
    } 
    
    
    
    public static Map<String,String> getFieldId(String objName,List<String> fieldList)
    {
        Map<String,String> fieldMap=new Map<String,String>();
        List<StoreFieldIds__c> listOfFields=StoreFieldIds__c.getAll().values();
        for(StoreFieldIds__c fieldId : listOfFields)
        {
            if(fieldId.Object_Name__c==objName)
            {
                for(String fieldName : fieldList)
                {
                    if(fieldName.equals(fieldId.Field_API_name__c))
                    {
                        fieldMap.put(fieldId.Field_API_name__c,fieldId.Field_Id__c);
                    }
                }
            }
        }
        return fieldMap;
    }
    
}