@isTest
public class TestFactory {

  public static SObject createSObject(SObject sObj) {
    // Check what type of object we are creating and add any defaults that are needed.
    String objectName = String.valueOf(sObj.getSObjectType());
    // Construct the default values class. Salesforce doesn't allow '__' in class names
    String defaultClassName = 'TestFactory.' + objectName.replace('__c', '') + 'Defaults';
    // If there is a class that exists for the default values, then use them
    if (Type.forName(defaultClassName) != null) {
      sObj = createSObject(sObj, defaultClassName);
    }
    return sObj;
  }

  public static SObject createSObject(SObject sObj, Boolean doInsert) {
    SObject retObject = createSObject(sObj);
    if (doInsert) {
      insert retObject;
    }
    return retObject;
  }

  public static SObject createSObject(SObject sObj, String defaultClassName) {
    // Create an instance of the defaults class so we can get the Map of field defaults
    Type t = Type.forName(defaultClassName);
    if (t == null) {
      Throw new TestFactoryException('Invalid defaults class.');
    }
    FieldDefaults defaults = (FieldDefaults)t.newInstance();
    addFieldDefaults(sObj, defaults.getFieldDefaults());
    return sObj;
  }

  public static SObject createSObject(SObject sObj, String defaultClassName, Boolean doInsert) {
    SObject retObject = createSObject(sObj, defaultClassName);
    if (doInsert) {
      insert retObject;
    }
    return retObject;
  }

  public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects) {
    return createSObjectList(sObj, numberOfObjects, (String)null);
  }

  public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, Boolean doInsert) {
    SObject[] retList = createSObjectList(sObj, numberOfObjects, (String)null);
    if (doInsert) {
      insert retList;
    }
    return retList;
  }

  public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, String defaultClassName, Boolean doInsert) {
    SObject[] retList = createSObjectList(sObj, numberOfObjects, defaultClassName);
    if (doInsert) {
      insert retList;
    }
    return retList;
  }

  public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects, String defaultClassName) {
    SObject[] sObjs = new SObject[] {};
    SObject newObj;

    // Get one copy of the object
    if (defaultClassName == null) {
      newObj = createSObject(sObj);
    } else {
      newObj = createSObject(sObj, defaultClassName);
    }

    // Get the name field for the object
    String nameField = nameFieldMap.get(String.valueOf(sObj.getSObjectType()));
    if (nameField == null) {
      nameField = 'Name';
    }

    // Clone the object the number of times requested. Increment the name field so each record is unique
    for (Integer i = 0; i < numberOfObjects; i++) {
      SObject clonedSObj = newObj.clone(false, true);
      clonedSObj.put(nameField, (String)clonedSObj.get(nameField) + ' ' + i);
      sObjs.add(clonedSObj);
    }
    return sObjs;
  }

  private static void addFieldDefaults(SObject sObj, Map<String, Object> defaults) {
    // Loop through the map of fields and if they are null on the object, fill them.
    for (String field : defaults.keySet()) {
      if (sObj.get(field) == null) {
        sObj.put(field, defaults.get(field));
      }
    }
  }

  // When we create a list of SObjects, we need to
  private static Map<String, String> nameFieldMap = new Map<String, String> {
    'Contact' => 'LastName',
    'Case' => 'Subject'
  };

  public class TestFactoryException extends Exception {}

  // Use the FieldDefaults interface to set up values you want to default in for all objects.
  public interface FieldDefaults {
    Map<String, Object> getFieldDefaults();
  }

  // To specify defaults for objects, use the naming convention [ObjectName]Defaults.
  // For custom objects, omit the __c from the Object Name

  public class AccountDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Name' => 'Test Account',
        'BillingStreet' => '123 Billing',
        'BillingCity' => 'BCity',
        'BillingState' => 'Texas',
        'BillingPostalCode' => '75222',
        'BillingCountry' => 'United States',
        'ShippingStreet' => '123 Shipping',
        'ShippingCity' => 'SCity',
        'ShippingState' => 'Texas',
        'ShippingPostalCode' => '75222',
        'ShippingCountry' => 'United States'
      };
    }
  }

  public class ContactDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'FirstName' => 'First',
        'LastName' => 'Last'
      };
    }
  }

  public class OpportunityDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Name' => 'Test Opportunity',
        'StageName' => 'Closed - Paid',
        'CloseDate' => System.today(),
        'Category_Picklist__c' => 'School',
        'Collection_Picklist__c' => 'Uniform Style',
        'Anticipated_Quantity__c' => 1
      };
    }
  }

  public class CaseDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Subject' => 'Test Case'
      };
    }
  }

  public class UserDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Alias' => 'mwlf',
        'CommunityNickname' => 'wxpq',
        'Email' => 'pwodidkw@ncmsjeu.com.testfake',
        'EmailEncodingKey' => 'UTF-8',
        'LanguageLocaleKey' => 'en_US',
        'LastName' => 'Doe',
        'LocaleSidKey' => 'en_US',
        'TimeZoneSidKey' => 'America/Chicago',
        'Username' => 'oelcjsue@ggklekd.com.testfake'
      };
    }
  }

  public class FeedItemDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Body' => 'a good body',
        'Title' => 'the title',
        'Type' => 'TextPost'
      };
    }
  }

  public class Product2Defaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Name' => 'a test product',
        'List_Price__c' => 100,
        'Quantity_Allocated__c' => 0,
        'Quantity_On_Hand__c' => 0
      };
    }
  }

  public class Custom_ItemDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Name' => 'an item',
        'Product_Style__c' => 'Uniform'
      };
    }
  }

  public class Inventory_TransactionDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Quantity__c' => 1,
        'Quantity_On_Hand_Adjustment__c' => 1
      };
    }
  }

  public class Inventory_AdjustmentDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Quantity_On_Hand_Adjustment__c' => 1,
        'Quantity_Allocated_Adjustment__c' => 1
      };
    }
  }

  public class Standardized_ItemDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Quantity__c' => 1,
        'Stated_Quantity__c' => 1
      };
    }
  }

  public class Fit_Kit_RequestDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Scheduled_Fitting_Date__c' => Date.today().addDays(7),
        'Status__c' => 'Requested'
      };
    }
  }

  public class Fit_Kit_Request_ProductDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
          'Status__c' => 'Reserved'
      };
    }
  }

  public class Fit_Kit_Request_BagDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
          'Bag_Number' => '0987'
      };
    }
  }

  public class FitKitSettingsDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Shipping_time_in_days__c' => 4,
        'Max_days_into_future__c' => 90,
        'Opportunity_Field_id__c' => 'SomeFieldId'
      };
    }
  }

  public class DepositDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Status__c' => 'Pending'
      };
    }
  }

  public class DesignRoundDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
        'Version__c' => '1'
      };
    }
  }

  public class Design_ItemDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
      };
    }
  }

  public class DesignDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      return new Map<String, Object> {
      };
    }
  }


}