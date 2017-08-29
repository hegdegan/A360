/***************************************************************************************************
Apex Class Name    : MFS_CaseTriggerHandler 
Version            : 1.0 
Created Date       : 15 MAY 2016
Function           : Class is a Handler class for MFS_CaseTrigger
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Priya Gupta               15/05/2016              Original Version
* Priya Gupta				15/11/2016				Added code for case team
***************************************************************************************************/

public class MFS_CaseTriggerHandler {
    /**
* @Description : Method is used to calculate number of actual business days based on users Business calender
* @Param : List Of cases & list of case owner
* @return: N/A
**/    
    public  static void calcualteBusinessDueDays(List<Case> caseRecords,List<Id> ownerIds)
    {
        try{
            Map<Id,Id> caseOwners= new  Map<Id,Id>();
            Map<String,List<Id>> ownerAddressMap= new  Map<String,List<Id>>(); 
            List<String> ownerAdd=new List<String>();
            for(User userRec:[select Id,Country,City from User where Id in:ownerIds])
            {            
                String userAdd=userRec.City != null?userRec.Country + ' ' + '(' + userRec.City + ')':userRec.Country;
                if(ownerAddressMap.get(userAdd)!=null)
                {
                    (ownerAddressMap.get(userAdd)).add(userRec.Id);
                }
                else
                {
                    ownerAddressMap.put(userAdd,new List<Id>{userRec.Id});
                }
            }
            //get business hours associated to case owners country/city
            List<BusinessHours> bHours =[select Id,Name from BusinessHours where Name In: ownerAddressMap.KeySet()];
            BusinessHours defaultHour=[select Id,Name from BusinessHours where isDefault=true limit 1]; 
            for(BusinessHours wHour:bHours)
            { 
                for(String add:ownerAddressMap.KeySet())
                {
                    for(Id userId:ownerAddressMap.get(add))			
                    {
                        if(Null!=wHour.Id)
                            caseOwners.put(userId,wHour.Id);
                        else
                            caseOwners.put(userId,defaultHour.Id);
                    }
                    
                }
            }
            for(Case caseRec:caseRecords)
            {
                //add 7 days excluding today to IMA finalization date
                if(NULL!=caseOwners.get(caseRec.OwnerId))
                {
                    caseRec.IMA_Finalization_Date__c	= (BusinessHours.addGMT(caseOwners.get(caseRec.OwnerId),System.today(),(8)*24*60*60*1000)).Date();
                }
                else
                {
                    caseRec.IMA_Finalization_Date__c	= (BusinessHours.addGMT(defaultHour.id,System.Today(),(8)*24*60*60*1000)).Date();
                }
            }
        }
        
        Catch (Exception exe)
        {
            System.debug('Exception Occured:'+exe.getMessage()+exe.getLineNumber());
        }
    }
    
    /**
* @Description : Method is used to create a list Case Team using related opportunity team members.
* @Param : Set of case ids
* @return: List<CaseTeamMember>
**/     
    public static  List<CaseTeamMember> addNewTeamMember(Set<Id> caseList){
        List<CaseTeamMember> caseTeamMembers=new  List<CaseTeamMember>();         
        Map<Id,Id>caseOppMap=new Map<Id,Id>();
        for(Case caseRec:[Select Related_To_Opportunity__r.Id,Id from Case where Id in :caseList]){
            caseOppMap.put(caseRec.Related_To_Opportunity__r.Id,caseRec.Id);
        }
        Map<String,Id> caseRoles=new Map<String,Id>();     
        for(CaseTeamRole role:[Select Name,Id from CaseTeamRole]){
            caseRoles.put(role.Name,role.Id);  
        }
        for(OpportunityTeamMember oppTeamM: [Select OpportunityId,TeamMemberRole,UserId from OpportunityTeamMember where OpportunityId in :caseOppMap.keySet()]){
            CaseTeamMember caseTeamM=new  CaseTeamMember();
            caseTeamM.MemberId=oppTeamM.UserId;
            caseTeamM.TeamRoleId=(caseRoles.get(oppTeamM.TeamMemberRole));
            caseTeamM.ParentId=(caseOppMap.get(oppTeamM.OpportunityId));                   
            caseTeamMembers.add(caseTeamM);
        }
        system.debug('these are out returned CaseTeamMemberm>>> ' +caseTeamMembers );
        return caseTeamMembers; 
    }
    
