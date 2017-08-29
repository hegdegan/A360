/**
Apex Class Name    : MFS_CampaignTriggerHandler
Version            : 1.0 
Created Date       : 09 Aug 2016
Function           : Handler class that gets called by Campaign Trigger 
when Campaign records are cloned
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              09/08/2016              Original Version
**/
public class MFS_CampaignTriggerHandler {
    
    
    //Fetch the id of the original campaign record to copy the campaign members after insert 
    public static void afterInsertCampaignHandler(List<Campaign> campList){
        String userEmail = UserInfo.getUserEmail();        
        if(!campList.isEmpty() ){
            for(Campaign cm : campList){
                if(String.isNotEmpty(cm.Original_Campaign__c)) {
                 Database.executeBatch(new MFS_CampaignCloneBatch(cm, userEmail));
                }
            }         
        }
    }
    //Check if same Business driven campaign is already present for the user 
    public static void beforeInsertCampaignHandler(List<Campaign> campList){
        MFS_CampaignUtilities.beforeInsertValidationForLinkPointCampaignName(campList);
    }
}