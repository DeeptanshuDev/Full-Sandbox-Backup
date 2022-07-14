/** 
* 
* Description : Test class for AttachmentVf class.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 07/08/2022 
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/

@isTest (seeAllData=false)
public class AttachmentVf_Test {
    /**
    *
    * @description : Test method for AttachmentVf class
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 07/08/2022 - Deeptanshu Bharti
    *
    * coverage : 
    *
**/
    @isTest static void testAccountOpportunity(){    
        Account acc = new Account(Name = 'Test Account'); 
        insert acc;
        
        Opportunity opp = TestData.opportunity(true);
        opp.AccountId = acc.Id;
        update opp;
        Attachment att = new Attachment();
        att.ParentId = acc.Id;
        att.Name = 'test';
        att.Body = Blob.valueOf('test');
        insert att;

        Test.startTest();
        AttachmentVf controller=new AttachmentVf(new ApexPages.StandardController(opp));

        Test.stopTest();
       
    } 
}