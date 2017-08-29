public class MFS_PmapsTriggerUtilities {
    //Add OpportunityLineItem records in Opportunity Product related list on Pmaps detail page
    public static List<Opportunity_Product__c> AddOppProductRL(List<PMAPS__c> newpmapsList){
        Set<Id> oppId = new set<Id>();
        List<OpportunityLineItem> oppItem = new List<OpportunityLineItem>();
        List<Opportunity_Product__c> oProd = new List<Opportunity_Product__c>();
        
        try{
            for(PMAPS__c pmap : newpmapsList){
            oppId.add(pmap.Opportunity__c);
        }
        if(oppId.size()>0){
          oppItem = [select Product2Id,OpportunityId,Asset_Class_Geography__c,Product_Vehicle__c,Restricted__c,Active__c,Product_Name__c from OpportunityLineItem
                     where OpportunityId in : oppId];
        for(PMAPS__c pmap : newpmapsList){
            for(OpportunityLineItem oprod1 : oppItem){
                if(oprod1.OpportunityId == pmap.Opportunity__c){
                    Opportunity_Product__c opp = new Opportunity_Product__c();
                    opp.Name = oprod1.Product_Name__c.length()>79?oprod1.Product_Name__c.substring(0,78):oprod1.Product_Name__c;
                    opp.Product2__c = oprod1.Product2Id;
                    opp.Opportunity__c = oprod1.OpportunityId;
                    opp.Asset_Class_Geography__c = oprod1.Asset_Class_Geography__c;
                    //oprod1.Product_Vehicle__c;
                    opp.Restricted__c = oprod1.Restricted__c;
                    opp.Active__c = oprod1.Active__c;
                    opp.RFP__c = pmap.Id;
                    opp.Product_Vehicle__c = oprod1.Product_Vehicle__c;
                    if(opp.Active__c == true){
                    oProd.add(opp); 
                    }
                }
            }
        }  
        }
        
        }catch(Exception ex){
             System.debug('Execption occured:'+ex.getMessage());
        }
        
            return oProd;
        
      }
    
}