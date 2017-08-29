/**
Apex Class Name    : OrganizationTriggerHandler
Version            : 1.0 
Created Date       : 11 MAY 2016
Function           : Handler class that gets called by Account Triggers 
when Accounts are created,updated and deleted
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              	09/05/2016				Original Version
* Christine Cui           	01/10/2017              added the method for changing the parent org to empty the email and added the date join date
* Matt Barth				04/11/2017				Updated AfterUpdate function to refactor into one update of sub-entities
**/

public class MFS_OrganizationTriggerHandler
{
    //Get the Id of user from custom setting and call organization utilities class before insert 
    public static void BeforeInsertEventhandler(List<Account> newAccount)
    {
        /*Map<String, Application_Settings__c> appSettings =  Application_Settings__c.getAll();
        Id MFSGenericUserId = MFS_Utilities.GetAppSettingValue(appSettings, 'MFSGenericUserId', System.Label.MFS_Owner_User_Id);
        Boolean changeOwner = MFS_Utilities.GetAppSettingValue(appSettings, 'EnableAccountTriggerChangeOwner', 'Yes') == 'yes' ? true : false;
        
        if(changeOwner)
        {
            MFS_OrganizationUtilities.ChangeAccountOwner(newAccount, MFSGenericUserId); 
        }*/
        MFS_OrganizationUtilities.setOrgRecordType(newAccount);
    }
    public static void BeforeUpdateEventhandler(Map<Id,Account> oldAccountMap, Map<Id,Account> newAccountMap){
        MFS_OrganizationUtilities.setOrgRecordType(newAccountMap.values());
    }
    
    //call organization utilities class to add current logged in user as a team member after insert
    public static void AfterInsertEventhandler(Map<Id, Account> mapNewAccount)
    {
        Map<String, Application_Settings__c> appSettings =  Application_Settings__c.getAll();
        Boolean addDefaultAccountTeam = 
            MFS_Utilities.GetAppSettingValue(appSettings, 'EnableAccountTriggerAddDefaultAccTeam', 'Yes') == 'yes' ? true : false;
        
        if(addDefaultAccountTeam)
        {
            MFS_OrganizationUtilities.AddOwnerAsTeamMember(mapNewAccount.values(), appSettings);
        }
    }
    
    //Handle dml operation error and call organization utilities class after update
    public static void afterUpdateEventHandler(Map<Id, Account> mapNewAccount, Map<Id,Account> mapOldAccount)
    {
        Map<Id, List<DataBase.Error>> errs = UpdateAssociatedEntities(mapNewAccount, mapOldAccount);
		if (null == errs || errs.isEmpty())
		{
			return;
		}

		for (Id obId : errs.keySet())
		{
			Account a = mapNewAccount.get(obId);
			for(DataBase.Error err : errs.get(obId))
			{
				a.addError('There was an error while updating Account ' + a.Id + ' : ' + err.getMessage());
			}
		}
    }

	public static Map<Id, List<DataBase.Error>> UpdateAssociatedEntities(Map<Id, Account> NewAccounts, Map<Id, Account> OldAccounts)
	{
		Map<Id, Account> contactUpdates = new Map<Id, Account>();
		Map<Id, Account> oppUpdates = new Map<Id, Account>();
		Map<Id, Account> taskUpdates = new Map<Id, Account>();

		try
        {
			for (Id aid : NewAccounts.KeySet())
			{
				Account nAcc = NewAccounts.get(aid);
				Account oAcc = OldAccounts.get(aid);

				if(nAcc.ShippingCity != oAcc.ShippingCity ||
				   nAcc.ShippingState != oAcc.ShippingState ||
				   nAcc.ShippingStreet != oAcc.ShippingStreet ||
				   nAcc.ShippingCountry != oAcc.ShippingCountry ||
				   nAcc.ShippingPostalCode != oAcc.ShippingPostalCode)
				{
					contactUpdates.put(nAcc.Id, nAcc);
				}

				if(nAcc.Entity_Status__c != null &&
					nAcc.Entity_Status__c != oAcc.Entity_Status__c &&
					nAcc.Entity_Status__c.equals('Inactive'))
				{
					contactUpdates.put(nAcc.Id, nAcc);
					oppUpdates.put(nAcc.Id, nAcc);
					taskUpdates.put(nAcc.Id, nAcc);
				}

				if(nAcc.ParentId != oAcc.ParentId)
				{
					contactUpdates.put(nAcc.Id, nAcc);
				}
			}
        }
        catch(Exception ex)
        {
            System.debug('Exception occured trying to determine associated entities in UpdateAssociatedEntities: ' + ex.getMessage());
			throw ex;
        }

        Map<Id, List<Database.Error>> errors = new Map<Id, List<Database.Error>>();
		try
		{
			if (!contactUpdates.isEmpty())
			{
				errors =  MFS_OrganizationUtilities.UpdateAssociatedContacts(NewAccounts, OldAccounts, contactUpdates);
			}
		}
		catch(Exception ex)
        {
            System.debug('Exception occured trying to update associated contacts in UpdateAssociatedEntities: ' + ex.getMessage());
			throw ex;
        }
		
		try
		{
			if (!oppUpdates.isEmpty())
			{
				Map<Id, List<Database.Error>> oppErrs = MFS_OrganizationUtilities.UpdateAssociatedOpportunities(oppUpdates);
				for (Id errId : oppErrs.keySet())
				{
					if (!errors.containsKey(errId))
					{
						errors.put(errId, new List<Database.Error>());
					}
					
					errors.get(errId).addAll(oppErrs.get(errId));
				}
            }
		}
		catch(Exception ex)
        {
            System.debug('Exception occured trying to update associated opportunities in UpdateAssociatedEntities: ' + ex.getMessage());
			throw ex;
        }
		
		try
		{
			if (!taskUpdates.isEmpty())
			{
				Map<Id, List<Database.Error>> taskErrs = MFS_OrganizationUtilities.UpdateAssociatedTasks(taskUpdates);
				for (Id errId : taskErrs.keySet())
				{
					if (!errors.containsKey(errId))
					{
						errors.put(errId, new List<Database.Error>());
					}
					
					errors.get(errId).addAll(taskErrs.get(errId));
				}
			}
		}
		catch(Exception ex)
        {
            System.debug('Exception occured trying to update associated tasks in UpdateAssociatedEntities: ' + ex.getMessage());
			throw ex;
        }

		return errors;
	}    
}