/***************************************************************************************************
Apex Class Name    : MFS_LinkedIn
Version            : 1.0 
Created Date       :217 Jul 2016
Function           : This class is used to open the linked in profile for contact
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey            7/21/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_LinkedIn {
      Private Contact cntct;
    //Constructor
    public MFS_LinkedIn(ApexPages.StandardController controller){
        try{
            cntct = [Select Id,AccountId,FirstName,LastName from Contact where Id =: controller.getRecord().Id];
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
    }
    
    /**
* @Description : Method used to redirect user to apporipate page based on Account record
* @Param : N/A
* @return: Nothing
**/  
    public pagereference redirect(){
        Pagereference url;
        try{
            url = new pageReference('http://www.linkedin.com/vsearch/p?');
            url.getParameters().put('firstName',cntct.FirstName);
            url.getParameters().put('lastName',cntct.LastName);
            url.getParameters().put('company',cntct.AccountId);
            url.getParameters().put('openAdvancedForm','true');
        } 
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
        
        return url;
    }
    
}