@isTest
public class MFS_CaseSchedulerControllerTest {
   
    @testSetup
    static void dataSetup(){
        
    }
    
    static testmethod void RecurringCaseTest(){
        Account acc = MFS_TestDataUtility.createAccount();
        Test.StartTest();
        insert acc;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        User usr = MFS_TestDataUtility.createUser('System Administrator');
        insert usr;
        Case csRec = MFS_TestDataUtility.createCase(cont);
        csRec.Repeats__c = 'Quarterly';
        csRec.Start_Date__c = System.today();
        csRec.Repeat_On_Weekly__c = 'Tue';
        csRec.Due_In__c = 5;
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2017,9,24);
        csRec.Excludes_Weekends__c = 'Business Days';
        csRec.OwnerId = usr.Id;
        insert csRec;
        
        Case cse = [select Recurring_Case__c from case where Id =: csRec.Id];
        System.assertEquals(true, cse.Recurring_Case__c);
        Case cs = [select Repeats__c,Start_Date__c,Repeat_On_Weekly__c from Case where Id =: csRec.Id];
        MFS_CaseSchedulerController cseSchedule = new MFS_CaseSchedulerController(new ApexPages.StandardController(csRec));
        
        cseSchedule.save();
        cseSchedule.getDays();
        cseSchedule.getsummary();
        cseSchedule.endNow();
        
