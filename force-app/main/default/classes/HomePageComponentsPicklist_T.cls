@isTest
private  class HomePageComponentsPicklist_T {
    
   
    @isTest
    private static void navigateToNewDesignRequest() {
        Test.startTest();
       HomePageComponentsPicklist hp= new HomePageComponentsPicklist();
        hp.getDefaultValue();
       hp.getValues();
        Test.stopTest(); 
    }
}