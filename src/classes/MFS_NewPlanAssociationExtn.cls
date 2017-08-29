/*
Apex class           :  MFS_NewPlanAssociationExtn
Version               :  1.0
Created Date          :  05 JAN 2017
Function              :  This class is used in Plan Association custom button
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* Ganesh Hegde            05 JAN 2017              Initial Version
*/
public class MFS_NewPlanAssociationExtn {
    public MFS_NewPlanAssociationExtn(ApexPages.StandardSetController stdCtrl)
    {}
    
    //Method to construct the url before redirecting to plan association record
    public PageReference redirect(){ 
        PageReference pageRef;
        try{
            Contact cont = [select id, name, account.id, account.name from Contact where id=:ApexPages.currentPage().getParameters().get('id')];
            List<String> listOfFields=new List<String>{'Contact__c','Organization__c'};
                Map<String,String> fieldMap=MFS_Utilities.getFieldId('Plan_Association__c',listOfFields);
            Schema.DescribeSObjectResult r = Plan_Association__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();			
            pageRef=new PageReference('/'+keyPrefix+'/e');
            pageRef.getParameters().put('retURL',cont.Id);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(0)),cont.Name);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(0))+'_lkid',cont.id);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(1)),cont.account.name);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(1))+'_lkid',cont.account.id);
         }catch(Exception e){
            system.debug('Exception in redirect: '+e.getMessage());
        }
        return pageRef;
    }
}