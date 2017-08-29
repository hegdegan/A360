/***************************************************************************************************
Apex Class Name    : MFS_OnBoardingSendEmail 
Version            : 1.0 
Created Date       : 15 MAY 2016
Function           : Class is Used send Reminder Email to approver.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               03/05/2016              Original Version
***************************************************************************************************/

public with sharing class MFS_OnBoardingSendEmail {
    
    public Approval_Request__c appRequest;
    
    //Constructor     
    public MFS_OnBoardingSendEmail(ApexPages.StandardController stdCtrl){
        try {
            appRequest=[Select id,Approval_Status__c,Number_of_Follow_ups_Sent__c,Approver_Group__c,Due_Date__c,Onboarding_Case__r.Id,Owner.FirstName,Owner.LastName
                        from Approval_Request__c where id=:String.escapeSingleQuotes(stdCtrl.getRecord().Id) limit 1];            
        } catch(Exception exe) {
            System.debug('Exception occured:'+exe.getMessage()+exe.getLineNumber());
        }
    }
    
    /**
    * @Description : Method is used to send email to actual approver
    * @Param : N/A
    * @return: PageReference
    **/       
    public PageReference sendReminder(){
        
        PageReference pageRef;
        try {
            if(MFS_AllConstants.APPROVAL_STATUS_PENDING==appRequest.Approval_Status__c){
                ProcessInstanceWorkItem approvalHis=[Select OriginalActorId from ProcessInstanceWorkItem where ProcessInstance.TargetObjectId=:String.escapeSingleQuotes(appRequest.Id)];
                Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
                String[] toAddresses=new String[]{};
                    //Check if approver is a user
                    if(String.valueOf(approvalHis.OriginalActorId).startsWith('005')){
                        toAddresses.add(approvalHis.OriginalActorId);
                    } 
                //Check if approver is a queue
                else if(String.valueOf(approvalHis.OriginalActorId).startsWith('00G')){
                    GroupMember queueMem=[Select UserOrGroupId From GroupMember where GroupId =:approvalHis.OriginalActorId limit 1];
                    //Assuming Queue will always have one public group
                    for(GroupMember groupMem:[Select UserOrGroupId From GroupMember where GroupId =:String.escapeSingleQuotes(queueMem.UserOrGroupId)]){
                        toAddresses.add(groupMem.UserOrGroupId);
                    }                    
                }  
                email.setTargetObjectId(toAddresses[0]);
                email.setSubject(System.Label.OB_ReminderEmailSubject);
                email.setHTMLBody(createEmailBody());
                email.setToAddresses(toAddresses);
                email.setSaveAsActivity(false);
                List<Messaging.SendEmailResult> results= Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
                for(Messaging.SendEmailResult result:results){
                    if(result.isSuccess()){
                        appRequest.Number_of_Follow_ups_Sent__c= appRequest.Number_of_Follow_ups_Sent__c+1;
                    }
                }
                update  appRequest;                
                pageRef= new PageReference(MFS_AllConstants.SLASH + appRequest.ID);
            } else {
                appRequest.addError(System.Label.OB_ApprovalError);
            }
        } catch(Exception exe) {
            System.debug('Exception occured:'+exe.getMessage()+exe.getLineNumber());
            pageRef= new PageReference(MFS_AllConstants.SLASH + appRequest.ID);
        }
        return pageRef;
    }
    
    /**
    * @Description : Method is used to create email boday
    * @Param : N/A
    * @return: String
    **/        
    public String createEmailBody(){
        String detailURL=URL.getSalesforceBaseUrl().toExternalForm()+'/';
        String emailBoday=System.Label.OB_ReminderEmailBody1+' '+appRequest.Approver_Group__c+',<br>';
        emailBoday=emailBoday+System.Label.OB_ReminderEmailBody2+' '+'<a href='+detailURL+appRequest.ID+'>'+System.Label.OB_ReminderEmailBody3+'</a> .';
        emailBoday=emailBoday+System.Label.OB_ReminderEmailBody4+' '+'<a href='+detailURL+appRequest.Onboarding_Case__r.Id+'>'+System.Label.OB_ReminderEmailBody5+'</a>.'+'<br>';
        emailBoday=emailBoday+System.Label.OB_ReminderEmailBody6+appRequest.Due_Date__c+'<br>';
        emailBoday=emailBoday+System.Label.OB_ReminderEmailBody7+'<br><br>';
        emailBoday=emailBoday+System.Label.OB_ReminderEmailBody8+'<br>'+appRequest.Owner.FirstName+' '+appRequest.Owner.LastName;
        System.debug('emailBody:'+emailBoday);
        return emailBoday;
    }
}