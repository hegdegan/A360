/***************************************************************************************************
Apex Class Name    : MFS_CreateNewTeamExt
Version            : 1.0 
Created Date       : 24 Nov 2016
Function           : This is a Controller for custom button to create a new team member from Contact
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Manoj Parida            11/24/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_CreateNewTeamExt {
    
 public MFS_CreateNewTeamExt(ApexPages.StandardsetController controller)
        {
           
        }
    //return Team url
    public PageReference redirect(){ 
        PageReference pageRef;
        try{
            Schema.DescribeSObjectResult r = Team__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            pageRef=new PageReference('/'+keyPrefix+'/e');
           }catch(Exception e){
            system.debug('Exception in redirect : '+e.getMessage());
		}
            return pageRef;
        }
    
}