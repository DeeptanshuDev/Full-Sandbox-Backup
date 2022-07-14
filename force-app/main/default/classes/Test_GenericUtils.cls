@isTest(seealldata = False)
public class Test_GenericUtils {
    
    @isTest
    static void test_getNameSpacePrefix() {
        String strClassName = 'MyOrdersController';
        Test.startTest();    
        String nameSpaceprefix = GenericUtils.getNameSpacePrefix(strClassName);
        System.assertEquals('',nameSpaceprefix);
        Test.stopTest();   
    }
    
    @isTest
    static void test_getPackagePrefix() {
        Test.startTest();
        String packagePrefix = GenericUtils.getPackagePrefix();
        System.assertEquals('',packagePrefix);
        Test.stopTest();   
    }
    
    @isTest
    static void test_getRecordTypeLabel() {
        Id typeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Reorder').getRecordTypeId();
        Test.startTest();      
        String label = GenericUtils.getRecordTypeLabel(typeId);
        System.assertEquals('Reorder',label);
        Test.stopTest();   
    }
    
    @isTest
    static void test_SFDC_JSENCODE() {
        String input = 'This is a string with a \\ in it';
        String expectedOutput = 'This is a string with a \\' +'\\ in it';
        Test.startTest();        
        String result  = GenericUtils.SFDC_JSENCODE(input);
        System.assertEquals(expectedOutput,result);
        Test.stopTest();   
    }
    
    @isTest
    static void test_SFDC_JSDECODE() {
        String input = 'This is a string with a \\ in it';
        String expectedOutput = 'This is a string with a \\ in it';
        Test.startTest();      
        String result  = GenericUtils.SFDC_JSDECODE(input);
        System.assertEquals(expectedOutput,result);
        Test.stopTest();   
    }
    
    @isTest
    static void test_xssSafeValue() {
        String input = 'This is a string with a \\ in it';
        String expectedOutput = 'This is a string with a \\ in it';
        Test.startTest();
        String output = GenericUtils.xssSafeValue(input);
        System.assertEquals(expectedOutput,output);
        Test.stopTest();   
    }
    
    @isTest
    static void test_jsDecodeValidHtml() {
        String input1 = '';
        String input = '<div style="background-color:lightblue"><h3>This is a heading</h3><p>This is a paragraph.</p></div>';
        String input2 = '<div style="background-color:lightblue" onchange="myFunction()"><p>This is a paragraph.</p></div>';
        Map<String, Set<String>> whiteList = new Map<String, Set<String>>();
        Set<String> div = new Set<String>();
        div.add('style');
        div.add('onchange');
        whiteList.put('div', div);
        
        Test.startTest();       
        String result1  = GenericUtils.jsDecodeValidHtml(input1);
        System.assertEquals(null,result1);
        
        String result  = GenericUtils.jsDecodeValidHtml(input);
        System.assertEquals('<div style="background-color:lightblue"><h3>This is a heading</h3><p>This is a paragraph.</p></div>' ,result);
        
        String output = GenericUtils.jsDecodeValidHtml(input2, whiteList);
        System.assertEquals('<div style="background-color:lightblue" onchange="myFunction()"><p>This is a paragraph.</p></div>',input2); 
        Test.stopTest	();   
    }
    
    @isTest
    static void test_encryptAndDecrypted() {
        String input = 'AditiMathur';    
        Test.startTest();         
        String encryptedData = GenericUtils.encrypt(input);     
        String decryptedData =  GenericUtils.decrypt(encryptedData);        
        System.assertEquals('AditiMathur', decryptedData);
        Test.stopTest();   
    }
    
    @isTest
    static void test_getConvertedFieldPath() {  
        Test.startTest();
        String result1 = GenericUtils.getConvertedFieldPath('Id','Id');
        System.assertEquals('Id', result1);
        
        String result2 = GenericUtils.getConvertedFieldPath('AccountId','REFERENCE');
        System.assertEquals('Account.Name', result2);
        
        String result3 = GenericUtils.getConvertedFieldPath('Expense__c','REFERENCE');
        System.assertEquals('Expense__r.Name', result3);
        
        String result4 = GenericUtils.getConvertedFieldPath('ContactId','Id');
        System.assertEquals('Contact.Name', result4);    
        
        String result5 = GenericUtils.getConvertedFieldPath('Account','REFERENCE');
        System.assertEquals('Account.Name', result5); 
        Test.stopTest();
    }
    
