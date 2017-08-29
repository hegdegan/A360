/*
Apex Class Name    : MFS_AccountTeamMemExtensions
Version            : 1.0 
Created Date       : 23 May 2016
Function           : Redirect class for custom edit for Account team members
*/
public with sharing class MFS_ACTRedirectPage{ 
      
/***************************************************************************************************
 * name        : Redirect page
 * description : Generate redirect URL - navigation utility method 
 * param1      : pageUrl which page to be Redirect  
 * param2      : Map<String,String> urlParameters need to validate
 * return      : redirect nextpage type of Pagereference 
**************************************************************************************************/
    public static PageReference redirectPage(String pageUrl, Map<String, String> urlParameters) {
        PageReference nextPage = new PageReference(pageUrl);
        if (urlParameters != null && !urlParameters.isEmpty()) {
            for (String paramName : urlParameters.keySet()) {
                nextPage.getParameters().put(paramName, urlParameters.get(paramName));
            }
        }
        nextPage.setRedirect(true);
        return nextPage;
    }
}