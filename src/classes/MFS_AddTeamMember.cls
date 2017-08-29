/***************************************************************************************************
Apex Class Name    : MFS_AddTeamMember 
Version            : 1.0 
Created Date       : 10 August 2016
Function           : Class is used to prepopulate fields on creation of new team member from Contact related list button.
Modification Log   :
***************************************************************************************************/

public with sharing class MFS_AddTeamMember {
    
    //Standard Controller
    public MFS_AddTeamMember(ApexPages.StandardSetController stdCtrl){
    }
    
    /**
    * @Description : Method is used to construct URL for redirection
    * @Param : N/A
    * @return: PageReference
    **/     
    public PageReference redirect(){
        Schema.DescribeSObjectResult r = Team_Member__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();            
        PageReference pageRef=new PageReference('/'+keyPrefix+'/e');
        try {
            Id recId = ApexPages.currentPage().getParameters().get('id');
                String objName = recId.getSObjectType().getDescribe().getName();
            List<String> listOfFields=new List<String>{'Contact__c','Team__c'};
                Map<String,String> fieldMap=MFS_Utilities.getFieldId('Team_Member__c',listOfFields);   
            if(objName == 'Contact'){
                Contact contactRec=[Select id,Name from Contact where id=:ApexPages.currentPage().getParameters().get('id')];
                pageRef.getParameters().put(MFS_AllConstants.RETURN_URL,contactRec.Id);          
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(0)),contactRec.Name);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(0))+MFS_AllConstants.LK_ID,contactRec.Id);
            }
            else{
                Team__c team = [select id, Name from Team__c where id =:ApexPages.currentPage().getParameters().get('id')];
                pageRef.getParameters().put(MFS_AllConstants.RETURN_URL,team.Id);          
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(1)),team.Name);
                pageRef.getParameters().put(fieldMap.get(listOfFields.get(1))+MFS_AllConstants.LK_ID,team.Id);
            }
        } catch(Exception exe) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
            system.debug('Exception');
        }
        return pageRef;
    } 
}