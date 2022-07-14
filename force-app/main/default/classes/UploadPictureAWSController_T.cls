@isTest
public class UploadPictureAWSController_T {
    
    @TestSetup
    private static void setup() {
        Opportunity opp = TestData.opportunity(true);
        Design_Request__c dr = TestData.designRequest(new Design_Request__c(ARC_ready_for_assignment__c = true, Opportunity__c = opp.Id), true);
        S3_Defaults__c S3D = new S3_Defaults__c(AWS_Access_Key__c = 'asdfa', AWS_Secret_Key__c = 'asdas', Bucket_Name__c = 'asdsda', File_Name__c = 'asdasdasd', 
                                               File_Path__c = 'asdasdcas', Package_Prefix__c = 'asdaskdasdk');
        insert S3D;
    }
    
    @isTest
    private static void getPicklistValue() {
        Design_Request__c dr = [SELECT Id, Name FROM Design_Request__c LIMIT 1];
        Test.startTest();
        PageReference pageRef = Page.UploadPictureAWS;
        pageRef.getParameters().put('Id',dr.Id);
        pageRef.getParameters().put('recordName',dr.Name);
        Test.setCurrentPage(pageRef);
        UploadPictureAWSController UPA = new UploadPictureAWSController();
        List<String> selectedCategoryList = new List<String>{'RC Proto Pics', 'RD Proto Pics', 'PP Pics', 'Dyesub Strike Off', 
            								'Inspiration Pics - Proto Phase', 'Inspiration Pics - Art Phase', 'Remake/Rework'};
        
        UPA.getItems();
        UPA.getCategories();
        for(String selectedCategory : selectedCategoryList) {
            UPA.selectedCategory = selectedCategory;
            UPA.getCities();
        }
        
        UPA.getGender();
        UPA.setGender('Boy');
        Test.stopTest();
    }
    
    @isTest
    private static void createS3Record() {
        Design_Request__c dr = [SELECT Id, Name FROM Design_Request__c LIMIT 1];
        Test.startTest();
        PageReference pageRef = Page.UploadPictureAWS;
        pageRef.getParameters().put('Id',dr.Id);
        pageRef.getParameters().put('recordName',dr.Name);
        Test.setCurrentPage(pageRef);
        UploadPictureAWSController UPA = new UploadPictureAWSController();
        
        UPA.protoSelection = true;
        UPA.amazonFileName = 'asdm sd na.jpeg';
        UPA.amazonFileURL = 'asdsadsdsd';
        UPA.createS3DocRec();
        
        Test.stopTest();
    }
    
    @isTest
    private static void deleteAndUpdateFile() {
        Design_Request__c dr = [SELECT Id, Name FROM Design_Request__c LIMIT 1];
        Test.startTest();
        PageReference pageRef = Page.UploadPictureAWS;
        pageRef.getParameters().put('Id',dr.Id);
        pageRef.getParameters().put('recordName',dr.Name);
        Test.setCurrentPage(pageRef);
        UploadPictureAWSController UPA = new UploadPictureAWSController();
        
        UPA.deletedKeyString = 'asdmgfgd';
        UPA.deleteSelectedFile();
        UPA.updateKeyString = 'asdm sd na.jpeg';
        UPA.amazonFileURL = 'asdsadsdsd';
        UPA.updateMediaDescription();
        
        UPA.closeWindow();
        UPA.hidePopup();
        UploadPictureAWSController.awsWrapper aws = new UploadPictureAWSController.awsWrapper('as', 'sd', 'asd', 'asd', 'assdv');
        
        Test.stopTest();
    }
    
    @isTest
    private static void deleteAndUpdateFile2() {
        Design_Request__c dr = [SELECT Id, Name FROM Design_Request__c LIMIT 1];
        Test.startTest();
        PageReference pageRef = Page.UploadPictureAWS;
        pageRef.getParameters().put('Id',dr.Id);
        pageRef.getParameters().put('recordName',dr.Name);
        Test.setCurrentPage(pageRef);
        UploadPictureAWSController UPA = new UploadPictureAWSController();
        
        UPA.updateKeyString = 'asdm sd na.mp3';
        UPA.amazonFileURL = 'asdsadsdsd';
        UPA.extension = '.mp3';
        UPA.updateMediaDescription();
        
        UPA.closeWindow();
        UPA.setGender('Boy');
        UPA.hidePopup();
        
        Test.stopTest();
    }
}