/** 
* 
* Description : Test class for AddMultipleStandardItemsController.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 04/15/2022
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/

@isTest (seeAllData=false)
private with sharing class AddMultipleStandardItemsController_Test {
      
    /**
    *
    * @description : Test method for AddMultipleStandardItemsController apex class.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/15/2022 - Deeptanshu Bharti
    *
    * coverage : 
    *
    **/
    static testMethod void myFirstMethod_Test()
    {
        Id accountId;
        List<integer> count;
        string indexing;
        Integer inputValue;
        Integer quantity;
        String currentRecordId;
        
        List<Account> accounts = new List<Account>();
        
        List<Contact> contacts = new List<Contact>();
        
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, Type = 'Pro', Phone = '9685741452'));
        }
        insert accounts;
        
        for (Integer i=0;i<10;i++) {
            contacts.add(new Contact(LastName = 'Test'));
        }
        insert contacts;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', Type = 'Reorder',Event_Date_Old__c = System.today(),StageName = 'Open',
                                          AccountId = accounts[0].id, Collection_Picklist__c ='Poly' , Category_Picklist__c = 'Pro', 
                                          Uniform_Style__c = 'Top', Primary_Contact__c = contacts[0].Id, CloseDate = System.today(),SO_De__c='');
        
        
        
        insert opp;
        Opportunity c = [SELECT Id FROM Opportunity WHERE Id =: opp.Id];
        Product2 pr = new Product2(Family = 'E-commerce Items',Product_Category__c='Accessories',Product_Subcategory__c='Athletic',
                                   SubCategory_Detail__c='Dance',Standardized_Style_Number__c='N110',Product_Line_Brand__c='Brikl',
                                   Size__c='Y11',Fabric__c='Lightweight Cotton',ProductCode='RABTEE',Name='#REBELAGAINSTBULLYING Tee',List_Price__c=20);
        insert pr;
        
        Test.startTest();
        Standardized_Item__c newLines2 = new Standardized_Item__c();
        newLines2.Stated_Quantity__c = 2;
        newLines2.Product__c = pr.Id;
        List<integer> cou = new List<integer>();
        cou.add(0);
        AddMultipleStandardItemsController.StandardItemWrapper  empW = new AddMultipleStandardItemsController.StandardItemWrapper(newLines2,5,'RABTEE','0');
        empW.newLines = newLines2;
        empW.checked = false;
        empW.index = 0;
        empW.count = cou;
        
        /*Standardized_Item__c newLines3 = new Standardized_Item__c();
        newLines3.Stated_Quantity__c = 5;
        newLines3.Product__c = pr.Id;
        AddMultipleStandardItemsController.StandardItemWrapper  empW2 = new AddMultipleStandardItemsController.StandardItemWrapper(newLines3,5);
        empW2.newLines = newLines3;
        empW2.checked = false;
        empW2.index = 1;
        empW2.count = cou;*/
        
        //indexing = '5';
        //inputValue = 1;
        List<AddMultipleStandardItemsController.StandardItemWrapper> contactData2 = new List<AddMultipleStandardItemsController.StandardItemWrapper>();
        contactData2.add(empW);
        //contactData2.add(empW2);
        System.debug('the contact data in test class is  : ' + contactData2);
        PageReference testPage = Page.AddMultipleStandardItems;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('recordId', String.valueOf(opp.Id));

        ApexPages.StandardController sc = new  ApexPages.StandardController(opp);     
        AddMultipleStandardItemsController ext = new AddMultipleStandardItemsController(sc);
        //ext.getBase64();
        ext.indexing = '0';
        ext.contactData = contactData2;
        ext.quantity = 1;
        ext.add();
        ext.remove();
        ext.cloneItem();
        ext.addOne();
        PageReference objPageRef1 = ext.cancel();
        PageReference objPageRef5 = ext.save();
        PageReference objPageRef6 = ext.getSelected();
        Test.stopTest();
    }
    
    /**
    *
    * @description : Test method for AddMultipleStandardItemsController apex class.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/15/2022 - Deeptanshu Bharti
    *
    * coverage : 
    *
    **/
    static testMethod void mySecondMethod_Test()
    {
        
        List<Account> accounts = new List<Account>();
        
        List<Contact> contacts = new List<Contact>();
        
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Accounts '+i, Type = 'Pro', Phone = '9685741452'));
        }
        insert accounts;
        
        for (Integer i=0;i<10;i++) {
            contacts.add(new Contact(LastName = 'Testing'));
        }
        insert contacts;
        
        Opportunity opp = new Opportunity(Name = 'Testing Opportunity', Type = 'Reorder',Event_Date_Old__c = System.today(),StageName = 'Open',
                                          AccountId = accounts[0].id, Collection_Picklist__c ='Poly' , Category_Picklist__c = 'Pro', 
                                          Uniform_Style__c = 'Top', Primary_Contact__c = contacts[0].Id, CloseDate = System.today(),SO_De__c='');
        
        
        
        insert opp;
        Opportunity c = [SELECT Id FROM Opportunity WHERE Id =: opp.Id];
        Product2 pr = new Product2(Family = 'E-commerce Items',Product_Category__c='Accessories',Product_Subcategory__c='Athletic',
                                   SubCategory_Detail__c='Dance',Standardized_Style_Number__c='N110',Product_Line_Brand__c='Brikl',
                                   Size__c='Y11',Fabric__c='Lightweight Cotton',ProductCode='RABTEE',Name='#REBELAGAINSTBULLYING Tee',List_Price__c=20);
        insert pr;
        
        Test.startTest();
        Standardized_Item__c newLines2 = new Standardized_Item__c();
        newLines2.Stated_Quantity__c = 2;
        newLines2.Product__c = pr.Id;
        List<integer> cou = new List<integer>();
        cou.add(0);
        Map<Integer,String> mapOfId = new Map<Integer,String>();
        mapOfId.put(0,'RABTEE');
        AddMultipleStandardItemsController.StandardItemWrapper  empW = new AddMultipleStandardItemsController.StandardItemWrapper(newLines2,5,'RABTEE','0');
        empW.newLines = newLines2;
        empW.checked = false;
        empW.index = 0;
        empW.count = cou;
        empW.mapProductCode = mapOfId;
        
        /*Standardized_Item__c newLines3 = new Standardized_Item__c();
        newLines3.Stated_Quantity__c = 5;
        newLines3.Product__c = pr.Id;
        AddMultipleStandardItemsController.StandardItemWrapper  empW2 = new AddMultipleStandardItemsController.StandardItemWrapper(newLines3,5);
        empW2.newLines = newLines3;
        empW2.checked = false;
        empW2.index = 1;
        empW2.count = cou;*/
        
        //indexing = '5';
        //inputValue = 1;
        List<AddMultipleStandardItemsController.StandardItemWrapper> contactData2 = new List<AddMultipleStandardItemsController.StandardItemWrapper>();
        contactData2.add(empW);
        //contactData2.add(empW2);
        System.debug('the contact data in test class is  : ' + contactData2);
        PageReference testPage = Page.AddMultipleStandardItems;
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('recordId', String.valueOf(opp.Id));

        ApexPages.StandardController sc = new  ApexPages.StandardController(opp);     
        AddMultipleStandardItemsController ext = new AddMultipleStandardItemsController(sc);
        //ext.getBase64();
      
    	ext.errorMessage='';
        ext.count = new List<integer>();
    	ext.isConstructorError=false;
        ext.indexing = '0';
        ext.contactData = contactData2;
        ext.add();
        Test.stopTest();
    }

}