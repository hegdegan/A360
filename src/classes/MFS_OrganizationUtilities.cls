/**
Apex Class Name    : MFS_OrganizationUtilities
Version            : 1.0 
Created Date       : 11 MAY 2016
Function           : Utility class that gets called by Account Triggers 
when Accounts are created,updated and deleted
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              11/05/2016              Original Version
* Christine Cui           01/10/2017              added the method for changing the parent org to empty the email and added the date join date
* Matt Barth			  04/11/2017			  Updated the contact/opp/task updates to bulkify and refactored all of them for reuse
**/
public class MFS_OrganizationUtilities
{
    //Change the owner of Account to a generic user
    public static void ChangeAccountOwner(List<Account> newAccounts, Id MFSGenericUserId)
	{
        try
		{
            for(Account newAccount : newAccounts)
			{
                if(MFSGenericUserId == null)
				{
                    newAccount.AddError(System.Label.Change_Owner_Error_Message);
                    return;
                }
				
                if(newAccount.OwnerId != MFSGenericUserId)
				{
                    newAccount.OwnerId = MFSGenericUserId;
                }
            }
        }
		catch(Exception exe)
		{
            System.debug('Execption occured:'+exe.getMessage());
        }
    }
    
    //Add Current login user as a Account Team Member and assign Read/Write access to Opportunity, Case and Account
    public static void AddOwnerAsTeamMember(List<Account> newAccounts, Map<String, Application_Settings__c> appSettings)
	{
        try
		{
            Boolean addOwnerAsATM = MFS_Utilities.GetAppSettingValue(appSettings, 'EnableAccountTriggerAddOwnerAsATM', 'yes') == 'Yes' ? true : false;
            //Boolean addDefaultAccountTeam = MFS_Utilities.GetAppSettingValue(appSettings, 'EnableAccountTriggerAddDefaultAccTeam', 'Yes') == 'yes' ? true : false;
            String defaultAccountTeamAccountAccessLevel = MFS_Utilities.GetAppSettingValue(appSettings, 'DefaultAccountTeamAccountAccessLevel', 'Edit');
            String defaultAccountTeamCaseAccessLevel = MFS_Utilities.GetAppSettingValue(appSettings, 'DefaultAccountTeamCaseAccessLevel', 'Edit');
            String defaultAccountTeamOpptunityAccessLevel = MFS_Utilities.GetAppSettingValue(appSettings, 'DefaultAccountTeamOpptunityAccessLevel', 'Edit');
            Id MFSGenericUserId = MFS_Utilities.GetAppSettingValue(appSettings, 'MFSGenericUserId', System.Label.MFS_Owner_User_Id);
            Id IntegrationProfileId = MFS_Utilities.GetAppSettingValue(appSettings, 'IntegrationProfileId', System.Label.MFS_Integration_Profile_ID); 
            String ATMRole = MFS_Utilities.GetAppSettingValue(appSettings, 'Role', 'Account Creator');
            Id LoginUserId = Userinfo.getUserId();
            Id LoginUserProfileId = userinfo.getProfileId();
            AccountTeamMember ATM;
            AccountShare AShare;
            List<AccountTeamMember> AccountTeamMembers = new List<AccountTeamMember>();
            List<AccountShare> AccountShares = new List<AccountShare>();
            
            if(addOwnerAsATM && LoginUserId != MFSGenericUserId && LoginUserProfileId != IntegrationProfileId)
            {
                for(Account newAccount : newAccounts)
                {
                    ATM = new AccountTeamMember();
                    AShare = new AccountShare();
                    ATM.UserId = LoginUserId;
                    ATM.AccountId = newAccount.Id;
                    ATM.TeamMemberRole = ATMRole;
                    AccountTeamMembers.add(ATM);
                }
            }
            Database.SaveResult[] insAccTeam;
            if(AccountTeamMembers.size()>0)
            {
                insAccTeam = Database.insert(AccountTeamMembers,false); 
			}
            
            Set<Id> actTeamIdSet = new Set<Id>();
            if(insAccTeam != null)
			{
                for(Integer i=0 ; i<insAccTeam.size() ; i++)
				{
                    if(insAccTeam[i].isSuccess())
					{
                        Id accTeamId = insAccTeam[i].Id;
                        actTeamIdSet.add(accTeamId);
                    }
                }
            }
			
            Map<Id,Id> accTemUserIDMap = new Map<Id,Id>();
            if(actTeamIdSet.size() > 0)
			{
                List<AccountTeamMember> aTeamList = new List<AccountTeamMember>([select Id,UserId,AccountID from AccountTeamMember where ID in : actTeamIdSet]);
                for(AccountTeamMember aTeam : aTeamList)
				{
                    accTemUserIDMap.put(aTeam.AccountID,aTeam.UserId);
                }
            }

            if(accTemUserIDMap.size() > 0)
			{
                List<AccountShare> aShareeamList = new List<AccountShare>([select Id,AccountId,UserOrGroupId from AccountShare where AccountId in : accTemUserIDMap.keySet()]);

                for(AccountShare accShare : aShareeamList)
				{
                    system.debug(' Id : '+accShare.Id+' AccountId : '+accShare.AccountId+' UserOrGroupId  :  '+accShare.UserOrGroupId);
                    if(accTemUserIDMap.containskey(accShare.AccountId) && accTemUserIDMap.get(accShare.AccountId) == accShare.UserOrGroupId)
					{
                        AShare.Id=accShare.Id;
                        AShare.AccountAccessLevel = defaultAccountTeamAccountAccessLevel;
                        Ashare.OpportunityAccessLevel = defaultAccountTeamOpptunityAccessLevel;
                        Ashare.CaseAccessLevel = defaultAccountTeamCaseAccessLevel;
                        AccountShares.add(Ashare);
                    }
                }
            }
			
            if(AccountShares.size()>0)
            {
                Database.SaveResult[] insAccShTeam = Database.update(AccountShares,false);
			}
        }
		catch(Exception ex)
		{
            System.debug('Exception :'+ ex.getMessage());
            System.debug('Exception occured-AcctShare:'+ ex.getStackTraceString());
        }
    }

