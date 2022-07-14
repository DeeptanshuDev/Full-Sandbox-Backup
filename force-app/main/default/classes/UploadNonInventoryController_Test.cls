/** 
* 
* Description : Test class for UploadNonInventoryController.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 07/08/2022 
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/
 
@isTest (seeAllData=false)
public class UploadNonInventoryController_Test {
    
    @testsetup
    private static void newset(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Opportunity opp = TestData.opportunity(true);
        
        SCMC__Currency_Master__c cm = new SCMC__Currency_Master__c(SCMC__Active__c = true, SCMC__Corporate_Currency__c = true, SCMC__Number_of_decimals__c = 2);
        insert cm;
        SCMC__Sales_Order__c so = new SCMC__Sales_Order__c(SCMC__Sales_Order_Date__c = Date.today(), Opportunity__c = opp.Id, SCMC__Currency__c = cm.Id,Order_Type__c = 'Sponsor', SCMC__Customer_Account__c = acc.Id);
        insert so;
        
        Non_Inventory_Item__c ni = new Non_Inventory_Item__c(PackageTrackingNumber__c = '1Z84A7970243085180',ShipToCompanyorName__c='Alliance', ShipToAttention__c ='Jackie',ShipToAddress1__c='mine',ShipToAddress2__c='mine2',ShipToCountryTerritory__c='USA',ShipToPostalCode__c='12452',ShipToCityorTown__c='Test',ShipToStateProvinceCounty__c='las',ShipToTelephone__c='124521',ShipToEmailAddress__c='',ShipToResidentialIndicator__c='N',ShipmentInformationVoidIndicator__c='N',PackageWeight__c='1',SO__c=so.Id,Opportunity__c=opp.Id);
        insert ni;
    }
    /**
    *
    * @description : Test method for using Date data type and adding it in list
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 07/03/2021 - Deeptanshu Bharti
    *
    * coverage : 100
    *
    **/
    static testMethod void myFirstMethod_Test()
    {
        SCMC__Sales_Order__c so = [SELECT Id, Name FROM SCMC__Sales_Order__c LIMIT 1];
        String soName = '"'+so.Name+'"';
        String str = '[{"packageTrackingNumber":"1Z84A7970243085180","shipToCompanyorName":"Alliance Cheer Elite-HOU","shipToAttention":"Jackie Hernandez","shipToAddress1":"6606 FM 1488","shipToAddress2":"Suite 148-675","shipToCountryTerritory":"United States","shipToPostalCode":"77354","shipToCityorTown":"MAGNOLIA","shipToStateProvinceCounty":"TX","shipToTelephone":"123456","shipToEmailAddress":"","shipToResidentialIndicator":"N","shipmentInformationVoidIndicator":"N","packageWeight":"1","packageReference1":"07-Remake/Rework","packageReference2":"","so":'+soName+',"inventory":"","nonInventory":"2103111; 2103112","carrier":"FedEx"}]';
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        String oppId = opp.Id;
        Non_Inventory_Item__c ni =[SELECT Id, Name, PackageTrackingNumber__c,ShipToCompanyorName__c,ShipToAttention__c,ShipToAddress1__c,
                                   ShipToAddress2__c,ShipToCountryTerritory__c,ShipToPostalCode__c,SO__c FROM Non_Inventory_Item__c LIMIT 1];
        Test.startTest();
        UploadNonInventoryController.uploadNonInventoryData(str,oppId);
        
        Map<Id,Non_Inventory_item__c> mapOfEmail = new Map<Id,Non_Inventory_item__c>();
        mapOfEmail.put(opp.Id,ni);
        UploadNonInventoryController.sendMail(mapOfEmail);
        
 
        Test.stopTest();        
    }
}