/**
*	Description   	:   Test class to perform the testing of CRPackageDotXMLBuilder vf page from CR detail page.
* 
*  	Version			:   v1.1 - Created -  - Abhinav Sharma         
**/ 
@isTest
private class CRPackageDotXMLBuilder_T
{
    static Project__c project;
    static Release__c release;
    static Change_Request__c changeRequest;
    static 
    {
        TestData.migrationConfiguration(new Migration_Configuration__c(Name = 'Apex Class', Component_Type__c = 'Apex Class', Component_Name__c = 'ApexClass'),true);
        TestData.migrationConfiguration(new Migration_Configuration__c(Name = 'Page Layout', Component_Type__c = 'Page Layout', Component_Name__c = 'Layout'),true);
           
        project = TestData.project(true);
        release = TestData.release(new Release__c(
            Project__c = project.Id
        ), true);
        
        changeRequest = TestData.changeRequest(new Change_Request__c(Release__c = release.Id, Status__c = '01-New Request', Priority__c='C-Standard', Type__c='New Request'), true);
        TestData.modification(new Modification__c(System_Issue_Report__c = changeRequest.Id, Type_Of_Modification__c = 'Add', Component_Type__c = 'Apex Class', Component_Name__c = 'AddToQuoteController'), true);
        TestData.modification(new Modification__c(System_Issue_Report__c = changeRequest.Id, Type_Of_Modification__c = 'Add', Component_Type__c = 'Page Layout', Component_Name__c = 'Account Layout', Object__c = 'Standard Object', Object_Name__c = 'Account'), true);    
        TestData.modification(new Modification__c(System_Issue_Report__c = changeRequest.Id, Type_Of_Modification__c = 'Add', Component_Type__c = 'Page Layout', Component_Name__c = 'Contact Layout', Object__c = 'Standard Object', Object_Name__c = 'Contact'), true);    
    }
    
    @isTest
    private static void createPackageFileFromCR() 
    { 
      
        List<Change_Request__c> changeRequests = [SELECT Id FROM Change_Request__c WHERE ID = :changeRequest.Id];
        
        Test.StartTest(); 
        PageReference pageRef = Page.CRPackageDotXMLBuilder; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(changeRequest.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(changeRequests);
        stdSetController.setSelected(changeRequests);
        CRPackageDotXMLBuilder cRPackageDotXMLBuilder = new CRPackageDotXMLBuilder(stdSetController);
        cRPackageDotXMLBuilder.sendPackageFile();
        Test.StopTest();
    }
}