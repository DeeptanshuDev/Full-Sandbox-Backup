/*
 Description  : Search Lightning Component controller class.
 Created By   : Abhinav Sharma
*/
/**
* @description     This class is used as the apex controller for the Search lighning component
*                  You can search on an object and it's related objects like a search on Contact and
*                  search on Contacts for a related Account. This should also work for other objects like Design__c
*/
public with sharing class SearchController {
    
    /** @description wrapper class for returning result **/
    public class SearchForResult{
        @AuraEnabled public List<SObject> recordsFound {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String message {get;set;}
        @AuraEnabled public String objectLabel {get;set;}
        
        public SearchForResult(){
            recordsFound = new List<SObject>();
        }
    }
    
    /** @description Method for retrieving the initial records **/
    @AuraEnabled
    public static SearchForResult SearchIds(List<Id> ids, String objectApiName, String jsonRelatedObjects, String jsonFieldList){
        SearchForResult result = new SearchForResult();
        String soql = 'SELECT ' + String.escapeSingleQuotes(GetFieldsToQuery(jsonFieldList, true)) + ' FROM ' + String.escapeSingleQuotes(objectApiName) + ' WHERE id in :ids';
        List<SObject> soqlResult = Database.query(soql);
        result.recordsFound.addAll(soqlResult);
        result.status = 'SUCCESS';
        return result;
    }
    
    /** @description Method for searching records with SOSL and process the search result with SOQL **/
    @AuraEnabled
    public static SearchForResult SearchFor(String searchText, String objectApiName, String jsonRelatedObjects, String jsonFieldList, String whereClause){
        if (whereClause == null) {
            whereClause = '';
        }
        
        try {
            //Create Dynamic SOSL qeury
            String fieldsReturning = '(Id)';
            if (String.isNotBlank(whereClause)) {
                fieldsReturning = '(Id WHERE ' + whereClause + ')';
            }
            String sosl = 'FIND :searchText IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(objectApiName) + ' ' + String.escapeSingleQuotes(fieldsReturning);
            
            //Get related objects
            Map<String, Object> relatedObjectsMap = getRelatedObjectsMap(jsonRelatedObjects);
            sosl += String.escapeSingleQuotes(getRelatedObjects(relatedObjectsMap));
            
            //Execute SOSL query
            List<List <sObject>> soslResult = Search.query(sosl);
            
            //Do a query on the main object and return
            return QueryRecords(objectApiName, relatedObjectsMap, soslResult, jsonFieldList, whereClause, null);
        }catch(Exception ex){
            System.debug('### ERROR: ' + ex.getMessage());
            SearchForResult sr = new SearchForResult();
            sr.status = 'ERROR';
            sr.message = ex.getMessage();
            return sr;
        }
    }
    
    /** @description Method for searching records with SOSL and process the search result with SOQL **/
    @AuraEnabled
    public static SearchForResult retrieveSearchData(String objectApiName, String jsonRelatedObjects, String jsonFieldList, String whereClause){
        SearchForResult result = new SearchForResult();
        if (whereClause == null) {
            whereClause = '';
        }
        try {
            Map<String, Object> relatedObjectsMap = getRelatedObjectsMap(jsonRelatedObjects);
            List<List<sObject>> recentItemsList = getRecentItems(objectApiName, jsonRelatedObjects, jsonFieldList);
            String orderBy = 'ORDER BY LastViewedDate DESC';
            if (recentItemsList.size() != 0) {
                result = QueryRecords(objectApiName, relatedObjectsMap, recentItemsList, jsonFieldList, whereClause, orderBy);
            }
        }catch(Exception ex){
            System.debug('\r\rERROR: Failed to created SearchForResult with initialization. Error is: ' + ex.getMessage());
        }
        
        try {
            result.objectLabel = Schema.getGlobalDescribe().get(objectApiName).getDescribe().getLabelPlural().toLowerCase();
        }catch(Exception ex){
            result.objectLabel = '';
            System.debug('\r\rError in getting object plural label: ' + ex.getMessage());
        }
        
        System.debug('\r\rresult: ' + result);
        return result;
    }
    
    /** @description Method will return a SaveResult object based on the SOSL result */
    private static SearchForResult QueryRecords(String objectApiName, Map<String, Object> relatedObjectsMap, List<List<sObject>> soslResult, String jsonFieldList, String whereClause, String orderBy){
        SearchForResult result = new SearchForResult();
        whereClause = String.escapeSingleQuotes(whereClause);
        System.debug('\r\rsoslResult: ' + soslResult);
        //Create a map of fields and Id Set to be used in the where clause
        Map<String, Set<Id>> relatedFieldMap = new Map<String, Set<Id>>();
        for(List<SObject> objectRecordList:soslResult){
            if(!objectRecordList.isEmpty()){
                String objectName = objectRecordList.get(0).getSObjectType().getDescribe().getName();
                if (objectName == 'RecentlyViewed') {
                    objectName = objectApiName;
                }
                Set<Id> idSet = (new Map<Id,SObject>(objectRecordList)).keySet().clone();
                if(objectName == objectApiName){
                    relatedFieldMap.put('Id', idSet);
                }else{
                    relatedFieldMap.put((String) relatedObjectsMap.get(objectName), idSet);
                }
            }
        }
        
        System.debug('\r\rrelatedFieldMap: ' + relatedFieldMap);
        
        //Create clause for the related fields/records
        String relatedFieldWhereClause = '(';
        for(String fieldName : relatedFieldMap.keySet()){
            if(!relatedFieldMap.get(fieldName).isEmpty()) {
                if (relatedFieldWhereClause != '(') {
                    relatedFieldWhereClause += ' OR';
                }
                relatedFieldWhereClause += ' ' + fieldName + ' IN ' + getStringOfIds(relatedFieldMap.get(fieldName));
            }
        }
        relatedFieldWhereClause += ')';
        
        if (relatedFieldWhereClause != '()') {
            if (String.isNotBlank(whereClause)) {
                whereClause += ' AND ';
            }
            whereClause += relatedFieldWhereClause;
        }
        
        System.debug('\r\rwhereClause: ' + whereClause);
        
        if(!relatedFieldMap.isEmpty() && whereClause != '') {
            String fieldsToQuery = GetFieldsToQuery(jsonFieldList, false);
            System.debug('\r\rfieldsToQuery: ' + fieldsToQuery);
            if(!fieldsToQuery.containsIgnoreCase('Image_url__c') && (objectApiName == 'Contact' || objectApiName.endsWithIgnoreCase('cxsCandidate__c'))) {
                fieldsToQuery += ', ' + GenericUtils.getPackagePrefix() + 'Image_Url__c';
            }
            String soql = 'SELECT ' + String.escapeSingleQuotes(fieldsToQuery) + ' FROM ' + String.escapeSingleQuotes(objectApiName);
            if (String.isNotBlank(whereClause)) {
                soql += ' WHERE ' + whereClause;
            }
            if (String.isNotBlank(orderBy)) {
                soql += ' ' + String.escapeSingleQuotes(orderBy);
            }
            
            System.debug('\r\rsoql query 1: ' + soql);
            List<SObject> soqlResult = Database.query(soql);
            result.recordsFound.addAll(soqlResult);
            result.status = 'SUCCESS';
        }
        else{
            result.status = 'NO_RECORDS_FOUND';
            result.message = System.Label.No_Records_Found;
        }
        
        //Return result
        return result;
    }
    
    /** @description Method will return a string of id's from a set of id's for usage in where clause */
    private static String GetStringOfIds(Set<Id> idSet){
        String stringOfIds = '(';
        
        //Loop trough id's and add it to the string with quotes and comma separated
        for(Id recordId : idSet){
            stringOfIds += '\'' + String.escapeSingleQuotes(recordId) + '\',';
        }
        
        //If ends with a comma, remove it and add the ) to close the set
        if(stringOfIds.endsWith(',')){
            stringOfIds = stringOfIds.left(stringOfIds.length()-1);
        }
        stringOfIds += ')';
        
        //return string of ids
        return stringOfIds;
    }
    
    /** @description Method will create a string of fields from a json field array for using in a dynamic soql query */
    private static String GetFieldsToQuery(String jsonFieldList, Boolean addIdField){
        String fieldString = '';
        
        if(addIdField){
            fieldString += 'Id';
        }
        
        //Parse list of fields from json
        if(String.isNotBlank(jsonFieldList) && jsonFieldList != 'null' && jsonFieldList != '[]'){
            
            List<Object> fieldList = (List<Object>) JSON.deserializeUntyped(jsonFieldList);
            if(!fieldList.isEmpty()) {
                if(fieldString != '') {
                    fieldString += ',';
                }
                for (Object fld : fieldList) {
                    fieldString += (String) fld + ',';
                }
                if (fieldString != null) {
                    //Remove the last comma
                    fieldString = fieldString.left(fieldString.length() - 1);
                }
            }
        }
        //No fields added
        if(fieldString == '') {
            //No fields? then we will return the Id field
            fieldString = 'Id';
        }
        return fieldString;
    }
    
    private static Map<String, Object> getRelatedObjectsMap(String jsonRelatedObjects) {
        Map<String, Object> relatedObjectsMap = new Map<String, Object>();
        if (String.isNotBlank(jsonRelatedObjects) && jsonRelatedObjects != 'null') {
            relatedObjectsMap = (Map<String, Object>) JSON.deserializeUntyped(jsonRelatedObjects);
        }
        return relatedObjectsMap;
    }
    
    // Get related objects
    private static String getRelatedObjects(Map<String, Object> relatedObjectsMap) {
        String relatedObjects = '';
        for (String key : relatedObjectsMap.keySet()) {
            relatedObjects += ', ' + key + ' (Id)';
        }
        return relatedObjects;
    }
    
    private static List<List<sObject>> getRecentItems(String objectApiName, String jsonRelatedObjects, String jsonFieldList) {
        String query = 'SELECT Id FROM RecentlyViewed WHERE Type IN (\'' + String.escapeSingleQuotes(objectApiName) + '\') ORDER BY LastViewedDate DESC LIMIT 20';
        List<List<sObject>> recentItemsList = new List<List<sObject>>();
        List<sObject> recentItems = Database.query(query);
        // Only add the recentItems to the recentItemsList if there were records returned.
        if (recentItems.size() != 0) {
            recentItemsList.add(recentItems);
        }
        return recentItemsList;
    }
}