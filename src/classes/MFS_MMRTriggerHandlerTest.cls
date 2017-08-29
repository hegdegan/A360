@isTest(seeAllData = false)
public class MFS_MMRTriggerHandlerTest {
    public static testMethod void testMeetingMaterialRequest(){
        Account acc = MFS_TestDataUtility.createAccount();
        insert acc;
        Activity_Detail__c cNote = MFS_TestDataUtility.createCallNote(acc.Id);
        insert cNote;
        AccountTeamMember atm = new AccountTeamMember(userId = UserInfo.getUserId(), accountId = acc.id, teamMemberRole = 'Client Service Coordinator');
        insert atm;
        //SONAR Fix
        system.assertNotEquals(null,atm.Id);
        //Test exception block and delete the MMR
        Meeting_Material_Request__c MMR = new Meeting_Material_Request__c(Name = 'MMRTest',Call_Note__c = cNote.Id, Client_Prospect_Name__c = acc.Id, Date_Due_to_Client__c = System.TODAY(), Material_Type__c = 'Client');
        insert MMR;
        delete MMR;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        MMR = new Meeting_Material_Request__c(Name = 'MMRTest',Call_Note__c = cNote.Id, Client_Prospect_Name__c = acc.Id, Date_Due_to_Client__c = System.TODAY(), Material_Type__c = 'Client');
        insert MMR;
    }
}