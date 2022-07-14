/**
*	Description   	:   Test class to perform the testing of SoSummary vf page.
* 
*  	Version			:   v1.0 - Created - CR - 000000120 - Chirag Soni 
*
*   Date            :   04/12/2020
**/ 

@isTest(seeAlldata = false)
private class SoSummaryCtrl_T {
    
    
    @testSetup static void setup(){
        SCMC__Currency_Master__c cm = new SCMC__Currency_Master__c();
        cm.Name = 'USD';
        cm.SCMC__Active__c = true;
        cm.SCMC__Corporate_Currency__c = true;
        insert cm;
        SCMC__Currency_Master__c c = [SELECT Id FROM SCMC__Currency_Master__c WHERE Name = 'USD' LIMIT 1];
        
        Account  acc = new Account();
        acc.Name = 'ACME';
        acc.SCMC__Active__c = true;
        acc.SCMC__Customer__c = true;
        acc.SCMC__Currency__c = c.Id;
        acc.SCMC__Corp_Line1__c = 'One Infinity Loop';
        acc.SCMC__Corp_City__c = 'Cupertino';
        acc.SCMC__Corp_PostalCode__c = '12345';
        insert acc;
        Account a = [SELECT Id FROM Account WHERE Name = 'ACME' LIMIT 1];
        
        List<SCMC__Sales_Order__c> sOrder = new List<SCMC__Sales_Order__c>();
        Id salesOrderRecordType = Schema.SObjectType.SCMC__Sales_Order__c.getRecordTypeInfosByName().get('Inventory').getRecordTypeId();// GetRecord Type id of Sales order      
        
        for(Integer i=0;i<4;i++)
        {
            sOrder.add(new SCMC__Sales_Order__c(SCMC__Customer_Account__c = a.Id, 
                                                SCMC__Sales_Order_Date__c = Date.today()+i,SCMC__Customer_Purchase_Order__c  ='12345'));
            sOrder[i].RecordtypeId = salesOrderRecordType;
        }
        insert sOrder;
    }
    
    @isTest
    private static void saveSoSummary()
    {
        Test.startTest();
        Account a = [SELECT Id FROM Account WHERE Name = 'ACME' LIMIT 1];
        
        SoSummaryCtrl ctrl = new SoSummaryCtrl(new ApexPages.StandardController(a));
        ctrl.salesOrderList[0].Selected = true;
         ctrl.salesOrderList[1].Selected = false;
        ctrl.salesOrderList[2].Selected = true;
         ctrl.salesOrderList[3].Selected = false;
        PageReference pr = ctrl.saveSoSummary();
       System.assert(pr != null, 'Expected a page reference');
        Test.stopTest();
    }    
    
}