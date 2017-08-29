@isTest(seeAllData = false)
public class MFS_ClientInvestmentTriggerTest {
    @testSetup
    static void setup(){
        RecordType accRetailRT=[select id, name from RecordType where SObjectType='Account' AND Name = 'Global Retail' LIMIT 1];
        //Custom settings Entries
        List<Application_Settings__c> appSettingsList = MFS_TestDataUtility.getappSettingsList();
        insert appSettingsList;
        Account accRet = MFS_TestDataUtility.createAccount();
        accRet.RecordtypeId = accRetailRT.Id;
        accRet.MDM_ID__c = 'RET12345678';
        insert accRet;
        Contact con = MFS_TestDataUtility.createContact(accRet.Id);
        insert con;
        Plan__c plan = MFS_TestDataUtility.createPlan(accRet.Id);
        insert plan;
        Plan_Association__c planAsso = MFS_TestDataUtility.createPlanAsscnwithPlan(con.Id, plan.Id);
        planAsso.All_Plans__c = true;
        insert planAsso;
        List<Product2> prodList = MFS_TestDataUtility.createBulkProduct();
        insert prodList;
        List<Account__c> clInvList = MFS_TestDataUtility.createBulkClientInvestment(accRet.Id, plan.Id,prodList);
        MFS_Utilities.runReset();
        insert clInvList;
    }
    static testmethod void testClientInvestmentTrigger(){
        Account acc = [select Id from Account where Name = 'TestAccount' and MDM_ID__c = 'RET12345678'];
        List<Account__c> clInvstList = [select Id, Name, Organization__c, Portfolio__c from Account__c where organization__c =: acc.Id ];
        MFS_Utilities.runReset();
        delete clInvstList;
        clInvstList = [select Id, Name, Organization__c, Portfolio__c from Account__c where organization__c =: acc.Id ];
        //SONAR Fix
        system.assert(clInvstList.size() == 0 );
        
    }
    
}