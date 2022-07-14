@isTest
public with sharing class SalesOrderAllocateTestHelper 
{
	public static SCMC__Sales_Order__c setupTestDataForSO() 
	{
		SCMC__Currency_Master__c curr = new SCMC__Currency_Master__c(name = 'USD', SCMC__Active__c = true, SCMC__Corporate_Currency__c = true);
		insert curr;
		
		SCMC__Organization_Settings__c orgSettings = new SCMC__Organization_Settings__c(SCMC__Partial_Shipments__c = true, 
														SCMC__Do_Not_Allow_Partial_Invoicing__c = true);
		insert orgSettings;
		
		Account acc = new account(Name='Test Account', SCMC__Active__c=true, SCMC__Customer__c=true);
		insert acc;
		
		SCMC__Product_Group__c pgroup = new SCMC__Product_Group__c(name = 'Test Product Group');
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
								SCMC__Product_Group__c = pgroup.id, SCMC__Item_Type__c = 'Product', SCMC__Active_Status__c = true);
		insert item;
		
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
		
		return so;
	}
}