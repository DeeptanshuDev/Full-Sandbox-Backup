/**
 * @description       : 
 * @author            : Seemu Saikia
 * @group             : 
 * @last modified on  : 05-03-2021
 * @last modified by  : Seemu Saikia
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   05-03-2021   Seemu Saikia   Initial Version
**/
@isTest
public class AFSFFinalController_T {
    
    @testSetup
    static void setUp(){

        CollaborationGroup cg = new CollaborationGroup(Name = 'Test Team',CollaborationType = 'Private');
        insert cg;

        List<Account> aList = new List<Account> {new Account (Name = 'My Test Account')};
        insert aList;
        
        List<Contact> cList = new List<Contact>{new Contact(LastName = 'Saikia')};
        insert cList;
        
        List<Opportunity> oList = new List<Opportunity> {
            new Opportunity(Name ='AFS Testing Pass',AccountID =aList[0].id,Primary_Contact__c = cList[0].Id,Category_Picklist__c = 'Pro',Collection_Picklist__c = 'Poly', CloseDate = System.today(),StageName = 'Open')};
        insert oList;

        ContentVersion contentVersionM = new ContentVersion(Title = 'AFS - FF -M- 0061159 - Pro Accessory-Bow Test',PathOnClient = 'AFS - FF -M- 0061159 - Pro Accessory-Bow Test.xlsm',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersionM;

        ContentVersion contentVersionF = new ContentVersion(Title = 'AFS - FF -G- 0061159 - Pro Accessory-Bow Test',PathOnClient = 'AFS - FF -G- 0061159 - Pro Accessory-Bow Test.xlsm',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersionF;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        List<ContentDocumentLink> cdl = new List<ContentDocumentLink> {
            new ContentDocumentLink( LinkedEntityId = oList[0].id, ContentDocumentId = documents[0].Id, shareType = 'V'),
            new ContentDocumentLink( LinkedEntityId = oList[0].id, ContentDocumentId = documents[1].Id, shareType = 'V')};
        insert cdl;

    }

    @isTest
    static void testFMethods(){

        Opportunity opp = [SELECT Id FROM Opportunity ];
        System.Test.StartTest(); 
        PageReference pageRef = Page.AFSFFinal; // Add your VF page Name here
        pageRef.getParameters().put('Id', String.valueOf(opp.Id));
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        AFSFFinalController obj = new AFSFFinalController(sc);
        obj.validateAFSFileOnOpportunity();
        System.Test.StopTest();
        opp = [SELECT Id,AFS_F_Final__c FROM Opportunity];
        system.debug(opp);
        System.assertEquals(true,opp.AFS_F_Final__c,'Checkbox not updated');

        obj.goBack();

    }
        
    }