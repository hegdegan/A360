/***************************************************************************************************
Apex Class Name    : MFS_OpportunityProductHandler 
Version            : 1.0 
Created Date       : 15 JUNE 2016
Function           : This is a handler class for MFS_OpportunityproductTrigger Trigger
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               15/06/2016              Original Version
***************************************************************************************************/
public class MFS_OpportunityProductHandler {
    
    //After insert handler
    public static void afterInsertTriggerhandler(List<OpportunityLineItem> newLst){
        List<Opportunity> oppListToUpdate=new List<Opportunity>();
        Set<Id> OpptyIds=new  Set<Id>();
        for(OpportunityLineItem oppLIRec : newLst){
            OpptyIds.add(oppLIRec.OpportunityId);
        }
       
        for(Opportunity oppty :[Select id, Rollup_Strategy__c from Opportunity where id =:OpptyIds] ){
            //oppty.Rollup_Strategy__c= '';
            for(OpportunityLineItem oppLI : newLst){
                if(oppLi.OpportunityId == Oppty.id) {
                    if(String.isEmpty(oppty.Rollup_Strategy__c)) {
                        oppty.Rollup_Strategy__c = oppLI.Product_Name__c;
                    } else {
                        oppty.Rollup_Strategy__c = oppty.Rollup_Strategy__c +'; '+ oppLI.Product_Name__c;
                    } 
                }
            }
            oppListToUpdate.add(oppty);        
        }
        DataBase.update(oppListToUpdate,false);
    }
    
    //After update handler
    public static void afterUpdateTriggerhandler(Map<id,OpportunityLineItem> oldMap, Map<id,OpportunityLineItem> newMap){
        system.debug('contact role is added ====================');
        List<Opportunity> oppListToUpdate=new List<Opportunity>();
        Set<Id> OpptyIds=new  Set<Id>();
        for(Id lineItemId : newMap.keyset()){
            OpptyIds.add(newMap.get(lineItemId).opportunityId);
            
        }
        for(Opportunity oppty :[Select id, Rollup_Strategy__c,(select id, Product_Name__c, Product2.Name from OpportunityLineItems) from Opportunity where id =:OpptyIds] ){
            oppty.Rollup_Strategy__c= '';
            for(OpportunityLineItem oppLI : oppty.OpportunityLineItems){
                if(String.isEmpty(oppty.Rollup_Strategy__c)) {
                    oppty.Rollup_Strategy__c = oppLI.Product2.Name;
                } else {
                    oppty.Rollup_Strategy__c = oppty.Rollup_Strategy__c +'; '+ oppLI.Product2.Name;
                }
            }
            oppListToUpdate.add(oppty);  
        }
        DataBase.update(oppListToUpdate);              
    }
    
    //Update rollup strategy after delete    
    public static void afterDeleteTriggerhandler(Map<id,OpportunityLineItem> oldMap){
        List<Opportunity> oppListToUpdate=new List<Opportunity>();
        Set<Id> OpptyIds=new  Set<Id>();
        for(Id lineItemId : oldMap.keyset()){
            OpptyIds.add(oldMap.get(lineItemId).opportunityId);
            
        }
        for(Opportunity oppty :[Select id, Rollup_Strategy__c,(select id, Product_Name__c, Product2.Name from OpportunityLineItems) from Opportunity where id =:OpptyIds] ){
            oppty.Rollup_Strategy__c= '';
            for(OpportunityLineItem oppLI : oppty.OpportunityLineItems){
                if(String.isEmpty(oppty.Rollup_Strategy__c)) {
                    oppty.Rollup_Strategy__c = oppLI.Product2.Name;
                } else {
                    oppty.Rollup_Strategy__c = oppty.Rollup_Strategy__c +'; '+ oppLI.Product2.Name;  
                } 
            }
            oppListToUpdate.add(oppty);  
        }
        DataBase.update(oppListToUpdate);              
    }
    
}