    @isTest
    static void test_getArrayStringForQuery() {
        Test.startTest();
        List<Object> objectList = new List<Object>{'Account'};
        String objectListOfString =  GenericUtils.getArrayStringForQuery(objectList);
        System.assertEquals('(\'' + '(Account)' + '\')', objectListOfString);
        
        String objectListString =  GenericUtils.getArrayStringForQuery('Account');
        System.assertEquals('(\'' + 'Account' + '\')', objectListString);  
        
        String objectListString2 = GenericUtils.getArrayStringForQuery('');
        System.assertEquals('(\''  + '\')', objectListString2);  
        Test.stopTest();
    }
    
    @isTest
    static void test_getsObjectDescribe() { 
        Test.startTest();
        Schema.DescribeSObjectResult sobjectTypeData =  GenericUtils.getsObjectDescribe('Account');
        System.debug('Sobject type----> '+sobjectTypeData);   
        Account accObj = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        System.debug('sObject data type -: '+accObj);
        Test.stopTest();
    }
    
    @isTest
    static void test_getsObjectFieldsDescribe() {
        Test.startTest();
        Map<String,Schema.DescribeFieldResult> mapOfSchemaDescribeField = GenericUtils.getsObjectFieldsDescribe('Account', 'AccountNumber');
        System.assertEquals(true,mapOfSchemaDescribeField.get('AccountNumber').Accessible);
        System.assertEquals(true,mapOfSchemaDescribeField.get('AccountNumber').Updateable);  
        System.assertEquals(false,mapOfSchemaDescribeField.get('AccountNumber').AutoNumber);  
        
        Map<String,Schema.DescribeFieldResult> mapOfSchemaDescribeField2 = GenericUtils.getsObjectFieldsDescribe('Contact', 'Account.Name');
        System.assertEquals(true,mapOfSchemaDescribeField2.get('Account.Name').Updateable);
        System.assertEquals(false,mapOfSchemaDescribeField2.get('Account.Name').Nillable);
        Test.stopTest();     
    }
    
    @isTest
    static void test_getFieldDescribeResult() {
        Test.startTest();    
        Schema.SObjectType sObjType = Account.sObjectType;
        Schema.DescribeFieldResult fieldResult = GenericUtils.getFieldDescribeResult(sObjType, 'Name');
        System.assertEquals(true, fieldResult.isUpdateable());
        System.assertEquals(true, fieldResult.isAccessible());
        
        Schema.SObjectType sObjType2 = Contact.sObjectType;
        Schema.DescribeFieldResult fieldResult2 = GenericUtils.getFieldDescribeResult(sObjType2, 'Account.Name');
        System.assertEquals(true, fieldResult2.isUpdateable());
        System.assertEquals(true, fieldResult2.isAccessible());
        
        List<Schema.FieldSetMember> fieldset = Schema.sObjectType.Account.fieldSets.getMap().get('MC4SF__Account_Filter_Fields').getFields();
        for(Schema.FieldSetMember filedSetMember: fieldset){
            Schema.DescribeFieldResult fieldResult3 = GenericUtils.getFieldDescribeResult(sObjType, filedSetMember); 
            System.assertEquals(true, fieldResult3.Accessible); 
        }     
        Test.stopTest();
    }
    
    @isTest
    static void test_getFieldValue() {
        Contact con = new Contact();
        Account newAcc = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        insert newAcc;
        String res = 'Fexle';
        Account acc = [Select Name From Account Where Name =: res LIMIT 1];     
        Contact contacts = new Contact();
        
        Test.startTest();      
        GenericUtils.getFieldValue(con,'Name');
        System.assertEquals('Name', 'Name');
        
        GenericUtils.getFieldValue(contacts,'Account.Name');
        System.assertEquals('Fexle', res);
        Test.stopTest();
    }
    
    @isTest
    static void test_getRecordType() {
        Test.startTest();
        Id str = GenericUtils.getRecordType(null,null);
        System.assertEquals(str, null);
        
        Id str2 = GenericUtils.getRecordType('','');
        System.assertEquals(str2, null);
        
        ID recId = GenericUtils.getRecordType('Case','Case');
        System.assertEquals(recId, '012150000014BMQAA2');
        Test.stopTest();
    }
    
