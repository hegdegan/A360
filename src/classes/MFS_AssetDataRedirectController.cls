/***************************************************************************************************
Apex Class Name    : MFS_AssetDataRedirectController
Version            : 1.0 
Created Date       : 27 MAY 2016
Function           : This Controller redirects the page to respective Asset & Sales Table based on the profile and recordtype
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Maheshkumar            27/05/2016              Original Version
***************************************************************************************************/

public with sharing class MFS_AssetDataRedirectController {
    //Variable declaration
    private final Account acct;	
    
    
    //Constructor for Extension class
    public MFS_AssetDataRedirectController(ApexPages.StandardController stdController) {
        //get the recordtype of the Account record
        if(!test.isRunningTest()){
            stdController.addFields(new List<String> {'Id','Name','RecordTypeId'});
        }
        this.acct= (Account)stdController.getRecord();
    }  
    
    //This method redirects to corresponding Asset table based on profile and Recordtype.    
    public PageReference redirect(){
        try {
            RecordType currentRecType = [select Name from RecordType where id = :acct.RecordTypeId];
            if(currentRecType.Name.containsIgnoreCase(MFS_AllConstants.RECTYPE_Consultant)){
                return new PageReference( '/apex/' + MFS_AllConstants.ASSETPAGE_Consultant + '?Id=' + acct.id );
            }else if(currentRecType.Name.containsIgnoreCase(MFS_AllConstants.RECTYPE_InstClient)){
                return new PageReference( '/apex/' + MFS_AllConstants.ASSETPAGE_Institutional + '?Id=' + acct.id); 
            }else if(currentRecType.Name.containsIgnoreCase(MFS_AllConstants.RECTYPE_Retail)) {
                return new PageReference( '/apex/'+ MFS_AllConstants.ASSETPAGE_Retail + '?Id=' + acct.id); 
            }else if(currentRecType.Name == null || currentRecType.Name.equals('') || 
                     currentRecType.Name.containsIgnoreCase(MFS_AllConstants.REC_TYPE_UNKNOWN) || 
                     currentRecType.Name.containsIgnoreCase(MFS_AllConstants.RECTYPE_Service_Provider)){
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.SA_Incorrect_Rec_Type));
                         return null;
                     }
            return  null;            
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Generic_Error));
            return null; 
        }
    }
}