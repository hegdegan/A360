/**
Apex Class Name    : MFS_EventUtilities
Version            : 1.0 
Created Date       : 09 Aug 2016
Function           : Utility class that gets called by Campaign Triggers 
when campaign records are cloned
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              09/08/2016              Original Version
**/
public class MFS_CampaignUtilities {
    //Copy Campaign members from the Original Campaign
    public static List<CampaignMember> cloneCampaignMembers(List<Campaign> newCampList, Set<Id> campId){
        List<CampaignMember> cmem = new List<CampaignMember>();
        List<CampaignMember> cmemAddToList = new List<CampaignMember>();
        try {
            if(!newCampList.isEmpty() && campId.size()>0) {
                cmem = [Select Id,FirstName,LastName,Status,Type,ContactId,LeadId 
                        from CampaignMember where campaignId in : campId];
                for(Campaign cmpn : newCampList){
                    for(CampaignMember cmpnmem : cmem){
                        CampaignMember campMem = cmpnmem.clone(false,true);
                        campMem.campaignId = cmpn.Id;
                        cmemAddToList.add(campMem);
                    }
                }
            }
        }catch(Exception ex){
            System.debug('Exception occured:'+ex.getMessage());
        }
        return cmemAddToList; 
    }
    //Check if same Business driven campaign is already present for the user
    public static void beforeInsertValidationForLinkPointCampaignName(List<Campaign>  newCampList){
        Set<Id> userIdSet = new Set<Id>();
        RecordType rt = [select id from RecordType where DeveloperName='Business_Driven' and SobjectType='Campaign' LIMIT 1];
        for( Campaign camp : newCampList ){
            if(camp.RecordTypeId.equals(rt.Id) && camp.Name.equals(System.Label.Default_campaign_name_for_user_for_Linkpoint)){
                userIdSet.add( camp.OwnerId );
            }
        } 
        Map<Id, String> duplicateCampaignMap = new Map<Id, String>();
        for( Campaign camp : [select Id, OwnerId, Name from Campaign where Name =: System.Label.Default_campaign_name_for_user_for_Linkpoint and 
                              RecordTypeId =: rt.Id and OwnerId IN :userIdSet] ){
            duplicateCampaignMap.put(camp.OwnerId, camp.Name) ;
        }
        for( Campaign camp : newCampList ){
            if(camp.RecordTypeId.equals(rt.Id) && !duplicateCampaignMap.isEmpty() && duplicateCampaignMap.containsKey(camp.OwnerId)){
                camp.addError(System.Label.Campaign_already_exists); 
            }
        }
    }
}