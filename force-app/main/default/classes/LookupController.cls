/*
	Description  : Lookup Lightning Component controller class.
	Created By   : Abhinav Sharma
*/
public with sharing class LookupController {

    // returns SOSL result
    public class SearchResult {
        public String value{get;Set;}
        public String id{get;set;}
        public List<String> extraResultData = new List<String>();

        public SearchResult() {
            this.extraResultData = new List<String>();
        }
    }

    /*
     * Returns the "Name" field for a given SObject (e.g. Case has CaseNumber, Account has Name)
     */
    private static String getSobjectNameField(SobjectType sobjType){

        //describes lookup obj and gets its name field
        String nameField = 'Name';
        Schema.DescribeSObjectResult dfrLkp = sobjType.getDescribe();
        for(schema.SObjectField sotype : dfrLkp.fields.getMap().values()){
            Schema.DescribeFieldResult fieldDescObj = sotype.getDescribe();
            if(fieldDescObj.isNameField() ){
                nameField = fieldDescObj.getName();
                break;
            }
        }
        return nameField;
    }

    /*
     * Searches (using SOQL) for a given Sobject type
     */
    @AuraEnabled
    public static String searchSObject(String type, String searchString){
        List<String>extraResultFields = new List<String>();
        // get the list of fields to show under the results based on the objectName (type)
        return searchSObject(type, searchString, extraResultFields);
    }

    @AuraEnabled
    public static String searchSObject(String type, String searchString, List<String> extraResultFields) {
        return searchSObject(type, searchString, extraResultFields, null, null, null, null, false);
    }

    @AuraEnabled
    public static String searchSObject(String type, String searchString, String whereField, Object whereValue) {
        List<String>extraResultFields = new List<String>();
        return searchSObject(type, searchString, extraResultFields, whereField, whereValue, null, null, false);
    }

    @AuraEnabled
    // List<String>extraResultFields  should be based on a fieldset of the current object (type)
    // keep in mind: prefixes. Do we allow reference fields ? (might slow things down too much)
    public static String searchSObject(String type, String searchString, List<String> extraResultFields, String whereField, Object whereValue, String fieldList, String lookupFilters, Boolean removeFilters) {
        
        List<Field> fields = new List<Field>();
        if(String.isNotBlank(fieldList)) {
            fields = (List<Field>) JSON.deserialize(fieldList, List<Field>.class);
        }
        
        List<SearchResult> output = new List<SearchResult>();
        
        // check if type is valid
        SObjectType objType = Schema.getGlobalDescribe().get(type);
        if (objType == null) {
            return null;
        }
        
        String nameField = getSobjectNameField(objType);
        
        String query = createLookupQuery(type,nameField,whereField,whereValue,searchString,extraResultFields,fields,removeFilters);
        
        System.debug('LookupController.searchSObject - query: ' + query);
        List<SObject> results = new List<SObject>();
        
        //Handling exceptions occured by adding lookup filters
        try {
            results = Database.query(query);
        }catch(Exception e){
            String updatedQuery  = createLookupQuery(type,nameField,whereField,whereValue,searchString,extraResultFields,fields,false);
            results = Database.query(updatedQuery);
        }
        
        for(SObject result: results) {
            SearchResult searchResult = new SearchResult();
            searchResult.id = (String) result.get('Id');
            searchResult.value = GenericUtils.xssSafeValue( (String)result.get(nameField) );
            
            // populate extra field values
            for(String extraString : extraResultFields) {
                String extraStringResult = String.valueOf(GenericUtils.getFieldValue(result, extraString));
                if(String.isNotBlank(extraStringResult)) {
                    searchResult.extraResultData.add(GenericUtils.xssSafeValue(extraStringResult));
                }
            }

            output.add(searchResult);
        }

        return JSON.serialize(output);
    }
    
    /**
    *  Method to create query for lookup. 
    */
    private static String createLookupQuery(String type,String nameField,String whereField, Object whereValue, String searchString, 
                                            List<String> extraResultFields, List<Field> fields, Boolean removeFilters) {
        SoqlBuilder builder = SoqlBuilder.create()
            .addSelect(new String[]{
                'Id', nameField
                    })
            .addFrom(type)
            .setLimit(20)
            .addSortAsc(nameField);
                                                
        if (whereField != null) {
            builder.addWhere(SoqlBuilder.eq(whereField, whereValue));
        }
        // query extra fields to be displayed in dropdown
        if(!extraResultFields.isEmpty()) {
            builder.addSelect(extraResultFields);
        }
        if(String.isNotBlank(searchString)) {
            builder.addWhere(SoqlBuilder.valueLike(nameField, '%' + searchString + '%'));
        }
        return builder.toQuery();
    }

    @AuraEnabled
    public static String retrieveDisplayValues(List<String> ids,String objectName) {
        List<SearchResult> output = new List<SearchResult>();

        // check if type is valid
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if(objType == null){
            return null;
        }
        String nameField = getSobjectNameField(objType);

        String solQuery = 'SELECT ' +nameField+ ' FROM '+objectName+ ' WHERE id in :ids';
        list<sObject> objectList=  Database.query(String.escapeSingleQuotes(solQuery));
        for(sObject sObj : objectList) {
            SearchResult sr = new SearchResult();
            sr.id = (String) sobj.get('Id');
            sr.value = GenericUtils.removeScript( (String)sobj.get(nameField));
            if(String.isNotBlank(sr.id) && String.isNotBlank(sr.value)) {
                output.add(sr);
            }
        }

        return JSON.serialize(output);
    }

    /**
     * For the given fieldName, determine whether to use a SOSL function based on the derived field type.
     *
     * @param objType
     * @param fieldName
     *
     * @return
     */
    private static String getSoslExpression(SObjectType objType, String fieldName) {
        DescribeFieldResult fieldDescribe = objType.getDescribe().fields.getMap().get(fieldName).getDescribe();

        if(fieldDescribe.getType() == Schema.DisplayType.CURRENCY || fieldDescribe.getType() == Schema.DisplayType.DATE || fieldDescribe.getType() == Schema.DisplayType.DATETIME || fieldDescribe.getType() == Schema.DisplayType.TIME) {
            return String.format('format({0})', new String[] { fieldName });
        }
        else if(fieldDescribe.getType() == Schema.DisplayType.MULTIPICKLIST || fieldDescribe.getType() == Schema.DisplayType.PICKLIST) {
            return String.format('toLabel({0})', new String[] { fieldName });
        }
        else return fieldName;
    }
}