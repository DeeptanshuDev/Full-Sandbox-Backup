/*
 Description  : Field Set controller class.
 Created By   : Abhinav Sharma
*/
public without sharing class FieldsetController {

    private static final Map<String, Schema.SObjectType> GLOBAL_DESCRIBE_MAP = Schema.getGlobalDescribe();

    public class PicklistOverrides {
        public String key;
        public List<Field.Option> options;

        public PicklistOverrides(String key, List<Field.Option> options) {
            this.key = key;
            this.options = options;
        }
    }

    // This class is used in CandidateWizardController and StepController
    public class FieldSet {
        @AuraEnabled public String header;
        @AuraEnabled public String description;
        @AuraEnabled public String name;
        @AuraEnabled public String sObjectName;
        @AuraEnabled public Id recordId;
        @AuraEnabled public Boolean readOnly;
        @AuraEnabled public Id recordTypeId;

        public FieldSet(String header, String description, String name, String sObjectName, Id recordId, Boolean readOnly, Id recordTypeId) {
            // sanitize header and description
            this.header = GenericUtils.removeHtml(header);
            this.description = GenericUtils.removeScript(description);
            this.name = name;
            this.sObjectName = sObjectName;
            this.recordId = recordId;
            this.readOnly = readOnly;
            this.recordTypeId = recordTypeId;
        }
    }

    // This class is used in Job/CandidateWizardController and StepController
    public class Input {
        @AuraEnabled public String sObjectName;
        @AuraEnabled public Id recordId;
        @AuraEnabled public List<Field> fields;

        public Input(String sObjectName, Id recordId, List<Field> fields) {
            this.sObjectName = sObjectName;
            this.recordId = recordId;
            this.fields = fields;
        }
    }

    public class Result {
        @AuraEnabled public List<Field> fields;
        @AuraEnabled public List<SObject> objects;
        @AuraEnabled public Boolean viewable;
        @AuraEnabled public Boolean readOnly;
        @AuraEnabled public String error;
        @AuraEnabled public Id id;          // first id when a list is passed
        @AuraEnabled public String successMessage;

        public List<Id> ids;

        public Result() {
            this.viewable = true;
            this.readOnly = false;
            this.fields = new List<Field>();
            this.objects = new List<SObject>();
            this.error = null;
            this.successMessage = null;
        }

        public Result(String error) {
            this.viewable = true;
            this.readOnly = true;
            this.fields = new List<Field>();
            this.objects = new List<SObject>();
            this.error = error;
            this.successMessage = null;
            System.debug('Result error: '+error);
        }

        public Result addFields(List<Field> fields) {
            if(this.fields == null){
                this.fields = new List<Field>();
            }
            this.fields.addAll(fields);
            return this;
        }
        public Result addFields(Field field) {
            return this.addFields(new Field[] {field});
        }
    }

    @AuraEnabled
    public static Result getFieldset(String sObjectName, String sObjectId, String fieldsetName, Id recordTypeId) {
        return getFieldset (sObjectName, sObjectId, fieldsetName, recordTypeId, new List<String>(), null);
    }

    @AuraEnabled
    public static Result recalculateFieldFormulas(String fieldList){
        Result resultData = new Result();
        try {
            String sObjectName;
            List<Field> returnfields = new List<Field>();
            List<Field> fields = (List<Field>) JSON.deserialize(fieldList, List<Field>.class);
            if (!fields.isEmpty()) {
                Map<String, SObjectType> objectMap = Schema.getGlobalDescribe();
                //Check if one of the fields has a sObject name in there
                for (Field fld : fields) {
                    if (fld.sObjectName != '' && fld.sObjectName != null) {
                        sObjectName = fld.sObjectName.toLowerCase();
                        break;
                    }
                }
                if (sObjectName != null) {
                    SObject obj = objectMap.get(sObjectName).newSObject();
                   
                    //Get all data into the object
                    for (Field fld : fields) {
                        system.debug('### fld: ' + JSON.serialize(fld));
                        if (fld.isCalculated != null && !fld.isCalculated && fld.sObjectName != null && fld.name != null && fld.value != null && fld.value != '') {
                            if (fld.type == 'DATE') {
                                obj.put(fld.name, Date.valueOf(fld.value));
                            } else if (fld.type == 'DATETIME') {
                                obj.put(fld.name, DateTime.valueOf(fld.value));
                            } else {
                                obj.put(fld.name, fld.value);
                            }
                        }
                    }

                    //Recalculate the formula fields
                    obj.recalculateFormulas();

                    //Get the recalculated formula values back into the object
                    for (Field fld : fields) {
                        if (fld.isCalculated != null && fld.isCalculated) {
                            if (obj.get(fld.name) != null) {
                                if (String.valueOf(fld.value) != String.valueOf(obj.get(fld.name))) {
                                    fld.value = (String) obj.get(fld.name);
                                    returnfields.add(fld);
                                }
                            }
                            else {
                                fld.value = '';
                                returnfields.add(fld);
                            }
                        }
                    }
                }
            }
            resultData.fields = returnfields;
        }
        catch(Exception e) {
            System.debug('### ERROR: ' + e.getMessage() + ' [' + e.getStackTraceString() + ']');
        }
        return resultData;
    }

    @AuraEnabled
    public static Result getFieldset(String sObjectName, String sObjectId, String fieldsetName, Id recordTypeId, List<String> fieldsToBlock, String picklistOptionOverrides) {
        GenericUtils.checkCommunityUser();
        Result result = new Result();
        Map<String, List<Field.Option>> picklistOptionOverridesMap = new Map<String, List<Field.Option>>();

        if (String.isNotBlank(picklistOptionOverrides)) {
            try {
                List<PicklistOverrides> overridesList = (List<PicklistOverrides>) JSON.deserialize(picklistOptionOverrides, List<PicklistOverrides>.class);
                for (PicklistOverrides currentOverride : overridesList) {
                    picklistOptionOverridesMap.put(currentOverride.key, currentOverride.options);
                }
            }
            catch (Exception e) {}
        }


        System.debug('### getFieldSet(\'' + fieldsetName + '\', \'' + sObjectName + '\', \'' + fieldsetName + '\', \'' + recordTypeId + '\');');
        if (String.isBlank(sObjectName)) {
            return new Result(Label.Error_invalid_object_name);
        }
        if (String.isBlank(fieldsetName)) {
            return new Result('Invalid Fieldset');
        }

        try {
            Schema.SObjectType sObjectTypeObj = GLOBAL_DESCRIBE_MAP.get(sObjectName);
            if (sObjectTypeObj == null) {
                return new Result('Invalid ObjectName');
            }
            Schema.DescribeSObjectResult objectDescribe = sObjectTypeObj.getDescribe();

            result.viewable = GenericUtils.isCommunityUser && GenericUtils.bypassObjectAccess.contains(sObjectName.toLowerCase())?true:objectDescribe.isAccessible();

            String strNoObjectAccessMessage = GenericUtils.checkIfUserHasObjectLevelSecurity(sObjectName, sObjectId);
            result.readOnly = String.isNotEmpty(strNoObjectAccessMessage);

            Map<String, Schema.SObjectField> fieldDescribes = SObjectTypeObj.getDescribe().fields.getMap();
            Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
            Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldsetName);

            if (fieldSetObj == null) {
                fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldsetName);
            }

            if (fieldSetObj == null) {
                return new Result('Invalid FieldSet Name');
            }
            
            if (result.viewable) {
                sObject obj = null;
                if (String.isNotBlank(sObjectId)) {
                    for (sObject queriedObject: Database.query(GenericUtils.getFieldsetQuery(sObjectName, fieldSetObj.getFields(), new List<String>(), 'Where Id = :sObjectId', null, null, true))) {
                        obj = queriedObject;
                    }
                }
                
                if(obj == null) {
                    obj = objectDescribe.getSObjectType().newSObject(recordTypeId, true);
                }
                Set<String> blockedFields = new Set<String>(fieldsToBlock);
                Set<String> controllingFields = new Set<String>();
                Set<String> fieldSetMemberNames = new Set<String>();
                for (Schema.FieldSetMember fieldSetMember: fieldSetObj.getFields()) {
                    // Do not process the field if it should be blocked
                    if (!blockedFields.contains(fieldSetMember.getFieldPath())) {
                        DescribeFieldResult describe = GenericUtils.getFieldDescribeResult(sObjectTypeObj, fieldSetMember);
                        // consider field which are accessible to logged in user
                        if(describe.isAccessible() || (GenericUtils.isCommunityUser && GenericUtils.bypassObjectAccess.contains(sObjectName.toLowerCase()))) {
                            Field field = FieldFactory.create(obj, fieldSetObj.getSObjectType(), fieldSetMember, describe);
                            if (field.type == 'FILEUPLOAD') {
                                String attachmentType = getAttachmentType(field.name);
                                field.format = attachmentType;
                                field.setOptions(picklistOptionOverridesMap.get(attachmentType));
                                field.readOnly = false;
                            }
                            result.addFields(field);

                            // If the label of a reference field is 'Account Id', change it to 'Account'
                            if(field.type == 'REFERENCE' && field.name.endsWithIgnoreCase('Id') && !field.name.startsWithIgnoreCase('Id')) {
                                Schema.SObjectType referencedObject = GLOBAL_DESCRIBE_MAP.get(field.referencedObjectName);
                                if (referencedObject != null) {
                                    field.label = referencedObject.getDescribe().getLabel();
                                }
                            }
                            // fill set of controlling fields for dependent picklists in order to ensure that all these controlling fields are in fieldset
                            if (String.isNotEmpty(field.controllingField)) {
                                controllingFields.add(field.controllingField);
                            }
                            fieldSetMemberNames.add(field.name);
                        }
                    }
                }
                if (String.isNotEmpty(sObjectId) && !controllingFields.isEmpty()) {
                    ensureControllingFieldsInFieldSet(controllingFields, fieldSetMemberNames, sObjectName, sObjectId, result, sObjectTypeObj);
                } else if (!controllingFields.isEmpty()) {
                    ensureControllingFieldsInFieldSet(controllingFields, fieldSetMemberNames, sObjectName, result, sObjectTypeObj);
                }
            }
        }
        catch (Exception e) {
            System.debug('!! Exception: ' + e.getMessage() + '\n' + e.getStackTraceString());
            result = new Result(e.getMessage());
        }
        return result;
    }

    @testvisible
    private static void ensureControllingFieldsInFieldSet(Set<String> controllingFields, Set<String> fieldSetMemberNames, String sObjectName, String recordId, Result result, SObjectType sObjectType) {
        Set<String> queryFields = new Set<String>(controllingFields);
        queryFields.removeAll(fieldSetMemberNames);
        List<SObject> records = new List<SObject>();
        if (!queryFields.isEmpty()) {
            records = Database.query(GenericUtils.getFieldsetQuery(sObjectName, new List<FieldSetMember>(), new List<String>(queryFields), 'Where Id = :recordId', null, null, false));
        } 
        if (!records.isEmpty()) {
            SObject record = records.get(0);
            Map<String, SObjectField> fieldsMap = sObjectType.getDescribe().fields.getMap();
            for (String fieldName : queryFields) {
                Schema.DescribeFieldResult describe = fieldsMap.get(fieldName.toLowerCase()).getDescribe();
                result.addFields(FieldFactory.create(record, sObjectType, null, describe)
                        .setIsHiddenField(true));
            }
        }
    }

    @testvisible
    private static void ensureControllingFieldsInFieldSet(Set<String> controllingFields, Set<String> fieldSetMemberNames, String sObjectName, Result result, SObjectType sObjectType) {
        Set<String> schemaFields = new Set<String>(controllingFields);
        schemaFields.removeAll(fieldSetMemberNames);
        SObject record = sObjectType.newSObject();
        Map<String, SObjectField> fieldsMap = sObjectType.getDescribe().fields.getMap();
        for (String fieldName : schemaFields) {
            Schema.DescribeFieldResult describe = fieldsMap.get(fieldName.toLowerCase()).getDescribe();
            result.addFields(FieldFactory.create(record, sObjectType, null, describe)
                    .setIsHiddenField(true));
        }
    }

    @testvisible
    private static String getAttachmentType(String fieldName) {
        String prefix = '';
        String attachmentType = '';
        if (fieldName.equalsIgnoreCase(prefix + 'CV__c') || fieldName.equalsIgnoreCase(prefix + 'CV_replace__c')) {
            attachmentType = 'CV';
        }
        else if (fieldName.equalsIgnoreCase(prefix + 'Letter__c') || fieldName.equalsIgnoreCase(prefix + 'Letter_replace__c')) {
            attachmentType = 'Letter';
        }
        else if (fieldName.equalsIgnoreCase(prefix + 'Extra_Document_1__c') || fieldName.equalsIgnoreCase(prefix + 'Extra_Document_1_replace__c')) {
            attachmentType = 'extra1';
        }
        else if (fieldName.equalsIgnoreCase(prefix + 'Extra_Document_2__c') || fieldName.equalsIgnoreCase(prefix + 'Extra_Document_2_replace__c')) {
            attachmentType ='extra2';
        }
        return attachmentType;
    }

    @AuraEnabled
    public static Result saveFieldset(String sObjectName, Id sObjectId, String fieldsJson, String fieldsetName, Id recordTypeId ) {
        if (String.isBlank(sObjectName)) {
            return new Result(Label.Error_invalid_object_name);
        }

        Savepoint sp = Database.setSavepoint();
        List<Field> fields = (List<Field>)JSON.deserialize(fieldsJson, List<Field>.class);
        if(sObjectName.toLowerCase() == 'task') {
            Boolean setReminder = false;
            for(Field thisField : fields) {
                if(thisField.name == 'ReminderDateTime' && String.isNotBlank(thisField.value)) {
                    setReminder = true;
                    break;
                }
            }
            if(setReminder) {
                Field newField = new Field('IsReminderSet', 'true', 'BOOLEAN', false);
                newField.name = 'IsReminderSet';
                fields.add(newField);
            }
        }
        Result result = upsertObjects(sObjectName, sObjectId, fields, null, null, null);

        if(String.isNotBlank(result.error)) {
            try {
                Database.rollback(sp);
            }
            catch(Exception rollbackEx) {
                System.debug('ERROR savepoints was already rollback! ' + rollbackEx.getMessage() + ' stack ' +rollbackEx.getStackTraceString() );
            }
        } else {
            Id resultId = result.Id;
            result = getFieldset(sObjectName, resultId, fieldsetName, recordTypeId);
            result.id = resultId;
        }

        return result;
    }
    
    @AuraEnabled
    public static Id getDefaultWorkflowStatus(String jobId) {
        return null;
    }

    public interface FieldsetObjectCreator {
        List<Database.SaveResult> insertObjects(List<sObject> objects);
        List<Database.SaveResult> updateObjects(List<sObject> objects);
    }

    public class FieldsetObjectCreatorDefault implements FieldsetObjectCreator {
        public List<Database.SaveResult> insertObjects(List<sObject> objects) {
            System.debug('FieldsetObjectCreatorDefault.insertObjects(#'+objects.size()+')');
            Database.SaveResult[] results = Database.insert(objects);
            return results;
        }

        public List<Database.SaveResult> updateObjects(List<sObject> objects) {
            System.debug('FieldsetObjectCreatorDefault.updateObjects(#'+objects.size()+')');
            Database.SaveResult[] results = Database.update(objects);
            return results;
        }
    }

    public with sharing class FieldSetObjectCreatorStep implements FieldsetObjectCreator {
        public boolean continueWithHtmlLinks = false;
        public List<Database.SaveResult> insertObjects(List<sObject> objects) {
            System.debug('FieldSetObjectCreatorStep.insertObjects(#'+objects.size()+')');
			return Database.insert(objects);
        }

        public List<Database.SaveResult> updateObjects(List<sObject> objects) {
            System.debug('FieldSetObjectCreatorStep.updateObjects(#'+objects.size()+')');
            return Database.update(objects);
        }
    }

    public with sharing class FieldSetObjectCreatorCandidate implements FieldsetObjectCreator {
        public List<Database.SaveResult> insertObjects(List<sObject> objects) {
            System.debug('FieldSetObjectCreatorCandidate.insertObjects(#'+objects.size()+')');
            return Database.insert(objects);
        }

        public List<Database.SaveResult> updateObjects(List<sObject> objects) {
            System.debug('FieldSetObjectCreatorCandidate.updateObjects(#'+objects.size()+')');
            return Database.update(objects);
        }
    }

    public static Boolean bulkifyRecords = false;

    public static Result upsertObjects(String sObjectName, Id sObjectId, List<Field> fields, List<Map<String, Object>> defaultNewObjectData, String recordTypeName, FieldsetObjectCreator creator) {
        Result result = new Result();

        if (String.isBlank(sObjectName)) {
            return new Result(Label.Error_invalid_object_name);
        }

        try {
            Schema.SObjectType sObjectTypeObj = GLOBAL_DESCRIBE_MAP.get(sObjectName);
            if (sObjectTypeObj == null) {
                return new Result(Label.Error_invalid_object_name);
            }
            Schema.DescribeSObjectResult objectDescribe = sObjectTypeObj.getDescribe();
            Map<String, Schema.SObjectField> fieldDescribes = SObjectTypeObj.getDescribe().fields.getMap();

            result.viewable = (objectDescribe.isAccessible());

            String strNoObjectAccessMessage = GenericUtils.checkIfUserHasObjectLevelSecurity(sObjectName, sObjectId);
            result.readOnly = String.isNotEmpty(strNoObjectAccessMessage);

            if (result.readOnly) {
                return new Result(strNoObjectAccessMessage);
            }

            List<sObject> objects = new List<sObject>();
            System.debug('\r\robjects List: ' + objects);
            Result existingObjectResult = queryExistingObject(fields, fieldDescribes, objects, sObjectName, sObjectId);
            if (existingObjectResult != null) {
                return existingObjectResult;
            }

            if (String.isBlank(sObjectId)) {
                Result createNewResult = createNewObjects(fields, fieldDescribes, objects, defaultNewObjectData, recordTypeName, sObjectTypeObj, sObjectName);
                System.debug('\r\rcreateNewResult: ' + createNewResult);
                if (createNewResult != null) {
                    return createNewResult;
                }
            }

            if(creator == null) {
                creator = new FieldsetObjectCreatorDefault();
            }
            System.debug('creator: '+creator);

            if(bulkifyRecords) {
                //send back the record without saving it to the database
                Result newObjectsResult = new Result();
                newObjectsResult.objects.addAll(objects);
                return newObjectsResult;
            }
            else{
                Result upsertObjectsResult = upsertObjects(objects, fields, creator, objectDescribe);
                if (upsertObjectsResult != null) {
                    return upsertObjectsResult;
                }
            }

            result.id = objects[0].id;
            result.ids = new List<Id>();
            for(sObject createdObject:objects) {
                result.ids.add(createdObject.id);
            }

            createRequirements(result.id, fields, sObjectName);

            system.debug('resulting object ids:'+result.ids);
        }
        catch (Exception e) {
            System.debug('!! Exception: ' + e.getMessage() + '\n' + e.getStackTraceString());
            result = new Result(e.getMessage());
        }
        return result;
    }

    private static void createRequirements(Id objectId, List<Field> fields, String sObjectName) {
    }

    @testvisible
    private static Result queryExistingObject(List<Field> fields, Map<String, Schema.SObjectField> fieldDescribes, List<sObject> objects, String sObjectName, Id sObjectId) {
        SoqlBuilder builder = SoqlBuilder.create().addSelect('Id');
        for(Field thisField : fields) {
            builder.addSelect(thisField.name.toLowerCase());
        }

        if(sObjectId != null) {
            String query = builder.addFrom(sObjectName)
                .addWhere(SoqlBuilder.eq('Id', sObjectId))
                .toQuery();
            system.debug('query:' + query);
            for (sObject existingObject: Database.query(query)) {
                objects.add(existingObject);
                Result fillResult = fillFields(existingObject, fields, fieldDescribes);
                if(fillResult != null) {
                    return fillResult;
                }
            }
        }

        return null;
    }

    private static Result createNewObjects(List<Field> fields, Map<String, Schema.SObjectField> fieldDescribes, List<sObject> objects, List<Map<String, Object>> defaultNewObjectData, String recordTypeName, Schema.SObjectType sObjectTypeObj, String sObjectName) {
        if(defaultNewObjectData == null) {
            defaultNewObjectData = new List<Map<String, Object>>();
            if(objects.size() == 0) {
                defaultNewObjectData.add(new Map<String, Object>());
            }
        }

        for(Map<String, Object> newSObject:defaultNewObjectData) {
            sObject newObject = sObjectTypeObj.newSObject();
            if(recordTypeName != null) {
                Id recordTypeId = GenericUtils.getRecordType(recordTypeName, sObjectName);
                newObject.put('RecordTypeId', recordTypeId);
            }
            else {
                newObject = sObjectTypeObj.newSObject();
            }
            System.debug('\r\rnewObject: ' + newObject);

            objects.add(newObject);

            Result fillResult = fillFields(newObject, fields, fieldDescribes);
            if(fillResult != null) {
                return fillResult;
            }

            for(String fieldName:newSObject.keySet()) {
                newObject.put(fieldName, newSObject.get(fieldName));
            }
        }

        return null;
    }

    public static Result upsertObjects(List<sObject> objects, List<Field> fields, FieldsetObjectCreator creator, Schema.DescribeSObjectResult objectDescribe) {
        List<Database.SaveResult> saveResults = new List<Database.SaveResult>();
        List<sObject> objectsToInsert = new List<sObject>();
        List<sObject> objectsToUpdate = new List<sObject>();

        //Divide what is insert and what is update
        for(sObject obj:objects){
            if(obj.Id == null){
                objectsToInsert.add(obj);
            }else{
                objectsToUpdate.add(obj);
            }
        }

        //Insert objects
        if(!objectsToInsert.isEmpty()) {
            if (objectDescribe.isCreateable()) {
                List<Database.SaveResult> insertResults = creator.insertObjects(objectsToInsert);
                if(insertResults != null && !insertResults.isEmpty()){
                    saveResults.addAll(insertResults);
                }
            } else {
                return new Result('Object not createable');
            }
        }
        //Update objects
        if(!objectsToUpdate.isEmpty()) {
            if (objectDescribe.isUpdateable()) {
                List<Database.SaveResult> updateResults = creator.updateObjects(objectsToUpdate);
                if(updateResults != null && !updateResults.isEmpty()){
                    saveResults.addAll(updateResults);
                }
            } else {
                return new Result('Object not updateable');
            }
        }

        if (!saveResults.isEmpty()) {
            String strActualErrorMessage = '';
            for (Database.saveResult saveResult:saveResults) {
                if (!saveResult.isSuccess()) {
                    List<Field> errorFields = new List<Field>();
                    // Operation failed, so get all errors
                    for (Database.Error err : saveResult.getErrors()) {
                        // Collecting exact error message
                        strActualErrorMessage = err.getMessage();

                        for (String field: err.getFields()) {
                            for (Field fsField: fields) {
                                if (fsField.name == field) {
                                    fsField.error = err.getMessage();
                                    if (fsField.error != null) {
                                        Integer index1 = fsField.error.indexOf(':');
                                        if (index1 > -1) {
                                            Integer index2 = fsField.error.indexOf(':', index1+1);
                                            if (index2 == -1) {
                                                fsField.error = fsField.error.left(index1);
                                            } else {
                                                fsField.error = fsField.error.mid(index1 + 1, index2 - index1);
                                            }
                                        }
                                    }
                                    errorFields.add(fsField);
                                    break;
                                }
                            }
                        }
                    }

                    // instead of showing a generic error message, show actual
                    Result validationErrorResult = new Result(strActualErrorMessage);
                    validationErrorResult.addFields(errorFields);
                   // validationErrorResult.fields = errorFields;
                    return validationErrorResult;
                }
            }
        }

        return null;
    }

    public static Result fillFields(sObject dataObject, List<Field> fields, Map<String, Schema.SObjectField> fieldDescribes) {
        List<Field> errorFields = new List<Field>();
        for (Field field: fields) {
            if(fieldDescribes.containsKey(field.name)){
                DescribeFieldResult describe = fieldDescribes.get(field.name).getDescribe();
                if (!field.name.endsWithIgnoreCase('stardisplay__c')) {
                    string error = GenericUtils.fillField(dataObject, describe, field.name, field.value);
                    if (String.isNotBlank(error)) {
                        field.error = error;
                        if (field.error != null && field.error.indexOf(':') > -1) {
                            field.error = field.error.left(field.error.indexOf(':'));
                        }
                        errorFields.add(field);
                    }
                }
            }

        }
        if (!errorFields.isEmpty()) {
            Result result = new Result('Validation Error');
            result.addFields(errorFields);
            // result.fields = errorFields;
            return result;
        }

        return null;
    }

    public static String getSingleFieldValue(String fieldName, List<Field> fields) {
        String returnedValue = null;
        for (Field f : fields) {
            if (f.name.equalsIgnoreCase(fieldName)) {
                returnedValue = f.value;
                break;
            }
        }
        return returnedValue;
    }
}