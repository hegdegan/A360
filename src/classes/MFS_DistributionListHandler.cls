/**
Apex Class Name    : MFS_DistributionListHandler
Version            : 1.0 
Created Date       : Dec 19 2016
Function           : Handler class that gets called by Distribution_List__c Triggers 
when Distribution_List__c are updated
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Christine Cui			   12/19/2016			   Original Version
**/
public class MFS_DistributionListHandler {

    public static void afterUpdateDistListHandler(Map<Id, Distribution_List__c> newMap, Map<id, Distribution_List__c> oldMap)
    {
      List<Plan_Association__c> planAccsnList = new List<Plan_Association__c>(); 
      List<Distribution_List__c> distList = new List<Distribution_List__c>([Select Id, Name, Organization__c, Email_Address__c, Status__c,
                                                                           (Select Id, name, CRT__c, Contact_Relationship_End_Date__c from Distribution_List__c.Plan_Associations__r) from Distribution_List__c 
                                                                           where id in :newMap.keySet()]);
        for(Distribution_List__c dlc: distList)  {
            Distribution_List__c dlcNew = newMap.get(dlc.Id);
            Distribution_List__c dlcOld = oldMap.get(dlc.Id);
            
            if(dlcNew.Id == dlcOld.Id && dlcNew.Status__c != dlcOld.Status__c && dlcNew.Status__c == 'Inactive')
            {
              for(Plan_Association__c pac: dlc.Plan_Associations__r) 
              {
                 planAccsnList.add(pac); 
              }
            }
        } 
       List<Plan_Association__c> planAsscnToUpdateList = new List<Plan_Association__c>();
       if(planAccsnList.size() >0){
            planAsscnToUpdateList = MFS_DistributionListUtilities.updatePlanAssociations(planAccsnList);
        }
        Database.SaveResult[] updPlanAssc = Database.update(planAsscnToUpdateList,false);
        
    }
}