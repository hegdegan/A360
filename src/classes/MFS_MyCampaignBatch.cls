/***************************************************************************************************
Apex Class Name    : MFS_MyCampaignBatch 
Version            : 1.0 
Created Date       : 31 May 2016
Function           : Batch to insert campaign members.
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ganesh Hegde              05/31/2016              Original Version
***************************************************************************************************/
global class MFS_MyCampaignBatch implements Database.Batchable<SObject>, Database.Stateful{
    private static final String INSTITUTIONAL = 'Institutional';
    private static final String RETAIL = 'Retail';
    private static final String SYSADMIN = 'System Admin';
    private static final String CLIENT_SERVICE = 'Client Service';
    global string query;
    global List<CampaignMember> camMemberToAdd;
    global List<CampaignMember> camMemberToRemove;
    global Integer queryLimit;
    public MFS_MyCampaignBatch(){
        camMemberToAdd = new List<CampaignMember>();
        camMemberToRemove = new List<CampaignMember>();
        
        queryLimit = 20000;
        query = 'select id, ownerid, Owner.Profile.Name from campaign where Content_Type__c = \'Contact\' AND recordtype.DeveloperName = \'Business_Driven\' AND Name= \'ContactSync\'';
    }
    
    global DataBase.QueryLocator start(Database.BatchableContext contacts){
        return DataBase.getQueryLocator(query);
    }
    
    global void execute(DataBase.BatchableContext contacts, List<SObject> allCampaignsList){
        String profileName;
        Id campaignId;
        Id ownerId;
        Map<Id, CampaignMember> campMembers = new Map<Id, CampaignMember>();
        for(SObject obj : allCampaignsList){
            Campaign camp = (Campaign)obj;
            campaignId = camp.Id;
            ownerId = camp.ownerId;
            profileName = camp.Owner.Profile.Name;
        }
        for(CampaignMember cm : [select id, contactId from CampaignMember where campaignid =: campaignId LIMIT :queryLimit]){
            campMembers.put(cm.contactId, cm);
        }
        
        Set<Id> contIds = new Set<Id>();
        
        //Get Ids for Retail Users
        if(profileName.containsIgnoreCase(RETAIL)) {
            List<Coverage_Team__c> mfsCovTeam = new List<Coverage_Team__c>([Select id, Contact__c from Coverage_Team__c where Coverage_Owner__c = :ownerId AND Contact__r.Status__c = 'Active' LIMIT :queryLimit]);
            for(Coverage_Team__c atm : mfsCovTeam) {
                contIds.add(atm.Contact__c);
            }
        }
        //check for Institutiona user or System admin
        else if(profileName.containsIgnoreCase('Admin') || profileName.containsIgnoreCase(INSTITUTIONAL) || profileName.containsIgnoreCase(CLIENT_SERVICE) || profileName.containsIgnoreCase('Global Consultant Relations')) {
            List<AccountTeamMember> mfsCovTeam = new List<AccountTeamMember>([Select id, accountId, UserId from AccountTeamMember where userId = :ownerId LIMIT :queryLimit]);
            for(AccountTeamMember atm : mfsCovTeam) {                
                contIds.add(atm.accountId);
            }
            List<Contact> contToQuery= new List<Contact>([select id from Contact where accountId IN :contIds AND Status__c = 'Active' LIMIT :queryLimit]);
            contIds.clear();
            for(Contact c : contToQuery) {
                contIds.add(c.Id);
            } 
            //Get IDs for system admin
            if(profileName.containsIgnoreCase('Admin')){
                List<Coverage_Team__c> contCoverageTeam = new List<Coverage_Team__c>([Select id, Contact__c from Coverage_Team__c where Coverage_Owner__c = :ownerId AND Contact__r.Status__c = 'Active' LIMIT :queryLimit]);
                for(Coverage_Team__c atm : contCoverageTeam) {
                    contIds.add(atm.Contact__c);
                }
            }
        }
        
        if(contIds.size() > 0){
            for(Id conId : contIds){
                if(campMembers.containsKey(conId)){
                    campMembers.remove(conId);
                }else{
                    camMemberToAdd.add(new CampaignMember(CampaignId = campaignId, contactId = conId, belong_To__c = ownerId));
                }
            }
            if(campMembers.size() > 0){
                camMemberToRemove.addAll(campMembers.values());
            }
        }
        //Insert records in different batches with batch size 10000
        /*if(camMemberToAdd.size() > 10000){
            List<CampaignMember> camMemberToAdd1 = new List<CampaignMember>();
            List<CampaignMember> camMemberToAdd2= new List<CampaignMember>();
            List<CampaignMember> camMemberToAdd3 = new List<CampaignMember>();
            List<CampaignMember> camMemberToAdd4 = new List<CampaignMember>();
            List<CampaignMember> camMemberToAdd5 = new List<CampaignMember>(); 
            for(CampaignMember cm : camMemberToAdd){
                if(camMemberToAdd1.size() < 10000){
                    camMemberToAdd1.add(cm);
                }
                else if(camMemberToAdd2.size() < 10000){
                    camMemberToAdd2.add(cm);
                }
                else if(camMemberToAdd3.size() < 10000){
                    camMemberToAdd3.add(cm);
                }
                else if(camMemberToAdd4.size() < 10000){
                    camMemberToAdd4.add(cm);
                }
                else if(camMemberToAdd5.size() < 10000){
                    camMemberToAdd5.add(cm);
                }
            }
            if(camMemberToAdd1.size() > 0) {System.debug('1=============>'+camMemberToAdd1.size());insert camMemberToAdd1;}
            if(camMemberToAdd2.size() > 0) {System.debug('2=============>'+camMemberToAdd2.size()); insert camMemberToAdd2;}
            if(camMemberToAdd3.size() > 0) {System.debug('3=============>'+camMemberToAdd3.size());insert camMemberToAdd3;}
            if(camMemberToAdd4.size() > 0) {System.debug('4=============>'+camMemberToAdd4.size());insert camMemberToAdd4;}
            if(camMemberToAdd5.size() > 0) {System.debug('5=============>'+camMemberToAdd5.size());insert camMemberToAdd5;}
        }
        else */
        /*if(camMemberToAdd.size() > 0 && camMemberToAdd.size() <= 10000){
            insert camMemberToAdd;
        }*/
    }
    
    global void finish(DataBase.BatchableContext contacts){
        MFS_MyCampaignDeleteBatch deleteBatch = new MFS_MyCampaignDeleteBatch(camMemberToRemove);
        Database.executeBatch(deleteBatch,2000);
        MFS_MyCampaignInsertBatch insertBatch = new MFS_MyCampaignInsertBatch(camMemberToAdd);
        Database.executeBatch(insertBatch,2000);
    }
}