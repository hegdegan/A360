/**
Apex Class Name    : MFS_StrategyPlanHandler
Version            : 1.0 
Created Date       : 11 MAY 2016
Function           : Handler class that gets called by StrategyPlan Triggers 
when StrategyPlan are created,updated and deleted
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              21/04/2016              Original Version
**/
public with sharing class MFS_StrategyPlanHandler {
    //call Strategy Plan utilities class before insert
    public static void beforeInsertEventHandler(List<Strategy_Plan__c> newPlanList){
        
        if(newPlanList != null && newPlanList.size() > 0){
            
            MFS_StrategyPlanUtilities.populateGoalDetailsInStrategyPlan(newPlanList);
        }
        
    }
}