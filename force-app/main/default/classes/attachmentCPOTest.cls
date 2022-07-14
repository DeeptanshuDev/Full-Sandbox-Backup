@isTest
public class attachmentCPOTest {

    static testMethod void test(){
        SCMC__Currency_Master__c cm = new SCMC__Currency_Master__c(Name='USD',SCMC__Active__c=true,SCMC__Corporate_Currency__c=true);
        insert cm;
        Account newAccount = new Account(Name='TestAcc',SCMC__Currency__c=cm.id);
        insert newAccount;
        Contact newContact = new Contact(FirstName='Bill',LastName='Bob',AccountId = newAccount.Id);
        insert newContact;
        
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE Name = 'Drop Ship Item' and SObjectType='SCMC__Sales_Order__c'];
        SCMC__Sales_Order__c newSO = new SCMC__Sales_Order__c(SCMC__Customer_Account__c=newAccount.Id,SCMC__Sales_Order_Date__c=system.today(),SCMC__Primary_Sales_Rep__c='00515000007GsKB',RecordTypeId=rt.Id);
        insert newSO;
        SCMC__Sales_Order_Line_Item__c newSOLI = new SCMC__Sales_Order_Line_Item__c(SCMC__Sales_Order__c=newSO.Id,SCMC__Item_Master__c='a8H1C000000TlId',SCMC__Quantity__c=1,Retail_Price__c=10,SCMC__Price__c=10);
        insert newSOLI;
        
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newAccount);
        attachmentCPO testCPO = new attachmentCPO(sc);
        
        PageReference pageRef = Page.NewCustomerPurchaseOrder;
        pageRef.getParameters().put('id', String.valueOf(newAccount.Id));
        Test.setCurrentPage(pageRef);
        
        //Testing attachmentCPO functionalities
        Attachment testAttach = new Attachment();
        testAttach.Name = 'Test CPO';
        Blob bodyBlob = Blob.valueOf('Test Attachment Body');
        testAttach.body=bodyBlob;

        testCPO.saveCPO();
        testCPO.getMyCPO();
        testCPO.myCPO.Account__c = newAccount.Id;
        testCPO.myCPO.PO_Number__c = '123';
        testCPO.getunSelectedValues();
        testCPO.getSelectedValues();
        testCPO.selectClick();
        testCPO.unselectClick();
        testCPO.loadSOOption();
        testCPO.leftSelected.add(newSO.Name);
        testCPO.selectClick();
        testCPO.getMyFile();
        testCPO.myFile = testAttach;
        testCPO.saveCPO();
        testCPO.displayTotals();
                
        Test.StopTest();
        
    }
    
}