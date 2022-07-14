trigger Trigger_DocuSignStatus on dsfs__DocuSign_Status__c (after update) {
    if(Label.Docusign_Trigger_Changes == 'true'){
    DocusignStatusTriggerHandler.invokeChatterThroughApex(Trigger.new,trigger.oldMap);
    }
}