	public static Map<Id, List<DataBase.Error>> UpdateAssociatedContacts(Map<Id, Account> NewAccounts, Map<Id, Account> OldAccounts, Map<Id, Account> AccountsWithContactUpdates)
	{
        //Map<Id, List<Contact>> contactsToUpdate = new Map<Id, List<Contact>>();
		List<Contact> contactsToUpdate = new List<Contact>();
        Map<Id, Id> accountIds = new Map<Id, Id>();
		try
        {
			for (Contact c : [SELECT Id, AccountId, Status__c, OtherStreet, OtherCity, OtherState, OtherCountry, OtherPostalCode,
                              			MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry ,
                              			Date_Joined_Current_Firm__c, email
                              FROM CONTACT
                              WHERE AccountId in : AccountsWithContactUpdates.keySet()])
			{
				Account nAcc = NewAccounts.get(c.AccountId);
				Account oAcc = OldAccounts.get(c.AccountId);
				
				c.MailingCity = nAcc.ShippingCity;
				c.MailingStreet = nAcc.ShippingStreet;
				c.MailingState = nAcc.ShippingState;
				c.MailingCountry = nAcc.ShippingCountry;
				c.MailingPostalCode = nAcc.ShippingPostalCode;

				if(	nAcc.Entity_Status__c != null && 
               		nAcc.Entity_Status__c != oAcc.Entity_Status__c &&
                	nAcc.Entity_Status__c.equals('Inactive'))
				{
					c.Status__c = 'Inactive';
				}

				if(nAcc.ParentId != oAcc.ParentId)
				{
					c.Date_Joined_Current_Firm__c = system.TODAY();          
					c.email = null;
                }

                /*if (!contactsToUpdate.containsKey(nAcc.Id))
                {
                    contactsToUpdate.put(nAcc.Id, new List<Contact>());
                }*/
                
				//contactsToUpdate.get(nAcc.Id).Add(c);
				contactsToUpdate.add(c);
                accountIds.put(c.Id, nAcc.Id);
			}
        }
        catch(Exception ex)
        {
            System.debug('Exception occured when trying to query and update contact info in memory in UpdateAssociatedAccounts: ' + ex.getMessage());
			throw ex;
        }

		try
		{
			if (!contactsToUpdate.isEmpty())
			{
				return SubmitEntityUpdate(contactsToUpdate,accountIds);
			}
            else
            {
                return new Map<Id, List<Database.Error>>();
            }
		}
        catch(Exception ex)
        {
            System.debug('Exception occured when trying to persist updated contact info into database in UpdateAssociatedAccounts: ' + ex.getMessage());
			throw ex;
        }
	}

