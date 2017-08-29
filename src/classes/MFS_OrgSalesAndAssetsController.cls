/**
Apex Class Name    : MFS_OrgSalesAndAssetsController
Version            : 1.0 
Created Date       : 26 Jun 2016
Function           : Controller class to do operation for Org Sales and Assets data  
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Manoj Parida              26/06/2016              Original Version
**/
public with sharing class MFS_OrgSalesAndAssetsController {
    
    private String mdmId;
    public string userCurrency{get;set;}
    public string userCurrencySymbol{get;set;}
    public List<MFS_SalesAssetsWrapper> levelOneList {get;set;}
    public List<MFS_SalesAssetsWrapper> levelTwoList {get;set;}
    public List<MFS_SalesAssetsWrapper> levelThreeList {get;set;}
    public Map<String,List<MFS_SalesAssetsWrapper>> levelTwoMap {get;set;}
    public Map<String,List<MFS_SalesAssetsWrapper>> levelThreeMap {get;set;}
    public MFS_SalesAssetsWrapper sWrapperTotal {get;set;}
    public List<MFS_SalesAssetsWrapper> salesWrapperList;
    public List<String> lstSalesType{get;set;}
    public String selectedCategory {
        get{ return selectedCategory;}
        
        set{selectedCategory = value;}
    }
    public string selectedCurrency{get;set;}
    private String pageName;
    
    //Constructor
    public MFS_OrgSalesAndAssetsController(ApexPages.StandardController controller){
        Id accId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('accId:::'+accId);  
        try{
            if(accId != null){          
                Account acc = [select MDM_Id__c from Account where id = : accId];
                mdmId = acc.MDM_Id__c;
                selectedCategory = MFS_AllConstants.MyCurr;
            }          
            userCurrency = UserInfo.getDefaultCurrency();
            userCurrencySymbol = MFS_Utilities.getCurrSymbol(userCurrency);
            if(userCurrencySymbol == null || ''.equals(userCurrencySymbol)){
                userCurrency = MFS_AllConstants.USDCurr;
                userCurrencySymbol = MFS_AllConstants.USDCurrSymbol;
            }
            if(MFS_Utilities.GetAppSettingValue('EnableShareClSearchByName','No').equalsIgnoreCase('Yes')){
                MFS_Utilities.getShareClassIdMap(); 
            }
            lstSalesType = new List<String>{MFS_AllConstants.Mycurr, MFS_AllConstants.ClientCurr};
        } catch(Exception e){
            system.debug('Exception in : '+e.getStackTraceString());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.Generic_Error);
            ApexPages.addMessage(myMsg);
        } 
    }   
    
    //Inititalize all Lists/Maps
    public void inititalizeAllListsAndMaps(){
        levelOneList = new List<MFS_SalesAssetsWrapper>();
        levelTwoList = new List<MFS_SalesAssetsWrapper>();
        levelThreeList = new List<MFS_SalesAssetsWrapper>();
        levelTwoMap = new Map<String,List<MFS_SalesAssetsWrapper>>();
        levelThreeMap = new Map<String,List<MFS_SalesAssetsWrapper>>();
        salesWrapperList = new List<MFS_SalesAssetsWrapper>();
    }
    
    /**
* @Description : Method is used to get Org Institutional Sales and Assets records
* @Param : None
* @return: void
**/ 
    public void getSalesAssetsListForInstitutional(){ 
        try{
            if(mdmId == null || ''.equals(mdmId)){
                throw new MFS_Exception(Label.SA_Blank_MDM);
            }
            //Initialize the drop down
            if(lstSalesType == null){
              lstSalesType = new List<String>{MFS_AllConstants.Mycurr, MFS_AllConstants.ClientCurr};  
            }            
            inititalizeAllListsAndMaps();
            pageName = MFS_AllConstants.OrgInsSalesPage;
            sWrapperTotal = new MFS_SalesAssetsWrapper();
            if(selectedCategory.equals(MFS_AllConstants.ClientCurr)){
                selectedCurrency = MFS_AllConstants.ClientCurrPlaceHolder;
                String exObjName = AssetPageAndTableSettings__c.getAll().get(pageName).TableName__c;
                userCurrency = MFS_Utilities.getClientReportingCurr(exObjName,mdmId);
                userCurrencySymbol = MFS_Utilities.getCurrSymbol(userCurrency);
            }
            //When switching back from Client curr to my Curr.
            else {
                userCurrency = UserInfo.getDefaultCurrency();
                userCurrencySymbol = MFS_Utilities.getCurrSymbol(userCurrency);
            }
            salesWrapperList =  MFS_Utilities.GetMFS_SalesAssetsWrapperList(mdmId, pageName, userCurrency,MFS_AllConstants.OrgInsExId );  
            if(salesWrapperList.size() == 0){
                throw new MFS_Exception(Label.SA_No_records_found);
            }
            createLevelList(pageName,salesWrapperList);   
        } catch(Exception e){
            logException(e);
        }
    }
    
    /**
* @Description : Method is used to get Org Retail Sales and Assets records
* @Param : None
* @return: void
**/ 
    public void getSalesAssetsListForRetail(){
        try{
            if(mdmId == null || ''.equals(mdmId)){
                throw new MFS_Exception(Label.SA_Blank_MDM);
            }
            inititalizeAllListsAndMaps();
            pageName = MFS_AllConstants.OrgRetSalesPage;
            salesWrapperList =  MFS_Utilities.GetMFS_SalesAssetsWrapperList(mdmId, pageName, userCurrency, MFS_AllConstants.OrgRetExId ); 
            if(salesWrapperList.size() == 0){
                throw new MFS_Exception(Label.SA_No_records_found);
            }
            createLevelList(pageName,salesWrapperList);
        }catch(Exception e){
            logException(e);
        }
    }  
    
    /**
* @Description : Method is used to get Org Consultant Sales and Assets records
* @Param : None
* @return: void
**/ 
    public void getSalesAssetsListForConsultant(){  
        try{
            if(mdmId == null || ''.equals(mdmId)){
                throw new MFS_Exception(Label.SA_Blank_MDM);
            }
            inititalizeAllListsAndMaps();
            pageName = MFS_AllConstants.OrgConSalesPage;
            salesWrapperList =  MFS_Utilities.GetMFS_SalesAssetsWrapperList(mdmId, pageName, userCurrency, MFS_AllConstants.OrgConsExId ); 
            if(salesWrapperList.size() == 0){
                throw new MFS_Exception(Label.SA_No_records_found);
            }
            createLevelList(pageName,salesWrapperList);
        } catch(Exception e){
			logException(e);
        }
    }
    
    //Common Exception Method
    public void logException(Exception e){
        system.debug('Exception in MFS_OrgSalesAndAssetsController : '+e.getMessage());
        system.debug('Exception stackTrace : '+e.getStackTraceString());
            if(e.getMessage().equals(Label.SA_Blank_MDM)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SA_Blank_MDM);
                ApexPages.addMessage(myMsg); 
            }else if(e.getMessage().equals(Label.SA_No_records_found)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.SA_No_records_found);
                ApexPages.addMessage(myMsg);
            }
    }
    
    /**
* @Description : Method is used to create lists for 3 levels in the Sales and Assets UI.
* @Param : None
* @return: void
**/     
    public void createLevelList(String page,List<MFS_SalesAssetsWrapper> salesWrapperList){
        //Assign Total level to a separate variable
        sWrapperTotal =  MFS_Utilities.swTotalforAssign;
        Integer i = 0;
        if(salesWrapperList != null && salesWrapperList.size()>0){
            //Create Level Lists for Org Institutional Sales
            if(page != null && page.equalsIgnoreCase(MFS_AllConstants.OrgInsSalesPage)){
                for(MFS_SalesAssetsWrapper slw:salesWrapperList){
                    if(slw != null && slw.Level.equalsIgnoreCase(MFS_AllConstants.LevelPlan)){levelOneList.add(slw);}
                    if(slw != null && slw.Level.equalsIgnoreCase(MFS_AllConstants.LevelPortfolio)){levelTwoList.add(slw);}
                }
            } 
            //Create Level Lists/Maps for Org Retail Sales
            else if(page != null && page.equalsIgnoreCase(MFS_AllConstants.OrgRetSalesPage)){
                for(MFS_SalesAssetsWrapper slw:salesWrapperList){
                    if(slw != null && slw.Level.equalsIgnoreCase(MFS_AllConstants.LevelProductVehicle)){levelOneList.add(slw);}
                    if(slw != null && slw.Level.equalsIgnoreCase(MFS_AllConstants.LevelProduct)){
                        slw.row = i;
                        levelTwoList.add(slw);
                        i++;
                    }
                    if(slw != null && slw.Level.equalsIgnoreCase(MFS_AllConstants.LevelShareClass)){
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
            } 
            //Create Level Lists/Maps for Org Consultant Sales
            else {
                for(MFS_SalesAssetsWrapper slw:salesWrapperList){
                    if(slw != null && slw.Level.equalsIgnoreCase(MFS_AllConstants.LevelProduct)){levelOneList.add(slw);}
                    if(slw != null && slw.Level.equalsIgnoreCase(MFS_AllConstants.LevelProductVehicle)){
                        if(slw.VehicleName != null){
                            slw.secondLevelGroup = slw.VehicleName+'_'+i;
                            i++;
                        }
                        if(slw.PortfolioId != null){
                            List<MFS_SalesAssetsWrapper> swList = levelTwoMap.get(slw.PortfolioId);
                            if(swList !=null ){
                                swList.add(slw); 
                            } else {
                                swList = new List<MFS_SalesAssetsWrapper>();
                                swList.add(slw);
                            }
                            levelTwoMap.put(slw.PortfolioId,swList);                
                        }
                    }
                    if(slw != null && slw.Level.equalsIgnoreCase(MFS_AllConstants.LevelOrg)){
                        if(slw.productVehicleId != null && slw.PortfolioId != null){
                            List<MFS_SalesAssetsWrapper> swList = levelThreeMap.get(slw.PortfolioId+'#'+slw.productVehicleId);
                            if(swList !=null ){
                                swList.add(slw); 
                            } else {
                                swList = new List<MFS_SalesAssetsWrapper>();
                                swList.add(slw);
                            }
                            levelThreeMap.put(slw.PortfolioId+'#'+slw.productVehicleId,swList);                
                        } 
                    }
                }               
            }
        }
    }
    //Generate drop down
    public List<SelectOption> getCategory(){
        List<SelectOption> options = new List<SelectOption>();
        for (String s: lstSalesType)
            options.add(new SelectOption(s,s));
        return options;               
    }
    
}