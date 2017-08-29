@isTest(SeeAllData=false)
public class MFS_OrgNewConsultantStrategyRating_Test {
     static testmethod void testRedirect()
    {
        Test.startTest();
       
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Strategy_Rating_Process__c strrate = new Strategy_Rating_Process__c(Consultant__c = accRec.Id);
        insert strrate;
        List<Strategy_Rating_Process__c> srList = new List<Strategy_Rating_Process__c>();
        srList.add(strrate);
        List<StoreFieldIds__c> fieldIds=new List<StoreFieldIds__c>();
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Strategy_Rating_Process__c','Consultant','Consultant__c'));
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Strategy_Rating_Process__c','Name','Name'));
        insert fieldIds;
        
        MFS_OrgNewConsultantStrategyRating consultantRating=new MFS_OrgNewConsultantStrategyRating(new ApexPages.StandardSetController(srList));   
        PageReference pageURL=new PageReference('/'+accRec.id);    
        pageURL.getParameters().put('Id',accRec.id); 
        test.setCurrentPage(pageURL);
        PageReference result = consultantRating.redirect();
        //SONAR Fix
        System.assertNotEquals(null,result.getUrl());
        Test.StopTest();
    }
    

}