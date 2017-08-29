public class MFS_MSTR_DashboardController
{
    public MFS_MSTR_DashboardController() {
        
    }
    
    public string getHomePageURL()
    {
        try
        {
            MicroStrategy_URLs__c ob = MicroStrategy_URLs__c.getInstance('HomeDashboard');
            string url = ob.URL__c;
            if (String.isNotBlank(ob.QueryString__c))
            {
                url += ('?' + ob.QueryString__c);
            }

        	return url;
        }
        catch(Exception ex)
        {
            return '';
        }
    }

	public string getTabURL()
    {
        try
        {
            MicroStrategy_URLs__c ob = MicroStrategy_URLs__c.getInstance('BIDashboardWebTab');
            string url = ob.URL__c;
            if (String.isNotBlank(ob.QueryString__c))
            {
                url += ('?' + ob.QueryString__c);
            }

        	return url;
        }
        catch(Exception ex)
        {
            return '';
        }
    }
    
    public string getRepScorecardURL()
    {
        try
        {
            string mdmId = ApexPages.currentPage().getParameters().get('MDM_Id');
            
            MicroStrategy_URLs__c ob = MicroStrategy_URLs__c.getInstance('RepScorecard');
            string url = ob.URL__c;
            if (String.isNotBlank(ob.QueryString__c))
            {
                url += ('?' + ob.QueryString__c.replace('{!Contact.MDM_ID__c}', mdmId));
            }

        	return url;
        }
        catch(Exception ex)
        {
            return '';
        }
    }
}