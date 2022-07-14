@isTest
private class StandardizedItemManager_T {


  @TestSetup
  private static void setup() {
    Opportunity opp = TestData.opportunity(true);

  }

  @isTest
  private static void setsShippingPerItem() {
      Opportunity opp = [SELECT Id FROM Opportunity][0];
      Account ac = new Account();
      ac.Name = 'Test';
      insert ac;
      Product2 prod = TestData.product(new Product2(
          Name = 'test prod',
          List_Price__c = 100
      ), true);
      Fit__c ff = new Fit__c();
      ff.Name = 'Custom Kicks Shoe - High Top';
      insert ff;
      
      test.startTest();
      
      Standardized_Item__c st = new Standardized_Item__c();
      st.Opportunity__c = opp.Id;
      st.Stated_Quantity__c = 2;
      st.Quantity__c = 1;
      st.Account_Lookup__c = ac.Id;
      st.Is_Submitted__c = 'true';
      st.FF_Create_Item_Successful__c = true;
      st.order_id__c = 'sfsds';
     
      insert st;
      
      standardized_Item__c st1 = new standardized_Item__c();
      st1.Opportunity__c = opp.Id;
      st1.stated_Quantity__c = 2;
      st1.Quantity__c = 2;
      st1.Account_Lookup__c = ac.Id;
      st1.Is_Submitted__c = 'false';
      st1.FF_Create_Item_Successful__c = false;
      
      st1.Style__c = 'Custom Kicks Shoe - High Top';
      insert st1;
      
      
      Standardized_Item__c item = [SELECT Shipping_per_Item__c FROM Standardized_Item__c][1];
      item.is_submitted__c = 'true';
      update item;
      
      test.stopTest();
      
      List<Opportunity> opp2 = [SELECT Id,Max_Quantity_on_Custom_Items__c FROM Opportunity WHERE Id =:opp.Id LIMIT 1];
      System.assertEquals(opp2[0].Max_Quantity_on_Custom_Items__c,2,'Max quantity error');
  }
    
}