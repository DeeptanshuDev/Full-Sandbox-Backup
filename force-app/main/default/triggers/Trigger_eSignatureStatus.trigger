trigger Trigger_eSignatureStatus on eSignature_Status__c (after update) {
 if(Trigger.isAfter && Trigger.isUpdate)
    {
        eSignatureStatusTriggerHandler.postChatter(Trigger.new);
        eSignatureStatusTriggerHandler.updateCustomItem(Trigger.new , Trigger.oldMap);
    }
}