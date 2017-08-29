/***************************************************************************************************
Apex Class Name    : MFS_OpportunityUtilitiesTest
Version            : 1.0 
Created Date       : 26 JUL 2016
Function           : This is a Test class for OpportunityTrigger and dependent classes(Handler and Utility)
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            07/26/2016              Original Version
***************************************************************************************************/
@isTest
public class MFS_OpportunityUtilitiesTest {
    static testmethod void changeOwnerTest()
    {
        Test.StartTest();
        try{
            List<Opportunity> opptnty = new List<Opportunity>();
            User usr = MFS_TestdataUtility.createUser('System Administrator');
            insert usr;
            
            Account acc = MFS_TestDataUtility.createAccount();
            insert acc;
            
            //Platform__c pltform = MFS_TestDataUtility.createPlatform(acc.id);
            //insert pltform;
            RecordType rt=[select id, name from RecordType where SObjectType='Opportunity' AND Name = 'Retail/Professional Buyer' LIMIT 1];
            List<Opportunity> oppList = MFS_TestDataUtility.createBulkOpportunities(acc.Id, 10, rt.id);
            insert oppList;
            Application_Settings__c appsettings=new Application_Settings__c();
            appsettings.Name='IntegrationProfileId';
            appsettings.value__c='00eP0000000HqIb';
            insert appsettings;
            Set<Id> opptyIds = new Set<Id>();
            Map<Id,Id> opportunityTeamMember = new Map<Id,Id>();
            List<AccountTeamMember> act = new List<AccountTeamMember>([select UserId,AccountId from AccountTeamMember where AccountId =: acc.ID]);
            Map<Id,Id> accountTeamMember = new Map<Id,Id>();
            for(AccountTeamMember atm : act)
            {
                accountTeamMember.put(atm.AccountId,atm.UserId);
            }
            System.debug('accountTeamMember..'+accountTeamMember);
            List<OpportunityTeamMember> otm = new List<OpportunityTeamMember>([Select UserId,OpportunityId from OpportunityTeamMember where OpportunityId in : oppList]);
            for(OpportunityTeamMember opp : otm)
            {
                opportunityTeamMember.put(opp.OpportunityId,opp.UserId);
            }
            
            List<Opportunity> oppToUpdate=new List<Opportunity>();
         
                
            for(Opportunity oppty : [select Id,OwnerId from Opportunity where Id in : oppList ]) 
            {
                opptyIds.add(oppty.id);
                System.assertEquals(oppty.OwnerId, opportunityTeamMember.get(oppty.Id));
            }
            delete otm;
            
               for(Opportunity oppty : [select Id,OwnerId from Opportunity where Id in : oppList ]) 
            {
                oppty.OwnerId=usr.Id;
                oppToUpdate.add(oppty);              
            }
            update oppToUpdate;
            List<Opportunity> op = new List<Opportunity>([select Id,AccountID from Opportunity where Id in : oppList]);
            for(Opportunity oppty : op)
            {
                System.assertEquals(accountTeamMember.get(oppty.AccountId),opportunityTeamMember.get(oppty.Id));
            }
            
            Account acc1 = MFS_TestDataUtility.createAccount();
            insert acc1;
            for(Opportunity opp : oppList)
            {
                opp.AccountId = acc1.Id;
                opp.stageName = 'In Progress';
                opp.Notification_Date__c = system.today();
                opptnty.add(opp);
            }
            update opptnty;
          }
        catch(DmlException e)
        {
            String message = e.getMessage();
        }
        Test.stopTest();
    }
}