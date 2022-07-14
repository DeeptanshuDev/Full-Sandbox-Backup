public with sharing class PrototypeStatusValues {

    @AuraEnabled(cacheable=true)
    public static List<String> getPicklistValue(){
        List<String> picklistValuesList = new List<String> ();
        Schema.DescribeFieldResult fieldResult = Opportunity.Prototype_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
            picklistValuesList.add(pickListVal.getLabel());

        }
        System.debug('picklistValuesList values are : '+ picklistValuesList);
        return picklistValuesList;
    }
}