    /**
    * @Description : Method is used on Insert to add new team members.
    * @Param : Set of case ids
    * @return: N/A
    **/     
    public static void addTeamMember(Set<Id> caseList){        
        try{
            List<CaseTeamMember> caseTeamMembers = addNewTeamMember(caseList);
            system.debug('These are our Case Team Member >> ' + caseTeamMembers);
            if(!caseTeamMembers.isEmpty()){
                insert caseTeamMembers;
            }
        } catch (Exception exe){
            system.debug('This our our Exception ' + exe);
            System.debug('Exception Occured >>>> :'+exe.getStackTraceString()); 
        }
    }
    
    /**
* @Description : Method is used on update to add new team members & update existing.
* @Param : Set of case ids
* @return: N/A
**/
    public static void updateTeamMember(Set<Id> caseList)
    {
        try{
            List<CaseTeamMember> caseTeamMembersInsert=new List<CaseTeamMember>();
            List<CaseTeamMember> caseTeamMembersUpdate=new List<CaseTeamMember>();
            Map<Id,List<CaseTeamMember>> newTemMembers=new Map<Id,List<CaseTeamMember>>();
            for(CaseTeamMember caseTemMem:addNewTeamMember(caseList))
            {
                if(Null==newTemMembers.get(caseTemMem.ParentId))
                {
                    List<CaseTeamMember> memList=	new List<CaseTeamMember>();
                    memList.add(caseTemMem); 
                    newTemMembers.put(caseTemMem.ParentId,memList);   
                }
                
                else
                    (newTemMembers.get(caseTemMem.ParentId)).add(caseTemMem);
                
            }
            Map<Id,List<CaseTeamMember>> existingTemMembers=new Map<Id,List<CaseTeamMember>>();
            for(CaseTeamMember caseTemMem:[Select MemberId,TeamRoleId,ParentId from CaseTeamMember where ParentId in :caseList])
            {
                if(Null==existingTemMembers.get(caseTemMem.ParentId))
                {
                    List<CaseTeamMember> memList=	new List<CaseTeamMember>();
                    memList.add(caseTemMem); 
                    existingTemMembers.put(caseTemMem.ParentId,memList);   
                }
                
                else
                    (existingTemMembers.get(caseTemMem.ParentId)).add(caseTemMem);
                
            }
            List<CaseTeamMember> memberToUpsert=new List<CaseTeamMember>();
            for(Id caseId:newTemMembers.keySet())
            {
                Set<CaseTeamMember> newMemb=new Set<CaseTeamMember>(newTemMembers.get(caseId));
                Set<CaseTeamMember> newMemb1=new Set<CaseTeamMember>(newTemMembers.get(caseId));
                Set<CaseTeamMember> extMemb=new Set<CaseTeamMember>(existingTemMembers.get(caseId));
                
                for(CaseTeamMember extCaseMem:extMemb)
                {
                    for(CaseTeamMember newCaseMem:newMemb)
                        if(extCaseMem.MemberId==newCaseMem.MemberId)
                    {
                        newMemb1.remove(newCaseMem);
                        if(extCaseMem.TeamRoleId!=newCaseMem.TeamRoleId)
                            extCaseMem.TeamRoleId=newCaseMem.TeamRoleId;
                        else 
                            extMemb.remove(newCaseMem); 
                    }                       
                }
                memberToUpsert.addAll(newMemb1);
                memberToUpsert.addAll(extMemb);
            }
            if(!memberToUpsert.isEmpty())
                upsert memberToUpsert;
            
        }
        catch (Exception exe)
        {
            System.debug('Exception Occured:'+exe.getStackTraceString());
        } 
    }
}