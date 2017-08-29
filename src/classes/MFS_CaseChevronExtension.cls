/***************************************************************************************************
Apex Class Name    : MFS_CaseChevronExtension
Version            : 1.0 
Created Date       : 12 AUG 2016
Function           : This is used to construct Case chevron
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde            08/12/2016              Original Version
***************************************************************************************************/
public with sharing class MFS_CaseChevronExtension {
    //Variable declarations
    private final Case cse;
    public String caseStatus{get;set;} 
    public String currentStage{get;set;}
    public List<String> pickListVals {get; set;}
    public String valsText {get; set;}
    public Boolean loadOnce {get; set;}
    public static String CLOSED = 'Closed';
    
    //Constructor
    public MFS_CaseChevronExtension(ApexPages.StandardController stdController){
        this.cse= (Case)stdController.getRecord();
        loadOnce=true;
        //Get the current Stage of the cseortunity
        if(cse.id != NULL)
            caseStatus = [select ToLabel(Status) from Case where id = : cse.id LIMIT 1].Status;
        else
            caseStatus = '';
    }
    
    //Method executes when the page loads to get the picklist value from the Page
    public PageReference reload() {
        CLOSED = Label.Case_Stage_Closed;
        pickListVals=new List<String>();
        Boolean skip=true;
        for (String val : valsText.split(':')){
            if (skip){
                skip=false;
            }
            else{
                pickListVals.add(val);
            }
        }
        loadOnce=false;
        return null;
    }
    
    //Getter method to get the list of Completed status
    public List<String> getCompletedStages() {
        list<String> l = new list<String>() ;
        if((pickListVals != NULL && pickListVals.SIZE() >0) ) {        
            for(String s:pickListVals ){
                if((s != caseStatus) )
                    l.add(s);
                else
                    break;
            }
        }
        return l;
    }
    
    //Getter method to get the current status
    public String getInprogressStage()
    {
        if(pickListVals != NULL && pickListVals.SIZE() >0 ){  
            for(String s:pickListVals) {
                if(s == caseStatus){
                    return s;
                }    
            } 
        }
        return NULL;
    }
    
    //Getter method to get the list of Future Stages    
    public List<String> getFutureStages() {    
        List<String> l = new list<String>();
        if( !(caseStatus.contains(CLOSED) )) {
            Boolean flag = false;
            if(pickListVals != NULL && pickListVals.SIZE() >0) {  
                for(String s:pickListVals) {
                    if(s == caseStatus)
                        flag = true;
                    else if(flag) {
                        if((s.contains(CLOSED))) {
                            l.add(CLOSED);
                            break;
                        }    
                        else
                            l.add(s); 
                    }    
                }
            }
        }
        return l;
    }
}