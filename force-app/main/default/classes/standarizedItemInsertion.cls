public class standarizedItemInsertion {
    @AuraEnabled
    public static void saveStandarizedItemList(List<Standardized_Item__c> newList) 
	{        
        for(Standardized_Item__c obj : newList)
        {
            System.assert(false,obj);
        }
    }
    
    @AuraEnabled
    public static Product2 getProductcode(String pc)  
    {
        System.debug('the product code is : ' +pc);
        
        Product2 pr = [SELECT Id,Family,Product_Category__c,Product_Subcategory__c,SubCategory_Detail__c,Standardized_Style_Number__c,
                       Product_Line_Brand__c,Size__c,Fabric__c,ProductCode,Name FROM Product2 WHERE ProductCode =: pc];
        
        return pr;
        
        
    }

}