/***************************************************************************************************
Apex Class Name    : MFS_RecurringCaseBatchSchedule 
Version            : 1.0 
Created Date       : 18 October 2016
Function           : Schedule recurring case batch class to insert child case.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey               18/10/2016              Original Version
***************************************************************************************************/
global with sharing class MFS_ActivityDetailBatchSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        MFS_ActivityDetailBatch runBatch = new MFS_ActivityDetailBatch();
        Database.executeBatch(runBatch, 200);
    }

}