@isTest
private  class CustomLinkRetrieveController_T {
    
   
    @isTest
    private static void navigateToNewDesignRequest() {
        Test.startTest();
        List<Home_Page_Component__mdt> homes = [select id,Label from Home_Page_Component__mdt];
        CustomLinkRetrieveController cc = new CustomLinkRetrieveController();
        
        CustomLinkRetrieveController.getCustomLinksDetails('custom Links');
       
        Test.stopTest(); 
    }
}