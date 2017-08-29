/***************************************************************************************************
Apex Class Name    : MFS_NewRatingChange 
Version            : 1.0 
Created Date       : 10 August 2016
Function           : Class is used to prepopulate fields on creation of new rating change from consultant rating related list button.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               10/08/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_NewRatingChange {
 
    //Constructor   
  public MFS_NewRatingChange(ApexPages.StandardSetController stdCtrl)
        {
            
        }

  
/**
* @Description : Method is used to construct URL for redirection
* @Param : N/A
* @return: PageReference
**/     
    public PageReference redirect()
        {
            Schema.DescribeSObjectResult r = Rating_Change__c.sObjectType.getDescribe();
			String keyPrefix = r.getKeyPrefix();
            PageReference pageRef=new PageReference('/'+keyPrefix+'/e');
            try{
            Consultant_Rating__c consultantRating=[Select id,Name from Consultant_Rating__c where id=:ApexPages.currentPage().getParameters().get('id')];                    
            List<String> listOfFields=new List<String>{'Name','Consultant_Rating__c'};
            Map<String,String> fieldMap=MFS_Utilities.getFieldId('Rating_Change__c',listOfFields);           
            pageRef.getParameters().put(MFS_AllConstants.RETURN_URL,consultantRating.Id);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(0)),consultantRating.Name);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(1))+MFS_AllConstants.LK_ID,consultantRating.Id);
            pageRef.getParameters().put(fieldMap.get(listOfFields.get(1)),consultantRating.Name);
            }   
            catch(Exception exe)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
            }
            System.debug('pageRef:'+pageRef);
            return pageRef;
        }
    


}