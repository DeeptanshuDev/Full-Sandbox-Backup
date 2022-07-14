public with sharing class QueryStructure {
    /**
    * OrderEnum contains list of available order direction.
    */
    public Enum OrderEnum {
        ORDER_ASC, ORDER_DESC
    }
    /**
    * RestrictionEnum contains list of available operators for  filters (Where conditions).
    */
    public Enum RestrictionEnum {
        EQ, NE, GT, GE, LT, LE, ISNULL, NOTNULL, VALUEIN, VALUENOTIN
    }

    /**
    * OrderField class represent order structure for SOQL query in a good format.
    * SoqlBuilder use OrderField to build SOQL query Order By condition
    */
    public class OrderField {
        public String fieldName;
        public OrderEnum direction;
    }

    /**
    * Filter class represent filter structure for SOQL query in a good format.
    * SoqlBuilder use Filter to build SOQL query WHERE condition
    */
    public class Filter {
        public List<FilterField> filterFields;
        public String filterLogic;
        public String soslString;
        public Map<String, List<SoslBuilder.SoslStructure>> soslResults;

        public Filter() {
            this.filterFields = new List<FilterField>();
            this.initSoslResults();
        }

        public void initSoslResults() {
            this.soslResults = new Map<String, List<SoslBuilder.SoslStructure>>();
        }

        public List<SoslBuilder.SoslStructure> getSoslResults(String sObjectName) {

            if(String.isNotEmpty(soslString)) {

                if(this.soslResults == null) {
                    this.initSoslResults();
                }

                if(!this.soslResults.containsKey(soslString)) {
                    System.debug('Executing sosl for searchString: ' + soslString);
                    this.soslResults.put(soslString, new SoslBuilder().forObject(sObjectName).includeReferenceFields(true).setSearchString(soslString).getResults());
                }
                else {
                    System.debug('Returning cached soslResults');
                }

                return this.soslResults.get(soslString);
            }

            return null;
        }

    }

    public class FilterField {
        public String fieldName;
        public RestrictionEnum restriction;
        public FilterValue filterValue;
        public Boolean hidden;

        public FilterField() {

        }

        public FilterField(String fieldName, RestrictionEnum restriction, Object value) {
            this.fieldName = fieldName;
            this.restriction = restriction;
            this.filterValue = value != null ? new FilterValue(value) : new FilterValue();
        }

        public Object getValue() {
            return this.getValue(this.restriction);
        }

        public Object getValue(RestrictionEnum restriction) {
            if(filterValue != null) {
                return restriction != null ? filterValue.getValue(restriction) : filterValue.getValue();
            }
            return null;
        }

        public Boolean isMultivalueFilter() {
            return this.restriction == RestrictionEnum.VALUEIN || restriction == RestrictionEnum.VALUENOTIN;
        }

        public SoqlBuilder.Criterion toCriterion(QueryStructure qs) {

            Object value = this.getValue();

            if(!String.isBlank(this.fieldName)) {

                if (this.restriction == RestrictionEnum.EQ && value != null) {
                    return SoqlBuilder.eq(this.fieldName, value);
                }
                if (this.restriction == RestrictionEnum.NE && value != null) {
                    return SoqlBuilder.ne(this.fieldName, value);
                }
                if (this.restriction == RestrictionEnum.GT && value != null) {
                    return SoqlBuilder.gt(this.fieldName, value);
                }
                if (this.restriction == RestrictionEnum.GE && value != null) {
                    return SoqlBuilder.ge(this.fieldName, value);
                }
                if (this.restriction == RestrictionEnum.LT && value != null) {
                    return SoqlBuilder.lt(this.fieldName, value);
                }
                if (this.restriction == RestrictionEnum.LE && value != null) {
                    return SoqlBuilder.le(this.fieldName, value);
                }
                if (this.restriction == RestrictionEnum.VALUEIN && value != null) {
                    return SoqlBuilder.valueIn(this.fieldName, value);
                }
                if (this.restriction == RestrictionEnum.VALUENOTIN && value != null) {
                    return SoqlBuilder.valueNotIn(this.fieldName, value);
                }
                if (this.restriction == RestrictionEnum.ISNULL) {
                    return SoqlBuilder.isNull(this.fieldName);
                }
                if (this.restriction == RestrictionEnum.NOTNULL) {
                    return SoqlBuilder.notNull(this.fieldName);
                }
            }
            return null;
        }
    }

    /**
     *
     */
    public class FilterValue {
        public List<String> stringValues;
        public List<Integer> integerValues;
        public List<Boolean> booleanValues;
        
        public FilterValue() {
            this.stringValues = new List<String>();
            this.integerValues = new List<Integer>();
            this.booleanValues = new List<Boolean>();
        }

        public FilterValue(List<String> stringValues) {
            this();
            this.stringValues = stringValues;
        }
        public FilterValue(Object value) {
            this();
            if(value instanceof List<Object>) {
                if (value instanceof List<String>) {
                    this.stringValues.addAll((List<String>) value);
                } else if (value instanceof List<Integer>) {
                    this.integerValues.addAll((List<Integer>) value);
                } else if (value instanceof List<Boolean>) {
                    this.booleanValues.addAll((List<Boolean>) value);
                }    
            }
            else if(value instanceof String || value instanceof Id) {
                this.stringValues.add((String)value);
            }
            else if(value instanceof Long || value instanceof Integer || value instanceof Double) {
                this.integerValues.add(Integer.valueOf(value));
            }
            else if(value instanceof Boolean) {
                this.booleanValues.add((Boolean)value);
            }
        }
        public FilterValue(List<Integer> integerValues) {
            this();
            this.integerValues = integerValues;
        }
        public FilterValue(List<Boolean> booleanValues) {
            this();
            this.booleanValues = booleanValues;
        }
        
        public Object getValue() {
            if(stringValues != null && stringValues.size() > 0) {
                return stringValues;
            }
            if(integerValues != null && integerValues.size() > 0) {
                return integerValues;
            }
            if(booleanValues != null && booleanValues.size() > 0) {
                return booleanValues;
            }
            return null;
        }

        public Object getValue(RestrictionEnum restriction) {
            if(restriction == RestrictionEnum.VALUEIN || restriction == RestrictionEnum.VALUENOTIN) {
                return this.getValue();
            }
            else {
                List<Object> values = (List<Object>)this.getValue();

                if(values != null && values.size() > 0) {
                    return values.get(0);
                }
            }
            return null;
        }

    }

    private String sObjectName;
    /**
     * fieldNames - list of all fields that need to be returned from query.
     * This list contains also all fields from FieldSets.
     * transient - exclude this field from JSon
    */
    transient private List<String> fieldNames;
    /**
     * formattedFieldNames - list of all accessible fields for user that will be returned from query.
    */
    private Set<String> formattedFieldNames;
    private Set<String> hiddenFieldNames;
    private List<String> groupFieldNames;
    private List<OrderField> orderFields;
    private Filter filter;

    private Map<String, Field> fieldsDescribe;
    
    /**
    * setOfReferencesToBeExcluded - Set of references that doesn't support parent traversing for name field and other reference fields
    */
    private Set<String> setOfReferencesToBeExcluded = new Set<String>{'ConnectionSentId', 'ConnectionReceivedId', 'ConnectionReceived', 'ConnectionSent'};

    public QueryStructure() {
        this.fieldNames = new List<String>();
        this.hiddenFieldNames = new Set<String>();
        this.groupFieldNames = new List<String>();
        this.orderFields = new List<OrderField>();
        this.filter = new Filter();
    }

    public static QueryStructure create() {
        return new QueryStructure();
    }

    public QueryStructure addOrderFields(List<OrderField> orderFields) {
        this.orderFields = orderFields;
        return this;
    }

    public QueryStructure addGroupFields(List<String> groupFieldNames) {
        this.groupFieldNames = groupFieldNames;
        return this;
    }

    public QueryStructure addFilter(Filter filter) {
        this.filter = filter;
        return this;
    }

    public QueryStructure fromSObject(String sObjectName) {
        this.sObjectName = sObjectName;
        return this;
    }

    public QueryStructure addField(String fieldName) {
        return this.addFields(new String[] { fieldName });
    }

    public QueryStructure addFields(String[] fieldNames) {
        if(fieldNames != null) {
            for(String fieldName: fieldNames) {
                this.fieldNames.add(fieldName);
            }
        }
        return this; 
    }

    public QueryStructure addHiddenFields(Set<String> hiddenFieldNames) {
        this.hiddenFieldNames = hiddenFieldNames;
        return this;
    }

    public List<String> getFieldNames() {
        return this.fieldNames;
    }
    public String getSobjectName(){
        return this.sObjectName;
    }

    public QueryStructure addFieldSet(String fieldSetName) {
        if(String.isNotBlank(fieldSetName)) {
            for(String fieldName : GenericUtils.getFieldSetsFields(this.sObjectName,fieldSetName)){
                System.debug('@@@@@ fieldName ' + fieldName);
                if(!containsCaseInsensitive(fieldName,this.fieldNames)){
                    this.fieldNames.add(fieldName);
                }
            }
        }
        return this;
    }
    
    /**
    *  Method to get describe information for all fields that will use in a query.
    *  @return - field describe in a good format.
    *  @exception cxsCoreUtil.ValidationException
    *  if user do not have a CRUD and FLS permission
    */
    public Map<String, Field> getFieldsDescribe() {
        if(this.fieldsDescribe == null) {

            //check hidden fields
            System.debug(this.fieldNames + ' this.fieldNames+++');
            if(!this.hiddenFieldNames.isEmpty()){
                Set<String> fieldNamesSet = new Set<String>(this.fieldNames);
                for(String hiddenField : this.hiddenFieldNames){
                    if(containsCaseInsensitive(hiddenField,fieldNamesSet) /*fieldNamesSet.contains(hiddenField)*/){
                        // field do't need to be hidden
                        this.hiddenFieldNames.remove(hiddenField);
                    }else{
                        // need to query this field but keep it hidden
                        this.fieldNames.add(hiddenField);
                    }
                }
            }


            this.fieldsDescribe = new Map<String, Field>();
            this.formattedFieldNames = new Set<String>();

            Map<String,Schema.DescribeFieldResult> fieldsDescribeResult = GenericUtils.getsObjectFieldsDescribe(this.sObjectName,this.fieldNames);
            Schema.SObjectType sobjectType = Schema.getGlobalDescribe().get(this.sObjectName);
            if(sobjectType == null){
                this.sObjectName = GenericUtils.getPackagePrefix() + this.sObjectName;
                sobjectType = Schema.getGlobalDescribe().get(this.sObjectName);
            }
            if(sobjectType == null){
                throw new GenericUtils.ValidationException(System.Label.Error_invalid_object_name);
            }
            
            for(String fieldName : fieldsDescribeResult.keySet()){
                if(fieldsDescribeResult.containsKey(fieldName)){
                    Field field = FieldFactory.create(null, sobjectType, null, fieldsDescribeResult.get(fieldName));
                    field.fieldName = fieldName;
                    field.fieldPath = fieldName;

                    //Set hidden attribute
                    if(!this.hiddenFieldNames.isEmpty()){
                        if(this.hiddenFieldNames.contains(fieldName) || this.hiddenFieldNames.contains(fieldname.replace(GenericUtils.getPackagePrefix(),''))){
                            field.isHiddenField= true;
                        }
                    }
                    
                    //Making Amount field on Opportunity to remaining payment balance
                    GenericUtils.checkCommunityUser();
                    /*if(sobjectType == Opportunity.sObjectType && fieldName == 'Amount' && GenericUtils.isCommunityUser) {
                        field.label = 'Remaining Payment Balance';
                    }*/
                    
                    //Making an editable field.
                    if(sobjectType == Custom_Item__c.sObjectType && fieldName == 'Quantity__c' && GenericUtils.isCommunityUser) {
                        field.isEditable = true;
                    }
                    
                    if(!fieldsDescribeResult.get(fieldName).isCustom() && !setOfReferencesToBeExcluded.contains(fieldName) ) {
                        if(fieldName.endsWithIgnoreCase('.Id') && field.schemaType == 'ID') {
                            //Currently we cannot view recordType in lightning experience as a known limitation 
                            //And at same time in classic Record Type URL have some other static prefix with it along with hostname and id
                            //that is why just redirecting to classic with id value will not work therefore we are bypassing it from creating
                            //clickable link for it similar to other reference fields
                            if(field.label != 'Record Type ID')
                                field.type = 'REFERENCE'; 
                        }
                        String fLabel = field.label;
                        if(String.isNotBlank(fLabel) && field.type == 'REFERENCE' && fLabel.endsWith(' ID')) {
                            field.label = fLabel.removeEnd(' ID');
                        }
                    }
                    if('REFERENCE' ==  field.type && !setOfReferencesToBeExcluded.contains(fieldName) ) {
                        if(fieldName.split('\\.').size() > 1) {
                            if(!setOfReferencesToBeExcluded.contains(fieldName.split('\\.')[0])) {
                                this.formattedFieldNames.add(GenericUtils.getConvertedFieldPath(fieldName,'REFERENCE'));
                            }
                        } else {
                            this.formattedFieldNames.add(GenericUtils.getConvertedFieldPath(fieldName,'REFERENCE'));
                        }
                    }

                    if (field.schemaType == 'PICKLIST' || field.schemaType == 'MULTIPICKLIST') {
                        fieldName = 'toLabel(' + fieldName + ')';
                    }

                    if(fieldName.toLowerCase() =='id'){
                        this.formattedFieldNames.add('Name');
                    }
                    this.formattedFieldNames.add(fieldName.toLowerCase());
                    this.fieldsDescribe.put(fieldName, field);
                }
            }
            if(this.formattedFieldNames.isEmpty()){
                throw new GenericUtils.ValidationException(System.Label.Error_dataService_no_available_fields);
            }
        }

        return this.fieldsDescribe;
    }
    
    /**
      *  Method to get SoqlBuilder instance based on QueryStructure.
      *  @return - SoqlBuilder instance.
    */
    public SoqlBuilder getSoqlBuilder() {
        this.getFieldsDescribe();
        SoqlBuilder builder = SoqlBuilder.create();
        List<String> fieldsForQuery = new List<String>();
        fieldsForQuery.addAll(this.formattedFieldNames);

        builder
            .addSelect(fieldsForQuery)
            .addFrom(this.sObjectName)
        ;
        builder = addWhereConditions(builder);
        if(!this.orderFields.isEmpty()){
            for(OrderField orderField : this.orderFields){
                if(orderField.direction == OrderEnum.ORDER_ASC){
                    builder.addSortAsc(orderField.fieldName);
                }
                if(orderField.direction == OrderEnum.ORDER_DESC){
                    builder.addSortDesc(orderField.fieldName);
                }
            }
        }
        if(!this.groupFieldNames.isEmpty()){
            builder.addGroup(this.groupFieldNames);
        }

        return builder;
    }
    
    /**
     *  Method to add WHERE conditions to SoqlBuilder based on QueryStructure.
     *  @return - SoqlBuilder instance.
   */
    @testVisible
    private SoqlBuilder addWhereConditions(SoqlBuilder builder){
        if(this.filter == null){
            return builder;
        }
        for(FilterField filterField : this.filter.filterFields){

            SoqlBuilder.Criterion criterion = filterField.toCriterion(this);
            if(criterion != null) {
                builder.addWhere(criterion);
            }

        }
        if(!String.isBlank(filter.filterLogic)){
            builder.setConditionLogic(filter.filterLogic);
        }

        if(String.isNotEmpty(this.filter.soslString)) {

            List<SoslBuilder.SoslStructure> soslResults = this.filter.getSoslResults(this.sObjectName);

            SoslBuilder theSoslBuilder = SoslBuilder.fromSoslStructures(soslResults);

            if(theSoslBuilder.hasResults()) {
                builder.addWhere(theSoslBuilder.getCriterion());
            }
            else {
                builder.setWillReturnResults(false);
            }
        }


        return builder;
    }

    /**
     *
     *
     * @param objectType
     * @param referenceObjectType
     * @param fieldPathSuffix
     * @param useRelationSuffix
     *
     * @return
     */
    public static List<String> getReferenceFieldsOfType(Schema.sObjectType objectType, Schema.sObjectType referenceObjectType, String fieldPathPrefix, Boolean useRelationSuffix) {

        List<String> referenceFields = new List<String>();

        Map<String,Schema.sObjectField> fields = objectType.getDescribe().fields.getMap();
        for(Schema.SObjectField field:fields.values()) {
            Schema.DescribeFieldResult describe = field.getDescribe();
            if (describe.isAccessible()) {
                for (Schema.sObjectType referenceTo : describe.getReferenceTo()) {
                    if (referenceTo == referenceObjectType) {
                        String fieldName = (String.isNotEmpty(fieldPathPrefix) ? fieldPathPrefix : '') + describe.getName();
                        if (useRelationSuffix) {
                            fieldName = fieldName.replace('__c', '__r');
                        }
                        referenceFields.add(fieldName);
                    }
                }
            }
        }
        return referenceFields;
    }

    @testVisible
    private boolean containsCaseInsensitive(String stringToCheck, List<String> listToCheck){
        for (String s : listToCheck){
            if (s.equalsIgnoreCase(stringToCheck)){
                return true;
            }
            if ((GenericUtils.getPackagePrefix() +s).equalsIgnoreCase(stringToCheck)){
                return true;
            }

        }
        return false;
    }

    @testVisible
    private boolean containsCaseInsensitive(String stringToCheck, Set<String> setToCheck){
        for (String s : setToCheck){
            if (s.equalsIgnoreCase(stringToCheck)){
                return true;
            }
            if ((GenericUtils.getPackagePrefix()+ s).equalsIgnoreCase(stringToCheck)){
                return true;
            }
        }
        return false;
    }

}