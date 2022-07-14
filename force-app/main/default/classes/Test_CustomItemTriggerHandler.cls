/**
    * Obejctive -  Testing for CustomItemTriggerHandler class
    * 
    * Created By - 
    * 
    * Created Date - 24-6-2020
    * 
    * Revision Log - V1.1 - Created.
**/
@isTest(SeeAllData=false)
private class Test_CustomItemTriggerHandler {
    
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
    static void testDataSetup(){
        
        //Records List of Account to insert
        List<Account> accountList = new List<Account>();
        
        //Records List of Contact to insert
        List<Contact> contactList = new List<Contact>();
        
        //Records List of Opportunity to insert
        List<Opportunity> opportunityList = new List<Opportunity>();
        
        //Records List of Fit__c to insert
        List<Fit__c> fitList = new List<Fit__c>();
        
        //Records List of Standardized_Item__c to insert
        List<Standardized_Item__c> standardizedItemList = new List<Standardized_Item__c>();
        
        Fit__c fit1 = new Fit__c(Name='Custom Kicks Shoe - Slip On');
        fitList.add(fit1);
        Fit__c fit2 = new Fit__c(Name='ZHS – Zip Hoodie Sweatshirt');
        fitList.add(fit2);
        Fit__c fit3 = new Fit__c(Name='fitTest3');
        fitList.add(fit3);
        insert fitList;
        
        System.assertEquals(3, fitList.size());
        
        Account acc1 = new Account(Name='accTest1', Phone='8949519191', Type ='Other');
        accountList.add(acc1);
        Account acc2 = new Account(Name='accTest2', Phone='8949519192', Type ='Other');
        accountList.add(acc2);
        Account acc3 = new Account(Name='accTest3', Phone='8949519193', Type ='Other');
        accountList.add(acc3);
        Account acc4 = new Account(Name='accTest4', Phone='8949519194', Type ='Other');
        accountList.add(acc4);
        insert accountList;
        
        System.assertEquals(4, accountList.size());
        
        Contact con1 = new Contact(LastName='conTest1', Preferred_Phone__c='Phone', Email ='sandeep1@gmail.com', AccountId=acc1.Id);
        contactList.add(con1);
        Contact con2 = new Contact(LastName='conTest2', Preferred_Phone__c='Phone', Email ='sandeep2@gmail.com', AccountId=acc2.Id);
        contactList.add(con2);
        Contact con3 = new Contact(LastName='conTest3', Preferred_Phone__c='Phone', Email ='sandeep3@gmail.com', AccountId=acc3.Id);
        contactList.add(con3);
        Contact con4 = new Contact(LastName='conTest4', Preferred_Phone__c='Phone', Email ='sandeep4@gmail.com', AccountId=acc4.Id);
        contactList.add(con4);
        insert contactList;
        
        System.assertEquals(4, contactList.size());
        
        Opportunity opp1 = new Opportunity(Name='oppTest1', Type='New Order', AccountId=acc1.Id, CloseDate= system.today(), Category_Picklist__c='School', StageName='Open', Primary_Contact__c=con1.Id);
        opportunityList.add(opp1);
        Opportunity opp2 = new Opportunity(Name='oppTest2', Type='New Order', AccountId=acc2.Id, CloseDate= system.today(), Category_Picklist__c='School', StageName='Open', Primary_Contact__c=con2.Id);
        opportunityList.add(opp2);
        Opportunity opp3 = new Opportunity(Name='oppTest3', Type='New Order', AccountId=acc3.Id, CloseDate= system.today(), Category_Picklist__c='School', StageName='Open', Primary_Contact__c=con3.Id);
        opportunityList.add(opp3);
        Opportunity opp4 = new Opportunity(Name='oppTest4', Type='New Order', AccountId=acc4.Id, CloseDate= system.today(), Category_Picklist__c='School', StageName='Open', Primary_Contact__c=con4.Id);
        opportunityList.add(opp4);
        insert opportunityList;
        
        System.assertEquals(4, opportunityList.size());
        
        Standardized_Item__c stItem1 = new Standardized_Item__c(order_id__c='order1', FF_Create_Item_Successful__c=true, 
                                                                is_submitted__c='true', Opportunity__c=opp1.Id, Quantity__c=8, Stated_Quantity__c=8);
        standardizedItemList.add(stItem1);
        Standardized_Item__c stItem2 = new Standardized_Item__c(order_id__c='order2', FF_Create_Item_Successful__c=false, 
                                                                is_submitted__c='true', Opportunity__c=opp2.Id, Quantity__c=10, Stated_Quantity__c=10);
        standardizedItemList.add(stItem2);
        Standardized_Item__c stItem3 = new Standardized_Item__c(order_id__c='order3', FF_Create_Item_Successful__c=true, 
                                                                is_submitted__c='true', Opportunity__c=opp3.Id, Quantity__c=12, Stated_Quantity__c=12);
        standardizedItemList.add(stItem3);
        Standardized_Item__c stItem4 = new Standardized_Item__c(FF_Create_Item_Successful__c=false, is_submitted__c='false', 
                                                                Opportunity__c=opp3.Id, Quantity__c=12, Stated_Quantity__c=12);
        standardizedItemList.add(stItem4);
        insert standardizedItemList;
        
        System.assertEquals(4, standardizedItemList.size());
        
    }
    /**
        * @description   :  Method to test method before insert. 
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 24-6-2020
        * 
    * */
    @isTest
    static void testMethod_beforeInsert(){

        Test.startTest();
        
        List<Opportunity> oppList = [SELECT Id FROM Opportunity];
        
        Custom_Item__c cItem1 = new Custom_Item__c(Name='cItemTest1', FF_Reorder_Sizing__c=true, order_id__c='order1', 
                                                   FF_Create_Item_Successful__c=false, is_submitted__c='true', 
                                                   Style__c='Custom Kicks Shoe - High Top', Category__c='Gymnastics', 
                                                   Design_Status__c='Confirmed to Send', Gender__c='Boy', Fabric_Options__c='Mistique', 
                                                   Opportunity__c=oppList[0].Id, Product_Style__c='Custom Bow', Quantity__c=8, 
                                                   Stated_Quantity__c=8, Price_per_item__c=500);
        insert cItem1;
        
        List<Custom_Item__c> customItemList = [SELECT Id, Style__c, FF_Style__c, order_id__c FROM Custom_Item__c];
        
        System.assertEquals('order1', customItemList[0].order_id__c);
        System.assertEquals('Custom Kicks Shoe - High Top', customItemList[0].Style__c);
        System.assertEquals('Custom Kicks Shoe - High Top', customItemList[0].FF_Style__c);
        
        Test.stopTest();
    }
    /**
        * @description   :  Method to test method before update. 
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 25-6-2020
        * 
    * */
    @isTest
    static void testMethod_beforeUpdate(){
        
        Test.startTest();
        
        List<Opportunity> oppList = [SELECT Id FROM Opportunity];
        
         Design_Request__c dr = TestData.designRequest(new Design_Request__c(Opportunity__c = oppList[0].Id),
      true);
        
        Custom_Item__c cItem1 = new Custom_Item__c(Name='cItemTest1', FF_Reorder_Sizing__c=true, order_id__c='order1', 
                                                   FF_Create_Item_Successful__c=false, is_submitted__c='true', 
                                                   Style__c='Custom Kicks Shoe - High Top', Category__c='Gymnastics', 
                                                   Design_Status__c='(P) Dye-Sub Strike Off Drop Shipped to Customer', Gender__c='Boy', 
                                                   Fabric_Options__c='Mistique', Opportunity__c=oppList[0].Id, Product_Style__c='Custom Bow', 
                                                   Quantity__c=8, Stated_Quantity__c=8, Price_per_item__c=500,Design_Request__c = dr.Id);
        insert cItem1;
        
        cItem1.Style__c='Custom Kicks Shoe - Slip On';
        
        update cItem1;
        
        Custom_Item__c cItemList = [SELECT Id, Style__c, FF_Style__c FROM Custom_Item__c WHERE order_id__c='order1'];
        System.assertEquals('Custom Kicks Shoe - Slip On', cItemList.Style__c);
        System.assertEquals('Custom Kicks Shoe - High Top', cItemList.FF_Style__c);
        
        Test.stopTest();
        
    }
    /**
        * @description   :  Method to test method after insert. 
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 25-6-2020
        * 
    * */
    @isTest
    static void testMethod_afterInsert(){
        
        //Records List of Custom_Item__c to insert
        List<Custom_Item__c> customItemList = new List<Custom_Item__c>();
        
        Test.startTest();
        
        List<Standardized_Item__c> stItemsList = [SELECT Id, Opportunity__r.Id, order_id__c FROM Standardized_Item__c];
        
        for(Standardized_Item__c sItm : stItemsList){
            if(sItm.order_id__c =='order1'){
                Custom_Item__c cItem1 = new Custom_Item__c(Name='cItemTest1', order_id__c='order1', 
                                                           FF_Create_Item_Successful__c=false, is_submitted__c='true', 
                                                           Style__c='Custom Kicks Shoe - Slip On', Category__c='Pro', 
                                                           Design_Status__c='Confirmed to Send', Gender__c='Girl', Fabric_Options__c='Mistique', 
                                                           Opportunity__c=sItm.Opportunity__r.Id, Product_Style__c='Uniform', Quantity__c=10, 
                                                           Stated_Quantity__c=10, Price_per_item__c=50);
                customItemList.add(cItem1);
            }
            if(sItm.order_id__c =='order2'){
                Custom_Item__c cItem2 = new Custom_Item__c(Name='cItemTest2', order_id__c='order2', 
                                                           FF_Create_Item_Successful__c=false, is_submitted__c='true', 
                                                           Style__c='ZHS – Zip Hoodie Sweatshirt', Category__c='Gymnastics', 
                                                           Design_Status__c='Confirmed to Send', Gender__c='Boy', Fabric_Options__c='Mistique', 
                                                           Opportunity__c=sItm.Opportunity__r.Id, Product_Style__c='Uniform', Quantity__c=12, 
                                                           Stated_Quantity__c=12, Price_per_item__c=5);
                customItemList.add(cItem2);
            }
        }
        
        insert customItemList;
        
        System.assertEquals(2, customItemList.size());
        
        customItemList[0].FF_Create_Item_Successful__c = true;
        customItemList[1].FF_Create_Item_Successful__c = true;
        
        update customItemList;
        
        Custom_Item__c cItemList = [SELECT Id, Name, Opportunity__r.Id, Account_Lookup__c, 
                                    FF_Reorder_Sizing__c FROM Custom_Item__c WHERE order_id__c='order1' AND FF_Create_Item_Successful__c=true 
                                    AND FF_Is_Submitted__c = true];
        
        Opportunity oppTestAccField = [SELECT Id, Create_AFS__c, AccountId FROM Opportunity WHERE Id=:cItemList.Opportunity__r.Id];
        
        System.assertEquals(true, oppTestAccField.Create_AFS__c);
        System.assertEquals(oppTestAccField.AccountId, cItemList.Account_Lookup__c);
        
        Custom_Item__c customItem3 = [SELECT Id, Name, Account_Lookup__c, Opportunity__r.Id, FF_Reorder_Sizing__c 
                                      FROM Custom_Item__c WHERE order_id__c='order2'];
        
        Opportunity oppTestField2 = [SELECT Id, Create_AFS__c, AccountId FROM Opportunity WHERE Id=:customItem3.Opportunity__r.Id];
        System.assertEquals(false, oppTestField2.Create_AFS__c);
        System.assertEquals(oppTestField2.AccountId, customItem3.Account_Lookup__c);
        
        Test.stopTest();
        
    }
    /**
        * @description   :  Method to test method updateFitOnCustomItem. 
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 29-6-2020
        * 
    * */
    @isTest
    static void testMethod_updateFitOnCustomItem(){
        
        //Records List of Custom_Item__c to insert
        List<Custom_Item__c> customItemList = new List<Custom_Item__c>();
        
        List<Opportunity> oppList = [SELECT Id FROM Opportunity];
        
        Custom_Item__c csItem2 = new Custom_Item__c(Name='cItemTest2', FF_Reorder_Sizing__c=false, order_id__c='order2', 
                                                    FF_Create_Item_Successful__c=false, is_submitted__c='true', 
                                                    Style__c='Custom Kicks Shoe - Slip On', Category__c='Pro', 
                                                    Design_Status__c='Confirmed to Send', Gender__c='Girl', Fabric_Options__c='Mistique', 
                                                    Opportunity__c=oppList[1].Id, Product_Style__c='Uniform', Quantity__c=10, 
                                                    Stated_Quantity__c=10, Price_per_item__c=50);
        customItemList.add(csItem2);
        
        Test.startTest();
        
        insert customItemList;
        
        System.assertEquals(1, customItemList.size());
        
        Fit__c fitList = [SELECT Id, Name FROM Fit__c WHERE Name=:csItem2.Style__c];
        
        System.assertEquals('Custom Kicks Shoe - Slip On', fitList.Name);
        
        Custom_Item__c cItemList = [SELECT Id, Name, Opportunity__r.Id, Opportunity__c, Account_Lookup__c, order_id__c, Fit__c, 
                                    FF_Reorder_Sizing__c FROM Custom_Item__c WHERE order_id__c='order2' AND FF_Create_Item_Successful__c=false 
                                    AND FF_Is_Submitted__c = true];
        
        System.assertEquals(fitList.Id, cItemList.Fit__c);
        
        csItem2.Style__c = 'ZHS – Zip Hoodie Sweatshirt';
        
        update csItem2;
        
        Fit__c fit2 = [SELECT Id, Name FROM Fit__c WHERE Name='ZHS – Zip Hoodie Sweatshirt'];
        
        Custom_Item__c cItemUpdated = [SELECT Id, Name, Opportunity__r.Id, Opportunity__c, Account_Lookup__c, order_id__c, Fit__c, 
                                    FF_Reorder_Sizing__c FROM Custom_Item__c WHERE order_id__c='order2' AND FF_Create_Item_Successful__c=false 
                                    AND FF_Is_Submitted__c = true];
        

        Test.stopTest();
    }
    /**
        * @description   :  Method to test method after update. 
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 27-6-2020
        * 
    * */
    @isTest
    static void testMethod_afterUpdate(){
        
        //Records List of Custom_Item__c to insert
        List<Custom_Item__c> customItemList = new List<Custom_Item__c>();
        
        List<Standardized_Item__c> stItemsList = [SELECT Id, Opportunity__r.Id, order_id__c FROM Standardized_Item__c];
        
        for(Standardized_Item__c sItm : stItemsList){
            if(sItm.order_id__c =='order1'){
                Custom_Item__c cItem1 = new Custom_Item__c(Name='cItemTest1', FF_Reorder_Sizing__c=false, order_id__c='order1', 
                                                           FF_Create_Item_Successful__c=false, is_submitted__c='true', 
                                                           Style__c='Custom Kicks Shoe - Slip On', Category__c='Pro', 
                                                           Design_Status__c='Confirmed to Send', Gender__c='Girl', Fabric_Options__c='Mistique', 
                                                           Opportunity__c=sItm.Opportunity__r.Id, Product_Style__c='Uniform', Quantity__c=10, 
                                                           Stated_Quantity__c=10, Price_per_item__c=50,Commission_Rate__c=6);
                customItemList.add(cItem1);
            }
            if(sItm.order_id__c =='order2'){
                Custom_Item__c cItem2 = new Custom_Item__c(Name='cItemTest2', FF_Reorder_Sizing__c=false, order_id__c='order2', 
                                                           FF_Create_Item_Successful__c=false, is_submitted__c='false', 
                                                           Style__c='ZHS – Zip Hoodie Sweatshirt', Category__c='Gymnastics', 
                                                           Design_Status__c='Confirmed to Send', Gender__c='Boy', Fabric_Options__c='Mistique', 
                                                           Opportunity__c=sItm.Opportunity__r.Id, Product_Style__c='Uniform', Quantity__c=12, 
                                                           Stated_Quantity__c=12, Price_per_item__c=5,Commission_Rate__c=6);
                customItemList.add(cItem2);
            }
        }
        
        insert customItemList;
        
        System.assertEquals(2, customItemList.size());
        
        customItemList[0].FF_Create_Item_Successful__c = true;
        customItemList[1].FF_Create_Item_Successful__c = true;
        
        Test.startTest();
        
        update customItemList;
        
        List<Custom_Item__c> cItemList = [SELECT Id, Name, Opportunity__r.Id, Opportunity__c, Account_Lookup__c, order_id__c, 
                                    FF_Reorder_Sizing__c, Commission_Rate__c FROM Custom_Item__c WHERE (order_id__c='order1' AND FF_Create_Item_Successful__c=true 
                                    AND FF_Is_Submitted__c = true) OR (order_id__c='order2' AND FF_Create_Item_Successful__c=true 
                                    AND FF_Is_Submitted__c = false)];
        
        System.assertEquals('order1', cItemList[0].order_id__c);
        System.assertEquals('order2', cItemList[1].order_id__c);
        
        Opportunity oppTestField2 = [SELECT Id, Create_AFS__c, AccountId FROM Opportunity WHERE Id=:cItemList[0].Opportunity__r.Id];
        System.assertEquals(true, oppTestField2.Create_AFS__c);
        
        cItemList[1].Opportunity__c = cItemList[0].Opportunity__r.Id;
        cItemList[1].Commission_Rate__c = 10;
        
        update cItemList[1];
        
        Opportunity oppTestField2Updt = [SELECT Id, Create_AFS__c, AccountId FROM Opportunity WHERE Id=:cItemList[0].Opportunity__r.Id];
        System.assertEquals(false, oppTestField2Updt.Create_AFS__c);
        
        
        Test.stopTest();
    }
    
    /**
        * @description   :  Method to test method statusChatter. 
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 27-6-2020
        * 
    * */
    @isTest
    static void testMethod_statusChatter(){
        Opportunity opp = TestData.opportunity(true);
        Design_Request__c dr = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
          true);
         Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
          Opportunity__c = opp.Id,
          Design_Request__c = dr.Id,
          Price_per_item__c = 0,
          Product_Style__c = 'Uniform',
          Design_Status__c = '(S) Grey Out'
        ),true);
        
        Design_Request__c dr1 = [SELECT Id FROM Design_Request__c LIMIT 1];
        Custom_Item__c ci = [SELECT id, Price_per_item__c FROM Custom_Item__c LIMIT 1];
        
        Test.startTest();
        ci.Design_Status__c = '(P) Waiting on sales rep confirmation';
        
        Test.stopTest();
    
        
    }
}