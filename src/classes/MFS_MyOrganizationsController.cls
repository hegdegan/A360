/***************************************************************************************************
Apex Class Name    : MFS_MyOrganizationsController 
Version            : 1.0 
Created Date       : 22 JAN 2017
Function           : Class is used to fetch my Orgs for the custom page
Modification Log   :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
Ganesh Hegde				22 JAN 2017				Original Version
***************************************************************************************************/
public class MFS_MyOrganizationsController {
    public transient List<Account> myOrgsList { get; set; }
    private Set<Id> accIds;
    Public Integer size {get;set;} 
    public Integer noOfRecords{get; set;}
    private Id loggedinUserId;
    
    public MFS_MyOrganizationsController()
    {
        try{
            //Record size for initial load
            size=1000;
            loggedinUserId = UserInfo.getUserId();
            accIds = new Set<Id>();
            myOrgsList = new List<Account>();
            List<AccountTeamMember> mfsCovTeam = new List<AccountTeamMember>([Select id, accountId, UserId from AccountTeamMember where userId = :UserInfo.getUserId() LIMIT 10000]);
            for(AccountTeamMember atm : mfsCovTeam)
            {                
                accIds.add(atm.accountId);
            }
            getOrgList();
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.My_Cont_Message2 +e.getMessage()));
        }
    }
    
    //fetch the Organizations where they have been assigned to Organization's MFS Coverage Team.
    public ApexPages.StandardSetController myOrgs {
        get {
            if(myOrgs == null) {
                myOrgs = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [Select Id, Name, ShippingCity, ShippingState, ShippingCountry, ShippingPOstalCode, Institutional_Tier__c, Type__c from Account where ID IN :accIds LIMIT 10000]));
                myOrgs.setPageSize(size);  
                noOfRecords = myOrgs.getResultSize();
            }            
            return myOrgs;
        }
        set;
    }
    
    //Prepare list to display
    public void getOrgList()
    {
        for(Account acc : (List<Account>)myOrgs.getRecords()) 
        {
            myOrgsList.add(acc);
        }
    }
    
    //get next set of records for pagination
    public void getNextOrgs()
    {
        myOrgs.next();
        myOrgsList = new List<Account>((List<Account>)myOrgs.getRecords());
    }
    
    //get previous set of records for pagination
    public void getpreviousOrgs()
    {
        myOrgs.previous();
        myOrgsList = new List<Account>((List<Account>)myOrgs.getRecords());
    }
    
    //Refresh page size after reload
    public PageReference refreshPageSize() {
        myOrgs.setPageSize(size);
        return null;
    }
}