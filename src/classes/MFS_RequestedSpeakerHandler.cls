/***************************************************************************************************
Apex Class Name    : MFS_RequestedSpeakerHandler
Version            : 1.0 
Created Date       : 28 Sep 2016
Function           : Trigger handler for Requested Speaker
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey            09/28/2016              Original Version
***************************************************************************************************/
public class MFS_RequestedSpeakerHandler {
    //calling the Utility class method
    public static void afterUpdateRequestedSpeakerHandler(Map<Id,Event_Relation__c> newMapList, Map<Id,Event_Relation__c> oldMapList){
        if(!newMapList.isEmpty() && !oldMapList.isEmpty()){
            MFS_RequestedSpeakerUtilities.pendingOverallApprovalProcess(newMapList,oldMapList);
        }
    }
    
    //This wil be executed during data load(EnableDataLoad == Yes)
    public static void afterDataLoadInsert(Map<Id, Event_Relation__c> evntRelMap)
    {
    	List<EventRelation> evRelList = new List<EventRelation>();
        Boolean isDataLoadEnabled = MFS_Utilities.GetAppSettingValue('EnableDataLoad', 'Yes') == 'Yes' ? true : false;
        if(isDataLoadEnabled && MFS_AllConstants.IntegrationProfileId!= null && UserInfo.getProfileId().containsIgnoreCase(MFS_AllConstants.IntegrationProfileId.value__c)){
        	MFS_RequestedSpeakerUtilities.submitForApproval(evntRelMap);
        	evRelList = MFS_RequestedSpeakerUtilities.insertStandardEventRelation(evntRelMap);
        	if(evRelList.size() > 0){
        		 Database.SaveResult[] insEvRelList = Database.insert(evRelList,false);
        	}
        }
    }
}