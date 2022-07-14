@isTest(seealldata = false)
public with sharing class Test_SOSLBuilder {
    
    @isTest
    static void testCandidate() {
        List<Id> ids = new List<Id>();
        Test.startTest();
        
        Test.setFixedSearchResults(ids);
        
        SoslBuilder builder = new SoslBuilder().forObject(genericUtils.getPackagePrefix()+'Account').setSearchString('Test');
        List<SoslBuilder.SoslStructure> soslStructures = builder.getResults();
        
        System.assert(soslStructures.size() == 1, 'Expected soslStructures size 1, was: ' + soslStructures.size());
        System.assert(soslStructures.get(0).ids.size() == 0, 'Expected 2 candidate ids in result, was: ' + soslStructures.get(0).ids.size());
        
        // Run again to test the dirty flag, should return cached results
        soslStructures = builder.execute().getResults();
        
        Test.stopTest();
        
        System.assert(soslStructures.get(0).ids.size() == 0, 'Expected 2 candidate ids in result, was: ' + soslStructures.get(0).ids.size());
    }
    
    @isTest
    static void testJobApplicationsWithReferences() {
        
        Test.startTest(); 
        
        SoslBuilder builder = new SoslBuilder().forObject(genericUtils.getPackagePrefix()+'Account').setSearchString('Test').includeReferenceFields();
        List<SoslBuilder.SoslStructure> soslStructures = builder.getResults();
        
        Test.stopTest();
        
        System.assert(soslStructures.size() > 1, 'Expected soslStructures size greater than 1, was: ' + soslStructures.size());
        System.assert(soslStructures.get(0).ids.size() == 0, 'Expected 3 job application ids in result, was: ' + soslStructures.get(0).ids.size());
    }
    
    @isTest
    static void testReferences() {
        List<SoslBuilder.SoslStructure> soslStructures = new SoslBuilder().forObject(genericUtils.getPackagePrefix()+'Contact').setSearchString('Test').includeReferenceFields().getResults();
        List<SoslBuilder.SoslStructure> soslStructures2 = new SoslBuilder().forObject(genericUtils.getPackagePrefix()+'Account').setSearchString('Test').includeReferenceFields(true).getResults();
        
    }
    
    
    @isTest
    static void testHasResults() {
        Boolean hasResults = new SoslBuilder().forObject(genericUtils.getPackagePrefix()+'Account').setSearchString('Test').hasResults();
        System.assert(!hasResults, 'Expected hasResults to be true, was ' + hasResults);
    }
    
    @isTest
    static void testHasNoResults() {
        Boolean hasResults = new SoslBuilder().forObject(genericUtils.getPackagePrefix()+'Account').setSearchString('Test').hasResults();
        System.assert(!hasResults, 'Expected hasResults to be false, was ' + hasResults);
    }
    
    @isTest
    static void testGetCriterion() {
        
        List<Id> ids = new List<Id>();
        
        SoqlBuilder.Criterion criterion = new SoslBuilder().forObject(genericUtils.getPackagePrefix()+'Contact').setSearchString('Test').getCriterion();
        
    }
    
    @isTest
    static void testFromSoslStructures() {
        List<Id> ids = new List<Id>();
        
        Test.startTest();
        
        SoslBuilder builder = new SoslBuilder().forObject(genericUtils.getPackagePrefix()+'Account').setSearchString('Test');
        List<SoslBuilder.SoslStructure> soslStructures = builder.getResults();
        
        SoslBuilder builder2 = SoslBuilder.fromSoslStructures(soslStructures);
        List<SoslBuilder.SoslStructure> soslStructures2 = builder.getResults();
        
        Test.stopTest();
        
        System.assert(soslStructures.get(0).ids.size() == soslStructures2.get(0).ids.size(), 'SoslStructures should have the same results');
    }
    
}