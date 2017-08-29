/***************************************************************************************************
Apex Class Name    : MFS_BusinessAtRiskRedirectController
Version            : 1.0 
Created Date       : 12 AUG 2016
Function           : This is a Controller for MFS_BusinessAtRiskRedirect Page
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            08/12/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_BusinessAtRiskRedirectController {
    private static String INSTITUTIONAL = 'Institutional';
    private static String RETAIL = 'Retail';
    private static String RETURL = 'retURL';
    Id accId;
    String url;
    private Business_At_Risk__c bar;
    public MFS_BusinessAtRiskRedirectController(ApexPages.StandardController controller) {
        bar = (Business_at_Risk__c)controller.getRecord();
        url = ApexPages.currentPage().getURL();
    }
    
    //Open Institutional/retail page depending on record type
    public PageReference redirect() {
        try{
            accId=bar.Organization__c;
            
            if(accId==null) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.BAR_Info_Message));
                return null;
            }
            else {
                Account acc = [select recordtypeId from account where id =:accId];
                //Get the current user's profile name
                String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
                String currentRecType = [select Name from RecordType where id = :acc.RecordTypeId].Name;
                if(currentRecType.Contains(INSTITUTIONAL)) {
                    return new PageReference( '/apex/MFS_BusinessAtRisk?account='+accId);
                }
                else if(currentRecType.Contains(RETAIL)) {
                    return new PageReference( '/apex/MFS_BusinessAtRiskRetail?account='+accId);
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.BAR_Info_Message2));
                    return null;
                }
            }
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.Generic_Error));
            return null; 
        }
    }
    
    //Redirect to correct page when detail link is clicked
    public PageReference redirectDetail() {
        //Get the record type
        try{
            Business_At_Risk__c barType = [select type__c from Business_At_Risk__c where id=:bar.id];
            if(barType!=null && barType.type__c==INSTITUTIONAL) {
                if(url.containsIgnoreCase(RETURL))
                    return new PageReference( '/apex/MFS_BusinessAtRiskUpdate?id='+bar.id+'&type=edit');
                else
                    return new PageReference( '/apex/MFS_BusinessAtRiskUpdate?id='+bar.id);
            }
            else {
                if(url.containsIgnoreCase(RETURL))
                    return new PageReference( '/apex/MFS_BusinessAtRiskRetailUpdate?id='+bar.id+'&type=edit');
                else
                    return new PageReference( '/apex/MFS_BusinessAtRiskRetailUpdate?id='+bar.id);
            }
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.Generic_Error));
            return null;
        }
    }
}