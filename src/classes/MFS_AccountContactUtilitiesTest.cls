@isTest(seeAllData=false)
public class MFS_AccountContactUtilitiesTest
{
	public static testMethod void testAccountContactRelationTrigger(){
        List<Account> accList = MFS_TestDataUtility.createBulkAccounts(3);
        insert accList;
        List<Contact> tempConList = MFS_TestDataUtility.createBulkContacts(accList, 10);
        List<Contact> conList = new List<Contact>();
        for(Contact c : tempConList)
        {
            c.Status__c = 'Active';
            c.Contact_Role__c = 'Competitor';
            conList.add(c);
        }
        insert conList;
        Contact con = MFS_TestDataUtility.createContact(accList[0].id);
        insert con;
        //insert new accountcontactrelation
        AccountContactRelation acr = new AccountContactRelation(AccountId = accList[1].Id, contactId = con.Id, Primary_Relationship__c= true );
        insert acr;
        AccountContactRelation updateRelation = [select id, StartDate, Start_Date__c, End_Date__c, EndDate, IsActive, Active__c, Primary_Relationship__c from AccountContactRelation where id= :acr.Id LIMIT 1];
        //update accountcontactrelation
        updateRelation.EndDate = System.today() + 10;
        update updateRelation;
        
        //update accountcontactrelation again by modifying the values to satisfy trigger/handler/utility condition
        updateRelation.Start_Date__c = null;
        updateRelation.End_Date__c = null;
        update updateRelation;
        
        
    }
    
	/*public static testMethod void testValidatePrimaryFlag()
	{
        

	}

	public static testMethod void testSyncBeforeInsert()
	{
		AccountContactRelation newRel = new AccountContactRelation();
		newRel.Active__c = true;
		newRel.IsActive = false;

		List<AccountContactRelation> rels = new List<AccountContactRelation>();
		rels.add(newRel);

		MFS_AccountContactRelationUtilities.syncStandardActiveStartEndDateBeforeInsert(rels);
		System.assert(newRel.IsActive, 'Standard Active field should have been flipped to true');

		newRel.Active__c = null;
		MFS_AccountContactRelationUtilities.syncStandardActiveStartEndDateBeforeInsert(rels);
		System.assert(newRel.Active__c, 'Custom Active field should have been flipped to true');

		newRel.Active__c = null;
		newRel.IsActive = null;
		
		newRel.Start_Date__c = date.today();
		MFS_AccountContactRelationUtilities.syncStandardActiveStartEndDateBeforeInsert(rels);
		System.assert(newRel.StartDate == date.today(), 'Standard Start Date field should have been flipped to true');

		newRel.Start_Date__c = null;
		MFS_AccountContactRelationUtilities.syncStandardActiveStartEndDateBeforeInsert(rels);
		System.assert(newRel.Start_Date__c == date.today(), 'Custom Start Date field should have been flipped to true');

		newRel.StartDate = null;
		newRel.Start_Date__c = null;
		
		newRel.End_Date__c = date.today();
		MFS_AccountContactRelationUtilities.syncStandardActiveStartEndDateBeforeInsert(rels);
		System.assert(newRel.EndDate == date.today(), 'Standard End Date field should have been flipped to true');

		newRel.End_Date__c = null;
		MFS_AccountContactRelationUtilities.syncStandardActiveStartEndDateBeforeInsert(rels);
		System.assert(newRel.End_Date__c == date.today(), 'Custom End Date field should have been flipped to true');		
	}

	public static testMethod void testSyncBeforeUpdate()
	{
		Map <Id, AccountContactRelation> newRecs = new Map <Id, AccountContactRelation>();
		Map <Id, AccountContactRelation> oldRecs = new Map <Id, AccountContactRelation>();

		Id recId = MFS_TestDataUtility.getFakeId(AccountContactRelation.SObjectType);
		
		AccountContactRelation oldRel = new AccountContactRelation(Id = recId);
		AccountContactRelation newRel = new AccountContactRelation(Id = recId);

		newRecs.put(newRel.Id, newRel);
		oldRecs.put(oldRel.Id, oldRel);

		oldRel.Active__c = false;
		newRel.IsActive = false;
		newRel.Active__c = true;

		MFS_AccountContactRelationUtilities.syncStandardActiveStartEndDateBeforeInsertUpdate(oldRecs, newRecs);
		system.assert(newRel.IsActive, 'Standard Active should have been flipped to true');

		oldRel.Active__c = null;
		newRel.Active__c = null;
		MFS_AccountContactRelationUtilities.syncStandardActiveStartEndDateBeforeInsertUpdate(oldRecs, newRecs);
		system.assert(newRel.Active__c, 'Custom Active should have been flipped to true');
	}*/
}