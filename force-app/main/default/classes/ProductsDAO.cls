public class ProductsDAO {
    
    public static List<Product2> getProducts(List<String> Ids){
        
        return  [select id,Standardized_Style_Number__c,ProductCode from Product2 where Id IN : Ids];
    }

}