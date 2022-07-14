public class CustomItemDAO {

    public static List<Custom_Item__c> getCustomItem(Set<Id> oppIds, String gender){ 
        
        return  [SELECT Id,Gender__c,Pushed_to_AFS__c FROM Custom_Item__c WHERE Opportunity__c IN: oppIds AND Gender__c =: gender];
    }
    
    public static List<Custom_Item__c> getCustomItemWithStyle(Set<Id> oppsId){
        
        return [select id,Style__c FROM Custom_Item__c where Opportunity__c IN : oppsId];
    }
    
    public static List<Custom_Item__c> getCustomItemWithOpportunity(Set<Id> setOppIds){
        
        return [SELECT Id, Opportunity__c, FF_Is_Submitted__c, order_id__c, FF_Create_Item_Successful__c
                FROM Custom_Item__c 
                WHERE Opportunity__c =: setOppIds];
    }
    
    public static List<Custom_Item__c> getCustomItemWithAccLookup(Set<Id> setItemIds){
        
        return [SELECT Id,Account_Lookup__c, Opportunity__r.Account.Id FROM Custom_Item__c Where ID =: setItemIds];
    }
    
    public static List<Custom_Item__c> getCustomItemWithNameAndOpp(Set<Id> setOfCustIds){
        
        return [SELECT Id,Name,Pushed_to_AFS__c,Opportunity__c FROM Custom_Item__c WHERE Id IN: setOfCustIds];
    }
    
    public static List<Custom_Item__c> getCustomItemWithProductStyleAndName(Set<Id> setIds){
        
        return [Select Id, Product_Style__c, Name FROM Custom_Item__c WHERE Id IN :setIds];
    }
   
    public static List<Custom_Item__c> getCustomItemByDesignRequestIds(List<Id> designRequestIds) {
        return [
            SELECT Id, Design_Status__c, Design_Request__c
            FROM Custom_Item__c
            WHERE Design_Request__c IN :designRequestIds
            AND (Stage__c != 'Grey Out' AND Stage__c != 'Production' AND (Design_Status__c !='(D) TechPack Sent' AND Design_Status__c !='(P)(T) Design Request Complete'  AND Design_Status__c !='(T) Tech Pack FTP\'d'))
        ];
    }
    
    public static List<Custom_Item__c> getCustomItemOppRelation(Set<Id> setOfCustomItemIds){
        return [SELECT Id, Opportunity__c,Opportunity__r.Is_Item_Finished__c FROM Custom_Item__c where Id IN: setOfCustomItemIds];
    }
    
    public static List<Custom_Item__c> getCustomItemInLine(Set<Id> setCustomITemIds){
        
        return [SELECT Id, (SELECT Id, recommended_sizes__c FROM Order_Sizes__r) FROM Custom_Item__c where Id IN: setCustomITemIds];
    }

}