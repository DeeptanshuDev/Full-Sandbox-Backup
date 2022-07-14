trigger invoicingTrigger on SCMC__Invoicing__c (after insert) {
    
    if (Trigger.isAfter && Trigger.isInsert) 
    {
        //opportunityChatterWithLink.invoiceChatter(Trigger.new, Trigger.oldMap);
    }

}