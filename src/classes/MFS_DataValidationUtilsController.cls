public class MFS_DataValidationUtilsController {

    public String selectedObject { get; set; }
    public String selectedField { get; set; }
    public String selectedPicklistField { get; set; }
    public List<String> requiredFields=new List<String>();
    public List<String> picklistFields=new List<String>();
    public List<String> picklistValues=new List<String>();
    //sObject tokens
    //public Map<String,Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    //get result for selected object
    //public Schema.DescribeSObjectResult dsr = Schema.getGlobalDescribe().get(selectedObject).getDescribe();
    //get fieldmap    
    //public Map<String,Schema.SObjectField> fieldMap = dsr.fields.getMap();
    //get result
    //public Schema.DescribeFieldResult dfr = fieldmap.get(selectedPicklistField).getDescribe();
    //get picklist values
    //public List<Schema.PickListEntry> pvalue = dfr.getPicklistValues();      

 //generate list of Objects from the Org using Dynamic Apex
   
    public SelectOption[] getObjectOptions() {
        SelectOption[] results = new SelectOption[] { new SelectOption('','-- none --') };
        for(SObjectType sobjectType: Schema.getGlobalDescribe().values()) {
            DescribeSObjectResult dsrao = sobjectType.getDescribe();
            results.add(new SelectOption(dsrao.getName(), dsrao.getName()));
            results.sort();
        }
        return results;    
    }

 //generate list of Fields from the Object using Dynamic Apex
   
    public SelectOption[] getFieldOptions() {
        SelectOption[] results = new SelectOption[] { new SelectOption('','-- none --') };
        if(selectedObject != null) {
            for(SObjectField sObjectField: Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap().values()) {
                DescribeFieldResult dfr = sObjectField.getDescribe();
                results.add(new SelectOption(dfr.getName(), dfr.getLabel()));
                results.sort();
            }
        }
        return results;
    }

 //generate list of RequiredFields from the Object,Required= is Creatable AND is NOT Nillable AND is NOT Defaulted On Create
   
    public List<String> getRequiredFields(){
        if(selectedObject != NULL){
            requiredfields = new List<String>();
            Schema.DescribeSObjectResult dsr = Schema.getGlobalDescribe().get(selectedObject).getDescribe();
            Map<String,Schema.SObjectField> fieldMap = dsr.fields.getMap();
            for(String fieldName : fieldMap.keySet()) { 
                Schema.SObjectField field = fieldMap.get(fieldName);
                Schema.DescribeFieldResult dfr = field.getDescribe();
                if( dfr.isCreateable()  && !dfr.isNillable() && !dfr.isDefaultedOnCreate()){
                  requiredfields.add(fieldName);
                }   
                system.debug('==>requiredfields==>'+requiredfields);
            }
            return requiredfields;          
        }
        return NULL;
    }
    
 //generate list of Picklistvalues from the Picklist selected
     
    public List<String> getPicklistValues(){
        pickListValues.clear();
        if(selectedPicklistField != NULL && selectedObject != NULL){
            Schema.DescribeSObjectResult dsr = Schema.getGlobalDescribe().get(selectedObject).getDescribe();
            Map<String,Schema.SObjectField> fieldMap = dsr.fields.getMap();
            Schema.SObjectField field = fieldMap.get(selectedPicklistField);
            Schema.DescribeFieldResult dfr = field.getDescribe();
            List<Schema.PickListEntry> picks = dfr.getPicklistValues();
            for(Schema.picklistentry v:picks){
                pickListValues.add(v.getValue());
            }
        return picklistValues;
        }
        return picklistValues;
    }
       
 //generate list of names of PicklistFields and MultiPicklistFields from the Object
    
    public List<String> getPicklistFields(){
        picklistfields.clear();
        if(selectedObject != NULL){
            Schema.DescribeSObjectResult dsr = Schema.getGlobalDescribe().get(selectedObject).getDescribe();
            Map<String,Schema.SObjectField> fieldMap = dsr.fields.getMap();
            for(String fieldName : fieldMap.keySet()){ 
                Schema.SObjectField field = fieldMap.get(fieldName);
                Schema.DescribeFieldResult dfr = field.getDescribe();
                if( dfr.getType()==Schema.DisplayType.Picklist || dfr.getType()==Schema.DisplayType.MultiPicklist ) {
                      picklistfields.add(fieldName);
                }   
                system.debug('==>picklistfields==>'+picklistfields);
            }
            return picklistfields;          
        }
        return NULL;
    }
    
 //generate list of PicklistFields from the Object as a dropdown
   
    public SelectOption[] getPicklistFieldOptions() {
        SelectOption[] results = new SelectOption[] { new SelectOption('','-- none --') };
        if(selectedObject != null) {
            for(SObjectField sObjectField: Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap().values()) {
                DescribeFieldResult dfr = sObjectField.getDescribe();
                if( dfr.getType()==Schema.DisplayType.Picklist || dfr.getType()==Schema.DisplayType.MultiPicklist ) {
                    results.add(new SelectOption(dfr.getName(), dfr.getLabel()));
                    results.sort();
                }
            }
        }
        return results;
    } 
    
  }