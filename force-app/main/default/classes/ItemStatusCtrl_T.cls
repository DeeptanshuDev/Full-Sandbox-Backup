@isTest
private class ItemStatusCtrl_T {
    
    @testSetup
    private static void setup() {
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name = :ProfileConstants.REBEL_SALES_USER];
        User user1 = TestData.user(new User(ProfileId = salesProfile.Id), true);
        Opportunity opp = TestData.Opportunity(new Opportunity(OwnerId = user1.Id), true);
        TestData.standardizedItem(new Standardized_Item__c(
            Opportunity__c = opp.Id
            , Stage__c = 'Potential / Artwork'
        ), true);
    }
    
    @isTest
    private static void onlyProfileAccessibleCustomItemStatuses() {
        Opportunity opp = [SELECT Id FROM Opportunity];
        TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id
        ), true);
        PageReference pr = Page.ItemStatus;
        pr.getParameters().put('oid', opp.Id);
        Test.setCurrentPage(pr);
        List<SelectOption> options;
        
        System.runAs([SELECT Id FROM User Where Username = 'oelcjsue@ggklekd.com.testfake'][0]) {
            ItemStatusCtrl ctrl = new ItemStatusCtrl();
            options = ctrl.CustomItemStatusSelectOptions;
        }
        final String IN_PRICING = '(d) in pricing';
        Boolean containsIllegalValue = false;
        for (SelectOption so : options) {
            if (so.getValue().trim().toLowerCase() == IN_PRICING) {
                containsIllegalValue = true;
                break;
            }
        }
        System.assert(!containsIllegalValue, 'Custom Item Statuses should only have values allowed by '
                      + 'profile');
    }
    
    @isTest
    private static void onlyProfileAccessibleCustomItemWrapperStatuses() {
        Opportunity opp = [SELECT Id FROM Opportunity];
        TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id
        ), true);
        PageReference pr = Page.ItemStatus;
        pr.getParameters().put('oid', opp.Id);
        Test.setCurrentPage(pr);
        List<SelectOption> options;
        
        System.runAs([SELECT Id FROM User Where Username = 'oelcjsue@ggklekd.com.testfake'][0]) {
            ItemStatusCtrl ctrl = new ItemStatusCtrl();
            options = ctrl.CustomItemWrappers.get(0).Options;
        }
        final String IN_PRICING = '(d) in pricing';
        Boolean containsIllegalValue = false;
        for (SelectOption so : options) {
            if (so.getValue().trim().toLowerCase() == IN_PRICING) {
                containsIllegalValue = true;
                break;
            }
        }
        System.assert(!containsIllegalValue, 'Custom Item Wrapper Statuses should only have values' +
                      + ' allowed by profile');
    }
    
    @isTest
    private static void nonProfileAccessibleCustomItemStatusAvailable() {
        final String IN_PRICING = '(d) in pricing';
        Opportunity opp = [SELECT Id FROM Opportunity];
        TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id
            , Design_Status__c = IN_PRICING
        ), true);
        PageReference pr = Page.ItemStatus;
        pr.getParameters().put('oid', opp.Id);
        Test.setCurrentPage(pr);
        List<SelectOption> options;
        
        System.runAs([SELECT Id FROM User Where Username = 'oelcjsue@ggklekd.com.testfake'][0]) {
            ItemStatusCtrl ctrl = new ItemStatusCtrl();
            options = ctrl.CustomItemWrappers.get(0).Options;
        }
        Boolean containsIllegalValue = false;
        for (SelectOption so : options) {
            if (so.getValue().trim().toLowerCase() == IN_PRICING) {
                containsIllegalValue = true;
                break;
            }
        }
        System.assert(containsIllegalValue, 'Custom Item Wrapper Statuses should includ non-profile' +
                      + ' accessible value if the Item\'s current status usually not accessible by the profile.');
    }
    
    @isTest
    private static void saveReturnsPageReference() {
        Opportunity opp = [SELECT Id FROM Opportunity];
        TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id
            , Design_Status__c = '(S) Hold - Not Ready for Designer Assignment'
        ), true);
        
        PageReference pr = Page.ItemStatus;
        pr.getParameters().put('oid', opp.Id);
        Test.setCurrentPage(pr);
        
        ItemStatusCtrl ctrl = new ItemStatusCtrl();
        ctrl.CustomItemWrappers.get(0).Item.Design_Status__c = 'Initial Art in Process';
        ctrl.CustomItemWrappers.get(0).Item.Stage__c = 'Confirmed';
        ctrl.StandardizedItemWrappers.get(0).Item.Stage__c = 'Prototype';
        pr = ctrl.save();
       
        List<Custom_Item__c> customItems = [SELECT Design_Status__c, Stage__c FROM Custom_Item__c];
       
        List<Standardized_Item__c> standardizedItems = [SELECT Stage__c FROM Standardized_Item__c];
        
    }
}