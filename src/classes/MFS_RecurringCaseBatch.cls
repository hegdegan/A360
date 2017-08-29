/***************************************************************************************************
Apex Class Name    : MFS_RecurringCaseBatch 
Version            : 1.0 
Created Date       : 08 June 2016
Function           : Batch class to insert child case based on the "Repats on" Date of Case object.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Jata Dubey               08/06/2016              Original Version
***************************************************************************************************/
global with sharing class MFS_RecurringCaseBatch implements Database.Batchable<SObject> , DataBase.Stateful{
    global String query;
    global List<Case> nextCaseList;
    global List<Case> oldCaseList;
    global List<Attachment> insertattList;
    //constructor
    global MFS_RecurringCaseBatch(){
        //String recId='500P0000004avZM';
        this.query='Select id,AccountId,CaseNumber,Number_of_Occurrence__c,Start_month__c,Start_Day__c,ContactId,Origin,Type,Sub_Type__c,Priority,OwnerId,Description,Repeats__c,Repeats_On__c,Ends__c,Total_No_of_Occurrences__c,Occurrence_Number__c,Start_Date__c,Repeat_On__c,Repeat_On_Weekly__c,Next_Case_CreateDate__c,Ends_On__c,Due_In__c,Excludes_Weekends__c from case where Recurring_Case__c =true'; 
        nextCaseList=new List<Case>();
        oldCaseList=new List<Case>(); 
        insertattList=new List<Attachment>();
    }
    
    /**
    * @Description : Method is used to return Parent Case records. 
    * @Param : Database.BatchableContext
    * @return: DataBase.QueryLocator
    **/
    global DataBase.QueryLocator start(Database.BatchableContext batchCon){
        return DataBase.getQueryLocator(query);
    }
    
    /**
    * @Description : Method is used to copy all the details of parent case and calculate next recurring case date.
    * @Param : DataBase.BatchableContext,List<sObject> 
    * @return: N/A
    **/
    global void execute(DataBase.BatchableContext batchCon,List<sObject> caseList){
        try{
             system.debug('date'+System.today().addDays(7));
            for(sObject sObjRec:caseList)  {
                Case caseRec=(Case)sObjRec; 
                if(System.today()==caseRec.Repeats_On__c){
                	//Date dt=Date.newInstance(2017,7,28);
                	//if(dt==caseRec.Repeats_On__c){
                    Case nextCase=new Case();
                    Case oldCase=new Case();
                    nextCase.AccountId=caseRec.AccountId;
                    nextCase.ContactId=caseRec.ContactId; 
                    nextCase.Origin=caseRec.Origin;
                    nextCase.Type=caseRec.Type;
                    nextCase.Sub_Type__c=caseRec.Sub_Type__c; 
                    nextCase.Priority=caseRec.Priority;
                    nextCase.Status=MFS_AllConstants.DEFAULT_CASE_STATUS;
                    nextCase.OwnerID=caseRec.OwnerId;
                    nextCase.Description=caseRec.Description;
                    nextCase.Parent_Case_Number__c=caseRec.CaseNumber;
                    nextCase.Parent_Case_Id__c=caseRec.Id;
                    nextCase.Excludes_Weekends__c=caseRec.Excludes_Weekends__c;
                    nextCase.Due_In__c=caseRec.Due_In__c; 
                    nextCase.Ends__c=caseRec.Ends__c;
                    nextCase.Ends_On__c=caseRec.Ends_On__c;
                    nextCase.Start_Date__c=caseRec.Start_Date__c;  
                    nextCase.Repeat_On_Weekly__c=caseRec.Repeat_On_Weekly__c;
                    nextCase.Occurrence_Number__c=caseRec.Occurrence_Number__c;
                    nextCase.Due_Date__c=MFS_CaseSchedulerController.populateDueDate(caseRec.ownerId,caseRec.Repeats_On__c,Integer.valueOf(caseRec.Due_In__c),caseRec.Excludes_Weekends__c);
                    oldCase.Id=caseRec.Id;
                    if(caseRec.Total_No_of_Occurrences__c == null){
                        nextCase.Total_No_of_Occurrences__c = 1; 
                        oldCase.Total_No_of_Occurrences__c = 1;
                    } else {
                        nextCase.Total_No_of_Occurrences__c = caseRec.Total_No_of_Occurrences__c + 1;
                        oldCase.Total_No_of_Occurrences__c = caseRec.Total_No_of_Occurrences__c + 1;
                    }
                   
                    Date repeatsOnDate;
                    String isCalled = 'Batch';
                    if(caseRec.Repeats__c.equals(MFS_AllConstants.RepeatsWeekly)) {
                        repeatsOnDate = MFS_CaseSchedulerController.calculateNextCaseDateWeekly(caseRec.Start_Date__c,caseRec.Repeat_On_Weekly__c,isCalled);
                    } else {
                       repeatsOnDate = MFS_CaseSchedulerController.calculateNextCaseDate(caseRec.Repeats__c,caseRec.Start_Date__c,caseRec.start_month__c,caseRec.start_day__C,caseRec.repeats_on__c);
                    }
                    nextCase.Number_of_Occurrence__c = MFS_CaseSchedulerController.calculateOccurrence(Integer.valueOf(nextCase.Total_No_of_Occurrences__c),Integer.valueOf(caseRec.Occurrence_Number__c),caseRec.Ends__c,caseRec.Repeats__c,caseRec.Ends_On__c,caseRec.Start_Date__c,repeatsOnDate);
                    oldCase.Number_of_Occurrence__c = MFS_CaseSchedulerController.calculateOccurrence(Integer.valueOf(nextCase.Total_No_of_Occurrences__c),Integer.valueOf(caseRec.Occurrence_Number__c),caseRec.Ends__c,caseRec.Repeats__c,caseRec.Ends_On__c,caseRec.Start_Date__c,repeatsOnDate);
                    //populate repeats on
                    System.debug('repeatsOnDate...'+repeatsOnDate+'caseRec.Ends_on__c...'+caseRec.Ends_on__c);
                    if(caseRec.Ends_on__c !=null && caseRec.Ends_on__c < repeatsOnDate && caseRec.Ends_on__c > caseRec.Start_Date__c) {
                        oldCase.Repeats_On__c = null; 
                    }	
                    else if(caseRec.Occurrence_Number__c!=null && caseRec.Occurrence_Number__c == nextCase.Total_No_of_Occurrences__c  ){
                        oldCase.Repeats_On__c = null;
                    } else {
                        oldCase.Repeats_On__c = repeatsOnDate;
                   }
                   
                    nextCaseList.add(nextCase);
                    oldCaseList.add(oldCase);
                }
            }
        } catch(Exception ex){
            System.debug('Execption occured:'+ex.getMessage());  
        }
        
        
    }
    
    /**
    * @Description : Method is used to Insert child case and copy attachments from parent case.
    * @Param : DataBase.BatchableContext
    * @return: N/A
    **/
    global void finish(DataBase.BatchableContext batchCon){
        try{
            if(!nextCaseList.isEmpty()){
                insert nextCaseList;
                Set<Id> oldCaseParentId = new Set<Id>();
                
                for(Case newCase : nextCaseList){
                    oldCaseParentId.add(newCase.Parent_Case_Id__c);
                }
                List<Attachment> attList = new List<Attachment>([select Id,name,body,ParentId from Attachment where ParentId in : oldCaseParentId]);
                if(!attList.isEmpty()){
                    for(Case newCase : nextCaseList){
                        for(Attachment a : attList){
                            if(newCase.Parent_Case_Id__c == a.ParentId){
                                Attachment attAdd = new Attachment(Name = a.Name,Body = a.Body,ParentId = newCase.Id);
                                insertattList.add(attAdd);
                            }
                        }
                    }
                    if(!insertattList.isEmpty()){
                        insert insertattList;
                    }
                }
            }
            if(!oldCaseList.isEmpty()){
               update oldCaseList; 
            }
        } catch(Exception ex) {
            System.debug('Execption occured:'+ex.getMessage());
        }
        
    }
}