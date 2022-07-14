/** 
* 
* Description : Test class for triggerAttachment.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 03/31/2022
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/
 
@isTest (seeAllData = false)
public class triggerAttachment_TestClass {
    /**
    *
    * @description : method to insert attachment in opportunity.
    *
    * @args : 
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 03/31/2022 - Deeptanshu Bharti
    * coverage : 
    * 
    **/
 
    static testMethod void insertNewAttachment()
    {
        Account acc = new Account();
        acc.Name = 'Testing account';
        acc.Type = 'All Star';
        acc.Phone = '123456';
        acc.Subtype__c = 'Dance';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Contact testing';
        con.Account = acc;
        con.Preferred_Phone__c = 'Phone';
        con.Email = 'testing@gmail.com';
        insert con;
        
        
        Opportunity opp = new Opportunity();
        
        opp.Name = 'Test Opportunity';
        opp.Type = 'New Order';
        opp.Account = acc;
        opp.Primary_Contact__c = con.Id;
        opp.Category_Picklist__c = 'All Star';
        opp.Collection_Picklist__c = 'N/A';
        opp.Uniform_Style__c = 'Accessory-Bow';
        opp.Prototype_Status__c = 'Proto';
        opp.Event_Date_Old__c = system.today();
        opp.StageName = 'Open';
        opp.CloseDate = system.today();
        insert opp;
        
        
        
        Attachment attach=new Attachment();       
        attach.Name='SIN080842';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = opp.id;
        
        
        
        Test.startTest();
        insert attach;
        Test.stopTest();
    }

}