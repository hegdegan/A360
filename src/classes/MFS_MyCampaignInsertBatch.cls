global class MFS_MyCampaignInsertBatch implements Database.Batchable<CampaignMember>{
    global String query;
    global Id campaignId;
    global Id ownerId;
    global Set<Id> contactIds;
    global List<Campaignmember> cmList;
    public MFS_MyCampaignInsertBatch(List<Campaignmember> cmList){
       this.cmList = cmList;
    }
    global Iterable<CampaignMember> start(Database.BatchableContext contacts){
        return cmList;
    }
    global void execute(DataBase.BatchableContext contacts, List<CampaignMember> allContactsList){
       Database.insert(allContactsList, false) ;
    }
    global void finish(DataBase.BatchableContext contacts){
        
    }
}