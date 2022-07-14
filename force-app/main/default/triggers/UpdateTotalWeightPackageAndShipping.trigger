trigger UpdateTotalWeightPackageAndShipping on zkmulti__MCPackage__c (after insert, after update) {
	// Lists to update
	Map<Id,zkmulti__MCShipment__c> shipmentsToUpdateMap = new Map<Id,zkmulti__MCShipment__c>();
    // Get current shipments based on packages
    Set<Id> allShipmentsIdsSet = new Set<Id>();
    for (zkmulti__MCPackage__c pkg :Trigger.new) {
        allShipmentsIdsSet.add(pkg.zkmulti__Shipment__c);
    }
    Map<Id,zkmulti__MCShipment__c> shipmentsMap = new Map<Id, zkmulti__MCShipment__c>([
        	SELECT Total_weight_of_all_packages__c,Total_number_of_packages__c,SCM_to_Zenkraft__c,zkmulti__Carrier__c,zkmulti__Tracking_Number__c,zkmulti__Service_Type__c,
        	(SELECT Id,zkmulti__Weight__c FROM zkmulti__Packages__r) FROM zkmulti__MCShipment__c
        	WHERE Id IN :allShipmentsIdsSet LIMIT 50000]);
    
    // Update shipments with new packages
    
    for (zkmulti__MCShipment__c ship :shipmentsMap.values()) {
        ship.zkmulti__Mod_Key__c = 'ZKMULTI2016';
        ship.Total_weight_of_all_packages__c = 0;
        for (zkmulti__MCPackage__c pkg :ship.zkmulti__Packages__r) {
            ship.Total_weight_of_all_packages__c += pkg.zkmulti__Weight__c;
        }
        ship.Total_Number_of_Packages__c = ship.zkmulti__Packages__r.size();
        shipmentsToUpdateMap.put(ship.id,ship);
    }
    database.update(shipmentsToUpdateMap.values());
    
    // Update Shipping carrier information
    Set<Id> allShippingsIdsSet = new Set<Id>();
    List<SCMC__Shipping__c> shippingsToUpdate = new List<SCMC__Shipping__c>();
    for(zkmulti__MCShipment__c myShip :shipmentsMap.values()) {
        if(myShip.SCM_to_Zenkraft__c != NULL) {
            allShippingsIdsSet.add(myShip.SCM_to_Zenkraft__c);
        }
    }
    Map<Id,SCMC__Shipping__c> shippingsMap = new Map<Id,SCMC__Shipping__c>([
        SELECT Id,SCMC__Carrier__c,SCMC__Carrier_Tracking_Number__c,SCMC__Carrier_Service__c,SCMC__Number_of_Boxes__c,SCMC__Weight__c
        FROM SCMC__Shipping__c WHERE Id IN :allShippingsIdsSet LIMIT 50000]);
    for(zkmulti__MCShipment__c myShip :shipmentsMap.values()) {
        if(myShip.SCM_to_Zenkraft__c != NULL) {
            shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier__c = shipmentsMap.get(myShip.id).zkmulti__Carrier__c;
            shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Tracking_Number__c = shipmentsMap.get(myShip.id).zkmulti__Tracking_Number__c;
            shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Number_of_Boxes__c = shipmentsMap.get(myShip.id).Total_number_of_packages__c;
            shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Weight__c = shipmentsMap.get(myShip.id).Total_weight_of_all_packages__c;
            if(shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'FEDEX_1_DAY_FREIGHT') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx 1Day Freight';} 
           	if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'FEDEX_2_DAY') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx 2Day';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'FEDEX_2_DAY_AM') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx 2Day';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'FEDEX_2_DAY_FREIGHT') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx 2Day Freight';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'FEDEX_3_DAY_FREIGHT') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx 3Day Freight';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'FEDEX_EXPRESS_SAVER') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx Express Saver';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'FEDEX_FIRST_FREIGHT') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx 1Day Freight';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'FEDEX_GROUND') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx Ground Service';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'FIRST_OVERNIGHT') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx First Overnight';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'GROUND_HOME_DELIVERY') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx Home Delivery';}
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'PRIORITY_OVERNIGHT') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx Priority Overnight';}
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'STANDARD_OVERNIGHT') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx Standard Overnight';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'EUROPE_FIRST_INTERNATIONAL_PRIORITY') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx International Priority';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'INTERNATIONAL_ECONOMY') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx International Economy';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'INTERNATIONAL_ECONOMY_FREIGHT') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx International Economy Freight';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'INTERNATIONAL_FIRST') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx International Priority';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'INTERNATIONAL_PRIORITY') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx International Priority';} 
            if (shipmentsMap.get(myShip.id).zkmulti__Service_Type__c == 'INTERNATIONAL_PRIORITY_FREIGHT') {shippingsMap.get(myShip.SCM_to_Zenkraft__c).SCMC__Carrier_Service__c = 'FedEx International Priority Freight';} 
            shippingsToUpdate.add(shippingsMap.get(myShip.SCM_to_Zenkraft__c));
        }
    }
    database.update(shippingsToUpdate);
}