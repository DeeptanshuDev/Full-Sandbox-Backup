trigger OpportunityTrigger on Opportunity (after update, before insert, before update,after insert) {

     if(Util.BypassAllTriggers) 
    {
        return;    
    }
    
  if (Trigger.isBefore && Trigger.isUpdate) {
      
      OpportunityManager.invokeApprovalProcessForOpportunity(Trigger.new,Trigger.oldMap);
      OpportunityManager mgr = new OpportunityManager();
      mgr.beforeUpdate(Trigger.new, Trigger.old);
      soNeedTriggerHandlerCheckbox.triggerMethod2(Trigger.new, Trigger.oldMap);
      OpportunityManager.approvalRejectMethod(Trigger.new, Trigger.oldMap);
  }

  if (Trigger.isBefore && Trigger.isInsert) {
      OpportunityManager mgr = new OpportunityManager();
      String bd = '';
      for(Opportunity opp : trigger.new){
          bd = opp.Business_Development__c;
      }
      soNeedTriggerHandlerCheckbox.triggerMethod2(Trigger.new, Trigger.oldMap);
      OpportunityManager.forBdPicklistValueForBdUser(Trigger.new, Trigger.oldMap);
  }
    
    if (Trigger.isAfter && Trigger.isUpdate){
        OpportunityManager.updateReleatedItems(Trigger.new,Trigger.oldMap);
        OpportunityManager mgr = new OpportunityManager();
        mgr.updateRelatedCustomItemAFS(Trigger.new,Trigger.oldMap);
        OpportunityManager.opportunityShareDelete(Trigger.new, Trigger.oldMap);
        OpportunityManager.bdApprovalCheckboxChanges(Trigger.new, Trigger.oldMap);  
    }
    if(Trigger.isAfter && Trigger.isInsert)
    {
        OpportunityManager.approvalCheckOnAccount(Trigger.new, Trigger.oldMap);
    }
    
}