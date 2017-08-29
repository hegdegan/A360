/***************************************************************************************************
Apex Class Name    : MFS_ActivityDetailRedirectController
Version            : 1.0 
Created Date       : 14 Feb 2017
Function           : Controller to redirect activity to custom A360 page 
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde           02/14/2017              Original Version
***************************************************************************************************/
public class MFS_ActivityDetailRedirectController {
    Activity_Detail__c actDet;
    String urlText;
    public MFS_ActivityDetailRedirectController(ApexPages.StandardController controller)
    {
        urlText = '';
        try{
            actDet = (Activity_Detail__c)controller.getRecord();
            Event[] evnt = [select id, RecordType.DeveloperName, whatId from Event where Activity_Detail__c = :actDet.Id LIMIT 1];
            Task[] tsk = [select id, RecordType.DeveloperName, whatId from Task where Activity_Detail__c = :actDet.Id LIMIT 1];
            if(evnt.size() > 0){
                if(!String.isEmpty(evnt[0].RecordType.DeveloperName) && evnt[0].RecordType.DeveloperName.containsIgnoreCase('Institutional'))
                    urlText = '/apex/MFS_Activity360PageSF1?id='+actDet.id+'&nooverride=1&returnID='+evnt[0].whatId+'&event=true';
                else if(!String.isEmpty(evnt[0].RecordType.DeveloperName) && evnt[0].RecordType.DeveloperName.containsIgnoreCase('Retail'))
                    urlText = '/apex/MFS_Activity360RetailPageSF1?id='+actDet.id+'&nooverride=1&returnID='+evnt[0].whatId+'&event=true';
            }
            if(tsk.size() > 0){
                if(!String.isEmpty(tsk[0].RecordType.DeveloperName) && tsk[0].RecordType.DeveloperName.containsIgnoreCase('Institutional'))
                    urlText = '/apex/MFS_Activity360PageSF1?id='+actDet.id+'&nooverride=1&returnID='+tsk[0].whatId+'&task=true';
                else if(!String.isEmpty(tsk[0].RecordType.DeveloperName) && tsk[0].RecordType.DeveloperName.containsIgnoreCase('Retail'))
                    urlText = '/apex/MFS_Activity360RetailPageSF1?id='+actDet.id+'&nooverride=1&returnID='+tsk[0].whatId+'&task=true';
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error while displaying the page. Please contact System administrator.'));
        }
    }
    public Pagereference redirect()
    {
        if(String.isEmpty(urlText))
            return new pageReference('/'+actDet.Id+'?nooverride=1');
        return new pagereference(urlText);
    }
}