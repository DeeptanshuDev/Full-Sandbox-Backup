@isTest
private class ShowS3DocumentsPicturesCtrl_T {
    
    @TestSetup
    private static void setup() {
        Opportunity opp = TestData.opportunity(true);
        Design_Request__c dr1 = TestData.designRequest(new Design_Request__c(ARC_ready_for_assignment__c = true, Opportunity__c = opp.Id), true);
        Design_Request__c dr2 = TestData.designRequest(new Design_Request__c(ARC_ready_for_assignment__c = false, Opportunity__c = opp.Id), true);
        
        List<AWS_Documents__c> documentList = new List<AWS_Documents__c>();
        List<String> CategoryList = new List<String>{'RC Proto Pics','RD Proto Pics','PP Pics','Dyesub Strike Off','Remake/Rework'};
        
        for(Integer i = 0; i < 5; i++) {
            AWS_Documents__c document = new AWS_Documents__c(File_Name__c = 'Testing File ' + i, Categories__c = CategoryList[i], Design_Request__c = dr1.Id);
            documentList.add(document);
        }
        insert documentList;
    }
    
    @isTest
    private static void getDocumentsList() {
        Design_Request__c dr1 = [SELECT Id FROM Design_Request__c WHERE ARC_ready_for_assignment__c = true];
        Design_Request__c dr2 = [SELECT Id FROM Design_Request__c WHERE ARC_ready_for_assignment__c = false];
        Test.startTest();
        PageReference pageRef = Page.ShowS3DocumentsPicturesVfPage;
        pageRef.getParameters().put('Id',dr1.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(dr1);
        ShowS3DocumentsPicturesCtrl s3Doc = new ShowS3DocumentsPicturesCtrl(sc);
        ShowS3DocumentsPicturesCtrl.getDocumentsList(dr1.Id);
        ShowS3DocumentsPicturesCtrl.getDocumentsList(dr2.Id);
        Test.stopTest();
    }
    
}