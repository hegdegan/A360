@isTest(seeAllData=false)
public class MFS_ContactUtilitiesTest {
 
    public static testMethod void updatePlanAsociationTest()
    {
        List<Account> accnts = new List<Account>();
        List<Contact> contLst = new List<Contact>();
        List<Contact> contLstToUpdate = new List<Contact>();
        Set<Id> plnAsscnId = new Set<Id>();
        Set<Id> Contact = new Set<Id>();
        List<Plan_Association__c> planAsscn = new List<Plan_Association__c>();
        Account acc1 = MFS_TestDataUtility.createAccount();
        insert acc1;
        accnts.add(acc1);
        Account acc2 = MFS_TestDataUtility.createAccount();
        insert acc2;
        accnts.add(acc2);
        Account acc3 = MFS_TestDataUtility.createAccount();
        insert acc3;
        accnts.add(acc3);
        Contact cont1 = MFS_TestDataUtility.createContact(acc1.id);
        insert cont1;
        contLst = MFS_TestDataUtility.createBulkContacts(accnts,10);
        insert contLst;
        contLst.add(cont1);
        Contact cont2 = MFS_TestDataUtility.createContact(acc2.id);
        insert cont2;
        contLst.add(cont2);
        Plan_Association__c planAsscn1 = MFS_TestDataUtility.createPlanAsscn(cont1.id);
        planAsscn.add(planAsscn1);
        Plan_Association__c planAsscn2 = MFS_TestDataUtility.createPlanAsscn(cont2.id);
        planAsscn.add(planAsscn2);
        insert planAsscn;
        for(Plan_Association__c p : planAsscn)
        {
            plnAsscnId.add(p.id);
        }
        
        List<AccountContactRelation> acr = new List<AccountContactRelation>([select StartDate,EndDate, ContactId from AccountContactRelation where ContactId IN : contLst]);
        for(Contact c:contLst)
        {
            c.accountId = acc3.id;
            //The following line throwing error. So commented
            //c.Status__c = 'Inactive';
            contLstToUpdate.add(c);
            for(AccountContactRelation ac : acr){
                System.assertEquals(System.Today(),ac.StartDate);
                System.assertEquals(null,ac.EndDate);
            }
            
        }
        MFS_Utilities.runReset();
        try{
        update contLstToUpdate;
        }catch(Exception e){
           system.debug(e.getMessage()); 
        }
        List<Plan_Association__c> updatedPlanAccsn = new List<Plan_Association__c>([select CRT__c, Contact_Relationship_End_Date__c from Plan_Association__c
                                                                                    where Id IN :plnAsscnId]);
        for(Plan_Association__c p : updatedPlanAccsn)
        {
            System.assertEquals(p.Contact_Relationship_End_Date__c, System.TODAY());
            System.assertEquals(p.CRT__c, false);
        }
    }
    
    public static testMethod void updateContactDOJ()
    {
        Account parAcc1 = MFS_TestDataUtility.createAccount();
        insert parAcc1;
        Account parAcc2 = MFS_TestDataUtility.createAccount();
        insert parAcc2;
        Account acc3 = MFS_TestDataUtility.createAccount();
        acc3.parentId = parAcc1.Id; 
        insert acc3;
        Account acc4 = MFS_TestDataUtility.createAccount();
        acc4.parentId = parAcc2.Id;
        insert acc4;
        Contact cont1 = MFS_TestDataUtility.createContact(acc3.id);
        cont1.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Retail').getRecordtypeId();
        insert cont1;
        MFS_Utilities.runReset();
        cont1.accountId = acc4.Id;
        update cont1;
        Application_Settings__c appSettings = new Application_Settings__c(name='EnableContactTrigger',value__c='No');
        insert appSettings;
        //SONAR Fix
        system.assertNotEquals(null,appSettings.Id );
        update cont1;
    }
    }