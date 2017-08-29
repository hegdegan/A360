/**
Apex Class Name    : MFS_StrategyPlanUtilities
Version            : 1.0 
Created Date       : 11 MAY 2016
Function           : Utility class that gets called by Strategy Plan Triggers 
when Strategy plans are created,updated and deleted
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              21/04/2016              Original Version
**/
public class MFS_StrategyPlanUtilities {
    //Populate fields of Strategy plan from Goal object
    public static void populateGoalDetailsInStrategyPlan(List<Strategy_Plan__c> planList){
        try{
            Set<Id> goalIdSet = new Set <Id> ();
            Map <Id, Goal__c> goalMap ;
            for (Strategy_Plan__c plan : planList ){ 
                if(plan.Goal__c != null)
                    goalIdSet.add(plan.Goal__c);
            }
            
            if(goalIdSet.size() > 0){
                goalMap = new Map<Id,Goal__c> ([select Client_Engagement__c,Institutional_Portfolio_Manager__c,Consultant_Meetings__c,
                                                Client_Review_Meetings__c,Portfolio_Manager__c,Analyst_Meeting__c,Sr_Executive_Meeting__c,
                                                Sr_Investment_Speaker_Client_Events__c from Goal__c where Id in : goalIdSet]);
                
                if(goalMap != null && goalMap.size() > 0){
                    for(Strategy_Plan__c plan : planList){
                        if(goalMap.containsKey(plan.Goal__c)){
                            Goal__c goal = goalMap.get(plan.Goal__c);
                            plan.Client_Engagement_Goal__c = goal.Client_Engagement__c;
                            plan.Institutional__c = goal.Institutional_Portfolio_Manager__c;
                            plan.Consultant_Meeting_Goal__c = goal.Consultant_Meetings__c;
                            plan.Client_Review_Meeting_Goal__c = goal.Client_Review_Meetings__c;
                            plan.Portfolio_Manager_Meeting_Goal__c =  goal.Portfolio_Manager__c;
                            plan.Analyst_Meeting_Goal__c = goal.Analyst_Meeting__c;
                            plan.Sr_Executive_Meeting_Goal__c = goal.Sr_Executive_Meeting__c;
                            plan.Sr_Investment_Speaker_Goal__c = goal.Sr_Investment_Speaker_Client_Events__c;
                        }
                    }
                }
            }
        } catch(Exception exe) {
            System.debug('Execption occured:'+exe.getMessage());
        }
    }
}