	public static Map<Id, List<DataBase.Error>> UpdateAssociatedOpportunities(Map<Id, Account> AccountsWithOppUpdates)
	{
        Id instId, argId;
		try
		{
			instId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Institutional New Business').getRecordTypeId();
            argId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail/Professional Buyer').getRecordTypeId();
		}
		catch(Exception ex)
        {
            System.debug('Exception occured when trying to retrieve record types in UpdateAssociatedOpportunities: ' + ex.getMessage());
			throw ex;
        }

		//Map<Id, List<Opportunity>> oppsToUpdate = new Map<Id, List<Opportunity>>();
		List<Opportunity> oppsToUpdate = new List<Opportunity>();
        Map<Id, Id> accountIds = new Map<Id, Id>();
		try
        {
            for (Opportunity opp : [SELECT Id, StageName, RecordTypeId , AccountId 
								    FROM Opportunity
								    WHERE AccountId in : AccountsWithOppUpdates.KeySet()
										AND (StageName NOT in ('Funded', 'Lost', 'Closed Won', 'Closed Lost'))])
            {
                if(opp.recordtypeid==instId)
                {
                    opp.StageName = 'Lost';
                }
                else if(opp.recordtypeid==argId)
                {
                    opp.StageName = 'Closed Lost';
                }

				/*if (!oppsToUpdate.containsKey(opp.AccountId))
				{
					oppsToUpdate.put(opp.AccountId, new List<Opportunity>());
				}
				oppsToUpdate.get(opp.AccountId).add(opp);*/
                oppsToUpdate.add(opp);
                accountIds.put(opp.Id, opp.AccountId);
            }
        }
        catch(Exception ex)
        {
            System.debug('Exception occured when trying to update opportunity status in memory in UpdateAssociatedOpportunities: ' + ex.getMessage());
			throw ex;
        }

		try
		{
			if (!oppsToUpdate.isEmpty())
			{
				//return SubmitEntityUpdate(oppsToUpdate);
				return SubmitEntityUpdate(oppsToUpdate, accountIds);
            }
            else
            {
                return new Map<Id, List<Database.Error>>();
            }
		}
        catch(Exception ex)
        {
            System.debug('Exception occured when trying to persist updated opportunity info into database in UpdateAssociatedOpportunities: ' + ex.getMessage());
			throw ex;
        }
	}
	
	public static Map<Id, List<DataBase.Error>> UpdateAssociatedTasks(Map<Id, Account> AccountsWithTaskUpdates)
	{
		//Map<Id, List<Task>> tasksToUpdate = new Map<Id, List<Task>>();
        List<Task> tasksToUpdate = new List<Task>();
        Map<Id, Id> accountIds = new Map<Id, Id>();
		try
        {
            for (Task t : [SELECT Id, Status, AccountId
                           FROM Task
                           WHERE AccountId in : AccountsWithTaskUpdates.KeySet()
                          		AND Status = 'Open'])
            {
                t.Status = 'Completed';

				/*if (!tasksToUpdate.containsKey(t.AccountId))
				{
					tasksToUpdate.put(t.AccountId, new List<Task>());
				}
				
                tasksToUpdate.get(t.AccountId).add(t);*/
                tasksToUpdate.add(t);
                accountIds.put(t.Id, t.AccountId);
            }
        }
        catch(Exception ex)
        {
            System.debug('Exception occured when trying to update Task status: ' + ex.getMessage());
			throw ex;
        }

		try
		{
			if (!tasksToUpdate.isEmpty())
			{
				//return SubmitEntityUpdate(tasksToUpdate);
				return SubmitEntityUpdate(tasksToUpdate, accountIds);
			}
            else
            {
                return new Map<Id, List<Database.Error>>();
            }
		}
        catch(Exception ex)
        {
            System.debug('Exception occured when trying to persist updated task info into database in UpdateAssociatedTasks: ' + ex.getMessage());
			throw ex;
        }			
	}

	static Map<Id, List<DataBase.Error>> SubmitEntityUpdate(List<Sobject> allObs, Map<Id, Id> accountIdByObId)
	{
		if (accountIdByObId.isEmpty())
		{
			throw new DmlException('Unable to persist records. Dataset empty.');
		}

		Map<Id, List<DataBase.Error>> retVals = new Map<Id, List<Database.Error>>();
		/*Map<Id, Id> accountIdByObId = new Map<Id, Id>();
		List<SObject> allObs = new List<SObject>();
		
		for (Id aId : ObsByAccountId.keySet())
		{
			for (SObject ob : ObsByAccountId.get(aId))
			{
				allObs.add(ob);
				accountIdByObId.put(ob.Id, aId);
			}
		}*/
        
		try
		{
			DataBase.SaveResult[] results = Database.update(allObs, false);
                
			for (Database.SaveResult sr : results) 
			{
				if (!sr.isSuccess())
				{
					Id accountId = accountIdByObId.get(sr.getId());
					if (!retVals.containsKey(accountId))
					{
						retVals.put(accountId, new List<Database.Error>());
					}
					
					// Operation failed, so get all errors
					for(Database.Error err : sr.getErrors())
					{
						System.debug('Database error updating ' + allObs.getSObjectType().getDescribe().getName() + ' records in MFS_OrganizationUtilities.SubmitEntityUpdate');
						System.debug(err.getStatusCode() + ': ' + err.getMessage());
						System.debug('Fields that affected this error: ' + err.getFields());
						
						retVals.get(accountId).add(err);
					}
				}
			}
            
            return retVals;
		}
        catch(Exception ex)
        {
            System.debug('Exception occured when trying to persist updated ' + allObs.getSObjectType().getDescribe().getName() 
							+ ' info into database in MFS_OrganizationUtilities.SubmitEntityUpdate: ' + ex.getMessage());
            throw ex;
        }
	}
    
