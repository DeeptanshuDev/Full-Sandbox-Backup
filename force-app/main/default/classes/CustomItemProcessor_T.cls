@isTest
public class CustomItemProcessor_T {
    @testsetup static void createTestData() {
        /*  This is shamelessly copied from SalesOrderAllocateTestHelper.setupTestDataForSO - but unfortunately, a
            data error in the Item insertion prevents me from calling it directly.
         */
        Custom_Item_Automation_Settings__c settings = Custom_Item_Automation_Settings__c.getOrgDefaults();
        settings.Active__c = true;
        settings.Update_Last_Sold_time__c = true;
        settings.Create_Custom_Item_Masters__c = true;
        upsert settings;

        SCMC__Currency_Master__c curr = new SCMC__Currency_Master__c(name = 'USD', SCMC__Active__c = true, SCMC__Corporate_Currency__c = true);
        insert curr;

        SCMC__Organization_Settings__c orgSettings = new SCMC__Organization_Settings__c(SCMC__Partial_Shipments__c = true,
        SCMC__Do_Not_Allow_Partial_Invoicing__c = true);
        insert orgSettings;

        Account acc = new account(Name='Test Account', SCMC__Active__c=true, SCMC__Customer__c=true);
        insert acc;

        SCMC__Product_Group__c pgroup = new SCMC__Product_Group__c(name = 'General');
        insert pgroup;

        SCMC__Address__c address = new SCMC__Address__c(name = 'Test Address', SCMC__City__c = 'A City', SCMC__Country__c = 'Country',
        SCMC__Line1__c = 'Address line 1', SCMC__PostalCode__c = 'Postcd', SCMC__State__c = 'State');
        insert address;

        SCMC__ICP__c icp = new SCMC__ICP__c(SCMC__Address__c = address.id, name = 'Test ICP', SCMC__Currency__c = curr.id,
        SCMC__ILS_User__c = 'xxxxxxx', SCMC__ILS_Password__c = 'yyyyyy');
        insert icp;

        SCMC__Warehouse__c warehouse = new SCMC__Warehouse__c(SCMC__ICP__c = icp.id, SCMC__Address__c = address.id, name = 'Test Warehouse');
        insert warehouse;

        SCMC__Item__c item = new SCMC__Item__c(name = 'SMTest Item', SCMC__Item_Description__c = 'Test part for unit tests',
        SCMC__Product_Group__c = pgroup.id, SCMC__Item_Type__c = 'Product', SCMC__Active_Status__c = true, Product_Subcategory__c = '');
        insert item;

        Opportunity opp = new Opportunity(AccountId = acc.id, Name='Testing Opp', StageName = 'Confirmed', CloseDate = system.today(),
        Category_Picklist__c = 'Pro Team', Collection_Picklist__c = 'Uniform Style');
        insert opp;

        Design_Request__c designRequest = new Design_Request__c(Account__c = opp.AccountId, Opportunity__c = opp.Id);
        insert designRequest;

        Custom_Item__c customItem = new Custom_Item__c(Design_Request__c = designRequest.Id, Opportunity__c = opp.Id, Price_per_item__c = 20,
        Quantity__c = 30, Style__c = 'U101 - Girls Full-length Top', Fabric_Options__c = 'Spandex', Collection__c = 'Couture');
        insert customItem;

        SCMC__Inventory_Location__c location = new SCMC__Inventory_Location__c(name = 'Level1', SCMC__Level1__c = 'Level1', SCMC__Warehouse__c = warehouse.id);
        insert location;

        Id soRecordTypeId = (Schema.SObjectType.SCMC__Sales_Order__c).getRecordTypeInfosByName().get('Inventory').getRecordTypeId();
        SCMC__Sales_Order__c so = new SCMC__Sales_Order__c(SCMC__Customer_Account__c=acc.Id, RecordTypeId=soRecordTypeId, SCMC__Status__c='New',
        SCMC__Sales_Order_Date__c=system.today(), SCMC__Currency__c=curr.Id);
        insert so;

        Id solRecordTypeId = (Schema.SObjectType.SCMC__Sales_Order_Line_Item__c).getRecordTypeInfosByName().get('Item').getRecordTypeId();
        SCMC__Sales_Order_Line_Item__c salesOrderLineItem = new SCMC__Sales_Order_Line_Item__c(SCMC__Sales_Order__c = so.Id,
        SCMC__Item_Master__c =  item.Id, SCMC__Quantity__c = 2, SCMC__Price__c = 100,
        RecordTypeId = solRecordTypeId);

        SCMC__Sales_Order_Line_Item__c salesOrderLineItem1 = new SCMC__Sales_Order_Line_Item__c(SCMC__Sales_Order__c = so.Id,
        SCMC__Item_Master__c =  item.Id, SCMC__Quantity__c = 2, SCMC__Price__c = 100,
        RecordTypeId = solRecordTypeId);
        insert new List<SCMC__Sales_Order_Line_Item__c>{salesOrderLineItem, salesOrderLineItem1};



        SCMC__Inventory_Position__c ip = new SCMC__Inventory_Position__c(SCMC__Acquisition_Cost__c = 55.00, SCMC__Acquisition_Currency__c = curr.id,
        SCMC__Availability__c = true, SCMC__Bin__c = location.id, SCMC__Current_Value__c = 55.00, SCMC__Availability_Code__c = 'In Stock',
        SCMC__ICP_Acquisition_Cost__c = 55.00, SCMC__ICP_Currency__c = curr.id, SCMC__ILS_Eligible__c = false,
        SCMC__Item_Master__c = item.Id, SCMC__Listed_on_ILS__c = false, SCMC__Lot_Number__c = null,
        SCMC__Manufacturer_CAGE__c = null, SCMC__Owned_By__c = null, SCMC__Quantity_Allocated__c = 0,
        SCMC__Quantity__c = 100, SCMC__Quantity_in_Transit__c = 0, SCMC__Receipt_Line__c = null,
        SCMC__Receiving_Inspection__c = null, SCMC__Reserve_Price__c = 60.00, SCMC__Revision_Level__c =  null,
        SCMC__Sale_Price__c = 65.00, SCMC__Item_Serial_Number__c = null, SCMC__Shelf_Life_Expiration__c = null,
        SCMC__List_Type__c = 'Y', SCMC__Sales_Order_Line_Item__c = salesOrderLineItem.id);
        insert ip;
    }

