@isTest
public class OppChildRelatedListCtrl_T {
    
    @TestSetup
    private static void setup() {
        Account acc = TestData.account(true);
        Opportunity opp = TestData.opportunity(new Opportunity(AccountId = acc.Id),true);
        SCMC__Currency_Master__c cm = new SCMC__Currency_Master__c(SCMC__Active__c = true, SCMC__Corporate_Currency__c = true, SCMC__Number_of_decimals__c = 2);
        insert cm;
        SCMC__Sales_Order__c so = new SCMC__Sales_Order__c(SCMC__Sales_Order_Date__c = Date.today(), Opportunity__c = opp.Id, SCMC__Currency__c = cm.Id, SCMC__Customer_Account__c = acc.Id);
        insert so;
        SCMC__Shipping__c sp = new SCMC__Shipping__c(SCMC__Sales_Order__c = so.Id);
        insert sp;
        SCMC__Picklist__c pl = new SCMC__Picklist__c(SCMC__Sales_Order__c = so.Id);
        insert pl;
        SCMC__Pick_list_Detail__c pld = new SCMC__Pick_list_Detail__c(SCMC__Picklist__c = pl.Id);
        insert pld;
    }
    
    @isTest
    private static void getChildRecordsList() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
       /* ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        OppChildRelatedListCtrl oppChildRelatedList = new OppChildRelatedListCtrl(sc);*/
        Test.stopTest();
    }
}