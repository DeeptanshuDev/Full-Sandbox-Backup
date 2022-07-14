global class CloneOpportunityBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    global Map<String, List<Opportunity>> newOpportunityMapping = new Map<String, List<Opportunity>>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, CloseDate__c, FactoryShipTo__c, opportunityId__c, JsonData__c FROM CustomOpportunity__c');
    }
    
    global void execute(Database.BatchableContext BC, List<CustomOpportunity__c> customOpps){
        
        String customItemRecordTypeId = [SELECT Id FROM RecordType
                                         WHERE DeveloperName = 'Reorder_Custom_Item' AND SObjectType = 'Custom_Item__c'
                                         LIMIT 1].Id;
        
        Map<String, Opportunity> standardOpportunity = new Map<String, Opportunity>();
        Map<String, String> customItemData = new Map<String, String>();
        Map<String, Opportunity> newOpps = new Map<String, Opportunity>();
        List<Custom_Item__c> newCustomItems = new List<Custom_Item__c>();
        
        for(CustomOpportunity__c custOpp : customOpps){
            standardOpportunity.put(custOpp.opportunityId__c, new opportunity(CloseDate=custOpp.CloseDate__c, Factory_Ship_To__c=custOpp.FactoryShipTo__c));
            customItemData.put(custOpp.opportunityId__c,custOpp.JsonData__c);     
        }
        
        for(Opportunity opp : [
            SELECT Id, Name, AccountId, Design_Request__c, Collection_Picklist__c, Category_Picklist__c, Uniform_Style__c, Primary_Contact__c
            FROM Opportunity
            WHERE Id IN:standardOpportunity.keySet()
        ]) {
            Opportunity newOpp = opp.clone();
            newOpp.Probability = .9;
            newOpp.StageName = 'Open';
            newOpp.Prototype_Status__c = 'None';
            newOpp.Type = 'Reorder';
            newOpp.Payment_Status__c = 'Unpaid';
            newOpp.CloseDate = standardOpportunity.get(opp.id).CloseDate;
            newOpp.Factory_Ship_To__c = standardOpportunity.get(opp.id).Factory_Ship_To__c;
            newOpps.put(opp.id,newOpp);
        }
        if(newOpps.size() > 0) {
            insert newOpps.values();
        }
        
        Map<String, Double> customItemsQuantity = new Map<String, Double>();
        Map<String, String> customItemsOpp = new Map<String, String>();
        
        for(String oppId : customItemData.keySet()) {
            String jsOnString = customItemData.get(oppId);
            if(!newOpportunityMapping.containsKey(oppId)) {
                newOpportunityMapping.put(oppId,new List<Opportunity>());
            }
            newOpportunityMapping.get(oppId).add(newOpps.get(oppId));
            List<CloneOpportunityController.ItemWrapper> itemsData = new List<CloneOpportunityController.ItemWrapper>();
            itemsData = (List<CloneOpportunityController.ItemWrapper>)JSON.deserialize(jsOnString, List<CloneOpportunityController.ItemWrapper>.class);
            
            for(CloneOpportunityController.ItemWrapper itemWrap: itemsData) {
                customItemsQuantity.put(itemWrap.Id,itemWrap.quantity);
                customItemsOpp.put(itemWrap.Id,newOpps.get(oppId).id);
                /*Custom_Item__c custItem = new Custom_Item__c();
                custItem.Opportunity__c = newOpps.get(oppId).id;
                custItem.RecordTypeId = customItemRecordTypeId;
                custItem.Quantity__c = itemWrap.quantity;
                // custItem.Item_Number_Edit__c = null;
                custItem.Stated_Quantity__c = itemWrap.quantity;
                newCustomItems.add(custItem);*/
            }
        }
        
        for(Custom_Item__c c : [Select id
                                ,Item_Number_Edit__c
                                ,Name
                                ,Gender__c
                                ,Style__c 
                                ,Price_per_item__c 
                                ,Discount_per_Item__c 
                                ,Price__c
                                ,Quantity__c 
                                ,Total_Price__c 
                                ,Design_Status__c 
                                ,Stage__c 
                                ,Category__c 
                                ,Collection__c 
                                from Custom_Item__c where id IN: customItemsQuantity.keySet()]) {
                                    Custom_Item__c newItem = c.clone();
                                    newItem.Opportunity__c = customItemsOpp.get(c.id);
                                    newItem.Quantity__c = customItemsQuantity.get(c.id);
                                    newItem.Stated_Quantity__c = customItemsQuantity.get(c.id);
                                    newItem.RecordTypeId = customItemRecordTypeId;
                                    newCustomItems.add(newItem);
                                }
        
        if(newCustomItems.size() > 0) {
            insert newCustomItems;
        }
        delete customOpps;        
    }
    
    global void finish(Database.BatchableContext BC) {
        Map<String, String> ownerMailBodyMapping = new Map<String, String>();
        String orgUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/';
        for(Opportunity opp : [Select Id, Account.Owner.Name, Account.Owner.Email From Opportunity Where Id IN:newOpportunityMapping.keySet()]) {
            if(String.isNotBlank(opp.Account.Owner.Email)) {
                if(!ownerMailBodyMapping.containsKey(opp.Account.Owner.Email)) {
                    String body = 'Hey '+opp.Account.Owner.Name+',\n\n';
                    ownerMailBodyMapping.put(opp.Account.Owner.Email, body);
                }
                String body = ownerMailBodyMapping.get(opp.Account.Owner.Email);
                for(Opportunity clonedOpp : newOpportunityMapping.get(opp.id)) {
                    body += 'Opportunity '+clonedOpp.Name+' was created by Account '+UserInfo.getName()+' with the customer portal.'+
                        ' Please see this link ('+orgUrl+clonedOpp.id+') to reassign the opportunity.\n';
                }
                ownerMailBodyMapping.put(opp.Account.Owner.Email,body);
            }
        }
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        for(String emailId : ownerMailBodyMapping.keySet()) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{emailId});
            mail.setSubject('Opportunity Assignment');
            mail.setHtmlBody(ownerMailBodyMapping.get(emailId));
            mailList.add(mail);
        }
        messaging.sendEmail(mailList);
    }
}