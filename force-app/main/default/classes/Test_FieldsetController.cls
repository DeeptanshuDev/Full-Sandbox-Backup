@isTest(seealldata = false)
public class Test_FieldsetController {
    
    @isTest
    static void test_getFieldset() {
        Account accounts = new Account(name='Account', Type = 'Pro', Phone = '9685741452');
        insert accounts;
        
        Test.startTest();
        
        FieldsetController.Result result = FieldsetController.getFieldset('bla',null,'bla',null);
        System.assertNotEquals(null,result.error);
        
        FieldsetController.Result result2 = FieldsetController.getFieldset('Account',accounts.Id,'MC4SF__Account_Filter_Fields',null);
        System.assertNotEquals('Same value',result2.error);
     
        FieldsetController.Result result3 = FieldsetController.getFieldset(GenericUtils.getPackagePrefix()+'AccountId',null,GenericUtils.getPackagePrefix()+'Apply_page_unittest',null);
        System.assertEquals('Invalid ObjectName',result3.error);
       
        FieldsetController.Result result4 = FieldsetController.getFieldset(GenericUtils.getPackagePrefix()+'cxsCandidate__c',accounts.Id,GenericUtils.getPackagePrefix()+'Apply_page_unittest',null);
        System.assertEquals('Invalid ObjectName',result4.error);
        
        Test.stopTest();    
    }
    
    private final static Map<String,String> FIELD_VALUES = new Map<String,String>{
        GenericUtils.getPackagePrefix()+'First_name__c' => 'fsc_FirstName',
            GenericUtils.getPackagePrefix()+'Initials__c' => 'f.s.c.',
            GenericUtils.getPackagePrefix()+'Last_name_prefix__c' => 'Pfx',
            GenericUtils.getPackagePrefix()+'Last_name__c' => 'fsc_LastName',
            GenericUtils.getPackagePrefix()+'Gender__c' => 'Female',
            GenericUtils.getPackagePrefix()+'Date_of_birth__c' => '1965-10-12',
            GenericUtils.getPackagePrefix()+'Town_city__c' => 'fsc_TownCity',
            GenericUtils.getPackagePrefix()+'E_mail_address__c' => 'fsc@connexys.nl',
            GenericUtils.getPackagePrefix()+'Linked_in_URL__c' => null,
            GenericUtils.getPackagePrefix()+'Mobile_phone__c' => '0612345678',
            GenericUtils.getPackagePrefix()+'Private_phone__c' => '0101234567',
            GenericUtils.getPackagePrefix()+'Address_line_1__c' => 'K.p. van der Mandelelaan 68',
            GenericUtils.getPackagePrefix()+'Country__c' => 'Nederland'
            };
                
    @isTest
   	private static void testGetSingleFieldValue(){
        Field f = new Field();
        f.name = 'Test_Field__c';
        f.value = 'Test Value';
        system.assertEquals('Test Value', FieldsetController.getSingleFieldValue('Test_Field__c', new List<Field>{f}), 'Value should be Test Value');
    }
      
    @isTest
    static void testRecalculateFieldFormulas(){
        String packagePrefix = GenericUtils.getPackagePrefix();
        List<Field> fieldList = new List<Field>();
        //Name
        Field nameFld = new Field('Name', 'Account Name', '', 'STRING', true, true, false, 'Test WE', 'Test WE');
        nameFld.fieldName = 'Name';
        nameFld.sObjectName = 'Account';
        nameFld.isCalculated = false;
        fieldList.add(nameFld);
        // Date
        Field startDateFld = new Field(packagePrefix+'SCMC__Credit_Card_Expiration_Date__c', 'Credit Card Expiration Date', '', 'Date', false, true, false, '2018-01-01', '2018-01-01');
        startDateFld.fieldName = 'SCMC__Credit_Card_Expiration_Date__c';
        startDateFld.sObjectName = 'Account';
        startDateFld.isCalculated = false;
        fieldList.add(startDateFld);
        // Date and time
        Field DateFld = new Field(packagePrefix+'LastCURequestDate', 'Last Stay-in-Touch Request Date', '', 'Date/Time', false, true, false, 'System.Now()', 'System.Now()');
        DateFld.fieldName = 'LastCURequestDate';
        DateFld.sObjectName = 'Contact';
        DateFld.isCalculated = false;
        fieldList.add(DateFld);
        // Formula field
        Field FormulaFld = new Field(packagePrefix+'ortoo_qra__Reviewed_Days__c', 'Q-assign Reviewed Days', '', 'Formula (Number)', false, true, false, '', '');
        FormulaFld.fieldName = 'ortoo_qra__Reviewed_Days__c';
        FormulaFld.sObjectName = 'Contact';
        FormulaFld.isCalculated = true;
        fieldList.add(FormulaFld);
        
        FieldsetController.Result res = FieldsetController.recalculateFieldFormulas(JSON.serialize(fieldList));
    }
  
