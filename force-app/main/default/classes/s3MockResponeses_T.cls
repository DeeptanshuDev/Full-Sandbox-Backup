@isTest
private class s3MockResponeses_T {

     @isTest
    private static void setup() {
        
        s3MockResponeses mr = new s3MockResponeses();
        s3MockResponeses.getS3DocumentsRespons();
        s3MockResponeses.getDeleteObjectsStatus();
        s3MockResponeses.getListBucketResult();
        s3MockResponeses.getListAllMyBucketResults();
        
         s3MockResponeses.copyObject();
        s3MockResponeses.putObject();
        s3MockResponeses.getObjACL();
        s3MockResponeses.GetObjectExtended();

s3MockResponeses.GetBucketLoggingStatus();
        
    }
}