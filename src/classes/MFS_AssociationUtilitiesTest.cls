@isTest
public class MFS_AssociationUtilitiesTest {

    public static testMethod void insertupdatePlanAssociationTest()
    {
        List<Account> accts = new List<Account>();
        List<Contact> conts = new List<Contact>();
        List<Product2> pd = new List<Product2>();
        List<Plan__c> pls = new List<Plan__c>();
        List<Account__c> acList = new List<Account__c>();
        List<Plan_Association__c> planAsscn = new List<Plan_Association__c>();
        Account acc1 = MFS_TestDataUtility.createAccount();
        insert acc1;
        accts.add (acc1);
        Contact cont1 = MFS_TestDataUtility.createContact(acc1.id);       
        insert cont1;
        conts.add(cont1);
        Plan__c pl = MFS_TestDataUtility.createPlan(acc1.id); 
        insert pl;
        pd = MFS_TestDataUtility.createBulkPortfolioProduct();
        insert pd;
        List<Product2> prod = [Select Id from Product2 where name like 'testPortfolio%' order by CreatedDate desc LIMIT 3];
        acList = MFS_TestDataUtility.createBulkClientInvestment(acc1.Id, pl.Id, prod);
        insert acList;
        Plan_Association__c planAsscn1 = MFS_TestDataUtility.createPlanAsscnwithPlan(cont1.id, pl.Id);
        planAsscn1.Contact_Role__c='Accounting';
        MFS_Utilities.runReset();
        try{
        insert planAsscn1;
        }catch(Exception e){
           system.debug(e.getMessage()); 
        }
        System.debug('planAsscn1:'+planAsscn1);
        List<Plan_Association__c> pac = [Select Id, name, investment__c from Plan_Association__c where Plan__c =: pl.Id and Contact__c =: cont1.id and 
                                         Organization1__c = : acc1.Id order by CreatedDate desc];
        System.debug('pac:'+pac);
        integer i=0;
        for(Plan_Association__c pa: pac)
        {  i++;
            }
        system.assertEquals(3, i);
}
}