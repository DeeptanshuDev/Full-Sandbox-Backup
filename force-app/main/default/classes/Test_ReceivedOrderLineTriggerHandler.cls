@isTest
private class Test_ReceivedOrderLineTriggerHandler {
    
    @TestSetup
  private static void setup() {
       SCMC__Received_Order__c sr = new SCMC__Received_Order__c();
        sr.SCMC__Account_Name__c = 'Test';
        insert sr;
        
        Product2 prod = new Product2(Name = 'Handling Fees', 
                                     Family = 'SCM Product Group');
        
        SCMC__Item__c si = new SCMC__Item__c();
        si.Name = 'Handling Fees';
        si.SCMC__Item_Description__c = 'Test';
        insert si;
        
        
        SCMC__Received_Order_Line__c sc = new SCMC__Received_Order_Line__c();
        sc.SCMC__Received_Order__c = sr.Id;
        sc.SCMC__Product_Name__c = 'Handling Fees';
        
        insert sc;
        
  }
    
    @isTest
    private static void testDiscountAmount() {
       List<SCMC__Received_Order_Line__c> sc = [select id from SCMC__Received_Order_Line__c];
    }
}