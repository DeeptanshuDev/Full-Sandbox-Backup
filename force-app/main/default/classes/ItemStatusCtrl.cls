public with sharing class ItemStatusCtrl {
    
    public class CustomItemWrapper {
        public CustomItemWrapper(Custom_Item__c item, List<SelectOption> options) {
            this.Item = item;
            this.Options = options;
        }
        
        public Custom_Item__c Item { get; set; }
        public List<SelectOption> Options { get; set; }
    }
    
    public class StandardizedItemWrapper {
        public StandardizedItemWrapper(Standardized_Item__c item) {
            this.Item = item;
        }
        
        public Standardized_Item__c Item { get; set; }
    }
    
    public ItemStatusCtrl() {
        designRequestId = ApexPages.currentPage().getParameters().get('did');
        if (designRequestId != null) {
            try {
                Design_Request__c dr = new DesignRequestRepo().findById(designRequestId);
                opportunityId = dr.Opportunity__c;
                returnPageReference = new PageReference('/' + dr.Id);
            }
            catch (System.QueryException ex) {
                throw new ApplicationException('Unable to find or access the Opportunity.');
            }
        }
        else {
            opportunityId = ApexPages.currentPage().getParameters().get('oid');
            if (opportunityId != null) {
                try {
                    Opportunity opp = new OpportunityRepo().findById(opportunityId);
                    OpportunityName = opp.Name;
                    returnPageReference = new PageReference('/' + opp.Id);
                }
                catch (System.QueryException ex) {
                    throw new ApplicationException('Unable to find or access the Opportunity.');
                }
            }
        }
        
        initStandardizedItemWrappers();
        initStandardizedItemStatusOptions();
        initProfileValues();
        initCustomItemWrappers();
        initCustomItemStatusSelectOptions();
        initCustomItemStageOptions();
        initCustomItemStagetableOptions();
        initStandardizedItemStatusSelectOptions();
    }
    
    private Id opportunityId;
    private Id designRequestId;
    private Set<String> profileValues = new Set<String>();
    private Boolean useProfileValues = true;
    private PageReference returnPageReference;
    
    public String OpportunityName { get; set; }
    public List<SelectOption> StandardizedItemStatusOptions { get; set; }
    public List<StandardizedItemWrapper> StandardizedItemWrappers { get; set; }
    public List<CustomItemWrapper> CustomItemWrappers { get; set; }
    public List<SelectOption> CustomItemStatusSelectOptions { get; set; }
    public List<SelectOption> customItemStageOptions{get;set;}
    public List<SelectOption> customItemStagetableOptions{get;set;}
    public List<SelectOption> StandardizedItemStatusSelectOptions { get; set; }
    
    
    public PageReference save() {
        Map<Id, Standardized_Item__c> standardizedItemMap = new Map<Id, Standardized_Item__c>(
            new StandardizedItemRepo().findByOpportunityId(opportunityId));
        Set<Id> setOfStandardizedItemId = new Set<Id>();  
        for (StandardizedItemWrapper w : StandardizedItemWrappers) {
            Standardized_Item__c item = standardizedItemMap.get(w.Item.Id);
            if (item != null && w.Item.Stage__c == item.Stage__c) {
                standardizedItemMap.remove(item.Id);
            }
            else {
                setOfStandardizedItemId.add(item.Id);
                item.Stage__c = w.Item.Stage__c;
            }
        }
        if(setOfStandardizedItemId.size() > 0){
            for(Standardized_Item__c item : [SELECT Id,product__r.Name,product__r.Viewable_by_Sales__c FROM Standardized_Item__c WHERE Id IN: setOfStandardizedItemId]){
                if(item.product__r.Viewable_by_Sales__c == false){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This product is not eligible to add to an opportunity as Viewable by Sales is false for \''+ item.product__r.name+'\''));
                    return null;
                }    
            }  
        }
        
        Map<Id, Custom_Item__c> customItemMap = new Map<Id, Custom_Item__c>(
            new CustomItemRepo().findByOpportunity(opportunityId));
        for (CustomItemWrapper w : CustomItemWrappers) {
            Custom_Item__c item = customItemMap.get(w.Item.Id);
            if (item != null && w.Item.Design_Status__c == item.Design_Status__c
                && w.Item.Stage__c == item.Stage__c) {
                    customItemMap.remove(item.Id);
                }
            else {
                item.Design_Status__c = w.Item.Design_Status__c;
                item.Stage__c = w.Item.Stage__c;
            }
        }
        
        try{
            if (!standardizedItemMap.isEmpty()) {                  
                 update standardizedItemMap.values();      
            }
            if (!customItemMap.isEmpty()) {
                update customItemMap.values();
            }
            return returnPageReference;
         }
         catch(DMLException e){
                
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getdmlMessage(0)));
               return null;
         }
         
        
        
    }
    
    public PageReference cancel() {
        return returnPageReference;
    }
    
    private void initProfileValues() {
        User user1 = new UserRepo().findById(UserInfo.getUserId());
        String profileName = user1.Profile.Name;
        
        try {
            Item_Status__mdt itemStatusRecord = new ItemStatusRepo().findByLabel(profileName);
            System.debug('item record status are : ' + itemStatusRecord.Statuses__c);
            List<String> statuses = itemStatusRecord.Statuses__c.split(';');
            for(String obj : statuses)
            {
                System.debug('after split is  : '  + obj);
            }
            for (String status : statuses) {
                profileValues.add(status.trim().toLowerCase());
                System.debug('profile values are : ' + profileValues);
            }
        }
        catch (System.QueryException ex) {
            // no ItemStatus setting found. ok.
            System.debug('error which you were waiting for are: ' + ex);
            useProfileValues = false;
        }
    }
    
    private CustomItemWrapper makeCustomItemWrapper(Custom_Item__c item, List<Schema.PicklistEntry>
                                                    picklistEntries) {
                                                        List<SelectOption> options = new List<SelectOption>();
                                                        for (Schema.PicklistEntry pl : picklistEntries) {
                                                            String normalizedLabel = pl.label.trim().toLowerCase();
                                                            
                                                            if (((item.Design_Status__c != null && normalizedLabel == item.Design_Status__c.trim().toLowerCase())
                                                                 || profileValues.contains(normalizedLabel))
                                                                || !useProfileValues) {
                                                                    options.add(new SelectOption(pl.value, pl.label));
                                                                }
                                                        }
                                                        return new CustomItemWrapper(item, options);
                                                    }
    
    private void initStandardizedItemStatusOptions() {
        Schema.DescribeFieldResult standardizedItemStatusField =
            Schema.sObjectType.Standardized_Item__c.fields.Stage__c;
        StandardizedItemStatusOptions = new List<SelectOption>();
        for (Schema.PicklistEntry pl : standardizedItemStatusField.picklistValues) {
            StandardizedItemStatusOptions.add(new SelectOption(pl.value, pl.label));
        }
    }
    
    private void initCustomItemWrappers() {
        Schema.DescribeFieldResult customItemField =
            Schema.sObjectType.Custom_Item__c.fields.Design_Status__c;
        List<Schema.PicklistEntry> pickListEntries = customItemField.picklistValues;
        List<Custom_Item__c> customItems = new CustomItemRepo().findByOpportunity(opportunityId);
        CustomItemWrappers = new List<CustomItemWrapper>();
        for (Custom_Item__c item : CustomItems) {
            CustomItemWrappers.add(makeCustomItemWrapper(item, pickListEntries));
        }
    }
    
    private void initStandardizedItemWrappers() {
        StandardizedItemWrappers = new List<StandardizedItemWrapper>();
        for (Standardized_Item__c item :
             new StandardizedItemRepo().findByOpportunityId(opportunityId)) {
                 StandardizedItemWrappers.add(new StandardizedItemWrapper(item));
             }
    }
    
    private void initCustomItemStatusSelectOptions() {
        Schema.DescribeFieldResult customItemField =
            Schema.sObjectType.Custom_Item__c.fields.Design_Status__c;
        List<Schema.PicklistEntry> pickListEntries = customItemField.picklistValues;
        System.debug('picklist value are : ' + pickListEntries);
        CustomItemStatusSelectOptions = new List<SelectOption>();
        CustomItemStatusSelectOptions.add(new SelectOption('', 'Set all items to...'));
        for (Schema.PicklistEntry pl : pickListEntries) {
            //added by Deeptanshu just for checking
            System.debug('status valye aare : '  + pl);
            String normalizedLabel = pl.label.trim().toLowerCase();
            for(String obj : profileValues) 
            {
                System.debug('profile valies are ss: ' + obj);
                System.debug('normalized label are : ' + normalizedLabel);
            }
            
            System.debug('profile value profileValues.contains(normalizedLabel) are  : '+ profileValues.contains(normalizedLabel));
            System.debug('user profile value are :  ' + !useProfileValues);
            
            if (profileValues.contains(normalizedLabel) || !useProfileValues) {
                CustomItemStatusSelectOptions.add(new SelectOption(pl.value, pl.label));
            }
            //added by Deeptanshu for testing

            else
            {
                //CustomItemStatusSelectOptions.add(new SelectOption(pl.value, pl.label));			
                System.debug(normalizedLabel + ' this design status has not been added because of profile values');
            }
        }  
    }
    
    private void initCustomItemStageOptions() {
        Schema.DescribeFieldResult customItemField =
            Schema.sObjectType.Custom_Item__c.fields.Stage__c;
        List<Schema.PicklistEntry> pickListEntries = customItemField.picklistValues;
        customItemStageOptions = new List<SelectOption>();
        customItemStageOptions.add(new SelectOption('', 'Set all items to...'));
        for (Schema.PicklistEntry pl : pickListEntries) {
            String normalizedLabel = pl.label.trim().toLowerCase();
            if (profileValues.contains(normalizedLabel) || !useProfileValues) {
                customItemStageOptions.add(new SelectOption(pl.value, pl.label));
            }
        }
    }
    
    private void initCustomItemStagetableOptions() {
        Schema.DescribeFieldResult customItemStatusField =
            Schema.sObjectType.Custom_Item__c.fields.Stage__c;
        customItemStagetableOptions = new List<SelectOption>();
        for (Schema.PicklistEntry pl : customItemStatusField.picklistValues) {
            customItemStagetableOptions.add(new SelectOption(pl.value, pl.label));
        }
    }
    
    private void initStandardizedItemStatusSelectOptions() {
        Schema.DescribeFieldResult standardizedItemStatusField =
            Schema.sObjectType.Standardized_Item__c.fields.Stage__c;
        List<Schema.PicklistEntry> pickListEntries = standardizedItemStatusField.picklistValues;
        StandardizedItemStatusSelectOptions = new List<SelectOption>();
        StandardizedItemStatusSelectOptions.add(new SelectOption('', 'Set all items to...'));
        for (Schema.PicklistEntry pl : pickListEntries) {
            StandardizedItemStatusSelectOptions.add(new SelectOption(pl.value, pl.label));
        }
    }
}