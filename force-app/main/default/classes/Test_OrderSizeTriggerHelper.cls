/**
    * Obejctive -  Testing for OrderSizeTriggerHelper class
    * 
    * Created By - 
    * 
    * Created Date - 24-6-2020
    * 
    * Revision Log - V1.1 - Created.
**/
@isTest(SeeAllData=false)
private class Test_OrderSizeTriggerHelper {
    
    /**
        * @description   :  Method to insert data used in testing. 
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 24-6-2020
        * 
    * */
    @testSetup
    static void insertDataSetup(){
        Opportunity opp = TestData.opportunity(true);
        Account ac = new Account();
        ac.Name = 'Test';
        insert ac;
        Standardized_Item__c st = new Standardized_Item__c();
        st.Opportunity__c = opp.Id;
        st.Stated_Quantity__c = 2;
        st.Quantity__c = 1;
        st.Account_Lookup__c = ac.Id;
        insert st;
       
        //Records of Order_Sizes__c to insert
        List<Order_Sizes__c> orderSizeList = new List<Order_Sizes__c>();
        Order_Sizes__c orderSize1 = new Order_Sizes__c(Name='test1',standard_order__c =st.Id,  full_recommended_sizes__c='{"recommended":"ABC", "recommended_override":"TYRD", "edits":null}}}');
        orderSizeList.add(orderSize1);
        Order_Sizes__c orderSize2 = new Order_Sizes__c(Name='test2',Order_Overrides__c = true, full_recommended_sizes__c='{"recommended":"", "recommended_override":"B", "edits":null}}}');
        orderSizeList.add(orderSize2);
        Order_Sizes__c orderSize3 = new Order_Sizes__c(Name='test3', full_recommended_sizes__c='{"recommended":"DEF", "recommended_override":"", "edits":null}}}');
        orderSizeList.add(orderSize3);
        Order_Sizes__c orderSize4 = new Order_Sizes__c(Name='test4', full_recommended_sizes__c='{"recommended_override":"F", "edits":null}}}');
        orderSizeList.add(orderSize4);
        Order_Sizes__c orderSize5 = new Order_Sizes__c(Name='test5', full_recommended_sizes__c='{"measured":{"hip-front":"14.25","shoulder":"13.84","waist-front":"10.86","chest-front":"11.04","torso-front":"25.10","inseam":"49.74","inseam-default":"49.74","sleeve-top-default":"12.91","sleeve-bottom-default":"10.22","hip-side":"8.04","waist-side":"7.24","chest-side":"7.63","school-skirt-side-straight":"12.57","school-skirt-side-diag":"11.97","school-skirt-side-top":"4.63","school-skirt-side-bottom":"7.34","school-skirt-side":"11.97","all-star-skirt-side-straight":"11.46","all-star-skirt-side-diag":"10.82","all-star-skirt-side-top":"3.48","all-star-skirt-side-bottom":"7.34","all-star-skirt-side":"10.82","hip":34.44,"waist":26.25,"chest":30.48,"torso":57.27,"sleeve":24.4,"body":29.32,"capri":25.45,"school skirt":12.87,"all star skirt":10.31,"legging":"49.74"},"recommendations":{"f36572ad-ad41-4136-b337-f10ca9bf114e":{"success":false,"fit_id":"f36572ad-ad41-4136-b337-f10ca9bf114e","recommended":null,"error":"skip, style doesnt exist for style_id : f36572ad-ad41-4136-b337-f10ca9bf114e"}}}');
        orderSizeList.add(orderSize5);
        insert orderSizeList;
    }
    /**
        * @description   :  Method to test method populateReccomendedAndRecommendedOverride. 
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 24-6-2020
        * 
    * */
    @isTest
    static void test_OrderSizeTriggerHelper_Methods(){

        List<Order_Sizes__c> orderSizeList = [SELECT Id FROM Order_Sizes__c];
        System.assertEquals(5, orderSizeList.size());
        
        Order_Sizes__c test1 = [SELECT Id, Recommended__c, Recommended_Override__c, full_recommended_sizes__c FROM Order_Sizes__c WHERE Name='test1'];
        System.assertEquals('ABC', test1.Recommended__c);
        System.assertEquals('TYRD', test1.Recommended_Override__c);
        
        Order_Sizes__c test2 = [SELECT Id, Recommended__c, Recommended_Override__c, full_recommended_sizes__c FROM Order_Sizes__c WHERE Name='test2'];
        System.assertEquals(null, test2.Recommended__c);
        System.assertEquals('B', test2.Recommended_Override__c);
        
        Order_Sizes__c test3 = [SELECT Id, Recommended__c, Recommended_Override__c, full_recommended_sizes__c FROM Order_Sizes__c WHERE Name='test3'];
        System.assertEquals('DEF', test3.Recommended__c);
        System.assertEquals(null, test3.Recommended_Override__c);
        
        Order_Sizes__c test4 = [SELECT Id, Recommended__c, Recommended_Override__c, full_recommended_sizes__c FROM Order_Sizes__c WHERE Name='test4'];
        System.assertEquals(NULL, test4.Recommended__c);
        System.assertEquals('F', test4.Recommended_Override__c);
        
        Order_Sizes__c test5 = [SELECT Id, Recommended__c, Recommended_Override__c, full_recommended_sizes__c FROM Order_Sizes__c WHERE Name='test5'];
      
        test2.full_recommended_sizes__c = '{"recommended":"A", "recommended_override":"B", "edits":null}}}';
        
        update test2;
       
    }
}