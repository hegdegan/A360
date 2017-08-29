@isTest(SeeAllData=false)
public class MFS_NewClientInvestmentObj_Test {
    
     static testmethod void testRedirect()
    {
        Test.startTest();
        FieldsUsedInButton__c objField=MFS_TestDataUtility.createFieldForButton('Account','Name','Name','Text');
        insert objField;   
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Strategy_Plan__c sPlan = MFS_TestDataUtility.createStrategyPlan(accRec.Id);
        insert sPlan;
        Client_Investment_Objective__c clientObjRec=MFS_TestDataUtility.createClientInverstment(accRec.Id);
        clientObjRec.Client_Strategy_Plan__c = sPlan.Id;
        insert clientObjRec;
        Strategy_Plan__c strategyPlan=MFS_TestDataUtility.createStrategyPlan(accRec.Id);
        insert strategyPlan;
        List<StoreFieldIds__c> fieldIds=new List<StoreFieldIds__c>();
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Client_Investment_Objective__c','Client Strategy Plan','Client_Strategy_Plan__c'));
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Client_Investment_Objective__c','Organization','Organization__c'));
        insert fieldIds;
        List<Client_Investment_Objective__c> clientObjList = new List<Client_Investment_Objective__c>{clientObjRec};
        PageReference pageRef = Page.MFS_NewClientInvestmentObj;
        pageRef.getParameters().put('Id',strategyPlan.Id);
        Test.setCurrentPage(pageRef);
        MFS_NewClientInvestmentObj newClientObj=new MFS_NewClientInvestmentObj(new ApexPages.StandardSetController(clientObjList));   
        PageReference pageURL=newClientObj.redirect();    
        System.assert(pageURL!=null);             
        Test.stopTest();
    }


}