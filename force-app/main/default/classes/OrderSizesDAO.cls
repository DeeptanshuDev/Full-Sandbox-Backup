public class OrderSizesDAO {
    
    public static List<order_sizes__c> getOrderSizes(Set<Id> setCustomItems){
        
        Return [SELECT Id,Gender__c,Order__c FROM order_sizes__c WHERE Order__c IN: setCustomItems];
    }
    
    public static List<order_sizes__c> getOrderSizesWithStandardOrder(Set<Id> setStdItems ){
        
        return [SELECT Id,Gender__c,standard_order__c FROM order_sizes__c WHERE standard_order__c IN: setStdItems];
        
    }
    
   
        
        

}