trigger Trigger_Receivedorder on SCMC__Received_Order_Line__c (before insert,before update) {

     //To provide mapping between Item Master and Received Order Line Item.
        if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
            ReceivedOrderLineTriggerHandler.populateItemMaster(Trigger.new, Trigger.oldMap);
        }
}