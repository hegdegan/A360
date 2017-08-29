@isTest
public class MFS_ProductApproval_Test {

    static testmethod void testProductApproval(){
        Test.startTest();
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec;
        Opportunity oppRec=MFS_TestDataUtility.createOpportunity(accRec.id);
        insert oppRec;
        Product2 prodRec=MFS_TestDataUtility.createProduct();
        insert prodRec; 
        PricebookEntry pbEntry=MFS_TestDataUtility.createPriceBEntry(prodRec);       
        insert pbEntry;  
        OpportunityLineItem oppLI=MFS_TestDataUtility.createOpportunityLineItem(oppRec,pbEntry.Id);
        insert oppLI;
        Test.setCurrentPage(Page.MFS_ProductApprovalPage);
        MFS_ProductApproval prdACtrl = new MFS_ProductApproval(new ApexPages.StandardController(oppRec)); 
        prdACtrl.refreshPage();
        System.assert(prdACtrl.feeAppRec!=null);        
        prdACtrl.toSelect=oppLI.Id;
        prdACtrl.submitForApproval();
        Approval_Request__c feeApprRec=[Select id,Approval_Status__c,RecordTypeId from Approval_Request__c where Opportuinty_ProductId__c=:oppLI.Id];
        Id recordTypeId=Schema.SObjectType.Approval_Request__c.getRecordTypeInfosByName().get('Fee Approval Request').getRecordTypeId();
        System.assert(feeApprRec.RecordTypeId==recordTypeId);
        System.assert(feeApprRec.Approval_Status__c=='Pending');   
        PageReference pageRef=prdACtrl.goBack();
        System.assert(pageRef!=null);  
        Test.stopTest();
    }
}