/***************************************************************************************************
Apex Class Name    : MFS_RecurringCaseBatchSchedule 
Version            : 1.0 
Created Date       : 13 June 2016
Function           : Schedule recurring case batch class to insert child case.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey               13/06/2016              Original Version
***************************************************************************************************/
global with sharing class MFS_RecurringCaseBatchSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        MFS_RecurringCaseBatch runBatch = new MFS_RecurringCaseBatch();
        Database.executeBatch(runBatch, 200);
    }
}