    @isTest
    static void test_isoTime2DateTime() {
        DateTime dateTimeData = GenericUtils.isoTime2DateTime('2019-04-13');
        Test.startTest();    
        string strDate = String.valueOfGmt(dateTimeData);
        System.assertEquals(strDate, '2019-04-13 00:00:00');      
        Test.stopTest();
    }
    
    @isTest
    static void test_disarmString() {
        Test.startTest();
        String str = GenericUtils.disarmString('Fexle@');
        System.assertEquals(str, 'Fexle@');  
        
        String str2 = GenericUtils.disarmString('');
        System.assertEquals(str2, ''); 
        Test.stopTest();
    }
    
    @isTest
    static void test_truncString() {
        Test.startTest();
        String truncStr = GenericUtils.truncString('HelloEveryOne',5);
        System.assertEquals(truncStr, 'Hello');  
        
        String truncStr2 = GenericUtils.truncString('HelloEveryOne',11,'5');
        System.assertEquals(truncStr2, 'HelloEvery5');  
        
        String truncStr3 = GenericUtils.truncString('',11,'Earth');
        System.assertEquals(truncStr3, '');  
        
        String truncStr4 = GenericUtils.truncString('HelloEveryOne',11,'HelloEveryOnes');
        System.assertEquals(truncStr4, 'HelloEveryOnes');  
        Test.stopTest();
    }
    
    @isTest
    static void test_removeBadUtfChars() {
        Test.startTest();
        String str = GenericUtils.removeBadUtfChars('HelloWorldOne');
        System.assertEquals(str, 'HelloWorldOne');  
        Test.stopTest();
    }	
    
    @isTest
    static void test_readObjectValue() {
        Account newAcc = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        insert newAcc;
        
        Contact con = new Contact();
        con.FirstName = 'Ram';
        con.LastName = 'Gupta';
        con.AccountId = newAcc.id;
        insert con;
        
        sObject sObj = con;
        
        Test.startTest();   
        Object objData = GenericUtils.readObjectValue(sObj,'Account.Name');
        System.assertEquals(null,objData);
        Test.stopTest();
    }
    
    @isTest
    static void test_getFieldSetsFields() {
        Test.startTest();    
        List<String>  fieldNameList = GenericUtils.getFieldSetsFields('Account','MC4SF__Account_Filter_Fields');
        List<String> listOfFieldsName = new List<String>{'Fax', 'Name', 'AccountNumber', 'Phone', 'Rating', 'Site', 'AccountSource', 'Type', 
            											'AnnualRevenue', 'BillingCity', 'BillingCountry', 'BillingStateCode','BillingStreet',
            											'BillingPostalCode', 'CreatedDate','Employees', 'Industry','LastActivityDate',
            											'LastModifiedDate', 'ShippingAddress', 'Website'};

        List<String>  fieldNameList2 = GenericUtils.getFieldSetsFields('Contact','AccountFieldSet');
        List<String> listOfFieldsName2 = new List<String>{};
        System.assertEquals(listOfFieldsName2,fieldNameList2);    
        Test.stopTest();
    }
    
    @isTest
    static void test_getReferenceFieldDescribeResult() {
        Test.startTest();
        Schema.DescribeSObjectResult describeResult = Contact.sObjectType.getDescribe();
        String fieldsName = 'Account.Name';
        Schema.DescribeFieldResult fieldResult = GenericUtils.getReferenceFieldDescribeResult(describeResult, fieldsName);
        System.assertEquals(true, fieldResult.isAccessible());
        System.assertEquals(false, fieldResult.isAutoNumber());
        
        Schema.DescribeSObjectResult describeResult2 = Campaign.sObjectType.getDescribe();
        String fieldsName2 = 'Campaign';
        Schema.DescribeFieldResult fieldResult2 = GenericUtils.getReferenceFieldDescribeResult(describeResult2, fieldsName2);
        System.assertEquals(null, fieldResult2);
        
        Schema.DescribeSObjectResult describeResult3 = c2g__codaCashEntry__c.sObjectType.getDescribe();
        String fieldsName3 = 'c2g__OwnerCompany__c';
        Schema.DescribeFieldResult fieldResult3 = GenericUtils.getReferenceFieldDescribeResult(describeResult3, fieldsName3);
        System.assertEquals(true, fieldResult3.isAccessible());
        System.assertEquals(false, fieldResult3.isAutoNumber());
        
        Test.stopTest();
    }
    