    public static void setOrgRecordType(List<Account> newAccountList){
        Map<Id,RecordType> mapRT = new Map<Id,RecordType> ([select Id,DeveloperName from RecordType where SobjectType='Account']);
        Map<String, String> RTAndIdMap = new MAp<String,String>();
        for(String RT : mapRT.keySet()){
            system.debug('RT '+ RT +' Name: '+ mapRT.get(RT).DeveloperName );
            RTAndIdMap.put( mapRT.get(RT).DeveloperName, RT);
        }
        for(Account acc : newAccountList){
            if(acc.RecordTypeId.equals(RTAndIdMap.get(MFS_AllConstants.RT_UNKNOWN))){
                if(acc.Type__c != null && acc.Type__c.equals(MFS_AllConstants.TYPE_CLIENT_PROSPECT) && 
               (acc.Distribution_Level__c != null && (acc.Distribution_Level__c.contains(MFS_AllConstants.DL_US_RETAIL) ||
                                                      acc.Distribution_Level__c.contains(MFS_AllConstants.DL_NON_US_RETAIL)) && !acc.Distribution_Level__c.contains(MFS_Allconstants.DL_GL_INST))){
                   acc.RecordTypeId = RTAndIdMap.get(MFS_AllConstants.RT_GLOBAL_RETAIL);
               }else if(acc.Type__c != null && acc.Type__c.equals(MFS_AllConstants.TYPE_CLIENT_PROSPECT) && 
                        acc.Distribution_Level__c != null && acc.Distribution_Level__c.contains(MFS_AllConstants.DL_GL_INST) &&  
                        acc.Sales_Status__c != null && acc.Sales_Status__c.equals(MFS_AllConstants.ST_PRSPT)){
                   acc.RecordTypeId = RTAndIdMap.get(MFS_AllConstants.RT_GLOBAL_INSTITUTIONAL_PROSPECT);
               }else if(acc.Type__c != null && acc.Type__c.equals(MFS_AllConstants.TYPE_COMPETITOR)){
                   acc.RecordTypeId = RTAndIdMap.get(MFS_AllConstants.RT_GLOBAL_RETAIL);
               }else if(acc.Type__c != null && ( acc.Type__c.equals(MFS_AllConstants.TYPE_SERVICE_PROVIDER) || acc.Type__c.equals(MFS_AllConstants.TYPE_SPCL_DEALER) ) ){
                  acc.RecordTypeId = RTAndIdMap.get(MFS_AllConstants.RT_SERVICE_PROVIDER); 
               }else if(acc.Type__c != null && acc.Type__c.equals(MFS_AllConstants.TYPE_INVST_CONSUL)){
                   acc.RecordTypeId = RTAndIdMap.get(MFS_AllConstants.RT_INVESTMENT_CONSULTANT); 
               }else if(acc.Type__c != null && acc.Type__c.equals(MFS_AllConstants.TYPE_CLIENT_PROSPECT) &&
                       acc.Distribution_Level__c != null && acc.Distribution_Level__c.contains(MFS_AllConstants.DL_GL_INST) && 
                       acc.Sales_Status__c != null && acc.Sales_Status__c.equals(MFS_AllConstants.ST_CLIENT) ){
                   acc.RecordTypeId = RTAndIdMap.get(MFS_AllConstants.RT_GLOBAL_INSTITUTIONAL_CLIENT);                         
               }else if(acc.Type__c != null && acc.Type__c.equals(MFS_AllConstants.TYPE_CLIENT_PROSPECT) &&
                       acc.Distribution_Level__c != null && acc.Distribution_Level__c.contains(MFS_AllConstants.DL_GL_INST) && 
                       (acc.Distribution_Level__c.contains(MFS_AllConstants.DL_NON_US_RETAIL) || acc.Distribution_Level__c.contains(MFS_AllConstants.DL_US_RETAIL)) ) {                                    
                   acc.RecordTypeId = RTAndIdMap.get(MFS_AllConstants.RT_GLOBAL_INSTITUTIONAL_CLIENT);   
               }
                
            }            
        }
        
    }
}