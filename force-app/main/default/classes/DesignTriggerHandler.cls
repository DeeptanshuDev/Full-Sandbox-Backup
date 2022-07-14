public class DesignTriggerHandler {

  public void afterUpdate(List<Design__c> newDesigns, Map<Id, Design__c> oldDesignMap) {
    CustomItemStatus status = new CustomItemStatus();
    status.setCustomItemStatusFromDesign(newDesigns, oldDesignMap);
      
  }
    
     public static void updateDesignItems(List<Design__c> newDesigns, Map<Id, Design__c> oldDesignMap) {
    
         set<Id> designRoundIds = new Set<Id>();
         List<Design_Item__c> dsItems = new List<Design_Item__c>();
         for(Design__c ds : newDesigns){
             designRoundIds.add(ds.Design_round__c);
             if(ds.Approved_Art__c = true && ds.Approved_Art__c != oldDesignMap.get(ds.Id).Approved_Art__c){
                 designRoundIds.add(ds.Id);
             }
         }
         
         for(Design_Item__c dd : [select id,design__c from Design_Item__c where design__c IN: designRoundIds]){
             
             Design_Item__c dt = new Design_Item__c();
             dt.Id =dd.Id;
             dt.Approved__c = true;
             dsItems.add(dt);
         } 
         if(dsItems.size() >0){
             update dsItems;
         }
  }
    
}