public class MFS_MSTR_DashboardExtension {

    Private final Contact c;
    
    public MFS_MSTR_DashboardExtension(ApexPages.StandardController stdController) {
        this.c = (Contact)stdController.getRecord();
    }

         public string getRepScorecardURL() {
       
             try
       		 {
                                 
            string mdmId = c.MDM_ID__c; 
            
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