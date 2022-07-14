public without sharing class DataServiceController {

    private static Integer MAX_PAGE_SIZE = 2000;
    
    /**
     * Row class representing sObject record in a good format.
    */
    public class Row {
        @AuraEnabled public Id id;
        @AuraEnabled public List<Field> fields;
        public Row(Id id) {
            this.id = id;
            this.fields = new List<Field>();
        }
    }
   
    /** 
     * InitInfo class contains all init information
     * that needed for DataService and other components that use DataService.
    */
    public class InitInfo {

        /**
        * fieldDescribe - sObject fields describe in a good format.
        */
        @AuraEnabled public List<Field> fieldDescribe { get; set; }
        /**
        * encryptedQueryStructureJson - QueryStructure.class instance converted to Json.
        * This attribute encrypted for security reason
        * this attribute needed to increase a performance, because all the main
        * operations happen once during init.
        */
        @AuraEnabled public String encryptedQueryStructureJson {get;set;}
        public InitInfo(List<Field> fieldDescribe , String encryptedQueryStructureJson){
            this.fieldDescribe = fieldDescribe;
            this.encryptedQueryStructureJson = encryptedQueryStructureJson;
        }

    }


    /**
    * PaginationInfo class contains pagination information
    * that needed for DataService and other components that use DataService.
   */
    public class PaginationInfo {
        /**
        * totalNumberOfRecords - number of records.
        */
        @AuraEnabled public Integer totalNumberOfRecords { get; set; }

        /**
        * totalPages - number of pages in pagination.
        */
        @AuraEnabled public Integer totalPages { get; set; }

        /**
        * hasMoreRecords - true if total number of records more than 2000.
        */
        @AuraEnabled public Boolean hasMoreRecords { get; set; }


        public PaginationInfo(Integer totalPages){
            this.totalPages = totalPages;
            this.totalNumberOfRecords = 0;
            this.hasMoreRecords = false;
        }

        public void addRecordsNumber(Integer totalNumberOfRecords){
            this.totalNumberOfRecords = totalNumberOfRecords;
        }
    }


    /**
    *  Method to get a limited scope of records (based on pagination settings)
    *  Use existing query structure from InitInfo to query the data.
    *  Method also use for data sorting.
    *  @param  encryptedQueryStructureJson QueryStructure.class instance converted to Json. This attribute encrypted for security reason.
    *  @param  currentPage current pagination page.
    *  @param  pageSize pagination page size.
    *  @param  ordersJson optional , json that represent list of QueryStructure.OrderField class instance. Use for SOQL Order By condition.
    *  @return - DataScope class instance in a Json format.
    *  @exception AuraHandledException
    *              if the DataService query structure
    *              is in incorrect format.
    */
    @AuraEnabled(cacheable=true)
    public static String getDataScope(String encryptedQueryStructureJson , Integer currentPage, Integer pageSize, String ordersJson) {// ,String filtersJson,String ordersJson,List<String> groupFields
        try{
            // re-use existing QueryStructure object , that was created during init
            String decryptedQueryStructure =  GenericUtils.decrypt(encryptedQueryStructureJson);
            QueryStructure structureOfQuery = (QueryStructure)Json.deserialize(decryptedQueryStructure,QueryStructure.class);

            //add order by statement
            if(!String.isBlank(ordersJson)) {
                try{
                    List<QueryStructure.OrderField> orders = (List<QueryStructure.OrderField>)Json.deserialize(ordersJson,List<QueryStructure.OrderField>.class);
                    structureOfQuery.addOrderFields(orders);
                } catch (Exception e){
                    throw new GenericUtils.ValidationException(System.Label.Error_dataservice_order_incorrect);
                }
            }

            //get existing sObject fields describe. Do not run describe call every time.
            Map<String, Field> fieldDescribe =  structureOfQuery.getFieldsDescribe();

            Integer currentPageNumber = Integer.valueOf(currentPage);
            Integer pageSizeNumber = Integer.valueOf(pageSize);
            if (pageSizeNumber < 1) {
                pageSizeNumber = MAX_PAGE_SIZE;
            }
            if (pageSizeNumber > MAX_PAGE_SIZE) {
                pageSizeNumber = MAX_PAGE_SIZE;
            }

            String sqlQuery ;
            List<Row> dataScope = new List<Row>();
            SoqlBuilder builder = structureOfQuery.getSoqlBuilder();

            if(builder.getWillReturnResults()) {

                //get a full string soql query
                if(currentPageNumber > 0 && pageSizeNumber > 0){
                    sqlQuery = builder.setPage(currentPageNumber, pageSizeNumber).toQuery();
                } else {
                    sqlQuery = builder.setPage(1,MAX_PAGE_SIZE).toQuery();
                }
                system.debug(sqlQuery + 'sqlQuery+++');
                List<SObject> recordsSet = Database.query(sqlQuery);

                //Prepare data in a good format
                Schema.sObjectType objType = Schema.getGlobalDescribe().get(structureOfQuery.getSobjectName());
                for(SObject record : recordsSet){
                    Row row = new Row(record.id);
                    for(String fieldName : fieldDescribe.keySet()){
                        Field field ;
                        field = FieldFactory.createRecordField(record,objType,fieldDescribe.get(fieldName));
                        row.fields.add(field);
                    }
                    dataScope.add(row);
                }

            }

            return JSON.serialize(dataScope);
        }catch (Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString() + ' ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage() );
        }

    }
    /**
    *  Method to get all init information for DataService.
    *  This method run only during the init operation
    *  or if DataService query structure is changed.
    *  This method check CRUD and FLS user access.
    *  @param  sObjectName name of sObject to query from.
    *  @param  fields list of sObject fields that need to be returned from query.
    *  @param  fieldSets list of sObject fieldSets that need to be returned from query.
    *  @param  pageSize optional , pagination page size.
    *  @param  filtersJson optional , json that represent QueryStructure.Filter class instance. Use for SOQL WHERE condition.
    *  @param  groupFields optional , list of fields for Soql Group by.
    *  @return - InitInfo class instance.
    *  @exception AuraHandledException
    *              if the DataService query structure
    *              is in incorrect format.
    */
    @AuraEnabled(cacheable=true)
    public static InitInfo getInitInfo(String sObjectName,List<String> fields,List<String> fieldSets, Integer pageSize, String filtersJson,List<String> groupFields,List<String> hiddenFields){// ,String filtersJson,String ordersJson,List<String> groupFields
        try{
            if(String.isBlank(sObjectName)){
                return null ;
            }
            Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName);
            if ((sObjectType == null) &&
                (!sObjectName.startsWithIgnoreCase(GenericUtils.getPackagePrefix()) &&
                (Schema.getGlobalDescribe().get(GenericUtils.getPackagePrefix()+sObjectName) != null))){
                sObjectName = GenericUtils.getPackagePrefix()+sObjectName;
            }
            if(fields.isEmpty() && fieldSets.isEmpty()){
                return null;
            }


            // add Soql query FROM
            QueryStructure structureOfQuery = QueryStructure.create().fromSObject(string.valueOf(sObjectName)).addFields(fields);

            // add fieldSets to query structure
            if(!fieldSets.isEmpty()){
                for(String fieldSetName : fieldSets){
                    structureOfQuery.addFieldSet(fieldSetName);
                }
            }

            if(!hiddenFields.isEmpty()){
                Set<String> setOfHiddenFields = new Set<String>(hiddenFields);
                structureOfQuery.addHiddenFields(setOfHiddenFields);
            }

            // add query WHERE condition
            if(String.isNotBlank(filtersJson)){
                try {
                    QueryStructure.Filter filter = (QueryStructure.Filter)Json.deserialize(filtersJson, QueryStructure.Filter.class);

                    if(filter != null && String.isNotEmpty(filter.soslString)) {
                        filter.getSoslResults(SObjectName);
                    }
                    
                    //Special filter for community
                    //------------------------------
                    GenericUtils.checkCommunityUser();
                    if(sobjectType == Opportunity.sObjectType && GenericUtils.isCommunityUser) {
                        QueryStructure.FilterField filterField = new QueryStructure.FilterField();
                        filterField.fieldName = 'StageName';
                        filterField.restriction = QueryStructure.RestrictionEnum.NE;
                        QueryStructure.FilterValue filterValue = new QueryStructure.FilterValue();
                        filterValue.stringValues.add('Grey out');
                        filterField.filterValue = filterValue;
                        filter.filterFields.add(filterField);
                    }
                    //------------------------------
                    structureOfQuery.addFilter(filter);

                } catch (Exception e){
                    throw new GenericUtils.ValidationException(System.Label.Error_dataService_filters_incorrect + '\n' + e.getMessage() + ' ' + e.getStackTraceString() + ' ' + e.getLineNumber()  );
                }
            }

            Map<String, Field> fieldDescribe =  structureOfQuery.getFieldsDescribe();

            // encrypt QueryStructure instance for future needs.
            String encryptedQueryStructureJson = Json.serialize(structureOfQuery);
            encryptedQueryStructureJson = GenericUtils.encrypt(encryptedQueryStructureJson);

            InitInfo initInfo = new InitInfo(fieldDescribe.values(),encryptedQueryStructureJson);

            return initInfo;
        } catch (Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString() + ' ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    *  Method to get all pagination information for DataService.
    *  This method run only during the init operation
    *  or if DataService query structure is changed.
    *  This method check CRUD and FLS user access.
    *  @param  encryptedQueryStructureJson QueryStructure.class instance converted to Json. This attribute encrypted for security reason.
    *  @param  pageSize pagination page size.
    *  @return - PaginationInfo class instance in a Json format.
    *  @exception AuraHandledException
    *              if the DataService query structure
    *              is in incorrect format.
    */
    @AuraEnabled(cacheable=true)
    public static PaginationInfo getPaginationDetails(String encryptedQueryStructureJson,Integer pageSize){
        try{
            String decryptedQueryStructure =  GenericUtils.decrypt(encryptedQueryStructureJson);
            QueryStructure structureOfQuery = (QueryStructure)Json.deserialize(decryptedQueryStructure,QueryStructure.class);

            SoqlBuilder builder = structureOfQuery.getSoqlBuilder();

            Long totalPages = 0;
            Integer totalNumberOfRecords = 0;
            Boolean hasMoreRecords =false;

            if(builder.getWillReturnResults()) {

                String sqlQuery = builder.toQuery();

                if (Integer.valueOf(pageSize) < 1) {
                    pageSize = MAX_PAGE_SIZE;
                } else {
                    pageSize = Integer.valueOf(pageSize);
                }

                String countQuery = structureOfQuery.getSoqlBuilder().toCountQuery(MAX_PAGE_SIZE + 1);
                Integer numberOfRecords = Database.countQuery(countQuery);
                hasMoreRecords = (numberOfRecords > MAX_PAGE_SIZE) ;
                // add total pages for pagination
                totalNumberOfRecords = numberOfRecords > MAX_PAGE_SIZE ? MAX_PAGE_SIZE : numberOfRecords;
                totalPages = ((Decimal)totalNumberOfRecords/ pageSize).round(System.RoundingMode.UP);

            }

            // encrypt QueryStructure instance for future needs.
            PaginationInfo paginationInfo = new PaginationInfo(Integer.valueOf(totalPages));
            paginationInfo.addRecordsNumber(totalNumberOfRecords);
            paginationInfo.hasMoreRecords = hasMoreRecords;

            return paginationInfo;

        } catch (Exception e){
            system.debug(e.getMessage() + ' ' + e.getStackTraceString() + ' ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }

    }

}