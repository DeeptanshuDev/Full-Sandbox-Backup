/*
*	Created By:	Daven Tsai
*	Date: 6/09/2022
*	Version: 1.0
*	Description: Reprices Custom Items with Price Expiration Date < Today and sets their new Pricing Expiration Date.
*/
global class CustomItemRepricing implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BD){
        String query = 'SELECT Id, Custom_Item_Reorder__c, Price_per_item__c, Price__c, Product_Style__c, Style_Category__c, Pricing_Expiration_Date__c, Previous_Price__c, Type_of_Discount_CI__c, DI_Early_Bird_Price__c, Price_Expiration_Completed__c,Production_DateStamp__c FROM Custom_Item__c WHERE (Custom_Item_Reorder__c = NULL and Style_Category__c != \'N/A\' and Pricing_Expiration_Date__c < TODAY)';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Custom_Item__c> cItems){
        // Gets list of all Custom Items needing repricing
        List <Custom_Item__c> updateCustItem = new List<Custom_Item__c>();
        System.debug('TEST FOR REFERENCE'+cItems);
        for (Custom_Item__c c : cItems){
            // Non-PW, Volume, Special items
            if (c.Product_Style__c != 'Practicewear' && c.Product_Style__c != 'Custom Bow' && c.Product_Style__c != 'Logo/Add-on' &&
                (c.Type_of_Discount_CI__c == null || (!c.Type_of_Discount_CI__c.contains('Volume') && 
                !c.Type_of_Discount_CI__c.contains('Early Bird') && !c.Type_of_Discount_CI__c.contains('Special')))){
                    c.Previous_Price__c = c.Price_per_item__c;
                    c.Price_Expiration_Completed__c = True;
                    c.Production_DateStamp__c = System.today();
                    c.Pricing_Expiration_Date__c = c.Pricing_Expiration_Date__c+730;
                    
                    c.Price__c = (c.Price_per_Item__c*1.05).round(system.RoundingMode.CEILING);
                    c.Price_per_item__c = c.Price__c;
                    system.debug('Debug Custom Item Info for nonpw, volume, nor special items: '+ c);
            }
            // Practicewears
            else if (c.Product_Style__c == 'Practicewear'){
                // Old EB Item, while Wholesale Price = Selling Price
                if (c.Price_per_item__c == c.Price__c){
                    c.Previous_Price__c = c.Price_per_item__c;
                    c.Price_Expiration_Completed__c = True;
                    c.Production_DateStamp__c = System.today();
                    c.Pricing_Expiration_Date__c = c.Pricing_Expiration_Date__c+365;
                    
                    c.Price__c = (c.Price__c*1.05).round(system.RoundingMode.CEILING);
                    c.Price_per_item__c = (c.Price_per_item__c*1.05).round(system.RoundingMode.CEILING);
                }
                // Old EB Item, while Wholesale Price != Selling Price
                else if (c.Price_per_item__c != c.Price__c && (c.Type_of_Discount_CI__c != null &&c.Type_of_Discount_CI__c.contains('Early Bird'))){
                    c.Previous_Price__c = c.Price_per_item__c;
                    c.Price_Expiration_Completed__c = True;
                    c.Production_DateStamp__c = System.today();
                    c.Pricing_Expiration_Date__c = c.Pricing_Expiration_Date__c+365;
                    
                    c.Price__c = ((c.Price__c+3)*1.05).round(system.RoundingMode.CEILING);
                    c.Price_per_item__c = c.Price__c;
                }
                // PW Item, where WP != SP and Sponsored and SP <= 10
                else if (c.Price_per_item__c != c.Price__c && (c.Type_of_Discount_CI__c != null && c.Type_of_Discount_CI__c == 'Sponsorship')  && 
                         c.Price__c <= 10){
                    c.Previous_Price__c = c.Price_per_item__c;
                    c.Price_Expiration_Completed__c = True;
                    c.Production_DateStamp__c = System.today();
                    c.Pricing_Expiration_Date__c = c.Pricing_Expiration_Date__c+365;
                    
                    if (c.DI_Early_Bird_Price__c != null && c.DI_Early_Bird_Price__c != 0){
                        c.Price__c = ((c.DI_Early_Bird_Price__c+3)*1.05).round(system.RoundingMode.CEILING);
                        c.Price_per_item__c = c.Price__c;
                    }
                    else{
                        c.Price__c = ((c.Price_per_item__c+3)*1.05).round(system.RoundingMode.CEILING);
                        c.Price_per_item__c = c.Price__c;
                    }
                }
                // PW Item, where WP != SP and Sponsored and SP > 10
                else if (c.Price_per_item__c != c.Price__c && (c.Type_of_Discount_CI__c != null && c.Type_of_Discount_CI__c == 'Sponsorship') &&
                         c.Price__c > 10){
                    c.Previous_Price__c = c.Price_per_item__c;
                    c.Price_Expiration_Completed__c = True;
                    c.Production_DateStamp__c = System.today();
                    c.Pricing_Expiration_Date__c = c.Pricing_Expiration_Date__c+365;
                    
                    c.Price__c = ((c.Price_per_Item__c+3)*1.05).round(system.RoundingMode.CEILING);
                    c.Price_per_item__c = c.Price__c;
                }
                // PW Item, where WP != SP and SP > 10
                else if (c.Price_per_item__c != c.Price__c && (c.Type_of_Discount_CI__c != null && !c.Type_of_Discount_CI__c.contains('Early Bird')) &&
                         c.Price__c > 10){
                    c.Previous_Price__c = c.Price_per_item__c;
                    c.Price_Expiration_Completed__c = True;
                    c.Production_DateStamp__c = System.today();
                    c.Pricing_Expiration_Date__c = c.Pricing_Expiration_Date__c+365;
                    
                    c.Price__c = ((c.Price__c+3)*1.05).round(system.RoundingMode.CEILING);
                    c.Price_per_item__c = c.Price__c;
                }
                //Catches all other PW exceptions
                else {
                    c.Previous_Price__c = c.Price_per_item__c;
                    c.Price_Expiration_Completed__c = True;
                    c.Production_DateStamp__c = System.today();
                    c.Pricing_Expiration_Date__c = c.Pricing_Expiration_Date__c+365;
                    
                    c.Price__c = ((c.Price_per_item__c)*1.05).round(system.RoundingMode.CEILING);
                    c.Price_per_item__c = c.Price__c; 
                }
            }    
            // Volume
            else if (c.Price_per_item__c != c.Price__c && c.Product_Style__c != 'Practicewear' && 
                     c.Product_Style__c != 'Custom Bow' && c.Product_Style__c != 'Logo/Add-on' &&
                     (c.Type_of_Discount_CI__c != null && c.Type_of_Discount_CI__c.contains('Volume'))){
                c.Previous_Price__c = c.Price_per_item__c;
                c.Price_Expiration_Completed__c = True;
                c.Production_DateStamp__c = System.today();
                c.Pricing_Expiration_Date__c = c.Pricing_Expiration_Date__c+730;
                
                c.Price__c = (c.Price_per_Item__c*1.03).round(system.RoundingMode.CEILING);
                c.Price_per_item__c = c.Price__c;
            }
            // Special
            else if (c.Product_Style__c != 'Practicewear' && 
                c.Product_Style__c != 'Custom Bow' && c.Product_Style__c != 'Logo/Add-on' &&
                (c.Type_of_Discount_CI__c != null && c.Type_of_Discount_CI__c.contains('Wholesale Special'))){
                    c.Previous_Price__c = c.Price_per_item__c;
                    c.Price_Expiration_Completed__c = True;
                    c.Production_DateStamp__c = System.today();
                    c.Pricing_Expiration_Date__c = c.Pricing_Expiration_Date__c+730;
                    
                    c.Price__c = (c.Price__c*1.05).round(system.RoundingMode.CEILING);
                    c.Price_per_item__c = (c.Price_per_Item__c*1.05).round(system.RoundingMode.CEILING);
            }
            updateCustItem.add(c);
        }
        try{
        	List<Database.SaveResult> results = Database.update(updateCustItem,false);
            for (Database.SaveResult result:results){
                if (!result.isSuccess()){
                    for (Database.Error err:result.getErrors()){
                        System.debug('Error: ' + err.getStatusCode() + ' '+ err.getMessage());
                    }
                }
            }
        }
        catch(DmlException de){
            System.debug('testing: '+de);
        }
    }
    global void finish(Database.BatchableContext BC){
    }
}