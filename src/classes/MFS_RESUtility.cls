/*
Apex class           :  MFS_RESUtility
Version               :  1.0
Created Date          :  10 NOV 2016
Function              :  This Utility class contains all methods related to RES opportunity
Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* GYANENDRA SINGH        10 NOV 2016              Initial Version
*/
public with sharing class MFS_RESUtility {
    private static final String TEAM_ROLE_DEFAULT ='Internal Wholesaler';
    private static final String ACCESS_LEVEL = 'Edit';
    //Code to save the RES record
    public static boolean saveRESRecord(Opportunity op, string selectedCoverageTeamMembers, Task parentTask, Event parentEvent, Boolean taskCallNote, Boolean eventCallNote, List<MFS_Activity360GeneralUtility.wrapperClass> taskWrapperList,
                                        Activity_Detail__c callNote, List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperList, List<MFS_Activity360GeneralUtility.wrapperClass> competitorProdWrapperList)
    {
        boolean flag = true;  
        Contact con = new Contact();
        try{
            if(op!=null){
                try{
                    insert op;
                    flag = false;
                }
                catch(DMLException e){
                    //return the falg as true if opportunity does not get inserted
                    flag = true;
                }
                if(op.id!=null){
                    
                    Boolean isOpptyProdCreateEnabled = MFS_Utilities.GetAppSettingValue('EnableOpportunityLineItem', 'Yes') == 'Yes' ? true : false;
                    if(isOpptyProdCreateEnabled){
                        //Add all products to opportunity
                        Set<Id> prodIds = new Set<Id>();
                        for(MFS_Activity360GeneralUtility.WrapperClass prdWc : ProductWrapperList)
                        {
                            prodIds.add(prdWc.wProduct.Id);
                        }
                        //Get the pricebook entries where Opportunity currency == pricebook entry currency
                        List<PriceBookEntry> priceBooks = new List<PriceBookEntry>([select id, UnitPrice, isActive, Strategy_Name__c, Portfolio_Name__c,Product_Record_Type__c,
                                                                                    Asset_Class_Geography__c, Product_Vehicle__c, Restricted__c from PricebookEntry where product2.id IN :prodIds and currencyisocode = :op.currencyisocode and Pricebook2.isStandard = true and isActive = true]);
                        List<OpportunityLineItem> oppProdList = new List<OpportunityLineItem>();
                        OpportunityLineItem oppProd;
                        for(PriceBookEntry pbe : priceBooks)
                        {
                            oppProd = new OpportunityLineItem(OpportunityId= op.Id, Product_Name__c=pbe.Strategy_Name__c, Portfolio_Name__c=pbe.Portfolio_Name__c, PriceBookEntryId=pbe.ID, Product_Record_Type__c=pbe.Product_Record_Type__c, Quantity = 1, Asset_Class_Geography__c = pbe.Asset_Class_Geography__c, Restricted__c=pbe.Restricted__c, Fee_Structure__c= MFS_AllConstants.FEE_TYPE_STD, Is_Unknown__c=false, UnitPrice=0);
                            oppProdList.add(oppProd);
                        }
                        if(oppProdList.size() > 0)
                            database.insert (oppProdList,false);
                        
                        //Add all competitor products to opportunity
                        Set<Id> comProdIds = new Set<Id>();
                        List<Competitor_Product_Opp_Association__c> comProdOpptyList = new List<Competitor_Product_Opp_Association__c>();
                        Competitor_Product_Opp_Association__c comProdOpptyJn;
                        for(MFS_Activity360GeneralUtility.WrapperClass comPrdWc : competitorProdWrapperList)
                        {
                            comProdOpptyJn = new Competitor_Product_Opp_Association__c(Competitor_Product__c = comPrdWc.wCompProduct.Id, Opportunity__c = op.Id);
                            comProdOpptyList.add(comProdOpptyJn);
                        }
                        if(comProdOpptyList.size() > 0)
                            insert comProdOpptyList;
                        
                    }
                    if(taskCallNote){
                        if(!String.isEmpty(parentTask.WhoId))
                            con = [Select Id, Name from Contact where Id =:parentTask.WhoId];
                        parentTask.WhatId = op.Id; 
                        upsert parentTask;   
                    }
                    if(eventCallNote){
                        if(!String.isEmpty(parentEvent.WhoId))
                            con = [Select Id, Name from Contact where Id =:parentEvent.WhoId];
                        parentEvent.WhatId = op.Id; 
                        upsert parentEvent;   
                    }
                    if(!string.isEmpty(selectedCoverageTeamMembers)){
                        
                        String sChatterText = System.Label.A360_RES_Chatter_Feed+'';
                        sChatterText = (con.id!=null) ? '@'+con.Name+' '+sChatterText : sChatterText;
                        List<Id> coverageTeamMemberIds = new List<Id>();
                        
                        if(selectedCoverageTeamMembers.contains(',')){
                            List<Id> parts = selectedCoverageTeamMembers.split(',');
                            if(parts.size() > 0){
                                for(Id s : parts){
                                    coverageTeamMemberIds.add(s);
                                }
                            }
                        }
                        else{
                            coverageTeamMemberIds.add(selectedCoverageTeamMembers);  
                        }
                        if(!coverageTeamMemberIds.isEmpty() && coverageTeamMemberIds.size() > 0){
                            boolean success = MFS_ChatterApiUtility.postChatterWithSingleTextMultiMentionAndSingleLink(coverageTeamMemberIds, op.Id, sChatterText, op.Id);
                            addToOpportunityTeam(op, coverageTeamMemberIds);
                        } 
                    }
                    createRESFollowUpTask(op, taskWrapperList, callNote);
                }
            }  
        }
        catch(Exception ex){
            system.debug('Exception in saveRESRecord : '+ex.getStackTraceString());
            throw ex;
        }
        return flag; 
    }
    //Add the Contact's coverage team members to the opportunity team
    public static void addToOpportunityTeam(Opportunity op, List<Id> memberIds){
        List<OpportunityTeamMember> listOfMembers = new List<OpportunityTeamMember>();
        try{
            if(memberIds.size() > 0){
                for(Id mId : memberIds){
                    OpportunityTeamMember otm = new OpportunityTeamMember();
                    otm.OpportunityId = op.Id;
                    otm.OpportunityAccessLevel = ACCESS_LEVEL;
                    otm.TeamMemberRole = TEAM_ROLE_DEFAULT;
                    otm.UserId = mId;
                    
                    listOfMembers.add(otm);
                }
                insert listOfMembers;
            }  
        }
        catch(Exception ex){
            system.debug('Exception in addToOpportunityTeam : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Creates a follow up task if the RES Opportunity record is saved successfully
    public static void createRESFollowUpTask(Opportunity op, List<MFS_Activity360GeneralUtility.wrapperClass> taskWrapperList, Activity_Detail__c callNote){
        try{
           	String oppUpdatedName = [select Name from Opportunity where id = :op.Id].Name;
            Task t = new Task();
            t.OwnerId = op.OwnerId;
            t.Status = MFS_AllConstants.RES_FOLLOW_UP_TASK_DEFAULT_STATUS;
            t.Subject = Label.A360_FOLLOWUP_TASK_SUBJECT_FIELD_DEFAULTVALUE + oppUpdatedName;//op.Name;
            t.ActivityDate = op.Notification_Date__c;
            t.WhatId = op.Id;
            t.recordTypeId =  [select id from RecordType where DeveloperName = 'Log_a_Call_Retail' LIMIT 1].Id;
            if(op.DCI_Lead__c){
                t.Follow_up_Type__c = MFS_AllConstants.FOLLOWUP_TASK_TYPE_FOR_DCILead; 
            }else{
                t.Follow_up_Type__c = MFS_AllConstants.FOLLOWUP_TASK_TYPE_FOR_MIM; 
            }
            Activity_Detail__c ad = new Activity_Detail__c();
            
            ad.Subject__c = t.Subject;
            if(ad.Organization__c == null){ 
                ad.Organization__c= ( !string.isEmpty(t.WhatId) && t.WhatId!=null && (String)((t.WhatId).getSobjectType().getdescribe().getName()) =='Account') ? t.WhatId : Null;
            }
            ad.Contact__c= (!string.isEmpty(t.WhoId) && t.WhoId!=null && (String)((t.WhoId).getSobjectType().getdescribe().getName()) =='Contact') ? t.WhoId : Null;
            ad.Not_An_Orphan_Record__c = true;
            
            upsert ad;
            if(ad.Id!=null){
                t.Activity_Detail__c = ad.Id;
                t.Parent_Activity_Detail_Id__c = callNote.Id;
                t.priority = 'Normal';
                insert t;
                
                if(t.Id!=null){
                    taskWrapperList.add(new MFS_Activity360GeneralUtility.wrapperClass(t, false));  
                }
            }  
        }
        catch(Exception ex){
            system.debug('Exception in createRESFollowUpTask : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Change the Notification Date if the Close Date is changed
    public static void changeDates(Opportunity op){
        try{
            if(op.CloseDate!=null){
                BusinessHours defHours = [select Id,Name from BusinessHours where isDefault =: true];
                
                Long bDiff;
                Long tempDiff;
                Date notificationDate = op.CloseDate - 5;
                op.Notification_Date__c = notificationDate;
                
                DateTime startDate = datetime.newInstance(notificationDate.year(), notificationDate.month(),notificationDate.day());
                DateTime endDate = datetime.newInstance(op.CloseDate.year(), op.CloseDate.month(),op.CloseDate.day());
                
                do{
                    bDiff = BusinessHours.diff(defHours.Id, startDate, endDate);
                    tempDiff = 5 - bDiff;
                    
                    if(tempDiff == 0){
                        op.Notification_Date__c = date.newInstance(startDate.year(),startDate.month(),startDate.day());  
                    }
                    else{
                        startDate = startDate - (Integer)tempDiff;
                    }
                }
                while(tempDiff == 0);
            }
        }
        catch(Exception ex){
            system.debug('Exception in changeDates : '+ex.getStackTraceString());
            throw ex;
        }
        
    }
    
    //This method returns all the values for the Contact's coverage team in JSON format
    public static String getContactCoverageTeamMembers(Task parentTask, Event parentEvent, Boolean taskCallNote, Boolean eventCallNote){
        
        String jSONString;
        JSONGenerator gen = JSON.createGenerator(false);
        
        try{
            gen.writeStartArray();
            
            if(jSONString == null){
                
                if(taskCallNote){
                    if(!String.IsEmpty(parentTask.WhoId) && parentTask.WhoId!=null && ((String)(parentTask.WhoId.getSobjectType().getdescribe().getName()) == 'Contact')){
                        for(Coverage_Team__c ct : [Select Id,Coverage_Owner__r.Name,Coverage_Owner__r.Id,Coverage_Role__c from Coverage_Team__c where Contact__c =: parentTask.WhoId LIMIT 999]){
                            if(ct.Coverage_Owner__r.Id != null){
                                gen.writeStartObject();
                                gen.writeStringField('id', ct.Coverage_Owner__r.Id);
                                gen.writeStringField('label', ct.Coverage_Role__c+': '+ct.Coverage_Owner__r.Name);
                                gen.writeEndObject();
                            }
                        }
                    }
                } 
                
                if(eventCallNote){
                    if(!String.IsEmpty(parentEvent.WhoId) && parentEvent.WhoId!=null && ((String)(parentEvent.WhoId.getSobjectType().getdescribe().getName()) == 'Contact')){
                        for(Coverage_Team__c ct : [Select Id,Coverage_Owner__r.Name,Coverage_Owner__r.Id,Coverage_Role__c from Coverage_Team__c where Contact__c =: parentEvent.WhoId LIMIT 999]){
                            if(ct.Coverage_Owner__r.Id != null){
                                gen.writeStartObject();
                                gen.writeStringField('id', ct.Coverage_Owner__r.Id);
                                gen.writeStringField('label', ct.Coverage_Role__c+': '+ct.Coverage_Owner__r.Name);
                                gen.writeEndObject();
                            }
                        }
                    }
                } 
            }
            
            gen.writeEndArray();
            jSONString = gen.getAsString();  
        }
        catch(Exception ex){
            system.debug('Exception in getContactCoverageTeamMembers : '+ex.getStackTraceString());
            throw ex;
        }
        return jSONString;
    }
    
     public static void removeProductFromRES(string individualChildRecordId, List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperListForRES)
    {
        //try{
            if(!ProductWrapperListForRES.isEmpty())
            {
                List<MFS_Activity360GeneralUtility.wrapperClass> lstNotToRemove = new List<MFS_Activity360GeneralUtility.wrapperClass>();
                if(individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                    for(MFS_Activity360GeneralUtility.wrapperClass wc: ProductWrapperListForRES)
                    {
                        //create a list of products which are not getting removed
                        if(wc.wProduct.id != individualChildRecordId){ 
                            lstNotToRemove.add(wc); 
                        }   
                    }
                    }
                ProductWrapperListForRES.clear();
                //recreate the product list
                ProductWrapperListForRES.addAll(lstNotToRemove);
            }
        //}catch(Exception ex){
        //    throw ex;
        //}
    }
    
    public static void removeCompProductFromRES(string individualChildRecordId, List<MFS_Activity360GeneralUtility.wrapperClass> compProdWrapperListForRES)
    {
        try{
            if(!compProdWrapperListForRES.isEmpty())
            {
                List<MFS_Activity360GeneralUtility.wrapperClass> lstNotToRemove = new List<MFS_Activity360GeneralUtility.wrapperClass>();
                if(individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                    for(MFS_Activity360GeneralUtility.wrapperClass wc: compProdWrapperListForRES)
                    {
                        //create a list of products which are not getting removed
                        if(wc.wCompProduct.id != individualChildRecordId){ 
                            lstNotToRemove.add(wc); 
                        }   
                    }
                    }
                compProdWrapperListForRES.clear();
                //recreate the product list
                compProdWrapperListForRES.addAll(lstNotToRemove);
            }
        }catch(Exception ex){
            system.debug('Exception in removeCompProductFromRES : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
}