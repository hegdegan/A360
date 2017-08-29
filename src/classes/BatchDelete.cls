global class BatchDelete implements Database.Batchable<sObject> {
   public String query;
 
   global Database.QueryLocator start(Database.BatchableContext BC){
     return Database.getQueryLocator(query);
   }
 
   global void execute(Database.BatchableContext BC, List<sObject> scope){
      try {
      
      if(runningInASandbox()) {
      delete scope;
      DataBase.emptyRecycleBin(scope);
      system.Debug('Executed the delete');
      
      }
      
      else {     
      Throw new MyException('You are in a production environment');
      
      }
      
      }
      catch (Exception e) {
       system.Debug('Threw an exception');
      }
      
      }
      
 
   global void finish(Database.BatchableContext BC){
   }
   
  public static Boolean runningInASandbox() {
  return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
}
}