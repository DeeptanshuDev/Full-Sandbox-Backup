@isTest
private class OpportunityManager_T {

  static Product2 prod1;

  static {
    prod1 = TestData.product(new Product2(Track_Inventory__c = true), true);
  }

 /* @isTest
  private static void setsName() {
    TestData.opportunity(new Opportunity(
      Category_Picklist__c = 'All Star',
      Collection_Picklist__c = 'Couture',
      Uniform_Style__c = 'Crop',
        Generate_AFS__c = true,
      Additional_Description__c = 'abc'
    ), true);
      Fit__c record = new Fit__c();
      record.name = 'XCustom Kicks Shoe - Slip On';
      record.categories_id__c = '111-cat-11';
      record.fit_id__c = '111-fi-11';
      insert record;
       Test.startTest();
    Opportunity opp = [SELECT Name FROM Opportunity][0];
      List<Custom_Item__c> customItems = new List<Custom_Item__c>();
        customItems.add(new Custom_Item__c(Name = 'Custom Item 001',FF_Create_Item_Successful__c = true , Opportunity__c = opp.Id , Stage__c = 'Prototype' , 
                                           Quantity__c = 10 , Category__c = 'Gymnastics' , Design_Status__c = 'Waiting on Girl Items' , 
                                           Gender__c = 'Boy' , Product_Style__c = 'Custom Bow' , Price_per_item__c = 20 , Style__c='Custom Kicks Shoe - Slip On',
                                           Stated_Quantity__c = 10, Fabric_Options__c='Mistique'));
       customItems.add(new Custom_Item__c(Name = 'Custom Item 001',FF_Create_Item_Successful__c = true , Opportunity__c = opp.Id , Stage__c = 'Prototype' , 
                                           Quantity__c = 10 , Category__c = 'Gymnastics' , Design_Status__c = 'Waiting on Girl Items' , 
                                           Gender__c = 'Girl' , Product_Style__c = 'Custom Bow' , Price_per_item__c = 20 , Style__c='Custom Kicks Shoe - Slip On',
                                           Stated_Quantity__c = 10, Fabric_Options__c='Mistique'));
      
      insert customItems;
      List<Standardized_Item__c> standardItems = new List<Standardized_Item__c>();
        standardItems.add(new Standardized_Item__c(Opportunity__c = opp.Id,FF_Create_Item_Successful__c = true, Stage__c = 'Prototype' , Quantity__c = 10 , Stated_Quantity__c = 10));
        standardItems.add(new Standardized_Item__c(Opportunity__c =opp.Id,FF_Create_Item_Successful__c = true , Stage__c = 'Prototype' , Quantity__c = 10 , Stated_Quantity__c = 10 ));
        standardItems.add(new Standardized_Item__c(Opportunity__c = opp.Id,FF_Create_Item_Successful__c = true , Stage__c = 'Prototype' , Quantity__c = 10 , Stated_Quantity__c = 10 ));
        insert standardItems;
        
      
       List<order_sizes__c> ordersizes = new List<order_sizes__c>();
        ordersizes.add(new order_sizes__c(Name ='Order 1',Order__c = customItems[0].Id));
        ordersizes.add(new order_sizes__c(Name ='Order 2',Order__c = customItems[1].Id));
        ordersizes.add(new order_sizes__c(Name ='Order 3',standard_order__c = standardItems[0].Id));
        ordersizes.add(new order_sizes__c(Name ='Order 4',standard_order__c = standardItems[1].Id));
       
        insert ordersizes;
     
      opp.Generate_AFS__c = false;
      opp.No_Length_adjustments__c = true;
      update opp;
      
      opp.Generate_AFS__c = true;
      opp.No_Length_adjustments__c = false;
      update opp;
      
      opp.Generate_M_AFS__c = true;
      update opp;
      
      opp.Generate_M_AFS__c =false;
      update opp;
    System.assertEquals('All Star Couture Crop abc', opp.Name);
      Test.stopTest();
  }
    
  @isTest
  private static void setsName1() {
    TestData.opportunity(new Opportunity(
      Category_Picklist__c = 'All Star1',
      Collection_Picklist__c = 'N/A',
      Uniform_Style__c = 'Crop1',
        Generate_M_AFS__c = true,
      Additional_Description__c = 'abc1'
    ), true);
 Test.startTest();
    Opportunity opp = [SELECT Name,Generate_M_AFS__c FROM Opportunity][0];
        List<Custom_Item__c> customItems = new List<Custom_Item__c>();
        customItems.add(new Custom_Item__c(Name = 'Custom Item 001',FF_Create_Item_Successful__c = true , Opportunity__c = opp.Id , Stage__c = 'Prototype' , 
                                           Quantity__c = 10 , Category__c = 'Gymnastics' , Design_Status__c = 'Waiting on Girl Items' , 
                                           Gender__c = 'Boy' , Product_Style__c = 'Custom Bow' , Price_per_item__c = 20 , Style__c='Custom Kicks Shoe - Slip On',
                                           Stated_Quantity__c = 10, Fabric_Options__c='Mistique'));
      customItems.add(new Custom_Item__c(Name = 'Custom Item 001',FF_Create_Item_Successful__c = true , Opportunity__c = opp.Id , Stage__c = 'Prototype' , 
                                           Quantity__c = 10 , Category__c = 'Gymnastics' , Design_Status__c = 'Waiting on Girl Items' , 
                                           Gender__c = 'Girl' , Product_Style__c = 'Custom Bow' , Price_per_item__c = 20 , Style__c='Custom Kicks Shoe - Slip On',
                                           Stated_Quantity__c = 10, Fabric_Options__c='Mistique'));
      
      insert customItems;
      List<Standardized_Item__c> standardItems = new List<Standardized_Item__c>();
        standardItems.add(new Standardized_Item__c(Opportunity__c = opp.Id,FF_Create_Item_Successful__c = true, Stage__c = 'Prototype' , Quantity__c = 10 , Stated_Quantity__c = 10));
        standardItems.add(new Standardized_Item__c(Opportunity__c =opp.Id,FF_Create_Item_Successful__c = true , Stage__c = 'Prototype' , Quantity__c = 10 , Stated_Quantity__c = 10 ));
        standardItems.add(new Standardized_Item__c(Opportunity__c = opp.Id,FF_Create_Item_Successful__c = true , Stage__c = 'Prototype' , Quantity__c = 10 , Stated_Quantity__c = 10 ));
        insert standardItems;
        
      
       List<order_sizes__c> ordersizes = new List<order_sizes__c>();
        ordersizes.add(new order_sizes__c(Name ='Order 1',Order__c = customItems[0].Id));
        ordersizes.add(new order_sizes__c(Name ='Order 2',Order__c = customItems[1].Id));
        ordersizes.add(new order_sizes__c(Name ='Order 3',standard_order__c = standardItems[0].Id));
        ordersizes.add(new order_sizes__c(Name ='Order 4',standard_order__c = standardItems[1].Id));
      
        insert ordersizes;
      opp.Generate_M_AFS__c = false;
      opp.No_Length_adjustments__c = false;
      update opp;
      
    System.assertEquals('All Star1 Crop1 abc1', opp.Name);
      Test.stopTest();
  }*/
    
