/***************************************************************************************************
Apex Class Name    : MFS_OpportunityHandler
Version            : 1.0 
Created Date       : 16 JUL 2016
Function           : This is a handler class for MFS_OpportunityTrigger
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            07/16/2016              Original Version
* Priya Gupta			 02/14/2017				  Added code to Add\Remove Opportunity Owner from Opportunity Team
***************************************************************************************************/
public class MFS_OpportunityHandler {
    
    public static void afterInsertEventHandler(List<Opportunity> newList)
    {
        //add owner to opportunity team
        try
        {
            List<OpportunityTeamMember> opptyTeam = new List<OpportunityTeamMember>();
            Set<Id> userIds = new Set<Id>();
            Set<Id> accountIds = new Set<Id>();
                
            Id IntegrationProfileId = MFS_Utilities.GetAppSettingValue(Application_Settings__c.getAll(), 'IntegrationProfileId', System.Label.MFS_Integration_Profile_ID);//Added on 14/Feb/2017 
            Id recTypeId = [select id from recordtype where DeveloperName='Retail_Professional_Buyer' AND sobjecttype='Opportunity' LIMIT 1].Id;
    
            for(Opportunity oppty : newList)
            {
                userIds.add(oppty.ownerId);
                if(oppty.recordTypeId == recTypeId)
                {
                    accountIds.add(oppty.accountId);
                }
            }
    
            //Added profileId filter on 14/Feb/2017
            Map<Id, User> userMap = 
                new Map<Id, User>([select id, User_Role__c,profileId from User where ID IN :userIds AND profileId!=:IntegrationProfileId]);

            for(Opportunity oppty : newList)
            {
                if(Null!=userMap.get(oppty.OwnerId))
                opptyTeam.add(MFS_OpportunityUtilities.insertOpptyTeamMember(oppty, userMap));
            }
    
            if(!opptyTeam.isEmpty()) //Added on 14/Feb/2017
            {
                insert opptyTeam;
            }
            
            //call Utility class to add AccountTeamMember as OpportunityTeamMember
            List<OpportunityTeamMember> oppTeamMemList = MFS_OpportunityUtilities.insertAccTeamMemberAsOppTeam(newList,IntegrationProfileId);
            if(!oppTeamMemList.isEmpty()) //Added on 14/Feb/2017
            {
            	Database.SaveResult[] insOppTeamMem = Database.insert(oppTeamMemList,false);
            }
        }
        catch(Exception e)
        {
            System.debug('Exception occured==:'+e.getMessage()+e.getLineNumber());
        }
    }  
    
    
    //If Organization is changed for the existing Opportunity then call Utility class methods to push AccountTeamMember to OpportunityTeamMember OR 
    //if CloseDate or Notification Date is changed then create a follow up task
    public static void afterUpdateEventHandler(Map<Id,Opportunity> newMap,Map<Id,Opportunity> oldMap){
        Id IntegrationProfileId = MFS_Utilities.GetAppSettingValue(Application_Settings__c.getAll(), 'IntegrationProfileId', System.Label.MFS_Integration_Profile_ID);//Added on 14/Feb/2017 
        List<Opportunity> oppList = new List<Opportunity>([Select Id,Name,AccountId,Notification_Date__c,CloseDate,StageName,OwnerId from opportunity where Id in : newMap.KeySet()]);
        List<Opportunity> opptyList = new List<Opportunity>();
        List<Task> followUpTaskList = new List<Task>();
        List<Activity_Detail__c> activityDetailList = new List<Activity_Detail__c>();        
        for(Opportunity opp : oppList){
            Opportunity oppNew = newMap.get(opp.Id);
            Opportunity oppOld = oldMap.get(opp.Id);            
            if(oppNew.AccountId != oppOld.AccountId){
                opptyList.add(oppNew);
            } 
            
            //if CloseDate or Notification Date is changed then create a follow up task
            if( oppNew.StageName =='In Progress' && ((oppNew.Notification_Date__c != oppOld.Notification_Date__c) || (oppNew.CloseDate != oppOld.CloseDate))){
                Task t = new Task();
                t.OwnerId = opp.OwnerId;
                t.Status = 'In Progress';
                t.Subject = 'Follow Up - ' + opp.Name;
                t.ActivityDate = opp.Notification_Date__c;
                t.WhatId = opp.Id;                
                Activity_Detail__c ad = new Activity_Detail__c();
                ad.Subject__c = t.Subject;
                ad.Not_An_Orphan_Record__c = true;                
                activityDetailList.add(ad);
                followUpTaskList.add(t);
            } 

        }
        
        if(oppList.size()>0){
            List<OpportunityTeamMember> oppTeamMemList = MFS_OpportunityUtilities.insertAccTeamMemberAsOppTeam(opptyList,IntegrationProfileId);
            if(!oppTeamMemList.isEmpty())//Added on 14/Feb/2017
            Database.SaveResult[] insOppTeamMem = Database.insert(oppTeamMemList,false);
        }
        if(activityDetailList.size() > 0){
            insert activityDetailList;
            
            if(followUpTaskList.size() > 0){
                insert followUpTaskList;
            }
        }
        //Changes done on 14/Feb/2017
        List<Opportunity> opptyOwnerChangeList = new List<Opportunity>();
        Map<Id,Id> opptyOwnerMap = new Map<Id,Id>();
        Map<Id,Id> opptyOldOwnerMap = new Map<Id,Id>();
        Map<Id,Id> opptyAccountMap = new Map<Id,Id>();
        for(Opportunity opp : oppList){
            Opportunity oppNewRec = newMap.get(opp.Id);
            Opportunity oppOldRec = oldMap.get(opp.Id);  
            if(oppNewRec.OwnerId!=oppOldRec.OwnerId)
            {             
                opptyOwnerMap.put(oppNewRec.Id,oppNewRec.OwnerId);
                opptyOldOwnerMap.put(oppNewRec.Id,oppOldRec.OwnerId);
                opptyAccountMap.put(oppNewRec.Id,oppNewRec.AccountId);
            }
        }
        try{
            If(!opptyOwnerMap.isEmpty())
            { 
             List<OpportunityTeamMember> updateOTMemList=MFS_OpportunityUtilities.addOppOwner(opptyOwnerMap,IntegrationProfileId); 
                if(!updateOTMemList.isEmpty())
            	 insert updateOTMemList;
            }
             If(!opptyOldOwnerMap.isEmpty())
            {
             List<OpportunityTeamMember> membersToDelete=MFS_OpportunityUtilities.removeOppOwner(opptyOldOwnerMap,opptyAccountMap); 
                if(!membersToDelete.isEmpty())
            	 delete  membersToDelete;
            }
        }
        catch(Exception exe)
        {
            System.debug('Exception Occured:'+exe.getMessage()+exe.getLineNumber());
        }
       }
}