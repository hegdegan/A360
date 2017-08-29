/**
Apex Class Name    : MFS_EventTriggerHandler
Version            : 1.0 
Created Date       : 11 MAY 2016
Function           : Handler class that gets called by Event Triggers 
when Event are created,updated and deleted
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Rupesh Shiramalla           3/14/2017              Original Version
**/

public class MFS_UserTriggerHandler {
    
    public static void processUserEmailRecords(list<user> userList){
        for(User uObj: userList){
            if(uObj.isActive && uObj.Email.endsWith('@mfs.com') && uObj.LastLoginDate == null && uObj.IsNotValidUser__c)
                uObj.isActive = false;
        }
    }
    
    //Added for new campaign record creation per user
    public static void createCampaignOnUserCreation(Map<Id, User> newUserMap){
        try{
            system.debug('Entering in createCampaignOnUserCreation : '); 
            List<Campaign> campList = new List<Campaign>();
            Set<Id> campIds = new Set<Id>();
            campList = MFS_UserTriggerUtilities.getCampaignListForUsers(newUserMap);
            if(campList != null && campList.size() > 0){
                try{
                    DataBase.SaveResult[] results = Database.insert(campList, false);
                    for (Database.SaveResult sr : results) {
                        if (sr.isSuccess()){
                            Id campaignId = sr.getId();
                            campIds.add(campaignId);
                        }
                    }
                }catch(Exception e){
                    system.debug('Exception in createCampaignOnUserCreation : '+e.getStackTraceString());  
                }
                if(Test.isRunningTest()){
                    if(campIds.size() > 0){
                        List<Campaign> campListafterInsert = new List<Campaign>([select id, Name, OwnerId from Campaign where Id in : campIds]);
                        for(Campaign camp : campListafterInsert){
                            system.debug('User id and Name of Campaign : '+camp.OwnerId + ' ' + camp.Name + ' ' + camp.Id);
                        }
                    }
                }
            }
        }catch(Exception e){
            System.debug('Exception in createCampaignOnUserCreation of MFS_UserTriggerHandler : '+e.getStackTraceString());
        }
    }
    
    public static void updateUserCampaign(Map<Id, User> newUserMap, Map<Id, User> oldUserMap){
        Set<Id> eligibleUsers = new Set<Id>();
        Set<Id> deleteCampaign = new Set<Id>();
        Set<Id> profileIdSet = new Set<Id>();
        for(User user : newUserMap.values()){
            profileIdSet.add(user.ProfileId);
        }
        Map<Id,Profile> profileMap = new Map<Id,Profile>([Select Id, Name from Profile where id in : profileIdSet]);
        Profile profile;
        for(User usr : newUserMap.values()){
            profile = profileMap.get(usr.ProfileId);
            if(usr.IsActive != oldUserMap.get(usr.Id).isActive && System.Label.Profile_names_for_users_for_campaign.containsIgnoreCase(profile.Name)){
                if(usr.isActive == TRUE)
                    eligibleUsers.add(usr.Id);
                else
                    deleteCampaign.add(usr.Id);                    
            }
        }
        if(eligibleUsers.size() > 0){
            MFS_UserTriggerUtilities.insertCampaignListForUsers(eligibleUsers);
        }
        if(deleteCampaign.size() > 0){
            Map<Id, Campaign> campMap = new Map<Id, Campaign>([select id from Campaign where ownerId IN :deleteCampaign AND Content_Type__c = 'Contact' AND recordtype.DeveloperName = 'Business_Driven' AND Name= 'ContactSync' ]);
            MFS_UserTriggerUtilities.deleteCampaigns(campMap.keySet());
        }
        
    }
}