public class AccountRepo {

  public Account findById(Id accountId) {

    return [
      SELECT Account_Number__c
        , Account_Rating_Image__c
        , Account_Status__c
        , AccountNumber
        , AccountSource
        , BillingStreet
        , BillingCity
        , BillingState
        , billingPostalCode
        , BillingGeocodeAccuracy
        , Bulk_Shipping_Country__c
        , Case_Safe_ID__c
        , Copy_Physical_Address_to_All_Address__c
        , CreatedById
        , CreatedDate
        , Description
        , Fax
        , Id
        , Industry
        , IsDeleted
        , JigsawCompanyId
        , LastActivityDate
        , LastModifiedById
        , LastModifiedDate
        , MasterRecordId
        , Name
        , NumberOfEmployees
        , OwnerId
        , ParentId
        , Phone
        , PhotoUrl
        , Physical_Address_Description__c
        , Primary_Shipping_Address_Description__c
        , Primary_Shipping_City__c
        , Primary_Shipping_State__c
        , Primary_Shipping_Street__c
        , Primary_Shipping_Zip__c
        , Proto_Shipping_Country__c
        , Rating
        , Region__c
        , RLR__c
        , Secondary_Shipping_Address__c
        , Secondary_Shipping_Address_Description__c
        , Secondary_Shipping_City__c
        , Secondary_Shipping_State__c
        , Secondary_Shipping_Zip__c
        , ShippingStreet                 
        , ShippingCity
        , ShippingState
        , ShippingPostalCode
        , ShippingGeocodeAccuracy
        , Site
        , Special_Shipping_Address_Description__c
        , Special_Shipping_City__c
        , Special_Shipping_Country__c
        , Special_Shipping_State__c
        , Special_Shipping_Street__c
        , Special_Shipping_Zip_Code__c
        , SystemModstamp
        , Total_Open_Opportunity_Value__c
        , Total_Won_Business__c
        , Type
        , Website
        , Owner.Street
        , Owner.City
        , Owner.State
        , Owner.PostalCode
        , (
          SELECT Account__c
            , Amount__c
            , CreatedById
            , CreatedDate
            , Date_Payment_Received__c
            , Id
            , IsDeleted
            , Keep_Deposit_on_File__c
            , LastModifiedById
            , LastModifiedDate
            , Name
            , Payment_Type__c
            , Status__c
          FROM Deposits__r
        )
      FROM Account
      WHERE Id = :accountId
    ];
  }
}