  @isTest
  private static void setsReorderName() {
    TestData.opportunity(new Opportunity(
      Type = 'Reorder',
      Category_Picklist__c = 'All Star',
      Collection_Picklist__c = 'Couture',
      Uniform_Style__c = 'Crop',
      Additional_Description__c = 'abc',
      Prototype_Status__c='N/A'
    ), true);

    Opportunity opp = [SELECT Name FROM Opportunity][0];
    System.assertEquals('RO All Star Couture Crop abc', opp.Name);
  }
    
  @isTest
  private static void setsReorderName1() {
    TestData.opportunity(new Opportunity(
      Type = 'Reorder',
      Category_Picklist__c = 'All Star2',
      Collection_Picklist__c = 'N/A',
      Uniform_Style__c = 'Crop2',
      Additional_Description__c = 'abc2',
      Prototype_Status__c='N/A'
    ), true);
      Fit__c record = new Fit__c();
      record.name = 'XCustom Kicks Shoe - Slip On';
      record.categories_id__c = '111-cat-11';
      record.fit_id__c = '111-fi-11';
      insert record;
      
      Opportunity opp1 = [SELECT Name FROM Opportunity][0];
      List<Custom_Item__c> customItems = new List<Custom_Item__c>();
        customItems.add(new Custom_Item__c(Name = 'Custom Item 001',FF_Create_Item_Successful__c = true , Opportunity__c = opp1.Id , Stage__c = 'Prototype' , 
                                           Quantity__c = 10 , Category__c = 'Gymnastics' , Design_Status__c = 'Waiting on Girl Items' , 
                                           Gender__c = 'Boy' , Product_Style__c = 'Custom Bow' , Price_per_item__c = 20 , Style__c='Custom Kicks Shoe - Slip On',
                                           Stated_Quantity__c = 10, Fabric_Options__c='Mistique'));
      customItems.add(new Custom_Item__c(Name = 'Custom Item 001',FF_Create_Item_Successful__c = true , Opportunity__c = opp1.Id , Stage__c = 'Prototype' , 
                                           Quantity__c = 10 , Category__c = 'Gymnastics' , Design_Status__c = 'Waiting on Girl Items' , 
                                           Gender__c = 'Girl' , Product_Style__c = 'Custom Bow' , Price_per_item__c = 20 , Style__c='Custom Kicks Shoe - Slip On',
                                           Stated_Quantity__c = 10, Fabric_Options__c='Mistique'));
      
      insert customItems;
      
      
      
      List<order_sizes__c> ordersizes = new List<order_sizes__c>();
        ordersizes.add(new order_sizes__c(Name ='Order 1',Order__c = customItems[0].Id));
        ordersizes.add(new order_sizes__c(Name ='Order 2',Order__c = customItems[1].Id));
      
        insert ordersizes;
      
      Test.startTest();
    Opportunity opp = [SELECT Name FROM Opportunity][0];
      opp.Generate_AFS__c = false;
      opp.No_Length_adjustments__c = true;
      update opp;
      
      opp.Generate_AFS__c = true;
      opp.No_Length_adjustments__c = false;
      update opp;
      
      opp.Generate_M_AFS__c = true;
      update opp;
      
      opp.Generate_M_AFS__c =false;
      update opp;
      
      opp.Generate_AFS__c = true;
      update opp;
      
      opp.Generate_AFS__c = false;
      update opp;
      
      
    System.assertEquals('RO All Star2 Crop2 abc2', opp.Name);
      Test.stopTest();
  }
    
