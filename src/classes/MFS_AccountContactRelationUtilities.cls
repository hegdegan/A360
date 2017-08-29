/**
Apex Class Name    : MFS_AccountContactRelationUtilities
Version            : 1.0 
Created Date       : 28 APR 2017
Function           : Utilities class that gets called by Account Contact Relation Trigger Handler
when Contacts are created,updated
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   	Description
* ----------------------------------------------------------------------------                 
* Manoj Parida              	04/28/2017              	Original Version
* Matt Barth				05/02/2017			Updated names and added function for end-dating existing relationships
**/
public with sharing class MFS_AccountContactRelationUtilities
{

	public static boolean validatePrimaryFlag(Map<Id, AccountContactRelation> oldMap, Map<Id, AccountContactRelation> newMap)
	{
		boolean allValid = true;
		
		for (Id acrId : newMap.keySet())
		{
			AccountContactRelation oAcr = oldMap.get(acrId);
			AccountContactRelation nAcr = newMap.get(acrId);

			if (oAcr.Primary_Relationship__c == true && nAcr.Primary_Relationship__c == false && oAcr.IsDirect == true && nAcr.IsDirect == true)
			{
				/// Cannot set primary flag to false directly, must be the result of isdirect being false
				nAcr.addError('Cannot set relationship to non-primary. Please set new primary relationship.');
				
				allValid = false;
			}
		}
		
		return allValid;
	}
	
	//Update IsActive, StartDate, EndDate on Insert
	public static void manageStandardActiveStartEndDateBeforeInsert(List<AccountContactRelation> acrList)
	{
		if (acrList != null && acrList.size() > 0)
		{
			for(AccountContactRelation acr:acrList)
			{
                // || acr.Start_Date__c != null || acr.End_Date__c != null)
				//If custom fields have values then copy custom - > standard
				if (acr.Active__c != null)
				{
					acr.IsActive = acr.Active__c;
                }
                else
                {
                    acr.Active__c = acr.IsActive;
                }

                if (acr.Start_Date__c == null)
                {
                    if (acr.StartDate == null)
                    {
                        acr.StartDate = acr.Start_Date__c = Date.today();
                    }
                    else
                    {
                        acr.Start_Date__c = acr.StartDate;
                    }
                }
                else
                {
                    acr.StartDate = acr.Start_Date__c;
                }

                if (acr.End_Date__c == null)
                {
                    acr.End_Date__c = acr.EndDate;
                }
                else
                {
                    acr.EndDate = acr.End_Date__c;
                }                
			}
		}
	}

	//Update IsActive, StartDate, EndDate on update
	public static void syncStandardActiveStartEndDateBeforeUpdate(Map<Id, AccountContactRelation> oldMap, Map<Id, AccountContactRelation> newMap)
	{
		//Compare Old values to New Values to see if we need to run or not
		for (AccountContactRelation acr: newMap.values())
		{
			AccountContactRelation acrOld = oldMap.get(acr.id);
			AccountContactRelation acrNew = newMap.get(acr.id);
			
			//If custom values are changed then copy those to standard(this happens during data migration)
			if(acrNew.Active__c != acrOld.Active__c)
            {
                acr.IsActive = acr.Active__c;
            }
            else if(acrNew.IsActive != acrOld.IsActive)
            {
                acr.Active__c = acr.IsActive;
            }
            
            if(acrNew.Start_Date__c != acrOld.Start_Date__c)
            {
                acr.StartDate = acr.Start_Date__c;
            }
            else if(acrNew.StartDate != acrOld.StartDate)
            {
                acr.Start_Date__c = acr.StartDate;
            }

			if(acrNew.End_Date__c != acrOld.End_Date__c)
            {
                acr.EndDate = acr.End_Date__c;
            }
            else if(acrNew.EndDate != acrOld.EndDate)
            {
                acr.End_Date__c = acr.EndDate;
            }
        }
	}

	public static void updatePrimaryRelationshipFlagBeforeUpdate(Map<Id, AccountContactRelation> oldMap, Map<Id, AccountContactRelation> newMap)
	{
		for (Id oldId : oldMap.keySet())
		{
			AccountContactRelation oldRel = oldMap.get(oldId);
			AccountContactRelation newRel = newMap.get(oldId);

			if (oldRel.Primary_Relationship__c == true && newRel.Primary_Relationship__c == true && newRel.IsDirect == false)
			{
				system.debug('Primary_Relationship__c setting ');
				newRel.Primary_Relationship__c = false;
			}
		}
	}

	// Only end-date relationship if isdirect = true and old isdirect = false and end-date flag is checked
	public static void endDateRelationshipsBeforeInsertUpdate(List<AccountContactRelation> OldRelationships, List<AccountContactRelation> NewRelationships)
	{
		Map<Id, AccountContactRelation> newPrimaryWithEndDateCheckedByContactId = new Map<Id, AccountContactRelation>();
		Map<Id, List<AccountContactRelation>> newRecordsByContactId = new Map<Id, List<AccountContactRelation>>();
		Map<Id, List<AccountContactRelation>> oldRecordsByContactId = new Map<Id, List<AccountContactRelation>>();
		Set<Id> incomingContactIds = new Set<Id>();

        if (OldRelationships != null)
        {
            for (AccountContactRelation acr : OldRelationships)
            {
                if (!oldRecordsByContactId.containsKey(acr.ContactId))
                {
                    oldRecordsByContactId.put(acr.ContactId, new List<AccountContactRelation>());
                }
                
                oldRecordsByContactId.get(acr.contactId).add(acr);
            }
        }
        
		for (AccountContactRelation acr : NewRelationships)
		{
			incomingContactIds.add(acr.ContactId);
			  
			if (!newRecordsByContactId.containsKey(acr.ContactId))
			{
				newRecordsByContactId.put(acr.ContactId, new List<AccountContactRelation>());
			}
			newRecordsByContactId.get(acr.ContactId).add(acr);
			
			if (acr.Primary_Relationship__c == true && acr.End_Date_Relationships__c == true)
			{
				boolean addPrimary = false;
				if (oldRecordsByContactId.isEmpty())
				{
					addPrimary = true;
				}
                
				else
				{
					for (AccountContactRelation oAcr: oldRecordsByContactId.get(acr.ContactId))
					{
					    if (oAcr.AccountId == acr.AccountId)
					    {
						   if (!oAcr.IsDirect)
						   {
                               addPrimary = true;
						   }
						   
						   break;
					    }
					}
				}
                
				if (addPrimary)
				{
					newPrimaryWithEndDateCheckedByContactId.put(acr.ContactId, acr);                    
				}
			}
		}

		if (newPrimaryWithEndDateCheckedByContactId.isEmpty())
		{
			return;
		}
		
		Map<Id, Map<Id, AccountContactRelation>> processedRecordsByContactId = new Map<Id, Map<Id, AccountContactRelation>>();
		
		// End-date any incoming records associated with new primary
		for (Id cId : newPrimaryWithEndDateCheckedByContactId.keySet())
		{
			AccountContactRelation primaryA = newPrimaryWithEndDateCheckedByContactId.get(cId);

			for (AccountContactRelation acr : newRecordsByContactId.get(cId))
			{
				if (primaryA.AccountId != acr.AccountId)
				{
                    //These guys are all set already, just move on
                    if (!acr.IsActive && acr.EndDate != null)
                    {
                        continue;
                    }

					acr.IsActive = false;
					acr.Active__c = false;
					acr.End_Date__c = Date.Today();
					acr.EndDate = Date.Today();
					
					if (!processedRecordsByContactId.containsKey(cId))
					{
						processedRecordsByContactId.put(cId, new Map<Id, AccountContactRelation>());
					}
					processedRecordsByContactId.get(cId).put(acr.AccountId, acr);
				}
			}
		}

		for (AccountContactRelation[] targetAcr : [SELECT Id, AccountId, ContactId, IsActive, EndDate, Active__c, End_Date__c
											FROM AccountContactRelation
											WHERE ContactId IN : incomingContactIds])
		{
			Map<Id, List<AccountContactRelation>> recordsToSaveByContactId = new Map<Id, List<AccountContactRelation>>();
			
			for (AccountContactRelation acr : targetAcr)
			{
				AccountContactRelation prim = newPrimaryWithEndDateCheckedByContactId.get(acr.ContactId);
				if (null == prim || prim.AccountId == acr.AccountId)
				{
					continue;
				}

                //These guys are all set already, just move on
                if (!acr.IsActive && acr.EndDate != null)
                {
                    continue;
                }

				if (processedRecordsByContactId.containsKey(acr.ContactId))
				{
					Map<Id, AccountContactRelation> relsByAccountId = processedRecordsByContactId.get(acr.ContactId);
					if (relsByAccountId.containsKey(acr.AccountId))
					{
						continue;
					}
				}

				// This is not the new primary and it has not been processed in the incoming set
				acr.IsActive = false;
				acr.Active__c = false;
				acr.End_Date__c = Date.Today();
				acr.EndDate = Date.Today();

				if (!recordsToSaveByContactId.containsKey(acr.ContactId))
				{
					recordsToSaveByContactId.put(acr.ContactId, new List<AccountContactRelation>());
				}
				recordsToSaveByContactId.get(acr.ContactId).add(acr);
			}

			if (!recordsToSaveByContactId.isEmpty())
			{
				Map<Id, List<DataBase.Error>> errorsByContactId = MFS_DMLUtilities.SaveEntityWithAssociatedId(recordsToSaveByContactId);
				for (Id contactId : errorsByContactId.keySet())
				{
					for (DataBase.Error err : errorsByContactId.get(contactId))
					{
						newPrimaryWithEndDateCheckedByContactId.get(contactId).addError(err.getMessage());
					}
				}	
			}
		}
	}

	public static void updateContactAccountIdAfterRelationshipInsertUpdate(Map<Id, AccountContactRelation> AllRelationships)
	{
		Map<Id, AccountContactRelation> primaryRelsByContactId = new Map<Id, AccountContactRelation>();
		for (AccountContactRelation acr : AllRelationships.values())
		{
			if (acr.Primary_Relationship__c == true && acr.IsDirect == false)
			{
				primaryRelsByContactId.put(acr.ContactId, acr);
			}
		}

		if (primaryRelsByContactId.isEmpty())
		{
			return;
		}

        for (Contact[] contacts : [SELECT Id, AccountId FROM Contact WHERE Id IN : primaryRelsByContactId.keySet()])
		{
			Map<Id, List<Contact>> records = new Map<Id, List<Contact>>();
			
			for (Contact c : contacts)
			{
				AccountContactRelation rel = primaryRelsByContactId.get(c.Id);
				
				c.AccountId = rel.AccountId;
				
				if (!records.containsKey(rel.Id))
				{
					records.put(rel.Id, new List<Contact>());
				}
				records.get(rel.Id).add(c);
			}

			Map<Id, List<DataBase.Error>> errorsByRelationshipId = MFS_DMLUtilities.SaveEntityWithAssociatedId(records);
			for (Id relationshipId : errorsByRelationshipId.keySet())
			{
				for (DataBase.Error err : errorsByRelationshipId.get(relationshipId))
				{
					AllRelationships.get(relationshipId).addError(err.getMessage());
				}
			}
		}
	}

	public static void setEndDateTrueForAllRelationshipsAfterInsertUpdate(Map<Id, AccountContactRelation> AllRelationships)
	{
		Map<Id, AccountContactRelation> relationsToUpdateById = new Map<Id, AccountContactRelation>();
		
		for (AccountContactRelation acr : AllRelationships.values())
		{
			if (acr.End_Date_Relationships__c == false)
			{
				relationsToUpdateById.put(acr.Id, acr);
			}
		}

		if (relationsToUpdateById.isEmpty())
		{
			return;
		}
        
		for (List<AccountContactRelation> targetAcr : [SELECT Id, End_Date_Relationships__c FROM AccountContactRelation WHERE Id IN : relationsToUpdateById.keySet()])
		{
			Map<Id, AccountContactRelation> relsById = new Map<Id, AccountContactRelation>();
			for (AccountContactRelation acr : targetAcr)
			{
				acr.End_Date_Relationships__c = true;
				relsById.put(acr.Id, acr);
			}

			Map<Id, List<DataBase.Error>> errorsByRelationshipId = MFS_DMLUtilities.SaveEntity(targetAcr);
			for (Id relationshipId : errorsByRelationshipId.keySet())
			{
				for (DataBase.Error err : errorsByRelationshipId.get(relationshipId))
				{
					relsById.get(relationshipId).addError(err.getMessage());
				}
			}
		}
	}
}