@isTest
public class TestData {

  public static Account account(Account acc, Boolean doInsert) {
    return (Account) TestFactory.createSObject(acc, doInsert);
  }

  public static Account account(Account acc) {
    return account(acc, false);
  }

  public static Account account(Boolean doInsert) {
    return account(new Account(), doInsert);
  }

  public static Account account() {
    return account(new Account(), false);
  }

   
     public static Contract contract(Contract con, Boolean doInsert) {
    return (Contract) TestFactory.createSObject(con, doInsert);
  }

  public static Contract contract(Contract con) {
    return contract(con, false);
  }

  public static Contract contract(Boolean doInsert) {
    return contract(new Contract(), doInsert);
  }

  public static Contract contract() {
    return contract(new Contract(), false);
  }
    
  public static Contact contact(Contact con, Boolean doInsert) {
    return (Contact) TestFactory.createSObject(con, doInsert);
  }

  public static Contact contact(Contact con) {
    return contact(con, false);
  }

  public static Contact contact(Boolean doInsert) {
    return contact(new Contact(), doInsert);
  }

  public static Contact contact() {
    return contact(new Contact(), false);
  }

  public static Custom_Item__c customItem(Custom_Item__c i, Boolean doInsert) {
    return (Custom_Item__c) TestFactory.createSObject(i, doInsert);
  }

  public static Custom_Item__c customItem(Custom_Item__c i) {
    return customItem(i, false);
  }

  public static Custom_Item__c customItem(Boolean doInsert) {
    return customItem(new Custom_Item__c(), doInsert);
  }

  public static Custom_Item__c customItem() {
    return customItem(new Custom_Item__c(), false);
  }

  public static User user(User user1, Boolean doInsert) {
    return (User) TestFactory.createSObject(user1, doInsert);
  }

  public static User user(User user1) {
    return user(user1, false);
  }

  public static User user(Boolean doInsert) {
    return user(new User(), doInsert);
  }

  public static User user() {
    return user(new User(), false);
  }

  public static Opportunity opportunity(Opportunity opp, Boolean doInsert) {
    return (Opportunity) TestFactory.createSObject(opp, doInsert);
  }

  public static Opportunity opportunity(Opportunity opp) {
    return opportunity(opp, false);
  }

  public static Opportunity opportunity(Boolean doInsert) {
    return opportunity(new Opportunity(), doInsert);
  }

  public static Opportunity opportunity() {
    return opportunity(new Opportunity(), false);
  }

  public static Product2 product(Product2 p, Boolean doInsert) {
    return (Product2) TestFactory.createSObject(p, doInsert);
  }

  public static Product2 product(Boolean doInsert) {
    return product(new Product2(), doInsert);
  }

  public static Product2 product(Product2 p) {
    return product(p, false);
  }

  public static Product2 product() {
    return product(new Product2(), false);
  }

  public static Inventory_Transaction__c inventoryTransaction(Inventory_Transaction__c trx,
    Boolean doInsert) {
    return (Inventory_Transaction__c) TestFactory.createSObject(trx, doInsert);
  }

  public static Inventory_Transaction__c inventoryTransaction(Inventory_Transaction__c trx) {
    return inventoryTransaction(trx, false);
  }

  public static Inventory_Transaction__c inventoryTransaction(Boolean doInsert) {
    return inventoryTransaction(new Inventory_Transaction__c(), doInsert);
  }

  public static Inventory_Transaction__c inventoryTransaction() {
    return inventoryTransaction(new Inventory_Transaction__c(), false);
  }

  public static Inventory_Adjustment__c inventoryAdjustment(Inventory_Adjustment__c adj,
    Boolean doInsert) {
    return (Inventory_Adjustment__c) TestFactory.createSObject(adj, doInsert);
  }

  public static Inventory_Adjustment__c inventoryAdjustment(Inventory_Adjustment__c adj) {
    return inventoryAdjustment(adj, false);
  }

  public static Inventory_Adjustment__c inventoryAdjustment(Boolean doInsert) {
    return inventoryAdjustment(new Inventory_Adjustment__c(), doInsert);
  }

  public static Inventory_Adjustment__c inventoryAdjustment() {
    return inventoryAdjustment(new Inventory_Adjustment__c(), false);
  }

  public static Standardized_Item__c standardizedItem(Standardized_Item__c item,
    Boolean doInsert) {
    return (Standardized_Item__c) TestFactory.createSObject(item, doInsert);
  }

  public static Standardized_Item__c standardizedItem(Standardized_Item__c item) {
    return standardizedItem(item, false);
  }

  public static Standardized_Item__c standardizedItem(Boolean doInsert) {
    return standardizedItem(new Standardized_Item__c(), doInsert);
  }

  public static Standardized_Item__c standardizedItem() {
    return standardizedItem(new Standardized_Item__c(), false);
  }

  public static Fit_Kit_Request__c fitKitRequest(Fit_Kit_Request__c request,
      Boolean doInsert) {
    return (Fit_Kit_Request__c) TestFactory.createSObject(request, doInsert);
  }

