global class MFS_CampaignCloneBatch implements Database.Batchable<sObject> {

    String userEmail;
    Campaign newCamp = null;
  
    
global MFS_CampaignCloneBatch(Campaign newCamp, String userEmail) {
   
    this.userEmail = userEmail;   
    this.newCamp = newCamp;
}

    
global Database.QueryLocator start(Database.BatchableContext BC) {
    
return DataBase.getQueryLocator([Select Id,FirstName,LastName,Status,Type,ContactId,LeadId 
                                        from CampaignMember where campaignId =: newCamp.Original_Campaign__c]);
}

    
global void execute(Database.BatchableContext BC, List<CampaignMember> scope) { 
    
        List<CampaignMember> cmemAddToList = new List<CampaignMember>();
    
        for(CampaignMember cm : scope){
            CampaignMember campMem = cm.clone(false,true);
            campMem.campaignId = newCamp.Id;
            cmemAddToList.add(campMem);
        }

     Database.SaveResult[] insCampMem = Database.insert(cmemAddToList,false); 
}
    
       
global void finish(Database.BatchableContext BC) {
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
String[] toAddresses = new String[] {userEmail};      
mail.setToAddresses(toAddresses);
mail.setSubject('Campaign Clone is Complete');
mail.setPlainTextBody('Campaign: ' + newCamp.Id + ' is Complete' + 
                      '\n\n' + 'You can access it here: ' + 
                      'https://mfs--sfdcdev02.cs4.my.salesforce.com/' + newCamp.Id);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}   
}