/**
Apex Class Name    : MFS_ContactAndTeamSalesAssetController
Version            : 1.0 
Created Date       : 26 Jun 2016
Function           : Controller class to do operation for COntact and Tesm Sales and Assets data  
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Manoj Parida              26/06/2016              Original Version
**/
public with sharing class MFS_ContactAndTeamSalesAssetController {
    
    public String mdmId ;
    public Id urlId ;
    Public MFS_SalesAssetsWrapper sWrapperTot {get;set;}
    
    //new variables
    public List<MFS_SalesAssetsWrapper> productVehicleList {get;set;}
    public List<MFS_SalesAssetsWrapper> productList {get;set;}
    public List<MFS_SalesAssetsWrapper> salesWrapperList{get;set;}
    public Map<String,List<MFS_SalesAssetsWrapper>> levelThreeMap {get;set;}
    public String selectedCategory {
        get{ return selectedCategory;}
        
        set{selectedCategory = value;}
    }
    public List<String> lstSalesType{get;set;}
    public string userCurrency{get;set;}
    public string userCurrencySymbol{get;set;}
    
    //Constructor
    public MFS_ContactAndTeamSalesAssetController(ApexPages.StandardController controller){
        urlId = ApexPages.currentPage().getParameters().get('id');
        try{
            String sObjName = urlId.getSObjectType().getDescribe().getName();
            if(sObjName!=null && sObjName==MFS_AllConstants.ContactObjApiName){
                Contact contact = [select MDM_ID__c from Contact where id = : urlId];
                mdmId = contact.MDM_ID__c;
                selectedCategory = Label.SA_Level_Total;
            }else if(sObjName!=null && sObjName==MFS_AllConstants.TeamObjApiName){
                Team__c team = [select MDM_Id__c from Team__c where id = : urlId];
                mdmId = team.MDM_Id__c;
                selectedCategory = MFS_AllConstants.SelectedCatTeam;
            }
            userCurrency = UserInfo.getDefaultCurrency();
            userCurrencySymbol = Currency_Symbol__c.getAll().containsKey(userCurrency) ? Currency_Symbol__c.getAll().get(userCurrency).Symbol__c : '';
            if(userCurrencySymbol == null || ''.equals(userCurrencySymbol)){
                userCurrency = MFS_AllConstants.USDCurr;
                userCurrencySymbol = MFS_AllConstants.USDCurrSymbol;
            }
            lstSalesType = new List<String>{Label.SA_Level_Total, Label.SA_Level_Individual,Label.SA_Level_Partnership};
            getSalesAssetsList();	        
        }catch(Exception e){
            system.debug('Exception in MFS_ContactAndTeamSalesAssetController Constructor: '+e.getStackTraceString());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.Generic_Error);
            ApexPages.addMessage(myMsg);
        }        
    }
    //Initialize all Lists and Maps
    public void inititalizeAllListsAndMaps(){
        salesWrapperList = new List<MFS_SalesAssetsWrapper>();
        productVehicleList = new List<MFS_SalesAssetsWrapper>();
        productList = new List<MFS_SalesAssetsWrapper>();
        sWrapperTot = new MFS_SalesAssetsWrapper();
        levelThreeMap = new Map<String,List<MFS_SalesAssetsWrapper>>(); 
    }
    
    /**
* @Description : Method is used to get Contact and Team Sales and Assets records
* @Param : None
* @return: void
**/ 
    public void getSalesAssetsList(){
        inititalizeAllListsAndMaps();
        try{
            if(mdmId == null || ''.equals(mdmId)){
                throw new MFS_Exception(Label.SA_Blank_MDM);
            }
            if(MFS_Utilities.GetAppSettingValue('EnableShareClSearchByName','No').equalsIgnoreCase('Yes') && MFS_AllConstants.shareClassMap == null){
                MFS_Utilities.getShareClassIdMap(); 
            }
            //Handles translation
            selectedCategory = selectedCategory.equals(Label.SA_Level_Total) ? 
                MFS_AllConstants.LevelTotal : selectedCategory.equals(Label.SA_Level_Individual) ? 
                    MFS_AllConstants.SelectedCatIndividual : MFS_AllConstants.SelectedCatPartnership ; 
            String tableName = getSelectedTableName(selectedCategory);
            String exObjName = AssetPageAndTableSettings__c.getAll().get(String.escapeSingleQuotes(tableName)).TableName__c;
            Map<String , String> gdmTableFieldMap = MFS_Utilities.getGDMCurrenyFields(exObjName+'#'+userCurrency);
            String [] mdmIdFArray =  gdmTableFieldMap.containsKey(MFS_AllConstants.MDM_ID) ? gdmTableFieldMap.get(MFS_AllConstants.MDM_ID).split('\\.') : new List<String> ();
            String mdmIdFName = mdmIdFArray.size() > 0 ? mdmIdFArray[0] : null;
            salesWrapperList = MFS_Utilities.GetMFS_SalesAssetsWrapperList(mdmId,tableName,userCurrency,mdmIdFName);
            if(salesWrapperList.size() == 0){
                throw new MFS_Exception(Label.SA_No_records_found);
            }else{
                setLevelLists(salesWrapperList);
            }
        }catch(Exception e){
            system.debug('Exception in getSalesAssetsList: '+e.getStackTraceString());
            system.debug('Exception is : '+e.getMessage());
            if(e.getMessage().equals(Label.SA_Blank_MDM)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SA_Blank_MDM);
                ApexPages.addMessage(myMsg); 
            }else if(e.getMessage().containsIgnoreCase(MFS_AllConstants.ListRowAssignmentError) || e.getMessage().equals(Label.SA_No_records_found)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SA_No_records_found);
                ApexPages.addMessage(myMsg);
            }
        }        
    }
    
    //To restrict SQL Injection
    public String getSelectedTableName(String tableName){
        if(tableName !=null && tableName.equalsIgnoreCase(MFS_AllConstants.LevelTotal)){
            return MFS_AllConstants.LevelTotal;
        }else if(tableName !=null && tableName.equalsIgnoreCase(MFS_AllConstants.SelectedCatIndividual)){
            return MFS_AllConstants.SelectedCatIndividual;
        }else if(tableName !=null && tableName.equalsIgnoreCase(MFS_AllConstants.SelectedCatPartnership)){
            return MFS_AllConstants.SelectedCatPartnership;
        }else return MFS_AllConstants.SelectedCatTeam;
    }
    
    //Set the asset levels Lists/Maps
    public void setLevelLists(List<MFS_SalesAssetsWrapper> salesWrapperList){
        for(MFS_SalesAssetsWrapper slw:salesWrapperList){
            if(slw.Level.equalsIgnoreCase(MFS_AllConstants.LevelProductVehicle)){productVehicleList.add(slw);}
            if(slw.Level.equalsIgnoreCase(MFS_AllConstants.LevelProduct)){productList.add(slw);}
            if(slw.Level.equalsIgnoreCase(MFS_AllConstants.LevelShareClass)){
                if(slw.PortfolioId != null){
                    List<MFS_SalesAssetsWrapper> swList = levelThreeMap.get(slw.PortfolioId);
                    if(swList !=null ){
                        swList.add(slw); 
                    } else {
                        swList = new List<MFS_SalesAssetsWrapper>();
                        swList.add(slw);
                    }
                    levelThreeMap.put(slw.PortfolioId,swList);                
                } 
            } 
        }
        sWrapperTot = MFS_Utilities.swTotalforAssign;
    }
    
    //Getter method for Category dropdown
    public List<SelectOption> getCategory(){
        List<SelectOption> options = new List<SelectOption>();
        for (String s: lstSalesType)
            options.add(new SelectOption(s,s));
        return options;               
    }
    
}