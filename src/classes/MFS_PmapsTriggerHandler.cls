/**
Apex Class Name    : MFS_PmapsTriggerHandler
Version            : 1.0 
Created Date       : 29 Jul 2016
Function           : Trigger Handler  class for Pmaps 
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey              7/29/2016              Original Version
**/
public class MFS_PmapsTriggerHandler {
    //call Utility class to insert Opportunity Product related list in PMAPS page
    public static void afterInsertAddRLPmaps(List<PMAPS__c> pmapsList){
        if(!pmapsList.isEmpty()){
            List<Opportunity_Product__c> oppProdToInsert = MFS_PmapsTriggerUtilities.AddOppProductRL(pmapsList);
            Database.SaveResult[] updOppProd = Database.insert(oppProdToInsert,false);
        } 
    }

}