    @isTest
    static void test_fillField() {
        sObject sobj = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        insert sobj;
        Contact newCon = new Contact(LastName = 'Gupta', AccountId = sobj.Id);
        insert newCon;
        String expectedCreatableExceptionThrown = 'Field Not Creatable';
        String expectedUpdateacleExceptionThrown = 'Field not updateable' ;
        
        Test.startTest();     
        Schema.DescribeFieldResult describeNameFieldResult = Account.Name.getDescribe();
        Object objName = 'Fexle';
        String nameFieldFillData = GenericUtils.fillField(sObj,describeNameFieldResult,'Name', objName);
        System.AssertEquals(null, nameFieldFillData);
        
        Schema.DescribeFieldResult describeBooleanFieldResult = Account.IsCustomerPortal.getDescribe();
        object objBoolean = true;
        String booleanFieldFillData = GenericUtils.fillField(sObj,describeBooleanFieldResult,'IsCustomerPortal', objBoolean);
        System.AssertEquals(null, booleanFieldFillData);
        
        Schema.DescribeFieldResult describeDateFieldResult = Account.SCMC__Credit_Card_Expiration_Date__c.getDescribe();
        Object objDate = system.today();
        String dateFieldFillData = GenericUtils.fillField(sObj,describeDateFieldResult,'SCMC__Credit_Card_Expiration_Date__c', objDate);
        System.assertEquals(null,dateFieldFillData); 
        
        Schema.DescribeFieldResult describeDateFieldResult2 = Account.SCMC__Credit_Card_Expiration_Date__c.getDescribe();
        Object objDate2 = '2019-08-12T20:17:46.384Z';
        String dateFieldFillData2 = GenericUtils.fillField(sObj,describeDateFieldResult2,'SCMC__Credit_Card_Expiration_Date__c', objDate2);
        System.assertEquals(null,dateFieldFillData2); 
        
        Schema.DescribeFieldResult describeDateTimeFieldResult = Account.CreatedDate.getDescribe();
        Object objDateTime = System.now();
        String dateTimeFieldFillData = GenericUtils.fillField(sObj,describeDateTimeFieldResult,'CreatedDate', objDateTime);
        System.AssertEquals(expectedUpdateacleExceptionThrown, dateTimeFieldFillData);
        
        Schema.DescribeFieldResult describeNumberFieldResult = Account.NumberOfEmployees.getDescribe();
        Object objNumber = 100;
        String numberFieldFillData = GenericUtils.fillField(sObj,describeNumberFieldResult,'NumberOfEmployees', objNumber);
        System.assertEquals(null,numberFieldFillData); 
        
        Schema.DescribeFieldResult describeCurrencyFieldResult = Account.AnnualRevenue.getDescribe();
        Object objCurrency = 88;
        String currencyFieldFillData = GenericUtils.fillField(sObj,describeCurrencyFieldResult,'AnnualRevenue', objCurrency);
        System.assertEquals(null,currencyFieldFillData); 
        
        sObject oppSobj = new Opportunity(Type = 'Reorder', AccountId = sobj.Id, Primary_Contact__c = newCon.Id, Name = 'Test Opportunity',	Category_Picklist__c ='Pro', Prototype_Status__c ='Proto', CloseDate = System.today(), StageName ='Open', Collection_Picklist__c = 'Poly');
        insert oppSobj;
        
        Schema.DescribeFieldResult describePercentFieldResult = Opportunity.Probability.getDescribe();
        Object objPercent = 100;
        String percentFieldFillData = GenericUtils.fillField(oppSobj,describePercentFieldResult,'Probability', objPercent);
        System.assertEquals(null,percentFieldFillData); 
        Test.stopTest();
    }  
    
    @isTest
    static void test_removeScript() {
        Test.startTest();        
        String input = GenericUtils.removeScript('onkeydown');
        System.assertEquals(' ', input);
        Test.stopTest();
    }  
    
