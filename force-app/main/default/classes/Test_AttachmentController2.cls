/** 
* 
* Description : Test class for attachmentcontroller2.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 02/20/2022
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/

@isTest
public class Test_AttachmentController2 {
    /**
    *
    * @description : Test method
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 02/20/2022 - Deeptanshu Bharti
    *
    *
    **/
        static testMethod void myFirstMethod_Test(){
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
                                              Uniform_Style__c = 'Top', Primary_Contact__c = contacts[0].Id, CloseDate = System.today(),SO_De__c='');
            
            Opportunity opp3 = new Opportunity(Name = 'Test Opportunity2', Type = 'Reorder',Event_Date_Old__c = System.today(),StageName = 'Open',
                                              AccountId = accounts[0].id, Collection_Picklist__c ='Poly' , Category_Picklist__c = 'Pro', 
                                              Uniform_Style__c = 'Top', Primary_Contact__c = contacts[0].Id, CloseDate = System.today());
            
            insert opp;
            insert opp3;
            blob file=  Blob.valueOf('sample text');
            Attachment objAttachment=new Attachment(); 
            objAttachment.Body= file;
            objAttachment.Name = 'test Attachment';
            objAttachment.ParentId = opp.Id;
            insert objAttachment;
            String text = 'Good to see you';
        	Test.startTest();
            AttachmentController2.updateDescription(opp.Id, text,text);
            AttachmentController2.postChatter(opp.Id, 3);
            AttachmentController2.postChatter(opp3.Id, 3);
            //AttachmentController2.saveFile(opp.id,'testAttachment',file.toString(),'jpg',objAttachment.Id);
            //AttachmentController2.saveFile(opp.id,'testAttachment',file.toString(),'jpg',NULL);  
            Test.stopTest();
            Opportunity opp2 = [SELECT Id, Name, SO_De__c FROM Opportunity WHERE Id =: opp.Id];
            System.assertEquals(opp2.SO_De__c, text);
            
        }
    
    /**
    *
    * @description : Test method
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 02/20/2022 - Deeptanshu Bharti
    *
    *
    **/
        static testMethod void mySeccondMethod_Test(){
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
                                              Uniform_Style__c = 'Top', Primary_Contact__c = contacts[0].Id, CloseDate = System.today(),SO_De__c='');
            
           
            
            insert opp;
            Opportunity c = [SELECT Id FROM Opportunity WHERE Id =: opp.Id];
            blob file=  Blob.valueOf('sample text');
            Attachment objAttachment=new Attachment(); 
            objAttachment.Body= file;
            objAttachment.Name = 'test Attachment';
            objAttachment.ParentId = opp.Id;
            insert objAttachment;
            String text = 'Good to see you';
            String fileName ='test Attachment'; 
            String base64 = 'sample text';
            Id recordId = opp.Id;
            String soDescription ='Hello';
            Integer leng =0;
        	Test.startTest();
            PageReference testPage = Page.SalesOrderNeeded;
            Test.setCurrentPage(testPage);
            testPage.getParameters().put('recordId', String.valueOf(opp.Id));
            testPage.getParameters().put('soDescription', 'Hello');
            ApexPages.StandardController sc = new  ApexPages.StandardController(opp);     
       		AttachmentController2 ext = new AttachmentController2(sc);
            ext.getBase64();
            PageReference objPageRef1 = ext.redirect();
            PageReference objPageRef = ext.saveMethod();
            Test.stopTest();
                        
        }

}