    static testmethod void testCreateSalesOrder() {
        //Get created opportunity
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity LIMIT 1];

        //Query a sales order line items to clone
        SCMC__Sales_Order_Line_Item__c baseLine = [SELECT SCMC__Sales_Order__c, SCMC__Item_Master__c, SCMC__Quantity__c,
                                                          SCMC__Price__c, RecordTypeId, SCMC__Item_Master__r.Last_Sold__c
                                                     FROM SCMC__Sales_Order_Line_Item__c
                                                    LIMIT 1];

        //Query the custom item
        Custom_Item__c customItem = [SELECT Id, Name, Item_Number__c, Collection__c FROM Custom_Item__c LIMIT 1];

        //Validate Last Ordered has been updated
        system.assertNotEquals(null, baseLine.SCMC__Item_Master__r.Last_Sold__c, 'Last Sold was not updated correctly.');


        //Add a new line for a custom item
        DateTime dtNow = system.now();
        SCMC__Sales_Order_Line_Item__c newLine = baseLine.clone();

        //Remove the item master
        newLine.SCMC__Item_Master__c = null;
        newLine.Custom_Item__c = customItem.Id;

        insert newLine;

        //Query the inserted line to ensure a new item master record was created for it
        newLine = [SELECT Id, SCMC__Sales_Order__c, SCMC__Item_Master__c, SCMC__Item_Master__r.CreatedDate,
                          SCMC__Item_Master__r.Name, SCMC__Item_Master__r.Collection__c
                     FROM SCMC__Sales_Order_Line_Item__c
                    WHERE Id =: newLine.id];

        //Validate line parameters
        system.assertNotEquals(null, newLine.SCMC__Item_Master__c); //Was item master selected?
        system.assertEquals(baseLine.SCMC__Sales_Order__c, newLine.SCMC__Sales_Order__c); //Is the line still on the right order?
        system.assertNotEquals(baseLine.SCMC__Item_Master__c, newLine.SCMC__Item_Master__c);  //Is the item master different than the original?
        system.assertEquals(customItem.Collection__c, newLine.SCMC__Item_Master__r.Collection__c);  //Was the collection copied over correctly?

