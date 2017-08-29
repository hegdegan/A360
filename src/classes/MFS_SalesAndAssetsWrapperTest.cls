@isTest(seeAllData=false)
public class MFS_SalesAndAssetsWrapperTest {
	
	static testMethod void TestSalesAndAssetsWraper(){	
        try{
            MFS_AllConstants.PageForSortSeq = MFS_AllConstants.OrgInsSalesPage;
            List <MFS_SalesAssetsWrapper> saWrapList= MFS_TestDataUtility.getSalesAndWrapperList();
            System.assert(saWrapList.size()>0);
            saWrapList.sort();
            MFS_AllConstants.PageForSortSeq = MFS_AllConstants.TotalSalesLabel;
            saWrapList.sort();
            MFS_AllConstants.PageForSortSeq = MFS_AllConstants.OrgConSalesPage;
            saWrapList.sort();
            //Institutional
            saWrapList = MFS_TestDataUtility.getSalesAndWrapperListPerObjectType(MFS_AllConstants.OrgInsSalesPage);
            System.assert(saWrapList.size()>0);
            MFS_AllConstants.PageForSortSeq = MFS_AllConstants.OrgInsSalesPage;
            saWrapList.sort();
            //Consultant
            saWrapList = MFS_TestDataUtility.getSalesAndWrapperListPerObjectType(MFS_AllConstants.OrgConSalesPage);
            System.assert(saWrapList.size()>0);
            MFS_AllConstants.PageForSortSeq = MFS_AllConstants.OrgConSalesPage;
            saWrapList.sort();
            //Total Sales
            saWrapList = MFS_TestDataUtility.getSalesAndWrapperListPerObjectType(MFS_AllConstants.TotalSalesLabel);
            MFS_AllConstants.PageForSortSeq = MFS_AllConstants.TotalSalesLabel;
            saWrapList.sort();
            //Exception Block
            saWrapList = MFS_TestDataUtility.getSalesAndWrapperListPerObjectType('Exception');
            System.assert(saWrapList.size()>0);
            MFS_AllConstants.PageForSortSeq = MFS_AllConstants.TotalSalesLabel;
            saWrapList.sort();
        }catch(Exception e){
            system.debug('Exception in : '+e.getStackTraceString());
        }
        
	}
    
}