/***************************************************************************************************
Apex Class Name    : MFS_AccountToBARRedirectController
Version            : 1.0 
Created Date       : 12 AUG 2016
Function           : This is a Controller for MFS_AccountToBARRedirectController Page.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            08/12/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_AccountToBARRedirectController {
    private static final String INSTITUTIONAL = 'Institutional';
    private static final String RETAIL = 'Retail';
    Account acc;
    public MFS_AccountToBARRedirectController(ApexPages.StandardController controller)
    {
        acc = (Account)controller.getRecord();
    }
    public PageReference redirect()
    {
        
        try{
            //get the name of organization record type
            String currentRecType = [select Name from RecordType where id = :acc.RecordTypeId].Name;
            if(currentRecType.Contains(INSTITUTIONAL))
            {
                return new PageReference('/apex/MFS_BusinessAtRisk?account='+acc.Id);
            }
            else if(currentRecType.Contains(RETAIL))
            {
                return new PageReference('/apex/MFS_BusinessAtRiskRetail?account='+acc.Id);
            }
            else
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.BAR_redirect_message));
            return null;
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.Generic_Error));
            return null; 
        }
    }
}