//Testing POC for CR-20210323-15018 - created by - chirag soni - 05/12/2021
public without sharing class LookupfieldController1 
{    
    @AuraEnabled(cacheable = true)
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value) 
    {
        try 
        {
            List<SObJectResult> sObjectResultList = new List<SObJectResult>();
            if(String.isNotBlank(ObjectName) && String.isNotBlank(fieldName) && String.isNotBlank(value)) 
            {
                String dataBaseQuery = 'Select Id,'+fieldName+', c2g__ReportingCode__c FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\'';
                System.debug(dataBaseQuery);
                for(sObject so : Database.Query(dataBaseQuery)) 
                { 
                    System.debug(so);
                    String fieldvalue = (String)so.get(fieldName);
                    String reportingCode = (String)so.get('c2g__ReportingCode__c');
                    sObjectResultList.add(new SObjectResult(fieldvalue, so.Id, reportingCode));
                }
            }
            return sObjectResultList;    
        }
        catch(Exception ex)
        {
            return null;  
        }
    }
    
    @AuraEnabled(cacheable = false)
    public static boolean saveAndUpdateEABEvent(Id eabEventId, String reportingCode)
    {
        try
        {
            if(String.isNotBlank(eabEventId) && String.isNotBlank(reportingCode)){
                Schema.SObjectType token = eabEventId.getSobjectType();
                Sobject customObject = token.newSObject();
                customObject.put('Id', eabEventId);
                customObject.put('Budgeted_Cost_Center__c', reportingCode); 
                update customObject;
            }
            return true;  
        }
        catch(Exception ex)
        {
            return false;  
        }
    }
    
    public class SObJectResult 
    {
        @AuraEnabled
        public String recName {get; set;}
        
        @AuraEnabled
        public Id recId {get; set;}
        
        @AuraEnabled
        public String recCode {get; set;}
        
        public SObJectResult(String recNameTemp, Id recIdTemp, String recCodeTemp) 
        {
            recName = recNameTemp;
            recId = recIdTemp;
            recCode = recCodeTemp;
        }
    }
}