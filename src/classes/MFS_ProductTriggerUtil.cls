/***************************************************************************************************
Apex Class Name    : MFS_ProductTriggerUtil 
Version            : 1.0 
Created Date       : 25 MAY 2016
Function           : Class is used to create standard price book entry for each product on insertion & update Active/Inactive PricebookEntry based on product status
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               25/05/2016              Original Version
***************************************************************************************************/

public class MFS_ProductTriggerUtil {    

/**
* @Description : Method is used to create Price book entry in standard price book
* @Param :Product Ids 
* @return: Nothing
**/
    public static void createStdPBEntry(Set<id> productIds)
    {
        try{
            PriceBook2 stdPB=[Select id from PriceBook2 where isStandard=true limit 1];
            Map<Id,Product2> productMap=new Map<Id,Product2>([Select id,IsActive from Product2 where id in :productIds]);
            List <PricebookEntry> pbEntries=new List <PricebookEntry> ();
            List<CurrencyType> curency = new List<CurrencyType>([select ISOCode from CurrencyType where isActive=true]);
            for(Id prdId:productIds)
            {
                for(CurrencyType curr : curency)
                {
                    PricebookEntry pbEntry=new PricebookEntry();
                    pbEntry.Product2Id=prdId;
                    pbEntry.Pricebook2Id=stdPB.id;
                    pbEntry.UnitPrice=0;
                    pbEntry.IsActive=(productMap.get(prdId)).IsActive;
                    pbEntry.CurrencyISOCode = curr.ISOCode;               
                    pbEntries.add(pbEntry);
                }
            } 
        
        
       if(!pbEntries.isEmpty())
            {
                DataBase.insert(pbEntries,false);
            }
        }

        catch(Exception exe)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
            System.debug('Exception Occured:'+exe.getMessage());
        }
    }
 

}