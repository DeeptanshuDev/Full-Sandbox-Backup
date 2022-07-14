public class SalesOrderTriggerHandler {

    public static void updateSalesOrderLineItems(List<SCMC__Sales_Order__c> items, Map<Id, SCMC__Sales_Order__c> oldItems) {
        
        Set<Id> salesOrderLineIds = new Set<Id>();
        Set<Id> salesOrderIds = new Set<Id>();
        Set<Id> salesOrderWithBD = new Set<Id>();
        Set<Id> salesOrderOldSponsor = new Set<Id>();
        Set<Id> salesOrderSoldAsPW = new Set<Id>();
        Set<Id> salesOrderCombination = new Set<Id>();
        Set<Id> userId = new Set<Id>();
        Map<String,String> mapOfUrIdSO = new Map<String, String>();
        Map<String,String> mapOfUrIdCommission = new Map<String, String>();
        List<SCMC__Sales_Order_Line_Item__c> soliToUpdate = new List<SCMC__Sales_Order_Line_Item__c>();
        List<SCMC__Sales_Order_Line_Item__c> soliToUpdate2 = new List<SCMC__Sales_Order_Line_Item__c>();
        List<SCMC__Sales_Order_Line_Item__c> soliToUpdate3 = new List<SCMC__Sales_Order_Line_Item__c>();
        List<SCMC__Sales_Order_Line_Item__c> soliToUpdate4 = new List<SCMC__Sales_Order_Line_Item__c>();
        List<SCMC__Sales_Order_Line_Item__c> soliToUpdate5 = new List<SCMC__Sales_Order_Line_Item__c>();
        List<SCMC__Sales_Order_Line_Item__c> soliToUpdateCombination = new List<SCMC__Sales_Order_Line_Item__c>();
        Set<Id> setOfSOId = new Set<Id>();
        
        for(SCMC__Sales_Order__c so : items){
            // Commented out since I think it can just re-run on every update
            //if(oldItems == null || (so.Order_Type__c != oldItems.get(so.Id).Order_Type__c)){
                salesOrderLineIds.add(so.Id);
            if (oldItems != null && oldItems.get(so.Id).Order_Type__c == 'Sponsor' && so.Order_Type__c != 'Sponsor'){
                salesOrderOldSponsor.add(so.Id);
            }
                
                // Here we add opp id in set
                if(so.Opportunity__c != null){
                	setOfSOId.add(so.Id);
                }
            //}
        
            
         /*   String temp = so.Opportunity__c;
            System.debug('opp owner  is : ' + temp);
            if(temp!=NULL)
            {
                Opportunity opp = [SELECT Id, Name, OwnerId,Business_Development__c FROM Opportunity WHERE Id =: temp];
                userId.add(opp.OwnerId);
                mapOfUrIdSO.put(opp.OwnerId,so.Id);
                
                //Added code for BD Commission Split
                if (opp.Business_Development__c != NULL){
                    salesOrderWithBD.add(so.Id);
                }
            }*/
        }
        
        if(setOfSOId.size()> 0){
            // Here We fetch all the opp associated with sales order 
            for(SCMC__Sales_Order__c so : [SELECT id , Opportunity__r.OwnerId , Opportunity__r.Business_Development__c, Opportunity__r.Number_of_Uniform_Sold_as_PW__c FROM SCMC__Sales_Order__c WHERE Id IN: setOfSOId]){
                userId.add(so.Opportunity__r.OwnerId);
                mapOfUrIdSO.put(so.Opportunity__r.OwnerId,so.Id);
            	//Uniform Sold as PW
                if (so.Opportunity__r.Number_of_Uniform_Sold_as_PW__c > 0){
                    salesOrderSoldAsPW.add(so.Id);
                }
                //BD Commission Split
                if (so.Opportunity__r.Business_Development__c != NULL){
                    salesOrderWithBD.add(so.Id);
                }
        	}
        }
        //Commission Override
        for(User ur : [SELECT Id,Commission_Override__c,Name FROM User WHERE Id IN: userId])
        {
            System.debug('user is : ' + ur);
            if(ur.Commission_Override__c != NULL)
            {
                string t = mapOfUrIdSO.get(ur.Id);
                System.debug('the value of so is : ' + t);
                salesOrderIds.add(t);
                system.debug(ur.Commission_Override__c);
                
                // Here Map of  sales order id and related user commission override 
                mapOfUrIdCommission.put(t,String.valueOf(ur.Commission_Override__c));
            }
        }
        // Sponsorship Commission
        if(salesOrderLineIds.size() > 0){
            for(SCMC__Sales_Order_Line_Item__c si : [SELECT Id, Custom_Item__c,Order_Type__c,SCMC__Sales_Order__c,Shipment_Status__c,Custom_Item__r.Commission_Rate__c,Original_Commission_Rate__c,BD_Commission_Rate__c,Commission_Rate__c FROM SCMC__Sales_Order_Line_Item__c WHERE SCMC__Sales_Order__c IN: salesOrderLineIds]){
                if(si.Order_Type__c == 'Sponsor' && si.Commission_Rate__c != 0){
                    SCMC__Sales_Order_Line_Item__c sc = new SCMC__Sales_Order_Line_Item__c();
                    if (si.BD_Commission_Rate__c!=NULL){
                        sc.Original_Commission_Rate__c = si.Commission_Rate__c + si.BD_Commission_Rate__c;
                    }
                    else{
                        sc.Original_Commission_Rate__c = si.Commission_Rate__c;
                    }
                    sc.BD_Commission_Amount__c = NULL;
                    sc.BD_Commission_Rate__c = NULL;
                    
                    sc.Id = si.Id;
                    sc.Commission_Rate__c = 0;
                    soliToUpdate.add(sc);
                }
            }
        }
        if(soliToUpdate.size() > 0){   
            update soliToUpdate;
            System.debug('the updated value is  : ' + soliToUpdate);
        }
        // Was Sponsored, but not anymore
        if (salesOrderOldSponsor.size() > 0){
            for(SCMC__Sales_Order_Line_Item__c si : [SELECT Id, Custom_Item__c,Order_Type__c,SCMC__Sales_Order__c,Shipment_Status__c,Custom_Item__r.Commission_Rate__c, Original_Commission_Rate__c,Commission_Rate__c FROM SCMC__Sales_Order_Line_Item__c WHERE SCMC__Sales_Order__c IN: salesOrderOldSponsor]){
                if (si.Order_Type__c != 'Sponsor' && si.Original_Commission_Rate__c != NULL){
                    SCMC__Sales_Order_Line_Item__c sc = new SCMC__Sales_Order_Line_Item__c();
                    sc.Commission_Rate__c = si.Original_Commission_Rate__c;
                    sc.Id = si.Id;
                    system.debug(sc.Original_Commission_Rate__c);
                    sc.Original_Commission_Rate__C = NULL;
                    sc.BD_Commission_Rate__c = NULL;
                    sc.BD_Commission_Amount__c = NULL;
                    soliToUpdate4.add(sc);
                }
            }
        }
        if (soliToUpdate4.size()>0){
            update soliToUpdate4;
        }
        //Combination of both SoldAsPW&Commission Override
        if (salesOrderSoldAsPW.size()>0 && salesOrderIds.size() > 0){
            for (Id objId:salesOrderIds){
                if (salesOrderSoldAsPW.contains(objId)){
                    salesOrderCombination.add(objId);
                    salesOrderSoldAsPW.remove(objId);
                    salesOrderIds.remove(objId);
                }
            }
            if (salesOrderCombination.size()>0){
                for(SCMC__Sales_Order_Line_Item__c si : [SELECT Id, Custom_Item__c,Order_Type__c,SCMC__Sales_Order__c,Shipment_Status__c,Commission_Rate__c, Original_Commission_Rate__c,Shipping_Rate__c,Custom_Item__r.Uniform_Sold_as_Practicewear_6_Ship__c FROM SCMC__Sales_Order_Line_Item__c WHERE SCMC__Sales_Order__c IN: salesOrderCombination]){
                    if (si.Order_Type__c != 'Sponsor' && si.Original_Commission_Rate__c == NULL){
                        SCMC__Sales_Order_Line_Item__c sc = new SCMC__Sales_Order_Line_Item__c();
                        sc.Id = si.Id;
                        sc.Commission_Rate__c = Double.valueOf(mapOfUrIdCommission.get(si.SCMC__Sales_Order__c));
                        sc.Shipping_Rate__c = 6;
                        soliToUpdateCombination.add(sc);
                    }
                }
            }
        }
        if (soliToUpdateCombination.size()>0){
            update soliToUpdateCombination;
        }
        // Uniform Sold as PW
        if (salesOrderSoldAsPW.size()>0){
            for(SCMC__Sales_Order_Line_Item__c si : [SELECT Id, Custom_Item__c,Order_Type__c,SCMC__Sales_Order__c,Shipment_Status__c,Commission_Rate__c, Original_Commission_Rate__c,Shipping_Rate__c,Custom_Item__r.Uniform_Sold_as_Practicewear_6_Ship__c FROM SCMC__Sales_Order_Line_Item__c WHERE SCMC__Sales_Order__c IN: salesOrderSoldAsPW]){
            	system.debug('How many uniform sold as pw?: ' + salesOrderSoldAsPW.size());
                if (si.Order_Type__c != 'Sponsor' && si.Original_Commission_Rate__c == NULL && si.Custom_Item__r.Uniform_Sold_as_Practicewear_6_Ship__c == true && (si.Commission_Rate__c != 10 && si.Shipping_Rate__c != 6)){
                    SCMC__Sales_Order_Line_Item__c sc = new SCMC__Sales_Order_Line_Item__c();
                    sc.Id = si.Id;
                    sc.Commission_Rate__c = 10;
                    sc.Shipping_Rate__c = 6;
                    soliToUpdate5.add(sc);
                }
            }
        }
        if(soliToUpdate5.size() > 0){   
            update soliToUpdate5;
        }
        // User Commission Override
        if(salesOrderIds.size() > 0){            
            for(SCMC__Sales_Order_Line_Item__c si : [SELECT Id, Custom_Item__c,Order_Type__c,SCMC__Sales_Order__c,Shipment_Status__c,Custom_Item__r.Commission_Rate__c, Original_Commission_Rate__c FROM SCMC__Sales_Order_Line_Item__c WHERE SCMC__Sales_Order__c IN: salesOrderIds]){
                system.debug('#############@@@@@@@@@@@@@@@@2'+ si.Original_Commission_Rate__c);
                if(si.Order_Type__c != 'Sponsor' && si.Original_Commission_Rate__c == NULL){
                    SCMC__Sales_Order_Line_Item__c sc = new SCMC__Sales_Order_Line_Item__c();
                    sc.Id = si.Id;
                    System.debug('commision rate is  : ' + sc.Commission_Rate__c);
                    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' + mapOfUrIdCommission.get(si.SCMC__Sales_Order__c));
                    sc.Commission_Rate__c = Double.valueOf(mapOfUrIdCommission.get(si.SCMC__Sales_Order__c));
                    //System.assert(false,sc.Commission_Rate__c);
                    soliToUpdate2.add(sc);
                }
            }
        }
        if(soliToUpdate2.size() > 0){   
            update soliToUpdate2;
        }
            
        // BD Commission Split
        if (salesOrderWithBD.size() > 0){
            for(SCMC__Sales_Order_Line_Item__c si : [SELECT Id, Custom_Item__c,Order_Type__c,SCMC__Sales_Order__c,Shipment_Status__c,Custom_Item__r.Commission_Rate__c, Original_Commission_Rate__c,Commission_Rate__c FROM SCMC__Sales_Order_Line_Item__c WHERE SCMC__Sales_Order__c IN: salesOrderWithBD]){
                if (si.Commission_Rate__c >= 2 && si.Original_Commission_Rate__c == NULL){
                    SCMC__Sales_Order_Line_Item__c sc = new SCMC__Sales_Order_Line_Item__c();
                    sc.Id = si.Id;
                    sc.Original_Commission_Rate__C = si.Commission_Rate__c;
                    sc.Commission_Rate__c = sc.Original_Commission_Rate__c-2;
                    system.debug(sc.Original_Commission_Rate__c);
                    sc.BD_Commission_Rate__c = 2;
                    soliToUpdate3.add(sc);
                }
            }
        }
        if (soliToUpdate3.size()>0){
            update soliToUpdate3;
        }
    }
}