/***************************************************************************************************
Apex Class Name    : MFS_CustomButtonUtilities
Version            : 1.0 
Created Date       : 17 Oct 2016
Function           : This is a Controller for custom button to create a new team member from Contact
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* MAhesh Selvaraj            10/17/2016              Original Version
***************************************************************************************************/
global class MFS_CustomButtonUtilities{
    webService static String getNotifyUserEmails (String caseid) {
        String sEmails = '';
        for(Notify_User__c  nu:[select User_email__c from Notify_User__c where Termination_Case__c =: caseid]) {
            sEmails += nu.User_email__c  + ';' ;
        }
        return sEmails;	
    }
}