public class HandleException extends Exception
{
private static list<ExceptionLog__c> lstException = new list<ExceptionLog__c>();

public static void addException (sObject Obj, Exception ex, String message, String className, String methodName, String errorLine, String errorMessage, String errorDetails, String errorStackTrace, String errorType, String name, String id)
{
    ExceptionLog__c log = new ExceptionLog__c(
        ClassName__c = className,
        MethodName__c = methodName,
        ErrorLine__c = errorLine,
        ErrorMessage__c = errorMessage,
        ErrorDetails__c = errorStackTrace,
        ErrorType__c = errorType,
        ObjectValues__c = String.valueOf(Obj),
        Name = name,
        Id = id
    );
    lstException.add(log); 
}

public static void saveExceptionLog()
{
    if(!lstException.isEmpty())
    {
        Database.insert(lstException,false); 
    }
  }
 }