  public static Fit_Kit_Request__c fitKitRequest(Fit_Kit_Request__c request) {
    return fitKitRequest(request, false);
  }

  public static Fit_Kit_Request__c fitKitRequest(Boolean doInsert) {
    return fitKitRequest(new Fit_Kit_Request__c(), doInsert);
  }

  public static Fit_Kit_Request__c fitKitRequest() {
    return fitKitRequest(new Fit_Kit_Request__c(), false);
  }

  public static Fit_Kit_Request_Product__c fitKitRequestProduct(Fit_Kit_Request_Product__c product,
      Boolean doInsert) {
    return (Fit_Kit_Request_Product__c) TestFactory.createSObject(product, doInsert);
  }

  public static Fit_Kit_Request_Product__c fitKitRequestProduct(Fit_Kit_Request_Product__c product) {
    return fitKitRequestProduct(product, false);
  }

  public static Fit_Kit_Request_Product__c fitKitRequestProduct(Boolean doInsert) {
    return fitKitRequestProduct(new Fit_Kit_Request_Product__c(), doInsert);
  }

  public static Fit_Kit_Request_Product__c fitKitRequestProduct() {
    return fitKitRequestProduct(new Fit_Kit_Request_Product__c(), false);
  }

  public static Fit_Kit_Bag__c fitKitBag(Fit_Kit_Bag__c bag,
      Boolean doInsert) {
    return (Fit_Kit_Bag__c) TestFactory.createSObject(bag, doInsert);
  }

  public static Fit_Kit_Bag__c fitKitBag(Fit_Kit_Bag__c bag) {
    return fitKitBag(bag, false);
  }

  public static Fit_Kit_Bag__c fitKitBag(Boolean doInsert) {
    return fitKitBag(new Fit_Kit_Bag__c(), doInsert);
  }

  public static Fit_Kit_Bag__c fitKitBag() {
    return fitKitBag(new Fit_Kit_Bag__c(), false);
  }

  public static FitKitSettings__c fitKitSettings(FitKitSettings__c settings,
    Boolean doInsert) {
    return (FitKitSettings__c) TestFactory.createSObject(settings, doInsert);
  }

  public static FitKitSettings__c fitKitSettings(FitKitSettings__c settings) {
    return fitKitSettings(settings, false);
  }

  public static FitKitSettings__c fitKitSettings(Boolean doInsert) {
    return fitKitSettings(new FitKitSettings__c(), doInsert);
  }

  public static FitKitSettings__c fitKitSettings() {
    return fitKitSettings(new FitKitSettings__c(), false);
  }

  public static Design_Request__c designRequest(Design_Request__c designRequest,
    Boolean doInsert) {
    return (Design_Request__c) TestFactory.createSObject(designRequest, doInsert);
  }

  public static Design_Request__c designRequest(Design_Request__c designRequest) {
    return designRequest(designRequest, false);
  }

  public static Design_Request__c designRequest(Boolean doInsert) {
    return designRequest(new Design_Request__c(), doInsert);
  }

  public static Design_Request__c designRequest() {
    return designRequest(new Design_Request__c(), false);
  }

  public static Custom_Item_Fit_Attribute__c customItemFitAttribute(
    Custom_Item_Fit_Attribute__c attribute, Boolean doInsert) {
    return (Custom_Item_Fit_Attribute__c) TestFactory.createSObject(attribute, doInsert);
  }

  public static Custom_Item_Fit_Attribute__c customItemFitAttribute(
      Custom_Item_Fit_Attribute__c attribute) {
    return customItemFitAttribute(attribute, false);
  }

  public static Custom_Item_Fit_Attribute__c customItemFitAttribute(Boolean doInsert) {
    return customItemFitAttribute(new Custom_Item_Fit_Attribute__c(), doInsert);
  }

  public static Custom_Item_Fit_Attribute__c customItemFitAttribute() {
    return customItemFitAttribute(new Custom_Item_Fit_Attribute__c(), false);
  }

  public static Deposit__c deposit(
    Deposit__c deposit, Boolean doInsert) {
    return (Deposit__c) TestFactory.createSObject(deposit, doInsert);
  }

  public static Deposit__c deposit(
    Deposit__c deposit) {
    return deposit(deposit, false);
  }

  public static Deposit__c deposit(Boolean doInsert) {
    return deposit(new Deposit__c(), doInsert);
  }

  public static Deposit__c deposit() {
    return deposit(new Deposit__c(), false);
  }

  public static Design__c design(
    Design__c design, Boolean doInsert) {
    return (Design__c) TestFactory.createSObject(design, doInsert);
  }

  public static Design__c design(
    Design__c design) {
    return design(design, false);
  }

  public static Design__c design(Boolean doInsert) {
    return design(new Design__c(), doInsert);
  }

  public static Design__c design() {
    return design(new Design__c(), false);
  }

