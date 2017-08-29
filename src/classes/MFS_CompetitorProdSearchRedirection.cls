/***************************************************************************************************
Apex Class Name    : MFS_CompetitorProdSearchRedirection
Version            : 1.0 
Created Date       : 1 Nov 2016
Function           : This is a Controller to redirec user to select competitor products to Opportunity from opportunity page
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            11/01/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_CompetitorProdSearchRedirection{
Opportunity oppty;
    //Constructor
    public MFS_CompetitorProdSearchRedirection(ApexPages.StandardController controller)
    {
        oppty = (Opportunity)controller.getRecord();
    }
    //redirect to add competitor product page
    public PageReference redirect()
    {
        
        try{
            //get the name of organization record type
             return new PageReference('/apex/MFS_CompetitorSearchPage?addTo='+oppty.Id+'&saveURL=%2F'+oppty.Id+'&retURL=%2F'+oppty.Id);
            }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.Generic_Error));
            return null; 
        }
    }
}