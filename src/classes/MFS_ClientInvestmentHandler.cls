/**
Apex Class Name    : MFS_ClientInvestmentHandler
Version            : 1.0 
Created Date       : Feb. 17, 2017
Function           : Handler class that gets called by Client Investment Triggers 
Modification Log   :
-----------------------------------------------------------------------------
* Developer	Date		Description
* ----------------------------------------------------------------------------                 
* Alex Gomez	02/17/2017	Original Version
**/

public class MFS_ClientInvestmentHandler
{
    public static void afterInsertClientInvestmentHandler(List<Account__c> accountList, Map<id,Account__c> mapNewAccount)
    {
      // Get a list of all of the plan ID's in the new client investments
      List<id> planIds = new List<id>();
      for (Account__c a: accountList)
      {
          if (a.Plan__c != null)
          {
              planIds.add(a.Plan__c);
          }
      }

      // Now select the associations and put in a map keyed by plan
      Map<id, List<Plan_Association__c>> allAssociationsByPlanID = new Map<id, List<Plan_Association__c>>();
      for (Plan_Association__c pa : [select id, All_Plans__c, Investment__c, Contact__c, Contact_Role__c, CRT__c, 
                                                  		 Distribution_List__c, Historical_Org_Name__c, Organization1__c, Role__c, Plan__c 
                                                  from Plan_Association__c 
                                                  where Plan__c IN :planIds and All_Plans__c = true])
      {
          if (!allAssociationsByPlanID.containsKey(pa.Plan__c))
          {
              allAssociationsByPlanID.put(pa.Plan__c, new List<Plan_Association__C>());
          }
          
          allAssociationsByPlanID.get(pa.Plan__c).add(pa);
      }

	  // If there are no new plan associations then just return
	  if (allAssociationsByPlanID.isEmpty())
	  {
		return;
	  }
	  
      List<Plan_Association__c> newAssocs = new List<Plan_Association__c>();
      //Loop through all of the newly added client investments:
      for (Account__c a: accountList)
      {
          if (null == a.Plan__c)
          {
              continue;
          }
          
          List<Plan_Association__c> acctAssociations = allAssociationsByPlanID.get(a.Plan__c);
          for (Plan_Association__c assoc: acctAssociations)
          {
              Plan_Association__c planAssociation = new Plan_Association__c();
              planAssociation.Investment__c = a.Id;
              planAssociation.Plan__c = a.Plan__c;
              planAssociation.All_Plans__c = assoc.All_Plans__c;
              planAssociation.Contact__c = assoc.Contact__c;
              planAssociation.Contact_Role__c = assoc.Contact_Role__c;
              planAssociation.CRT__c = assoc.CRT__c;
              planAssociation.Distribution_List__c = assoc.Distribution_List__c;
              planAssociation.Historical_Org_Name__c = assoc.Historical_Org_Name__c;
              planAssociation.Organization1__c = assoc.Organization1__c;
              planAssociation.Role__c = assoc.Role__c;
              newAssocs.add(planAssociation);
          }
      }
      
      if (newAssocs.size() > 0)
      {
          database.saveResult[] sr = database.insert(newAssocs,false);
      }
  	}
    
	public static void afterDeleteClientInvestmentHandler(List<Account__c> accountListOld, Map<id,Account__c> accountListDelete)
    {
		//if a client investment gets deleted, delete all of the associations with that investment
        try{
		map<id,Account__c> oldAccountMap=accountListDelete;
		list<Plan_Association__c> associationsToDelete = [select id from Plan_Association__c where Investment__c in : oldAccountMap.keyset()];
		delete associationsToDelete; 
        }catch(Exception e){
            system.debug('Exception in afterDeleteClientInvestmentHandler : '+ e.getStackTraceString());
        }
    }
}