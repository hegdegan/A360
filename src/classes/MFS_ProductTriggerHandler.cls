/***************************************************************************************************
Apex Class Name    : MFS_ProductTriggerHandler 
Version            : 1.0 
Created Date       : 25 MAY 2016
Function           : Handler Class for Product Trigger
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               25/05/2016              Original Version
***************************************************************************************************/

public class MFS_ProductTriggerHandler {
    
/**
 * @Description : Method is used to call utility class method with product Ids
 * @Param :Product Ids 
 * @return: Nothing
**/    
public static void createPBEntry(List<Product2> productIdList)
{
    if(!productIdList.isEmpty())
    {        
        Set<Id> productIds=new Set<Id>();
        	for(Product2 prodRec:productIdList)
            {                
                if(!prodRec.isClone())
                	productIds.add(prodRec.Id);
            }
    	MFS_ProductTriggerUtil.createStdPBEntry(productIds);
    }
}
    
 
    
}