/***************************************************************************************************
Apex Class Name    : MFS_MyCampaignBatchSchedule 
Version            : 1.0 
Created Date       : 31 May 2016
Function           : Schedular to insert campaign members.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde              05/31/2016              Original Version
***************************************************************************************************/
global with sharing class MFS_MyCampaignBatchSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        MFS_MyCampaignBatch runBatch = new MFS_MyCampaignBatch();
        Database.executeBatch(runBatch, 1);
    }
}