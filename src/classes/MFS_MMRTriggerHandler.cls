/***************************************************************************************************
Apex Class Name    : MFS_MMRTriggerHandler 
Version            : 1.0 
Created Date       : 10 NOV 2016
Function           : This is an handler for MMR Trigger
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde                 10/11/2016                Original Version
***************************************************************************************************/
public class MFS_MMRTriggerHandler {
    //Method to send an email to Client Service Coordinator
    public static void afterInsertEventHandler(Map<Id,Meeting_Material_Request__c> newMMRMap){
        
        Set<String> usrEmailIds = new Set<String>();
        Map<Id, Id> accMMRIds = new Map<Id, Id>();
        Map<Id, Set<String>> mmrUserMap = new Map<Id, Set<String>>();
        try{
            for(Meeting_Material_Request__c mmr : newMMRMap.values())
            {
                accMMRIds.put(mmr.Client_Prospect_Name__c, mmr.Id);
            }
            List<Account> accList = new List<Account>([select id, (select id, User.Email from AccountTeamMembers where teamMemberRole = 'Client Service Coordinator') from Account where Id In : accMMRIds.keySet()]);
            for(Account acc : accList)
            {
                for(AccountTeamMember ATM : acc.AccountTeamMembers)
                {
                    usrEmailIds.add(ATM.User.Email);
                }
                if(usrEmailIds.size() > 0)
                    mmrUserMap.put(accMMRIds.get(acc.Id), usrEmailIds);
            }
            Contact cont = [Select Id,Email from Contact limit 1];
            Id emailTemplateId = [Select Id from EmailTemplate where DeveloperName = 'Notify_when_MMR_is_created'].Id;
            for(Id mmrId : mmrUserMap.keySet())
            {   
                List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(emailTemplateId);
                mail.setWhatId(mmrid);
                mail.setTargetObjectId(cont.Id);
                mail.saveAsActivity = false;
                String[] to = new String[]{};
                    for(String emailId : mmrUserMap.get(mmrId))
                {
                    to.add(emailId);
                }
                mail.setToAddresses(to);
                msgList.add(mail);
                Savepoint sp = Database.setSavepoint(); 
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(msgList);
                }
                Database.rollback(sp);
                List<Messaging.SingleEmailMessage> msgListToSend = new List<Messaging.SingleEmailMessage>();
                for(Messaging.SingleEmailMessage email : msgList){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(email.getToAddresses());
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    msgListToSend.add(emailToSend);
                }
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(msgListToSend); 
                }
            }
        }catch(Exception ex){
            system.debug('Error while sending an email: '+ex.getMessage()+' - '+ex.getLineNumber());
        }
    } 
}