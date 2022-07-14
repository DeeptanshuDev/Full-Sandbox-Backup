trigger DesignRoundTrigger on Design_Round__c (after update,after insert) {
    
    if(Util.BypassAllTriggers) 
    {
        return;    
    }
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        new DesignRoundTriggerHandler().updateDesingRequestFlag(Trigger.new, Trigger.oldMap);
        new DesignRoundTriggerHandler().updateLengthCheckbox(Trigger.new,Trigger.oldMap);
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        new DesignRoundTriggerHandler().afterUpdate(Trigger.new, Trigger.oldMap);
    }
    
}