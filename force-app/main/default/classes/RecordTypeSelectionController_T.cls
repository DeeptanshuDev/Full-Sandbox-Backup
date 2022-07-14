@isTest
private  class RecordTypeSelectionController_T {
    
   
    @isTest
    private static void navigateToNewDesignRequest() {
        Test.startTest();
       
        RecordTypeSelectionController.getRecordType('Opportunity');
       RecordTypeSelectionController.getDefaultRecordType('Opportunity');
        Test.stopTest(); 
    }
}