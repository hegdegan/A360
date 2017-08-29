/**
Apex Class Name    : MFS_EventRequestUtilities
Version            : 1.0 
Created Date       : 17 Aug 2016
Function           : Utility class that gets called by Event Request Triggers 
when Event Request records are updated
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              17/08/2016              Original Version
**/
public with sharing class MFS_EventRequestUtilities {
    //Fetch the Notification users and send them email notification after update of Event Request records
    public static void emailNotificationToUsers(Map<Id,Event_Request__c> newSpeakerMap,Map<Id,Event_Request__c> oldSpeakerMap){
        Set<Id> usrId = new Set<Id>();
        Set<Id> spkrId = new Set<Id>();
        List<Event_Request__c> eReqList = new List<Event_Request__c>([Select Start_Date__c,End_Date__c,Location__c from Event_Request__c where Id in : newSpeakerMap.keySet()]);
        try{
            for(Event_Request__c sr : eReqList){
                Event_Request__c spNew = newSpeakerMap.get(sr.Id);
                Event_Request__c spOld = oldSpeakerMap.get(sr.Id);
                if((spNew.Start_Date__c != spOld.Start_Date__c) || (spNew.End_Date__c != spOld.End_Date__c) || (spNew.Location__c != spOld.Location__c))
                    spkrId.add(sr.Id);
            }
            if(spkrId.size()>0){
                List<Event_Request__c> spkrreq = new List<Event_Request__c>([select Id,Name, (select Id,User__c,User__r.id, User__r.Email from Notify_Users__r) from Event_Request__c where Id in : spkrId ]);
                Contact cont = [Select Id,Email from Contact limit 1];
                Id emailTemplateId = [Select Id from EmailTemplate where DeveloperName =: Label.Speaker_Request_Changes_Notify_Creator_Template].Id;
                for(Event_Request__c sr : spkrreq){
                    if(sr.Notify_Users__r != null){
                       String[] to = new String[]{};
                            for(Notify_User__c nu : sr.Notify_Users__r){
                               to.add(nu.User__r.Email);
                            }
                        
                        
                        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTemplateId(emailTemplateId);
                        mail.setWhatId(sr.Id);
                        mail.setTargetObjectId(cont.Id);
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
                }
            }
        } catch(Exception ex){
            System.debug('Execption occured:'+ex.getMessage());
        } 
    }   
}