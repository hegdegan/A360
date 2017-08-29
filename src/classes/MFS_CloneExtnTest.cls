@isTest
public class MFS_CloneExtnTest {
    static testmethod void testCampaignRedirection(){
        Test.StartTest();
        Campaign campn = MFS_TestDataUtility.createCampaign();
        MFS_CloneExtn cloneContrl1 = new MFS_CloneExtn(new ApexPages.StandardController(campn));
        insert campn;
        MFS_CloneExtn cloneContrl = new MFS_CloneExtn(new ApexPages.StandardController(campn));
        pagereference pageRef=cloneContrl.redirect();        
        pageRef=cloneContrl.redirect();
        System.assert(pageRef!=null);
        Test.StopTest();
    }

}