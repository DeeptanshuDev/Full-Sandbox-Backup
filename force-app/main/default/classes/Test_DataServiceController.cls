@isTest(seealldata = false)
public with sharing class Test_DataServiceController {
    
    private static QueryStructure.FilterField createFilter(String fieldname ,QueryStructure.RestrictionEnum restriction , Object value ){
        QueryStructure.FilterField filter = new QueryStructure.FilterField();
        filter.fieldName = fieldname;
        filter.restriction = restriction;
        if(value instanceof List<String>) {
            filter.FilterValue =new QueryStructure.FilterValue((List<String>) value);
        }
        if(value instanceof List<Boolean>) {
            system.debug('BOOLEAN');
            filter.FilterValue =new QueryStructure.FilterValue((List<Boolean>) value);
        }
        if(value instanceof List<Integer>) {
            filter.FilterValue =new QueryStructure.FilterValue((List<Integer>) value);
        }
        return filter;
    }
    
    @isTest
    static void testDataServiceComplexField() {  
        Profile profile = [SELECT Id FROM Profile WHERE Name='Customer Community Login User (Rebel)' LIMIT 1];
        if(profile != null)  
        {
			List<User> users = [Select Id, Contact.AccountId from User WHERE ProfileId =: profile.Id];
			if(users != null && users.size() > 0)
			{
				Test.startTest();
				System.runAs(users[0]){
					Contact contacts = new Contact(); 
					List<String> objectFields = new List<String>();
					objectFields.add('Account.Name');
					objectFields.add('Owner.Name');
            
					List<String> fieldSets = new List<String>();
					List<String> groupFields = new List<String>();
					
					QueryStructure.Filter fa = new QueryStructure.Filter();
					// equals condition
					fa.filterFields.add(createFilter('LastName', QueryStructure.RestrictionEnum.EQ, new List<String>{
						contacts.LastName
							}));
					fa.filterFields.add(createFilter('FirstName', QueryStructure.RestrictionEnum.EQ, new List<String>{
						contacts.FirstName
							}));
					
					DataServiceController.InitInfo initInfo = DataServiceController.getInitInfo('Contact', objectFields, fieldSets, 1,  Json.serialize(fa), groupFields,groupFields);
					
					system.assertEquals(initInfo.fieldDescribe.size() == 2, true);
					system.assertNotEquals(initInfo.encryptedQueryStructureJson, null);
					
					String encryptedQueryStructureJson = initInfo.encryptedQueryStructureJson;
					
					String jsonData = DataServiceController.getDataScope(encryptedQueryStructureJson, 1, 1, '');
					
					List<DataServiceController.Row> returnedData = (List<DataServiceController.Row>) Json.deserialize(jsonData, List<DataServiceController.Row>.class);
					system.assertEquals(returnedData.size(), 0);
					
					DataServiceController.PaginationInfo paginationInfo = DataServiceController.getPaginationDetails(encryptedQueryStructureJson, 1);
					system.assertEquals(paginationInfo.totalNumberOfRecords, 0);
					system.assertEquals(paginationInfo.totalPages, 0);
				}
			}	
        }      
    }
    
    @isTest
    static void test_DataServiceComplexField() {  
        Profile profile = [SELECT Id FROM Profile WHERE Name='Customer Community Login User (Rebel)' LIMIT 1];
        if(profile != null)  
        {
			List<User> users = [Select Id, Contact.AccountId from User WHERE ProfileId =: profile.Id];
			if(users != null && users.size() > 0)
			{
				Test.startTest();
				System.runAs(users[0]){
					Account acc = new Account();
					acc.Name  = 'test account';
					Contact contacts = new Contact(); 
					List<String> objectFields = new List<String>();
					objectFields.add('Account.Name');
					objectFields.add('Owner.Name');
					objectFields.add('LastName');
					
					List<String> fieldSets = new List<String>();
					List<String> groupFields = new List<String>();
					
					QueryStructure.Filter fa = new QueryStructure.Filter();
					// equals condition
					fa.filterFields.add(createFilter('LastName', QueryStructure.RestrictionEnum.EQ, new List<String>{
						contacts.LastName
							}));
					fa.filterFields.add(createFilter('FirstName', QueryStructure.RestrictionEnum.EQ, new List<String>{
						contacts.FirstName
							}));
					fa.filterFields.add(createFilter('AccountId', QueryStructure.RestrictionEnum.EQ, new List<String>{
						contacts.AccountId
							}));
					
					DataServiceController.InitInfo initInfo = DataServiceController.getInitInfo('Contact', objectFields, fieldSets, 1,  Json.serialize(fa), groupFields,groupFields);
					
					system.assertEquals(initInfo.fieldDescribe.size() == 2, false);
					system.assertNotEquals(initInfo.encryptedQueryStructureJson, null);
					
					String encryptedQueryStructureJson = initInfo.encryptedQueryStructureJson;      
					List<QueryStructure.OrderField> orders = new List<QueryStructure.OrderField>{};
					String jsonOrder = JSON.serialize(orders);
					String jsonData = DataServiceController.getDataScope(encryptedQueryStructureJson, 1, 2, '');
					String jsonDataResult = DataServiceController.getDataScope(encryptedQueryStructureJson, 1, 2, jsonData);
				}
			}
		}		    
    }
    
    @isTest 
    static void test_getInitInfo()  {   
        List<String> fields = new List<String>{'Name', 'AccountNumber'};
        List<String> fieldSets = new List<String>{'Name','AccountNumber','Type', 'Phone', 'Website'};
        List<String> groupFields = new List<String>{'Name'};
        List<String> hiddenFields = new List<String>{'AccountNumber'};
        String str  = JSON.serialize('Type');
        DataServiceController.getInitInfo('', fields, fieldSets , 1, str,groupFields, hiddenFields);
    }

    @isTest
    static void test_getInitInfoMethod()  {   
        List<String> fields = new List<String>();
        List<String> fieldSets = new List<String>();
        List<String> groupFields = new List<String>();
        List<String> hiddenFields = new List<String>();
        DataServiceController.getInitInfo('Account', fields, fieldSets , 1, '',groupFields, hiddenFields);
    }
}