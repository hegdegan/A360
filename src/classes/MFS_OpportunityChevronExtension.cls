/***************************************************************************************************
Apex Class Name    : OpportunityChevronExtension
Version            : 1.0 
Created Date       : 16 APR 2016
Function           : This Controller extension clas puts the Opportunity stages in 3 separate lists: 1) Completed,  2) Current, 3) Not Completed  .
These lists are used to create Custom Chevron (visual representation of  stage Progress ) for the Opportunity.
Note: The 'Closed Lost' and 'Closed Won' are represented by single entry 'Closed'
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Maheshkumar            16/04/2016              Original Version
* Ganesh Hegde            27/07/2016              Added logic to show Closed Won, Funded and Lost as closed
***************************************************************************************************/
public with sharing class MFS_OpportunityChevronExtension {
    
    public static String test = 'initial';
    //Variable declarations 
    public static String CLOSED = 'Closed';
    public static  String CLOSEDLOST = 'Lost' ;
    public static  String CLOSEDWON = 'Funded';
    public static  String CLOSEDWONARG = 'Closed Won';
    public static String RESOLVED = 'Resolved';
    
    public List<String> CompletedStages{get;set;}
    public String InprogressStage{get;set;}
    public List<String> FutureStages{get;set;}
    
    private final Opportunity opp;
    public String oppStage{get;set;} 
    public List<String> pickListVals {get; set;}
    public String valsText {get; set;}
    public Boolean loadOnce {get; set;}
    
    //Constructor
    public MFS_OpportunityChevronExtension(ApexPages.StandardController stdController) {
        
        system.debug('test = '+test);
        CompletedStages = new List<String>();
        InprogressStage = '';
        FutureStages = new List<String>();
        
        this.opp= (Opportunity)stdController.getRecord();
        loadOnce=true;
        //Get the current Stage of the Opportunity
        if(opp.id != NULL) {
            oppStage = [select ToLabel(Stagename) from Opportunity where id = : String.escapeSingleQuotes(opp.id)  LIMIT 1].Stagename;
            system.debug('oppStage'+oppStage);
            
        } else {
            oppStage = '';
        }
        
        CompletedStages=formCompletedStages();
        InprogressStage = formInprogressStage();
        FutureStages = formFutureStages();
    }
    
    //Method executes when the page loads to get the picklist value from the Page
    public PageReference reload(){
        system.debug('test'+test);
        test = 'reload';
        CLOSED = Label.OPP_Stage_Closed;
        CLOSEDLOST = Label.OPP_Stage_Closed_Lost;
        CLOSEDWON  = Label.OPP_Stage_Funded;
        CLOSEDWONARG  = Label.OPP_Stage_Closed_Won;
        RESOLVED  =  Label.OPP_Stage_Resolved;
        
        pickListVals=new List<String>();
        Boolean skip=true;
        for (String val : valsText.split(':')){
            if (skip){
                skip=false;
            } else {
                pickListVals.add(val);
            }
        }
        
        loadOnce=false;
        
        CompletedStages=formCompletedStages();
        InprogressStage = formInprogressStage();
        FutureStages = formFutureStages();
        return null;
    }
    
    
    //Getter method to get the list of Completed Stages
    public List<String> formCompletedStages(){
        list<String> l = new list<String>() ;
        if((pickListVals != NULL && pickListVals.SIZE() >0) ){        
            for(String s:pickListVals ){
                //if(s != oppStage){
                if((s != oppStage) && (!(s.contains(CLOSEDLOST) || (s.contains(CLOSEDWON) || s.contains(CLOSEDWONARG) || s.contains(RESOLVED))))) {
                    l.add(s);
                } else {
                    break;
                }
            }
        }
        return l;
    }
    
    //Getter method to get the current Stage
    public String formInprogressStage(){
        if(pickListVals != NULL && pickListVals.SIZE() >0 ){  
            for(String s:pickListVals){
                if(s == oppStage){
                    if((s.contains(CLOSEDLOST) || s.contains(CLOSEDWON) || s.contains(CLOSEDWONARG) || s.contains(RESOLVED))) {
                        return CLOSED;
                    } else {
                        return s;
                    }
                }    
            } 
        }
        return NULL;
    }
    
    //Getter method to get the list of Future Stages    
    public List<String> formFutureStages(){    
        List<String> l = new list<String>();
        if( !(oppStage.contains(CLOSEDLOST) || oppStage.contains(CLOSEDWON) ||oppStage.contains(CLOSEDWONARG) || oppStage.contains(RESOLVED))){
            Boolean flag = false;
            if(pickListVals != NULL && pickListVals.SIZE() >0){  
                for(String s:pickListVals){
                    if(s == oppStage) {
                        flag = true;
                    }
                    else if(flag){
                        if((s.contains(CLOSEDLOST) || s.contains(CLOSEDWON) || s.contains(CLOSEDWONARG) || s.contains(RESOLVED))){
                            l.add(CLOSED);
                            break;
                        } else {
                            l.add(s); 
                            
                        }
                    }    
                }
            }
        }
        return l;
    }
    
}