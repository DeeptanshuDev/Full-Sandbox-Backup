@isTest
public class UpdateTotalWeightPackageAndShippingTest {
	@isTest
    private static void PackageCreationTestMethod() {
        SCMC__Shipping__c myShipping = new SCMC__Shipping__c(SCMC__Status__c = 'Queued for shipment items issued',
                                                             SCMC__Requestor_Department__c = 'Sales',
                                                             SCMC__Shipment_Services__c = 'Most Economical');
        database.insert(myShipping);
        zkmulti__MCShipment__c myShipment = new zkmulti__MCShipment__c(zkmulti__Recipient_Name__c = 'test',
                                                                       zkmulti__Recipient_Company__c = 'testcompany',
                                                                       zkmulti__Recipient_Street__c = 'teststreet',
                                                                       zkmulti__Recipient_Email__c = 'test@email.com',
                                                                       zkmulti__Recipient_Phone__c = '1231231234',
                                                                       zkmulti__Recipient_Country__c = 'United States',
                                                                       zkmulti__Recipient_Zip_Postal_Code__c = '12332',
                                                                       zkmulti__Recipient_State_Province__c = 'TN',
                                                                       zkmulti__Recipient_City__c = 'testville',
                                                                       SCM_to_Zenkraft__c = myShipping.id,
                                                                       zkmulti__Service_Type__c = 'FEDEX_1_DAY_FREIGHT');
        database.insert(myShipment);
        List<zkmulti__MCPackage__c> myPackages = new List<zkmulti__MCPackage__c>();
        zkmulti__MCPackage__c myPackage = new zkmulti__MCPackage__c(zkmulti__PackageProfileDescription__c = 'test',
                                                                    zkmulti__Carrier__c = 'FedEx',
                                                                    zkmulti__Packaging_Type__c = 'Your Packing',
                                                                    zkmulti__Quantity__c = 1,
                                                                    zkmulti__DeclaredValue__c = 1,
                                                                    zkmulti__Height__c = 3,
                                                                    zkmulti__Length__c = 3,
                                                                    zkmulti__Width__c = 3,
                                                                    zkmulti__Weight__c = 3,
                                                                    zkmulti__Shipment__c = myShipment.id);
        myPackages.add(myPackage);
        zkmulti__MCPackage__c myPackage2 = new zkmulti__MCPackage__c(zkmulti__PackageProfileDescription__c = 'test2',
                                                                    zkmulti__Carrier__c = 'FedEx',
                                                                    zkmulti__Packaging_Type__c = 'Your Packing',
                                                                    zkmulti__Quantity__c = 1,
                                                                    zkmulti__DeclaredValue__c = 1,
                                                                    zkmulti__Height__c = 4,
                                                                    zkmulti__Length__c = 4,
                                                                    zkmulti__Width__c = 4,
                                                                    zkmulti__Weight__c = 4,
                                                                    zkmulti__Shipment__c = myShipment.id);
       myPackages.add(myPackage2);
       database.insert(myPackages);
        
       zkmulti__MCShipment__c myShipmentQuery = [SELECT Id,Total_weight_of_all_packages__c FROM zkmulti__MCShipment__c WHERE Id =:myShipment.id];
       SCMC__Shipping__c myShippingQuery = [SELECT Id,SCMC__Carrier_Service__c FROM SCMC__Shipping__c WHERE Id =:myShipping.id];
       system.assertEquals('FedEx 1Day Freight', myShippingQuery.SCMC__Carrier_Service__c);
       system.assertEquals(myPackage.zkmulti__Weight__c + myPackage2.zkmulti__Weight__c, myShipmentQuery.Total_weight_of_all_packages__c);
    }
}