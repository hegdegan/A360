/**
Apex Class Name    : MFS_DistributionListUtilities
Version            : 1.0 
Created Date       : Dec. 19, 2016
Function           : Handler class that gets called by Distribution_List__c Triggers 
when Distribution_List__c is updated
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Christine Cui              12/19/2016              Original Version
**/

public class MFS_DistributionListUtilities {
//Method to update Plan Association's "Contact Relationship End Date" to today's date when distribution list changes from Active to Inactive.
    public static List<Plan_Association__c> updatePlanAssociations(List<Plan_Association__c> lstPlanAsscn){
        List<Plan_Association__c> planAsscnToUpdateList = new List<Plan_Association__c>();
        for(Plan_Association__c plnAsscn : lstPlanAsscn ){
            plnAsscn.Contact_Relationship_End_Date__c = system.TODAY();
            plnAsscn.CRT__c = false;
            planAsscnToUpdateList.add(plnAsscn);
        }
        return planAsscnToUpdateList; 
    }
}