    @isTest
    static void test_saveFieldset(){
        Account newAcc = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        insert newAcc;
       
        Contact newCon = new Contact();
        newCon.LastName = 'Gupta';
        newCon.AccountId = newAcc.Id;
        newCon.Preferred_Phone__c = 'Phone';
        newCon.Email = 'test@gmail.com';
        insert newCon;

        String packagePrefix = GenericUtils.getPackagePrefix();
        List<Field> fieldList = new List<Field>();
        //Name
        Field nameFld = new Field('Name', 'Account Name', '', 'STRING', true, true, false, 'Test WE', 'Test WE');
        nameFld.fieldName = 'Name';
        nameFld.sObjectName = 'Account';
        nameFld.isCalculated = false;
        fieldList.add(nameFld);
        // Date
        Field startDateFld = new Field(packagePrefix+'SCMC__Credit_Card_Expiration_Date__c', 'Credit Card Expiration Date', '', 'Date', false, true, false, '2018-01-01', '2018-01-01');
        startDateFld.fieldName = 'SCMC__Credit_Card_Expiration_Date__c';
        startDateFld.sObjectName = 'Account';
        startDateFld.isCalculated = false;
        fieldList.add(startDateFld);
        // Date and time
        Field DateFld = new Field(packagePrefix+'LastCURequestDate', 'Last Stay-in-Touch Request Date', '', 'Date/Time', false, true, false, 'System.Now()', 'System.Now()');
        DateFld.fieldName = 'LastCURequestDate';
        DateFld.sObjectName = 'Contact';
        DateFld.isCalculated = false;
        fieldList.add(DateFld);
        // Formula field
        Field FormulaFld = new Field(packagePrefix+'ortoo_qra__Reviewed_Days__c', 'Q-assign Reviewed Days', '', 'Formula (Number)', false, true, false, '', '');
        FormulaFld.fieldName = 'ortoo_qra__Reviewed_Days__c';
        FormulaFld.sObjectName = 'Contact';
        FormulaFld.isCalculated = true;
        fieldList.add(FormulaFld);
        
        String fieldsJson = JSON.serialize(fieldList);
        Id recordTypeId = GenericUtils.getRecordType('Default', 'Contact');
        
        FieldsetController.saveFieldset('Contact', newCon.Id, fieldsJson, 'MC4SF__Contact_Filter_Fields', recordTypeId);        
    }

    @isTest
    static void test_getDefaultWorkflowStatus() {
        Id resultId = FieldsetController.getDefaultWorkflowStatus('101');
        System.assertEquals(null,resultId);
    }
    
    @isTest
    static void test_unitTest() {
        Account acc = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        insert acc;
        String strId = String.valueOf(acc.Id);
        
        Set<String> controllingFields = new Set<String>{'Bulk_Shipping_Country__c','Proto_Shipping_Country__c','Type'};
        Set<String> fieldSetMemberNames = new Set<String>{'Fax', 'AccountNumber', 'Name', 'Phone', 'Type'};
            
        Schema.DescribeFieldResult fieldResult = Account.Name.getDescribe();
        SObjectType accountType = Schema.getGlobalDescribe().get('Account');
        
        String res = FieldsetController.getAttachmentType('Name');

        FieldsetController.Result result = new FieldsetController.Result();   
        FieldsetController.ensureControllingFieldsInFieldSet(controllingFields,fieldSetMemberNames,'Account',strId,result,accountType);
        FieldsetController.ensureControllingFieldsInFieldSet(controllingFields,fieldSetMemberNames,'Account',result,accountType);
    }
    
    @isTest
    static void test_upsertObjects() {
        Account newAcc = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        insert newAcc;
        
        Contact newCon = new Contact();
        newCon.LastName = 'Gupta';
        newCon.AccountId = newAcc.Id;
        newCon.Preferred_Phone__c = 'Phone';
        newCon.Email = 'test@gmail.com';
        insert newCon;
        
        String packagePrefix = GenericUtils.getPackagePrefix();
        List<Field> fieldList = new List<Field>();
        //Name
        Field nameFld = new Field('Name', 'Account Name', '', 'STRING', true, true, false, 'Test WE', 'Test WE');
        nameFld.fieldName = 'Name';
        nameFld.sObjectName = 'Account';
        nameFld.isCalculated = false;
        fieldList.add(nameFld);
        // Date
        Field startDateFld = new Field(packagePrefix+'SCMC__Credit_Card_Expiration_Date__c', 'Credit Card Expiration Date', '', 'Date', false, true, false, '2018-01-01', '2018-01-01');
        startDateFld.fieldName = 'SCMC__Credit_Card_Expiration_Date__c';
        startDateFld.sObjectName = 'Account';
        startDateFld.isCalculated = false;
        fieldList.add(startDateFld);
        
        List<sObject> objects = new List<sObject>{newAcc};

        FieldsetController creator = new FieldsetController();
        Schema.DescribeSObjectResult objectDescribe =  GenericUtils.getsObjectDescribe('Account');
        FieldsetController.FieldsetObjectCreatorDefault creater = new FieldsetController.FieldsetObjectCreatorDefault();
        FieldsetController.FieldSetObjectCreatorCandidate candidiateCreator = new FieldsetController.FieldSetObjectCreatorCandidate();
        FieldsetController.FieldSetObjectCreatorStep objectCreator = new FieldsetController.FieldSetObjectCreatorStep();
        
        FieldsetController.upsertObjects(objects,fieldList,creater,objectDescribe);
      	FieldsetController.upsertObjects('Contact',newCon.Id,fieldList,null, 'Default',creater);
 
    }
    
