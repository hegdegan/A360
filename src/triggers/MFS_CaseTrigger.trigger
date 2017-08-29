trigger MFS_CaseTrigger on Case (before insert,before update,after insert,after update) {
    
    //before Trigger event
    If(Trigger.isBefore)
    {
        //Get onboarding recordtypeId
        //Id recTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Onboarding).getRecordTypeId();
        Id recTypeId = [select id from recordtype where developername='Onboarding' and SObjectType = 'Case' LIMIT 1].Id;
        List<Case> caseToupdate=new List<Case>();
        List<Id> caseOwners=new List<Id>();
        for(Case caseRec: Trigger.new)
        {
            if(caseRec.RecordTypeId==recTypeId && caseRec.Funding_Date__c!=null)
            {
                caseToupdate.add(caseRec) ;
                caseOwners.add(caseRec.OwnerId);
            }
        }
        //Caclulate IMA Finalized date for Onboarding case
        if(!caseToupdate.isEmpty())
            MFS_CaseTriggerHandler.calcualteBusinessDueDays(caseToupdate, caseOwners);
    }
    
    //after Trigger event
    if(Trigger.isAfter)
    { 
        //prevent recursive execution of the trigger. Trigger should run only once
        if(MFS_Utilities.runOnce())
        {
            Set<Id> caseIds=new Set<Id>();
            if(Trigger.isInsert)
            {
                for(Case cs : Trigger.new)
                {
                    Id recTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Onboarding).getRecordTypeId();
                    if(cs.RecordTypeId == recTypeId && cs.Related_To_Opportunity__c!=null)
                    {
                        caseIds.add(cs.id); 
                    }
                }
                //add case team members from opportunity
                if(!caseIds.isEmpty())
                {
                    system.debug('About to add Case Team from Oppty');	
                    MFS_CaseTriggerHandler.addTeamMember(caseIds);                                           
                }
            }
            if(Trigger.isUpdate)
            {
                Id recTypeId = [select id from recordtype where developername='Onboarding' and SObjectType = 'Case'].Id;
                for(Case cs : Trigger.new)
                {
                    if(cs.RecordTypeId == recTypeId && cs.Related_To_Opportunity__c!=null &&  cs.Related_To_Opportunity__c!=((Trigger.oldMap).get(cs.id)).Related_To_Opportunity__c)
                    {
                        caseIds.add(cs.id); 
                    }
                }
                //update case team members
                if(!caseIds.isEmpty())
                {
                    MFS_CaseTriggerHandler.updateTeamMember(caseIds);                           
                }
            }
        }
    }
}