    @isTest
    private static void setsReorderName3() {
        TestData.opportunity(new Opportunity(
            Type = 'New Order',
            Category_Picklist__c = 'All Star',
            Collection_Picklist__c = 'Couture',
            Uniform_Style__c = 'Crop',
            Additional_Description__c = 'abc',
            Prototype_Status__c='N/A',
            Generate_M_AFS__c = true
        ), true);
        Fit__c record = new Fit__c();
        record.name = 'XCustom Kicks Shoe - Slip On';
        record.categories_id__c = '111-cat-11';
        record.fit_id__c = '111-fi-11';
        insert record;
        
        Opportunity opp1 = [SELECT Name FROM Opportunity][0];
        List<Standardized_Item__c> standardItems = new List<Standardized_Item__c>();
        standardItems.add(new Standardized_Item__c(Opportunity__c = opp1.Id,FF_Create_Item_Successful__c = true, Stage__c = 'Prototype' , Quantity__c = 10 , Stated_Quantity__c = 10, Style__c = 'XCustom Kicks Shoe - Slip On'));
        standardItems.add(new Standardized_Item__c(Opportunity__c =opp1.Id,FF_Create_Item_Successful__c = true , Stage__c = 'Prototype' , Quantity__c = 10 , Stated_Quantity__c = 10, Style__c = 'XCustom Kicks Shoe - Slip On' ));
        standardItems.add(new Standardized_Item__c(Opportunity__c = opp1.Id,FF_Create_Item_Successful__c = true , Stage__c = 'Prototype' , Quantity__c = 10 , Stated_Quantity__c = 10, Style__c = 'XCustom Kicks Shoe - Slip On' ));
        insert standardItems;
        
		List<order_sizes__c> ordersizes = new List<order_sizes__c>();
        ordersizes.add(new order_sizes__c(Name ='Order 3',standard_order__c = standardItems[0].Id));
        ordersizes.add(new order_sizes__c(Name ='Order 4',standard_order__c = standardItems[1].Id));
      
        insert ordersizes;        
        
        Test.startTest();
        Opportunity opp = [SELECT Name FROM Opportunity][0];
        opp.Generate_AFS__c = false;
        opp.No_Length_adjustments__c = true;
        update opp;
        
        opp.Generate_AFS__c = true;
        opp.No_Length_adjustments__c = false;
        update opp;
        
        opp.Generate_M_AFS__c = true;
        update opp;
        
        opp.Generate_M_AFS__c =false;
        update opp;
        
        opp.Generate_AFS__c = true;
        update opp;
        
        opp.Generate_AFS__c = false;
        update opp;
        System.assertEquals('All Star Couture Crop abc', opp.Name);
        Test.stopTest();
    }
    