        //Now change some style attributes and see what happens
        String oldItemName = newLine.SCMC__Item_Master__r.Name;

        customItem.Collection__c = 'Purple Label';
        customItem.Sub_Collection__c = 'Rebel Mark* Allstar';
        update customItem;

        newLine.Collection__c = customItem.Collection__c;
        update newLine;

        //We should have a new item master with a revision name
        newLine = [SELECT Id, SCMC__Sales_Order__c, SCMC__Item_Master__c, SCMC__Item_Master__r.CreatedDate,
                          SCMC__Item_Master__r.Collection__c, SCMC__Item_Master__r.Sub_Collection__c,
                          SCMC__Item_Master__r.Name
        FROM SCMC__Sales_Order_Line_Item__c
        WHERE Id =: newLine.id];

        system.assertEquals(customItem.Collection__c, newLine.SCMC__Item_Master__r.Collection__c, JSON.serialize(newLine));
        system.assertEquals(customItem.Sub_Collection__c, newLine.SCMC__Item_Master__r.Sub_Collection__c);
        system.assertEquals(oldItemName + ' Rev. 1', newLine.SCMC__Item_Master__r.Name);
    }

    static testmethod void testCreateQuote() {
        //Get created opportunity, custom item, and default item
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity LIMIT 1];
        Custom_Item__c customItem = [SELECT Id, Name, Item_Number__c, Collection__c, Sub_Collection__c FROM Custom_Item__c LIMIT 1];
        SCMC__Item__c defaultItem = [SELECT Id FROM SCMC__Item__c LIMIT 1];

        //Create a new quote
        SCMC__Customer_Quotation__c quote = new SCMC__Customer_Quotation__c(SCMC__Opportunity__c = opp.id);
        insert quote;

        //Create a quote line with a custom item
        SCMC__Customer_Quotation_Line__c line = new SCMC__Customer_Quotation_Line__c(
                SCMC__Customer_Quotation__c = quote.id,
                SCMC__Quantity__c = 1,
                Custom_Item__c = customItem.id,
                SCMC__Item_Number__c = defaultItem.id
        );
        insert line;

        //Reload the line and make sure the custom item generated an item master
        line = [SELECT Id, SCMC__Item_Number__c, SCMC__Item_Number__r.Collection__c,
                        SCMC__Item_Number__r.Sub_Collection__c, SCMC__Item_Number__r.Name
                FROM SCMC__Customer_Quotation_Line__c
                WHERE Id =: line.id LIMIT 1];

        system.assertNotEquals(null, line.SCMC__Item_Number__c);
        system.assertEquals(customItem.Collection__c, line.SCMC__Item_Number__r.Collection__c);
        system.assertEquals(customItem.Sub_Collection__c, line.SCMC__Item_Number__r.Sub_Collection__c);

        //Store the old item name so we know the revision name
        String oldItemName = line.SCMC__Item_Number__r.Name;

        //Change the custom item's collection and subcollection
        customItem.Collection__c = 'Purple Label';
        customItem.Sub_Collection__c = 'Rebel Mark* Allstar';
        update customItem;

        //Force a refresh on the line
        line.Custom_Item__c = null;
        update line;

        line.Custom_Item__c = customItem.id;
        update line;

        //Requery the line
        line = [SELECT Id, SCMC__Item_Number__c, SCMC__Item_Number__r.Collection__c,
                       SCMC__Item_Number__r.Sub_Collection__c, SCMC__Item_Number__r.Name
                FROM SCMC__Customer_Quotation_Line__c
                WHERE Id =: line.id LIMIT 1];

        system.assertEquals(customItem.Collection__c, line.SCMC__Item_Number__r.Collection__c, JSON.serialize(line));
        system.assertEquals(customItem.Sub_Collection__c, line.SCMC__Item_Number__r.Sub_Collection__c);
        system.assertEquals(oldItemName + ' Rev. 1', line.SCMC__Item_Number__r.Name);
    }
}