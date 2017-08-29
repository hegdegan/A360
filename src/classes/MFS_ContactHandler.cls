/**
Apex Class Name    : MFS_ContactHandler
Version            : 1.0 
Created Date       : 11 MAY 2016
Function           : Handler class that gets called by Contact Triggers 
when Contacts are created,updated and deleted
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   	Description
* ----------------------------------------------------------------------------                 
* Priya Gupta              	09/05/2016              	Original Version
* Christine Cui			12/06/2016			Add CRT flag functionality
* Matt Barth				05/03/2017			Added End Date custom field to accountcontactrelation update
**/
public class MFS_ContactHandler
{
	//call contact utilities class after insert
	public static void afterInsertContactEventHandler(Map<id, Contact> contactList)
	{
		List<Contact> lstContToUpdate = new List<Contact>();
		Set<Id> accountIdSet = new Set<Id>();
		List<Contact> contactsList = new List<Contact>([select Account.ShippingCity, Account.ShippingStreet, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode,
											 OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry,Account.Phone, Phone,RecordType.Name ,
                                             MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry 
											 from Contact where id IN :contactList.keySet()]);

		List<AccountContactRelation> acrToUpdateList = new List<AccountContactRelation>();
		acrToUpdateList = MFS_ContactUtilities.populateStartDate(contactList);
		if(acrToUpdateList.size()>0)
		{
			Database.SaveResult[] updAcr = Database.update(acrToUpdateList,false);   
		}

		lstContToUpdate = MFS_ContactUtilities.updateContactAddressOnInsert(contactsList);
		Database.SaveResult[] updLstCon = Database.update(lstContToUpdate,false);
	}
    
	//This method will update Geo Code, Contact Address and Plan Associations related to contact on 'after update' event 
	public static void afterUpdateContactEventHandler(Map<Id, Contact> newMap, Map<Id, Contact> oldMap)
	{
		// geoUpdateContactHandler(newMap,oldMap);
		List<Contact> lstContToUpdate = new List<Contact>();
		List<Contact> lstContToUpdateIfAccParentChanged = new List<Contact>();
		List<Plan_Association__c> planAccsnList = new List<Plan_Association__c>(); 
		List<Contact> contactsList = new List<Contact>([select id, AccountId, Account.ShippingCity, Account.ShippingStreet, Account.ShippingState,
                                                        Account.ShippingCountry, Account.ShippingPostalCode, Status__c,Account.Phone,Account.ParentId,
                                                        OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry,RecordType.Name,
                                                        MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry ,
                                                        (select id, CRT__c, Contact_Relationship_End_Date__c from Contact.Plan_Account_Relationships_del__r) from Contact where id IN : newMap.keySet()]);
		//Added - Manoj  - 12/15/2016                                              
		Set<Id> accIdSet = new Set<Id>();
		for(Contact con : oldMap.values())
		{
			accIdSet.add(con.AccountId);
		}
		
		Map<Id,Account> accoutMap = new Map<Id,Account>([select Id,ParentId from Account where Id in : accIdSet ]);
		//Finished - Manoj - 12/15/2016
        
		List<AccountContactRelation> acr = new List<AccountContactRelation>([select AccountId,StartDate, EndDate, ContactId from AccountContactRelation 
                                                                             where ContactId IN : newmap.keySet()]);
		List<AccountContactRelation> acrToUpdate = new List<AccountContactRelation>();
        
		for(Contact cont : contactsList)
		{
			Contact contNew = newMap.get(cont.id);
			Contact contOld = oldMap.get(cont.id);
            
			//If you change orgs...            
			if(contNew.AccountId != contOld.AccountId)
			{
                    for(Plan_Association__c plnAsscn : cont.Plan_Account_Relationships_del__r)
				{
					planAccsnList.add(plnAsscn);
				}
                              
				if(accoutMap.containsKey(contOld.AccountId))
				{
					Account acc = accoutMap.get(contOld.AccountId);
					if(cont.Account.ParentId != acc.ParentId && cont.RecordType.Name.containsIgnoreCase('Retail') )
					{
						lstContToUpdateIfAccParentChanged.add(cont);
					}
					else
					{
						lstContToUpdate.add(cont);
					}
				}
                 
			} //if you change orgs...
            
			//If you become inactive...
			if (contNew.Status__c != contOld.Status__c && ContNew.Status__c=='Inactive')
			{
				for(AccountContactRelation ac2 : acr)
				{
					if(ac2.ContactId == cont.Id)
					{
						ac2.EndDate = System.Today();
						ac2.End_Date__c = System.Today();

						acrToUpdate.add(ac2);
					}
				}
			}
		} //loop thru contacts

		List<Contact> contactsReadyToUpdateList = new List<Contact>();
		List<Contact> contResultForOrgParentChangeList = new List<Contact>();
		
		if(lstContToUpdate.size() > 0)
		{
			//Dedupe Contact List via Set
			Set<Contact> contSet = new Set<Contact>();
			List<Contact> contResult = new List<Contact>();
			contSet.addAll(lstContToUpdate);
			contResult.addAll(contSet);
			contactsReadyToUpdateList = MFS_ContactUtilities.updateContactAddress(contResult);
		}
        
		if(lstContToUpdateIfAccParentChanged.size() > 0)
		{
			contResultForOrgParentChangeList = MFS_ContactUtilities.updateContactDOJ(lstContToUpdateIfAccParentChanged);
		}
        
		List<Plan_Association__c> planAsscnToUpdateList = new List<Plan_Association__c>();
		
		if(planAccsnList.size() >0)
		{
			planAsscnToUpdateList = MFS_ContactUtilities.updatePlanAssociations(planAccsnList);
		}
        
		//Dedupe acr List via Set
		Set<AccountContactRelation> accContSet = new Set<AccountContactRelation>();
		accContSet.addAll(acrToUpdate);
		
		List<AccountContactRelation> accContResult = new List<AccountContactRelation>();
		accContResult.addAll(accContSet);
        
		Database.SaveResult[] updContact = Database.update(contactsReadyToUpdateList,false);
		Database.SaveResult[] updContactAsst = Database.update(contResultForOrgParentChangeList,false);
		Database.SaveResult[] updPlanAssc = Database.update(planAsscnToUpdateList,false);
		Database.SaveResult[] updAcr = Database.update(accContResult,false);
	}
    public static void beforeUpdateContactEventHandler(Map<Id, Contact> newMap, Map<Id, Contact> oldMap){
        
        
    }
}