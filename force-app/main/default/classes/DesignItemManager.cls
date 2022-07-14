public class DesignItemManager {

  private static final Map<String, Decimal> SHIPPING_RATE_BY_PRODUCT_STYLE =
      new Map<String, Decimal> {
    'Warmup' => .06,
    'Practicewear' => .06,
    'Noveltywear' => .06,
    'Custom Bow' => .06,
    'Uniform' => .03,
    'Logo/Add-on' => .06
  };

  public void beforeInsert(List<Design_Item__c> items) {
    setDiscount(items);
    setPricesFromStandardItems(items);
    setShippingPrice(items);
  }

  public void beforeUpdate(List<Design_Item__c> items) {
    setDiscount(items);
    setShippingPrice(items);
  }

  public void afterInsert(List<Design_Item__c> items) {
    setCustomItemPricing(items);
    new CustomItemStatus().setCustomItemStatusFromNewDesignItems(items);
  }

  public void afterUpdate(List<Design_Item__c> items) {
    setCustomItemPricing(items);
  }

  private void setShippingPrice(List<Design_Item__c> items) {
    Set<Id> customItemIds = new Set<Id>();
    for (Design_Item__c i : items) {
      if (i.Custom_Item__c != null) {
        customItemIds.add(i.Custom_Item__c);
      }
    }

    Map<Id, Custom_Item__c> customItemMap = new Map<Id, Custom_Item__c>(
      CustomItemDAO.getCustomItemWithProductStyleAndName(customItemIds));

    for (Design_Item__c di : items) {
      if (di.Free_Shipping__c) {
        di.Shipping_per_Item__c = 0;
        continue;
      }
      if (di.Standardized_Item__c != null && !di.International_Pricing__c && di.Price__c != null) {
        di.Shipping_per_Item__c = di.Price__c * Constants.STANDARDIZED_ITEM_SHIPPING_RATE;
        di.Shipping_Rate__c = Constants.STANDARDIZED_ITEM_SHIPPING_RATE*100;
      }
      else if (di.Custom_Item__c != null && !di.International_Pricing__c) {
        Custom_Item__c customItem = customItemMap.get(di.Custom_Item__c);
        if (customItem.Product_Style__c == null) {
          throw new ApplicationException('Unable to set shipping price due to blank Product Style'
            + ' for Custom Item: ' + di.Custom_Item__c + ', ' + di.Custom_Item__r.Name);
        }
        Double shippingBasis = null;
        if (di.Type_of_Discount__c == Constants.DISCOUNT_TYPE_EARLY_BIRD) {
          	//shippingBasis = di.Early_Bird_Price__c;
        	shippingBasis = di.Wholesale_Price__c;
        }
        else {
          shippingBasis = di.Wholesale_Price__c;
        }
        Double shippingRate = SHIPPING_RATE_BY_PRODUCT_STYLE.get(customItem.Product_Style__c);
        if (shippingRate == null) {
          throw new ApplicationException('Unable to set shipping price due to unsupported'
            + ' product style: \'' + customItem.Product_Style__c + '\' for Custom Item: '
            + customItem.Id + ' ' + customItem.Name);
        }
        if (shippingBasis != null) {
          di.Shipping_per_Item__c =
            shippingBasis * SHIPPING_RATE_BY_PRODUCT_STYLE.get(customItem.Product_Style__c);
          di.Shipping_Rate__c = shippingRate*100;
        }
      }
    }
  }

  private void setCustomItemPricing(List<Design_Item__c> items) {
    Set<Id> designRequestIds = new Set<Id>();
    items = DesignItemDAO.getDesignItemsById(items);
    for (Design_Item__c di : items) {
      designRequestIds.add(di.Design__r.Design_Request__c);
    }
    new DesignRequestManager().setCustomItemPricing(designRequestIds);
  }

  private void setDiscount(List<Design_Item__c> items) {
    for (Design_Item__c i : items) {
      if (i.MSRP__c != null) {
        i.Discount_Amount__c = i.MSRP__c - (i.Price__c != null ? i.Price__c : 0);
      }
      else {
        i.Discount_Amount__c = 0;
      }
    }    
  }

  private void setPricesFromStandardItems(List<Design_Item__c> items) {
    List<Id> standardizedItemIds = new List<Id>();
    for (Design_Item__c di : items) {
      if (di.Standardized_Item__c != null) {
        standardizedItemIds.add(di.Standardized_Item__c);
      }
    }
    if (standardizedItemIds.isEmpty()) {
      return;
    }

    Map<Id, Standardized_Item__c> standardizedItemMap =
      new Map<Id, Standardized_Item__c>(StandardizedItemDAO.getStandardizedItemByTotalPrice(standardizedItemIds));

    for (Design_Item__c di : items) {
      if (di.Standardized_Item__c != null) {
        di.Price__c = standardizedItemMap.get(di.Standardized_Item__c).Total_Price_per_Item__c;
      }
    }
    // No update, called from before context
  }
    
    /**
    *
    * @description : This method is being used for updating value in category, collection and pri=oduct style in CI id DI is approved.
    *
    * @args : List<Custom_Item__c> items, Map<Id, Custom_Item__c> oldItems
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 05/09/2021 - Deeptanshu Bharti
    *
    **/ 
    public void updateCIbasedOnDI(List<Design_Item__c> items, Map<Id, Design_Item__c> oldMap)
    {
        Map<Id, Map<String,String>> mapOfvalues = new Map<Id, Map<String,String>>();
        Map<String,String> mapOfString = new Map<String,String>();
        Map<Id,String> categoryMap = new Map<Id,String>();
        Map<Id,String> collectionMap = new Map<Id,String>();
        List<Custom_Item__c> listOfCi = new List<Custom_Item__c>();
        if(items.size()>0)
        {
            for(Design_Item__c obj : items)
            {
                System.debug('the approved field value is : '+obj.Approved__c);
                if(obj.Approved__c == True)
                {
                        System.debug('you Di has been approved now');
                        System.debug('the category is  : ' + obj.DI_categotry__c);
                        System.debug('the collection value is  : ' + obj.DI_Collection__c);
                        mapOfString.put(obj.DI_categotry__c,obj.DI_Collection__c);
                        mapOfvalues.put(obj.Custom_Item__c,mapOfString);
                        categoryMap.put(obj.Custom_Item__c,obj.DI_categotry__c);
                        collectionMap.put(obj.Custom_Item__c,obj.DI_Collection__c);
                }
            }
        }
        
        if(!mapOfvalues.isEmpty())
        {
            for(Custom_Item__c ci : [SELECT Id, Name, Category__c,Collection__c,Product_Style__c FROM Custom_Item__c WHERE Id IN:mapOfvalues.keySet()])
            {
                Custom_Item__c cuIt = new Custom_Item__c();
                cuIt.Id = ci.Id;
                cuIt.Category__c = categoryMap.get(ci.Id);
                cuIt.Collection__c = collectionMap.get(ci.Id);
                listOfCi.add(cuIt);
            }
        }
        if(!listOfCi.isEmpty())
        {
            update listOfCi;
            System.debug('updated : ' + listOfCi);
        }
    }

}