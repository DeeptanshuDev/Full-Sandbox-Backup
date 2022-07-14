@isTest(seealldata = false)
public class DocusignStatusTriggerHandler_T {
    
    @isTest
    static void test_unitTest() {

         List<Account> accounts = new List<Account>();
        
        List<Contact> contacts = new List<Contact>();

        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, Type = 'Pro', Phone = '9685741452'));
        }
        insert accounts;
        
        for (Integer i=0;i<10;i++) {
            contacts.add(new Contact(LastName = 'Test'));
        }
        insert contacts;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', Type = 'Reorder',Event_Date_Old__c = System.today(),StageName = 'Open',
                                          AccountId = accounts[0].id, Collection_Picklist__c ='Poly' , Category_Picklist__c = 'Pro', 
                                          Uniform_Style__c = 'Top', Primary_Contact__c = contacts[0].Id, CloseDate = System.today());
        
        insert opp;  
        Design_Request__c request = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
                                                           true);
        
        Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id,
            Design_Request__c = request.Id
        ), true);
        
        Design_Round__c round = TestData.designRound(new Design_Round__c(
            Design_Request__c = request.Id,
            Version__c = '1'
        ), true);
        
        dsfs__DocuSign_Status__c docSta = new dsfs__DocuSign_Status__c();
        docSta.dsfs__DocuSign_Envelope_ID__c = 'adafdfffdds';
        docSta.Design_Round__c = round.Id;
        docSta.dsfs__Subject__c = 'Rebel Art Approval Test';
        docSta.dsfs__Sender__c = 'Ayush Gupta';
        docSta.dsfs__Envelope_Status__c = 'Sent';
        insert docSta;
        
        Test.startTest();
        
        List<dsfs__DocuSign_Status__c> docs = [select id,dsfs__Envelope_Status__c from dsfs__DocuSign_Status__c];
        
        docs[0].dsfs__Envelope_Status__c = 'Declined';
        update docs;
        
        test.stopTest();
    }
}