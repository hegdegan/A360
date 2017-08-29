/***************************************************************************************************
Apex Class Name    : MFS_OppTeamController 
Version            : 1.0 
Created Date       : 16 June 2016
Function           : Class is used to add opportunity team members using cusotm Add button
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               16/06/2016              Original Version
***************************************************************************************************/

public with sharing class MFS_OppTeamController {
    public List<oppTemWrapper> oppTeaWlist{get;set;}
    public Boolean isDuplicate{get;set;}
    public Opportunity oppRec{get;set;}
    public integer selectedRow{get;set;}
    public String selectedUserId{get;set;}
    public String selectedUserName{get;set;}
    
    //Constructor 
    public MFS_OppTeamController (ApexPages.StandardController controller) {
        try{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,
                                                       System.Label.Opp_Team_Info+'<a href='+MFS_AllConstants.HELP_URL+'>Learn More</a>'));
            oppRec=[Select Name from Opportunity where id=:String.escapeSingleQuotes(controller.getRecord().Id)];
        } catch(Exception exe) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
        }
    }
    
    /**
     * @Description : Method is used to add member rows on page
     * @Param : N/A
     * @return: PageReference
    **/ 
    public PageReference getMemberList(){
        oppTeaWlist=new List<oppTemWrapper>();
        if(oppTeaWlist.size()==0){
            for(integer i=0;i<5;i++){             
                 oppTemWrapper oppW=new oppTemWrapper();
                oppW.oppTeamMem=new OpportunityTeamMember();
                 oppW.oppTeamMem.OpportunityId=oppRec.id;
                oppW.rowNum=i;
                oppTeaWlist.add(oppW);
            }
        }
        return null;
    }
    
    /**
    * @Description : Method is used to get User role from user record based on selected team member
    * @Param : N/A
    * @return: N/A
    **/ 
    public void getUserRole(){
        OpportunityTeamMember oppT= (oppTeaWlist.get(selectedRow)).oppTeamMem;
        if(oppT.UserId!=null ){
            ((oppTeaWlist.get(selectedRow)).oppTeamMem).TeamMemberRole=([Select User_Role__c from user where id=:oppT.UserId]).User_Role__c; 
        }
    }
    
    /**
* @Description : Method is used set user role
* @Param : N/A
* @return: N/A
**/     
    public  void setUserRole(){      
    }
    
    /**
* @Description : Method is used set user access level on opportunity
* @Param : N/A
* @return: N/A
**/     
    public  void setOppAccess(){        
    }    
    
    /**
     * @Description : Wrapper class to display Team members on user interface
    **/     
    public class oppTemWrapper{
        public OpportunityTeamMember oppTeamMem{get;set;}
        public integer  rowNum{get;set;}
    }  
 
    /**
     * @Description : Method is used to insert or update opportunity team members
     * @Param : N/A
     * @return: PageReference
    **/     
    public PageReference saveTeamMember(){
        PageReference pageRef;
        List<OpportunityTeamMember> memberToAdd=new List<OpportunityTeamMember>();
        List<Id> userIdList=new List<Id>();
        Set<id> uniqueMember=new Set<id>();
        
        try{ 
            for(oppTemWrapper oppTeamW :oppTeaWlist){             
                if(oppTeamW.oppTeamMem.UserId!=null){ 
                    userIdList.add(oppTeamW.oppTeamMem.UserId);
                    memberToAdd.add(oppTeamW.oppTeamMem);
                }
            }          
            uniqueMember.addAll(userIdList);
            if(uniqueMember.size()<userIdList.size()){
                isDuplicate=true;
            } else {
                memberToAdd=checkExistingMember(memberToAdd);
                if(!memberToAdd.isEmpty())
                    upsert memberToAdd;
                pageRef= new PageReference('/'+oppRec.id);
            }
        } catch(Exception exe) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getmessage()));
            pageRef=null;
        }
        return pageRef;      
    } 
    
  	/**
     * @Description : Method is identify existing Team member for opportunity 
     * @Param : N/A
     * @return: PageReference
    **/   
    public  List<OpportunityTeamMember> checkExistingMember(List<OpportunityTeamMember> exMemList){
        Map<Id,OpportunityTeamMember> existingMember=new Map<Id,OpportunityTeamMember>();
        for(OpportunityTeamMember oppTeamM:[Select OpportunityAccessLevel,TeamMemberRole,userId,id from OpportunityTeamMember where OpportunityId=:oppRec.id]){
            existingMember.put(oppTeamM.userId,oppTeamM);
        }
          for(integer i=0;i< exMemList.size();i++){
              OpportunityTeamMember oppTeamMem=exMemList.get(i);
              if(null!=existingMember.get(oppTeamMem.userId)){
                  if(existingMember.get(oppTeamMem.userId).TeamMemberRole!=oppTeamMem.TeamMemberRole || (existingMember.get(oppTeamMem.userId).OpportunityAccessLevel!=oppTeamMem.OpportunityAccessLevel)){
                   existingMember.get(oppTeamMem.userId).TeamMemberRole=oppTeamMem.TeamMemberRole;
                   existingMember.get(oppTeamMem.userId).OpportunityAccessLevel=oppTeamMem.OpportunityAccessLevel;
                   oppTeamMem= existingMember.get(oppTeamMem.userId);
                  } else {
                      exMemList.remove(i);
                  }
              }
          }
        
        return exMemList;
    }
    
    //Getter
    public static List<SelectOption> getAccessLevel(){
         List<Selectoption>  accesLevelList=new List<Selectoption> ();
         accesLevelList.add(new SelectOption(MFS_AllConstants.EDIT,MFS_AllConstants.READ_WRITE));  
         accesLevelList.add(new SelectOption(MFS_AllConstants.READ,MFS_AllConstants.READ_ONLY)); 		 
         return accesLevelList;

    }
      //Getter  
      public void getUserRoleSF1(OpportunityTeamMember oppT){ 
        if(oppT.UserId!=null ){
              ((oppTeaWlist.get(selectedRow)).oppTeamMem).TeamMemberRole=([Select User_Role__c from user where id=:oppT.UserId]).User_Role__c; 
           }
    }
    
    //Setter
    public void setUserId(){ 
        System.debug('oppTeaWlist:'+oppTeaWlist);
        OpportunityTeamMember oppT= (oppTeaWlist.get(selectedRow)).oppTeamMem;
        oppT.UserId=selectedUserId   ;
        oppT.User_Name__c=selectedUserName   ;
        
        getUserRoleSF1(oppT);
    } 

}