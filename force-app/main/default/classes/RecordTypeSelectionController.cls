/**
Desription      :  Controller class for RecordTypeSelection lex component 

Created By      :   Abhinav Sharma

Created Date    :  17/09/2018

Revision Logs   :   v1 - Created
**/
public class RecordTypeSelectionController {

    @AuraEnabled
    public static Map<String,String> getRecordType(String objName) {
                
        List<String> recordTypeNames = ObtainAvailableRecordType(objName, false);
            
        Map<String, String> result = new Map<String, String>();
        
        if(String.isNotBlank(objName)) {
            
            for(RecordType rt: [SELECT ID, Name, developerName 
                                FROM RecordType 
                                WHERE IsActive = true 
                                AND sObjectType = :objName 
                                AND Name IN :recordTypeNames 
                               ])
                
                result.put(rt.name, rt.ID);
            System.debug('hello'+result);
        }
        return result;
    }
    
    /*  @description    :  Method to Returns a List of the Names of all RecordTypes available to the running user for a given SOBject type
    *
    *  @args           	:  none
    *
    *  @return         	:   void
    *
    **/
    public static List<String> ObtainAvailableRecordType(String objName, Boolean check) {
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
        Schema.SObjectType objType = schemaMap.get(objName);
        
        List<String> recordTypeNames = new List<String>();
        
        List<RecordTypeInfo> recordTypeDescribe = objType.getDescribe().getRecordTypeInfos();
        
        if(check == true){
            
            // If there are 2 or more RecordTypes
            if (recordTypeDescribe.size() > 1) {
                
                for (RecordTypeInfo rt : recordTypeDescribe) {
                    
                    if(rt.isDefaultRecordTypeMapping()) 
                        recordTypeNames.add(rt.getName());
                } 
            }
        }
        else{   
            // If there are 2 or more RecordTypes
            if (recordTypeDescribe.size() > 1) {
                
                for (RecordTypeInfo rt : recordTypeDescribe) {
                    
                    if (rt.isAvailable() 
                        
                        // Ignore the Master Record Type, whose Id always ends with 'AAA'.
                        // We check the Id because Name can change depending on the user's language.
                        && !String.valueOf(rt.getRecordTypeId()).endsWith('AAA'))
                        recordTypeNames.add(rt.getName());
                }
            } 
            else recordTypeNames.add(recordTypeDescribe[0].getName());
        }
        return recordTypeNames;
    }
    
    
    @AuraEnabled
    public static Map<String,String> getDefaultRecordType(String objName) {
        
        List<String> recordTypeNames = ObtainAvailableRecordType(objName,true);
        
        Map<String, String> result = new Map<String, String>();
        
        if(String.isNotBlank(objName)) {
            
            for(RecordType rt: [SELECT ID, Name, developerName 
                                FROM RecordType 
                                WHERE IsActive = true 
                                AND sObjectType = :objName 
                                AND Name IN :recordTypeNames 
                               ])
                
                result.put(rt.name, rt.ID);
        }
         System.debug('hello'+result);
        return result;
    }
    
}