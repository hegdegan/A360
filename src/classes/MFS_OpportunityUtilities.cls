/***************************************************************************************************
Apex Class Name    : MFS_OpportunityUtilities
Version            : 1.0 
Created Date       : 16 JUL 2016
Function           : This is a Utility class for MFS_OpportunityHandler
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            07/16/2016              Original Version
***************************************************************************************************/
public class MFS_OpportunityUtilities {
    
    //Method to insert Opportunity team member
    public static OpportunityTeamMember insertOpptyTeamMember(Opportunity oppty ,Map<Id, User> userMap){
        OpportunityTeamMember newOpptyTeam = new OpportunityTeamMember(UserId = oppty.OwnerId, TeamMemberRole = userMap.get(oppty.ownerId).User_Role__c,
                                                                       OpportunityId = oppty.Id, OpportunityAccessLevel = 'Edit');
        return newOpptyTeam;
    }
    //Remove Opp Owner from Opp Team  added on 14/feb/2017  
    public static List<OpportunityTeamMember> removeOppOwner(Map<Id,Id> oppOwnerMap,Map<Id,Id>oppAccOwner){       
        List<OpportunityTeamMember> oppTMToRemove=new List<OpportunityTeamMember>();
        Map<Id, Set<Id>> accountTMMap = new  Map<Id, Set<Id>>();
        Map<Id, List<OpportunityTeamMember>> oppTMMap = new  Map<Id, List<OpportunityTeamMember>>();
        for(AccountTeamMember accTM:[select Id,UserId,AccountId from AccountTeamMember where AccountId in : oppAccOwner.values() AND User.IsActive = true])
        {
			if(Null!=accountTMMap.get(accTM.AccountId))
            {
                (accountTMMap.get(accTM.AccountId)).add(accTM.UserId);
            }
            else
            {
                accountTMMap.put(accTM.AccountId,new Set<Id>{accTM.UserId});
            }
        }                           
            
         for(OpportunityTeamMember oppTM:[select Id,UserId,OpportunityId from OpportunityTeamMember where OpportunityId in : oppOwnerMap.keySet()])
        {
			if(accountTMMap.isEmpty() || !(accountTMMap.get(oppAccOwner.get(oppTM.OpportunityId))).contains(oppOwnerMap.get(oppTM.OpportunityId)))
            {
                if(oppTM.UserId==oppOwnerMap.get(oppTM.OpportunityId))
                {
                    oppTMToRemove.add(oppTM);
                }
            }
        }    
                
        return oppTMToRemove;
    }
    
    //Change Opp Owner added on 14/feb/2017
    public static List<OpportunityTeamMember> addOppOwner(Map<Id,Id> oppOwnerMap,Id IntegrationProfileId){
        List<OpportunityTeamMember> oppTeamMemberList = new List<OpportunityTeamMember>(); 
       Map<Id,Id> ownerMap=new Map<Id,Id>();
       Map<Id, Set<Id>> existingOppTMember = new  Map<Id, Set<Id>>();
       Map<Id, User> userMap = new Map<Id, User>([select id, User_Role__c,profileId from User where ID IN :oppOwnerMap.values()]);        
               
        try{
           
            for(OpportunityTeamMember oppTM:[Select Id,OpportunityID,UserId from OpportunityTeamMember where OpportunityID in :oppOwnerMap.keySet()])
            {
                if(Null!=existingOppTMember.get(oppTM.OpportunityID))
             {
                 (existingOppTMember.get(oppTM.OpportunityID)).add(oppTM.UserId);                
             }
                else
                {
                    existingOppTMember.put(oppTM.OpportunityID,new Set<Id>{oppTM.UserId});
                }
            }
           
          for(Id oppId:oppOwnerMap.keySet())
          {
              if((Null==existingOppTMember.get(oppId) || !(existingOppTMember.get(oppId)).contains(oppOwnerMap.get(oppId)) ) && IntegrationProfileId!=(userMap.get(oppOwnerMap.get(oppId))).profileId)
              {
                       OpportunityTeamMember oppTeamMember = new OpportunityTeamMember();
                        oppTeamMember.userId = oppOwnerMap.get(oppId);
                        oppTeamMember.TeamMemberRole =userMap.get(oppOwnerMap.get(oppId)).User_Role__c ;
                        oppTeamMember.OpportunityAccessLevel = 'Edit';
                        oppTeamMember.OpportunityId = oppId;
                        oppTeamMemberList.add(oppTeamMember);
              }
              
          }
            
        } 
        
        catch(Exception exe)
        {
            System.debug('Exception Occured:'+exe.getMessage()+exe.getLineNumber());
        }
        return oppTeamMemberList;
    }
    
    //Fetch AccountTeamMember from related Account of opportunity and copy AccountTeamMember to OpportunityTeamMember
    public static List<OpportunityTeamMember> insertAccTeamMemberAsOppTeam(List<Opportunity> opptyList,Id IntegrationProfileId)
    {
        List<OpportunityTeamMember> oppTeamMemberList = new List<OpportunityTeamMember>();
        Map<Id,Id> opportunityIdToAccountId = new Map<Id,Id>();
        Map<Id, List<AccountTeamMember>> accountIdToAccountTeamMembers = new  Map<Id, List<AccountTeamMember>>();
       	Set<Id> accTMID=new Set<Id>();
        
        try
        {
            for(Opportunity opp : opptyList)
            {
                opportunityIdToAccountId.put(opp.Id,opp.AccountId);
            }
            
            List<AccountTeamMember> accWithAccTeam = new List<AccountTeamMember>
            (
					[select Id,UserId,TeamMemberRole,AccountId,OpportunityAccessLevel
                     from AccountTeamMember 
                     where AccountId in : opportunityIdToAccountId.values()
                       	AND User.IsActive = true]
            );

            if(!accWithAccTeam.isEmpty())
            {
                for(AccountTeamMember atm : accWithAccTeam)
                {
                    if (!accountIdToAccountTeamMembers.containsKey(atm.AccountId))
                    {
                        accountIdToAccountTeamMembers.put(atm.AccountId, new List<AccountTeamMember>());
                    }
                    
                    accountIdToAccountTeamMembers.get(atm.AccountId).add(atm);
                    accTMID.add(atm.userId);
                }
                
				Map<Id, User> userMap = new Map<Id, User>([select id, User_Role__c,profileId from User where ID IN :accTMID]);                
                for(Opportunity opp : opptyList)
                {
                    Id AccountId = opportunityIdToAccountId.get(opp.Id);
                    for(AccountTeamMember atm : accountIdToAccountTeamMembers.get(AccountId))
                    {
                        if(IntegrationProfileId!=(userMap.get(atm.userId)).profileId)
                        {
                            OpportunityTeamMember oppTeamMember = new OpportunityTeamMember();
                            oppTeamMember.userId = atm.userId;
                            oppTeamMember.TeamMemberRole = atm.TeamMemberRole;
                            oppTeamMember.OpportunityAccessLevel = atm.OpportunityAccessLevel;
                            oppTeamMember.OpportunityId = opp.Id;
                            oppTeamMemberList.add(oppTeamMember);
                        }
                    }
                } 
            } 
        }
        catch(Exception ex)
        {
            System.debug('Execption occured:'+ex.getStackTraceString());
        }
        
        return oppTeamMemberList;
    }
}