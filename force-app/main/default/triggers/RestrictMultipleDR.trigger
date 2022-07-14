trigger RestrictMultipleDR on Design_Request__c (before insert) {
    //Gets set of oppIds for the DRs triggering this
    Set<Id> oppIDList = new Set<Id>();
    for (Design_Request__c req:Trigger.new){
        if (req.Opportunity__c != null){
            oppIDList.add(req.Opportunity__c);
        }
    }
    //Compares DRs to see if they have the oppIds already assigned. If they do, adds onto the drList
    List <Design_Request__c> drList = [SELECT Id, Opportunity__c FROM Design_Request__c WHERE Design_Request__c.Opportunity__c IN :oppIDList];
    for (Design_Request__c req:Trigger.new){
        //Checks drList and counts the number of times opps are being used for a DR already. If it's being used already, produces an error.
        Integer count = 0;
        for (Integer i=0; i<drList.size();i++){
            if (req.Opportunity__c == drList[i].Opportunity__c){
                count++;
            }
        }
        if (count>0){
            req.AddError(System.Label.Restrict_Multiple_DR);
        }
    }
}