/** 
* 
* Description : Test class for checkRecursion.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 01/03/2022
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/
 
@isTest (seeAllData=false)
public class Test_checkRecursion {

    /**
        * @description   :  Method to insert data used in testing. 
        * 
        * @args          :  -
        * 
        * @return		 :  void
        * 
        * @revision Log  :  V_1.0  - 07/03/2021
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
    *
    * @description : Test methid for using Date data type and adding it in list
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 07/03/2021 - Deeptanshu Bharti
    *
    * coverage : 100
    *
    **/
    static testMethod void myFirstMethod_Test(){
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

        List<Custom_Item__c> listOfCI = new List<Custom_Item__c>();
        listOfCI.add(cItem1);
        System.debug('list of custom item are :' + listOfCI);
        Map<Id, Custom_Item__c> mapOfCi = new Map<Id, Custom_Item__c>();
        mapOfCi.put(listOfCI[0].Id, listOfCI[0]);
        System.debug('Map of custom item are : '+mapOfCi);

        Map<Integer, String> m1 = new Map<Integer, String>();
m1.put(1, 'First item');

        checkRecursion.hasAlreadyRun();
        CustomItemTriggerHandler obj = new CustomItemTriggerHandler();
        obj.preventSalesUsersToUpdateWholeSalePrice(listOfCI, mapOfCi);
    }


}