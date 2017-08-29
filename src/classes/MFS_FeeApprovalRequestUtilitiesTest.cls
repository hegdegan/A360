/***************************************************************************************************
Apex Class Name    : MFS_FeeApprovalRequestUtilitiesTest
Version            : 1.0 
Created Date       : 16 JUN 2016
Function           : This is a Test class for FreeApprovalRequestTrigger and dependent classes(Handler and Utility)
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            06/16/2016              Original Version
***************************************************************************************************/
@isTest
public class MFS_FeeApprovalRequestUtilitiesTest {
    //Bulk Testing is not required because VF page will insert only one record at a time.
    static testmethod void changStatusTest()
    {
        Test.StartTest();
        try{
            User usr = MFS_TestdataUtility.createUser('System Administrator');
            insert usr;
            
            Account acc = MFS_TestDataUtility.createAccount();
            insert acc;
            Opportunity opp = MFS_TestDataUtility.createOpportunity(acc.Id);
            insert opp;
            Product2 prodRec=MFS_TestDataUtility.createProduct();
            insert prodRec; 
            PricebookEntry pbEntry=MFS_TestDataUtility.createPriceBEntry(prodRec);       
            insert pbEntry;
            OpportunityLineItem oppLinItem = MFS_TestDataUtility.createOpportunityLineItem(opp.id, pbEntry.id);
            insert oppLinItem;
            Approval_Request__c far = MFS_TestDataUtility.createFeeApprovalRequest(opp.id, oppLinItem.id, usr.Id);
            insert far;
            System.runAs(usr)
            {
                
                Approval_Request__c fee = [select Id,Approval_Status__c,Discount__c,Next_Approver__c from Approval_Request__c where id=:far.id ];
                fee.Approval_Status__c = 'Approved';
                update fee;
                fee.Discount__c=5.00;
                update fee;
                
                OpportunityLineItem oppLI = [select Approval_Status__c from OpportunityLineItem where id= :oppLinItem.id];
                system.assertEquals('Approved', oppLI.Approval_Status__c);
                fee.Next_Approver__c=usr.Id;
                fee.Discount__c=25.00;
                update fee;
                
                
            }
            far.Approval_Status__c = 'Approved';
            far.Approver_Group__c = 'Non-US Questionnaire Approver Group';
            update far;
            
            
        }
        catch(DmlException e)
        {
            String message = e.getMessage();
            
        }
        Test.stopTest();
       }
    
    static testmethod void ApprovalRequestTest(){
        Account accRec=MFS_TestDataUtility.createAccount();
        insert accRec; 
        Contact cont = MFS_TestDataUtility.createContact(accRec.id);
        insert cont;
        Case caseRec1 = MFS_TestDataUtility.createCase(cont);
        caseRec1.recordtypeid= Schema.SObjectType.Case.getRecordTypeInfosByName().get(MFS_AllConstants.APPROVAL_DOMESTIC_RT).getRecordtypeId();
        caseRec1.Non_US_Questionnaire_Approval_Group__c = true;
        caseRec1.Compliance_AML_KYC__c = true;
        caseRec1.Corporate_Finance__c = true;
        caseRec1.GDS_Acknowledgement__c = userinfo.getUserId();
        caseRec1.Funds_Lawyer__c = userinfo.getUserId(); 
        caseRec1.FATCA_Lawyer__c = userinfo.getUserId();
        caseRec1.Final_Acknowledgement__c = userinfo.getUserId(); 
        caseRec1.Distribution_Lawyer__c = userinfo.getUserId();
        caseRec1.AML_Lawyer__c = userinfo.getUserId();
        insert caseRec1;
        MFS_DomesticCaseApprovalCtrl caseCtrl=new MFS_DomesticCaseApprovalCtrl(new ApexPages.StandardController(caseRec1));  
        PageReference pageRef=caseCtrl.submitForApproval();
        System.assert(pageRef!=null);
        Approval_Request__c appr = [Select Approval_status__c from Approval_Request__c where Onboarding_case__c =: caseRec1.Id];
        appr.Approval_Status__c = 'Approved';
        update appr;
        
        Case caseRec = MFS_TestDataUtility.createCase(cont);
        RecordType rt = [select id from RecordType where DeveloperName='Retail_Amendment' and SobjectType='Case' LIMIT 1];
        caseRec.recordtypeid= rt.Id;//Schema.SObjectType.Case.getRecordTypeInfosByName().get('Amendment (URF)').getRecordtypeId();
        caseRec.AccountId = accRec.Id;
        caseRec.Strategic_Alliance_Department_Heads__c = true;
        caseRec.Corporate_Finance_Billing_Approver__c = userinfo.getUserId();
        caseRec.GDS_Acknowledgement__c = userinfo.getUserId();
        caseRec.Compliance_AML_KYC_Approver__c = userinfo.getUserId();
        caseRec.CFO_Onboarding_Retail_Lookup__c = userinfo.getUserId();
        caseRec.Co_Heads_of_Global_Distribution__c = userinfo.getUserId();
        insert caseRec;
        MFS_DomesticCaseApprovalCtrl caseCtrl1=new MFS_DomesticCaseApprovalCtrl(new ApexPages.StandardController(caseRec));  
        PageReference pageRef1=caseCtrl1.submitForApproval();
        System.assert(pageRef1!=null);
        List<Approval_Request__c> apprList = [Select Approval_status__c from Approval_Request__c where Onboarding_case__c =: caseRec.Id];
        List<Approval_Request__c> apprListToUpdate =  new List<Approval_Request__c>();
        for(Approval_Request__c app : apprList)
        {
           app.Approval_Status__c = 'Approved'; 
           apprListToUpdate.add(app); 
        }
        update apprListToUpdate;
    }
 }