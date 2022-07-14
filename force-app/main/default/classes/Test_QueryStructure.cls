@isTest(seealldata = false)
public class Test_QueryStructure {

    @isTest
    static void testFields() {
        QueryStructure qs = QueryStructure.create();
        qs.addFields(new String[] { 'Id', 'Name' });
        
        List<String> fieldnames = qs.getFieldnames();
        
        System.assert(fieldnames.get(0).equals('Id'), 'Expected first fieldname to be `Id`, was: ' + fieldnames.get(0));
    }
     
    @isTest 
    static void test_getFieldsDescribe() {    
        Test.startTest();
        QueryStructure qs = QueryStructure.create();
        qs.fromSObject('Contact');
        qs.addFields(new String[] { 'Id', 'Name', 'OwnerId','Birthdate','RecordTypeId','SCMC__Suffix__c','DoNotCall','LastCURequestDate','Phone', GenericUtils.getPackagePrefix() +'AccountId' });
        Map<String, Field> mapOfFieldDescribe = qs.getFieldsDescribe();
        System.assert(mapOfFieldDescribe.get('OwnerId').label == 'Owner','Expected field label to be `Owner`, was:' + mapOfFieldDescribe.get('OwnerId').label);
        System.assert(mapOfFieldDescribe.get(GenericUtils.getPackagePrefix() +'AccountId').label == 'Account','Expected field label to be `Record`, was:' + mapOfFieldDescribe.get(GenericUtils.getPackagePrefix() +'AccountId').label);
        Test.stopTest();
    }
    
    @isTest 
    static void test_getSoslResult() {
        
        Test.startTest();
      
        SoslBuilder builder = new SoslBuilder().forObject(genericUtils.getPackagePrefix()+'Account').setSearchString('Test');
        List<SoslBuilder.SoslStructure> soslStructures = builder.getResults();
        
        SoslBuilder builder2 = SoslBuilder.fromSoslStructures(soslStructures);
        List<SoslBuilder.SoslStructure> soslStructures2 = builder.getResults();
        
        Test.stopTest();
        
        System.assert(soslStructures.get(0).ids.size() == soslStructures2.get(0).ids.size(), 'SoslStructures should have the same results');
    }
    
    @isTest
    static void test_toCriterion() {
        SoqlBuilder.Criterion criterion = new SoslBuilder().forObject('Account').setSearchString('Name').getCriterion();
    }
    
    @isTest 
    static void test_getReferenceFieldsOfType() {
        Boolean useRelationSuffix = Boolean.valueOf(false);
        
        Map<String, Schema.SObjectType> globalDescMapCon = Schema.getGlobalDescribe();
        Schema.SObjectType objectType = globalDescMapCon.get('Contact');
         
        Map<String, Schema.SObjectType> globalDescMapAcc = Schema.getGlobalDescribe(); 
        Schema.SObjectType referenceObjectType = globalDescMapAcc.get('Account');
         
        QueryStructure.getReferenceFieldsOfType(Contact.sObjectType, Account.sObjectType, 'Name', useRelationSuffix); 
        
    } 
    
    @isTest 
    static void test_testFieldsMethod() {
        QueryStructure qs = new QueryStructure();
        List<String> listToCheck = new List<String>{'Name', 'AccountNumber', 'AccountSource','Name'};
        Set<String> setToCheck = new Set<String>{'Name', 'AccountNumber', 'AccountSource'};
        List<String> groupFieldNames = new List<String>{'Name'};
       	String stringToCheck = 'Name';
        SoqlBuilder builder = new SoqlBuilder();
        qs.containsCaseInsensitive(stringToCheck, listToCheck);
        qs.containsCaseInsensitive(stringToCheck, setToCheck);
        qs.addHiddenFields(setToCheck);
        qs.addField('Account');
        qs.addGroupFields(groupFieldNames);
        qs.addWhereConditions(builder);
    }
}