/*
Apex class           :  MFS_ProductActivityUtility
Version               :  1.0
Created Date          :  16 SEP 2016
Function              :  This Utility class contains all methods related to MFS Portfolios Related List in Activity360
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* Maheshkumar            16 SEP 2016              Initial Version
* GYANENDRA SINGH        27 SEP 2016              Added goToProduct()
*/
public class MFS_ProductActivityUtility {
    /*
** Method Name     : goToProduct
** Description     : Method to get all the related products. 
** Used in         : MFS Portfolio related section (Activity360 page)
*/
    public static List<MFS_Activity360GeneralUtility.wrapperClass> goToProduct(Activity_Detail__c callNote){
        Set<ID> setProdID = new Set<ID>();
        List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        try{
            for(Call_Note_Product__c cProdJN:  [select Product__c from Call_Note_Product__c where Call_Note__c = : callNote.Id]){
                setProdID.add(cProdJN.Product__c);
            }
            if(!setProdID.isEmpty())
            {
                for(Product2 cp: [select (select id,High_Interest__c, Added_From_Invitees__c from Call_Note_Relationships__r where Call_Note__c = : callNote.Id LIMIT 1), Name, IsActive, ProductCode, Family, Vehicle__c, Is_High_Interest_Product__c, Portfolio_Code__c, portfolio_Start_Date__c from Product2 where id in: setProdID])
                {
                    MFS_Activity360GeneralUtility.wrapperClass tempWC = new MFS_Activity360GeneralUtility.wrapperClass();
                    tempWC.wProduct = cp;
                    tempWC.wActivityProdJuncObj = cp.Call_Note_Relationships__r[0];
                    ProductWrapperList.add(tempWC);
                }
            }
        }catch(Exception ex){
            system.debug('Exception in goToProduct : '+ex.getStackTraceString());
            throw ex;
        }
        return ProductWrapperList;
    }
    
    
    /*
** Method Name     : addingProduct
** Description     :  Method to link the Products to Activity. 
** Used in         : search box in MFS Portfolio related section (Activity360 page)
*/ 
    public static void addingProduct(List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperList, Set<Id> selectedProductIds, Activity_Detail__c callNote)
    {
        try{
            for (MFS_Activity360GeneralUtility.wrapperClass wExisting:ProductWrapperList)
            {
                //remove duplicate products from the set
                if(selectedProductIds.contains(wExisting.wProduct.id))
                    selectedProductIds.remove(wExisting.wProduct.id);
            }
            List<Product2> prodList = new List<Product2> ([select id,Name,IsActive,ProductCode,Family,Vehicle__c,Is_High_Interest_Product__c,Portfolio_Code__c, portfolio_Start_Date__c from Product2 where id In : selectedProductIds]);
            List<Call_Note_Product__c> ProdListToInsert = new List<Call_Note_Product__c>();
            for(Product2 prd : prodList)
            {
                Call_Note_Product__c cnp = new Call_Note_Product__c(Added_from_Invitees__c = false,Call_Note__c = callNote.Id, Product__c = prd.Id);
                ProdListToInsert.add(cnp);
            }
            insert ProdListToInsert;
            //Update the product wrapper after inserting the products inti o database
            for(Integer i= 0; i< ProdListToInsert.size(); i++)
            {
                MFS_Activity360GeneralUtility.wrapperClass tempWC = new MFS_Activity360GeneralUtility.wrapperClass();
                tempWC.wProduct = prodList[i];
                tempWC.wActivityProdJuncObj = ProdListToInsert[i];
                ProductWrapperList.add(tempWC);
            }
        }catch(Exception ex){
            system.debug('Exception in addingProduct : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    /*
** Method Name     : addingProductFromInvitees
** Description     :  Method to link the Products to Activity which are added to invitee section. 
** Used in         : Invitee section - Add portfolio button (Activity360 page)
*/ 
    public static void addingProductFromInvitees(List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperList, Set<Id> prodIds, Activity_Detail__c callNote)
    {
        try{
            //Remove product ids which are already added to product related list
            for (MFS_Activity360GeneralUtility.wrapperClass wExisting:ProductWrapperList)
            {
                if(prodIds.contains(wExisting.wProduct.id))
                    prodIds.remove(wExisting.wProduct.id);
            }
            List<Product2> prodList = new List<Product2> ([select id,Name,IsActive,ProductCode,Family,Vehicle__c,Is_High_Interest_Product__c,Portfolio_Code__c, portfolio_Start_Date__c from Product2 where id In : prodIds]);
            List<Call_Note_Product__c> ProdListToInsert = new List<Call_Note_Product__c>();
            for(Product2 prd : prodList)
            {
                Call_Note_Product__c cnp = new Call_Note_Product__c(Added_from_Invitees__c = true, Call_Note__c = callNote.Id, Product__c = prd.Id);
                ProdListToInsert.add(cnp);
            }
            insert ProdListToInsert;
            for(Integer i= 0; i< ProdListToInsert.size(); i++)
            {
                MFS_Activity360GeneralUtility.wrapperClass tempWC = new MFS_Activity360GeneralUtility.wrapperClass();
                tempWC.wProduct = prodList[i];
                tempWC.wActivityProdJuncObj = ProdListToInsert[i];
                ProductWrapperList.add(tempWC);
            }
            
        }catch(Exception ex){
            system.debug('Exception in addingProductFromInvitees : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    /*
** Method Name     : highInterestProductCheck
** Description     :  Method to mark the MFS Product as 'High Interest' Product  and create Followup Tasks.
** Used in         : 'High Interest' checkbox in MFS Portfolio related section (Activity360 page)
*/     
    public static void highInterestProductCheck(Boolean taskCallNote, Event parentEvent, Task parentTask,RecordType oRecTypeActivity, List<MFS_Activity360GeneralUtility.wrapperClass> taskWrapperList, string individualChildRecordId, List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperList ){
        Boolean highInterestChecked = false;
        if(individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                //Iterate through the list to find selected product id. break the loop when id is found
                Call_Note_Product__c prodJn;
                for (MFS_Activity360GeneralUtility.wrapperClass wc:ProductWrapperList){
                    if(wc.wActivityProdJuncObj.Id == individualChildRecordId){ 
                        prodJn = wc.wActivityProdJuncObj; 
                        highInterestChecked = (wc.wActivityProdJuncObj.High_Interest__c) ? true : false;
                        break;
                    }
                }
            if(prodJn != null)
            	upsert prodJn;
            }
            ID contId = (taskCallNote) ? parentTask.WhoId : parentEvent.WhoId;
            //create automatic follow up task
            if(highInterestChecked && oRecTypeActivity.Name.containsIgnoreCase(MFS_AllConstants.RETAIL_RECORDTYPE_SUBTEXT) && !String.isEmpty(contId)){ 
                MFS_Activity360GeneralUtility.automaticFollowUpTaskCreate('Prod', taskCallNote, parentEvent, parentTask,taskWrapperList, contId,7,MFS_AllConstants.TASK_PRIORITY_DEFAULT_HIGH); 
            }
        
        
    } 
    
    /*
** Method Name     : removingProduct
** Description     :  Method to delink the products from Activity.
** Used in         : 'remove' icon in MFS Portfolio related section (Activity360 page)
*/
    public static void removingProduct(string individualChildRecordId, List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperList, Call_Note_Product__c oProductJN, Activity_Detail__c callNote )
    {
        try{
            if(!ProductWrapperList.isEmpty())
            {
                List<MFS_Activity360GeneralUtility.wrapperClass> lstNotToRemove = new List<MFS_Activity360GeneralUtility.wrapperClass>();
                List<Call_Note_Product__c> junObjects;
                if(individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                    for(MFS_Activity360GeneralUtility.wrapperClass wc:ProductWrapperList)
                    {
                        //create a list of products which are not getting removed
                        if(wc.wProduct.id != individualChildRecordId){ lstNotToRemove.add(wc); }   
                    }
                    junObjects = new List<Call_Note_Product__c>([select id from Call_Note_Product__c where Call_Note__c =:callNote.id AND Product__r.Id =:individualChildRecordId]);
                    delete junObjects;
                }
                ProductWrapperList.clear();
                //recreate the product list
                ProductWrapperList.addAll(lstNotToRemove);
            }
        }catch(Exception ex){
            system.debug('Exception in removingProduct : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    /*
** Method Name     : removingProductFromInvitee
** Description     :  Method to delink the products from Activity.
** Used in         : 'remove' icon in Invitee section(Activity360 page)
*/
    public static void removingProductFromInvitee(List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperList, Set<Id> removedInviteePf, Id cNoteId)
    {
        try{
            List<MFS_Activity360GeneralUtility.wrapperClass> lstNotToRemove = new List<MFS_Activity360GeneralUtility.wrapperClass>();
            for(MFS_Activity360GeneralUtility.wrapperClass wc:ProductWrapperList){
                if(!removedInviteePf.contains(wc.wProduct.id) || wc.wActivityProdJuncObj.Added_From_Invitees__c == false){ 
                    lstNotToRemove.add(wc); 
                }   
            }
            delete [select id from Call_Note_product__c where Product__c in :removedInviteePf and Added_From_Invitees__c = true and Call_Note__c = :cNoteId];
            ProductWrapperList.clear();
            //recreate the list after deleting the products
            ProductWrapperList.addAll(lstNotToRemove);
        }catch(Exception ex){
            system.debug('Exception in removingProductFromInvitee : '+ex.getStackTraceString());
            throw ex;
        }
    }
}