    /**
    *
    * @description : Test method for OpportunityManager 
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 03/31/2022 - Deeptanshu Bharti
    *
    *
    **/
	 static testMethod void firstMethod()
     {
         Contact con= TestData.contact(true);
         List<Account> listOfAcc = new List<Account>();
         Account acc1 = new Account(Name = 'Testing12', Type='All Star', Phone = '123456789', X2021_Total_SO_Sales__c = 95);
         listOfAcc.add(acc1);
         insert listOfAcc;
         
         
         List<Opportunity> listOfOpp = new List<Opportunity>();
         
         Opportunity opp1 = new Opportunity(Name = 'Opp Testing1', Account = listOfAcc[0], Primary_Contact__c = con.Id,Type='New Order',
                                            Category_Picklist__c='All Star',Category_Subtype__c='Dance',
                                            Collection_Picklist__c= 'Couture',Uniform_Style__c='Top',Prototype_Status__c='Proto',
                                           Event_Date_Old__c = system.today(), StageName='Open',CloseDate=system.today());
         
         listOfOpp.add(opp1);
         Opportunity opp2 = new Opportunity(Name = 'Opp Testing2', Account = listOfAcc[0], Primary_Contact__c = con.Id,Type='New Order',
                                            Category_Picklist__c='All Star',Category_Subtype__c='Dance',
                                            Collection_Picklist__c= 'Couture',Uniform_Style__c='Top',Prototype_Status__c='Proto',
                                           Event_Date_Old__c = system.today(), StageName='Open',CloseDate=system.today());
          listOfOpp.add(opp2);
         Opportunity opp3 = new Opportunity(Name = 'Opp Testing3', Account = listOfAcc[0], Primary_Contact__c = con.Id,Type='New Order',
                                            Category_Picklist__c='All Star',Category_Subtype__c='Dance',
                                            Collection_Picklist__c= 'Couture',Uniform_Style__c='Top',Prototype_Status__c='Proto',
                                           Event_Date_Old__c = system.today(), StageName='Open',CloseDate=system.today());
          listOfOpp.add(opp3);
         Opportunity opp7 = new Opportunity(Name = 'Opp Testing7', Account = listOfAcc[0], Primary_Contact__c = con.Id,Type='New Order',
                                            Category_Picklist__c='All Star',Category_Subtype__c='Dance',
                                            Collection_Picklist__c= 'Couture',Uniform_Style__c='Top',Prototype_Status__c='Proto',
                                           Event_Date_Old__c = system.today(), StageName='Open',CloseDate=system.today());
          listOfOpp.add(opp7);
         
         insert listOfOpp; 
         Map<Id, Opportunity> mapOfOpp = new Map<Id, Opportunity>();
         mapOfOpp.put(opp1.Id, opp1);
         mapOfOpp.put(opp2.Id, opp2);
         /*
         opp2.Business_Development_Approval_Checkbox__c = false;
         update opp2;*/
         
         Profile prof = [select id from profile where name LIKE '%Rebel Sales User%'];
         User user = new User();
         user.firstName = 'test1';
         user.lastName = 'test2';
         user.profileId = prof.id;
         user.username = 'test@1test32.com';
         user.email = 'test@test.com';
         user.emailencodingkey='UTF-8';
         user.languagelocalekey='en_US';
         user.localesidkey='en_US';
         user.country='United States';
         user.IsActive =true;
         user.TimeZoneSidKey = 'America/Los_Angeles';
         user.Alias='TT12';
         insert user;
         //User u3 = [SELECT Id FROM User WHERE UserName='candace@rebelathletic.com.full'];
         String userRoleLabel = System.Label.BussinessDevelopmentUsers;
         Set<String> usersName = new Set<String>();
        
        if(userRoleLabel != null)
        {
            for(String str : userRoleLabel.split(','))
            {
                usersName.add(str);
            }
        }
        List<User> users = [SELECT Id, Name FROM USER WHERE Name IN : usersName];
         List<Opportunity> listOpps = new List<Opportunity>();
         Opportunity opp5 = [SELECT Id, Name,Business_Development_Approval_Checkbox__c,OwnerId FROM Opportunity WHERE Id =: opp3.Id];
         opp5.OwnerId = users[0].Id;
         update opp1;
         
         Opportunity opp6 = [SELECT Id, Name,Business_Development_Approval_Checkbox__c,OwnerId FROM Opportunity WHERE Id =: opp1.Id];
         opp6.Business_Development_Approval_Checkbox__c = true;
         listOpps.add(opp6);
         update listOpps;
         System.runAs(users[0])
         {
             Test.startTest();
             Opportunity opp8 = [SELECT Id, Name,Business_Development_Approval_Checkbox__c,OwnerId FROM Opportunity WHERE Id =: opp7.Id];
             opp8.BD_status__c = 'Rejected';
             opp8.Approval_for_BD__c = false;
             listOpps.add(opp8);
             update listOpps;
             Opportunitymanager.sendMail(opp1.Id);
             
             Opportunity opp = [SELECT Id, Name,Business_Development_Approval_Checkbox__c,OwnerId FROM Opportunity WHERE Id =: opp2.Id];
             opp.Business_Development_Approval_Checkbox__c = true;
             listOpps.add(opp);
             update listOpps;
             
             
             
             Test.stopTest();
         }  
     } 
    
