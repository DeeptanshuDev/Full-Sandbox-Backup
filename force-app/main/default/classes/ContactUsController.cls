public with sharing class ContactUsController {
    
    public static Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
    
    @AuraEnabled
    public static FieldSetForm getForm(String sObjectName , String fieldSetname) {
        FieldSetForm form = new FieldSetForm();        
        form.Fields = getFields(sObjectName, fieldSetname);
        return form;
    }
    
    private static List<FieldsName> getFields(String objectName, String fieldSetName) {
        Schema.SObjectType objectType = null;
        
        if (String.isNotBlank(objectName)) {
            objectType = Schema.getGlobalDescribe().get(objectName);
        }
        
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        Map<String, Schema.FieldSet> fieldSetMap = objectDescribe.fieldSets.getMap();
        Schema.FieldSet fieldSet = fieldSetMap.get(fieldSetName);
        List<Schema.FieldSetMember> fieldSetMembers = fieldSet.getFields();
        
        List<FieldsName> fields = new List<FieldsName>();
        for (Schema.FieldSetMember fsm : fieldSetMembers) {
            FieldsName fieldName = new FieldsName(fsm);
            
            fields.add(fieldName);
        }
        
        return fields;
    }
    
    public class FieldSetForm {
        @AuraEnabled
        public List<FieldsName> Fields { get; set; }
        
        public FieldSetForm() {
            Fields = new List<FieldsName>();
        }
    }   
    
    public class FieldsName {
        
        public FieldsName(Schema.FieldSetMember fieldSetMember) {
            this.APIName = fieldSetMember.fieldPath;
            this.Required = fieldSetMember.required;
            this.Type = String.valueOf(fieldSetMember.getType());
        }
        
        @AuraEnabled
        public String APIName { get;set; }
        
        @AuraEnabled
        public Boolean Required { get;set; }
        
        @AuraEnabled
        public String Type { get; set; }   
    }
    
    @AuraEnabled
    public static void saveContact(String contactUsId) {
        if(String.isNotBlank(contactUsId)) {
            List<User> users = new List<User>([SELECT ID, FirstName, LastName, Email, Phone FROM User
                                               WHERE Id =: UserInfo.getUserId()
                                               AND IsActive = true
                                              ]);
            if(users.size() > 0) {
                List<ContactUs__c> existingContactUS = [SELECT Id, First_Name__c, Last_Name__c, Email__c, Phone__c 
                                                        FROM ContactUs__c 
                                                        WHERE Id =: contactUsId];
                if(existingContactUS.size() > 0) {
                    existingContactUS[0].First_Name__c = users[0].FirstName;
                    existingContactUS[0].Last_Name__c = users[0].LastName;
                    existingContactUS[0].Email__c = users[0].Email;
                    existingContactUS[0].Phone__c = users[0].Phone;
                    update existingContactUS;
                }
            }
        }
    }
}