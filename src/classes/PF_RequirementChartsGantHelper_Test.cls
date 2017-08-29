/**
 * This class contains unit tests for PF_RequirementChartsGantHelper_Test
 *
 */
@isTest
private class PF_RequirementChartsGantHelper_Test {
    static testMethod void myUnitTest(){
        //Prepare project 
        PF_Project__c project = new PF_Project__c();
        project.Name = 'Project Test';       
        project.PF_Stage__c = 'Planned';
        insert project;
        
        //Prepare Release
        PF_Release__c release = new PF_Release__c();
        release .Name = 'Release Test';       
        release.PF_Status__c= 'New';
        release.PF_Project__c = project.id;
        release.PF_Planned_Start_Date__c = Date.Today();
        release.PF_Planned_End_Date__c    = Date.Today().addDays(10);
        
        insert release;
        
        PF_Sprints__c sprint = new PF_Sprints__c();
        sprint.Name = 'sprint Test';
        sprint.PF_Sprint_Status__c = 'In Progress';
        sprint.PF_Release__c = release.Id;
        sprint.PF_Priority__c = 'High';
        sprint.PF_Number_Of_Resources__c= 2;
        sprint.PF_Planned_Start_Date__c = Date.Today();
        sprint.PF_Planned_End_Date__c    = Date.Today().addDays(10);
        
        insert sprint ;
        
        
        ApexPages.StandardController sc = new ApexPages.standardController(sprint);
        PF_RequirementChartsGanttHelper rcg = new PF_RequirementChartsGanttHelper(sc);
        
        
    }
}