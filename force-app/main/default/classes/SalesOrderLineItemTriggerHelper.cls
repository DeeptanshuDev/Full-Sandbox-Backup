public with sharing class SalesOrderLineItemTriggerHelper {
    /**
     *
     *   @description    :  on basis Custom Item Number or Item Master in sales order line item update the total amount in custom item or standard item respectively 
     *
     *   @args           :  List<SCMC__Sales_Order_Line_Item__c>, Map<Id,SCMC__Sales_Order_Line_Item__c>   
     *
     *   @return         :  
     *
     *   @revision Log   :   V1.1 - Created  - 23/05/2022 - Ajay - Comment
     * 
     **/
    public static void updateCISITotalAmount(List<SCMC__Sales_Order_Line_Item__c> listNewSOLI, Map<Id,SCMC__Sales_Order_Line_Item__c> mapOfOldSOLI) {
        
        List<Standardized_Item__c> listStandardizedItemToUpdate = new List<Standardized_Item__c>();
        List<Custom_Item__c> listCustomItemToUpdate = new List<Custom_Item__c>();

        Set<String> setOpportunityNumber = new Set<String>();

        for(SCMC__Sales_Order_Line_Item__c soli : listNewSOLI){
            /*
            if(mapOfOldSOLI != null){
                if(soli.SCMC__Extended_Price__c != mapOfOldSOLI.get(soli.id).SCMC__Extended_Price__c || soli.Custom_Item_Number__c != mapOfOldSOLI.get(soli.id).Custom_Item_Number__c || soli.SCMC__Item_Master__c != mapOfOldSOLI.get(soli.id).SCMC__Item_Master__c){
                    setOpportunityNumber.add(soli.Opportunity_Number__c);
                }
            }else{
                setOpportunityNumber.add(soli.Opportunity_Number__c);
            }
            */
            setOpportunityNumber.add(soli.Opportunity_Number__c);
        }

        // List<SCMC__Sales_Order_Line_Item__c> listTotalLineItems = [SELECT Id, Opportunity_Number__c, SCMC__Sales_Order__c, Custom_Item_Number__c, SCMC__Item_Master__c, SCMC__Item_Master__r.Name, SCMC__Extended_Price__c FROM SCMC__Sales_Order_Line_Item__c WHERE Opportunity_Number__c IN: setOpportunityNumber];

        Map<String, List<SCMC__Sales_Order_Line_Item__c>> mapCINtoListSOLI = new Map<String, List<SCMC__Sales_Order_Line_Item__c>>();
        Map<String, List<SCMC__Sales_Order_Line_Item__c>> mapIMtoListSOLI = new Map<String, List<SCMC__Sales_Order_Line_Item__c>>();

        if(setOpportunityNumber.size()>0){
            for(SCMC__Sales_Order_Line_Item__c soli : [SELECT Id, Opportunity_Number__c, SCMC__Sales_Order__c, Custom_Item_Number__c, SCMC__Item_Master__c, SCMC__Item_Master__r.Name, SCMC__Extended_Price__c FROM SCMC__Sales_Order_Line_Item__c WHERE Opportunity_Number__c IN: setOpportunityNumber]){
                if(String.isNotBlank(soli.Custom_Item_Number__c)){
                    if(mapCINtoListSOLI != null && mapCINtoListSOLI.keySet().contains(soli.Custom_Item_Number__c)){
                        mapCINtoListSOLI.get(soli.Custom_Item_Number__c).add(soli);
                    }else{
                        List<SCMC__Sales_Order_Line_Item__c> listSOLIforMap = new List<SCMC__Sales_Order_Line_Item__c>();
                        listSOLIforMap.add(soli);
                        mapCINtoListSOLI.put(soli.Custom_Item_Number__c,listSOLIforMap);
                    }

                }else if(String.isNotBlank(soli.SCMC__Item_Master__c)){

                    if(mapIMtoListSOLI != null && mapIMtoListSOLI.keySet().contains(soli.SCMC__Item_Master__r.Name)){
                        mapIMtoListSOLI.get(soli.SCMC__Item_Master__r.Name).add(soli);
                    }else{
                        List<SCMC__Sales_Order_Line_Item__c> listSOLIforMap = new List<SCMC__Sales_Order_Line_Item__c>();
                        listSOLIforMap.add(soli);
                        mapIMtoListSOLI.put(soli.SCMC__Item_Master__r.Name,listSOLIforMap);
                    }
                }
                
            }
    
            List<Opportunity> listOpportunities = [SELECT Id, Opportunity_Auto_Number__c,
                (SELECT ID, Item_Number_Edit__c, CI_Total_Amount__c, Total_Price__c FROM Custom_Items__r), 
                (SELECT ID, Product_Code__c, Product__c, SI_Total_Amount__c, Total_Price__c FROM Standardized_Items__r)
                FROM Opportunity WHERE Opportunity_Auto_Number__c IN: setOpportunityNumber];
    
            if(listOpportunities.size()>0){
                for(Opportunity opp : listOpportunities) {
                    for(Custom_Item__c ci : opp.Custom_Items__r){
                        if(mapCINtoListSOLI != null && mapCINtoListSOLI.get(ci.Item_Number_Edit__c) != null){
                            Decimal totalAmount = 0;
                            for(SCMC__Sales_Order_Line_Item__c soli: mapCINtoListSOLI.get(ci.Item_Number_Edit__c)){
                                
                                totalAmount = totalAmount + soli.SCMC__Extended_Price__c;
                            }
                            if(ci.CI_Total_Amount__c != totalAmount){
                            	listCustomItemToUpdate.add(new Custom_Item__c(Id=ci.Id, CI_Total_Amount__c = totalAmount));
                            }
                        }
                    }
    
                    for(Standardized_Item__c si : opp.Standardized_Items__r){
                        if(mapIMtoListSOLI != null && mapIMtoListSOLI.get(si.Product_Code__c) != null){
                            Decimal totalAmount = 0;
                            for(SCMC__Sales_Order_Line_Item__c soli: mapIMtoListSOLI.get(si.Product_Code__c)){
                                totalAmount = totalAmount + soli.SCMC__Extended_Price__c;
                            }
                            if(si.SI_Total_Amount__c != totalAmount){
                            	listStandardizedItemToUpdate.add(new Standardized_Item__c(Id=si.Id, SI_Total_Amount__c = totalAmount));
                            }
                        }
                    }
                }
            }
        }


        if(listCustomItemToUpdate.size()>0){
            update listCustomItemToUpdate;
        }
		
        if(listStandardizedItemToUpdate.size()>0){
            update listStandardizedItemToUpdate;
        }
    }
}