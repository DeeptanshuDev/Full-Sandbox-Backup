public with sharing class FieldFactory {
    
    private static final Map<String, Schema.SObjectType> GLOBAL_DESCRIBE_MAP = Schema.getGlobalDescribe();
    
    public final static Set<String> FILE_UPLOAD_TYPES = new Set<String>{
    };
        
        public static Field create(sObject obj, Schema.sObjectType objType, Schema.FieldsetMember fieldSetMember, Schema.DescribeFieldResult describe) {
            
            Schema.DisplayType fieldType = describe.getType();
            
            List<Field.Option> options = null;
            Integer maxLength = null;
            String format = null;
            String parentObjectName = null;
            String parentObjectLabel = null;
            
            String sObjectName = objType.getDescribe().getName();
            
            String fieldPath = fieldSetMember != null ? fieldSetMember.getFieldPath() : describe.getName();
            String fieldLabel = fieldSetMember != null ? fieldSetMember.getLabel() : describe.getLabel();
            Boolean fieldRequired = fieldSetMember != null ? fieldSetMember.getRequired() : !describe.isNillable();
            Boolean isGroupable;
            Boolean isCalculated;
            String controllingField;
            Map<String, List<String>> dependentValuesByControllerValue;
            
            if(describe != null){
                isGroupable = describe.isGroupable();
                isCalculated = describe.isCalculated();
            }
            
            String value = null;
            String displayValue = null;
            
            List<String> extraResultFields = new List<String>();
            
            List<Field.NamePoint> namePointingList = new List<Field.NamePoint>();
            
            String fieldTypeString = getFieldType(fieldType, describe.isHtmlFormatted());
            
            if(fieldPath.endsWithIgnoreCase('Total_score__c')) {
                fieldTypeString = 'REQUIREMENT_ASSESSMENT';
            }
            else if(fieldPath.endsWithIgnoreCase('Progress__c')) {
                fieldTypeString = 'PROGRESS';
            }
            else if(fieldPath.endsWithIgnoreCase('Documents__c')) {
                fieldTypeString = 'DOCUMENTS';
            }
            else if(fieldPath.endsWithIgnoreCase('Is_favourite__c')) {
                fieldTypeString = 'FAVOURITE';
            }
            else if(fieldPath.endsWithIgnoreCase('Hard_Criteria_Match__c') || fieldPath.endsWithIgnoreCase('MatchText__c') || fieldPath.endsWithIgnoreCase('Supplier_score_on_price__c')) {
                fieldTypeString = 'MATCHING';
            }
            else if(FILE_UPLOAD_TYPES.contains(fieldPath)) {
                fieldTypeString = 'FILEUPLOAD';
            }
            else if(fieldPath.endsWithIgnoreCase('starDisplay__c')) {
                fieldTypeString = 'RATING';
            }
            else if(fieldPath =='Subject') {
                fieldTypeString = 'STRING';
            }
            else if(fieldPath.endsWithIgnoreCase('RecordTypeId')) {
                fieldTypeString = 'PICKLIST';
                options = new List<Field.Option>();
                fieldLabel = System.Label.RecordTypeLabel;
                
                List<Schema.RecordTypeInfo> recTypInfoList = objType.getDescribe().getRecordTypeInfos();
                for(Schema.RecordTypeInfo inf : recTypInfoList){
                    if (inf.isAvailable() && !inf.isMaster()) {
                        options.add(new Field.Option(inf.getRecordTypeId(), inf.getName()));
                    }
                }
            }
            else if (Schema.DisplayType.REFERENCE == fieldType) {
                if(describe.isNamePointing()) {
                    for(Schema.sObjectType refObjectType : describe.getReferenceTo()) {
                        Schema.DescribeSObjectResult refObjectTypeResult= refObjectType.getDescribe();
                        if((refObjectTypeResult.isAccessible() && refObjectTypeResult.isSearchable()) || (GenericUtils.isCommunityUser && GenericUtils.bypassObjectAccess.contains(sObjectName.toLowerCase()))) {
                            String objName = String.valueOf(refObjectType);
                            String labelName = GLOBAL_DESCRIBE_MAP.get(objName).getDescribe().getLabelPlural();
                            namePointingList.add(new Field.NamePoint(objName, labelName));
                        }
                    }
                }
                parentObjectName = String.valueOf(describe.getReferenceTo()[0]);
                Schema.SObjectType sObjectTypeObj = GLOBAL_DESCRIBE_MAP.get(parentObjectName);
                parentObjectLabel = sObjectTypeObj.getDescribe().getLabelPlural();
                extraResultFields = getExtraResultFields(sObjectTypeObj);
                // ensure translated labels come without "ID" word for standard fields, eg.: Owner, CreatedBy etc.
                if (!describe.isCustom()) {
                    fieldLabel = fieldLabel.replace('-ID', '').replace('ID du ', '').replace('ID für ', '')
                        .replace('Id. del ', '').replace(' el Id.', '').replace('ID do ', '').replace('ID for ', '')
                        .replace('ID ', '').replace('"', '').replace(' (ID)', '').replaceAll(' id$', '');
                    fieldLabel = fieldLabel.replaceFirst(fieldLabel.substring(0, 1), fieldLabel.substring(0, 1).toUpperCase(UserInfo.getLocale()));
                }
            }
            else if ((Schema.DisplayType.PICKLIST == fieldType) || (Schema.DisplayType.MULTIPICKLIST == fieldType)) {
                options = new List<Field.Option>();
                // obtain available values for current record type
                Id recTypeId = null;
                if(obj != null && obj.getPopulatedFieldsAsMap() != null){
                    recTypeId = obj.getPopulatedFieldsAsMap().containsKey('RecordTypeId') ? (Id) obj.get('RecordTypeId') : null;
                }
                
                //List<String> availableValues = GenericUtils.getPickListValuesIntoList(sObjectName, recTypeId, fieldPath);
                
                for (Schema.PicklistEntry picklistEntry : describe.getPickListValues()) {
                    options.add(new Field.Option(picklistEntry.getValue(), picklistEntry.getLabel()));
                }
            }
            else if (Schema.DisplayType.STRING == fieldType || Schema.DisplayType.TEXTAREA == fieldType) {
                maxLength = describe.getLength();
            }
            else if (Schema.DisplayType.INTEGER == fieldType) {
                maxLength = describe.getDigits();
            }
            else if (Schema.DisplayType.DOUBLE == fieldType || Schema.DisplayType.PERCENT == fieldType || Schema.DisplayType.CURRENCY == fieldType) {
                maxLength = describe.getPrecision()-describe.getScale();
                format = String.valueOf(maxLength);
                if(describe.getScale() != 0) {
                    maxLength += 1 + describe.getScale();
                    format += '.'+describe.getScale();
                }
                System.debug('### DJB ### format (old):'+format);
                format = createFormat(describe.getPrecision()-describe.getScale(),describe.getScale());
                System.debug('### DJB ### format (new):'+format);
            }
            
            Boolean isLookupField = (fieldPath.split('\\.').size() > 1);
            
            System.debug('****FieldFactory.create obj: ' + obj);
            Boolean readOnly = ((describe.isCalculated() || isLookupField || (obj == null && !describe.isCreateable()) || (obj != null && ((obj.get('id') == null && !describe.isCreateable()) || (obj.get('id') != null &&!describe.isUpdateable())) )));
            
            readOnly = describe.isCalculated()?true:!(GenericUtils.isCommunityUser && GenericUtils.bypassObjectAccess.contains(sObjectName.toLowerCase()));
            
            String help = describe.getInlineHelpText();
            
            Boolean isSortable = describe.isSortable();
            
            Boolean viewable = (GenericUtils.isCommunityUser && GenericUtils.bypassObjectAccess.contains(sObjectName.toLowerCase()))?true:describe.isAccessible();
            
            Field field = new Field(fieldPath, fieldLabel, String.isBlank(help) ? '' : help, fieldTypeString, fieldRequired, viewable, readOnly, null, null)
                .setOptions(options)
                .setMaxLength(maxLength)
                .setFormat(format)
                .setReferencedObjectName(parentObjectName)
                .setReferencedObjectLabel(parentObjectLabel)
                .setNamePointingList(namePointingList)
                .setExtraResultFields(extraResultFields)
                .setIsSortable(isSortable)
                .setIsGroupable(isGroupable)
                .setIsCalculated(isCalculated)
                .setControllingField(controllingField)
                .setDependentValuesByControllerValue(dependentValuesByControllerValue)
                .setSchemaType(fieldType);
            
            System.debug('FIELD:'+field);
            
            field.sObjectName = sObjectName;
            
            if(obj != null){
                Field recordField = createRecordField(obj,objType, field);
                field.value = recordField.value;
                field.displayValue = recordField.displayValue;
                
            }
            if (Schema.DisplayType.MULTIPICKLIST == fieldType && field.value == null) {
                field.value = '';
            }
            return field;
        }
    /**
    *  Method to return information about sObject record field , in a good format.
    *  @param  obj sObject record.
    *  @param  objType sObject schema type.
    *  @param  field existing Field.class instance with all general field describe information .
    *  @return - Field.class instance with additional sobject field information based on specific Sobject Record.
    */ 
    public static Field createRecordField(sObject obj, Schema.sObjectType objType, Field field) {
        
        String value = null;
        String displayValue = null;
        Datetime dateTimeValue = null;
        Date dateValue = null;
        
        String fieldPath = field.fieldName;
        Object objectValue = (obj != null)?GenericUtils.readObjectValue(obj, fieldPath):null;
        
        if (objectValue != null) {
            value = String.valueOf(objectValue);
        }
        
        //prepare displayValue as a translated picklist option or label of picklist value
        if ((String.valueOf(Schema.DisplayType.PICKLIST) == field.schemaType) || (String.valueOf(Schema.DisplayType.MULTIPICKLIST) == field.schemaType)) {
            if(!String.isBlank(value)){
                List<String> values = value.split(';');
                List<String> translatedValue = new List<String>();
                for(String picklistValue : values){
                    for(Field.Option option : field.options){
                        if(picklistValue == option.value){
                            translatedValue.add(option.label);
                        }
                    }
                }
                if(!translatedValue.isEmpty()){
                    displayValue=String.join(translatedValue,';');
                }
            }
        }
        GenericUtils.checkCommunityUser();
        if(fieldPath.endsWithIgnoreCase('Progress__c')) {
            value = value.replaceAll('alt=','title=');
            displayValue = value;
        }
        else if(fieldPath.endsWithIgnoreCase('Documents__c')) {
            if(value != null && value != '') {
                value = value.replaceAll('alt=','title=');
            }
            displayValue = value;
        }
        else if(fieldPath.endsWithIgnoreCase('Hard_Criteria_Match__c') || fieldPath.endsWithIgnoreCase('MatchText__c') || fieldPath.endsWithIgnoreCase('Supplier_score_on_price__c')) {
            displayValue = value;
        }
        else if(fieldPath.endsWithIgnoreCase('starDisplay__c')) {
            displayValue = value;
            if(String.isNotBlank(value)){
                value = ''+(value.replaceAll('[^Y]','')).length();
            }
        }
        else if ('DATE' == field.type) {
            if (String.isNotBlank(value)) {
                value = value.left(10);
                dateValue = (Date) objectValue;
            }
        }
        else if ('DATETIME' ==  field.type) {
            if (String.isNotBlank(value)) {
                value = ((DateTime)objectValue).format('yyyy-MM-dd HH:mm:ss');
                dateTimeValue = (DateTime) objectValue;
            }
        }
        else if ('REFERENCE' ==  field.type) {
            if (value != null) {
                Object o = GenericUtils.readObjectValue(obj, GenericUtils.getConvertedFieldPath(fieldPath,'REFERENCE'));
                if (o != null) {
                    displayValue = String.valueOf(o);
                }
            }
        }
        else if(field.isEditable && fieldPath.endsWithIgnoreCase('Quantity__c') && GenericUtils.isCommunityUser) {
            value = '0';
        }
        //Displaying RecordType label instead of Id
        //if ('RecordTypeId' == field.name) {
			//value = GenericUtils.getRecordTypeLabel(value);
		//}
        
        if (displayValue == null) {
            displayValue = value;
        }
        
        Field recordField = new Field(field);
        recordField.value = value;
        recordField.displayValue = displayValue;
        recordField.dateTimeValue = dateTimeValue;
        recordField.dateValue = dateValue;
        
        return recordField;
    }
    private static String createFormat(Integer digits, Integer decimals) {
        String result = '0';
        for (Integer d = 1; d< digits; d++) {
            result = '#'+result;
        }
        if (decimals > 0) {
            result += '.';
        }
        for (Integer d = 0; d< decimals; d++) {
            result += '0';
        }
        return result;
    }
    
    private final static Set<String> STRING_FIELD_TYPES = new Set<String>{
        'ADDRESS',
            'BASE64',
            'COMPLEXVALUE',
            'DATACATEGORYGROUPREFERENCE',
            'ENCRYPTEDSTRING',
            'ID',
            'JSON',
            'TIME'
            };
                
                private static String getFieldType(Schema.DisplayType fieldType, Boolean isHtmlFormatted) {
                    String result = 'UNKNOWN';
                    
                    result = ('' + fieldType).toUpperCase();
                    if ((result == 'TEXTAREA') && isHtmlFormatted) {
                        result = 'RICHTEXT';
                    } else if (STRING_FIELD_TYPES.contains(result)) {
                        result = 'STRING';
                    }
                    return result;
                }
    
    private static Boolean useRequirementsComponent;
    
    public static List<String> getExtraResultFields(Schema.SObjectType sObjectTypeObj) {
        List<String> extraResultFields = new List<String>();
        String sObjectName = sObjectTypeObj.getDescribe().getName();
        Map<String, Schema.FieldSet> fieldSetMapMap = sObjectTypeObj.getDescribe().fieldSets.getMap();
        Schema.FieldSet fieldSet = fieldSetMapMap.get('lightningLookupFields');
        if (fieldSet == null) {
            fieldSet = fieldSetMapMap.get('lightningLookupFields');
        }
        
        if (fieldSet != null) {
            System.debug('*** fieldset found :'+fieldSet);
            List<Schema.FieldSetMember> fieldSetMembers = fieldSet.getFields();
            Map<String, Schema.SObjectField> fieldDescribes = sObjectTypeObj.getDescribe().fields.getMap();
            for (Schema.FieldSetMember fsMember : fieldSetMembers) {
                DescribeFieldResult fieldDescribe = fieldDescribes.get(fsMember.fieldPath).getDescribe();
                // Field must be readable.  Note that references are not converted due to these fields being used in SOSL.
                if (fieldDescribe.isAccessible() || (GenericUtils.isCommunityUser && GenericUtils.bypassObjectAccess.contains(sObjectName.toLowerCase()))) {
                    if(getFieldType(fsMember.type,false) == 'REFERENCE') {
                        extraResultFields.add(GenericUtils.getConvertedFieldPath(fsMember.fieldPath,'REFERENCE'));
                    }
                    else {
                        extraResultFields.add(fieldDescribe.getName());
                    }
                }
            }
            System.debug('extraResultFields: ' + extraResultFields);
        }
        return extraResultFields;
    }
    
    // Get the label for a picklist option. The label will be translated if the language of the user is not English.
    // If no matching value is found, return null
    public static String getPicklistLabelByValue(String value, Field fieldDescribe) {
        if (fieldDescribe.type == 'PICKLIST' && fieldDescribe.options != null) {
            for (Field.Option option : fieldDescribe.options) {
                if (option.value.equalsIgnoreCase(value)) {
                    return option.label;
                }
            }
        }
        return null;
    }
}