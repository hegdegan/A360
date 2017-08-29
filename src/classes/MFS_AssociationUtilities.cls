/**
Apex Class Name    : MFS_AssociationUtilities
Version            : 1.0 
Created Date       : Dec. 13 2016
Function           : Utility class that gets called by Plan Association Triggers 
when Associations are created and updated
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Christine Cui             12/13/2016              Original Version
**/

public class MFS_AssociationUtilities {
 
    // Clone the association if the Plan has 3 investments, 2 association records will be created to associate the plan with 2 investments 
    public static List<Plan_Association__c> CloneAssociation(List<Plan_Association__c> newAssocList, Set<Id> AssocId){
        
        // Get the list from trigger parameter
        List<Plan_Association__c> associationsList = new List<Plan_Association__c>([Select 
                                                                                    Active__c,Contact_Relationship_End_Date__c,Contact_Relationship_Start_Date__c,Contact__c,CreatedById,CreatedDate,Contact_Role__c, All_Plans__c,
                                                                                    CRT__c,Distribution_List__c,Historical_Org_Name__c,Investment__c,LastModifiedById,LastModifiedDate,Name,Organization1__c,Organization__c,OwnerId,Plan__c,Role__c FROM Plan_Association__c where Id = :AssocId]);
        List<Plan_Association__c> newassociationsList = new List<Plan_Association__c>();                                                                            
        Set<Id> PlanId = new Set<Id>();
        Set<Id> InvestId = new Set<Id>();   
        List<Account__c> accList = new List<Account__C>();
        
        // Get PlanID and InvestmentID from the list
        try{ 
            if(!newAssocList.isEmpty() && AssocId.size()>0){
                for(Plan_Association__c pac: associationsList) {
                    PlanId.add(pac.Plan__c);
                    InvestId.add(pac.Investment__c);
                }
                
                //Make sure to only get PlanId and Investment not equal to the investment of the original association ID
                If(!associationsList.isEmpty()) {
                    accList=[Select Id, name from Account__c where Plan__c in : PlanId and Id <> :InvestId]; 
 
                    for (Plan_Association__c passo: associationsList){
                        for (Account__c ac: accList){
                            Plan_Association__c pa = passo.clone(false, true);
                            pa.Investment__c = ac.id;
                            newassociationsList.add (pa);
                        }
                    }
                }
            }
        } catch(Exception ex){
            System.debug('Exception occurred '+ex.getMessage());
        }
        return newassociationsList;
    }
    
    // When the association is created, immediately associate the 1st investment id of this plan, in this case, we need to update the the 1st investmentID
    public static List<Plan_Association__c> updateInvestmentId(Map<Id,Plan_Association__c> newAssocList){   
        List<Plan_Association__c> lstAssoUpdate = new List<Plan_Association__c>();
        Set<Id> PlanId = new set<Id>();
        
        List<Plan_Association__c> associationsList = new List<Plan_Association__c>([Select 
                                                                                    Active__c,Contact_Relationship_End_Date__c,Contact_Relationship_Start_Date__c,Contact__c,CreatedById,CreatedDate,
                                                                                    CRT__c,Distribution_List__c,Historical_Org_Name__c,Investment__c,LastModifiedById,LastModifiedDate,Name,
                                                                                    Organization1__c,Organization__c,OwnerId,Plan__c,Role__c FROM Plan_Association__c where Id IN :newAssocList.keyset()]);
        for(Plan_Association__c pa: associationsList){
            //make sure plan is filled in and investment is left blank
            if (pa.Investment__c ==null && pa.plan__c !=null){ 
                PlanId.add(pa.Plan__c);
            }
        }
         //update the 1st investment id of this plan to the association record we just created
        List<Account__c> acList = new List<Account__c>([Select Id from Account__c where Plan__c =: PlanId Order By Id LIMIT 1]);
        for(Account__c a: acList){
            for(Plan_Association__c pa: associationsList) {
                pa.Investment__c = a.Id;
                lstAssoUpdate.add(pa);   
            }
        }
        //return the list to update
        return lstAssoUpdate;
    }
}