public class DesignRequestManager {

  public void setCustomItemPricing(Set<Id> designRequestIds) {
    List<Design_Item__c> items = findByDesignRequestIds(designRequestIds);
    Map<Id, List<Design_Item__c>> designItemsByCustomItemId = new Map<Id, List<Design_Item__c>>();
    Integer maxVersion = 0;
    for (Design_Item__c item : items) {
      if (item.Custom_Item__c == null) {
        continue;
      }
      List<Design_Item__c> designItems = designItemsByCustomItemId.get(item.Custom_Item__c);
      if (designItems == null) {
        designItems = new List<Design_Item__c>();
        designItemsByCustomItemId.put(item.Custom_Item__c, designItems);
      }
      designItems.add(item);
      if (item.Design__r.Design_Round__r.Version__c != null
        && Integer.valueOf(item.Design__r.Design_Round__r.Version__c) > maxVersion) {
        maxVersion = Integer.valueOf(item.Design__r.Design_Round__r.Version__c);
      }
    }
    List<Custom_Item__c> customItemsToSave = new List<Custom_Item__c>();
    for (Id customItemId : designItemsByCustomItemId.keySet()) {
      List<Design_Item__c> designItems = designItemsByCustomItemId.get(customItemId);
      Double price = 0;
      Double wholesalePrice = 0;
      Integer highestVersion = 0;
      Double shipping = 0;
      Double shippingRate = 0;
      Boolean priceChanged = false;
      for (Design_Item__c di : designItems) {
        if (di.Design__r.Design_Round__r.Version__c == null) {
          continue;
        }
        Integer currentVersion = Integer.valueOf(di.Design__r.Design_Round__r.Version__c);
        if ((currentVersion > highestVersion
          || (currentVersion == highestVersion && di.Price__c < price))
          && di.Price__c != null) {
          highestVersion = currentVersion;
          price = di.Price__c;
          wholesalePrice = di.Wholesale_Price__c;
          shipping = di.Shipping_per_Item__c;
          shippingRate = di.Shipping_Rate__c;
          priceChanged = true;
        }
        if (di.Design__r.Approved_Art__c) {
          price = di.Price__c ;
          wholesalePrice = di.Wholesale_Price__c;
          shipping = di.Shipping_per_Item__c;
          shippingRate = di.Shipping_Rate__c;
          priceChanged = true;
          break;
        }
      }
      if (priceChanged) {
        customItemsToSave.add(new Custom_Item__c(
          Id = customItemId,
          Price__c = price,
          Price_per_item__c = wholesalePrice,
          Shipping__c = shipping,
          Shipping_Rate__c = shippingRate
        ));
      }
    }
    if (customItemsToSave.size() > 0) {
        Util.BypassAllTriggers = true;
      update customItemsToSave;
        Util.BypassAllTriggers = false;
    }
  }

  private List<Design_Item__c> findByDesignRequestIds(Set<Id> designRequestIds) {
      return [
      SELECT Id, Design__c , Price__c, Design__r.Design_Round__r.Version__c, Design__r.Design_Request__c,
        Design__r.Approved_Art__c, Design__r.Design_Round__c, Wholesale_Price__c,
        Custom_Item__c, Custom_Item__r.Price_per_item__c, Standardized_Item__c, Custom_Item__r.Price__c,
      Shipping_per_Item__c, Custom_Item__r.Shipping__c, Shipping_Rate__c
      FROM Design_Item__c
        WHERE Design__r.Design_Request__c IN :designRequestIds
        ];
    }
  }