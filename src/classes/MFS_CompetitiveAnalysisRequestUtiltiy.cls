/*
Apex class           :  MFS_CompetitiveAnalysisRequestUtiltiy
Version               :  1.0
Created Date          :  16 SEP 2016
Function              :  This Utility class contains all methods related to Competitive Analysis Related List in Activity360


Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* Maheshkumar            16 SEP 2016              Initial Version
*/
public with sharing class MFS_CompetitiveAnalysisRequestUtiltiy {    
    public static ID queueIdForDCTeam;
    public static ID queueIdForCompTeam;
    
    /*
** Method Name     : selectCompProductForCA
** Description     :  Method to select the Competitor Product Competitive Analysis Request 
** Used in         : search box in Competitive Analysis PopUp screen (Activity360 page)
*/ 
    public static void selectCompProductForCA(List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperListForCA, string individualChildRecordId,Competitive_Analysis_Request__c compRequest)
    {
        try{
            if(!ProductWrapperListForCA.isEmpty() &&(individualChildRecordId!=null && !string.isBlank(individualChildRecordId))){
                Competitive_Analysis_Product__c tempCPJn;
                for(MFS_Activity360GeneralUtility.wrapperClass wc:ProductWrapperListForCA){
                    if(wc.wProduct.id == individualChildRecordId){
                        if(wc.wCompAnalysisProdJn.Competitor_Product__c != NULL){
                            
                            //Query the selected Competitor Product and add it to the List to display  
                            if(compRequest.id != NULL)  {
                                if(wc.wCompAnalysisProdJn.Competitive_Analysis_Request__c == NULL){
                                    wc.wCompAnalysisProdJn.Competitive_Analysis_Request__c = compRequest.id;
                                }
                                wc.wCompAnalysisProdJN.Product__c = wc.wProduct.Id;
                                tempCPJn = wc.wCompAnalysisProdJn;
                                
                            }
                        }
                    }
                }
                upsert tempCPJn;
                
                Competitor_Product__c tempCp ;
                for(Competitor_Product__c t:  [select name,Firm__c,Firm_Name__c from Competitor_Product__c where id=:tempCPJn.Competitor_Product__c LIMIT 1] )//Firm_Name__c is added on 08/Feb/2017 to fix UAT defect
                {
                    tempCp= new Competitor_Product__c();
                    tempCp = t; 
                }
                for(MFS_Activity360GeneralUtility.wrapperClass wc:ProductWrapperListForCA){
                    if(wc.wProduct.id == individualChildRecordId){
                        if(wc.wCompAnalysisProdJn.Competitor_Product__c != NULL){
                            if(wc.lstCompProd == NULL){
                                wc.lstCompProd = new List<Competitor_Product__c>();
                            }
                            for(Competitor_Product__c tcp: wc.lstCompProd){
                                if(tcp.id == wc.wCompAnalysisProdJn.Competitor_Product__c ){
                                    wc.wCompAnalysisProdJn.Competitor_Product__c = NULL;
                                    return;
                                }
                            }
                            if(tempCp != NULL){
                                wc.lstCompProd.add(tempCp);  
                            }
                        }
                        wc.wCompAnalysisProdJn = new Competitive_Analysis_Product__c ();
                    }
                }
            }
        }catch(Exception ex){
            system.debug('Exception in selectCompProductForCA : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    
    public static void selectCompProductForCA(List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperListForCA, string individualChildRecordId,Competitive_Analysis_Request__c compRequest, Set<Id> selectedIds)
    {
        try{
            if(!ProductWrapperListForCA.isEmpty() &&(individualChildRecordId!=null && !string.isBlank(individualChildRecordId))){
                Competitive_Analysis_Product__c tempCPJn;
                for(MFS_Activity360GeneralUtility.wrapperClass wc:ProductWrapperListForCA){
                    if(wc.wProduct.id == individualChildRecordId){
                        if(compRequest.id != NULL) {
                            if(wc.wCompAnalysisProdJn.Competitive_Analysis_Request__c == NULL){
                                wc.wCompAnalysisProdJn.Competitive_Analysis_Request__c = compRequest.id;
                            }
                            wc.wCompAnalysisProdJN.Product__c = wc.wProduct.Id;
                            tempCPJn = wc.wCompAnalysisProdJn;
                            
                        }
                        if(wc.lstCompProd == NULL){
                            wc.lstCompProd = new List<Competitor_Product__c>();
                        }
                        for(Competitor_Product__c tcp: wc.lstCompProd){
                            if(selectedIds.contains(tcp.id)){
                                selectedIds.remove(tcp.id);
                            }
                        }
                    }
                }
                if(tempCPJn != null){
                    upsert tempCPJn;
                }
                List<Competitor_Product__c> cpList = [select name,Firm__c,Firm_Name__c from Competitor_Product__c where id IN :selectedIds];  
                for(MFS_Activity360GeneralUtility.wrapperClass wc:ProductWrapperListForCA){
                    if(wc.wProduct.id == individualChildRecordId){
                        wc.lstCompProd.addAll(cpList);
                        wc.wCompAnalysisProdJn = new Competitive_Analysis_Product__c ();
                    }
                }
            }
        }catch(Exception ex){
            system.debug('Exception in selectCompProductForCA : '+ex.getStackTraceString());
            throw ex;
        }
    }
    /*
** Method Name     : removeCompProductForCA
** Description     :  Method to remove the Competitor Product from Competitive Analysis Request 
** Used in         : onclick of 'remove' button in Competitive Analysis PopUp screen (Activity360 page) 
*/     
    public static void removeCompProductForCA(List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperListForCA, ID selectedCompProduct, String individualChildRecordId,Competitive_Analysis_Request__c compRequest)
    {
        try{
            //individualChildRecordId   selectedCompProduct
            if(!ProductWrapperListForCA.isEmpty() &&(selectedCompProduct!=null && !string.isBlank(selectedCompProduct))&&(individualChildRecordId!=null && !string.isBlank(individualChildRecordId))){
                Set<Id> idsToDelete = new Set<Id>();
                for(MFS_Activity360GeneralUtility.wrapperClass wc:ProductWrapperListForCA){
                    if(wc.wProduct.id == individualChildRecordId){
                        List<Competitor_Product__c> tempLstCP;
                        for(Competitor_Product__c cp: wc.lstCompProd){
                            if(cp.id == selectedCompProduct){
                                if(compRequest.id != NULL){
                                    idsToDelete.add(cp.Id);
                                    }  
                            }else {
                                if(tempLstCP == NULL){
                                    tempLstCP = new List<Competitor_Product__c> ();
                                }
                                tempLstCP.add(cp); 
                            }
                        }
                        wc.lstCompProd = tempLstCP;
                        
                    }
                }
                if(compRequest.id != NULL && idsToDelete.size() >0 ){
                    delete [select id from Competitive_Analysis_Product__c where Competitive_Analysis_Request__c = : compRequest.id and  
                            Product__c = : individualChildRecordId and Competitor_Product__c IN :idsToDelete LIMIT 1];
                }
            } 
        }catch(Exception ex){
            system.debug('Exception in removeCompProductForCA : '+ex.getStackTraceString());
            throw ex;
        }
    } 
    
    /*
** Method Name     : removingProductForCA
** Description     :  Method to delink the Competitor Product bundled under one product 
** Used in         : onclick of 'remove' button in Competitive Analysis PopUp screen (Activity360 page) 
*/         
    public static void removingProductForCA(List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperListForCA, String individualChildRecordId,Competitive_Analysis_Request__c compRequest)
    {
        try{
            if(!ProductWrapperListForCA.isEmpty() &&(individualChildRecordId!=null && !string.isBlank(individualChildRecordId))){
                List<MFS_Activity360GeneralUtility.wrapperClass> tempWC = new List<MFS_Activity360GeneralUtility.wrapperClass>();
                for(MFS_Activity360GeneralUtility.wrapperClass wc:ProductWrapperListForCA){
                    if(wc.wProduct.id == individualChildRecordId){
                        if(wc.lstCompProd != NULL){
                            wc.lstCompProd.clear();
                        }
                    }else{
                        tempWC.add(wc);
                    }
                }
                if(compRequest.id != NULL){
                    delete [select id from Competitive_Analysis_Product__c  where Competitive_Analysis_Request__c = : compRequest.id and  
                            Product__c = : individualChildRecordId ];
                }
                ProductWrapperListForCA.clear();
                ProductWrapperListForCA.addAll(tempWC);
            }
        }catch(Exception ex){
            system.debug('Exception in removingProductForCA : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Get DC team queue ID
    public static ID getQueueIdForDCTeam (){
        if(queueIdForDCTeam == NULL){
            for(QueueSObject que: [select id, QueueId, Queue.Name, SObjectType from QueueSObject  where SObjectType=:  MFS_AllConstants.SOBJECT_NAME_FOR_COMPETITIVE_ANALYSIS_REQUEST and 
                                   Queue.Name = :System.Label.A360_DC_Queue_for_Competitive_Analysis_Request]){
                                       return que.QueueId;  
                                   }
        }else{
            return queueIdForDCTeam;
        }
        return NULL;
    }
    
    public static ID getQueueIdForCompTeam (){
        if(queueIdForCompTeam == NULL){
            for(QueueSObject que: [select id, QueueId, Queue.Name, SObjectType from QueueSObject 
                                   where SObjectType=:  MFS_AllConstants.SOBJECT_NAME_FOR_COMPETITIVE_ANALYSIS_REQUEST and Queue.Name = :System.Label.A360_Queue_for_Competitive_Analysis_Request]){
                                       return que.QueueId;  
                                   }
        }else{
            return queueIdForCompTeam;
        }
        return NULL;
    }    
    /*
** Method Name     : changeTypeOfCompAnalysis
** Description     :  Method to update the Owner of Comp. Request based on  
** Used in         : onchange of Type Picklist field
*/  
    
    public static void changeTypeOfCompAnalysis(Competitive_Analysis_Request__c compRequest){
        try{    
            if((compRequest.Type__c == 'FI360') || (compRequest.Type__c =='Fee Benchmarker') || (compRequest.Type__c =='Morningstar Target Data Analyzer') || (compRequest.Type__c =='Morningstar (Plan Status and Plan Comparison)') || (compRequest.Type__c =='Brightscope')){
                compRequest.OwnerId = getQueueIdForDCTeam();
            }else{
                compRequest.OwnerId = getQueueIdForCompTeam();
            }
        }catch(Exception ex){
            system.debug('Exception in changeTypeOfCompAnalysis : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    
    /*
** Method Name     : checkRequestCompAnalysis
** Description     :  Method to update the Owner of Comp. Request based on  
** Used in         : onchange of Request Report checkbox
*/  
    
    public static void checkRequestCompAnalysis(Competitive_Analysis_Request__c compRequest){
        try{
            if(compRequest.Request_Report__c){
                changeTypeOfCompAnalysis(compRequest);
            }else{
                if(compRequest.id == NULL){
                    compRequest.OwnerId = UserInfo.getUserId();
                }else{
                    compRequest.OwnerId = compRequest.CreatedById;
                }
            }
        }catch(Exception ex){
            system.debug('Exception in checkRequestCompAnalysis : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    /*
** Method Name     : saveCompAnalysis
** Description     :  Method to Save the Competitive Analysis Request and while creating , link the Competitor Products to request 
** Used in         : onclick of Save button in Competitive Analysis PopUp screen (Activity360 page) 
*/  
    public static void saveCompAnalysis(Boolean taskCallNote,Task parentTask,Event parentEvent, RecordType oRecTypeActivity, List<MFS_Activity360GeneralUtility.wrapperClass> taskWrapperList,Activity_Detail__c callNote,List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperListForCA,List<MFS_Activity360GeneralUtility.wrapperClass> CompAnalysisWrapperList, Competitive_Analysis_Request__c compRequest)
    {
        try{
            if(callNote.Id!=null){
                if(compRequest.Id!=null){
                    upsert compRequest;
                    compRequest = [select id,Name, Call_Note__c,Ownerid,Owner.Name,  Contact__c,Contact__r.Name, Status__c, Type__c,Description__c, CreatedBy.Name, CreatedDate,  Notify__c, Completed_Date__c,Request_completed_in_days__c , Notes__c, Request_Report__c  from Competitive_Analysis_Request__c where id = :compRequest.id];
                    
                    //update the wrapper with edited field values
                    for(MFS_Activity360GeneralUtility.wrapperClass wc: CompAnalysisWrapperList){
                        if(wc.wCompAnalysisRequest.id == compRequest.id  ){
                            wc.wCompAnalysisRequest = compRequest;
                        }  
                    }
                }
                
                if(compRequest.Id==null){
                    compRequest.Call_Note__c = callNote.id;
                    if(!compRequest.Request_Report__c){
                        compRequest.Name = UserInfo.getLastName() + '-' + date.today().format();
                    }else{
                        /*****include this code if Competitive Analysis Request enabled for Institutional Activities
if(oRecTypeActivity.Name.containsIgnoreCase('Institutional')){
if(compRequest.Contact__c != NULL){
for(Contact con: [select lastname from Contact where id = : compRequest.Contact__c LIMIT 1]){
compRequest.Name = con.lastname + '-' + date.today().format() ;}   
}else{
compRequest.Name = date.today().format();
}
}else
*/
                        {
                            for(QueueSObject que:[select id, QueueId, Queue.Name, SObjectType from QueueSObject where Queueid =:compRequest.Ownerid LIMIT 1]){
                                compRequest.Name = que.Queue.Name +'-'+ date.today().format();
                            }
                        }
                    }
                    upsert compRequest;
                    //update wrapper
                    compRequest = [select id,Name, Call_Note__c,Ownerid,Owner.Name, Contact__c,Contact__r.Name, Status__c, Type__c,Description__c, CreatedBy.Name, CreatedDate,  Notify__c, Completed_Date__c,Request_completed_in_days__c , Notes__c,Request_Report__c  from Competitive_Analysis_Request__c where id = :compRequest.id];
                    MFS_Activity360GeneralUtility.wrapperClass cawc = new MFS_Activity360GeneralUtility.wrapperClass(compRequest,false);
                    CompAnalysisWrapperList.add(cawc);
                    Id i = (taskCallNote) ? parentTask.WhoId : parentEvent.WhoId;
                    if(oRecTypeActivity.Name.containsIgnoreCase(MFS_AllConstants.RETAIL_RECORDTYPE_SUBTEXT)   ){
                        MFS_Activity360GeneralUtility.automaticFollowUpTaskCreate('CAR', taskCallNote,parentEvent,parentTask,taskWrapperList,i, 7, MFS_AllConstants.TASK_PRIORITY_DEFAULT);
                    }
                }
                
                //Relate the Competitor Products associated
                List<Competitive_Analysis_Product__c> lstCAPjn = new List<Competitive_Analysis_Product__c>();
                Map<ID, Set<ID>> mProdIDvsLstCompId = new Map<ID, Set<ID>>();
                for(Competitive_Analysis_Product__c cap:
                    //Load the existing Competitor Products for Competitive Analysis Request
                    [select id,Product__c, Competitor_Product__c from Competitive_Analysis_Product__c where Competitive_Analysis_Request__c = :compRequest.id]){
                        if(mProdIDvsLstCompId.containsKey(cap.Product__c)){
                            (mProdIDvsLstCompId.get(cap.Product__c)).add(cap.Competitor_Product__c);
                        }else{
                            Set<ID> tempSet = new Set<ID>();  
                            tempSet.add(cap.Competitor_Product__c);
                            mProdIDvsLstCompId.put(cap.Product__c, tempSet);
                        }
                        
                    }
                for(MFS_Activity360GeneralUtility.WrapperClass wP: ProductWrapperListForCA){
                    if(wP.lstCompProd != NULL){
                        for (Competitor_Product__c cp: wP.lstCompProd){
                            if(!((mProdIDvsLstCompId.containsKey(wP.wProduct.id)) && 
                                 ((mProdIDvsLstCompId.get(wP.wProduct.id)).contains(cp.id)))) 
                                lstCAPjn.add(new Competitive_Analysis_Product__c(Product__c = wP.wProduct.id, 
                                                                                 Competitor_Product__c = cp.id,
                                                                                 Competitive_Analysis_Request__c = compRequest.id ));
                        }
                    }
                }
                
                if(!(lstCAPjn.isEmpty())){
                    insert lstCAPjn;
                }
            }
       }catch(Exception ex){
            system.debug('Exception in saveCompAnalysis : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    
    /*
** Method Name     : loadCompProductsToCARWrapper
** Description     :  Method to get the Competitor Products related to one Competitive Analysis Request and display it in the screen
** Used in         : onclick of Create/Edit or View from Competitive Analysis related list section (Activity360 page) 
*/      
    public static void loadCompProductsToCARWrapper(Competitive_Analysis_Request__c compRequest,List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperListForCA){
        try{
            ProductWrapperListForCA.clear();
            if(compRequest.id != NULL){
                
                Set<ID> compProdIdsCA = new Set<ID>();
                Map<ID, Set<ID>> mProdIDvsLstCompId = new Map<ID, Set<ID>>();
                
                //When Viewing existing Competitive Analysis Request, load the associated Products in related list
                for(Competitive_Analysis_Product__c cap: 
                    [select id, Product__c, Competitor_Product__c from Competitive_Analysis_Product__c where Competitive_Analysis_Request__c = : compRequest.id ] ){
                        //prodIdsCA.add(cap.Product__c); 
                        if(mProdIDvsLstCompId.containsKey(cap.Product__c)){
                            (mProdIDvsLstCompId.get(cap.Product__c)).add(cap.Competitor_Product__c);
                        }else{
                            Set<ID> tempSet = new Set<ID>();  
                            tempSet.add(cap.Competitor_Product__c);
                            mProdIDvsLstCompId.put(cap.Product__c, tempSet);
                        }
                        compProdIdsCA.add(cap.Competitor_Product__c);
                    }
                Map<ID, Product2> mProdtemp = new Map<ID, Product2>(
                    [select Name, IsActive, ProductCode, Family,Vehicle__c,Is_High_Interest_Product__c ,
                     (select id,High_Interest__c from Call_Note_Relationships__r where Call_Note__c = : compRequest.Call_Note__c  )
                     from Product2 where id in: mProdIDvsLstCompId.keyset()]);
                Map<ID, Competitor_Product__c> mCompProd2temp = new Map<ID, Competitor_Product__c>(
                    [select id, Name, Firm__c,Firm_Name__c from Competitor_Product__c where id in: compProdIdsCA]); //Firm_Name__c is added on 08/Feb/2017 to fix UAT defect
                
                for(Product2 cp: mProdtemp.values())
                {
                    MFS_Activity360GeneralUtility.wrapperClass tempWC = new MFS_Activity360GeneralUtility.wrapperClass();
                    tempWC.wProduct = cp;
                    tempWC.wCompAnalysisProdJn = new Competitive_Analysis_Product__c ();                        
                    for(Call_Note_Product__c cnp: cp.Call_Note_Relationships__r){  
                        tempWC.wActivityProdJuncObj = cnp;
                    }  
                    tempWC.lstCompProd = new List<Competitor_Product__c> ();
                    for(ID forCompId: mProdIDvsLstCompId.get(cp.id)){
                        tempWC.lstCompProd.add(mCompProd2temp.get(forCompId));
                    }
                    
                    ProductWrapperListForCA.add(tempWC);
                } 
            }
        }catch(Exception ex){
            system.debug('Exception in loadCompProductsToCARWrapper : '+ex.getStackTraceString());
            throw ex;
        }
    }  
    
    /*
** Method Name     : deleteCompAnalysisRecord
** Description     :  Method to delte the Competitive Analysis Request related to Activity
** Used in         : 'remove' hyperlink from Competitive Analysis related list section (Activity360 page) 
*/    
    public static void deleteCompAnalysisRecord(string individualChildRecordId, List<MFS_Activity360GeneralUtility.wrapperClass> CompAnalysisWrapperList ){
        List<MFS_Activity360GeneralUtility.wrapperClass> tempCompAnalysisTokeepList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        List<Competitive_Analysis_Request__c> tempCompAnalysisToDeleteList = new List<Competitive_Analysis_Request__c>();
        try{
            if(CompAnalysisWrapperList.size()>0 && individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                for(MFS_Activity360GeneralUtility.wrapperClass wc:CompAnalysisWrapperList){
                    if(wc.wCompAnalysisRequest.Id != individualChildRecordId){ tempCompAnalysisTokeepList.add(wc); }
                    if(wc.wCompAnalysisRequest.Id == individualChildRecordId){ tempCompAnalysisToDeleteList.add(wc.wCompAnalysisRequest); }
                }
                if(tempCompAnalysisToDeleteList.size()>0){ delete tempCompAnalysisToDeleteList; }
                CompAnalysisWrapperList.clear();
                CompAnalysisWrapperList.addAll(tempCompAnalysisTokeepList);
            }
            
            individualChildRecordId = null;
        }catch(Exception ex){
            system.debug('Exception in deleteCompAnalysisRecord : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    
    /*    
** Method Name     : postChatterWhenCompRequestCreated
** Description     :  Method to post chatter on related contact to notify the creation of comp. request to concerned User.
** Used in         : savecompAnalysis() method - while creating new comp.request  (Activity360 page) 
*/      
    public static void postChatterWhenCompRequestCreated(Competitive_Analysis_Request__c compRequest){
        try{
            if(compRequest.Contact__c != NULL && compRequest.Notify__c != NULL){
                String sChatterText = System.Label.A360_Chatter_Feed_for_Creation_of_New_Competitive_Analysis_Request;
                MFS_ChatterApiUtility.postChatterWithSingleTextSingleMentionAndSingleLink(compRequest.Notify__c, compRequest.Contact__c, sChatterText, compRequest.id);
            }
        }catch(Exception ex){
            system.debug('Exception in postChatterWhenCompRequestCreated : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    public static void postChatterWhenCompRequestCreated(Competitive_Analysis_Request__c compRequest, ID orgId , List<String> lstAdditionalIDs){
        try{
            if( !(lstAdditionalIDs.isEmpty())){
                List<ID> lstNotifierIDs = new List<ID>();
                for(String s: lstAdditionalIDs){
                    ID tempID;
                    try{
                        tempID = (ID)s; 
                    }catch(Exception e){}
                    if(tempID != NULL){
                        lstNotifierIDs.add(tempID);
                    }
                }
                
                String sChatterText = System.Label.A360_Chatter_Feed_for_Creation_of_New_Competitive_Analysis_Request;
                ID subjectId;
                if(compRequest.Contact__c == NULL){
                    subjectId = orgId  ;
                }else{
                    subjectId = compRequest.Contact__c;
                }
                MFS_ChatterApiUtility.postChatterWithSingleTextMultiMentionAndSingleLink(lstNotifierIDs,subjectId, sChatterText, compRequest.id);
            }
        }catch(Exception ex){
            system.debug('Exception in postChatterWhenCompRequestCreated : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    /*    
** Method Name     : initializeNotifierMultiSelection
** Description     :  Method to get the Coverage Team members of the related Contact and display in Multi-selection format
** Used in         : When creating new Competitive Analysis Request in Activity360 page
** parameters      : contid - Contact id, lstAvailableCompRequestNotifiers - Available Options , lstSelectedNotifiersForCA - selected Options
*/      
    public static void initializeNotifierMultiSelection(Id orgId,ID contid, List<SelectOption> lstAvailableCompRequestNotifiers, List<String> lstSelectedNotifiersForCA){
        try{
            if(contid == null && orgID != null && String.valueOf(orgID) != '')
            {
                for(AccountTeamMember atm: [select User.Name,  AccountId, TeamMemberRole from AccountTeamMember where AccountId =: orgId LIMIT 50000])
                {
                    lstAvailableCompRequestNotifiers.add(new SelectOption(atm.UserId, atm.TeamMemberRole + ': '+ atm.User.Name  ));
                    //Default the selection of 'Internal Wholesaler'
                    if(atm.TeamMemberRole.equalsignorecase(System.Label.A360_Default_Coverage_Team_Member_Role_To_Notify_Competitive_Request_Creation)){
                        lstSelectedNotifiersForCA.add(atm.UserId);
                    }
                }
                
            }
            else if(contid != null && String.valueOf(contid) != '' ) {
                for (Coverage_Team__c ct: [select Coverage_Owner__c,Coverage_Owner__r.Name,Coverage_Role__c from Coverage_Team__c where Contact__c =: contid LIMIT 50000]){
                    if(ct.Coverage_Owner__r.id != NULL){
                        lstAvailableCompRequestNotifiers.add(new SelectOption(ct.Coverage_Owner__r.id, ct.Coverage_Role__c + ': '+ ct.Coverage_Owner__r.Name   ));
                        //Default the selection of 'Internal Wholesaler'
                        if(ct.Coverage_Role__c.equalsignorecase(System.Label.A360_Default_Coverage_Team_Member_Role_To_Notify_Competitive_Request_Creation)){
                            lstSelectedNotifiersForCA.add(ct.Coverage_Owner__r.Id);
                        }  
                    }
                }
            }
        }catch(Exception ex){
            system.debug('Exception in initializeNotifierMultiSelection : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    
    /*    
** Method Name     : formJsonWithAvailableNotifiers
** Description     :  Method to get json format of the Available Multipicklist Options (left side)
** Used in         : Activity360 Lightning Page - Creation popup screen of Competitive Analysis Request
*/          
    public static String formJsonWithAvailableNotifiers(List<SelectOption> lstAvailableNotifiersForCA, List<String> lstSelectedNotifiersForCA){
        Set<String> setSelectedNotifiersForCA = new Set<String>(lstSelectedNotifiersForCA);
        List<MFS_Activity360GeneralUtility.wSelectOption> lstAvailableOptions = new List<MFS_Activity360GeneralUtility.wSelectOption>();
        try{
            for(SelectOption so: lstAvailableNotifiersForCA){
                if(!setSelectedNotifiersForCA.contains(so.getValue())){
                    MFS_Activity360GeneralUtility.wSelectOption wso = new MFS_Activity360GeneralUtility.wSelectOption( so.getValue(),so.getLabel());
                    lstAvailableOptions.add(wso);
                }
            }
        }catch(Exception ex){
            system.debug('Exception in formJsonWithAvailableNotifiers : '+ex.getStackTraceString());
            throw ex;
        }
        return json.serialize(lstAvailableOptions);
    }                                  
    
    
    /*    
** Method Name     : formJsonWithSelectedNotifiers
** Description     :  Method to get json format of the selected Multipicklist Options (right side)
** Used in         : Activity360 Lightning Page - Creation popup screen of Competitive Analysis Request
*/   
    public static String formJsonWithSelectedNotifiers(List<SelectOption> lstAvailableNotifiersForCA, List<String> lstSelectedNotifiersForCA ){
        Set<String> setSelectedNotifiersForCA = new Set<String>(lstSelectedNotifiersForCA);
        List<MFS_Activity360GeneralUtility.wSelectOption> lstSelectedOptions = new List<MFS_Activity360GeneralUtility.wSelectOption>();
        for(SelectOption so: lstAvailableNotifiersForCA){
            if(setSelectedNotifiersForCA.contains(so.getValue()))
            {
                MFS_Activity360GeneralUtility.wSelectOption wso = new MFS_Activity360GeneralUtility.wSelectOption( so.getValue(),so.getLabel());
                lstSelectedOptions.add(wso);
            }
        }
        return json.serialize(lstSelectedOptions);
    }
    
    
}