  public static Design_Round__c designRound(
    Design_Round__c designRound, Boolean doInsert) {
    return (Design_Round__c) TestFactory.createSObject(designRound, doInsert);
  }

  public static Design_Round__c designRound(
    Design_Round__c designRound) {
    return designRound(designRound, false);
  }

  public static Design_Round__c designRound(Boolean doInsert) {
    return designRound(new Design_Round__c(), doInsert);
  }

  public static Design_Round__c designRound() {
    return designRound(new Design_Round__c(), false);
  }
    
   
  public static eSignature_Status__c eSignatureStatus(
    eSignature_Status__c eSignatureStatus, Boolean doInsert) {
    return (eSignature_Status__c) TestFactory.createSObject(eSignatureStatus, doInsert);
  }

  public static eSignature_Status__c eSignatureStatus(
    eSignature_Status__c eSignatureStatus) {
    return eSignatureStatus(eSignatureStatus, false);
  }

  public static eSignature_Status__c eSignatureStatus(Boolean doInsert) {
    return eSignatureStatus(new eSignature_Status__c(), doInsert);
  }

  public static eSignature_Status__c eSignatureStatus() {
    return eSignatureStatus(new eSignature_Status__c(), false);
  }
    
    public static eSignature_Recipient__c  eSignatureRecipient(
    eSignature_Recipient__c  eSignatureRecipient, Boolean doInsert) {
    return (eSignature_Recipient__c ) TestFactory.createSObject(eSignatureRecipient, doInsert);
  }

  public static eSignature_Recipient__c  eSignatureRecipient(
    eSignature_Recipient__c  eSignatureRecipient) {
    return eSignatureRecipient(eSignatureRecipient, false);
  }

  public static eSignature_Recipient__c  eSignatureRecipient(Boolean doInsert) {
    return eSignatureRecipient(new eSignature_Recipient__c (), doInsert);
  }

  public static eSignature_Recipient__c  eSignatureRecipient() {
    return eSignatureRecipient(new eSignature_Recipient__c (), false);
  }
   
  public static Design_Item__c designItem(
    Design_Item__c designItem, Boolean doInsert) {
    return (Design_Item__c) TestFactory.createSObject(designItem, doInsert);
  }

  public static Design_Item__c designItem(
    Design_Item__c designItem) {
    return designItem(designItem, false);
  }

  public static Design_Item__c designItem(Boolean doInsert) {
    return designItem(new Design_Item__c(), doInsert);
  }

  public static Design_Item__c designItem() {
    return designItem(new Design_Item__c(), false);
  }
  public static Project__c project(Project__c projt, Boolean doInsert) {
    return (Project__c) TestFactory.createSObject(projt, doInsert);
  }

  public static Project__c project(Project__c projt) {
    return project(projt, false);
  }

  public static Project__c project(Boolean doInsert) {
    return project(new Project__c(), doInsert);
  }

  public static Project__c project() {
    return project(new Project__c(), false);
  }
  
  public static Release__c release(Release__c release, Boolean doInsert) {
    return (Release__c) TestFactory.createSObject(release, doInsert);
  }

  public static Release__c release(Release__c release) {
    return release(release, false);
  }

  public static Release__c release(Boolean doInsert) {
    return release(new Release__c(), doInsert);
  }

  public static Release__c release() {
    return release(new Release__c(), false);
  }
  
  public static Change_Request__c changeRequest(Change_Request__c cR, Boolean doInsert) {
    return (Change_Request__c) TestFactory.createSObject(cR, doInsert);
  }

  public static Change_Request__c changeRequest(Change_Request__c cR) {
    return changeRequest(cR, false);
  }

  public static Change_Request__c changeRequest(Boolean doInsert) {
    return changeRequest(new Change_Request__c(), doInsert);
  }

  public static Change_Request__c changeRequest() {
    return changeRequest(new Change_Request__c(), false);
  }
  public static Modification__c modification(Modification__c modifn, Boolean doInsert) {
    return (Modification__c) TestFactory.createSObject(modifn, doInsert);
  }

  public static Modification__c modification(Modification__c modifn) {
    return modification(modifn, false);
  }

  public static Modification__c modification(Boolean doInsert) {
    return modification(new Modification__c(), doInsert);
  }

  public static Modification__c modification() {
    return modification(new Modification__c(), false);
  }
  public static Migration_Configuration__c migrationConfiguration(Migration_Configuration__c migrtnConfg, Boolean doInsert) {
    return (Migration_Configuration__c) TestFactory.createSObject(migrtnConfg, doInsert);
  }

  public static Migration_Configuration__c migrationConfiguration(Migration_Configuration__c migrtnConfg) {
    return migrationConfiguration(migrtnConfg, false);
  }

  public static Migration_Configuration__c migrationConfiguration(Boolean doInsert) {
    return migrationConfiguration(new Migration_Configuration__c(), doInsert);
  }

  public static Migration_Configuration__c migrationConfiguration() {
    return migrationConfiguration(new Migration_Configuration__c(), false);
  }      
}