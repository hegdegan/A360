global class MFS_StrategyRatingController {
    public string searchString{get;set;} // search keyword
    public List<SearchWrapper> wraplist{get;set;} 
    public String selectedProductName { get; set; }
    public String selectedConsultantName { get; set; }
    public Boolean isInConsole { get; set; }
    public String searchOpt{
        set{searchOpt=value;}
        get{return searchOpt;}
    }
    public String selectedAssetGeography{
        get{return selectedAssetGeography;}
        set{selectedAssetGeography=value;}
    }
    public String selectedVehicle{
        get{return selectedVehicle;}
        set{selectedVehicle=value;}
    } 
    public MFS_StrategyRatingController() {
        // get the current search string
        searchString = System.currentPageReference().getParameters().get('lksrch');
        String url = ApexPages.CurrentPage().getURL();
        if(url!= null && url.containsIgnoreCase('isInConsole')){
            isInConsole = true;
        }
        User usr = [select Vehicle__c from User where id = :UserInfo.getUserId()];
        selectedVehicle = usr.Vehicle__c;
        wraplist = new List<SearchWrapper>();
        searchProduct();
    }
    public MFS_StrategyRatingController(ApexPages.StandardController controller){
        if(controller.getId() != null && UserInfo.getUiThemeDisplayed() != 'Theme3'){
            Strategy_Rating_Process__c srp = [select Product__r.Name, Consultant__r.Name from Strategy_Rating_Process__c where Id = :controller.getId()];
            selectedProductName = srp.Product__r.Name;
            selectedConsultantName = srp.Consultant__r.Name;
        }
    }
    
    // performs the keyword search
   
    // used by the visualforce page to send the link to the right dom element
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
    
    // used by the visualforce page to send the link to the right dom element for the text box
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
    
    //search product fro the modal
    public void searchProduct(){
        try{
            wraplist = new List<SearchWrapper>();            
            String query=constructQuery(searchOpt,selectedAssetGeography,selectedVehicle);
            List<Product2> pList = Database.query(query);                
            for(Product2 pbRec : pList){  
                wraplist.add( new SearchWrapper(false, pbRec, pbRec.ID, MFS_AllConstants.PRODUCT_ASSET_CLASS_GEOHRAPHY_VALUES.get(pbRec.Asset_Class_by_Geography__c))); 
            }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.A360_Error_Message_1 + ex.getMessage() +' - '+ ex.getLineNumber()));
        }
    }
    
    //Construct query for product search depending on user's entry
    @TestVisible
    private  String constructQuery(String productName,String productGeography,String productVehicle)
    {
        String query='Select Id,Strategy__r.Name,Name,Asset_Class_by_Geography__c,Vehicle__c,Restricted__c, Product_Record_Type__c from Product2 where IsActive=true and Is_Unknown__c =false and Restricted__c=false  '; //Asset_Class_Geography__c field is replace by Asset_Class_by_Geography__c on 01/Feb/2017
        if(productName!='' && productName!=null){
            //query=query+' AND Name like '+'\'%'+String.escapeSingleQuotes(productName)+ '%\' ';
            query=query+' AND (Strategy__r.Name like '+'\'%'+String.escapeSingleQuotes(productName)+ '%\''+' OR Name like '+'\'%'+String.escapeSingleQuotes(productName)+ '%\''+')';
        }
        if(productGeography!='None' && productGeography!=null && productGeography!=''){
            query=query+' AND Asset_Class_by_Geography__c ='+'\''+String.escapeSingleQuotes(productGeography)+'\' ';
        }
        if(productVehicle!='None' && productVehicle!=null && productVehicle!='')
        {
            query=query+' AND Vehicle__c='+'\''+String.escapeSingleQuotes(productVehicle)+'\' ';
            
        }
        if(query.EndsWith('AND ')) {
            query = query.removeEnd('AND ');
        }
        query=query+' ORDER BY Product_Record_Type__c,Strategy__r.Name,Name, Vehicle__c ASC Limit 25'; //Limit is changed on 01/Feb/2017
        return query;
    }
    
    //Method is used to get Asset Class-Geography picklist from Product2 object
    public List<Selectoption> getGeograhpyOptions(){
        List<Selectoption>  prodGeograhpy=new List<Selectoption> ();
        prodGeograhpy.add(new SelectOption(MFS_AllConstants.PICKLIST_DEFAULT,'---'+MFS_AllConstants.PICKLIST_DEFAULT+'---'));        
        map<String, Schema.SObjectField> fieldMap = Product2.getSObjectType().getDescribe().fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get(MFS_AllConstants.PRODUCT_GEOGRAPHY).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values)
        { 
            prodGeograhpy.add(new SelectOption(a.getValue(),a.getLabel())); 
        }
        return prodGeograhpy;
    }
    
    //Method is used to get Vehicle picklist from Product2 object  
    public List<Selectoption> getVehicleOptions(){
        List<Selectoption>  prodVehicleList=new List<Selectoption> ();
        prodVehicleList.add(new SelectOption(MFS_AllConstants.PICKLIST_DEFAULT,'---'+MFS_AllConstants.PICKLIST_DEFAULT+'---'));
        Schema.sObjectType objType = Product2.getSObjectType(); 
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> values =     fieldMap.get(MFS_AllConstants.PRODUCT_VEHICLE).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values)
        { 
            prodVehicleList.add(new SelectOption(a.getValue(),a.getLabel())); 
        }
        return prodVehicleList; 
    }
    
    //Set the variable when "add portfolio" is clicked from invitee section
    public void loadProducts(){
        User usr = [select Vehicle__c from User where id = :UserInfo.getUserId()];
        selectedVehicle = usr.Vehicle__c;
        selectedAssetGeography ='';
        searchOpt = '';
        searchProduct();
    }
    
    //Wrapper for Product Search and Competitor Product Search
    public class SearchWrapper{
        public Product2 prg {get;set;}
        public Id prodId{get;set;}
        public Boolean isSelected { get; set; }
        public String assetClassGeoName{get; set; }
        
        //Used for products
        public SearchWrapper( Boolean slct, Product2 pr, Id prId, String assetClassGeoName) {
            this.prg = pr;
            this.prodId = prId;
            this.isSelected = slct;
            this.assetClassGeoName = assetClassGeoName;
        }
    }
    
    //This method is usind in SLDS to populate lookup field
    @RemoteAction
    global static List<Account> queryAccounts(String keyword) {
        List<Account> accountList = new List<Account>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            accountList = [Select Id, Name from Account where Name like :keyword limit 5];
        }
        return accountList;
    }
}