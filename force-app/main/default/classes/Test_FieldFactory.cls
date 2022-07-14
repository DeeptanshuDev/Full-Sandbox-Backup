@isTest
public class Test_FieldFactory {
    
    Static String packagePrefix = ((String.isnotBlank(GenericUtils.getPackagePrefix())) ? (GenericUtils.getPackagePrefix()) : '');
    
    @isTest 
    static void test_createRecordField() {
        Test.startTest();
        Schema.SObjectType objType  = Schema.getGlobalDescribe().get('Account');
        Account acc = new Account(Name = 'test',Phone = '1234567897');
        insert acc;
        
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get('Account').getDescribe().fields.getMap();
        schema.describefieldresult dfield;
        Field fd = new Field();
        Field fd1 = new Field();
        Field fd2 = new Field();
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
            Schema.FieldSetMember fsMember;
            dfield = sfield.getDescribe(); 
            fd = new Field('Name','Address','Text',true,fsMember); 
        }
        Field fid = FieldFactory.createRecordField(acc,objType,fd);
        System.assert(fid != null);
        Test.stopTest();
    }
    
    @isTest 
    static void test_getExtraResultFields() {
        Test.startTest();
        Schema.SObjectType sObjType = Account.sObjectType;
        List<Schema.FieldSetMember> fieldset = Schema.sObjectType.Account.fieldSets.getMap().get('MC4SF__Account_Filter_Fields').getFields();
        for(Schema.FieldSetMember filedSetMember: fieldset){
            List<String> fid = FieldFactory.getExtraResultFields(sObjType);
            System.assert(fid != null);
        }    
        Test.stopTest();
    }
    @isTest 
    static void test_getExtraResultFields1() {
        Test.startTest();
        Schema.SObjectType sObjType = Contact.sObjectType;
        List<Schema.FieldSetMember> fieldset = Schema.sObjectType.Contact.fieldSets.getMap().get('MC4SF__Contact_Filter_Fields').getFields();
        for(Schema.FieldSetMember filedSetMember: fieldset){
            List<String> fid = FieldFactory.getExtraResultFields(sObjType);
            System.assert(fid != null);
        }    
        Test.stopTest();
    }
    
    @isTest
    static void test_create() {
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Test account';
        acc.Phone = '1234567897';
        insert acc;
        Schema.SObjectType sObjType = Account.sObjectType; 
        Schema.DescribeFieldResult describe = Account.Name.getDescribe();
        Schema.DescribeFieldResult describe2 = Account.AccountNumber.getDescribe();
        Schema.DescribeFieldResult describe3 = Account.Phone.getDescribe();
        Schema.DescribeFieldResult describe4 = Account.Type.getDescribe();      
        Schema.DescribeFieldResult describe5 = Account.AnnualRevenue.getDescribe();
        Schema.DescribeFieldResult describe6 = Account.Industry.getDescribe();
        
        
        List<Schema.FieldSetMember> fieldset = Schema.sObjectType.Account.fieldSets.getMap().get('MC4SF__Account_Filter_Fields').getFields();
        for(Schema.FieldSetMember filedSetMember: fieldset){
            Field fld = FieldFactory.create(acc,sObjType, filedSetMember,describe);
            Field fld2 = FieldFactory.create(acc,sObjType, filedSetMember,describe2);
            Field fld3 = FieldFactory.create(acc,sObjType, filedSetMember,describe3);
            Field fld4 = FieldFactory.create(acc,sObjType, filedSetMember,describe4);
            Field fld5 = FieldFactory.create(acc,sObjType, filedSetMember,describe5);
            System.assert(fld!= null);
            System.assert(fld2!= null);
            System.assert(fld3!= null);
            System.assert(fld4!= null);
            System.assert(fld5!= null);
        } 
        Test.stopTest();
    }
     
    @isTest
    static void test_create1() {
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Test account';
        acc.Phone = '1234567897';
        insert acc;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'Test Contact';
        con.Preferred_Phone__c = 'Phone';
        insert con;
        
        Schema.SObjectType sObjType = Contact.sObjectType; 
        Schema.DescribeFieldResult describe = Contact.Name.getDescribe(); 
        Schema.DescribeFieldResult describe2 = Contact.Description.getDescribe();
        
        List<Schema.FieldSetMember> fieldset = Schema.sObjectType.Contact.fieldSets.getMap().get('MC4SF__Contact_Filter_Fields').getFields();
        for(Schema.FieldSetMember filedSetMember: fieldset){
            Field fld = FieldFactory.create(con,sObjType, filedSetMember,describe);
            Field fld2 = FieldFactory.create(con,sObjType, filedSetMember,describe2);
            System.assert(fld!= null);
            System.assert(fld2!= null);
        } 
        
    }
    
    @isTest
    static void test_create2() {
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Test account';
        acc.Phone = '1234567897';
        insert acc;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'Test Contact';
        con.Preferred_Phone__c = 'Phone';
        insert con;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', Type = 'Reorder',Event_Date_Old__c = System.today(),StageName = 'Open',
                                          AccountId = acc.id, Collection_Picklist__c ='Poly' , Category_Picklist__c = 'Pro', 
                                          Uniform_Style__c = 'Top', Primary_Contact__c = con.Id, CloseDate = System.today());
        insert opp;
        
        Opportunity oppp = [Select Id, AccountId,Name From Opportunity Where Id =: opp.Id];
        
        Schema.SObjectType sObjTypeOpp = Opportunity.sObjectType;  
        Schema.DescribeFieldResult describeOpp = Opportunity.AccountId.getDescribe();
        Schema.DescribeFieldResult describeOpp1 = Opportunity.CloseDate.getDescribe();
        Schema.DescribeFieldResult describeOpp2 = Opportunity.ForecastCategoryName.getDescribe();
        
        List<Schema.FieldSetMember> fieldsetOpp = Schema.sObjectType.Opportunity.fieldSets.getMap().get('My_Order_Details_1').getFields();
        for(Schema.FieldSetMember filedSetMember: fieldsetOpp){
            Field fld2 = FieldFactory.create(opp,sObjTypeOpp, filedSetMember,describeOpp2);
        } 
        Test.stopTest();
    }
        
    @isTest
    static void test_getPicklistLabelByValue() {
        Test.startTest();
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get('Account').getDescribe().fields.getMap();
        schema.describefieldresult dfield;
        Field fd = new Field();
        String res = FieldFactory.getPicklistLabelByValue('Type', fd);
        System.assertEquals(null, res); 
        Test.stopTest();   
    }
    
}