    @isTest
    static void test_getSingleFieldValue() {
        String packagePrefix = GenericUtils.getPackagePrefix();
        List<Field> fieldList = new List<Field>();
        
         //Name
        Field nameFld = new Field('Name', 'Account Name', '', 'STRING', true, true, false, 'Test WE', 'Test WE');
        nameFld.fieldName = 'Name';
        nameFld.sObjectName = 'Account';
        nameFld.isCalculated = false;
        fieldList.add(nameFld);
        // Date
        Field startDateFld = new Field(packagePrefix+'SCMC__Credit_Card_Expiration_Date__c', 'Credit Card Expiration Date', '', 'Date', false, true, false, '2018-01-01', '2018-01-01');
        startDateFld.fieldName = 'SCMC__Credit_Card_Expiration_Date__c';
        startDateFld.sObjectName = 'Account';
        startDateFld.isCalculated = false;
        fieldList.add(startDateFld);
        // Date and time
        Field DateFld = new Field(packagePrefix+'LastCURequestDate', 'Last Stay-in-Touch Request Date', '', 'Date/Time', false, true, false, 'System.Now()', 'System.Now()');
        DateFld.fieldName = 'LastCURequestDate';
        DateFld.sObjectName = 'Contact';
        DateFld.isCalculated = false;
        fieldList.add(DateFld);
        
        String res = FieldsetController.getSingleFieldValue('Name', fieldList);
        System.assertEquals('Test WE', res);
        
    }
    
    @isTest
    static void test_fillFields() {
        
        Account newAcc = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        insert newAcc;
        
        String packagePrefix = GenericUtils.getPackagePrefix();
        List<Field> fieldList = new List<Field>();
        
        //Name
        Field nameFld = new Field('Name', 'Account Name', '', 'STRING', true, true, false, 'Test WE', 'Test WE');
        nameFld.fieldName = 'Name';
        nameFld.sObjectName = 'Account';
        nameFld.isCalculated = false;
        fieldList.add(nameFld);
        // Date
        Field startDateFld = new Field(packagePrefix+'SCMC__Credit_Card_Expiration_Date__c', 'Credit Card Expiration Date', '', 'Date', false, true, false, '2018-01-01', '2018-01-01');
        startDateFld.fieldName = 'SCMC__Credit_Card_Expiration_Date__c';
        startDateFld.sObjectName = 'Account';
        startDateFld.isCalculated = false;
        fieldList.add(startDateFld);
        
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        SObjectType accountType = Schema.getGlobalDescribe().get('Opportunity');
        Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();

        FieldsetController.fillFields(newAcc, fieldList, mfields);
        
    }
    
    @isTest
    static void test_queryExistingObject() {
        
        Account newAcc = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        insert newAcc;
       
        String packagePrefix = GenericUtils.getPackagePrefix();
        List<Field> fieldList = new List<Field>();
        //Name
        Field nameFld = new Field('Name', 'Account Name', '', 'STRING', true, true, false, 'Test WE', 'Test WE');
        nameFld.fieldName = 'Name';
        nameFld.sObjectName = 'Account';
        nameFld.isCalculated = false;
        fieldList.add(nameFld);
        // Date
        Field startDateFld = new Field(packagePrefix+'SCMC__Credit_Card_Expiration_Date__c', 'Credit Card Expiration Date', '', 'Date', false, true, false, '2018-01-01', '2018-01-01');
        startDateFld.fieldName = 'SCMC__Credit_Card_Expiration_Date__c';
        startDateFld.sObjectName = 'Account';
        startDateFld.isCalculated = false;
        fieldList.add(startDateFld);

        List<sObject> objects = new List<sObject>{newAcc};
            
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        SObjectType accountType = Schema.getGlobalDescribe().get('Opportunity');
        Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();
        
        FieldsetController.queryExistingObject(fieldList, mfields, objects, 'Account', newAcc.Id);
    }
    
}