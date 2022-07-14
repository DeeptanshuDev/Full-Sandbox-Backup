trigger DesignTrigger on Design__c (before insert, before update, before delete, after insert,
  after update) {

      if(Util.BypassAllTriggers) 
      {
          return;    
      }
  if (Trigger.isAfter && Trigger.isUpdate) {
    new DesignTriggerHandler().afterUpdate(Trigger.new, Trigger.oldMap);
     
  }
       if (Trigger.isBefore && Trigger.isUpdate) {
     
      DesignTriggerHandler.updateDesignItems(Trigger.new, Trigger.oldMap);
  }
}