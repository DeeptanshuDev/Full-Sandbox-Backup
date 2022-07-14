trigger DesignItemTrigger on Design_Item__c (before insert, before update, after insert, after update) {
  
    if(ExecutionManagerUtilities.byPassAllTriggers) 
    {
        return;
    }  
    
  if (Trigger.isBefore) 
  {
    if (Trigger.isInsert) 
    {
      new DesignItemManager().beforeInsert(Trigger.new);
        new DesignItemManager().updateCIbasedOnDI(Trigger.new,Trigger.oldMap);
    }
    else if (Trigger.isUpdate) 
    {
      new DesignItemManager().beforeUpdate(Trigger.new);
        //new DesignItemManager().updateCIbasedOnDI(Trigger.new,Trigger.oldMap);
    }
  }

  if (Trigger.isAfter) 
  {
    if (Trigger.isInsert) 
    {
      new DesignItemManager().afterInsert(Trigger.new);
    }
    else if (Trigger.isUpdate) 
    {
      new DesignItemManager().afterUpdate(Trigger.new);
    }
  }
}