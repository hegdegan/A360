public class MFS_UserTriggerUtilities {
    
    public static List<Campaign> getCampaignListForUsers(Map<Id, User> useMap){
        List<Campaign> campList = new List<Campaign>();
        Campaign camp;
        Set<Id> profileIdSet = new Set<Id>();
        for(User user : useMap.values()){
            profileIdSet.add(user.ProfileId);
        }
        RecordType rt = [select id from RecordType where DeveloperName='Business_Driven' and SobjectType='Campaign' LIMIT 1];
        Map<Id,Profile> profileMap = new Map<Id,Profile>([Select Id, Name from Profile where id in : profileIdSet]);
        Profile profile;
        for(User user : useMap.values()){
            profile = profileMap.get(user.ProfileId);
            if(System.Label.Profile_names_for_users_for_campaign.containsIgnoreCase(profile.Name)){
                camp = new Campaign(ownerId=user.Id, Name=System.Label.Default_campaign_name_for_user_for_Linkpoint,
                                    recordTypeId=rt.Id,Content_Type__c='Contact',Description__c=System.Label.Default_campaign_name_for_user_for_Linkpoint,
                                    Status='In-Progress',StartDate=System.today(),Campaign_Objective__c=System.Label.Default_campaign_name_for_user_for_Linkpoint,
                                    Target_Audience__c=System.Label.Default_campaign_name_for_user_for_Linkpoint, Campaign_Delivery__c='ContactSync', EndDate=null);  
                campList.add(camp);   
            }
        }
        system.debug('Size of campaign list in the User utility : '+campList.size());
        return campList;
    }
    
    @future
    public static void insertCampaignListForUsers(Set<Id> userId){
        List<Campaign> campList = new List<Campaign>();
        Campaign camp;
        RecordType rt = [select id from RecordType where DeveloperName='Business_Driven' and SobjectType='Campaign' LIMIT 1];
        for(Id user : userId){
            camp = new Campaign(ownerId=user, Name=System.Label.Default_campaign_name_for_user_for_Linkpoint,
                                recordTypeId=rt.Id,Content_Type__c='Contact',Description__c=System.Label.Default_campaign_name_for_user_for_Linkpoint,
                                Status='In-Progress',StartDate=System.today(),Campaign_Objective__c=System.Label.Default_campaign_name_for_user_for_Linkpoint,
                                Target_Audience__c=System.Label.Default_campaign_name_for_user_for_Linkpoint, Campaign_Delivery__c='ContactSync', EndDate=null);  
            campList.add(camp);   
        }
        insert campList;
    }
    
    @future
    public static void deleteCampaigns(Set<Id> campList){
        delete [select id from Campaign where id IN :campList];
    }
    
}