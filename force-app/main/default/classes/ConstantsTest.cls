@isTest(seeAllData = false)
public class ConstantsTest {

    @isTest
    static void test_updateCustomAndStandardItemsRecord(){
        
        Constants cc = new Constants();
        Constants.MIGRATION_CONFIGURATION_MAP = new Map<String, Migration_Configuration__c>();
        Set<String> str = new Set<String>();
        str = constants.SET_COMPONENTS_NAME_HAVING_OBJECT_NAME_PREFIX_AS_MEMBER;
        
        
    }
}