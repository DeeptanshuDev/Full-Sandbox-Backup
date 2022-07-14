/**
*  Description     :   Test class to test the functionality of Sizing Order Button On Account detail page.
*            
*  Create By       :   Abhinav Sharma
*
*  Created Date    :   12-05-2020
*
*  Revision Log    :   V_1.0 - Created - Abhinav Sharma
*
*  Coverage        :   94%
*
**/

@isTest(seeAllData = false)
private with sharing class Test_FF_SizingOrderController
{
    
    //testSetUp
    @testSetUp static void testSetupData()
    {
        System.Debug('!!!!!!!!!!!!!!!!!!!!!!! Inside Setup');
        
        //Insert Custom Setting data used for callout
        FF_Credentials__c ffCreds = new FF_Credentials__c();
        ffCreds.Endpoint__c = 'http://example.com/';
        ffCreds.User_Id__c = 'user@user.com';
        ffCreds.Password__c = 'user@123';
        insert ffCreds;

        //Insert Fits record
        Fit__c newFit = new Fit__c();
        newFit.Name = 'Fit Demo 1';
        newFit.fit_id__c = '111-fit-111';
        insert newFit;
        System.debug('newFit = ' + newFit.id);
        
        //Create Account Record
        //List to hold Account records
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Gym Account 001' , Type = 'All Star', gym_id__c = '111-gym-111', FF_Create_Gym_Successful__c = TRUE));
        //accounts.add(new Account(Name = 'Gym Account 002' , Type = 'All Star'));
        insert accounts;
		System.debug('accounts = ' + accounts[0].id);
        
        //Insert Rosters record
        Rosters__c ros = new Rosters__c(Name = 'Test Rosters', Rosters_id__c = '111-ros-111', Account__c = accounts[0].id);
        insert ros;
        System.debug('ros = ' + ros.id);
        
        //Insert Contact record
        //List to hold Contact records
       	List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(LastName = '001' , FirstName = 'Contact Demo ' , Email = 'contactdemo001@gmail.com' , AccountId = accounts[0].Id));
        //contacts.add(new Contact(LastName = '002' , FirstName = 'Contact Demo ' , Email = 'contactdemo002@gmail.com' , AccountId = accounts[1].Id));
        insert contacts;
		System.debug('contacts = ' + contacts[0].id);

        //Insert Opportunity Record
        //List to hold opportunities
        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(new Opportunity(Name = 'Opportunity Demo 001' , StageName = 'Open' , AccountId = accounts[0].Id , CloseDate = System.today() , Type = 'New Order' , Primary_Contact__c = contacts[0].Id , Collection_Picklist__c = 'N/A' , Category_Picklist__c = 'All Star'));
        opportunities.add(new Opportunity(Name = 'Opportunity Demo 002' , StageName = 'Open' , AccountId = accounts[0].Id , CloseDate = System.today() , Type = 'New Order' , Primary_Contact__c = contacts[0].Id , Collection_Picklist__c = 'N/A' , Category_Picklist__c = 'All Star'));
        opportunities.add(new Opportunity(Name = 'Opportunity Demo 003' , StageName = 'Closed Lost' , AccountId = accounts[0].Id , CloseDate = System.today() , Type = 'New Order' , Primary_Contact__c = contacts[0].Id , Collection_Picklist__c = 'N/A' , Category_Picklist__c = 'All Star'));
        insert opportunities;
        System.debug('opportunities = ' + opportunities[0].id);

        //Insert Custom Items
        //List to hold Custom Items
        List<Custom_Item__c> customItems = new List<Custom_Item__c>();
        customItems.add(new Custom_Item__c(Name = 'Custom Item 001' , Opportunity__c = opportunities[0].Id , Stage__c = 'Prototype' , 
                                           Quantity__c = 10 , Category__c = 'Gymnastics' , Design_Status__c = 'Waiting on Girl Items' , 
                                           Gender__c = 'Boy' , Product_Style__c = 'Custom Bow' , Price_per_item__c = 20 , Style__c='Custom Kicks Shoe - Slip On',
                                           Stated_Quantity__c = 10, Fabric_Options__c='Mistique'));
        customItems.add(new Custom_Item__c(Name = 'Custom Item 002' , Opportunity__c = opportunities[0].Id , Stage__c = 'Prototype' , 
                                           Quantity__c = 10 , Category__c = 'Gymnastics' , Design_Status__c = 'Waiting on Girl Items' , 
                                           Gender__c = 'Boy' , Product_Style__c = 'Custom Bow' , Price_per_item__c = 20 , Stated_Quantity__c = 10 , 
                                           Fit__c = newFit.Id, Style__c='Custom Kicks Shoe - Slip On', Fabric_Options__c='Mistique'));
        customItems.add(new Custom_Item__c(Name = 'Custom Item 003' , Opportunity__c = opportunities[1].Id , Stage__c = 'Prototype' , 
                                           Quantity__c = 10 , Category__c = 'Gymnastics' , Design_Status__c = 'Waiting on Girl Items' , 
                                           Gender__c = 'Boy' , Product_Style__c = 'Custom Bow' , Price_per_item__c = 20 , Stated_Quantity__c = 10 , 
                                           Fit__c = newFit.Id, Style__c='ZHS – Zip Hoodie Sweatshirt', Fabric_Options__c='Mistique'));
        insert customItems;
        System.debug('customItems = ' + customItems[0].id);

        //Insert Standard Items
        //List to hold standard items
        List<Standardized_Item__c> standardItems = new List<Standardized_Item__c>();
        standardItems.add(new Standardized_Item__c(Opportunity__c = opportunities[0].Id , Stage__c = 'Prototype' , Quantity__c = 10 , Stated_Quantity__c = 10));
        standardItems.add(new Standardized_Item__c(Opportunity__c = opportunities[0].Id , Stage__c = 'Prototype' , Quantity__c = 10 , Stated_Quantity__c = 10 , Fit__c = newFit.Id));
        standardItems.add(new Standardized_Item__c(Opportunity__c = opportunities[1].Id , Stage__c = 'Prototype' , Quantity__c = 10 , Stated_Quantity__c = 10 , Fit__c = newFit.Id));
        insert standardItems;
        System.debug('standardItems = ' + standardItems[0].id);

        System.Debug('!!!!!!!!!!!!!!!!!!!!!!! Setup End');
    }

      //Test
    @isTest
    static void test_saveMethodForCustomItem()
    {
        Profile p = [select id 
                  from 
                  Profile 
                  where 
                  name='System Administrator']; 
     
     User bdeUser = new user(alias = 'test123', email='test123@noemail.com', 
                             emailencodingkey='UTF-8', firstName='Nahush', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_IN', profileid = p.Id, country='India',
                             timezonesidkey='Asia/Kolkata', username='test_g'+math.random()+'@noemail.com'); 
     insert bdeUser;
     
     
     PermissionSet ps = new PermissionSet(Label = 'mockPs', Name = 'mockPs');
     insert ps;
     
     // Given custom permission associated to the mocked PermissionSet
     SetupEntityAccess sea = new SetupEntityAccess(
         ParentId = ps.Id,
         SetupEntityId = [SELECT Id FROM CustomPermission
                          WHERE DeveloperName = 'Fit_Freedom_User'][0].Id
     );
     insert sea;
     
     // Given mocked Permission Set assigned to user for test
     PermissionSetAssignment psa = new PermissionSetAssignment(
         AssigneeId = bdeUser.Id,
         PermissionSetId = ps.Id
     );
     insert psa;
     system.runAs(bdeUser)
     {
         System.Debug('!!!!!!!!!!!!!!!!!!!!!!! Test Class Starts');
         
         List<Account> accs = [SELECT Id FROM Account];
         System.assertEquals(1, accs.size());
         
         List<Contact> cons = [SELECT Id FROM Contact];
         System.assertEquals(1, cons.size());
         
         List<Opportunity> opps = [SELECT Id FROM Opportunity];
         System.assertEquals(3, opps.size());
         
         List<Fit__c> fits = [SELECT Id FROM Fit__c];
         System.assertEquals(1, fits.size());
         
         List<Rosters__c> ros = [SELECT Id FROM Rosters__c];
         System.assertEquals(1, ros.size());
         
         List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
         System.assertEquals(3, cItems.size());
         
         List<Standardized_Item__c> sItems = [SELECT Id FROM Standardized_Item__c];
         System.assertEquals(3, sItems.size());
         
         //Setting vf page reference
         Test.setCurrentPageReference(Page.FF_SizingOrderVFPage);
         System.currentPageReference().getParameters().put('Id', accs[0].Id);
         ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accs[0]);
         
         
         //Geting metadata
         List<HTTPCalloutConfiguration__mdt> createOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Create_Order' ];
         System.assertEquals(1, createOrderMDT.size());
         System.assert(String.isNotBlank(createOrderMDT[0].EndPoint__c));
         
         List<HTTPCalloutConfiguration__mdt> addFitToOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Add_Fit_To_Order' ];
         System.assertEquals(1, addFitToOrderMDT.size());
         System.assert(String.isNotBlank(addFitToOrderMDT[0].EndPoint__c));
         
         List<HTTPCalloutConfiguration__mdt> finalizeOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Finalize_Order' ];
         System.assertEquals(1, finalizeOrderMDT.size());
         System.assert(String.isNotBlank(finalizeOrderMDT[0].EndPoint__c));
         
         //Setting Mock
         FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
         FF3_0_Create_Order_Mock createOrderMock = new FF3_0_Create_Order_Mock();
         FF3_0_Add_Fit_To_Order_Mock addFitToOrderMock = new FF3_0_Add_Fit_To_Order_Mock();
         FF3_0_Finalize_Order_Mock finalizeOrderMock = new FF3_0_Finalize_Order_Mock();
         
         Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
         mapMock.put('http://example.com/',accessTokenMock);
         mapMock.put(createOrderMDT[0].EndPoint__c ,createOrderMock);
         mapMock.put(addFitToOrderMDT[0].EndPoint__c ,addFitToOrderMock);
         mapMock.put(finalizeOrderMDT[0].EndPoint__c ,finalizeOrderMock);
         HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
         Test.setMock(HttpCalloutMock.class, multiCalloutMock);
         //Start Test
         Test.startTest();
         
         FF_SizingOrderController ctrl = new FF_SizingOrderController(stdCtrl);
         
         System.assertEquals(2, ctrl.sizingOrderCustomItemsWrapper.size());
         System.assertEquals(2, ctrl.sizingOrderStandardItemsWrapper.size());
         ctrl.sizingOrderCustomItemsWrapper[0].isSelected = TRUE;
         ctrl.sizingOrderCustomItemsWrapper[0].customItem.Rosters__c = ros[0].id;
         
         ctrl.updateCustomAndStandardItemsRecord();
         
         //Stop Test
         Test.stopTest();
     }
    }
    
    @isTest
    static void test_saveMethodForStandarizedItem()
    {
        Profile p = [select id 
                     from 
                     Profile 
                     where 
                     name='System Administrator']; 
        
        User bdeUser = new user(alias = 'test123', email='test123@noemail.com', 
                                emailencodingkey='UTF-8', firstName='Nahush', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_IN', profileid = p.Id, country='India',
                                timezonesidkey='Asia/Kolkata', username='test_g'+math.random()+'@noemail.com'); 
        insert bdeUser;
        
        
        PermissionSet ps = new PermissionSet(Label = 'mockPs', Name = 'mockPs');
        insert ps;
        
        // Given custom permission associated to the mocked PermissionSet
        SetupEntityAccess sea = new SetupEntityAccess(
            ParentId = ps.Id,
            SetupEntityId = [SELECT Id FROM CustomPermission
                             WHERE DeveloperName = 'Fit_Freedom_User'][0].Id
        );
        insert sea;
        
        // Given mocked Permission Set assigned to user for test
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = bdeUser.Id,
            PermissionSetId = ps.Id
        );
        insert psa;
        system.runAs(bdeUser){
            System.Debug('!!!!!!!!!!!!!!!!!!!!!!! Test Class Starts');
            
            List<Account> accs = [SELECT Id FROM Account];
            System.assertEquals(1, accs.size());
            
            List<Contact> cons = [SELECT Id FROM Contact];
            System.assertEquals(1, cons.size());
            
            List<Opportunity> opps = [SELECT Id FROM Opportunity];
            System.assertEquals(3, opps.size());
            
            List<Fit__c> fits = [SELECT Id FROM Fit__c];
            System.assertEquals(1, fits.size());
            
            List<Rosters__c> ros = [SELECT Id FROM Rosters__c];
            System.assertEquals(1, ros.size());
            
            List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
            System.assertEquals(3, cItems.size());
            
            List<Standardized_Item__c> sItems = [SELECT Id FROM Standardized_Item__c];
            System.assertEquals(3, sItems.size());
            
            //Setting vf page reference
            Test.setCurrentPageReference(Page.FF_SizingOrderVFPage);
            System.currentPageReference().getParameters().put('Id', accs[0].Id);
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accs[0]);
            
            
            //Geting metadata
            List<HTTPCalloutConfiguration__mdt> createOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Create_Order' ];
            System.assertEquals(1, createOrderMDT.size());
            System.assert(String.isNotBlank(createOrderMDT[0].EndPoint__c));
            
            List<HTTPCalloutConfiguration__mdt> addFitToOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Add_Fit_To_Order' ];
            System.assertEquals(1, addFitToOrderMDT.size());
            System.assert(String.isNotBlank(addFitToOrderMDT[0].EndPoint__c));
            
            List<HTTPCalloutConfiguration__mdt> finalizeOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Finalize_Order' ];
            System.assertEquals(1, finalizeOrderMDT.size());
            System.assert(String.isNotBlank(finalizeOrderMDT[0].EndPoint__c));
            
            //Setting Mock
            FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
            FF3_0_Create_Order_Mock createOrderMock = new FF3_0_Create_Order_Mock();
            FF3_0_Add_Fit_To_Order_Mock addFitToOrderMock = new FF3_0_Add_Fit_To_Order_Mock();
            FF3_0_Finalize_Order_Mock finalizeOrderMock = new FF3_0_Finalize_Order_Mock();
            
            Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
            mapMock.put('http://example.com/',accessTokenMock);
            mapMock.put(createOrderMDT[0].EndPoint__c ,createOrderMock);
            mapMock.put(addFitToOrderMDT[0].EndPoint__c ,addFitToOrderMock);
            mapMock.put(finalizeOrderMDT[0].EndPoint__c ,finalizeOrderMock);
            HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
            Test.setMock(HttpCalloutMock.class, multiCalloutMock);
            //Start Test
            Test.startTest();
            
            FF_SizingOrderController ctrl = new FF_SizingOrderController(stdCtrl);
            
            System.assertEquals(2, ctrl.sizingOrderCustomItemsWrapper.size());
            System.assertEquals(2, ctrl.sizingOrderStandardItemsWrapper.size());
            ctrl.sizingOrderStandardItemsWrapper[0].isSelected = TRUE;
            ctrl.sizingOrderStandardItemsWrapper[0].standardItem.Rosters__c = ros[0].id;
            
            ctrl.updateCustomAndStandardItemsRecord();
            
            //Stop Test
            Test.stopTest();
        }
    }
    
    
    
    @isTest
    static void test_negativeCase1()
    {
        Profile p = [select id 
                     from 
                     Profile 
                     where 
                     name='System Administrator']; 
        
        User bdeUser = new user(alias = 'test123', email='test123@noemail.com', 
                                emailencodingkey='UTF-8', firstName='Nahush', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_IN', profileid = p.Id, country='India',
                                timezonesidkey='Asia/Kolkata', username='test_g'+math.random()+'@noemail.com'); 
        insert bdeUser;
        
        
        PermissionSet ps = new PermissionSet(Label = 'mockPs', Name = 'mockPs');
        insert ps;
        
        // Given custom permission associated to the mocked PermissionSet
        SetupEntityAccess sea = new SetupEntityAccess(
            ParentId = ps.Id,
            SetupEntityId = [SELECT Id FROM CustomPermission
                             WHERE DeveloperName = 'Fit_Freedom_User'][0].Id
        );
        insert sea;
        
        // Given mocked Permission Set assigned to user for test
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = bdeUser.Id,
            PermissionSetId = ps.Id
        );
        insert psa;
        system.runAs(bdeUser)
        {
            System.Debug('!!!!!!!!!!!!!!!!!!!!!!! Test Class Starts');
            
            List<Account> accs = [SELECT Id FROM Account];
            System.assertEquals(1, accs.size());
            
            List<Contact> cons = [SELECT Id FROM Contact];
            System.assertEquals(1, cons.size());
            
            List<Opportunity> opps = [SELECT Id FROM Opportunity];
            System.assertEquals(3, opps.size());
            
            List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
            System.assertEquals(3, cItems.size());
            
            List<Standardized_Item__c> sItems = [SELECT Id FROM Standardized_Item__c];
            System.assertEquals(3, sItems.size());
            
            delete cItems;
            delete sItems;
            delete opps;
            
            List<Opportunity> oppsUpdated = [SELECT Id FROM Opportunity];
            System.assertEquals(0, oppsUpdated.size());
            
            //Setting vf page reference
            Test.setCurrentPageReference(Page.FF_SizingOrderVFPage);
            System.currentPageReference().getParameters().put('Id', accs[0].Id);
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accs[0]);
            
            
           
        }
    }
   
    
    @isTest
    static void test_negativeCase2()
    {
        Profile p = [select id 
                     from 
                     Profile 
                     where 
                     name='System Administrator'];
        
        User bdeUser = new user(alias = 'test123', email='test123@noemail.com', 
                                emailencodingkey='UTF-8', firstName='Nahush', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_IN', profileid = p.Id, country='India',
                                timezonesidkey='Asia/Kolkata', username='test_g'+math.random()+'@noemail.com'); 
        insert bdeUser;
        
        
        PermissionSet ps = new PermissionSet(Label = 'mockPs', Name = 'mockPs');
        insert ps;
        
        // Given custom permission associated to the mocked PermissionSet
        SetupEntityAccess sea = new SetupEntityAccess(
            ParentId = ps.Id,
            SetupEntityId = [SELECT Id FROM CustomPermission
                             WHERE DeveloperName = 'Fit_Freedom_User'][0].Id
        );
        insert sea;
        
        // Given mocked Permission Set assigned to user for test
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = bdeUser.Id,
            PermissionSetId = ps.Id
        );
        insert psa;
        system.runAs(bdeUser){
            System.Debug('!!!!!!!!!!!!!!!!!!!!!!! Test Class Starts');
            
            List<Account> accs = [SELECT Id FROM Account];
            System.assertEquals(1, accs.size());
            
            List<Contact> cons = [SELECT Id FROM Contact];
            System.assertEquals(1, cons.size());
            
            List<Opportunity> opps = [SELECT Id FROM Opportunity];
            System.assertEquals(3, opps.size());
            
            List<Fit__c> fits = [SELECT Id FROM Fit__c];
            System.assertEquals(1, fits.size());
            
            List<Rosters__c> ros = [SELECT Id FROM Rosters__c];
            System.assertEquals(1, ros.size());
            
            List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
            System.assertEquals(3, cItems.size());
            
            List<Standardized_Item__c> sItems = [SELECT Id FROM Standardized_Item__c];
            System.assertEquals(3, sItems.size());
            
            //Setting vf page reference
            Test.setCurrentPageReference(Page.FF_SizingOrderVFPage);
            System.currentPageReference().getParameters().put('Id', accs[0].Id);
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accs[0]);
            
            
            //Geting metadata
            List<HTTPCalloutConfiguration__mdt> createOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Create_Order' ];
            System.assertEquals(1, createOrderMDT.size());
            System.assert(String.isNotBlank(createOrderMDT[0].EndPoint__c));
            
            List<HTTPCalloutConfiguration__mdt> addFitToOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Add_Fit_To_Order' ];
            System.assertEquals(1, addFitToOrderMDT.size());
            System.assert(String.isNotBlank(addFitToOrderMDT[0].EndPoint__c));
            
            List<HTTPCalloutConfiguration__mdt> finalizeOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Finalize_Order' ];
            System.assertEquals(1, finalizeOrderMDT.size());
            System.assert(String.isNotBlank(finalizeOrderMDT[0].EndPoint__c));
            
            //Setting Mock
            FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
            FF3_0_Create_Order_Mock createOrderMock = new FF3_0_Create_Order_Mock();
            FF3_0_Add_Fit_To_Order_Mock addFitToOrderMock = new FF3_0_Add_Fit_To_Order_Mock();
            FF3_0_Finalize_Order_Mock finalizeOrderMock = new FF3_0_Finalize_Order_Mock();
            
            Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
            mapMock.put('http://example.com/',accessTokenMock);
            mapMock.put(createOrderMDT[0].EndPoint__c ,createOrderMock);
            mapMock.put(addFitToOrderMDT[0].EndPoint__c ,addFitToOrderMock);
            mapMock.put(finalizeOrderMDT[0].EndPoint__c ,finalizeOrderMock);
            HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
            Test.setMock(HttpCalloutMock.class, multiCalloutMock);
            //Start Test
            Test.startTest();
            
            FF_SizingOrderController ctrl = new FF_SizingOrderController(stdCtrl);
            
            System.assertEquals(2, ctrl.sizingOrderCustomItemsWrapper.size());
            System.assertEquals(2, ctrl.sizingOrderStandardItemsWrapper.size());
            
            ctrl.updateCustomAndStandardItemsRecord();
            
            //Stop Test
            Test.stopTest();
        }
    }
   
     
    @isTest
    static void test_negativeCase3()
    {
        Profile p = [select id 
                     from 
                     Profile 
                     where 
                     name='System Administrator'];
        
        User bdeUser = new user(alias = 'test123', email='test123@noemail.com', 
                                emailencodingkey='UTF-8', firstName='Nahush', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_IN', profileid = p.Id, country='India',
                                timezonesidkey='Asia/Kolkata', username='test_g'+math.random()+'@noemail.com'); 
        insert bdeUser;
        
        
        PermissionSet ps = new PermissionSet(Label = 'mockPs', Name = 'mockPs');
        insert ps;
        
        // Given custom permission associated to the mocked PermissionSet
        SetupEntityAccess sea = new SetupEntityAccess(
            ParentId = ps.Id,
            SetupEntityId = [SELECT Id FROM CustomPermission
                             WHERE DeveloperName = 'Fit_Freedom_User'][0].Id
        );
        insert sea;
        
        // Given mocked Permission Set assigned to user for test
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = bdeUser.Id,
            PermissionSetId = ps.Id
        );
        insert psa;
        system.runAs(bdeUser){
            System.Debug('!!!!!!!!!!!!!!!!!!!!!!! Test Class Starts');
            
            List<Account> accs = [SELECT Id FROM Account];
            System.assertEquals(1, accs.size());
            
            List<Contact> cons = [SELECT Id FROM Contact];
            System.assertEquals(1, cons.size());
            
            List<Opportunity> opps = [SELECT Id FROM Opportunity];
            System.assertEquals(3, opps.size());
            
            List<Fit__c> fits = [SELECT Id FROM Fit__c];
            System.assertEquals(1, fits.size());
            
            List<Rosters__c> ros = [SELECT Id FROM Rosters__c];
            System.assertEquals(1, ros.size());
            
            List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
            System.assertEquals(3, cItems.size());
            
            List<Standardized_Item__c> sItems = [SELECT Id FROM Standardized_Item__c];
            System.assertEquals(3, sItems.size());
            
            //Setting vf page reference
            Test.setCurrentPageReference(Page.FF_SizingOrderVFPage);
            System.currentPageReference().getParameters().put('Id', accs[0].Id);
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accs[0]);
            
            
            //Geting metadata
            List<HTTPCalloutConfiguration__mdt> createOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Create_Order' ];
            System.assertEquals(1, createOrderMDT.size());
            System.assert(String.isNotBlank(createOrderMDT[0].EndPoint__c));
            
            List<HTTPCalloutConfiguration__mdt> addFitToOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Add_Fit_To_Order' ];
            System.assertEquals(1, addFitToOrderMDT.size());
            System.assert(String.isNotBlank(addFitToOrderMDT[0].EndPoint__c));
            
            List<HTTPCalloutConfiguration__mdt> finalizeOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Finalize_Order' ];
            System.assertEquals(1, finalizeOrderMDT.size());
            System.assert(String.isNotBlank(finalizeOrderMDT[0].EndPoint__c));
            
            //Setting Mock
            FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
            FF3_0_Create_Order_Mock createOrderMock = new FF3_0_Create_Order_Mock();
            createOrderMock.body = '{"ad""';
            FF3_0_Add_Fit_To_Order_Mock addFitToOrderMock = new FF3_0_Add_Fit_To_Order_Mock();
            FF3_0_Finalize_Order_Mock finalizeOrderMock = new FF3_0_Finalize_Order_Mock();
            
            Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
            mapMock.put('http://example.com/',accessTokenMock);
            mapMock.put(createOrderMDT[0].EndPoint__c ,createOrderMock);
            mapMock.put(addFitToOrderMDT[0].EndPoint__c ,addFitToOrderMock);
            mapMock.put(finalizeOrderMDT[0].EndPoint__c ,finalizeOrderMock);
            HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
            Test.setMock(HttpCalloutMock.class, multiCalloutMock);
            //Start Test
            Test.startTest();
            
            FF_SizingOrderController ctrl = new FF_SizingOrderController(stdCtrl);
            System.assertEquals(2, ctrl.sizingOrderCustomItemsWrapper.size());
            System.assertEquals(2, ctrl.sizingOrderStandardItemsWrapper.size());
            
            ctrl.updateCustomAndStandardItemsRecord();
            
            //Stop Test
            Test.stopTest();
        }
    }
   
    @isTest
    static void testNeg_invalidGym()
    {
        Profile p = [select id 
                     from 
                     Profile 
                     where 
                     name='System Administrator']; 
        
        User bdeUser = new user(alias = 'test123', email='test123@noemail.com', 
                                emailencodingkey='UTF-8', firstName='Nahush', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_IN', profileid = p.Id, country='India',
                                timezonesidkey='Asia/Kolkata', username='test_g'+math.random()+'@noemail.com'); 
        insert bdeUser;
        
        
        PermissionSet ps = new PermissionSet(Label = 'mockPs', Name = 'mockPs');
        insert ps;
        
        // Given custom permission associated to the mocked PermissionSet
        SetupEntityAccess sea = new SetupEntityAccess(
            ParentId = ps.Id,
            SetupEntityId = [SELECT Id FROM CustomPermission
                             WHERE DeveloperName = 'Fit_Freedom_User'][0].Id
        );
        insert sea;
        
        // Given mocked Permission Set assigned to user for test
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = bdeUser.Id,
            PermissionSetId = ps.Id
        );
        insert psa;
        system.runAs(bdeUser)
        {
            System.Debug('!!!!!!!!!!!!!!!!!!!!!!! Test Class Starts');
            
            List<Account> accs = [SELECT Id,FF_Create_Gym_Successful__c, gym_id__c  FROM Account];
            System.assertEquals(1, accs.size());
			accs[0].FF_Create_Gym_Successful__c = FALSE;
            accs[0].gym_id__c = '';
			update accs;
            List<Account> accsUpdated = [SELECT Id,FF_Create_Gym_Successful__c  FROM Account];
            System.assertEquals(False, accsUpdated[0].FF_Create_Gym_Successful__c);
            
            //Setting vf page reference
            Test.setCurrentPageReference(Page.FF_SizingOrderVFPage);
            System.currentPageReference().getParameters().put('Id', accs[0].Id);
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accs[0]);
            
            
           
        }
    }
   
    
   /*  @isTest
    static void test_saveMethodForCustomAndStandarizedItemBoth()
    {
        Profile p = [select id 
                     from 
                     Profile 
                     where 
                     name='System Administrator']; 
        
        User bdeUser = new user(alias = 'test123', email='test123@noemail.com', 
                                emailencodingkey='UTF-8', firstName='Nahush', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_IN', profileid = p.Id, country='India',
                                timezonesidkey='Asia/Kolkata', username='test_g@noemail.com'); 
        insert bdeUser;
        
        
        PermissionSet ps = new PermissionSet(Label = 'mockPs', Name = 'mockPs');
        insert ps;
        
        // Given custom permission associated to the mocked PermissionSet
        SetupEntityAccess sea = new SetupEntityAccess(
            ParentId = ps.Id,
            SetupEntityId = [SELECT Id FROM CustomPermission
                             WHERE DeveloperName = 'Fit_Freedom_User'][0].Id
        );
        insert sea;
        
        // Given mocked Permission Set assigned to user for test
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = bdeUser.Id,
            PermissionSetId = ps.Id
        );
        insert psa;
        system.runAs(bdeUser){
            System.Debug('!!!!!!!!!!!!!!!!!!!!!!! Test Class Starts');
            
            List<Account> accs = [SELECT Id FROM Account];
            System.assertEquals(1, accs.size());
            
            List<Contact> cons = [SELECT Id FROM Contact];
            System.assertEquals(1, cons.size());
            
            List<Opportunity> opps = [SELECT Id FROM Opportunity];
            System.assertEquals(3, opps.size());
            
            List<Fit__c> fits = [SELECT Id FROM Fit__c];
            System.assertEquals(1, fits.size());
            
            List<Rosters__c> ros = [SELECT Id FROM Rosters__c];
            System.assertEquals(1, ros.size());
            
            List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
            System.assertEquals(3, cItems.size());
            
            List<Standardized_Item__c> sItems = [SELECT Id FROM Standardized_Item__c];
            System.assertEquals(3, sItems.size());
            
            //Setting vf page reference
            Test.setCurrentPageReference(Page.FF_SizingOrderVFPage);
            System.currentPageReference().getParameters().put('Id', accs[0].Id);
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accs[0]);
            
            
            //Geting metadata
            List<HTTPCalloutConfiguration__mdt> createOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Create_Order' ];
            System.assertEquals(1, createOrderMDT.size());
            System.assert(String.isNotBlank(createOrderMDT[0].EndPoint__c));
            
            List<HTTPCalloutConfiguration__mdt> addFitToOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Add_Fit_To_Order' ];
            System.assertEquals(1, addFitToOrderMDT.size());
            System.assert(String.isNotBlank(addFitToOrderMDT[0].EndPoint__c));
            
            List<HTTPCalloutConfiguration__mdt> finalizeOrderMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Finalize_Order' ];
            System.assertEquals(1, finalizeOrderMDT.size());
            System.assert(String.isNotBlank(finalizeOrderMDT[0].EndPoint__c));
            
            //Setting Mock
            FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
            FF3_0_Create_Order_Mock createOrderMock = new FF3_0_Create_Order_Mock();
            FF3_0_Add_Fit_To_Order_Mock addFitToOrderMock = new FF3_0_Add_Fit_To_Order_Mock();
            FF3_0_Finalize_Order_Mock finalizeOrderMock = new FF3_0_Finalize_Order_Mock();
            
            Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
            mapMock.put('http://example.com/',accessTokenMock);
            mapMock.put(createOrderMDT[0].EndPoint__c ,createOrderMock);
            mapMock.put(addFitToOrderMDT[0].EndPoint__c ,addFitToOrderMock);
            mapMock.put(finalizeOrderMDT[0].EndPoint__c ,finalizeOrderMock);
            HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
            Test.setMock(HttpCalloutMock.class, multiCalloutMock);
            //Start Test
            Test.startTest();
            
            FF_SizingOrderController ctrl = new FF_SizingOrderController(stdCtrl);
            
            System.assertEquals(2, ctrl.sizingOrderCustomItemsWrapper.size());
            System.assertEquals(2, ctrl.sizingOrderStandardItemsWrapper.size());
            ctrl.sizingOrderCustomItemsWrapper[0].isSelected = TRUE;
            ctrl.sizingOrderCustomItemsWrapper[0].customItem.Rosters__c = ros[0].id;
            ctrl.sizingOrderStandardItemsWrapper[0].isSelected = TRUE;
            ctrl.sizingOrderStandardItemsWrapper[0].standardItem.Rosters__c = ros[0].id;
            
            ctrl.updateCustomAndStandardItemsRecord();
            
            //Stop Test
            Test.stopTest();
        }
    }
*/
    
}