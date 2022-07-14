@isTest
private class CustomItemStatus_T {
    
    @TestSetup
    private static void setup() {
        Opportunity opp = TestData.opportunity(true);
    }
    
    
    @isTest
    private static void designUpdate() {
         
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
      
        Design_Request__c request = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
                                                           true);
        
        Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id,
            Design_Request__c = request.Id
        ), true);
        
        Design_Round__c round = TestData.designRound(new Design_Round__c(
            Design_Request__c = request.Id,
            Version__c = '1'
        ), true);
        
        Design__c design = TestData.design(new Design__c(
            Design_Round__c = round.Id,
            Design_Request__c = request.Id
        ), true);
        
        TestData.designItem(new Design_Item__c(
            Design__c = design.Id,
            Custom_Item__c = customItem.Id
        ), true);
         Test.stopTest();
        
        design = [SELECT Id FROM Design__c LIMIT 1];
        design.Needs_Pricing__c = true;
        CustomItemNotifications.disableNotifications = true;
        update design;
        
       
        customItem = [SELECT Id, Design_Status__c FROM Custom_Item__c LIMIT 1];
        
        //System.assertEquals('(D) In Pricing', customItem.Design_Status__c);
    }
    
    @isTest
    private static void designRoundPricingCompleteChange() {
        
        Test.startTest();
        
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Design_Request__c request = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
                                                           true);
        
        Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id,
            Design_Request__c = request.Id
        ), true);
        
        Design_Round__c round = TestData.designRound(new Design_Round__c(
            Design_Request__c = request.Id,
            Version__c = '1'
        ), true);
        Design__c design = TestData.design(new Design__c(
            Design_Round__c = round.Id,
            Design_Request__c = request.Id)
                                           , true);
        
        TestData.designItem(new Design_Item__c(
            Design__c = design.Id,
            Custom_Item__c = customItem.Id
        ), true);
        
        CustomItemNotifications.disableNotifications = true;
        round.Pricing_Complete__c = true;
       // update round;
        
        Test.stopTest();
          customItem = [SELECT Id, Design_Status__c FROM Custom_Item__c LIMIT 1];
       // System.assertEquals('(D) Initial Art Completed and Sent', customItem.Design_Status__c);
    }
    
    @isTest
    private static void designRoundArtApprovalSentChange() {
        
        Test.startTest();
        
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Design_Request__c request = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
                                                           true);
        
        Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id,
            Design_Request__c = request.Id
        ), true);
        
        Design_Round__c round = TestData.designRound(new Design_Round__c(
            Design_Request__c = request.Id,
            Version__c = '1'
        ), true);
        Design__c design = TestData.design(new Design__c(
            Design_Round__c = round.Id,
            Design_Request__c = request.Id)
                                           , true);
        
        TestData.designItem(new Design_Item__c(
            Design__c = design.Id,
            Custom_Item__c = customItem.Id
        ), true);
        CustomItemNotifications.disableNotifications = true;
        round.Art_Approval_Sent__c = true;
        update round;
        
        customItem = [SELECT Id, Design_Status__c FROM Custom_Item__c LIMIT 1];
        
        Test.stopTest();
        
        //System.assertEquals('Art Approval Sent', customItem.Design_Status__c);
        
    }
    
    @isTest
    private static void designRoundApprovedArtChange() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        
        Design_Request__c request = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
                                                           true);
        
        Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id,
            Design_Request__c = request.Id
        ), true);
        
        Design_Round__c round = TestData.designRound(new Design_Round__c(
            Design_Request__c = request.Id,
            Version__c = '13'
        ), true);
        Design__c design = TestData.design(new Design__c(
            Design_Round__c = round.Id,
            Design_Request__c = request.Id)
                                           , true);
        
        TestData.designItem(new Design_Item__c(
            Design__c = design.Id,
            Custom_Item__c = customItem.Id
        ), true);
      
        CustomItemNotifications.disableNotifications = true; 
        
        design.Approved_Art__c = true;
       // update design;
        
        Test.stopTest();
        customItem = [SELECT Id, Design_Status__c FROM Custom_Item__c LIMIT 1];

       // System.assertEquals('(S) Proto Revision Artwork Approved, Proto Change Form Attached', customItem.Design_Status__c);
    }
    
    
    @isTest
    private static void designRoundNeedsPricingChange() {
         Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        
       
        Design_Request__c request = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
                                                           true);
        
        Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id,
            Design_Request__c = request.Id
        ), true);
        
        Design_Round__c round = TestData.designRound(new Design_Round__c(
            Design_Request__c = request.Id,
            Version__c = '1'
        ), true);
        Design__c design = TestData.design(new Design__c(
            Design_Round__c = round.Id,
            Needs_Pricing__c = false,
            Design_Request__c = request.Id)
                                           , true);
        
        TestData.designItem(new Design_Item__c(
            Design__c = design.Id,
            Custom_Item__c = customItem.Id
        ), true);
        CustomItemNotifications.disableNotifications = true;
        design.Needs_Pricing__c = true;
        update design;
        
        customItem = [SELECT Id, Design_Status__c FROM Custom_Item__c LIMIT 1];
        
        Test.stopTest();
        
        //System.assertEquals('(D) In Pricing', customItem.Design_Status__c);
    }
    
    @isTest
    private static void designRoundArtworkApprovedChange() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        
        
        Design_Request__c request = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
                                                           true);
        
        Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id,
            Design_Request__c = request.Id
        ), true);
        
        Design_Round__c round = TestData.designRound(new Design_Round__c(
            Design_Request__c = request.Id,
            Version__c = '1'
        ), true);
        Design__c design = TestData.design(new Design__c(
            Design_Round__c = round.Id,
            Design_Request__c = request.Id)
                                           , true);
        
        TestData.designItem(new Design_Item__c(
            Design__c = design.Id,
            Custom_Item__c = customItem.Id
        ), true);
        CustomItemNotifications.disableNotifications = true;
        round.Artwork_Approved__c = true;
        //update round;
        
       
        Test.stopTest();
         customItem = [SELECT Id, Design_Status__c FROM Custom_Item__c LIMIT 1];
        
        //System.assertEquals('(S) Artwork Approved', customItem.Design_Status__c);
    }
    
    @isTest
    private static void designRoundPrototypeCommentsPostedChange() {
        
        Test.startTest();
        
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Design_Request__c request = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
                                                           true);
        
        Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id,
            Design_Request__c = request.Id
        ), true);
        
        Design_Round__c round = TestData.designRound(new Design_Round__c(
            Design_Request__c = request.Id,
            Version__c = '1'
        ), true);
        Design__c design = TestData.design(new Design__c(
            Design_Round__c = round.Id,
            Design_Request__c = request.Id)
                                           , true);
        
        TestData.designItem(new Design_Item__c(
            Design__c = design.Id,
            Custom_Item__c = customItem.Id
        ), true);
        CustomItemNotifications.disableNotifications = true;
        round.Version__c = '12';
        round.Revision_Comments_Posted__c = true;
        update round;
        

        Test.stopTest();
                customItem = [SELECT Id, Design_Status__c FROM Custom_Item__c LIMIT 1];
        
    }
    
    @isTest
    private static void designRoundCommentsPostedChange() {
        
        Test.startTest();
        
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Design_Request__c request = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
                                                           true);
        
        Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id,
            Design_Request__c = request.Id
        ), true);
        
        Design_Round__c round = TestData.designRound(new Design_Round__c(
            Design_Request__c = request.Id,
            Version__c = '1'
        ), true);
        Design__c design = TestData.design(new Design__c(
            Design_Round__c = round.Id,
            Design_Request__c = request.Id)
                                           , true);
        
        TestData.designItem(new Design_Item__c(
            Design__c = design.Id,
            Custom_Item__c = customItem.Id
        ), true);
        CustomItemNotifications.disableNotifications = true;
        round.Revision_Comments_Posted__c = true;
        update round;
        
        customItem = [SELECT Id, Design_Status__c FROM Custom_Item__c LIMIT 1];
        
        Test.stopTest();
        
        //System.assertEquals('(S) Revision Comments Sent, Waiting for Revised Art',customItem.Design_Status__c);
    }
    
    @isTest
    private static void designRequestAssignedDesignerChange() {
        
        Test.startTest();
        
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Design_Request__c request = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
                                                           true);
        
        Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id,
            Design_Request__c = request.Id
        ), true);
        
        Design_Round__c round = TestData.designRound(new Design_Round__c(
            Design_Request__c = request.Id,
            Version__c = '1'
        ), true);
        Design__c design = TestData.design(new Design__c(
            Design_Round__c = round.Id,
            Design_Request__c = request.Id)
                                           , true);
        
        TestData.designItem(new Design_Item__c(
            Design__c = design.Id,
            Custom_Item__c = customItem.Id
        ), true);
        CustomItemNotifications.disableNotifications = true;
        request.Assigned_Designer__c = UserInfo.getUserId();
        update request;
        
        customItem = [SELECT Id, Design_Status__c FROM Custom_Item__c LIMIT 1];
        
        Test.stopTest();
        
        //System.assertEquals('Initial Art in Process',customItem.Design_Status__c);
    }
    
    @isTest
    private static void multipleDesignRounds() {
        
    }
}