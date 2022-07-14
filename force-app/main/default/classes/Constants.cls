public class Constants {
    
    public static final String OPERATION_TYPE_UPSERT = 'upsert';
    public static final String TABLE_NAME_ORDERS = 'orders';
    public static final String TABLE_NAME_PRODUCTS = 'inventories';
    public static final String REQUIRED_FIELD_MISSING_ERROR_MESSAGE = 'Order Id or Item Id is missing';
    public static final String INVALID_OPERATION_TYPE = 'Invalid Operation Type';
    public static final String INVALID_TABLE_NAME = 'Invalid table name';
    public static final String STATUS_DETAIL_SUCCESS = 'Success';
    public static final String STATUS_DETAIL_FAILED = 'Failed';
    public static final String FULL_NAME_BILLING_POSTFIX = '(Billing)';
    public static final String BLANK_SPACE = ' ';
    public static final String ORDER_ID_PREFIX = '0000';
    public static final String DATE_DELIMETER_VALUE_DOT = '\\.';
    public static final String TIME_DELIMETER_VALUE_COLON = '\\:';
    public static final String FULL_NAME_SHIPPING_POSTFIX = '(Shipping)';
    public static final String CALLOUT_TYPE_MAGENTO_TO_SFDC = 'Magento --> SFDC';
    public static final String OPERATION_NAME_DOUPSERTSOVERSFDCRRECORDS = 'doUpsertsOverSFDCRecords';
    public static final String TYPE_TALEND_INTEGRATION = 'Talend Integration';
    public static final String TYPE_INVENTORY_INTEGRATION = 'Inventory Integration';
    public static final String REQUEST_METHOD_POST = 'Post';
    public static final String WEBSITE_ID_RA = 'RA';
    public static final String WEBSITE_ID_ONLINE_SALES = 'Online Sales';
    public static final Double NUMERIC_ZERO_VALUE = 0.00;
    public static final Double NUMERIC_ONE_VALUE = 1.00;
    public static final String COUPON_CODE = 'Coupon Code';
    public static final String STRING_COLON = ':';
    public static final String DISCOUNT_LINE_ID_POSTFIX = 'D';
    public static final String GIFTCARD_LINE_ID_POSTFIX = 'G';
    public static final String REFUNDED_LINE_ID_POSTFIX = 'R';
    public static final String SHIPPPING_LINE_ID_POSTFIX = 'S';
    public static final String ORDER_STATUS_MAGENTO = 'Magento';
    public static final String ITEM_NAME_DISCOUNT = 'Discount';
    public static final String ITEM_NAME_GIFT_CARD = 'Gift Card';
    public static final String ITEM_NAME_SHIPPING_FEES = 'Shipping Fees';
    public static final String ACCOUNT_NAME_ONLINE_SALES = 'Online Sales';
    public static final String OTHER_ROLI_ERROR_MESSAGE = 'Other ROLI Operation Error on {0}';
    public static final String STRING_DISCOUNT = 'Discount';
    public static final String STRING_GIFT_CARD = 'Gift Card';
    public static final String STRING_REFUND = 'Refund';
    public static final String STRING_SHIPPING = 'Shipping';
    public static final String BILLING_CUSTOMER_NUMBER_PREFIX = 'B';
    public static final String SHIPPING_CUSTOMER_NUMBER_PREFIX = 'S';
    public static final Integer MIN_ORDER_ID_LENGTH = 10;
    public static final String ZERO_STRING = '0';
    public static final String ONE_STRING = '1';
    public static final String TWO_STRING = '2';
    public static final String CUSTOMER_SITE_ACCOUNT_NUMBER = 'A-00003068';
    public static final String STATUS_LIVE = 'Live';
    public static final String STATUS_DISABLED = 'Disabled';
    public static final String PRODUCT_SKU_BLANK_ERROR_MESSAGE = 'Product Sku is required';
    
    
    public static final String INVENTORY_TRANSACTION_TYPE_INVENTORY_ADJUSTMENT =
        'Inventory Adjustment';
    
    public static final Double STANDARDIZED_ITEM_SHIPPING_RATE = .06;
    
    public static final String DISCOUNT_TYPE_WHOLESALE = 'Wholesale';
    public static final String DISCOUNT_TYPE_EARLY_BIRD = 'Early Bird';
    
    //Migration Configuration (List Custom Setting)
    @testvisible public static Map<String, Migration_Configuration__c> MIGRATION_CONFIGURATION_MAP {
        
        get {
            
            // Find all the Migration Configuration in the custom setting
            Map<String, Migration_Configuration__c> migrationConfigMap = Migration_Configuration__c.getAll();
            
            //return map
            return migrationConfigMap;
        }
    }
    
    //Set to hold the components strings for whom ObjectName. Prefix is required for migration using Package.xml file
     @testvisible public static Set<String> SET_COMPONENTS_NAME_HAVING_OBJECT_NAME_PREFIX_AS_MEMBER {
        
        get {
            
            //Create a Set of fields
            Set<String> setFields = new Set<String>();
            
            //Populating set with the value
            setFields.add('CustomField');
            setFields.add('CustomObjectOwnerSharingRule');
            setFields.add('CustomObjectCriteriaBasedSharingRule');
            setFields.add('RecordType');
            setFields.add('WorkflowRule');
            setFields.add('WorkflowFieldUpdate');
            setFields.add('WorkflowTask');
            setFields.add('WorkflowAlert');
            setFields.add('WebLink');
            setFields.add('ValidationRule');
            setFields.add('AssignmentRule');
            setFields.add('AutoResponseRule');
            setFields.add('BusinessProcess');
            setFields.add('EscalationRule');
            setFields.add('ListView');
            setFields.add('FieldSet');
            setFields.add('WorkflowOutboundMessage');
            setFields.add('ApprovalProcess');
            
            //Return Set
            return setFields;
        }
    }
    
    public final static String LAYOUT = 'Layout';
    public final static String PACKAGEFILENAMESPACE = 'http://soap.sforce.com/2006/04/metadata';
    public final static String PACKAGE_STRING = 'Package';
    public final static String PACKAGE_PREFIX = 'ih';
    public final static String FULLNAME = 'fullName';
    public final static String INITIAL_TEXT = 'Migration test';
    public final static String TYPES = 'types';
    public final static String MEMBERS = 'members';
    public final static String NAME = 'name';
    public final static String VERSION = 'version';
    public final static String VERSION_NO = '27.0';
    public final static String ENTIRE_WORKFLOW = 'Workflow: Entire Workflow';
    public final static String INFO_MESSAGE = 'Please include actions related to workflow manually. Since user added Entire workflow as modification on SIR.';
    
    public static final String BEARER = 'Bearer';
    public static final String AUTHORIZATION = 'Authorization';
    public static final Set<String> setOfJobStatus = new Set<String>{'WAITING', 'ACQUIRED', 'EXECUTING', 'PAUSED', 'BLOCKED','PAUSED_BLOCKED', 'Holding', 'Queued', 'Preparing', 'Processing'};
    public static final Set<Integer> setOfSBCreateSuccessCodes = new Set<Integer>{200, 201};
    
    public static final String JOB_TYPE_QUEUEABLE = 'Queueable';
    public static final String SB_STATUS= 'Completed';
    public static final String CONTENT_TYPE= 'Content-Type';
    public static final String CONTENT_TYPE_APP_URLENCODED = 'application/x-www-form-urlencoded';
    public static final String CONTENT_TYPE_APP_JSON = 'application/json';
    public static final String HTTP_REQUEST_GET_TYPE = 'GET';
    public static final String HTTP_REQUEST_POST_TYPE = 'POST';
    public static final String HTTP_REQUEST_PUSH_TYPE = 'PUSH';
    public static final String HTTP_REQUEST_PUT_TYPE = 'PUT';
    public static final String CHAR_FORWARDSLASH_COMMA = '\'';
    public static final String CHAR_SEMI_COLON = ';';
    public static final String CHAR_DOT = '.';
    public static final String CHAR_COMMA = ',';
    public static final String CHAR_SPACE = ' ';
    public static final String CHAR_COLON = ':';
    
    public static final String GENDER_SMALL = 'gender';
    public static final String EMAIL_SMALL = 'email';
    public static final String AGE_SMALL = 'age';

	public static final String HTTP_AUTHORIZATION = 'Authorization';
	public static final String HTTP_BEARER = 'Bearer';    
    public static final String HTTP_HEADER_ID = 'id';
    public static final String HTTP_HEADER_GYM_ID = 'gym_id'; // Don't use it, Use Below One
    public static final String HTTP_GYM_ID = 'gym_id';
    public static final String HTTP_GYM_DELETE_RESPONSE = 'Gym has been deleted';
    public static final String HTTP_TEAM_ID = 'team_id';
    public static final String HTTP_CATEGORY_ID = 'category_id';
    public static final String HTTP_USER_ID = 'user_id';
    public static final String HTTP_ORDER_ID = 'order_id';
    public static final String HTTP_EDIT_ID = 'edit_id';
    public static final String HTTP_FIT_ID = 'fit_id';
    public static final String HTTP_SPEC_ID = 'spec_id';
    public static final String HTTP_MEMBER_ID = 'member_id';
    public static final String HTTP_ACTION = 'action';
    
    public static final String DATA_TYPE_INTEGER = 'Integer';
    public static final String DATA_TYPE_DATETIME = 'DateTime';
     public static final String DATA_TYPE_DATE = 'Date';
    
    public static final String HTTP_RESPONSE_FAILED = 'Failed';
    public static final String HTTP_RESPONSE_CREATED = 'Created';
    public static final String HTTP_RESPONSE_SPECIFICATION_DELETE = 'Spec deleted';
    
    public static final String CONTACT_TYPE_ATHLETE = 'Athlete';
    
    public static final String HTTP_RESPONSEWRAPPER_STATUS_FAIL = 'fail';
    public static final String HTTP_RESPONSEWRAPPER_STATUS_SUCCESS = 'success';
    
    //FF3.0 Integartion based generic constants
    public static final String ACTIVE_SMALL = 'active';
    public static final String FINALIZED_SMALL = 'finalized';
    public static final String NAME_SMALL = 'name';
    public static final String ERROR_LINE =  'ERROR By Line #';
    public static final String DETAILS =   'Details :';
    
    //FF3.0 Intergration based HTTP attribute keys constants
    public static final String HTTP_PARAM_MEASUREMENT_ID = 'measure_id';
    
    //Measurement object columns name
    public static final String MEASUREMENT_PERSON_HEIGHT = 'person_height';
    public static final String MEASUREMENT_MEASURED_SIZES = 'measured_sizes';
    public static final String MEASUREMENT_Y_VALUES = 'y_values';
    public static final String MEASUREMENT_MEASURED_BY = 'measured_by';
    
    //Specification object FF side field apis
    public static final String SPECIFICATION_DEFINED_MEASURES = 'defined_measures';
    public static final String SPECIFICATION_CREATED_AT = 'created_at';
    
    //Fits object FF side field apis
    public static final String FITS_CATEGORIES_ID = 'categories_id';
    public static final String FITS_CONDITION_APPLY = 'condition_apply';
    public static final String FITS_CREATED_BY = 'created_by';
    public static final String FITS_FABRIC = 'fabric';
    public static final String FITS_FIT_DESC = 'fit_desc';
    public static final String FITS_FIT_IMAGE = 'fit_image';
    public static final String FITS_FIT_NUMBER = 'fit_number';
    public static final String FITS_IS_DELETED = 'is_deleted';
    public static final String FITS_LINING = 'lining';
    public static final String FITS_CREATED_AT = 'created_at';
    public static final String FITS_MODIFIED_AT = 'modified_at';
    
    //Order object FF side field apis
    public static final String ORDER_FITS = 'fits';
    public static final String ORDER_FINALIZE = 'finalize';
    public static final String ORDER_IS_DELETED = 'is_deleted';
    public static final String ORDER_IS_FINALIZED = 'is_finalized';
    public static final String ORDER_IS_SUBMITTED = 'is_submitted';
    public static final String ORDER_CREATED_AT = 'created_at';
    public static final String ORDER_MODIFIED_AT = 'modified_at';
    
    //Contact(User/Athlete) object FF side field apis
    public static final String USER_FIRST_NAME = 'first_name';
    public static final String USER_LAST_NAME = 'last_name';
    
    //Team object FF side field apis
    public static final String TEAM_MEMBER_COUNT = 'member_count';
    public static final String TEAM_NAME = 'team_name';
    public static final String TEAM_CREATED_AT = 'created_at';
    public static final String TEAM_MODIFIED_AT = 'modified_at';
    public static final String HTTP_TEAM_BODY_NEW_TEAM_NAME = 'new_team_name';

    public static final String CUSTOM_ITEM_STAGE_GREY_OUT = 'Grey out';
    public static final String CUSTOM_ITEM_STAGE_PROTOTYPE = 'Prototype';
    public static final String CUSTOM_ITEM_STAGE_CONFIRMED = 'Confirmed';
    public static final String STANDARDIZED_ITEM_STAGE_GREY_OUT = 'Grey out';
    public static final String STANDARDIZED_ITEM_STAGE_PROTOTYPE = 'Prototype';
    public static final String STANDARDIZED_ITEM_STAGE_CONFIRMED = 'Confirmed';
    
    //Gym object FF side field apis
    public static final String GYM_NAME = 'gym_name';
    public static final String GYM_TYPE = 'gym_type';
    public static final String LOCATION = 'location';
    public static final String ADMIN = 'admin';
    public static final String GYM = 'gym';
    public static final String TEAM = 'team';
    
    
    public static Final String GYM_SQLOBJECT = 'gym';
    public static Final String ADMIN_SQLOBJECT = 'admin';
    public static Final String TEAM_SQLOBJECT = 'team';
    public static Final String ATHLETE_CREATED_SUCCESSFULLY = 'Athlete Created Successfully';
    
    public static Final String RESPONSE_ADD_COACH_TO_TEAM = 'Coach added';
    
    
    //Art Approval Constant
    public static Final String ART_APPROVAL_EMAIL_TEMPLATE = 'Art Approval Email Template';
    public static Final String  REBEL_ESIGNATURE_SITE = 'Rebel_eSignature_Site';
     public static Final String TRUE_CLIENT_IP = 'True-Client-IP';
    public static Final String  X_SALESFORCE_SIP = 'X-Salesforce-SIP';
     public static Final String X_FORWARDED_FOR = 'X-Forwarded-For';
    public static Final String  USER_AGENT = 'User-Agent';
    
    //AddMUltipleStandardItemsController class constant
    public static Final String stage = 'Confirmed';
    public static Final String BOY = 'Boy';
    public static Final String GIRL = 'Girl';

}