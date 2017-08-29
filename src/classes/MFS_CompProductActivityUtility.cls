/*
Apex class           :  MFS_CompProductActivityUtility
Version               :  1.0
Created Date          :  16 SEP 2016
Function              :  This Utility class contains all methods related to MFS Competitor Portfolios Related List in Activity360
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* Maheshkumar            16 SEP 2016              Initial Version
*/
public with sharing class MFS_CompProductActivityUtility {
    
    /*
    ** Method Name     : addingCompetitorProduct
    ** Description     :  Method to link the Products to Activity. 
    ** Used in         : search box in MFS Competitor Portfolio related section (Activity360 page)
    */
    public static void addingCompetitorProduct (Set<Id> selectedProductIds, List<MFS_Activity360GeneralUtility.wrapperClass> competitorProdWrapperList, Activity_Detail__c callNote)
    {
        try{
        for (MFS_Activity360GeneralUtility.wrapperClass wExisting:competitorProdWrapperList)
        {   
            if(selectedProductIds!=null && selectedProductIds.contains(wExisting.wCompProduct.id))
                selectedProductIds.remove(wExisting.wCompProduct.id);
        }
        List<Competitor_Product__c> prodList = new List<Competitor_Product__c> ([select id,Name,Firm__c,Firm_Name__c,Is_High_Interest_Product__c from Competitor_Product__c where id In : selectedProductIds]); // Firm__r.Name is replaced with Firm_Name__c on 08/Feb/2017 for UAT Defect
        List<Call_Note_Competitor_Product__c> ProdListToInsert = new List<Call_Note_Competitor_Product__c>();
        for(Competitor_Product__c prd : prodList)
        {
            Call_Note_Competitor_Product__c cnp = new Call_Note_Competitor_Product__c(Call_Note__c = callNote.Id, Competitor_Product__c = prd.Id);
            ProdListToInsert.add(cnp);
        }
        insert ProdListToInsert;
        for(Integer i= 0; i< ProdListToInsert.size(); i++)
        {
            competitorProdWrapperList.add(new MFS_Activity360GeneralUtility.wrapperClass(prodList[i],false));
        }
        }catch(Exception ex){
            system.debug('Exception in addingCompetitorProduct : '+ex.getStackTraceString());
            throw ex;
        }
    }

    /*
    ** Method Name     : removingCompetitorProduct
    ** Description     :  Method to delink the products from Activity.
    ** Used in         : 'remove'hyperlink in MFS Competitor Portfolio related section (Activity360 page)
    */
    public static void removingCompetitorProduct(string individualChildRecordId, Call_Note_Competitor_Product__c oCompProductJN, List<MFS_Activity360GeneralUtility.wrapperClass> competitorProdWrapperList, Activity_Detail__c callNote)
    {
        try{
        if(competitorProdWrapperList != null)
        {
            List<MFS_Activity360GeneralUtility.wrapperClass> lstNotToRemove = new List<MFS_Activity360GeneralUtility.wrapperClass>();
            List<Call_Note_Competitor_Product__c> junObjects;
            if(individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                for(MFS_Activity360GeneralUtility.wrapperClass wc:competitorProdWrapperList)
                {
                    if(wc.wCompProduct.id != individualChildRecordId){ lstNotToRemove.add(wc); }   
                }
                junObjects =  new List<Call_Note_Competitor_Product__c>([select id from Call_Note_Competitor_Product__c where Call_Note__c =:callNote.id AND Competitor_Product__r.Id =:individualChildRecordId]);
                delete junObjects;
            }
            competitorProdWrapperList.clear();
            competitorProdWrapperList.addAll(lstNotToRemove);
        } 
        oCompProductJN = new Call_Note_Competitor_Product__c();
        individualChildRecordId = null;
        }  catch(Exception ex){
            system.debug('Exception in removingCompetitorProduct : '+ex.getStackTraceString());
            throw ex;
        }
    }
}