/**
    * Obejctive -  Testing for StandardizedItemManager class
    * 
    * Created By - 
    * 
    * Created Date - 29-6-2020
    * 
    * Revision Log - V1.1 - Created.
**/
@isTest(SeeAllData=false)
private class Test_StandardizedItemManager {
    
    /**
        * @description   :  Method to insert data used in testing.
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 29-6-2020
        * 
    * */
    @testSetup
    static void testDataSetup(){
        
        //Records List of Custom_Item__c to insert
        List<Custom_Item__c> customItemList = new List<Custom_Item__c>();
        
        //Records List of Account to insert
        List<Account> accountList = new List<Account>();
        
        //Records List of Contact to insert
        List<Contact> contactList = new List<Contact>();
        
        //Records List of Opportunity to insert
        List<Opportunity> opportunityList = new List<Opportunity>();
        
        //Records List of Fit__c to insert
        List<Fit__c> fitList = new List<Fit__c>();
        
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
        
        Opportunity opp1 = new Opportunity(Name='oppTest1', Type='New Order', AccountId=acc1.Id, CloseDate= date.newInstance(2020, 10, 5), 
                                           Category_Picklist__c='School', StageName='Open', Primary_Contact__c=con1.Id);
        opportunityList.add(opp1);
        Opportunity opp2 = new Opportunity(Name='oppTest2', Type='New Order', AccountId=acc2.Id, CloseDate= date.newInstance(2020, 10, 6), 
                                           Category_Picklist__c='School', StageName='Open', Primary_Contact__c=con2.Id);
        opportunityList.add(opp2);
        Opportunity opp3 = new Opportunity(Name='oppTest3', Type='New Order', AccountId=acc3.Id, CloseDate= date.newInstance(2020, 10, 7), 
                                           Category_Picklist__c='School', StageName='Open', Primary_Contact__c=con3.Id);
        opportunityList.add(opp3);
        Opportunity opp4 = new Opportunity(Name='oppTest4', Type='New Order', AccountId=acc4.Id, CloseDate= date.newInstance(2020, 10, 8), 
                                           Category_Picklist__c='School', StageName='Open', Primary_Contact__c=con4.Id);
        opportunityList.add(opp4);
        insert opportunityList;
        
        System.assertEquals(4, opportunityList.size());
        
        Custom_Item__c cItem1 = new Custom_Item__c(Name='cItemTest1', order_id__c='order1', 
                                                           FF_Create_Item_Successful__c=false, is_submitted__c='true', 
                                                           Style__c='Custom Kicks Shoe - Slip On', Category__c='Pro', 
                                                           Design_Status__c='Confirmed to Send', Gender__c='Girl', Fabric_Options__c='Mistique', 
                                                           Opportunity__c=Opp1.Id, Product_Style__c='Uniform', Quantity__c=10, 
                                                           Stated_Quantity__c=10, Price_per_item__c=50);
        customItemList.add(cItem1);
        Custom_Item__c cItem2 = new Custom_Item__c(Name='cItemTest2', order_id__c='order2', 
                                                           FF_Create_Item_Successful__c=false, is_submitted__c='false', 
                                                           Style__c='ZHS – Zip Hoodie Sweatshirt', Category__c='Gymnastics', 
                                                           Design_Status__c='Confirmed to Send', Gender__c='Boy', Fabric_Options__c='Mistique', 
                                                           Opportunity__c=Opp2.Id, Product_Style__c='Uniform', Quantity__c=12, 
                                                           Stated_Quantity__c=12, Price_per_item__c=5);
        customItemList.add(cItem2);
        
        insert customItemList;
        
        System.assertEquals(2, customItemList.size());
    }
    /**
        * @description   :  Method to test method after insert. 
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 29-6-2020
        * 
    * */
    @isTest
    static void testMethod_afterInsert(){
        
        //Records List of Standardized_Item__c to insert
        List<Standardized_Item__c> stItemsList = new List<Standardized_Item__c>();
        
        Test.startTest();
        
        List<Custom_Item__c> customItemList = [SELECT Id, Opportunity__r.Id, order_id__c, FF_Create_Item_Successful__c FROM Custom_Item__c];
        
        customItemList[0].FF_Create_Item_Successful__c = true;
        customItemList[1].FF_Create_Item_Successful__c = true;
        
        update customItemList;
        
        for(Custom_Item__c cItm : customItemList){
            if(cItm.order_id__c =='order1'){
                Standardized_Item__c stItem1 = new Standardized_Item__c(order_id__c='order1', FF_Create_Item_Successful__c=true, 
                                                                        is_submitted__c='true', Opportunity__c=cItm.Opportunity__r.Id, Quantity__c=8, 
                                                                        Stated_Quantity__c=8);
                stItemsList.add(stItem1);
            }
            if(cItm.order_id__c =='order2'){
                Standardized_Item__c stItem2 = new Standardized_Item__c(order_id__c='order2', FF_Create_Item_Successful__c=true, 
                                                                        is_submitted__c='true', Opportunity__c=cItm.Opportunity__r.Id, Quantity__c=8, 
                                                                        Stated_Quantity__c=8);
                stItemsList.add(stItem2);
            }
        }
        
        insert stItemsList;
        
        System.assertEquals(2, stItemsList.size());
        
        Standardized_Item__c sItem1 = [SELECT Id, Opportunity__r.Id, Account_Lookup__c FROM Standardized_Item__c WHERE 
                                          order_id__c='order1' AND FF_Create_Item_Successful__c=true AND FF_Is_Submitted__c = true];
        
        Opportunity oppTestAccField = [SELECT Id, Create_AFS__c, AccountId FROM Opportunity WHERE Id=:sItem1.Opportunity__r.Id];
        
        System.assertEquals(true, oppTestAccField.Create_AFS__c);
        System.assertEquals(oppTestAccField.AccountId, sItem1.Account_Lookup__c);
        
        Standardized_Item__c sItem2 = [SELECT Id, Account_Lookup__c, Opportunity__r.Id 
                                      FROM Standardized_Item__c WHERE order_id__c='order2'];
        
        Opportunity oppTestField2 = [SELECT Id, Create_AFS__c, AccountId FROM Opportunity WHERE Id=:sItem2.Opportunity__r.Id];
        System.assertEquals(false, oppTestField2.Create_AFS__c);
        System.assertEquals(oppTestField2.AccountId, sItem2.Account_Lookup__c);
        
        Test.stopTest();
        
    }
    /**
        * @description   :  Method to test method updateFitOnStandardizedItem. 
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 29-6-2020
        * 
    * */
    @isTest
    static void testMethod_updateFitOnStandardizedItem(){
        
        //Records List of Standardized_Item__c to insert
        List<Standardized_Item__c> stItemsList = new List<Standardized_Item__c>();
        
        List<Custom_Item__c> customItemList = [SELECT Id, Opportunity__r.Id, order_id__c FROM Custom_Item__c];
        
        Standardized_Item__c stItem1;
        for(Custom_Item__c cItem : customItemList){
            if(cItem.order_id__c =='order2'){
                stItem1 = new Standardized_Item__c(order_id__c='order2', FF_Create_Item_Successful__c=false, Style__c='ZHS – Zip Hoodie Sweatshirt', 
                                                                        is_submitted__c='true', Opportunity__c=cItem.Opportunity__r.Id, Quantity__c=8, 
                                                                        Stated_Quantity__c=8);
                stItemsList.add(stItem1);
            }
        }
        Test.startTest();
        insert stItemsList;
        
        System.assertEquals(1, stItemsList.size());
        
        Fit__c fitList = [SELECT Id, Name FROM Fit__c WHERE Name=:stItem1.Style__c];
        
        System.assertEquals('ZHS – Zip Hoodie Sweatshirt', fitList.Name);
        
        Standardized_Item__c sItem2 = [SELECT Id, Account_Lookup__c, Opportunity__r.Id, Fit__c 
                                      FROM Standardized_Item__c WHERE order_id__c='order2'];
        
        System.assertEquals(fitList.Id, sItem2.Fit__c);
        
        sItem2.Style__c = 'Custom Kicks Shoe - Slip On';
        
        update sItem2;
        
        Fit__c fit2 = [SELECT Id, Name FROM Fit__c WHERE Name='Custom Kicks Shoe - Slip On'];
        
        sItem2 = [SELECT Id, Account_Lookup__c, Opportunity__r.Id, Fit__c 
                                      FROM Standardized_Item__c WHERE order_id__c='order2'];
        
       
        Test.stopTest();
    }
    /**
        * @description   :  Method to test method after update. 
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 1-7-2020
        * 
    * */
    @isTest
    static void testMethod_afterUpdate(){
        
        //Records List of Standardized_Item__c to insert
        List<Standardized_Item__c> stItemsList = new List<Standardized_Item__c>();
        
        List<Custom_Item__c> cItemsList = [SELECT Id, Opportunity__r.Id, order_id__c, FF_Create_Item_Successful__c FROM Custom_Item__c];
        
        cItemsList[0].FF_Create_Item_Successful__c = true;
        cItemsList[1].FF_Create_Item_Successful__c = true;
        
        update cItemsList;
        
        for(Custom_Item__c cItem : cItemsList){
            if(cItem.order_id__c =='order1'){
                Standardized_Item__c stItem1 = new Standardized_Item__c(order_id__c='order1', FF_Create_Item_Successful__c=true, 
                                                                        is_submitted__c='true', Opportunity__c=cItem.Opportunity__r.Id, 
                                                                        Quantity__c=8, Stated_Quantity__c=8);
                stItemsList.add(stItem1);
            }
            if(cItem.order_id__c =='order2'){
                Standardized_Item__c stItem2 = new Standardized_Item__c(order_id__c='order2', FF_Create_Item_Successful__c=true, 
                                                                        is_submitted__c='false', Opportunity__c=cItem.Opportunity__r.Id, 
                                                                        Quantity__c=8, Stated_Quantity__c=8);
                stItemsList.add(stItem2);
            }
        }
        
        insert stItemsList;
        
        System.assertEquals(2, stItemsList.size());
        
        Test.startTest();
        
        List<Standardized_Item__c> sItemList = [SELECT Id, Opportunity__r.Id, Opportunity__c, Account_Lookup__c, order_id__c 
                                    FROM Standardized_Item__c WHERE (order_id__c='order1' AND FF_Create_Item_Successful__c=true 
                                    AND FF_Is_Submitted__c = true) OR (order_id__c='order2' AND FF_Create_Item_Successful__c=true 
                                    AND FF_Is_Submitted__c = false)];
        
        System.assertEquals('order1', sItemList[0].order_id__c);
        System.assertEquals('order2', sItemList[1].order_id__c);
        
        Opportunity oppTestField2 = [SELECT Id, Create_AFS__c, AccountId FROM Opportunity WHERE Id=:sItemList[0].Opportunity__r.Id];
        System.assertEquals(true, oppTestField2.Create_AFS__c);
        
        sItemList[1].Opportunity__c = sItemList[0].Opportunity__r.Id;
        
        update sItemList[1];
        
        Opportunity oppTestField2Updt = [SELECT Id, Create_AFS__c, AccountId FROM Opportunity WHERE Id=:sItemList[0].Opportunity__r.Id];
        System.assertEquals(false, oppTestField2Updt.Create_AFS__c);
        
        Test.stopTest();
    }
}