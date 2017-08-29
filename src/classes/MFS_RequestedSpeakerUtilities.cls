/***************************************************************************************************
Apex Class Name    : MFS_RequestedSpeakerUtilities
Version            : 1.0 
Created Date       : 28 Sep 2016
Function           : Trigger utility for Requested Speaker
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey            09/28/2016              Original Version
***************************************************************************************************/
public class MFS_RequestedSpeakerUtilities {
    //update the overall status of related Event Request and sent a email notification if all the requested Speakers are approved
    public static void pendingOverallApprovalProcess(Map<Id,Event_Relation__c> newMapList, Map<Id,Event_Relation__c> oldMapList){
        Account acc;
        try {
            List<Event_Relation__c> reSpkr = new List<Event_Relation__c>([Select Approval_Status__c from Event_Relation__c where Id in : newMapList.keyset() LIMIT 50000]);
            List<Event_Request__c> EReqToUpdate = new List<Event_Request__c>();
            Set<Id> evrsID = new Set<Id>();
            Set<Id> evrsIDForEmail = new Set<Id>();
            Integer totalNoOfRecords;
            Integer totalNoOfRecordsApproved;
            for(Event_Relation__c rs : reSpkr){
                Event_Relation__c rsNew = newMapList.get(rs.Id);
                Event_Relation__c rsOld = oldMapList.get(rs.Id);
                if(rsNew.Approval_Status__c != rsOld.Approval_Status__c){
                    if(rsNew.Approval_Status__c == MFS_AllConstants.STATUS_PENDING || rsNew.Approval_Status__c == MFS_AllConstants.STATUS_APPROVED || rsNew.Approval_Status__c == MFS_AllConstants.STATUS_REJECTED){
                        evrsID.add(rsNew.Speaker_Request__c);
                    }
                    if(rsNew.Approval_Status__c == MFS_AllConstants.STATUS_APPROVED){
                        evrsIDForEmail.add(rsNew.Speaker_Request__c);
                    }
                }
            }
            
            if(evrsID.size()>0){
                List<Event_Request__c> eReq = new List<Event_Request__c>([Select Overall_Approval_Status__c from Event_Request__c where Id in : evrsID LIMIT 50000]);
                for(Event_Request__c evr : eReq ){
                    evr.Overall_Approval_Status__c = MFS_AllConstants.STATUS_PENDING;
                    EReqToUpdate.add(evr);
                } 
            }
            
            if(evrsIDForEmail.size()>0){
                List<Event_Relation__c> eRel = new List<Event_Relation__c>([Select Approval_Status__c,Speaker_Request__r.Name from Event_Relation__c where Speaker_Request__c in : evrsIDForEmail LIMIT 50000]);
                List<String> idList = new List<String>();
                Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name =: System.Label.Event_Change_Notify_Public_Group];
                for (GroupMember gm : g.groupMembers) {
                    idList.add(gm.userOrGroupId);
                }
                User[] usr = [SELECT email FROM user WHERE id IN :idList];
                Contact cont = [Select Id,Email from Contact limit 1];
                Id emailTemplateId = [Select Id from EmailTemplate where DeveloperName =: Label.All_Requested_Speakers_Approved_Template].Id;
                for(Id evr : evrsIDForEmail){
                    totalNoOfRecords = 0;
                    totalNoOfRecordsApproved = 0;
                    for(Event_Relation__c eRelation : eRel){
                        if(eRelation.Speaker_Request__c == evr){
                            totalNoOfRecords++;
                            if(erelation.Approval_Status__c == MFS_AllConstants.STATUS_APPROVED){
                                totalNoOfRecordsApproved++;
                            }
                        }
                    }
                    
                    if(totalNoOfRecords == totalNoOfRecordsApproved){
                        List<String> mailToAddresses = new List<String>();
                        for(User u : usr) {
                            mailToAddresses.add(u.email);
                        }
                        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTemplateId(emailTemplateId);
                        mail.setWhatId(evr);
                        mail.setTargetObjectId(cont.Id);
                        mail.setToAddresses(mailToAddresses);
                        msgList.add(mail);
                        Savepoint sp = Database.setSavepoint(); 
                        Messaging.sendEmail(msgList);
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
                        Messaging.sendEmail(msgListToSend); 
                        //Delete acc;
                    }
                    
                }
                
            }
            
            if(!EReqToUpdate.isEmpty()) {
                update EReqToUpdate;
            }
        } catch(Exception ex) {
            System.debug('Exception :'+ex.getStackTraceString());
        } 
        
    }
    
    //The logic inside this method is executed only during Data Load/Data Migration
    public static void submitForApproval(Map<Id, Event_Relation__c> evntRelMap)
    {
        //Create a map of eligible Event relation records with curresponding requester Ids(Event_Request__c.Requester__c)
        Map<Id, Id> erIdReqIdMap = new Map<Id,Id>();
        for(Event_Relation__c er : [select id, Speaker_Request__c, Time_Slot_Start__c, Speaker_Request__r.Requester__c from Event_Relation__c where id IN :evntRelMap.keySet() LIMIT 50000])
        {
            if(er.Speaker_Request__c != null && er.Speaker_Request__r.Requester__c != null && er.Time_Slot_Start__c > System.now()) 
                erIdReqIdMap.put(er.Id, er.Speaker_Request__r.Requester__c);
        }
        
        //Entry criteria for Submit for Approval - Submit for approval only if Requestor's Business is Retail/Institutional and  Requestor has Speaker Approval role
        Set<Id> eligibleUsers = new Set<Id>();
        for(User requester : [select id,Business__c,Speaker_Request_Approval__c from User where id IN :erIdReqIdMap.values() LIMIT 50000])
        {
            if(requester.Business__c != NULL && requester.Speaker_Request_Approval__c != NULL){
                eligibleUsers.add(requester.id);
            }
        }
        //Check if any of the requesters are eligible to kick off the approval process
        if(eligibleUsers.size() > 0)
        {
            List<Approval.ProcessSubmitRequest> appReqList=new List<Approval.ProcessSubmitRequest>();
            for(Id erId : erIdReqIdMap.keySet())
            {
                //check if the requester is eligible to submit the Event relation record for approval
                if(eligibleUsers.contains(erIdReqIdMap.get(erId)))
                {
                    Approval.ProcessSubmitRequest appReq=new Approval.ProcessSubmitRequest();
                    appReq.setObjectId(erId);
                    appReqList.add(appReq);
                }
            }
            if(!appReqList.isempty()){
                Approval.ProcessResult[] appResults=Approval.process(appReqList);
            } 
        }
    }
    
    public static List<EventRelation> insertStandardEventRelation(Map<Id, Event_Relation__c> evntRelMap){
    	Set<Id> activityDetailIdSet = new Set<Id>();
    	List<EventRelation> evRelList = new List<EventRelation>();
    	for(Event_Relation__c evRelCustom : evntRelMap.values()){
            if(!String.isempty(evRelCustom.Activity_Detail__c))
    		activityDetailIdSet.add(evRelCustom.Activity_Detail__c);
    	}
    	Map<Id, Event> eventMapWithADId = new Map<Id, Event>();
    	if(!activityDetailIdSet.isEmpty()){
	    	for(Event ev : [select id, Activity_Detail__c, ownerId from Event where Activity_Detail__c in : activityDetailIdSet LIMIT 50000 ]){
	    		if(!eventMapWithADId.containsKey(ev.Activity_Detail__c)){
	    			eventMapWithADId.put(ev.Activity_Detail__c, ev);
	    		}
	    	}
    	}
    	for(Event_Relation__c evRelCustom : evntRelMap.values()){
    		if(eventMapWithADId.containsKey(evRelCustom.Activity_Detail__c)){
    			Event ev = eventMapWithADId.get(evRelCustom.Activity_Detail__c);
    			id relId = (Id)evRelCustom.RelationId__c;
    			if(ev!=null && ev.ownerId != relId && relId != null && relId.getSobjectType().getDescribe().getName()=='User'){
    				EventRelation stdERel = new EventRelation(RelationId = relId, Status=Label.A360_INVITEE_STATUS_NEW, EventId = ev.Id, isParent = false, isInvitee = true);
    				evRelList.add(stdERel);
    			}else if(relId != null && relId.getSobjectType().getDescribe().getName()=='Contact'){
    				EventRelation stdERel = new EventRelation(RelationId = relId, Status=Label.A360_INVITEE_STATUS_NEW, EventId = ev.Id, isParent = true, isInvitee = true); 
    				evRelList.add(stdERel);
    			}
    		}
    	}
    	
    	return evRelList;
    }
}