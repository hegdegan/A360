@isTest(seeAllData=false)
public class MFS_BusinessAtRiskRedirectControllerTest {
    static testMethod void redirectionTestInstitutional() {
        Account acc = MFS_TestDataUtility.createAccount();
        acc.MDM_ID__c = '1234567890';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Global Institutional Client').getRecordtypeId();
        insert acc;
        Business_At_Risk__c br = new Business_At_Risk__c();
        br.Organization__c = acc.Id;
        br.Expected_Loss_Date__c = System.Today();
        br.Percentage_at_Risk__c = 'Low';
        br.Expected_Loss_Date__c = System.Today()+1;
        br.Reason_at_Risk__c = 'Regulatory';
        br.Status__c = 'Open';
        insert br;
        PageReference pr =  new PageReference('/'+br.id);
        pr.getParameters().put('id',br.id);
        //pr.getParameters().put('retURL',br.id);
        Test.setCurrentPage(pr);
        MFS_BusinessAtRiskRedirectController BAR = new MFS_BusinessAtRiskRedirectController(new ApexPages.StandardController(br));
        Pagereference redirect = BAR.redirect();
        Pagereference redirectDetail = BAR.redirectDetail();
        
        PageReference pr1 =  new PageReference('/'+br.id);
        pr1.getParameters().put('id',br.id);
        pr1.getParameters().put('retURL',br.id);
        Test.setCurrentPage(pr1);
        MFS_BusinessAtRiskRedirectController BAR1 = new MFS_BusinessAtRiskRedirectController(new ApexPages.StandardController(br));
        Pagereference redirect1 = BAR1.redirect();
        Pagereference redirectDetail1 = BAR1.redirectDetail();
        
        br.type__c = 'Institutional';
        update br;
        PageReference pr2 =  new PageReference('/'+br.id);
        pr2.getParameters().put('id',br.id);
        pr2.getParameters().put('retURL',br.id);
        Test.setCurrentPage(pr2);
        MFS_BusinessAtRiskRedirectController BAR2 = new MFS_BusinessAtRiskRedirectController(new ApexPages.StandardController(br));
        Pagereference redirect2 = BAR1.redirect();
        Pagereference redirectDetail2 = BAR1.redirectDetail();
        //SONAR FIX
        system.assertNotEquals(null, redirectDetail2.getUrl());
        
    }
    
    static testMethod void redirectionTestRetail() {
        Account acc = MFS_TestDataUtility.createAccount();
        acc.MDM_ID__c = '1234567890';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Global Retail').getRecordtypeId();
        insert acc;
        Business_At_Risk__c br = new Business_At_Risk__c();
        br.Organization__c = acc.Id;
        br.Expected_Loss_Date__c = System.Today();
        br.Percentage_at_Risk__c = 'Low';
        br.Expected_Loss_Date__c = System.Today()+1;
        br.Reason_at_Risk__c = 'Regulatory';
        br.Status__c = 'Open';
        insert br;
        PageReference pr =  new PageReference('/'+br.id);
        pr.getParameters().put('id',br.id);
        //pr.getParameters().put('retURL',br.id);
        Test.setCurrentPage(pr);
        MFS_BusinessAtRiskRedirectController BAR = new MFS_BusinessAtRiskRedirectController(new ApexPages.StandardController(br));
        Pagereference redirect = BAR.redirect();
        Pagereference redirectDetail = BAR.redirectDetail();
        //SONAR FIX
        system.assertNotEquals(null, redirectDetail.getUrl());
    }
    
    static testMethod void redirectionTestInvstConsul() {
        Account acc = MFS_TestDataUtility.createAccount();
        acc.MDM_ID__c = '1234567890';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Investment Consultant').getRecordtypeId();
        insert acc;
        Business_At_Risk__c br = new Business_At_Risk__c();
        br.Organization__c = acc.Id;
        br.Expected_Loss_Date__c = System.Today();
        br.Percentage_at_Risk__c = 'Low';
        br.Expected_Loss_Date__c = System.Today()+1;
        br.Reason_at_Risk__c = 'Regulatory';
        br.Status__c = 'Open';
        insert br;
        PageReference pr =  new PageReference('/'+br.id);
        pr.getParameters().put('id',br.id);
        //pr.getParameters().put('retURL',br.id);
        Test.setCurrentPage(pr);
        MFS_BusinessAtRiskRedirectController BAR = new MFS_BusinessAtRiskRedirectController(new ApexPages.StandardController(br));
        Pagereference redirect = BAR.redirect();
        Pagereference redirectDetail = BAR.redirectDetail();
        //SONAR FIX
        system.assertNotEquals(null, redirectDetail.getUrl());
    }
}