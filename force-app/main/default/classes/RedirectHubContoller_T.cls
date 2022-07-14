@isTest
private  class RedirectHubContoller_T {
    
    static Opportunity opp;
    
    static {
        opp = TestData.opportunity(true);
    }
    
    @isTest
    private static void navigateToNewDesignRequest() {
        
        PageReference pageRef = Page.RedirectHub;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oppId',opp.id);
        
        Test.startTest();
        
        RedirectHubContoller redirectHubCon = new RedirectHubContoller();
        PageReference urlForNavigation =  redirectHubCon.navigateToNewDesignRequest();
        
        opp.Custom_Item_Numbers__c = '90';
        update opp;
       
        urlForNavigation =  redirectHubCon.navigateToNewDesignRequest();
        
        redirectHubCon.theme = 'Theme4d';
        urlForNavigation =  redirectHubCon.navigateToNewDesignRequest();
        
        delete opp;
        
        urlForNavigation =  redirectHubCon.navigateToNewDesignRequest();
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        system.assertEquals(2, msgs.size());
       
        Test.stopTest(); 
    }
}