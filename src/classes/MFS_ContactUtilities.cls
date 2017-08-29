/**
Apex Class Name    : MFS_ContactUtilities
Version            : 1.0 
Created Date       : 11 MAY 2016
Function           : Handler class that gets called by Contact Triggers 
when Contacts are created,updated and deleted
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta              09/05/2016              Original Version
**/
public class MFS_ContactUtilities {
    
    //Method to update Plan Association's "Contact Relationship End Date" to today's date when parent Contat's Organization Id is changed.
    public static List<Plan_Association__c> updatePlanAssociations(List<Plan_Association__c> lstPlanAsscn){
        List<Plan_Association__c> planAsscnToUpdateList = new List<Plan_Association__c>();
        for(Plan_Association__c plnAsscn : lstPlanAsscn ){
            plnAsscn.Contact_Relationship_End_Date__c = system.TODAY();
            plnAsscn.CRT__c = false;
            planAsscnToUpdateList.add(plnAsscn);
        }
        return planAsscnToUpdateList; 
    }
    
    //Method to update contact address with parent organization's address
    public static List<Contact> updateContactAddress(List<Contact> contactList){
        List<Contact> lstContToUpdate = new List<Contact>();
        for(Contact cont: contactList){
            cont = setContactaddressFields(cont);
            lstContToUpdate.add(cont);
        }
        return lstContToUpdate;
    }
    //Method to update address of Contacts from Account
    //Changed from account.shipping --> con.other to account.shipping --> con.mailing on 23 may by Manoj
    public static Contact setContactaddressFields(Contact cont){
        	cont.MailingCity = cont.Account.ShippingCity;
            cont.MailingStreet = cont.Account.ShippingStreet;
            cont.MailingState = cont.Account.ShippingState;
            cont.MailingCountry = cont.Account.ShippingCountry;
            cont.MailingPostalCode = cont.Account.ShippingPostalCode;
            if(cont.Phone == null || ''.equals(cont.Phone)){
            	cont.Phone = cont.Account.Phone;
            }
            
             if(cont.RecordType != null && cont.RecordType.Name != null && cont.RecordType.Name.containsIgnoreCase('Retail')){
	            cont.Assistant_Name__c = null;
	            cont.Assistant_Phone__c = null;
	            cont.Assistant_Email__c = null;	
	            cont.Home_Office__c = false;
            }
            return cont;
    }
    
    //Method to update contact address with parent organization's address
    public static List<Contact> updateContactAddressOnInsert(List<Contact> contactList){
        List<Contact> lstContToUpdate = new List<Contact>();
        for(Contact cont: contactList){
            system.debug('Contact Phone after save  '+cont.Phone);
            cont = setContactaddressFieldsOnInsert(cont);
            lstContToUpdate.add(cont);
        }
        return lstContToUpdate;
    }
    //Method to update address of Contacts from Account
    public static Contact setContactaddressFieldsOnInsert(Contact cont){
        //Changed from account.shipping --> con.other to account.shipping --> con.mailing on 23 may by Manoj
        //if(cont.OtherStreet == null || ''.equals(cont.OtherStreet)){
    		cont.MailingCity = cont.Account.ShippingCity;
            cont.MailingStreet = cont.Account.ShippingStreet;
            cont.MailingState = cont.Account.ShippingState;
            cont.MailingCountry = cont.Account.ShippingCountry;
            cont.MailingPostalCode = cont.Account.ShippingPostalCode;
        //}
            if(cont.Phone == null || ''.equals(cont.Phone)){
            	cont.Phone = cont.Account.Phone;
            }
            
             if(cont.RecordType != null && cont.RecordType.Name != null && cont.RecordType.Name.containsIgnoreCase('Retail')){
	            cont.Assistant_Name__c = null;
	            cont.Assistant_Phone__c = null;
	            cont.Assistant_Email__c = null;	
	            cont.Home_Office__c = false;
            }
            return cont;
    }
    
    //Method to update DOJ of Contacts
    public static List<Contact> updateContactDOJ(List<Contact> contactList){
    	List<Contact> lstContToUpdate = new List<Contact>();
    	for(Contact cont: contactList){
    		cont = setContactaddressFields(cont);
            cont.Date_Joined_Current_Firm__c = system.TODAY();          
            cont.email = null;
            lstContToUpdate.add(cont);
        }
        return lstContToUpdate;
        
    }
    
     //Method to populate Contact start Date
    public static List<AccountContactRelation> populateStartDate(Map<id, Contact> contactList){
        List<AccountContactRelation> acr = new List<AccountContactRelation>([select StartDate, Start_Date__c, ContactId from AccountContactRelation where ContactId IN : contactList.keySet()]);
        List<AccountContactRelation> acrToUpdate = new List<AccountContactRelation>();
        
        for(Id cntct : contactList.keySet()){
            for(AccountContactRelation ac : acr){
                if(ac.ContactId == cntct){
                    ac.StartDate = System.Today();
                    ac.Start_Date__c = System.Today();
                    acrToUpdate.add(ac);
                }
            }
        }
        return acrToUpdate;
    }
  
}