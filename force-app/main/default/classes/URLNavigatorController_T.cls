@isTest
private  class URLNavigatorController_T {
    
    static Opportunity opp;
    
    static {
        opp = TestData.opportunity(true);       
    }
    
    
    @isTest
    private static void redirectToNewRecord() {
     
        PageReference pageRef = Page.URLNavigator;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('retURL',opp.Id);
        ApexPages.currentPage().getParameters().put('entityName','Standardized_Item__c');
        ApexPages.currentPage().getParameters().put('recordTypeSelection','false');
        ApexPages.currentPage().getParameters().put('classicfieldsid','Opportunity__c@~@Design_Request__c');
        
        ApexPages.currentPage().getParameters().put('defaults',opp.Id+'@~@'+opp.Design_Request__c);
       
        ApexPages.currentPage().getParameters().put('operationtype','createRecord');
        
        Test.startTest();
        URLNavigatorController urlNavigator = new URLNavigatorController();
        PageReference redirectToNewRecord =  urlNavigator.redirect();
        Test.stopTest(); 
    }
    
    
    @isTest
    private static void redirectToBack() {
     
        PageReference pageRef = Page.URLNavigator;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('retURL',opp.Id);
        ApexPages.currentPage().getParameters().put('entityName','Standardized_Item__c');
        ApexPages.currentPage().getParameters().put('recordTypeSelection','false');
        ApexPages.currentPage().getParameters().put('classicfieldsid','Opportunity__c@~@Design_Request__c');
        
        ApexPages.currentPage().getParameters().put('defaults',opp.Id+'@~@'+opp.Design_Request__c);
        ApexPages.currentPage().getParameters().put('refresh','true');
       
        ApexPages.currentPage().getParameters().put('operationtype','back');
        
        Test.startTest();
        URLNavigatorController urlNavigator = new URLNavigatorController();
        PageReference redirectToBack =  urlNavigator.redirect();
        Test.stopTest(); 
    }
    
    @isTest
    private static void redirectToSobject() {
     
        PageReference pageRef = Page.URLNavigator;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('recordId',opp.Id);
        ApexPages.currentPage().getParameters().put('entityName','Standardized_Item__c');
        ApexPages.currentPage().getParameters().put('recordTypeSelection','false');
        ApexPages.currentPage().getParameters().put('classicfieldsid','Opportunity__c@~@Design_Request__c');
        
        ApexPages.currentPage().getParameters().put('defaults',opp.Id+'@~@'+opp.Design_Request__c);
       
        
        ApexPages.currentPage().getParameters().put('operationtype','navigateToSObject');
        
        Test.startTest();
        URLNavigatorController urlNavigator = new URLNavigatorController();
        PageReference redirectToSbjectRecord =  urlNavigator.redirect();
        Test.stopTest(); 
    }
    
    @isTest
    private static void redirectToUrl() {
     
        PageReference pageRef = Page.URLNavigator;
        Test.setCurrentPage(pageRef);
       
        ApexPages.currentPage().getParameters().put('entityName','Standardized_Item__c');
        ApexPages.currentPage().getParameters().put('recordTypeSelection','false');
        ApexPages.currentPage().getParameters().put('classicfieldsid','Opportunity__c@~@Design_Request__c');
        
        ApexPages.currentPage().getParameters().put('defaults',opp.Id+'@~@'+opp.Design_Request__c);
        ApexPages.currentPage().getParameters().put('url',opp.Id);
        ApexPages.currentPage().getParameters().put('isredirect','true');
        
        ApexPages.currentPage().getParameters().put('operationtype','navigateToUrl');
        
        Test.startTest();
        URLNavigatorController urlNavigator = new URLNavigatorController();
        PageReference redirectToUrl =  urlNavigator.redirect();
        Test.stopTest(); 
    }
    
    
}