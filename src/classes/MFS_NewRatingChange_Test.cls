@isTest(SeeAllData=false)
public class MFS_NewRatingChange_Test {

     static testmethod void testRedirect()
    {
        Test.startTest();       
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Product2 prodRec=MFS_TestDataUtility.createProduct();
        insert prodRec;
        Consultant_Rating__c ratingRec=MFS_TestDataUtility.createConsRating(accRec.id,prodRec.id);
        insert ratingRec;
        List<StoreFieldIds__c> fieldIds=new List<StoreFieldIds__c>();
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Rating_Change__c','Consultant Rating','Consultant_Rating__c'));
        fieldIds.add(MFS_TestDataUtility.createFieldIDData('Rating_Change__c','Name','Name'));
        insert fieldIds;
        List<Rating_Change__c> ratingCList = new List<Rating_Change__c>{new Rating_Change__c()};
        PageReference pageRef = Page.MFS_NewRatingChange;
        pageRef.getParameters().put('Id',ratingRec.Id);
        Test.setCurrentPage(pageRef);
        MFS_NewRatingChange ratingChange=new MFS_NewRatingChange(new ApexPages.StandardSetController(ratingCList));   
        PageReference pageURL=ratingChange.redirect();    
        System.assert(pageURL!=null);             
        Test.stopTest();
    }
    
}