trigger LetterOfIntentTrigger on Letter_Of_Intent__c (after insert,after update) {
    if(Trigger.isAfter)
    {
        LetterOfIntentTriggerHandler.getSalesOrderNumber(Trigger.new,Trigger.oldMap);
    }

}