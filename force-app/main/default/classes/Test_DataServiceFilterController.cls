@IsTest
public with sharing class Test_DataServiceFilterController {

    static String getEncrypedQueryStructureJson() {
        List<String> emptyList = new List<String>();

        DataServiceController.InitInfo initInfo = DataServiceController.getInitInfo(
                'Account',
                new List<String> { 'Id', 'Name','Name'}, emptyList, 20, '', emptyList, emptyList
        );
        return initInfo.encryptedQueryStructureJson;
    }

    static DataServiceFilterController.FiltersInitInfo getFiltersInitInfo(List<String> fields, String fieldset) {
        DataServiceFilterController.FiltersInitInfo filtersInitInfo = DataServiceFilterController.getFiltersInitInfo(
                'Account',
                fields,
                fieldset
        );
        return filtersInitInfo;
    }

    @isTest
    static void test_getFiltersInitInfo() {
        List<String> fields = new List<String>{'Name', 'AccountNumber'};
        DataServiceFilterController.getFiltersInitInfo('Account',fields,'MC4SF__Account_Filter_Fields');
    }
    
    @isTest
    static void test_convertToSalesforceId() {
        List<Object> selectedValues = new List<Object>{'Account', 'Contact'};
        DataServiceFilterController.convertToSalesforceId(selectedValues);
    }
    
    @isTest
    static void test_getFilterValues() {
        String encryptedQueryStructureJson = getEncrypedQueryStructureJson();
        DataServiceFilterController.FiltersInitInfo filtersInitInfo = getFiltersInitInfo(
                new List<String>{'Name'},
                null
        );
        
        String filterFieldJson = 'Name';
        // get the name field describe
        String fieldDescribeJson = JSON.serialize(filtersInitInfo.fieldDescribe.get(0));
        
        DataServiceFilterController.getFilterValues(encryptedQueryStructureJson,fieldDescribeJson,'Name',true,filterFieldJson);
        DataServiceFilterController.getFilterValues(encryptedQueryStructureJson,fieldDescribeJson,'',false,null);
       	DataServiceFilterController.getFilterValues(encryptedQueryStructureJson,fieldDescribeJson,'32',false,null);
        DataServiceFilterController.getFilterValues(encryptedQueryStructureJson,fieldDescribeJson,'test',false,null);
        
    }
    
    @isTest
    static void test_getTermValue() {
        Object obj = DataServiceFilterController.getTermValue('Name', 'Text');
        Object obj1 = DataServiceFilterController.getTermValue('Contract_Exists__c', 'Number');
        Object obj2 = DataServiceFilterController.getTermValue('SCMC__Active__c', 'Checkbox');
        Object obj3 = DataServiceFilterController.getTermValue('AccountId', 'Id');
    }
    
    @isTest
    static void test_getGenericFilterValues() {
        LightningResponseEntity response1;
        LightningResponseEntity response2;
        LightningResponseEntity response3;
        LightningResponseEntity response4;
        DataServiceFilterController.FilterValuesResponse filterValuesResponse;
        QueryStructure qs = new QueryStructure();
        Field fl1 = new Field('Contact.Account.Id', 'Test1', 'Test1', 'REFERENCE', false, true, false, 'Test', 'Test');
        Field fl2 = new Field('Contact.Account__r.Name', 'Test2', 'Test1', 'REFERENCE', false, true, false, 'Test', 'Test');
        Field fl3 = new Field('Name', 'Test3', 'Test2', 'REFERENCE', false, true, false, 'Test', 'Test');
        Field fl4 = new Field('id', 'Test4', 'Test2', 'REFERENCE', false, true, false, 'Test', 'Test');
        List<Object> selectedValues = new List<Object>{'Account', 'Contact'};           
        response1 = DataServiceFilterController.getGenericFilterValues(qs, fl1, 'term', false, selectedValues);
        response2 = DataServiceFilterController.getGenericFilterValues(qs, fl2, 'term', false, selectedValues);
        response3 = DataServiceFilterController.getGenericFilterValues(qs, fl3, 'term', false, selectedValues);
        response4 = DataServiceFilterController.getGenericFilterValues(qs, fl4, 'term', false, selectedValues);
    }
    
    @isTest
    static void test_getGenericFilterValues1() {
      LightningResponseEntity response;
        DataServiceFilterController.FilterValuesResponse filterValuesResponse;
        QueryStructure qs = new QueryStructure();
        Field fl = new Field();       
        List<Object> selectedValues = new List<Object>{'Account', 'Contact', 'Lead','Opportunity', 'Id', 'Name'};           
        response = DataServiceFilterController.getGenericFilterValues(qs, fl, 'Name', false, selectedValues);  
        
    }
 
    @isTest
    static void test_UnitMethod() {
        Schema.FieldSetMember fsMember;
        
        Account acc = new Account(name='Account', Type = 'Pro', Phone = '9685741452');
        insert acc;
        
        Field fl = new Field();
        fl = new Field('Name','Name','To store address','Text',true,true,true,'Account','Account');
        
        
        DataServiceFilterController.isFieldLikable(fl);
        DataServiceFilterController.isRecordTypeField(fl); 
       	//DataServiceFilterController.getRecordLabel(acc,fl);
    }
 
}