/***************************************************************************************************
Apex Class Name    : MFS_OpportunityAdditionalFlows 
Version            : 1.0 
Created Date       : 29 June 2016
Function           : Class is used to clone an opportunity
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               29/06/2016              Original Version
Ganesh Hegde              08/07/2016              Added 2 parameters to URL. Need to remove hardcoded values
***************************************************************************************************/

public with sharing class MFS_OpportunityAdditionalFlows {
    private Opportunity oppRec;
    public Boolean isError{get;set;}
    
    //Constructor    
    public MFS_OpportunityAdditionalFlows(ApexPages.StandardController controller) {
        try{
            oppRec=[Select Id,Name,StageName from Opportunity where id=:String.escapeSingleQuotes(controller.getRecord().id)];
        } catch(Exception exe) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
        }
        
    }
    
    /**
    * @Description : Method used to redirect user to apporipate page based on opportunity stage
    * @Param : N/A
    * @return: PageReference
    **/   
    public  pagereference  redirect(){
        PageReference cloneURL;
        try { 
            if(oppRec.StageName==MFS_ALLConstants.STATUS_FUNDED) {
                List<String> listOfFields=new List<String>{'Original_Opportunity__c'};
                    Map<String,String> fieldMap=MFS_Utilities.getFieldId('Opportunity',listOfFields);            
                cloneURL = new PageReference('/'+oppRec.Id+'/e?clone=1');
                cloneURL.setRedirect(true);
                cloneURL.getParameters().put(MFS_AllConstants.RETURN_URL, MFS_AllConstants.SLASH+oppRec.Id);                
                cloneURL.getParameters().put(fieldMap.get(listOfFields.get(0)), oppRec.Name);
                cloneURL.getParameters().put(fieldMap.get(listOfFields.get(0))+MFS_AllConstants.LK_ID, oppRec.Id);
            } else {
                cloneURL=null;
                isError=true;
            }
        } catch(Exception exe) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
        }
        return cloneURL;
    }
    
}