/**
*  Description     :  DAO Class to handle the soqls for Design Items 
*
*  Created By      :  Ajay
*
*  Created Date    :  13/05/2022
*
*  Revision Logs   :  V1.0 - Created By - Ajay
*
**/
public class DesignItemDAO {
    /**
     *
     *   @description    :  method to return list of Design Items by ids
     * 
     *   @args           :  List<Design_Item__c>
     *
     *   @return         :  List<Design_Item__c>
     *
     *   @revision Log   :   V1.1 - Created  -  13/05/2022 	-		Ajay 
     * 
     **/
    public static List<Design_Item__c> getDesignItemsById(List<Design_Item__c> items) {
        return [
      		SELECT Id, Design__c, Price__c, Design__r.Design_Request__c, Custom_Item__r.Product_Style__c,
        		Standardized_Item__c, Custom_Item__c, Custom_Item__r.Name, Type_of_Discount__c,
       			Early_Bird_Price__c, Wholesale_Price__c
      		FROM Design_Item__c
      		WHERE Id IN :items
   			];
    }
    
    /**
     *
     *   @description    :  method to return list of Design Items with custom item and designstatus
     * 
     *   @args           :  List<Id>
     *
     *   @return         :  List<Design_Item__c>
     *
     *   @revision Log   :   V1.1 - Created  -  13/05/2022 	-		Ajay 
     * 
	 **/
	public static List<Design_Item__c> getDesignItemByIdWithCustomItemAndDesignStatus(List<Id> designItemIds) {
        return [
            SELECT Id, Custom_Item__c, Custom_Item__r.Design_Status__c, Design__c, Design__r.Design_Round__c, Design__r.Needs_Pricing__c
            FROM Design_Item__c
            WHERE Id IN :designItemIds
            AND Custom_Item__c != null
            AND (Custom_Item__r.Stage__c != 'Grey Out' AND Custom_Item__r.Stage__c != 'Production' AND (Custom_Item__r.Design_Status__c !='(D) TechPack Sent' AND Custom_Item__r.Design_Status__c !='(P)(T) Design Request Complete'  AND Design_Status__c !='(T) Tech Pack FTP\'d'))
        ];
    }
    
    /**
     *
     *   @description    :  method to return list of Design Items with custom item and designstatus
     * 
     *   @args           :  List<Id>
     *
     *   @return         :  List<Design_Item__c>
     *
     *   @revision Log   :   V1.1 - Created  -  13/05/2022 	-		Ajay 
     * 
	 **/
    public static List<Design_Item__c> getDesignItemsByRound(List<Id> designRoundIds) {
        return [
            SELECT Id, Custom_Item__c, Custom_Item__r.Design_Status__c, Design__c, Design__r.Design_Round__c
            FROM Design_Item__c
            WHERE Design__r.Design_Round__c IN :designRoundIds
            AND Custom_Item__c != null
            AND (Custom_Item__r.Stage__c != 'Grey Out' AND Custom_Item__r.Stage__c != 'Production' AND (Design_Status__c !='(D) TechPack Sent' AND Design_Status__c !='(P)(T) Design Request Complete'  AND Design_Status__c !='(T) Tech Pack FTP\'d'))
            
        ];
    }
    
}