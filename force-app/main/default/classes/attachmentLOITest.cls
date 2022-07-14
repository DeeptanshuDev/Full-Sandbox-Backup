@isTest
public class attachmentLOITest {

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
        attachmentLOI testLOI = new attachmentLOI(sc);
        
        PageReference pageRef = Page.NewCustomerPurchaseOrder;
        pageRef.getParameters().put('id', String.valueOf(newAccount.Id));
        Test.setCurrentPage(pageRef);
        
        //Testing attachmentLOI functionalities
        Attachment testAttach = new Attachment();
        testAttach.Name = 'Test LOI';
        Blob bodyBlob = Blob.valueOf('Test Attachment Body');
        testAttach.body=bodyBlob;

        testLOI.saveLOI();
        testLOI.getMyLOI();
        testLOI.myLOI.Account__c = newAccount.Id;
        testLOI.getunSelectedValues();
        testLOI.getSelectedValues();
        testLOI.selectClick();
        testLOI.unselectClick();
        testLOI.loadSOOption();
        testLOI.leftSelected.add(newSO.Name);
        testLOI.selectClick();
        testLOI.getMyFile();
        testLOI.myFile = testAttach;
        testLOI.saveLOI();
                
        Test.StopTest();
        
    }
    
}