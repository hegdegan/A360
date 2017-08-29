global class MFS_MyCampaignDeleteBatch implements Database.Batchable<CampaignMember>{
    global List<Campaignmember> cmList;
    public MFS_MyCampaignDeleteBatch(List<Campaignmember> cmList){
       this.cmList = cmList;
    }
    global Iterable<CampaignMember> start(Database.BatchableContext contacts){
        return cmList;
    }
    global void execute(DataBase.BatchableContext contacts, List<CampaignMember> deleteList){
       Database.delete(deleteList,false);
    }
    global void finish(DataBase.BatchableContext contacts){
        
    }
}