    /**
    *
    * @description : Test method for OpportunityManager 
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 03/31/2022 - Deeptanshu Bharti
    *
    *
    **/
	 static testMethod void testMethodForforBdPicklist()
     {
         Contact con= TestData.contact(true);
         List<Account> listOfAcc = new List<Account>();
         Account acc1 = new Account(Name = 'Testing12', Type='All Star', Phone = '123456789', X2021_Total_SO_Sales__c = 95,Opp_Approval__c=false);
         listOfAcc.add(acc1);
         insert listOfAcc;
         
         
         List<Opportunity> listOfOpp = new List<Opportunity>();
         
         Opportunity opp = new Opportunity(Name = 'Opp Testing1', Account = listOfAcc[0], Primary_Contact__c = con.Id,Type='New Order',
                                            Category_Picklist__c='All Star',Category_Subtype__c='Dance',
                                            Collection_Picklist__c= 'Couture',Uniform_Style__c='Top',Prototype_Status__c='Proto',
                                           Event_Date_Old__c = system.today(), StageName='Open',CloseDate=system.today());
         
         listOfOpp.add(opp);
         insert listOfOpp;
         Opportunity opp2 = [SELECT Id, Name,Business_Development_Approval_Checkbox__c,OwnerId FROM Opportunity WHERE Id =: opp.Id];
         Map<Id, Opportunity> mapOfOpp = new Map<Id, Opportunity>();
         mapOfOpp.put(opp2.Id,opp2);
         
         String userRoleLabel = System.Label.BussinessDevelopmentUsers;
         Set<String> usersName = new Set<String>();
        
        if(userRoleLabel != null)
        {
            for(String str : userRoleLabel.split(','))
            {
                usersName.add(str);
            }
        }
        List<User> users = [SELECT Id, Name FROM USER WHERE Name IN : usersName];
         
         System.runAs(users[0])
         {
             Test.startTest();
             Opportunity opp3 = [SELECT Id, Name,Business_Development_Approval_Checkbox__c,OwnerId FROM Opportunity WHERE Id =: opp.Id];
             opp3.Business_Development_Approval_Checkbox__c = true;
             update opp3;
             
             Opportunity opp9 = new Opportunity(Name = 'Opp Testing2', Account = listOfAcc[0], Primary_Contact__c = con.Id,Type='New Order',
                                            Category_Picklist__c='All Star',Category_Subtype__c='Dance',
                                            Collection_Picklist__c= 'Couture',Uniform_Style__c='Top',Prototype_Status__c='Proto',
                                           Event_Date_Old__c = system.today(), StageName='Open',CloseDate=system.today());
             //insert opp9;
             Test.stopTest();
         }
         
     }
}