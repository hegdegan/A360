/**
Apex Class Name    : MFS_DMLUtilities
Version            : 1.0 
Created Date       : 2 MAY 2017
Function           : Utilities class for DML Operations
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Matt Barth              	04/02/2017             Original Version
**/
public with sharing class MFS_DMLUtilities
{
	public static Map<Id, List<DataBase.Error>> SaveEntityWithAssociatedId(Map<Id, List<SObject>> ObsByAssociatedId)
	{
		if (ObsByAssociatedId.isEmpty())
		{
			throw new DmlException('Unable to persist records. Dataset empty.');
		}

		Map<Id, Id> associatedIdByObId = new Map<Id, Id>();
		List<SObject> allObs = new List<SObject>();
		for (Id aId : ObsByAssociatedId.keySet())
		{
			for (SObject ob : ObsByAssociatedId.get(aId))
			{
				allObs.add(ob);
				associatedIdByObId.put(ob.Id, aId);
			}
		}

		Map<Id, List<DataBase.Error>> retVals = new Map<Id, List<Database.Error>>();		
		try
		{
			DataBase.SaveResult[] results = Database.update(allObs, false);
                
			for (Database.SaveResult sr : results) 
			{
				if (!sr.isSuccess())
				{
					Id associatedId = associatedIdByObId.get(sr.getId());
					if (!retVals.containsKey(associatedId))
					{
						retVals.put(associatedId, new List<Database.Error>());
					}
					
					// Operation failed, so get all errors
					for(Database.Error err : sr.getErrors())
					{
						System.debug('Database error updating ' + allObs.getSObjectType().getDescribe().getName() + ' records in MFS_DMLUtilities.SubmitEntityUpdate');
						System.debug(err.getStatusCode() + ': ' + err.getMessage());
						System.debug('Fields that affected this error: ' + err.getFields());
						
						retVals.get(associatedId).add(err);
					}
				}
			}
            
            return retVals;
		}
		catch(Exception ex)
		{
			System.debug('Exception occured when trying to persist updated ' + allObs.getSObjectType().getDescribe().getName() 
							+ ' info into database in MFS_DMLUtilities.SubmitEntityUpdate: ' + ex.getMessage());
			throw ex;
		}
	}
	
	public static Map<Id, List<DataBase.Error>> SaveEntity(List<SObject> allObs)
	{
		if (allObs.isEmpty())
		{
			throw new DmlException('Unable to persist records. Dataset empty.');
		}

		DataBase.SaveResult[] results = null;
		try
		{
			results = Database.update(allObs, false);
		}
		catch(Exception ex)
		{
			System.debug('Exception occured when trying to persist updated ' + allObs.getSObjectType().getDescribe().getName() 
							+ ' info into database in MFS_DMLUtilities.SubmitEntityUpdate: ' + ex.getMessage());
			throw ex;
		}
		
		Map<Id, List<DataBase.Error>> retVals = new Map<Id, List<Database.Error>>();
		for (Database.SaveResult sr : results)
		{
			if (!sr.isSuccess())
			{
                Id val = sr.getId();
                
				if (!retVals.containsKey(val))
				{
					retVals.put(val, new List<Database.Error>());
				}

				for(Database.Error err : sr.getErrors())
				{
					System.debug('Database error updating ' + allObs.getSObjectType().getDescribe().getName() + ' record Id = ' + val + ' in MFS_DMLUtilities.SubmitEntityUpdate');
					System.debug(err.getStatusCode() + ': ' + err.getMessage());
					System.debug('Fields that affected this error: ' + err.getFields());
					
					retVals.get(val).add(err);
				}
			}
		}
		
		return retVals;
	}
}