        csRec.Repeats__c = 'Weekly';
        csRec.start_date__C=Date.today();
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2017,9,24);
        csRec.Repeat_On_Weekly__c='Friday';
        //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        csRec.Repeats__c = 'Quarterly';
        csRec.Ends__c = 'On';
        cseSchedule.selectedQuarter='Beginning';
        csRec.Ends_On__c = Date.newInstance(2017,9,24);
        //update csRec;
        cseSchedule.getsummary();
        cseSchedule.save();
        Date tempDate=Date.newInstance(2017,4,4);
        
         csRec.Repeats__c = 'Quarterly';
        csRec.Ends__c = 'On';
        cseSchedule.selectedQuarter='End';
        csRec.Ends_On__c = Date.newInstance(2017,9,24);
       // update csRec;
        cseSchedule.getsummary();
        cseSchedule.save();
        
        csRec.Repeats__c = 'Annual';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2019,2,24);
        csRec.Start_Month__c='April';
        csRec.Start_Day__c='20';
        update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        csRec.Repeats__c = 'Monthly';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2019,2,24);
        csRec.Start_Month__c='March';
        csRec.Start_Day__c='31';
        //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        csRec.Repeats__c = 'Monthly';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2019,2,24);
        csRec.Start_Month__c='March';
        csRec.Start_Day__c=null;
        //update csRec;
        cseSchedule.getSummary();
        
        csRec.Repeats__c = 'Monthly';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2019,2,24);
        csRec.Start_Month__c='April';
        csRec.Start_Day__c='31';
        //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        csRec.Repeats__c = 'Monthly';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2019,2,24);
        csRec.Start_Month__c=null;
        csRec.Start_Day__c='31';
        cseSchedule.save();
        
        csRec.Repeats__c = 'Monthly';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2019,2,24);
        csRec.Start_Month__c='February';
        csRec.Start_Day__c='30';
        //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        csRec.Repeats__c = 'Monthly';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2019,2,24);
        csRec.Start_Month__c='April';
        csRec.Start_Day__c='30';
        csRec.Repeats_on__c=Date.newInstance(2017,5,31);
        //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        csRec.Repeats__c = 'Monthly';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2019,2,24);
        csRec.Start_Month__c='February';
        csRec.Start_Day__c='29';
        csRec.Repeats_on__c=Date.newInstance(2017,5,31);
        //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        csRec.Repeats__c = 'Monthly';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2019,2,24);
        csRec.Start_Month__c='February';
        csRec.Start_Day__c='2';
        csRec.Repeats_on__c=Date.newInstance(2017,5,31);
        //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        csRec.Repeats__c = 'Monthly';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2017,4,24);
        csRec.Start_Month__c='March';
        csRec.Start_Day__c='30';
        csRec.Repeats_on__c=Date.newInstance(2017,5,31);
        //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        csRec.Repeats__c = 'Quarterly';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2017,4,24);
        cseSchedule.selectedQuarter='Beginning';
        csRec.Repeats_on__c=Date.newInstance(2017,5,31);
        //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        csRec.Repeats__c = 'Annual';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2018,1,24);
        csRec.Start_Month__c='March';
        csRec.Start_Day__c='30';
        csRec.Repeats_on__c=Date.newInstance(2017,5,31);
        //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
         csRec.Repeats__c = 'Monthly';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2019,2,24);
        csRec.Start_Month__c='April';
        csRec.Start_Day__c='20;30';
        csRec.Repeats_on__c=Date.newInstance(2017,5,20);
       // update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        csRec.Repeats__c = 'Monthly';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2019,2,24);
        csRec.Start_Month__c='May';
        csRec.Start_Day__c='20;31';
        csRec.Repeats_on__c=Date.newInstance(2017,6,20);
        //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        
        csRec.Repeats__c = 'Semi Annual';
        csRec.Ends__c = 'On';
        csRec.Ends_On__c = Date.newInstance(2017,9,24);
         csRec.Start_Month__c='April';
        csRec.Start_Day__c='20;28';
       //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        
        
          csRec.Repeats__c = 'Monthly';
        csRec.Ends__c = 'Never';
         csRec.Start_Month__c='June';
        csRec.Start_Day__c='20;28';
        cseSchedule.getStartDay();
        cseSchedule.getSelectedStartDay();
        //update csRec;
        cseSchedule.getSummary();
        cseSchedule.save();
        Test.StopTest();
       // MFS_CaseSchedulerController cseSchedule1 = new MFS_CaseSchedulerController(new ApexPages.StandardController(csRec1));
        
    }
    
    static testmethod void RecurringCaseTestwithConditions(){
        Account acc = MFS_TestDataUtility.createAccount();
        Test.StartTest();
        insert acc;
        Contact cont = MFS_TestDataUtility.createContact(acc.id);
        insert cont;
        Case csRec = MFS_TestDataUtility.createCase(cont);
        insert csRec;
        
        Case csRec1 = MFS_TestDataUtility.createCase(cont);
        csRec1.Parent_Case_Number__c = csRec.Id;
        csRec1.Start_Date__c = (System.Today() - 5);
        insert csRec1;
        System.assertNotEquals(null, csRec1.Id);
         
        //MFS_CaseSchedulerController cseSchedule2 = new MFS_CaseSchedulerController(new ApexPages.StandardController());
       // cseSchedule1.Save();
        MFS_CaseSchedulerController cseSchedule1 = new MFS_CaseSchedulerController(new ApexPages.StandardController(csRec1));
        cseSchedule1.Save();
        
        MFS_CaseSchedulerController cseSchedule2 = new MFS_CaseSchedulerController(new ApexPages.StandardController(cont));
        
        csRec1.Start_Date__c = System.Today();
        csRec1.Repeats__c = 'Weekly';
        csRec1.Repeat_On_Weekly__c = null;
        update csRec1;
        cseSchedule1.Save();
        
        csRec1.Repeats__c = 'Weekly';
        csRec1.Repeat_On_Weekly__c = 'Tue';
        update csRec1;
        cseSchedule1.Save();
        
        csRec1.Due_In__c = null;
        csRec1.Excludes_Weekends__c = 'Business Days';
        update csRec1;
        cseSchedule1.Save();
        
        csRec1.Due_In__c = 5;
        update csRec1;
        cseSchedule1.Save();
        
        
        csRec1.Ends__c = 'On';
        csRec1.Ends_On__c = (System.Today() - 5);
        update csRec1;
        cseSchedule1.Save();
        
        csRec1.Ends__c = 'After';
        csRec1.Ends_On__c = System.Today();
        update csRec1;
        cseSchedule1.Save();  
        
        //Manoj
        csRec1.Due_In__c = 5;
        csRec1.Excludes_Weekends__c = null;
        update csRec1;
        cseSchedule1.Save();
        
        csRec1.Repeats__c = 'Monthly';
        csRec1.Ends__c = 'On';
        csRec1.Ends_On__c = Date.newInstance(2015,2,24);
        csRec1.Start_Date__c = Date.newInstance(2016,2,24);
        update csRec1;
        cseSchedule1.Save();
		
      	MFS_CaseSchedulerController.calculateNextCaseDate('Weekly', System.Today().addDays(30), 'January', '2;17', System.today().addDays(10));
        MFS_CaseSchedulerController.calculateNextCaseDate('Semi Annual', System.Today().addDays(30), 'January', '2;17', NULL);
        MFS_CaseSchedulerController.calculateNextCaseDate('Semi Annual', System.Today().addDays(30), 'January', '2;17', System.today().addDays(10));
           
        Test.stopTest();
    }
}