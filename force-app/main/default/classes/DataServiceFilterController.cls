/*
 Description  : Data Service Filters Controller class
 Created By   : Abhinav Sharma
*/
public without sharing class DataServiceFilterController {
    
    private static final Integer PAGE_SIZE = 8;
    private static final Integer MAX_RESULTS = 250;
    private static final Integer MAX_RESULTS_UNGROUPED = 2000;
     
    /**
    * List if DisplayTypes that can't use the LIKE logical operator in the WHERE clause when finding filtervalues based on a `term`
    */
    private static final Set<DisplayType> NON_LIKABLE_TYPES = new Set<DisplayType> {
        DisplayType.INTEGER,
		DisplayType.DOUBLE,
		DisplayType.BOOLEAN,
		DisplayType.ID
	};
                
	private static final Set<DisplayType> SUPPORTED_TYPES = new Set<DisplayType> {
		DisplayType.DOUBLE,
		DisplayType.INTEGER,
        DisplayType.BOOLEAN,
        DisplayType.COMBOBOX,
        DisplayType.EMAIL,
        DisplayType.REFERENCE,
        DisplayType.STRING,
        DisplayType.PICKLIST,
        DisplayType.URL
	};
        
    /**
    * FiltersInitInfo class to store field describes for the visible and overflow filters
    */
    public class FiltersInitInfo {
        @AuraEnabled public List<Field> fieldDescribe;
    }
    
    public class FilterValuesResponse {
        @AuraEnabled public List<FilterValue> filterValues;
        @AuraEnabled public Boolean hasMoreResults;
        
        FilterValuesResponse() {
            this.filterValues = new List<FilterValue>();
            this.hasMoreResults = false;
        }
        
        public void addFilterValue(FilterValue filterValue) {
            this.filterValues.add(filterValue);
        }
    }
    
    class FilterValue {
        @AuraEnabled public Object label;
        @AuraEnabled public Object value;
        @AuraEnabled public Integer amount;
        
        FilterValue(Object label, Object value, Integer amount) {
            this.label = label != null ? label : System.Label.Filter_empty;
            this.value = value;
            this.amount = amount;
        }
    }
    
    /**
    * Returns `true` if the field type can be used as a filter
    *
    * @param type
    *
    * @return
    */
    @testVisible
    private static Boolean isSupported(Field fieldDescribe) {
		for(DisplayType displayType: SUPPORTED_TYPES) {
            if(displayType.name() == fieldDescribe.type || displayType.name() == fieldDescribe.schemaType) {
                return true;
            }
        }
        return false;
    }

    /**
    * Returns `true` if the field type can be used with the LIKE logical operator when searching for filtervalues
    *
    * @param fieldDescribe
    *
    * @return
    */
    @testVisible
    private static Boolean isFieldLikable(Field fieldDescribe) {
        for(DisplayType displayType: NON_LIKABLE_TYPES) {
            if(displayType.name() == fieldDescribe.type || displayType.name() == fieldDescribe.schemaType) {
                return false;
            }
        }
        
        return true;
    }
    
    /**
    * Returns `true` if the field type is RecordType
    *
    * @param fieldDescribe
    *
    * @return
    */
    @testVisible
    private static Boolean isRecordTypeField(Field fieldDescribe) {
        return fieldDescribe.name == 'RecordTypeId';
    }
    
    /**
    * Casts the `term` argument to the proper class based on the provided `type` and returns it.
    * Returns `null` if any error occurs while casting
    *
    * @param term
    * @param type
    *
    * @return
    */
    @testVisible
    private static Object getTermValue(String term, String type) {
        Object value = null;
        try {
            if(type == String.valueOf(DisplayType.DOUBLE)) {
                value = Double.valueOf(term);
            }
            else if(type == String.valueOf(DisplayType.INTEGER)) {
                value = Integer.valueOf(term);
            }
            else if(type == String.valueOf(DisplayType.ID)) {
                value = String.valueOf(term);
            }
        }
        catch(Exception e) {
        }
        return value;
    }
    
    /**
    * Removes any unsupported fields from the provided `fields` list and returns it
    *
    * @param fields
    *
    * @return
    */
    private static List<Field> removeUnsupportedFields(List<Field> fields) {
        for(Integer i = fields.size() - 1; i >= 0; i--) {
            Field fieldDescribe = fields.get(i);
            if(!isSupported(fieldDescribe)) {
                fields.remove(i);
            }
        }
        return fields;
    }
    
    @AuraEnabled(cacheable=true)
    public static LightningResponseEntity getFilterValues(String encryptedQueryStructureJson, String fieldDescribeJson, String term, Boolean showAllResults, String filterFieldJson) {
        LightningResponseEntity response = LightningResponseEntity.create();
        
        if(showAllResults == null) {
            showAllResults = false;
        }
        
        try {
            List<Object> selectedValues;
            
            if(String.isNotEmpty(filterFieldJson)) {
                QueryStructure.FilterField filterField = (QueryStructure.FilterField)JSON.deserialize(filterFieldJson, QueryStructure.FilterField.class);
                if(filterField.isMultivalueFilter()) {
                    selectedValues = filterField.getValue() != null ? (List<Object>)filterField.getValue() : selectedValues;
                }
                else {
                    Object value = filterField.getValue();
                    if(value != null) {
                        selectedValues = new List<Object> { value };
                	}
                }
            }
            
            String decryptedQueryStructure = GenericUtils.decrypt(encryptedQueryStructureJson);
            
            QueryStructure qs = (QueryStructure) Json.deserialize(decryptedQueryStructure, QueryStructure.class);
            Field fieldDescribe = (Field) Json.deserialize(fieldDescribeJson, Field.class);
            
            response = getGenericFilterValues(qs, fieldDescribe, term, showAllResults, selectedValues);
        }
        catch(Exception e) {
            response.setError('Error while getting filter values: ' + e.getMessage() + ' - ' + e.getStackTraceString());
        }
        
        return response;
        
    }
    
    /**
    *
    *
    * @param qs
    * @param fieldDescribe
    * @param term
    * @param showAllResults
    * @param selectedValues
    *
    * @return
	*/
    public static LightningResponseEntity getGenericFilterValues(QueryStructure qs, Field fieldDescribe, String term, Boolean showAllResults, List<Object> selectedValues) {
        
        LightningResponseEntity response = LightningResponseEntity.create();
        List<SObject> selectedRecords = new List<SObject>();
        List<SObject> records; 
        
        FilterValuesResponse body = new FilterValuesResponse();
        String query;
        
        try {
            
            Boolean groupable = true;
            SoqlBuilder builder = qs.getSoqlBuilder().clearSelects();
            
            String fieldName = fieldDescribe.fieldName;
            String fieldPath = fieldName;
            String labelFieldPath = fieldName;
            String valueFieldPath = fieldName;
            String groupField = fieldName == 'Id' ? 'Name' : 'Id';
            
            if (fieldDescribe.type == 'REFERENCE' || isRecordTypeField(fieldDescribe)) {
                // Handle native reference fields (like OwnerId, AccountID, et)
                if (fieldPath.toLowerCase().endsWith('id')) {
                    fieldPath = fieldPath.left(fieldPath.length() - 2);
                }
                
                labelFieldPath = fieldPath.replace('__c', '__r') + '.Name';
                valueFieldPath = fieldPath.replace('__c', '__r') + '.Id';
                
                selectedValues = convertToSalesforceId(selectedValues);
            }
            
            // In case of translatable fields like workflows_status and workflow create a map of translations keyed on Id
            Set<Id> translationIds;
            Map<Id, String> translatedFilterValues = new Map<Id, String>();
            
            // Verify all fields in the query are groupable
            Map<String, DescribeFieldResult> describeFieldResults = GenericUtils.getsObjectFieldsDescribe(qs.getSobjectName(), new List<String>{
                labelFieldPath, valueFieldPath
                    });
            for (DescribeFieldResult describeFieldResult : describeFieldResults.values()) {
                if (!describeFieldResult.isGroupable()) {
                    groupable = false;
                    break;
                }
            }
            
            System.debug(
                'fieldName: ' + fieldName + '\n' +
                'fieldPath: ' + fieldPath + '\n' +
                'labelFieldPath: ' + labelFieldPath + '\n' +
                'valueFieldPath: ' + valueFieldPath + '\n' +
                'groupField: ' + groupField + '\n' +
                'groupable: ' + groupable
            );
            
            // Create a GROUP BY query if the Field is groupable to get the distinct filter values and counts
            if (groupable) {
                builder
                    .addSelect(new String[]{ labelFieldPath + ' label', valueFieldPath + ' value', 'Count(' + groupField + ') amount' })
                    .addGroup(new String[]{ labelFieldPath, valueFieldPath });
            }
            else {
                builder
                    .addSelect(new String[]{ labelFieldPath, valueFieldPath });
            }
            
            builder.removeWhereCondition(
                new SoqlBuilder.RemoveWhereOptions(fieldName)
                .setNestedStrategy(SoqlBuilder.RemoveWhereNestedStrategyEnum.ROOT_ONLY)
                .ignoreRestrictions(new List<SoqlBuilder.RestrictionEnum> { SoqlBuilder.RestrictionEnum.NOTNULL })
            );
            
            // First, query the selected records
            if (selectedValues != null && selectedValues.size() > 0) {
                builder
                    .addWhere(SoqlBuilder.valueIn(valueFieldPath, selectedValues))
                    .clearSorts()
                    .setPage(1, MAX_RESULTS_UNGROUPED);
                
                if (fieldDescribe.isSortable) {
                    builder.addSortDescNullsLast(labelFieldPath);
                }
                
                for (SObject selectedRecord : Database.query(builder.toQuery())) {
                    Object value =  groupable ? selectedRecord.get('value') : GenericUtils.getFieldValue(selectedRecord, valueFieldPath);
                    String valueStr = value == null ? '': String.valueOf(value); 
                    
                    for(Object selectedValue: selectedValues) {
                        String selectedValueStr = selectedValue == null ? '' : String.valueof(selectedValue);
                        
                        if(valueStr.equals(selectedValueStr)) {
                            selectedRecords.add(selectedRecord);
                            break;
                        } 
                    }
                }
                
                builder.removeWhereCondition(
                    new SoqlBuilder.RemoveWhereOptions(valueFieldPath)
                    .setNestedStrategy(SoqlBuilder.RemoveWhereNestedStrategyEnum.ROOT_ONLY)
                    .ignoreRestrictions(new List<SoqlBuilder.RestrictionEnum> { SoqlBuilder.RestrictionEnum.NOTNULL })
                );
            }
            
            if (isFieldLikable(fieldDescribe)) {
                
                if(String.isNotEmpty(term)) {
                    builder.addWhere(SoqlBuilder.valueLike(labelFieldPath, '%' + term + '%'));
                }
                else {
                    builder.addWhere(
                        SoqlBuilder.disjunction()
                        .add(SoqlBuilder.valueLike(labelFieldPath, '%' + term + '%'))
                        .add(SoqlBuilder.isNull(labelFieldPath))
                    );
                }
            }
            else {
                if (String.isNotEmpty(term)) {
                    Object termValue = getTermValue(term, fieldDescribe.schemaType);
                    
                    if (termValue != null) {
                        builder.addWhere(SoqlBuilder.eq(labelFieldPath, termValue));
                    }
                    else {
                        builder.addWhere(SoqlBuilder.notNull(labelFieldPath));
                    }
                }
            }
            
            // Map of FilterValue keyed by value so we can count the filter values using a non-group by query
            Map<Object, FilterValue> ungroupedFilterValues = new Map<Object, FilterValue>();
            
            if(groupable) {
                builder.setPage(1, showAllResults ? MAX_RESULTS : PAGE_SIZE).clearSorts().addSortAscNullsFirst(labelFieldPath);
            }
            else {
                builder.setPage(1, MAX_RESULTS_UNGROUPED).clearSorts();
                
                if (fieldDescribe.isSortable) {
                    builder.addSortAscNullsFirst(labelFieldPath);
                }
            }
            System.debug('query: ' + builder.toQuery());
            
            records = Database.Query(builder.toQuery());
            
            // Move the selected records to the top of the list
            if(selectedRecords != null && selectedRecords.size() > 0) {
                
                for(Integer i = records.size() - 1; i >= 0; i--) {
                    SObject record = records.get(i);
                    
                    Object value = groupable ? record.get('value') : GenericUtils.getFieldValue(record, valueFieldPath);
                    String valueStr = value == null ? '' : String.valueOf(value);
                    Boolean valueInSelectedValues = false;
                    
                    for(Object selectedValue: selectedValues) {
                        String selectedValueStr = selectedValue == null ? '' : String.valueof(selectedValue);
                        
                        if(valueStr.equals(selectedValueStr)) {
                            valueInSelectedValues = true;
                            break;
                        }
                    }
                    
                    if(valueInSelectedValues) {
                        records.remove(i);
                    }
                }
                
                for(SObject selectedRecord: selectedRecords) {
                    if(records.size() == 0) {
                        records.add(selectedRecord);
                    }
                    else {
                        records.add(0, selectedRecord);
                    }
                }
            }
            // process the records
            for(SObject record: records) {
                if(groupable) {
                    Object recordLabel = getRecordLabel(record, fieldDescribe);
                    body.addFilterValue(new FilterValue(recordLabel, record.get('value'), (Integer)record.get('amount')));
                }
                else {
                    Object value = GenericUtils.getFieldValue(record, valueFieldPath);
                    Object label = GenericUtils.getFieldValue(record, labelFieldPath);
                    FilterValue filterValue = ungroupedFilterValues.get(value);
                    if(filterValue == null) {
                        filterValue = new FilterValue(label, value, 0);
                        ungroupedFilterValues.put(value, filterValue);
                    }
                    filterValue.amount++;
                }
            }
            
            if(groupable) {
                // Get page 2 to determine whether there are more records
                if(body.filterValues.size() > 0 && !showAllResults) {
                    body.hasMoreResults = Database.query(builder.setPage(2, PAGE_SIZE).toQuery()).size() > 0;
                }
            }
            else {
                Integer i = 0;
                for(FilterValue filterValue: ungroupedFilterValues.values()) {
                    
                    if(!showAllResults && i++ >= PAGE_SIZE) {
                        break;
                    }
                    body.addFilterValue(filterValue);
                }
                body.hasMoreResults = ungroupedFilterValues.keySet().size() > PAGE_SIZE;
            }
            
            //Special check for community
            //------------------------------
            GenericUtils.checkCommunityUser();
            String oppObjName = 'opportunity';
            if(oppObjName.equalsIgnoreCase(qs.getSobjectName()) && fieldDescribe.fieldName == 'StageName' && GenericUtils.isCommunityUser && body != null && body.filterValues != null) {
                Integer index;                
                for(Integer i=0; i<body.filterValues.size(); i++) {
                    if(body.filterValues[i].value == 'Grey Out') {
                        index = i;
                        break;
                    }
                }
                if(index != null) {
                    body.filterValues.remove(index);
                }
            }
            //------------------------------
            response.setBody(body);
        }
        catch(Exception e) {
            response.setError('Error while getting filter values: ' + e.getMessage() + ' - ' + e.getStackTraceString());
        }
        return response;
    }
    
    // Get the label for a filter option. If the filter is based on a picklist field, use the translated label
    @testVisible
    private static Object getRecordLabel(SObject record, Field fieldDescribe) {
        String recordLabel;
        if (fieldDescribe.type == 'PICKLIST' && fieldDescribe.options != null) {
            recordLabel = FieldFactory.getPicklistLabelByValue(String.valueOf(record.get('value')), fieldDescribe);
        }
        return String.isNotBlank(recordLabel) ? recordLabel : record.get('label');
    }
    
    // Convert a 15 character Ids to an 18 character Ids
   @testVisible
    private static List<Object> convertToSalesforceId(List<Object> selectedValues) {
        List<Object> selectedValuesId = new List<Object>();
        if(selectedValues != null && !selectedValues.isEmpty()) {
            for(Object selectedValue: selectedValues) {
                try {
                    Id lookupValue = Id.valueOf(String.valueOf(selectedValue));
                    if(String.isNotEmpty(lookupValue)) {
                        selectedValuesId.add(lookupValue);
                    }
                }
                catch(Exception e) {
                    // error casting to ID. Just add the original value
                    selectedValuesId.add(selectedValue);
                }
            }
        }
        return selectedValuesId;
    }
    
    @AuraEnabled(cacheable=true)
    public static FiltersInitInfo getFiltersInitInfo(String sObjectName,List<String> fields, String fieldSet) {
        try {
            if(String.isBlank(sObjectName)) {
                return null;
            }
            
            QueryStructure qs = null;
            FiltersInitInfo filtersInitInfo = new FiltersInitInfo();
             
            // Visible filter fields
            if((fields != null && fields.size() > 0) || String.isNotBlank(fieldSet)) {
                qs = QueryStructure.create().fromSObject(String.valueOf(sObjectName)).addFields(fields).addFieldSet(String.isNotBlank(fieldSet) ? fieldSet.trim() : null);
                filtersInitInfo.fieldDescribe = removeUnsupportedFields(qs.getFieldsDescribe().values());
            }
            return filtersInitInfo;
        }
        catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}