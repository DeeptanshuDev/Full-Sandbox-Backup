trigger triggerAttachment on Attachment (after insert,after update) {
    if(Trigger.isAfter)
    {
        List<c2g__codaInvoice__c> listOfSi = new List<c2g__codaInvoice__c>();
        Set<String> setOfId = new Set<String>();
        
        for(Attachment att : trigger.New)
        {
            //parent id is opportunity id
            
            
            System.debug('the attachment name is : '+att.Name);
            String str = att.Name;
            if(str.containsIgnoreCase('SIN'))
            {
                System.debug('this is the latest attachment with date : ' + att.CreatedDate);
                System.debug('the sales invoice id is : ' + att.Name);
                String s1 = att.Name;
                String s2 = s1.replace('.pdf', '');
                System.debug('s2 value is : ' + s2);
                setOfId.add(s2);
            }
            for(c2g__codaInvoice__c obj : [SELECT Id, Name, Latest_Document_Created_Date__c FROM c2g__codaInvoice__c WHERE Name IN : setOfId])
            {
                System.debug('the sales invoice is : ' + obj);
                System.debug('the sales invoice latest documnet date is : ' + obj.Latest_Document_Created_Date__c);
                obj.Latest_Document_Created_Date__c = System.now();
                System.debug('cuurent date and time is : ' + System.now());
                listOfSi.add(obj);
            }
            if(listOfSi.size()>0)
            {
                update listOfSi;
            }
            /*System.debug('attachment is : ' + att);
            System.debug('sales inovice typoe is : ' + c2g__codaInvoice__c.SobjectType);
            System.debug('atachment object type is : ' + att.ParentId.getSobjectType());
            if(att.ParentId.getSobjectType() == c2g__codaInvoice__c.SobjectType)
            {
                setOfId.add(att.ParentId);
                System.debug('the parent id is : ' + att.ParentId);
                System.assert(false,att.ParentId);
                System.debug('the attachment id is : ' + att.Id);
                System.debug('the attachment name is : ' + att.Name);
                System.debug('the attachment owner is : ' + att.OwnerId);
            }*/
        }
        
    }

}