public class MFS_RedirectDetailRequest
{
	public PageReference redirectContact()
    {
        string app = '';
        try
        {
            app = getAppName();
        }
        catch(Exception ex)
        {
            return null;
        }

		string contactId = '';        
        try
        {
            contactId = ApexPages.currentPage().getParameters().get('ContactId');
        }
        catch(Exception ex)
        {
            return null;
        }

        try
        {
            string page = '';
            if (app.toUpperCase().indexOf('CONSOLE') != -1)
            {
                page = '/console#%2F' + contactId;
                //pr = new PageReference();
                //001P0000016rA60|%2F003P0000018TOsR);
            }
            else
            {
                page = '/' + contactId;
            }
            
            return new PageReference(page);
        }
        catch(Exception ex)
        {
            return null;
        }
    }
    
    String getAppName()
    {
        // Get tab set describes for each app
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();

        // Iterate through each tab set describe for each app and display the info
        string name = '';
        for(Schema.DescribeTabSetResult tsr : tabSetDesc)
        {
            if (tsr.isSelected())
            {
                name = tsr.getLabel();
            }
        }       

        // Selected?
        return name;
    }
}