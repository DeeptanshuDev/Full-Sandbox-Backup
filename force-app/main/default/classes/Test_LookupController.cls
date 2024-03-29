@isTest(seealldata = false)
public with sharing class Test_LookupController {
    
    private static final String LOOKUP_FILTER_JSON = '{"size":1,"totalSize":1,"done":true,"queryLocator":null,"entityTypeName":"LookupFilter",'
        +'"records":[{"attributes":{"type":"LookupFilter","url":"/services/data/v43.0/tooling/sobjects/LookupFilter/0DG3B0000004becWAA"},'
        +'"SourceFieldDefinition":{"attributes":{"type":"FieldDefinition","url":"/services/data/v43.0/tooling/sobjects/FieldDefinition/Account.Owner"},'
        +'"FullName":"Account.OwnerId"},"TargetEntityDefinition":{"attributes":{"type":"EntityDefinition","url":"/services/data/v43.0/tooling/sobjects/'
        +'EntityDefinition/User"},"FullName":"User"},"Metadata":{"booleanFilter":"((1 OR 2 OR 5) AND (3 OR 4) AND (6 OR 7 OR 8) AND 9 AND 10)","filterItems"'
        +':[{"field":"$Source.AccountSource","operation":"equals","value":"Web","valueField":null},{"field":"$Profile.Name","operation":"equals","value":'
        +'"System Administrator","valueField":null},{"field":"User.ContactId","operation":"notEqual","value":"null","valueField":null},{"field":'
        +'"$Source.Industry","operation":"notEqual","value":null,"valueField":"$Source.AccountSource"},{"field":"$User.Country","operation":"equals",'
        +'"value":null,"valueField":"$Source.Industry"},{"field":"$Source.Industry","operation":"equals","value":null,"valueField":'
        +'"User.CompanyName"},{"field":"$UserRole.Name","operation":"notEqual","value":null,"valueField":"User.Division"},'
        +'{"field":"User.CompanyName","operation":"notEqual","value":null,"valueField":"$User.CompanyName"},{'
        +'"field":"User.City","operation":"equals","value":null,"valueField":"$User.City"},{"field":"User.Profile.Name","operation":"equals"'
        +',"value":null,"valueField":"$User.LastName"}],"active":true,"description":null,"errorMessage":null,"infoMessage":null,"isOptional":false}}]}';
    
    @testSetup
    private static void setup(){
        insert new Contact(LastName = 'Test1', FirstName = 'Name1');
        insert new Contact(LastName = 'Test2', FirstName = 'Name2');
        insert new Contact(LastName = 'Test3', FirstName = 'Name3');
    }
    
    @isTest
    static void test_search(){
        List<Contact> contacts = [Select Id, LastName, FirstName, Name From Contact];
        
        Test.startTest();
        
        String ret = LookupController.searchSObject(null, null);
        System.assert(String.isBlank(ret), 'Should return null string ['+ret+']');
        
        ret = LookupController.searchSObject('INVALID_OBJECT', 'NO_RESULT_SEARCH_STRING');
        System.assert(String.isBlank(ret), 'Should return null string ['+ret+']');
        
        ret = LookupController.searchSObject('Contact', 'NO_RESULT_SEARCH_STRING');
        System.assert(String.isNotBlank(ret), 'Should return non null string ['+ret+']');
        
        List<LookupController.SearchResult> sResList = (List<LookupController.SearchResult>)JSON.deserialize(ret, List<LookupController.SearchResult>.class);
        System.assert(sResList.isEmpty(), 'Why not empty list? ['+sResList.size()+' instead]');
        
        Test.setFixedSearchResults(new List<String>{contacts[0].Id,contacts[1].Id,contacts[2].Id});
        ret = LookupController.searchSObject('Contact', 'Test');
        System.assert(String.isNotBlank(ret), 'Should return a serialized list string ['+ret+']');
        
        sResList = (List<LookupController.SearchResult>)JSON.deserialize(ret, List<LookupController.SearchResult>.class);
        System.assert(sResList.size() == 3, 'Why not 3 items found? ['+sResList.size()+' instead]');
        
        Test.stopTest();
    }
    
    @isTest 
    static void test_searchSObject() {   
        Object obj = 'Jaipur'; 
        String fieldNames  = LookupController.searchSObject('Account','Name', 'BillingCity', obj);
        System.assertEquals('[]', fieldNames);   
    }
    
    @isTest
    static void test_retrieveDisplayValues() {   
        List<String> ids = new List<String>{'0011500001GEDVxAAP'};
            String values  = LookupController.retrieveDisplayValues(ids, 'Account');
        System.assertEquals('[]', values);   
    }
}