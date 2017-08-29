public class MFS_ContactController {
    @auraEnabled
    public static Contact getContactInfo(Id conId){
        return [select id, Phone, accountId from contact where id = :conId];
    }
    
    @auraEnabled
    public Static Id getTaskRecordTypeId(){
        List<RecordType> taskRT = [select id from RecordType where developername ='Standard_Task' and SObjectType='Task' LIMIT 1];
        if(taskRT.size() > 0)
            return taskRT[0].Id;
        else
            return null;
    }

}