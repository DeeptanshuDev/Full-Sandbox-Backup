/**
 * @description       : 
 * @author            : Shubham Sharma
 * @group             : 
 * @last modified on  : 09-14-2021
 * @last modified by  : Shubham Sharma
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-13-2021   Shubham Sharma   Initial Version
 * 1.1   09-14-2021   Shubham Sharma   Added extra field "Subcategory__c" in the s3DocumentList query
**/
public class ShowS3DocumentsPicturesCtrl {

    public static Id designRequestIdPage {get;set;}
    
    public ShowS3DocumentsPicturesCtrl(ApexPages.standardController con){
        designRequestIdPage = con.getId();
    }
    
    @AuraEnabled
    public static S3DocumentsListWrapper getDocumentsList(String designRequestId) {
        S3DocumentsListWrapper dlw = new S3DocumentsListWrapper();
        try {
            List<AWS_Documents__c> s3DocumentList = [SELECT Id, Name, File_Name__c, Gender__c, Approved_Proto_Selection__c,LastModifiedDate, Categories__c, Subcategory__c, Description__c, 
                                                     File_Link__c, Account__r.name FROM AWS_Documents__c WHERE Design_Request__c = :designRequestId];
            if(s3DocumentList != null && s3DocumentList.size() > 0) {
                dlw.isSuccess = true;
                dlw.documentList = s3DocumentList;
                Set<String> CategorySet = new Set<String>();
                for(AWS_Documents__c s3Document: s3DocumentList) {
                    CategorySet.add(s3Document.Categories__c);
                }
                List<String> CategoryList = new List<String>(CategorySet);
                dlw.documentCategory = CategoryList;
            } else {
                dlw.isSuccess = false;
                dlw.message = 'There is no documents For this Design Request';
            }
        } catch(Exception ex) {
            dlw.isSuccess = false;
            dlw.message = ex.getMessage();
        }
        return dlw;
    }
    
    public class S3DocumentsListWrapper {
        
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public List<AWS_Documents__c> documentList;
        @AuraEnabled
        public List<String> documentCategory;
    }
}