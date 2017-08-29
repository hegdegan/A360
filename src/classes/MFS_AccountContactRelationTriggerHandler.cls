/**
Apex Class Name    : MFS_AccountContactRelationTriggerHandler
Version            : 1.0 
Created Date       : 28 APR 2017
Function           : Handler class that gets called by Account Contact Relation Trigger
when Contacts are created,updated
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   	Description
* ----------------------------------------------------------------------------                 
* Manoj Parida              	04/28/2017          	Original Version
* Matt Barth				05/02/2017			Updated calls to utilities and added call to end-date functionality
**/
public with sharing class MFS_AccountContactRelationTriggerHandler
{
	//Handler to update IsActive, StartDate, EndDate on Insert
	public static void beforeInsertAccountContactEventHandler(List<AccountContactRelation> newRelationships)
	{
		MFS_AccountContactRelationUtilities.manageStandardActiveStartEndDateBeforeInsert(newRelationships);

		MFS_AccountContactRelationUtilities.endDateRelationshipsBeforeInsertUpdate(null, newRelationships);
	}
	
	//Handler to update IsActive, StartDate, EndDate on update
	public static void beforeUpdateAccountContactEventHandler(Map<Id, AccountContactRelation> oldMap, Map<Id, AccountContactRelation> newMap)
	{
		if (!MFS_AccountContactRelationUtilities.validatePrimaryFlag(oldMap, newMap))
		{
			return;
		}

		MFS_AccountContactRelationUtilities.syncStandardActiveStartEndDateBeforeUpdate(oldMap,newMap);

		MFS_AccountContactRelationUtilities.updatePrimaryRelationshipFlagBeforeUpdate(oldMap, newMap);

		MFS_AccountContactRelationUtilities.endDateRelationshipsBeforeInsertUpdate(oldMap.values(), newMap.values());        
	}

	public static void afterUpdateAccountContactEventHandler(Map<Id, AccountContactRelation> oldMap, Map<Id, AccountContactRelation> newMap)
	{
		MFS_AccountContactRelationUtilities.updateContactAccountIdAfterRelationshipInsertUpdate(newMap);
        
		MFS_AccountContactRelationUtilities.setEndDateTrueForAllRelationshipsAfterInsertUpdate(newMap);
	}

	public static void afterInsertAccountContactEventHandler(Map<Id, AccountContactRelation> newMap)
	{	
		MFS_AccountContactRelationUtilities.updateContactAccountIdAfterRelationshipInsertUpdate(newMap);
        
        MFS_AccountContactRelationUtilities.setEndDateTrueForAllRelationshipsAfterInsertUpdate(newMap);
	}
}