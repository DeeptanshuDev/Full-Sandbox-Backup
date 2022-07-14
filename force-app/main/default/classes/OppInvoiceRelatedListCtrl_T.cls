@isTest
public class OppInvoiceRelatedListCtrl_T {

    @TestSetup
    private static void setup() {
        Account acc = TestData.account(true);
        Opportunity opp = TestData.opportunity(new Opportunity(AccountId = acc.Id),true);
       /* SCMC__Currency_Master__c cm = new SCMC__Currency_Master__c(SCMC__Active__c = true, SCMC__Corporate_Currency__c = true, SCMC__Number_of_decimals__c = 2);
        insert cm;
        SCMC__Sales_Order__c so = new SCMC__Sales_Order__c(SCMC__Sales_Order_Date__c = Date.today(), Opportunity__c = opp.Id, SCMC__Currency__c = cm.Id, SCMC__Customer_Account__c = acc.Id);
        insert so;
        c2g__codaInvoice__c soin = new c2g__codaInvoice__c(Sales_Order__c = so.Id);
        insert soin;
        SCMC__Invoicing__c inv = new SCMC__Invoicing__c(SCMC__Sales_Order__c = so.Id);
        insert inv;*/
    }
    
    @isTest
    private static void  getChildRecordList() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        OppInvoiceRelatedListCtrl OppInvoiceRelatedList = new OppInvoiceRelatedListCtrl(sc);
        Test.stopTest();

    }
}