public class CustomItemInsertAndUpdateTest {
   public static Id recordId;
    public static void insertMethod(){
        Custom_Item__c obj = new Custom_Item__c();
        obj.Name = 'Deeptanshu Testing12415';
        obj.Design_Status__c = '(D) In Pricing';
        obj.Opportunity__c = '0066u000002eiw4';
        obj.Category__c = 'Pro';
        obj.Gender__c = 'Boy';
        obj.Product_Style__c = 'Uniform';
        obj.Quantity__c = 2;
        obj.Price_per_item__c = 10;
        obj.Fabric_Options__c = 'Test';
        obj.Style_Category__c = 'Tops';
        obj.Collection__c = 'Poly';
        obj.Style_Subcategory__c = 'Choker';
        obj.Stated_Quantity__c = 2;
        insert obj;
        recordId = obj.Id;
    }
    
    public static void updateMethod()
    {
        List<Custom_Item__c> listToUp =new List<Custom_Item__c>();
        List<Custom_Item__c> obj2 = [SELECT Id,Name,LastModifiedDate,Grey_Out_Reason__c, Price_Expiration_Completed__c, Custom_Item_Reorder__c, Pricing_Expiration_Date__c FROM Custom_Item__c WHERE Custom_Item_Reorder__c= NULL AND Pricing_Expiration_Date__c <= TODAY];
        for(Custom_Item__c obj : obj2)
        {
            System.debug('custom item is : ' + obj);
            System.debug('last modified date is  : ' + obj.LastModifiedDate);
            System.debug('Grey_Out_Reason__c are :   '+ obj.Grey_Out_Reason__c);
            //obj.Grey_Out_Reason__c = 'Silent';
            listToUp.add(obj);
        }
        if(listToUp !=NULL)
        {
            update listToUp;
        }
    }
    
     public static void thirdMethod()
    {
        
        List<Custom_Item__c> obj2 = [SELECT Id,Name,LastModifiedDate,Grey_Out_Reason__c, Price_Expiration_Completed__c, Custom_Item_Reorder__c, Pricing_Expiration_Date__c FROM Custom_Item__c WHERE Custom_Item_Reorder__c= NULL AND Pricing_Expiration_Date__c <= TODAY];
        for(Custom_Item__c obj : obj2)
        {
            System.debug('custom item is : ' + obj);
            System.debug('last modified date is  : ' + obj.LastModifiedDate);
            System.debug('Grey_Out_Reason__c are :   '+ obj.Grey_Out_Reason__c);
        }
        
    }

}