trigger Trigger_DocuSign_Recipient_Status on dsfs__DocuSign_Recipient_Status__c (after insert,after update) {
    if(Label.Docusign_Trigger_Changes == 'true'){
        DocusignStatusController.invokeChatterThroughApex(Trigger.new,Trigger.oldMap);
    }
}