/*
Apex class           :  StrategyPlanGoalsProgressBarExtension
Version               :  1.0 
Created Date          :  25 APR 2016
Function              :  This is the controller extension for the Page which displays the responsive and dynamic Progress Bar with Surplus.
                         The logic to calculate the Surplus is implemented in the controller.
                         Input Wrapper : Actual, goal
                         Output Wrapper: Actual, Remaining, Surplus
                        

Modification Log : 
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Maheshkumar            25 APR 2016              Initial Version
*/

public with sharing class MFS_SPlanGoalsProgressBarExtension{
    
    //Variable declarations
    public  Strategy_Plan__c oStyPlan;
    List<wInputData> lstInput{get;set;}
    public List<wOutputData> lstOutput{get;set;}

    //Input Data wrapper for Progress Bar; It contains the actual values.
    public class wInputData 
    {
        public String name { get; set; }
        public Decimal actual { get; set; }
        public Decimal goal { get; set; }
        
        //wrapper constructor
        public wInputData(String name, Decimal actual, Decimal goal) {
            this.name = name;
            this.actual = (actual == NULL)? 0:actual;
            this.goal = (goal == NULL)? 0:goal;
        }
    }    
    
    //Output Data wrapper for Progress Bar; It contains the percentage value 
    public class wOutputData 
    {
        public String name { get; set; }
        public Decimal actual { get; set; }
        public Decimal remaining { get; set; }
        public Decimal surplus { get; set; }
        public String info { get; set; }
        public wOutputData (){}
    }

    
    //Controller for Extension
    public MFS_SPlanGoalsProgressBarExtension(ApexPages.StandardController stdController)
    {
        this.oStyPlan= (Strategy_Plan__c)stdController.getRecord();
        
    }    
        
    //This is the initial method called when the page loads; This method query the Strategy Plan object to form the input wrapper and then calls buildchartdata() method to form the output data having percentage values and surplus.
    public void init()
    {
        try
       {
        if(oStyPlan.id != NULL)
            {
                oStyPlan = [select 
                            Institutional__c,
                            Institutional_Portfolio_Manager_Goal_Cou__c, 
                            Consultant_Meeting_Goal__c,
                            Consultant_Meeting_Goal_Counter__c, 
                            Portfolio_Manager_Meeting_Goal__c,
                            Portfolio_Manager_Meeting_Goal_Counter__c, 
                            Sr_Executive_Meeting_Goal__c,
                            Sr_Executive_Meeting_Goal_Counter__c,
                            Client_Engagement_Goal__c,
                            Client_Engagement_Counter__c, 
                            Client_Review_Meeting_Goal__c,
                            Client_Review_Meeting_Goal_Counter__c, 
                            Analyst_Meeting_Goal__c,
                            Analyst_Meeting_Goal_Counter__c, 
                            Sr_Investment_Speaker_Goal__c,
                            Sr_Investment_Speaker_Goal_Counter__c 
                       from Strategy_Plan__c where id = : this.oStyPlan.id LIMIT 1]; 
                
                //Create the input wrapper (containg counter, goal vlues) from the queried data
                lstInput = new List<wInputData>();
                lstInput.add( new wInputData (MFS_AllConstants.INST_PORTFOLIO_MGR_GOAL, oStyPlan.Institutional_Portfolio_Manager_Goal_Cou__c, Decimal.valueof(oStyPlan.Institutional__c != null ? oStyPlan.Institutional__c : '0')));
                lstInput.add( new wInputData (MFS_AllConstants.CLIENT_ENG_GOAL, oStyPlan.Client_Engagement_Counter__c, Decimal.valueof(oStyPlan.Client_Review_Meeting_Goal__c != null ? oStyPlan.Client_Review_Meeting_Goal__c : '0')));                
                lstInput.add( new wInputData (MFS_AllConstants.CONSULTANT_MEETING_GOAL, oStyPlan.Consultant_Meeting_Goal_Counter__c, Decimal.valueof(oStyPlan.Consultant_Meeting_Goal__c != null ?oStyPlan.Consultant_Meeting_Goal__c : '0')));
                lstInput.add( new wInputData (MFS_AllConstants.CLIENT_REVIEW_MEETING_GOAL, oStyPlan.Client_Review_Meeting_Goal_Counter__c, Decimal.valueof(oStyPlan.Client_Review_Meeting_Goal__c != null ? oStyPlan.Client_Review_Meeting_Goal__c : '0')));
                lstInput.add( new wInputData (MFS_AllConstants.PORTFOLIO_MGR_MEETING_GOAL, oStyPlan.Portfolio_Manager_Meeting_Goal_Counter__c, Decimal.valueof(oStyPlan.Portfolio_Manager_Meeting_Goal__c != null ? oStyPlan.Portfolio_Manager_Meeting_Goal__c : '0')));                
                lstInput.add( new wInputData (MFS_AllConstants.ANALYST_MEETING_GOAL, oStyPlan.Analyst_Meeting_Goal_Counter__c, Decimal.valueof(oStyPlan.Analyst_Meeting_Goal__c != null ? oStyPlan.Analyst_Meeting_Goal__c : '0')));
                lstInput.add( new wInputData (MFS_AllConstants.SR_EX_MEETING_GOAL, oStyPlan.Sr_Executive_Meeting_Goal_Counter__c, Decimal.valueof(oStyPlan.Sr_Executive_Meeting_Goal__c != null ? oStyPlan.Sr_Executive_Meeting_Goal__c : '0')));
                lstInput.add( new wInputData (MFS_AllConstants.SR_INVSTR_SPKR_MEETING_GOAL, oStyPlan.Sr_Investment_Speaker_Goal_Counter__c, Decimal.valueof(oStyPlan.Sr_Investment_Speaker_Goal__c != null ? oStyPlan.Sr_Investment_Speaker_Goal__c : '0')));                                
                
                //Form the output wrapper containing percentage values and surplus
                lstOutput = new List<wOutputData>();
                buildChartData (lstInput);
            }   
            }
            catch(Exception e)
            {
            	
            	
            system.debug('Error is Goal Bar::'+e.getMessage());	
                String errMsg = '';
                if(e.getMessage().containsIgnoreCase('Divide by 0')){
                   errMsg = 'There are blank goal parameters. To see the Goal progress all goals must be captured'; 
                }else{
                    errMsg = 'There is an error in viewing the page. Please contact your administrator';
                }
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errMsg);
            ApexPages.addMessage(myMsg);
            } 
        
    }   
    
    //Function to form output data wrapper having 3 datas: actual, goal and surplus in percentage format
    public void buildChartData (List<wInputData> lstInput)
    {
        for(wInputData input: lstInput)
        {
            wOutputData output = new wOutputData();
            output.name = input.name;
            output.info = input.actual + '/' + input.goal;            
            //Logic to calculate Surplus
            if(input.actual <= input.goal)
            {
                output.actual = ((input.actual)/input.goal)*100;
                output.remaining = ((input.goal - input.actual)/input.goal)*100;
                output.surplus = 0;
            }
            else
            {
                output.actual = ((input.goal)/input.actual)*100;
                output.remaining = 0;
                output.surplus = ((input.actual- input.goal)/input.actual)*100 ;                
            }
            lstOutput.add(output);
        }
    }

    //Excluded this code since Progress bar need to be shown as 100% always. 
    //Include this code if the Progress bar is dynamic based on quantity. 
    /* 
    //Function to return the maximum value; This value is taken as base value (100%) for the Progress bar       
    public Decimal findMax (List<wInputData> lstInput)
    {
        
        Decimal max = 0;//initial
        for(wInputData input: lstInput)
        {
            if(input.actual > max)
                max = input.actual;
            if(input.goal > max)
                max = input.goal;
        }
        return max;
    }
    */
    
}