@isTest
public class MFS_DistributionListUtilitiesTest {
 public static testMethod void updateDistributionListTest()
 {  List<Distribution_List__c> dlcUpdateList = new List<Distribution_List__c>();
    Account acc1 = MFS_TestDataUtility.createAccount();
    insert acc1;
    Distribution_List__c dlc = MFS_TestDataUtility.createDistributionList(acc1.Id);
    insert dlc;   
    Plan_Association__c pac = MFS_TestDataUtility.createPlanAsscnwithDistList(acc1.Id, dlc.Id);
  	pac.Contact_role__c = 'Auditor';
    insert pac;
    List<Distribution_List__c> dlcList = new List<Distribution_List__c>([Select Id, Status__c from Distribution_List__c where Id =: dlc.Id]);
    for(Distribution_List__c dList: dlcList){
        dList.Status__c = 'Inactive';
        dlcUpdateList.add (dList);
    }    
    MFS_Utilities.runReset();
        try{
        update dlcUpdateList;
        }catch(Exception e){
           system.debug(e.getMessage()); 
        }
    List<Plan_Association__c> pacLst = new List<Plan_Association__c> ([Select Id, CRT__c, Contact_Relationship_End_Date__c from Plan_Association__c where Id =: pac.Id]);
    for(Plan_Association__c pasc: pacLst)
    {
        system.assertEquals(System.TODAY(), pasc.Contact_Relationship_End_Date__c);
        system.assertEquals(false, pasc.CRT__c);
    }
 }
 }