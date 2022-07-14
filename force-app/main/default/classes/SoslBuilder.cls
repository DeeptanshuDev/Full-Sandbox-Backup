public with sharing class SoslBuilder {

    private static final List<String> DEFAULT_RETURN_FIELDS = new List<String> { 'Id' };

    /**
     *  This class holds information about fieldnames and fieldobject types, used to create the sosl statement.
     *  It also stores the resulting ID's (per object) after running the SOSL statement
     */
    public class SoslStructure {
        public List<Id> ids;
        public List<String> fieldNames;
        public String objectName;

        public SoslStructure() {
            this.ids = new List<Id>();
            this.fieldNames = new List<String>();
        }

        public SoslStructure setObjectName(String objectName) {
            this.objectName = objectName;
            return this;
        }

        public SoslStructure addFieldName(String fieldName) {
            this.fieldNames.add(fieldName);
            return this;
        }
    }

    private String objectName;
    private String searchString;
    private List<String> returnFields;
    private Boolean isDirty;
    public List<SoslStructure> soslStructures;

    /**
     * Constructor
     */
    public SoslBuilder() {
        this.setReturnFields(DEFAULT_RETURN_FIELDS);
        this.soslStructures = new List<SoslStructure>();
        this.isDirty = true;
    }

    /**
     * Create a new SoslBuilder instance for the provided list of SoslStructures
     *
     * @param soslStructures
     *
     * @return
     */
    public static SoslBuilder fromSoslStructures(List<SoslStructure> soslStructures) {
        SoslBuilder builder = new SoslBuilder();
        builder.soslStructures = soslStructures;
        builder.isDirty = false;
        return builder;
    }

    /**
     * Sets the object to base the SOSL search on
     *
     * @param objectName
     *
     * @return
     */
    public SoslBuilder forObject(String objectName) {
        this.objectName = objectName;
        this.addSoslStructure(new SoslStructure().addFieldName('Id').setObjectName(objectName));
        return this.setDirty();
    }

    /**
     * Sets the searchString
     *
     * @param searchString
     *
     * @return
     */
    public SoslBuilder setSearchString(String searchString) {
        this.searchString = searchString;
        return this.setDirty();
    }

    /**
     * Sets the fields to use in the RETURNING statement
     *
     * @param returnFields
     *
     * @return
     */
    public SoslBuilder setReturnFields(List<String> returnFields) {
        this.returnFields = returnFields;
        return this.setDirty();
    }


    /**
     * Adds a new SoslStructure object to the list of SoslStructures
     *
     * @param soslStructure
     *
     * @return
     */
    private SoslBuilder addSoslStructure(SoslStructure soslStructure) {
        this.soslStructures.add(soslStructure);
        return this;
    }

    /**
     * Returns the SoslStructure object for the provided objectName
     *
     * @param objectName
     *
     * @return
     */
    private SoslStructure getSoslStructureForObjectName(String objectName) {
        for(SoslStructure soslStructure: soslStructures) {
            if(soslStructure.objectName == objectName) {
                return soslStructure;
            }
        }
        return null;
    }

    /**
     * Sets the configuration to dirty so we know we need to re-execute the SOSL statement when calling `getResults()`
     *
     * @return
     */
    private SoslBuilder setDirty() {
        this.isDirty = true;
        return this;
    }

    /**
     * Generates a SOSL statement
     *
     * @return
     */
    public String toSoslStatement() {
        List<String> returningObjects = new List<String>();

        for(SoslStructure soslStructure: soslStructures) {
            returningObjects.add(soslStructure.objectName + '(' + String.join(returnFields, ', ') +')');
        }
        return 'FIND :searchString IN ALL FIELDS RETURNING ' + String.join(returningObjects, ', ');
    }

    /**
     * Executes the SOSL statement, stores the results in the list of SoslStructures
     *
     * @return
     */
    public SoslBuilder execute() {

        if(!this.isDirty) {
            return this;
        }

        this.isDirty = false;
        String soslStatement = this.toSoslStatement();

        System.debug('SoslBuilder.execute() - Executing SOSL statement: ' + soslStatement + '\n:searchString = ' + searchString);

        List<List <sObject>> soslResult = Search.query(soslStatement);

        Integer i = 0;
        if(soslResult.size() > 0) {

            for(List<SObject> results: soslResult) {
                if(results != null && results.size() > 0) {

                    String objectName = results.get(0).getSObjectType().getDescribe().getName();
                    List<Id> ids = new List<Id>();

                    SoslStructure soslStructure = getSoslStructureForObjectName(objectName);

                    for(SObject result: results) {
                        ids.add(result.Id);
                    }
                    soslStructure.ids = ids;
                }

                i++;
            }
        }
        return this;
    }

    /**
     *
     *
     * @return
     */
    public List<SoslStructure> getResults() {
        if(this.isDirty) {
            this.execute();
        }
        return soslStructures;
    }

    /**
     * Creates a SoqlBuilder.Criterion for the provided list of SoslStructures
     *
     * @return
     */
    public SoqlBuilder.Criterion getCriterion() {
        this.execute();

        SoqlBuilder.Criterion criterion;

        for(SoslStructure soslStructure: soslStructures) {
            if(soslStructure.ids.size() > 0) {
                if(criterion == null) {
                    criterion = SoqlBuilder.disjunction();
                }

                for(String fieldName: soslStructure.fieldNames) {
                    criterion.add(SoqlBuilder.valueIn(fieldName, soslStructure.ids));
                }
            }
        }
        return criterion;
    }

    /**
     * Include all searchable REFERENCE fields of the currently set object, including non-custom fields
     *
     * @return
     */
    public SoslBuilder includeReferenceFields() {
        return this.includeReferenceFields(false).setDirty();
    }

    /**
     * Include all searchable REFERENCE fields of the currently set object.
     *
     * If onlyCustomFields is true, only custom REFERENCE fields will be included
     *
     * @param onlyCustomFields
     *
     * @return
     */
    public SoslBuilder includeReferenceFields(Boolean onlyCustomFields) {

        DescribeSObjectResult sObjectDescribe = genericUtils.getsObjectDescribe(this.objectName);
        Map<String, SObjectField> fields = sObjectDescribe.fields.getMap();

        for(SObjectField field: fields.values()) {
            DescribeFieldResult describeFieldResult = field.getDescribe();

            if(describeFieldResult.getType() == Schema.DisplayType.REFERENCE && ((onlyCustomFields && describeFieldResult.isCustom()) || !onlyCustomFields)) {

                DescribeSObjectResult referenceDescribeSObjectResult = describeFieldResult.getReferenceTo().get(0).getDescribe();

                // check if the object is searchable
                if(referenceDescribeSObjectResult.isSearchable()) {
                    String objectName = referenceDescribeSObjectResult.getName();
                    String fieldName = describeFieldResult.getName();
                    SoslStructure soslStructure = getSoslStructureForObjectName(objectName);

                    if(soslStructure != null) {
                        soslStructure.addFieldName(fieldName);
                    }
                    else {
                        this.addSoslStructure(
                                new SoslStructure()
                                        .setObjectName(objectName)
                                        .addFieldName(fieldName)
                        );
                    }
                }
            }
        }
        return this.setDirty();
    }

    /**
     * Returns true if the SOSL statement has any results
     *
     * @return
     */
    public Boolean hasResults() {

        if(this.isDirty) {
            this.execute();
        }

        for(SoslStructure soslStructure: soslStructures) {
            if(soslStructure.ids.size() > 0) {
                return true;
            }
        }
        return false;
    }

}