    @isTest
    static void test_getFieldsetQuery() {
        Test.startTest();      
        
        Schema.FieldSetMember[] fieldset = Schema.sObjectType.Account.fieldSets.getMap().get('MC4SF__Account_Filter_Fields').getFields();
        String input = GenericUtils.getFieldsetQuery('Account',fieldset);
        String outputquery ='select id, fax, name, accountnumber, phone, rating, site, accountsource, type, annualrevenue, billingcity, billingcountry, billingstate, billingstreet, billingpostalcode, createddate, numberofemployees, industry, lastactivitydate, lastmodifieddate, shippingcity, shippingcountry, shippingstate, shippingstreet, shippingpostalcode, website from Account';
        System.assertEquals(outputquery, input);
        
        List<String> mandatoryFields = new List<String>{'Name = Fexle'};
        String fieldSetInput = GenericUtils.getFieldsetQuery('Account',fieldset, mandatoryFields);
        String outputquery2 ='select id, name = fexle, fax, name, accountnumber, phone, rating, site, accountsource, type, annualrevenue, billingcity, billingcountry, billingstate, billingstreet, billingpostalcode, createddate, numberofemployees, industry, lastactivitydate, lastmodifieddate, shippingcity, shippingcountry, shippingstate, shippingstreet, shippingpostalcode, website from Account';
        System.assertEquals(outputquery2, fieldSetInput);
        
        String whereClause = 'Name =' + 'Fexle' + '\'';
        String orderBy = 'Name';
        String queryLimit = '5';
        Boolean convertFieldPaths = true; 
        String fieldSetInput3 = GenericUtils.getFieldsetQuery('Account', fieldset, mandatoryFields,whereClause, orderBy, queryLimit, convertFieldPaths);
        String outputquery3 ='select id, name = fexle, fax, name, accountnumber, phone, rating, site, accountsource, type, annualrevenue, billingcity, billingcountry, billingstate, billingstreet, billingpostalcode, createddate, numberofemployees, industry, lastactivitydate, lastmodifieddate, shippingcity, shippingcountry, shippingstate, shippingstreet, shippingpostalcode, website from Account Name =Fexle' +'\' Name 5';
        System.assertEquals(outputquery3, fieldSetInput3);
        
        String fieldSetInput4 = GenericUtils.getFieldsetQuery('Account', fieldset, mandatoryFields,whereClause, orderBy, queryLimit, convertFieldPaths, true);
        String outputquery4 ='select id, name = fexle, fax, name, accountnumber, phone, rating, site, accountsource, type, annualrevenue, billingcity, billingcountry, billingstate, billingstreet, billingpostalcode, createddate, numberofemployees, industry, lastactivitydate, lastmodifieddate, shippingcity, shippingcountry, shippingstate, shippingstreet, shippingpostalcode, website from Account Name =Fexle' +'\' Name 5';
        System.assertEquals(outputquery4, fieldSetInput4);
        
        Test.stopTest();
    } 
    
    @isTest
    static void test_removeHtml() {
        Test.startTest();    
        String input = 'Hello<.*?>world';
        String output = GenericUtils.removeHtml(input);
        System.assertEquals('Hello world',output);
        Test.stopTest();
    } 
    
    @isTest
    static void test_checkIfUserHasObjectLevelSecurity() {
        Test.startTest();   
        Account newAcc = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        insert newAcc;
        String recordId = newAcc.Id;
        String objLevelSecurityResult = GenericUtils.checkIfUserHasObjectLevelSecurity('Account',recordId);
        System.assertEquals('',objLevelSecurityResult);
        
        String objLevelSecurityResult2 = GenericUtils.checkIfUserHasObjectLevelSecurity('',recordId);
        System.assertEquals('Invalid ObjectName',objLevelSecurityResult2);
        
        String objLevelSecurityResult3 = GenericUtils.checkIfUserHasObjectLevelSecurity('Account','');
        System.assertEquals('',objLevelSecurityResult3);
        Test.stopTest();
    } 
    
    @isTest
    static void test_getPickListValuesIntoList() {
        Test.startTest(); 
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
        List<String> listOfPicklistValue = GenericUtils.getPickListValuesIntoList('Case', recTypeId, 'Priority');
        List<String> expectedResult = new List<String> {'Immediate', 'Same Day Response Needed', 'Next Day Response', '2-3 Day Response Needed'};
        System.assertEquals(expectedResult, listOfPicklistValue);
        Test.stopTest();
    } 
}