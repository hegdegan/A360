/***************************************************************************************************
Apex Class Name    : MFS_ParentActivityLinkController
Version            : 1.0 
Created Date       : 03/27/2017
Function           : This is a Controller for MFS_ParentActivityLink Page
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            03/27/2017              Original Version
***************************************************************************************************/
public class MFS_ParentActivityLinkController {
    public String activityName { get; set; }
    Task tsk;
    public MFS_ParentActivityLinkController(ApexPages.StandardController controller){
        tsk = (Task)controller.getRecord();
        activityName = '';
        if(tsk.Parent_Activity_Detail_Id__c != null){
            Activity_Detail__c ad = [select name from Activity_Detail__c where id = :tsk.Parent_Activity_Detail_Id__c];
            activityName = ad.Name;
        }
    }
}