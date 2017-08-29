/**
Apex Class Name    : MFS_AssociationHandler
Version            : 1.0 
Created Date       : Dec. 13, 2016
Function           : Handler class that gets called by Plan Association Triggers 
when the Association record is created.  When the Plan record is not blank 
and Investment record is blank, the coe will auto create the association record 
to associate the investments with this plan.  For an example, if this plan 
has 3 investments, 3 association Id will be created.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Christine Cui			   12/13/2016			   Original Version
**/

public class MFS_AssociationHandler {
    public static void afterInsertUpdateAssociationHandler(List<Plan_Association__c> assocList, Map<id,Plan_Association__c> mapNewAssoc){
        
        List<Plan_Association__c> planA = new list<Plan_Association__c>();
        for(Plan_Association__c pac: assocList){
            if (pac.Plan__c != null && pac.Investment__c == null){
                planA.add(pac);
            }
        }
        map<id,Plan_Association__c> paMap = new map<Id,Plan_Association__c>(planA);
        if (planA.size() >0){
            // When the initial plan association is created, the first invest will be updated for that plan in this association record
            List<Plan_Association__c> PlanAssocUpdate = MFS_AssociationUtilities.updateInvestmentId(paMap);
            Database.SaveResult[] updPlanAssoc = Database.Update(PlanAssocUpdate, false);    
            
            // If the plan has 3 investments, the 2 other association records will be created.
            List<Plan_Association__c> PlanAssocInsert = MFS_AssociationUtilities.CloneAssociation(planA,paMap.keyset());
            Database.SaveResult[] insPlanAssoc = Database.Insert(PlanAssocInsert, false);             
        }
    }
}