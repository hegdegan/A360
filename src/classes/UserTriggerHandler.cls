public class UserTriggerHandler {
    
    public static void processUserEmailRecords(list<user> userList){
        for(User uObj: userList){
            if(uObj.isActive && uObj.Email.endsWith('@mfs.com') && uObj.LastLoginDate == null && uObj.IsNotValidUser__c)
                uObj.isActive = false;
        }
    }
    
    
}