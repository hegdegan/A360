/*
Apex class            :  MFS_MeetingPreparationUtility
Version               :  1.0
Created Date          :  2 FEB 2017
Function              :  This Utility class contains all the common methods related to Meeting Preparation

Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* Maheshkumar Selvaraj            2 FEB 2017              Initial Version
*/


public class MFS_MeetingPreparationUtility {
/*
** Method Name     : updateMeetingPreparation
** Description     : Method to update Meeting Preparation fields
** Used in         : onclick of save button in Meeting Preparation Pop Up screen in Activity360. 
*/  
    public static Boolean updateMeetingPreparation(Activity_Detail__c callNote){
        try{
            update callNote;
            
            return TRUE;
        }
        catch(Exception e){    
            return FALSE;
        }
    }
}