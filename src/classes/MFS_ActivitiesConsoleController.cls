public class MFS_ActivitiesConsoleController {
    Account acc;
    Contact con;
	public MFS_ActivitiesConsoleController(ApexPages.StandardController controller)
    {
        String objName = controller.getRecord().getsObjectType().getDescribe().getName();
        if(objName == 'Account')
            acc = (Account)controller.getRecord();
        else
            con = (Contact)controller.getRecord();
    }
    
    public List<ActivityHistory> getActivityHistories()
    {
        List<Account> actHistAcc = new List<Account>([Select (select subject,WhoId,Who.Name,PrimaryWhoId,PrimaryWho.Name,WhatId,What.Name,IsTask,ActivityDate,Owner.Name,LastModifiedDate from 
                                                                                      ActivityHistories ORDER BY ActivityDate DESC LIMIT 5) from Account where Id=:acc.id ]); 
        List<ActivityHistory> actHist = new List<ActivityHistory>();
        for(Account ahAcc : actHistAcc )
        {
            for(ActivityHistory ah : ahAcc.ActivityHistories){
                actHist.add(ah);
            }
        }
        return actHist;
    }
    
    public List<OpenActivity> getOpenActivities()
    {
        //Open Activities should be queried with parent record. Direct Query is not allowed.
        List<Account> openActAcc = new List<Account>([select id,(select id, subject,WhoId,Who.Name,PrimaryWhoId, PrimaryWho.Name,WhatId,What.Name,IsTask,ActivityDate,Status,Priority,Owner.Name from OpenActivities ORDER BY ActivityDate
                                                                                         ASC LIMIT 5) from Account where Id=:acc.id]); 
        List<OpenActivity> openAct = new List<OpenActivity>();
        for(Account oaAcc : openActAcc )
        {
            for(OpenActivity oa : oaAcc.Openactivities){
                openAct.add(oa);
            }
        }
        return openAct;
    }
    
    public List<ActivityHistory> getContactActivityHistories()
    {
        List<Contact> actHistAcc = new List<Contact>([Select (select subject,WhoId,Who.Name,PrimaryWhoId,PrimaryWho.Name,WhatId,What.Name,IsTask,ActivityDate,Owner.Name,LastModifiedDate from 
                                                                                      ActivityHistories ORDER BY ActivityDate DESC LIMIT 5) from Contact where Id=:con.id ]); 
        List<ActivityHistory> actHist = new List<ActivityHistory>();
        for(Contact ahAcc : actHistAcc )
        {
            for(ActivityHistory ah : ahAcc.ActivityHistories){
                actHist.add(ah);
            }
        }
        return actHist;
    }
    
    public List<OpenActivity> getContactOpenActivities()
    {
        //Open Activities should be queried with parent record. Direct Query is not allowed.
        List<Contact> openActAcc = new List<Contact>([select id,(select id, subject,WhoId,Who.Name,PrimaryWhoId, PrimaryWho.Name,WhatId,What.Name,IsTask,ActivityDate,Status,Priority,Owner.Name from OpenActivities ORDER BY ActivityDate
                                                                                         ASC LIMIT 5) from Contact where Id=:con.id]); 
        List<OpenActivity> openAct = new List<OpenActivity>();
        for(Contact oaAcc : openActAcc )
        {
            for(OpenActivity oa : oaAcc.Openactivities){
                openAct.add(oa);
            }
        }
        return openAct;
    }
}