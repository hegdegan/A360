/*
Apex class           :  MFS_MeetingMaterialRequestUtility
Version               :  1.0
Created Date          :  16 SEP 2016
Function              :  This Utility class contains all methods related to Meeting Material Request Related List in Activity360

Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                
* Ganesh Hegde            16 SEP 2016              Initial Version
Ganesh Hegde       19 SEP 2016         Modified SaveMMR(), Added methods - addMMRPortfolios(), removeMMRPortfolios(), addLanguageFields().
*/
public with sharing class MFS_MeetingMaterialRequestUtility {
    
    private static FINAL String MATERIAL_TYPE = 'Webcast';
    private static FINAL String SYNTAX = 'US English';
    private static FINAL String STATUS = 'Requested';
    private static FINAL String YES = 'Yes';
    private static FINAL String HARD_COPY_REQUIRED = 'Yes: Hardcopy required';
    private static FINAL String PERFORMANCE_PERIOD = 'QTD;YTD;1 Year;3 Years;5 Years;10 Years;Since Client Inception';
    private static FINAL String INTRO_TRANSITION_CALL ='Introductory Transition Call';
    Private static FINAL String GLOBALCONSULTANTRELATIONS = 'Global Consultant Relations';
    private static FINAL String TIME_PERIOD_COVERED = '';
    private static Final String DEFAULT_PLS_UPDATE_IF_CUSTOM = 'Default - Please update if custom';
    private static Final String MATERIAL_TYPE_CONSULTANT = 'Consultant';
    private static Final String MATERIAL_TYPE_CRP_ONLY= 'CRP Only';
    private static Final String MATERIAL_TYPE_PRP_ONLY = 'PRP Only';
    private static Final String MATERIAL_TYPE_SALES = 'Generic/Sales';
    private static Final String MATERIAL_TYPE_MRQ = 'Most Recent Quarter';
        
    Public static Boolean isGlobalConsultantRelations = false;
    
    //Kosko
    //Query the values when the page gets loaded
    //Overloaded goToMMR method to include the Time_Periods_Covered__c field instead of Please_Enter_the_Desired_Time_Range__c
    public static void goToMMR(Activity_Detail__c callNote, List<MFS_Activity360GeneralUtility.wrapperClass> MMRWrapperList, List<MMR_Client_Investment_Association__c> portfolioLst,
                               Map<String, List<MMR_Client_Investment_Association__c>> portfolioMap, String timePeriodsCoverd)
    {
        Set<String> mmrIds = new Set<String>();
        //construct a wraper for all line items
        try{
            for(Meeting_Material_Request__c mmr: [select id,Name,Material_Name__c,Material_Type__c,Requested_Date__c,Call_Note__c, Client_Prospect_Name__c, Date_due_to_Client__c,
                                                  portfolio__c,Data_Time_period__c, Sector_Scheme__c, Benchmark__c, Use_CRP__c,Meeting_Room_Needed__c, Translation_Required__c, 
                                                  toLabel(Translation_Languages__c), Syntax__c, Background__c,delivery_method__c,Government_Entity__c ,Additional_Comments__c, Do_materials_need_to_be_printed__c, 
                                                  Data_as_of_End_Month__c, Data_as_of_End_Year__c, Start__c, End__c, Location__c, Overview_Section__c, Status__c, Cover_Page_Title__c, Team_Members__c, Since_Inception_Date__c,
                                                  Agreement_Finalized_Date__c, Account_Estimate_Funding_Date__c, toLabel(Time_Periods_Covered__c),Presenters__c,Number_of_Copies_for_Each_Language__c,
                                                  toLabel(Performance_Period__c),toLabel(Attribution_Period__c) from Meeting_Material_Request__c where Call_Note__c = :callNote.Id])
            {
                mmrIds.add(mmr.id);
                MMRWrapperList.add(new MFS_Activity360GeneralUtility.wrapperClass(mmr,false));
            }
            if(!MMRWrapperList.isEmpty())
            { 
                //Get MMR Portfolio related list items
                List<MMR_Client_Investment_Association__c> MMRPortLst = new List<MMR_Client_Investment_Association__c>
                    ([select id,Meeting_Material_Request__c, Portfolio__c, Portfolio__r.Name, Portfolio__r.Portfolio_Start_Date__c, Portfolio__r.Portfolio_Code__c from MMR_Client_Investment_Association__c where 
                      Meeting_Material_Request__c in :mmrIds]);
                //associate Related list to MMR record
                for(String mmrId : mmrIds)
                {
                    portFolioLst = new List<MMR_Client_Investment_Association__c>();
                    for(MMR_Client_Investment_Association__c portf : MMRPortLst)
                    {
                        if(mmrId == portf.Meeting_Material_Request__c){
                            portFolioLst.add(portf);
                        }
                    }
                    portfolioMap.put(mmrId, portFolioLst);
                }
            } 
        }
        catch(Exception ex){
            system.debug('Exception in goToMMR : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Kosko
    //Meeting Material Request
    //Overloaded with String whatName to Carry out Time Periods field
    //Assign the values and create wrapper while opening MMR modal window
    public static void showMMRPopup(Meeting_Material_Request__c MMR,  List<MFS_Activity360GeneralUtility.WrapperClass> MMRPortfolioWrapperList, List<MFS_Activity360GeneralUtility.wrapperClass> ProductWrapperList, Event parentEvent, Boolean editMMROrgName,
                                    String startDateTime, String endDateTime,  List<MFS_Activity360GeneralUtility.WrapperClass> languageFields,
                                    Map<Id,MFS_EventInviteeUtility.InviteeWrapper> inviteesMap, String whatName)
    {
        try{
            MMRPortfolioWrapperList.clear();
            Integer rowNum = 0;
                        
            for(MFS_Activity360GeneralUtility.wrapperClass prodWc : ProductWrapperList)
            {
                MMRPortfolioWrapperList.add(new MFS_Activity360GeneralUtility.wrapperClass(prodWc.wProduct, prodWc.wProduct.Name, prodWc.wProduct.Portfolio_Code__c,prodWc.wProduct.Portfolio_Start_Date__c, false, false, rowNUm));
                rowNum++;
            }
            //set default values
            Id parentEventWId = parentEvent.whatId;
            Id pEventWhatId = parentEvent.whatId;
            if(pEventWhatId != null && pEventWhatId.getSobjectType().getDescribe().getName()=='Campaign')
            { 
                MMR.Material_Type__c = MATERIAL_TYPE;
            }
            if(pEventWhatId != null && pEventWhatId.getSobjectType().getDescribe().getName()=='Account')
            { 
                Account acc = [select name from Account where id = :pEventWhatId];
                MMR.Cover_Page_Title__c = acc.Name;
                MMR.Client_Prospect_Name__c = pEventWhatId;
            }
            if(parentEvent != null && parentEvent.WhatId != null && parentEvent.WhatId.getSobjectType().getDescribe().getName()=='Account') {
                Account acc = [select name from Account where id = :pEventWhatId];
                MMR.Cover_Page_Title__c = acc.Name;
                MMR.Client_Prospect_Name__c = pEventWhatId;
            }
            fetchPresenters(MMR, parentEvent, inviteesMap);
            languageFields.clear();
            MMR.Syntax__c = SYNTAX;
            MMR.Status__c = STATUS;
            MMR.Meeting_Room_Needed__c = YES;
            MMR.Do_materials_need_to_be_printed__c = HARD_COPY_REQUIRED;
            MMR.Benchmark__c = DEFAULT_PLS_UPDATE_IF_CUSTOM;
            if(UserInfo.getLanguage() != MFS_AllConstants.USER_DEFAULT_LANGUAGE){
                List<String> valuesList = new List<String>();
                if(!String.isEmpty(PERFORMANCE_PERIOD)){
                    valuesList = PERFORMANCE_PERIOD.split(';');
                    for(String val : valuesList){
                        if(MMR.Performance_Period__c == NULL)
                            MMR.Performance_Period__c = MFS_AllConstants.MMR_PERFORMANCE_PERIOD_VALUES.get(val);
                        else
                            MMR.Performance_Period__c += ';'+MFS_AllConstants.MMR_PERFORMANCE_PERIOD_VALUES.get(val);
                    }
                }
            }
            else{
                MMR.Performance_Period__c = PERFORMANCE_PERIOD;
            }
            //Added for Time Periods Covered
            if(UserInfo.getLanguage() != MFS_AllConstants.USER_DEFAULT_LANGUAGE){
                List<String> valuesList = new List<String>();
                if(!String.isEmpty(TIME_PERIOD_COVERED)){
                    valuesList = TIME_PERIOD_COVERED.split(';');
                    for(String val : valuesList){
                        if(MMR.Time_Periods_Covered__c == NULL)
                            MMR.Time_Periods_Covered__c = MFS_AllConstants.MMR_TIME_PERIOD_COVERED_VALUES.get(val);
                        else
                            MMR.Time_Periods_Covered__c += ';'+MFS_AllConstants.MMR_TIME_PERIOD_COVERED_VALUES.get(val);
                    }
                }
            }
            else{
                MMR.Time_Periods_Covered__c = TIME_PERIOD_COVERED;
            }
            languageFields.add(new MFS_Activity360GeneralUtility.WrapperClass(Label.A360_English, '0'));
            MMR.Location__c = parentEvent.Location;
            MMR.Requested_Date__c = System.Today();
            MMR.Start__c = String.isEmpty(startDateTime) || startDateTime== 'None' ? MFS_Activity360GeneralUtility.dateTimeConcat(parentEvent.Event_Start_Date__c,'12:00 AM') : MFS_Activity360GeneralUtility.dateTimeConcat(parentEvent.Event_Start_Date__c,startDateTime);
            MMR.End__c = String.isEmpty(endDateTime) || endDateTime== 'None'? MFS_Activity360GeneralUtility.dateTimeConcat(parentEvent.Event_End_Date__c,'12:00 AM') : MFS_Activity360GeneralUtility.dateTimeConcat(parentEvent.Event_End_Date__c,endDateTime);
            
        } catch(Exception ex){
            system.debug('Exception in showMMRPopup : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
	//Kosko    
    //Save MMR record when hit on "Save" on modal window
    //Overloaded saveMMr method to include Time_Periods_Covered__c multipicklist
    public static void saveMMR(Meeting_Material_Request__c MMR, List<MFS_Activity360GeneralUtility.wrapperClass> MMRWrapperList, Map<String, List<MMR_Client_Investment_Association__c>> portfolioMap,
                               List<MFS_Activity360GeneralUtility.WrapperClass> MMRPortfolioWrapperList, Activity_Detail__c callNote, List<MMR_Client_Investment_Association__c> portfolioLst,Set<Id> portfolioSetToRemove,
                               List<MFS_Activity360GeneralUtility.WrapperClass> languageFields, String Time_Periods_Covered_temp)
    {
        try{
            if(callNote.Id!=null){
                if(MMR.Id!=null){
                    MMR.Number_of_Copies_for_Each_Language__c = null;
                    for(MFS_Activity360GeneralUtility.WrapperClass wc : languageFields){
                        if(MMR.Number_of_Copies_for_Each_Language__c == null)
                            MMR.Number_of_Copies_for_Each_Language__c = wc.labelName+':'+wc.fieldValue;
                        else
                            MMR.Number_of_Copies_for_Each_Language__c = MMR.Number_of_Copies_for_Each_Language__c+';'+wc.labelName+':'+wc.fieldValue;
                    }
                    if(MMR.Team_Members__c != INTRO_TRANSITION_CALL)
                        MMR.Team_Members__c = '';
                    
                    if(UserInfo.getLanguage() != MFS_AllConstants.USER_DEFAULT_LANGUAGE){
                        List<String> valuesList = new List<String>();
                        if(!String.isEmpty(MMR.Translation_Languages__c)){
                            valuesList = MMR.Translation_Languages__c.split(';');
                            MMR.Translation_Languages__c = NULL;
                            for(String val : valuesList){
                                if(MMR.Translation_Languages__c == NULL)
                                    MMR.Translation_Languages__c = MFS_AllConstants.MMR_TRANSLATION_LANGUAGES_LABELS.get(val);
                                else
                                    MMR.Translation_Languages__c += ';'+MFS_AllConstants.MMR_TRANSLATION_LANGUAGES_LABELS.get(val);
                            }
                        }
                        valuesList = new List<String>();
                        if(!String.isEmpty(MMR.Performance_Period__c)){
                            valuesList = MMR.Performance_Period__c.split(';');
                            MMR.Performance_Period__c = NULL;
                            for(String val : valuesList){
                                if(MMR.Performance_Period__c == NULL)
                                    MMR.Performance_Period__c = MFS_AllConstants.MMR_PERFORMANCE_PERIOD_LABELS.get(val);
                                else
                                    MMR.Performance_Period__c += ';'+MFS_AllConstants.MMR_PERFORMANCE_PERIOD_LABELS.get(val);
                            }
                        }
                        valuesList = new List<String>();
                        if(!String.isEmpty(MMR.Attribution_Period__c)){
                            valuesList = MMR.Attribution_Period__c.split(';');
                            MMR.Attribution_Period__c = NULL;
                            for(String val : valuesList){
                                if(MMR.Attribution_Period__c == NULL)
                                    MMR.Attribution_Period__c = MFS_AllConstants.MMR_ATTRIBUTION_PERIOD_LABELS.get(val);
                                else
                                    MMR.Attribution_Period__c += ';'+MFS_AllConstants.MMR_ATTRIBUTION_PERIOD_LABELS.get(val);
                            }
                        }
                        //Including Time_Periods_Covered_temp
                        valuesList = new List<String>();
                        if(!String.isEmpty(MMR.Time_Periods_Covered__c)){
                            valuesList = MMR.Time_Periods_Covered__c.split(';');
                            MMR.Time_Periods_Covered__c = NULL;
                            for(String val : valuesList){
                                if(MMR.Time_Periods_Covered__c == NULL)
                                    MMR.Time_Periods_Covered__c = MFS_AllConstants.MMR_TIME_PERIOD_COVERED_LABELS.get(val);
                                else
                                    MMR.Time_Periods_Covered__c += ';'+MFS_AllConstants.MMR_TIME_PERIOD_COVERED_LABELS.get(val);
                            }
                        }
                    }
                    upsert MMR;
                    List<MMR_Client_Investment_Association__c> mmrPortJnList = new List<MMR_Client_Investment_Association__c>();
                    //Delete the portfolios which are removed from the page
                    if(portfolioMap != null && portfolioMap.get(MMR.ID)!= null)
                    {
                        for(MMR_Client_Investment_Association__c portf : portfolioMap.get(MMR.ID) ){
                            if(portfolioSetToRemove.contains(portf.portfolio__c) ){
                                mmrPortJnList.add(portf);
                            }
                        }
                    }
                    delete mmrPortJnList;
                    portfolioSetToRemove.clear();
                    mmrPortJnList.clear();
                    for(MFS_Activity360GeneralUtility.WrapperClass wc : MMRPortfolioWrapperList){
                        if(wc.isNew){
                            MMR_Client_Investment_Association__c mmrPortJn = new MMR_Client_Investment_Association__c(Name = MMR.Name, Meeting_Material_Request__c = MMR.id, Portfolio__c = wc.mmrPortfolio.Id );
                            mmrPortJnList.add(mmrPortJn);
                        }
                    }
                    insert mmrPortJnList;
                    
                    portFolioLst = new List<MMR_Client_Investment_Association__c>();
                    //Construct MMR portfolio map with MMR record id as Map Key
                    for(MMR_Client_Investment_Association__c portf : [select id, Meeting_Material_Request__c, Portfolio__c, Portfolio__r.Name, Portfolio__r.Portfolio_Start_Date__c, Portfolio__r.Portfolio_Code__c from MMR_Client_Investment_Association__c where Meeting_Material_Request__c = :MMR.id])
                    {
                        portFolioLst.add(portf);
                    }
                    portfolioMap.put(MMR.Id, portFolioLst);
                }
                
                //Creation of MMR record
                if(MMR.Id==null){
                    MMR.Call_Note__c = callNote.Id;
                    for(MFS_Activity360GeneralUtility.WrapperClass wc : languageFields){
                        if(MMR.Number_of_Copies_for_Each_Language__c == null)
                            MMR.Number_of_Copies_for_Each_Language__c = wc.labelName+':'+wc.fieldValue;
                        else
                            MMR.Number_of_Copies_for_Each_Language__c = MMR.Number_of_Copies_for_Each_Language__c+';'+wc.labelName+':'+wc.fieldValue;
                    }
                    if(MMR.Team_Members__c != INTRO_TRANSITION_CALL)
                        MMR.Team_Members__c = '';
                    System.debug('TransLang'+MMR.Translation_Languages__c);
                    System.debug('PP'+MMR.Performance_Period__c);
                    System.debug('AP'+MMR.Attribution_Period__c);
                    if(UserInfo.getLanguage() != MFS_AllConstants.USER_DEFAULT_LANGUAGE){
                        List<String> valuesList = new List<String>();
                        if(!String.isEmpty(MMR.Translation_Languages__c)){
                            valuesList = MMR.Translation_Languages__c.split(';');
                            MMR.Translation_Languages__c = NULL;
                            for(String val : valuesList){
                                if(MMR.Translation_Languages__c == NULL)
                                    MMR.Translation_Languages__c = MFS_AllConstants.MMR_TRANSLATION_LANGUAGES_LABELS.get(val);
                                else
                                    MMR.Translation_Languages__c += ';'+MFS_AllConstants.MMR_TRANSLATION_LANGUAGES_LABELS.get(val);
                            }
                        }
                        valuesList = new List<String>();
                        if(!String.isEmpty(MMR.Performance_Period__c)){
                            valuesList = MMR.Performance_Period__c.split(';');
                            MMR.Performance_Period__c = NULL;
                            for(String val : valuesList){
                                if(MMR.Performance_Period__c == NULL)
                                    MMR.Performance_Period__c = MFS_AllConstants.MMR_PERFORMANCE_PERIOD_LABELS.get(val);
                                else
                                    MMR.Performance_Period__c += ';'+MFS_AllConstants.MMR_PERFORMANCE_PERIOD_LABELS.get(val);
                            }
                        }
                        valuesList = new List<String>();
                        if(!String.isEmpty(MMR.Attribution_Period__c)){
                            valuesList = MMR.Attribution_Period__c.split(';');
                            MMR.Attribution_Period__c = NULL;
                            for(String val : valuesList){
                                if(MMR.Attribution_Period__c == NULL)
                                    MMR.Attribution_Period__c = MFS_AllConstants.MMR_ATTRIBUTION_PERIOD_LABELS.get(val);
                                else
                                    MMR.Attribution_Period__c += ';'+MFS_AllConstants.MMR_ATTRIBUTION_PERIOD_LABELS.get(val);
                            }
                        }
                    }
                    upsert MMR;
                    
                    List<MMR_Client_Investment_Association__c> mmrPortJnList = new List<MMR_Client_Investment_Association__c>();
                    for(MFS_Activity360GeneralUtility.WrapperClass wc : MMRPortfolioWrapperList)
                    {
                        MMR_Client_Investment_Association__c mmrPortJn = new MMR_Client_Investment_Association__c(Name = MMR.Name, Meeting_Material_Request__c = MMR.Id, Portfolio__c = wc.mmrPortfolio.Id  );
                        mmrPortJnList.add(mmrPortJn);
                        
                    }
                    insert mmrPortJnList;
                    portFolioLst = new List<MMR_Client_Investment_Association__c>();
                    for(MMR_Client_Investment_Association__c portf : [select id,Meeting_Material_Request__c, Portfolio__c, Portfolio__r.Name,Portfolio__r.Portfolio_Start_Date__c, Portfolio__r.Portfolio_Code__c from MMR_Client_Investment_Association__c where Meeting_Material_Request__c = :MMR.id])
                    {
                        portFolioLst.add(portf);
                    }
                    portfolioMap.put(MMR.Id, portFolioLst);
                    
                    MFS_Activity360GeneralUtility.wrapperClass mmrwc = new MFS_Activity360GeneralUtility.wrapperClass(MMR,false);
                    MMRWrapperList.add(mmrwc);
                }
                
            }
            
            /* if parent event is not saved already then just add the MMR records in memory and also check if the record has already been added
in the memory or adding a new record by looping through the MMRWrapperList and checking for the matching record */
            else{
                if(MMR.Id==null){
                    boolean existing = false;
                    
                    for(MFS_Activity360GeneralUtility.wrapperClass mw:MMRWrapperList){
                        if(mw.wMMR == MMR){ existing = true; }
                    }
                    if(!existing){
                        MFS_Activity360GeneralUtility.wrapperClass mmrwc = new MFS_Activity360GeneralUtility.wrapperClass(MMR,false);
                        MMRWrapperList.add(mmrwc);
                    }
                }
            }
        } catch(Exception ex){
            system.debug('Exception in saveMMR : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    /*
** Method Name     : deleteMMRRecord
** Description     :  Method to remove the Meeting Material Request.
** Used in       : 'remove' hyperlink in Material Material Request related list (Activity360 page)
*/
    public static void deleteMMRRecord(string individualChildRecordId, List<MFS_Activity360GeneralUtility.wrapperClass> MMRWrapperList, Activity_Detail__c callNote, Boolean showAllRelatedSection)
    {
        List<MFS_Activity360GeneralUtility.wrapperClass> tempMMRTokeepList = new List<MFS_Activity360GeneralUtility.wrapperClass>();
        List<Meeting_Material_Request__c> tempMMRToDeleteList = new List<Meeting_Material_Request__c>();
        try{            
            if(MMRWrapperList.size()>0 && individualChildRecordId!=null && !string.isBlank(individualChildRecordId)){
                
                if(showAllRelatedSection){
                    for(MFS_Activity360GeneralUtility.wrapperClass wc:MMRWrapperList){
                        if(wc.wMMR.Id != individualChildRecordId){ tempMMRTokeepList.add(wc); }
                        if(wc.wMMR.Id == individualChildRecordId){ tempMMRToDeleteList.add(wc.wMMR); }
                    }  
                }
                if(!showAllRelatedSection){
                    for(MFS_Activity360GeneralUtility.wrapperClass wc:MMRWrapperList){
                        if(wc.wMMR.Name != individualChildRecordId){ tempMMRTokeepList.add(wc); }
                        if(wc.wMMR.Name == individualChildRecordId){ tempMMRToDeleteList.add(wc.wMMR); }
                    }  
                }
                
                /* Delete only if already the parent event exsists as there is need to add the meeting material request in just the memory 
for the first time when we are creating the parent event which is not saved until global save is hit */
                if(callNote.Id!=null){
                    if(tempMMRToDeleteList.size()>0){ delete tempMMRToDeleteList; }
                }
                MMRWrapperList.clear();
                MMRWrapperList.addAll(tempMMRTokeepList);
            }
        }
        catch(Exception ex){
            system.debug('Exception in deleteMMRRecord : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Add portfolios to MMR through lookup
    public static void addMMRPortfolios(Meeting_Material_Request__c MMR, List<MFS_Activity360GeneralUtility.WrapperClass> MMRPortfolioWrapperList)
    {
        try{
            Product2 prod = [select id, name, Portfolio_Start_Date__c, Portfolio_Code__c from Product2 where id=:MMR.Portfolio__c];
            Boolean skipProduct = false;
            for(MFS_Activity360GeneralUtility.WrapperClass wc : MMRPortfolioWrapperList){
                if(wc.mmrportfolio.Id == prod.Id)
                    skipProduct = true;
            }
            if(!skipProduct)
                MMRPortfolioWrapperList.add(new MFS_Activity360GeneralUtility.WrapperClass(prod, prod.Name, prod.Portfolio_Code__c, prod.Portfolio_Start_Date__c, false,true,MMRPortfolioWrapperList.size()));
            MMR.Portfolio__c = null;
        } catch(Exception ex){
            system.debug('Exception in addMMRPortfolios : '+ex.getStackTraceString());
            throw ex;
        }
    }
    //Remove portfolios from MMR related list.
    public static void removeMMRPortfolios(List<MFS_Activity360GeneralUtility.WrapperClass> MMRPortfolioWrapperList, String rmMMRPortfRow, Set<Id> portfolioSetToRemove )
    {
        try{
            MFS_Activity360GeneralUtility.WrapperClass tempWc = MMRPortfolioWrapperList.remove(Integer.ValueOf(rmMMRPortfRow));
            portfolioSetToRemove.add(tempWc.mmrPortfolio.Id);
            List<MFS_Activity360GeneralUtility.WrapperClass> MMRPorfTempLst = new List<MFS_Activity360GeneralUtility.WrapperClass>();
            Integer rowNum = 0;
            for(MFS_Activity360GeneralUtility.WrapperClass wc : MMRPortfolioWrapperList){
                wc.rowNum = rowNum;
                MMRPorfTempLst.add(wc);
                rowNum = rowNum+1;
            }
            MMRPortfolioWrapperList = MMRPorfTempLst;
        } catch(Exception ex){
            system.debug('Exception in removeMMRPortfolios : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Delete MMR portfolios individually 
    public static void removeSingleMMRClientInv(Meeting_Material_Request__c MMR, List<MFS_Activity360GeneralUtility.WrapperClass> MMRPortfolioWrapperList, String rmMMRPortfRow, Map<String, List<MMR_Client_Investment_Association__c>> portfolioMap)
    {
        try{
            MFS_Activity360GeneralUtility.WrapperClass tempWc = MMRPortfolioWrapperList.remove(Integer.ValueOf(rmMMRPortfRow));
            delete [select id from MMR_Client_Investment_Association__c where POrtfolio__c = :tempWc.mmrPortfolio.Id];
            List<MFS_Activity360GeneralUtility.WrapperClass> MMRPorfTempLst = new List<MFS_Activity360GeneralUtility.WrapperClass>();
            Integer rowNum = 0;
            for(MFS_Activity360GeneralUtility.WrapperClass wc : MMRPortfolioWrapperList){
                wc.rowNum = rowNum;
                MMRPorfTempLst.add(wc);
                rowNum = rowNum+1;
            }
            MMRPortfolioWrapperList = MMRPorfTempLst;
            portfolioMap.remove(MMR.id);
            List<MMR_Client_Investment_Association__c> MMRPortLst = new List<MMR_Client_Investment_Association__c>([select id,Meeting_Material_Request__c,
                                                                                                                    Portfolio__c, Portfolio__r.Name, Portfolio__r.Portfolio_Start_Date__c, Portfolio__r.Portfolio_Code__c from MMR_Client_Investment_Association__c where 
                                                                                                                    Meeting_Material_Request__c = : MMR.id]);
            List<MMR_Client_Investment_Association__c> portFolioLst = new List<MMR_Client_Investment_Association__c>();
            for(MMR_Client_Investment_Association__c portf : MMRPortLst){
                portFolioLst.add(portf);
            }
            portfolioMap.put(MMR.Id, portFolioLst);
        } catch(Exception ex){
            system.debug('Exception in removeSingleMMRClientInv : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Display language fields based on selected language
    public static void addLanguageFields(Meeting_Material_Request__c MMR, List<MFS_Activity360GeneralUtility.WrapperClass> languageFields)
    {
        Boolean isEnglishAdded = false;
        String englishValue = '0';
        try{
            if(!String.isEmpty(MMR.Translation_Languages__c)){
                List<String> tempList = new List<String>(MMR.Translation_Languages__c.split(';'));
                Set<String> selectedlang = new Set<String>(tempList);
                Set<String> tempLang = new Set<String>();
                Map <String, String> tempLangMap = new Map<String, String>();
                
                for(MFS_Activity360GeneralUtility.WrapperClass wc: languageFields ){
                    tempLangMap.put(wc.labelName, wc.fieldValue);
                    tempLang.add(wc.labelName);
                    if(wc.LabelName == Label.A360_English){
                        isEnglishAdded = true;
                        englishValue = wc.fieldValue;
                    }
                }
                languageFields.clear();
                if(isEnglishAdded){
                    languageFields.add(new MFS_Activity360GeneralUtility.WrapperClass(Label.A360_English,englishValue )); 
                }
                for(String selLang : selectedlang){
                    if(!tempLang.contains(selLang)){
                        languageFields.add(new MFS_Activity360GeneralUtility.WrapperClass(selLang, '0'));    
                    }
                    else{
                        languageFields.add(new MFS_Activity360GeneralUtility.WrapperClass(selLang, tempLangMap.get(selLang)));
                    }
                }
            }
            else
                languageFields.clear();
            if(MMR.Do_materials_need_to_be_printed__c == HARD_COPY_REQUIRED || MMR.Do_materials_need_to_be_printed__c == 'Both')
            {
                if(!isEnglishAdded)
                    languageFields.add(new MFS_Activity360GeneralUtility.WrapperClass(Label.A360_English, '0'));
            } 
        } catch(Exception ex){
            system.debug('Exception in addLanguageFields : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Display NUmber of hard copies required for English
    public static void addTransLanguage(Meeting_Material_Request__c MMR, List<MFS_Activity360GeneralUtility.WrapperClass> languageFields)
    {
        try{
            if(MMR.Do_materials_need_to_be_printed__c == HARD_COPY_REQUIRED || MMR.Do_materials_need_to_be_printed__c == 'Both')
            {
                Boolean isEnglishAdded = false;
                for(MFS_Activity360GeneralUtility.WrapperClass selLang : languageFields){
                    if(selLang.labelName==Label.A360_English)
                        isEnglishAdded = true;
                } 
                if(!isEnglishAdded)
                    languageFields.add(new MFS_Activity360GeneralUtility.WrapperClass(Label.A360_English, '0'));
            } 
            else{
                List<MFS_Activity360GeneralUtility.WrapperClass> tempLst = new List<MFS_Activity360GeneralUtility.WrapperClass>();
                for(MFS_Activity360GeneralUtility.WrapperClass selLang : languageFields){
                    if(selLang.labelName!=Label.A360_English)
                        tempLst.add(selLang);
                } 
                languageFields.clear();
                languageFields.addAll(tempLst);
            }
        } catch(Exception ex){
            system.debug('Exception in addTransLanguage : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Construct list with language fields selected
    public static void fetchLanguageFields(Meeting_Material_Request__c MMR, List<MFS_Activity360GeneralUtility.WrapperClass> languageFields)
    {
        try{
            //clear the language fields before constructing it from database value
            languageFields.clear();
            if(!String.isEmpty(MMR.Number_of_Copies_for_Each_Language__c)){
                List<String> tempList = new List<String>(MMR.Number_of_Copies_for_Each_Language__c.split(';'));
                Set<String> selectedlang = new Set<String>(tempList);
                
                for(String selLang : selectedlang){
                    String[] fieldValuePair = selLang.split(':');
                    languageFields.add(new MFS_Activity360GeneralUtility.WrapperClass(fieldValuePair[0], fieldValuePair[1]));     
                }
            }
        } catch(Exception ex){
            system.debug('Exception in fetchLanguageFields : '+ex.getStackTraceString());
            throw ex;
        }
    }
    //Wrapper list for MMR portfolios
    public static void constructMMRRelatedList(Meeting_Material_Request__c MMR, List<MFS_Activity360GeneralUtility.WrapperClass> languageFields, Map<String, List<MMR_Client_Investment_Association__c>> portfolioMap, List<MFS_Activity360GeneralUtility.WrapperClass> MMRPortfolioWrapperList)
    {
        try{
            MFS_MeetingMaterialRequestUtility.fetchLanguageFields(MMR, languageFields);
            MMRPortfolioWrapperList.clear();
            List<MMR_Client_Investment_Association__c> tempLst = PortfolioMap.get(MMR.id);
            if(tempLst !=null){
                Integer row = 0;
                for(MMR_Client_Investment_Association__c tempMMR : tempLst){
                    MMRPortfolioWrapperList.add(new MFS_Activity360GeneralUtility.WrapperClass
                                                (new Product2(Id= tempMMR.Portfolio__c), tempMMR.Portfolio__r.Name, tempMMR.Portfolio__r.Portfolio_Code__c,tempMMR.Portfolio__r.Portfolio_Start_Date__c, false, false, row));
                    row = row+1;
                }
            }
        } catch(Exception ex){
            system.debug('Exception in constructMMRRelatedList : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //get team members based on material type
    public static void fetchMMRTeamMembers(Meeting_Material_Request__c MMR)
    {
        try{
            MMR.Team_Members__c = null;
            if(MMR.Client_Prospect_Name__c!=null && MMR.Material_Type__c == INTRO_TRANSITION_CALL)
            {
                Account accCovTeam = [select id, (select user.Name from AccountTeamMembers) from Account where id=:MMR.Client_Prospect_Name__c];
                for(AccountTeamMember at : accCovTeam.AccountTeamMembers){
                    if(MMR.Team_Members__c==null)
                        MMR.Team_Members__c= at.User.Name;
                    else
                        MMR.Team_Members__c = MMR.Team_Members__c+', '+at.User.Name;
                }
            }
        } catch(Exception ex){
            system.debug('Exception in fetchMMRTeamMembers : '+ex.getStackTraceString());
            throw ex;
        } 
    }
    
    //Fetch ans sort the presenters based on last name
    public static void fetchPresenters(Meeting_Material_Request__c MMR,Event parentEvent, Map<Id,MFS_EventInviteeUtility.InviteeWrapper> inviteesMap)
    {
        try{
            MMR.Presenters__c = null;
            User lUser = [select Name from User where id = : parentEvent.OwnerId LIMIT 1];
            MMR.Presenters__c = lUser.Name;
            Set<Id> usrIds = new Set<Id>();
            for(MFS_EventInviteeUtility.InviteeWrapper inW : inviteesMap.values()){
                if(inW.evntRel.Host__c == false && inW.evntRel.Invitee_Type__c == 'User'){
                    usrIds.add(inW.evntRel.RelationId__c) ;  
                }
            }
            for(User usr : [select Name from User where id IN : usrIds ORDER BY LastName ASC]){
                if(MMR.Presenters__c==null)
                    MMR.Presenters__c = usr.Name;
                else
                    MMR.Presenters__c = MMR.Presenters__c+', '+usr.Name;
            }
        } catch(Exception ex){
            system.debug('Exception in fetchPresenters : '+ex.getStackTraceString());
            throw ex;
        }
    }
    
    //Logic for MMR name
    public static void constructMMRName(Meeting_Material_Request__c MMR)
    {
        String Name='';
        String stringDate = '';
        try{
            if(MMR.Date_Due_to_Client__c!=null)
                stringDate = MMR.Date_Due_to_Client__c.month()+'/'+MMR.Date_Due_to_Client__c.Day()+'/'+MMR.Date_Due_to_Client__c.year();
            if(String.isEmpty(MMR.Material_Type__c))
                name = stringDate;
            else if(MMR.Date_Due_to_Client__c == null)
                name = MMR.Material_Type__c;
            else
                name =  MMR.Material_Type__c +' - '+stringDate;
            MMR.Name = name;
            fetchMMRTeamMembers(MMR);
            
            MMR.Time_Periods_Covered__c = '';
            if(MMR.Material_Type__c == MATERIAL_TYPE_CONSULTANT || MMR.Material_Type__c == MATERIAL_TYPE_CRP_ONLY|| MMR.Material_Type__c == MATERIAL_TYPE_PRP_ONLY || MMR.Material_Type__c == MATERIAL_TYPE_SALES){
                MMR.Time_Periods_Covered__c = MATERIAL_TYPE_MRQ;
            }
            else {
            	MMR.Time_Periods_Covered__c = '';
            }
        } catch(Exception ex){
            system.debug('Exception in constructMMRName : '+ex.getStackTraceString());
            throw ex;
        }
    }
    //Get all the picklist values for the multiselect picklist Translation_Languages__c 
    public static String getAllLanguages(Meeting_Material_Request__c MMR){
        String options = '';
        Set<String> valuesFromSchema = new Set<String>();
        try{
            Schema.DescribeFieldResult fieldResult =Meeting_Material_Request__c.Translation_Languages__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                valuesFromSchema.add(f.getLabel());
            }
            Set<String> valuesToDisplay = new Set<String>(valuesFromSchema);
            
            if(!String.isEmpty(MMR.Translation_Languages__c)){
                List<String> tempList = new List<String>(MMR.Translation_Languages__c.split(';'));
                Set<String> selectedlang = new Set<String>(tempList);
                valuesToDisplay.clear();
                
                for(String schmaValue : valuesFromSchema){
                    if(!selectedLang.contains(schmaValue)) 
                        valuesToDisplay.add(schmaValue);
                }
            }
            for(String val : valuesToDisplay){
                if(String.isEmpty(options))
                    options = val;//MFS_AllConstants.MMR_TRANSLATION_LANGUAGES_VALUES.get(val);
                else
                    options = options+','+val;// MFS_AllConstants.MMR_TRANSLATION_LANGUAGES_VALUES.get(val);
            }
        } catch(Exception ex){
            system.debug('Exception in getAllLanguages : '+ex.getStackTraceString());
            throw ex;
        }
        return options;
    }
    
    //Get all the selected values for the multiselect picklist Translation_Languages__c
    public static String getSelectedLanguages(Meeting_Material_Request__c MMR){
        String options = '';
        Set<String> valuesToDisplay = new Set<String>();
        try{
            if(MMR!=null && !String.isEmpty(MMR.Translation_Languages__c)){
                List<String> tempList = new List<String>(MMR.Translation_Languages__c.split(';'));
                Set<String> selectedlang = new Set<String>(tempList);
                
                for(String schmaValue : selectedlang){
                    valuesToDisplay.add(schmaValue);
                }
            }
            for(String val : valuesToDisplay){
                if(String.isEmpty(options))
                    options = val;//MFS_AllConstants.MMR_TRANSLATION_LANGUAGES_VALUES.get(val);
                else
                    options = options+','+val;//MFS_AllConstants.MMR_TRANSLATION_LANGUAGES_VALUES.get(val);
            }
        } catch(Exception ex){
            system.debug('Exception in getSelectedLanguages : '+ex.getStackTraceString());
            throw ex;
        }
        return options; 
    }
    
    //Get all the picklist values for the multiselect picklist Performance_Period__c 
    public static String getLeftSideValues(String values, String label){
        String options = '';
        Set<String> valuesFromSchema = new Set<String>();
        Schema.DescribeFieldResult fieldResult;
        try{
            if(label == 'PerformancePeriod')
                fieldResult=Meeting_Material_Request__c.Performance_Period__c.getDescribe();
            if(label == 'AttrPeriod')
                fieldResult=Meeting_Material_Request__c.Attribution_Period__c.getDescribe();
            if(label == 'TimePeriodCovered')
                fieldResult=Meeting_Material_Request__c.Time_Periods_Covered__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                valuesFromSchema.add(f.getLabel());
            }
            
            Set<String> valuesToDisplay = new Set<String>(valuesFromSchema);
            if(!String.isEmpty(values)){
                List<String> tempList = new List<String>(values.split(';'));
                Set<String> selectedlang = new Set<String>(tempList);
                valuesToDisplay.clear();
                
                for(String schmaValue : valuesFromSchema){
                    if(!selectedLang.contains(schmaValue)) 
                        valuesToDisplay.add(schmaValue);
                }
            }
            for(String val : valuesToDisplay){
                if(label == 'PerformancePeriod'){
                    if(String.isEmpty(options))
                        options = val; //MFS_AllConstants.MMR_PERFORMANCE_PERIOD_VALUES.get(val);
                    else
                        options = options+','+val;//MFS_AllConstants.MMR_PERFORMANCE_PERIOD_VALUES.get(val);
                }
                else{
                    if(String.isEmpty(options))
                        options = val;//MFS_AllConstants.MMR_ATTRIBUTION_PERIOD_VALUES.get(val);
                    else
                        options = options+','+val;//MFS_AllConstants.MMR_ATTRIBUTION_PERIOD_VALUES.get(val);
                }
            }
        } catch(Exception ex){
            system.debug('Exception in getLeftSideValues : '+ex.getStackTraceString());
            throw ex;
        }
        return options;
    }
    
    //Get all the selected values for the multiselect picklist Performance_Period__c
    public static String getRightSideValues(String values){
        String options = '';
        Set<String> valuesToDisplay = new Set<String>();
        try{
            if(!String.isEmpty(values)){
                List<String> tempList = new List<String>(values.split(';'));
                Set<String> selectedlang = new Set<String>(tempList);
                
                for(String schmaValue : selectedlang){
                    valuesToDisplay.add(schmaValue);
                }
            }
            for(String val : valuesToDisplay){
                if(String.isEmpty(options))
                    options = val;
                else
                    options = options+','+val;
            }
        } catch(Exception ex){
            system.debug('Exception in getRightSideValues : '+ex.getStackTraceString());
            throw ex;
        }
        return options; 
    }
}