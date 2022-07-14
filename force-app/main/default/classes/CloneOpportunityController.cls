public without sharing class CloneOpportunityController {
    
    public class ItemWrapper {
        public Double quantity { get; set; }
        public String Id { get; set; }
        // public Custom_Item__c Item { get; set; }
        
        public ItemWrapper() {}
        
        public ItemWrapper(Custom_Item__c item) {
            this.quantity = item.Quantity__c;
            this.Id = item.Id;
            // this.Item = item;
        }
    }
    
    public List<ItemWrapper> Items { get; set; }
    
    private final Opportunity opp;
    
    @AuraEnabled
    public static Boolean checkCommunityUser() {
    	GenericUtils.checkCommunityUser();
        System.debug('@@@@@ ' + GenericUtils.isCommunityUser);
        return GenericUtils.isCommunityUser;
    }
    
    @AuraEnabled
    public static LightningResponseEntity doClone(String oppDataWrap, String customItemWrap) {
         LightningResponseEntity genericResponse = new LightningResponseEntity();
        try {
            List<ItemWrapper> items = new List<ItemWrapper>();
            if(String.isNotBlank(customItemWrap)) {
                items = (List<ItemWrapper>)JSON.deserialize(customItemWrap, List<ItemWrapper>.class);
            }
            Map<String,Object> oppData = new Map<String,Object>();
            
            if(String.isNotBlank(oppDataWrap)) {
                oppData = (Map<String,Object>)JSON.deserializeUntyped(oppDataWrap);
            }
            
            Object closeDate = oppData.containsKey('CloseDate')?oppData.get('CloseDate'):null;
            Date updatedCloseDate;
            if(closeDate != null) {
                if (String.valueOf(closeDate).contains('Z')) {
                    DateTime dt = GenericUtils.isoTime2DateTime(String.valueOf(closeDate));
                    updatedCloseDate = dt.date();
                }
                else {
                    String dateValue = String.valueOf(closeDate);
                    try {
                        updatedCloseDate = Date.parse(dateValue);
                    }
                    catch (Exception e) {
                        if (!dateValue.contains(':')) {
                            dateValue += ' 00:00:00';
                        }
                        updatedCloseDate = Date.valueOf(dateValue);
                    }
                }
            }
            
            CustomOpportunity__c custOpp = new CustomOpportunity__c();
            custOpp.opportunityId__c = oppData.containsKey('id')?String.valueOf(oppData.get('id')):null;
            custOpp.CloseDate__c = updatedCloseDate;
            custOpp.FactoryShipTo__c = oppData.containsKey('Factory_Ship_To__c')?String.valueOf(oppData.get('Factory_Ship_To__c')):null;
            custOpp.JsonData__c = JSON.serialize(items);
            insert custOpp;
            
            genericResponse.setBody('Success');
        } catch(Exception e) {
            genericResponse.setError(e.getMessage());
        }
        return genericResponse;
    }
}