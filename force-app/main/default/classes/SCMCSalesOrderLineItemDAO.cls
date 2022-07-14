/**
*  Description     :  DAO Class to handle the soqls for SCMC_Sales_Order_Line_Item__c object 
*
*  Created By      :  Ajay
*
*  Created Date    :  12/05/2022
*
*  Revision Logs   :  V1.0 - Created By - Ajay
*
**/
public class SCMCSalesOrderLineItemDAO {
    
    /**
    *
    *   @description    :  method to return list of SCMC__Sales_Order_Line_Item__c with the SCMC__Sales_Order__c id given
    * 
    *   @args           :  Set<Id>
    *
    *   @return         :  List<SCMC__Sales_Order_Line_Item__c>
    *
    *   @revision Log   :   V1.1 - Created  -  12/05/2022 	-		Ajay 
    * 
    **/
    public static List<SCMC__Sales_Order_Line_Item__c> getSCMCSalesOrderLineItems(Set<Id> setsalesOrderLineIds){
        
        return [SELECT Id, Custom_Item__c,Order_Type__c,SCMC__Sales_Order__c,Shipment_Status__c,Custom_Item__r.Commission_Rate__c FROM SCMC__Sales_Order_Line_Item__c WHERE SCMC__Sales_Order__c IN: setsalesOrderLineIds];
    }
}