public class MFS_OpportunityComponentController {

    Account acc;
    
	public MFS_OpportunityComponentController(ApexPages.StandardController controller)
    {
        acc = (Account)controller.getRecord();
    }
    //get 5 opportunities which are recently created
    public List<Opportunity> getOpportunities()
    {
        List<Opportunity> opptyList = new List<Opportunity>([Select id, Name, StageName, Amount__c, Estimated_Funding_Date__c from Opportunity where AccountId=:acc.id ORDER BY CreatedDate DESC LIMIT 5]); 
        return opptyList;
    }
    //get the count of opportunities
    public Integer getOppCount()
    {
        return [select count() from Opportunity where accountId = :acc.Id];
    }
}