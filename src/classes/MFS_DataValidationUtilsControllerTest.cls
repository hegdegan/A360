@isTest(seeAllData = false)
public class MFS_DataValidationUtilsControllerTest {
    static testMethod void testDataUtils(){    
        Test.startTest();
        MFS_DataValidationUtilsController dUtils = new MFS_DataValidationUtilsController();
        dUtils.selectedPicklistField = 'Type';
        dUtils.selectedObject = 'Account';
        dUtils.selectedField = 'Type';
        dUtils.getObjectOptions();
        dUtils.getFieldOptions();
        dUtils.getRequiredFields();
        dUtils.getPicklistValues();
        dUtils.getPicklistFields();
        dUtils.getPicklistFieldOptions();
        Test.stopTest();
    }
    
}