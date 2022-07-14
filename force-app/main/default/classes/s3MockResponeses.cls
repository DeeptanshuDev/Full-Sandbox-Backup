/**
 * @description       : 
 * @author            : Seemu Saikia
 * @group             : 
 * @last modified on  : 05-10-2021
 * @last modified by  : Seemu Saikia
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   05-10-2021   Seemu Saikia   Initial Version
**/
public with sharing class s3MockResponeses {
    
    //Method to get fake response 
    public static s3.ListEntry[] getS3DocumentsRespons()  {
        
        //List of response
        s3.ListEntry[] s3List = new s3.ListEntry[]{};
        
        //Instance of s3.ListEntry  
        s3.ListEntry s3ListEntry = new s3.ListEntry();
        s3ListEntry.Key = 'Account/Test/0019000000xgQxW/Book1.pdf';
        s3ListEntry.LastModified = system.now();
        s3ListEntry.ETag = '17013f6d9c0a7e640194783c4b96b152';
        s3ListEntry.Size = 1048576;
        s3ListEntry.StorageClass = 'STANDARD';
        s3.CanonicalUser s3Canonical = new s3.CanonicalUser();
        s3Canonical.Id = 'd5a0fc2be4187ff6fed524cdbe5b32eaf0c574ea5a81a7689dd33bddc842ee1a';
        s3Canonical.DisplayName = 'bhavi';
        s3ListEntry.Owner = s3Canonical;
        
        
        //Instance of s3.ListEntry  
        s3.ListEntry  s3ListEntry1 = new s3.ListEntry();
        
        s3ListEntry1.Key = 'Account/Test/0019000000xgQxW/Book1.ppt';
        s3ListEntry1.LastModified = system.now();
        s3ListEntry1.ETag = '17013f6d9c0a7e640194783c4b96b152';
        s3ListEntry1.Size = 528314;
        s3ListEntry1.StorageClass = 'STANDARD';
        s3.CanonicalUser s3Canonical1 = new s3.CanonicalUser();
        s3Canonical1.Id = 'd5a0fc2be4187ff6fed524cdbe5b32eaf0c574ea5a81a7689dd33bddc842ee1a';
        s3Canonical1.DisplayName = 'bhavi';
        s3ListEntry1.Owner = s3Canonical1;
        
        //Instance of s3.ListEntry  
        s3.ListEntry s3ListEntry2 = new s3.ListEntry();
        
        s3ListEntry2.Key = 'Account/Test/0019000000xgQxW/Book1.xls';
        s3ListEntry2.LastModified = system.now();
        s3ListEntry2.ETag = '17013f6d9c0a7e640194783c4b96b152';
        s3ListEntry2.Size = 528314;
        s3ListEntry2.StorageClass = 'STANDARD';
        s3.CanonicalUser s3Canonical2 = new s3.CanonicalUser();
        s3Canonical2.Id = 'd5a0fc2be4187ff6fed524cdbe5b32eaf0c574ea5a81a7689dd33bddc842ee1a';
        s3Canonical2.DisplayName = 'bhavi';
        s3ListEntry2.Owner = s3Canonical2;
        
        //Instance of s3.ListEntry  
        s3.ListEntry s3ListEntry3 = new s3.ListEntry();
        
        s3ListEntry3.Key = 'Account/Test/0019000000xgQxW/Book1.jpg';
        s3ListEntry3.LastModified = system.now();
        s3ListEntry3.ETag = '17013f6d9c0a7e640194783c4b96b152';
        s3ListEntry3.Size = 528314;
        s3ListEntry3.StorageClass = 'STANDARD';
        s3.CanonicalUser s3Canonical3 = new s3.CanonicalUser();
        s3Canonical3.Id = 'd5a0fc2be4187ff6fed524cdbe5b32eaf0c574ea5a81a7689dd33bddc842ee1a';
        s3Canonical3.DisplayName = 'bhavi';
        s3ListEntry3.Owner = s3Canonical3;
        
        //Instance of s3.ListEntry  
        s3.ListEntry s3ListEntry6 = new s3.ListEntry();
        
        s3ListEntry6.Key = 'Account/Test/0019000000xgQxW/Book1.doc';
        s3ListEntry6.LastModified = system.now();
        s3ListEntry6.ETag = '17013f6d9c0a7e640194783c4b96b152';
        s3ListEntry6.Size = 528314;
        s3ListEntry6.StorageClass = 'STANDARD';
        s3.CanonicalUser s3Canonical6 = new s3.CanonicalUser();
        s3Canonical6.Id = 'd5a0fc2be4187ff6fed524cdbe5b32eaf0c574ea5a81a7689dd33bddc842ee1a';
        s3Canonical6.DisplayName = 'bhavi';
        s3ListEntry6.Owner = s3Canonical6;
        
        //Instance of s3.ListEntry  
        s3.ListEntry s3ListEntry4 = new s3.ListEntry();
        
        s3ListEntry4.Key = 'Account/Test/0019000000xgQxW/Book1.zip';
        s3ListEntry4.LastModified = system.now();
        s3ListEntry4.ETag = '17013f6d9c0a7e640194783c4b96b152';
        s3ListEntry4.Size = 528314;
        s3ListEntry4.StorageClass = 'STANDARD';
        s3.CanonicalUser s3Canonical4 = new s3.CanonicalUser();
        s3Canonical4.Id = 'd5a0fc2be4187ff6fed524cdbe5b32eaf0c574ea5a81a7689dd33bddc842ee1a';
        s3Canonical4.DisplayName = 'bhavi';
        s3ListEntry4.Owner = s3Canonical4;
        
        //Instance of s3.ListEntry  
        s3.ListEntry s3ListEntry5 = new s3.ListEntry();
        
        s3ListEntry5.Key = 'Account/Test/0019000000xgQxW/Book1.txt';
        s3ListEntry5.LastModified = system.now();
        s3ListEntry5.ETag = '17013f6d9c0a7e640194783c4b96b152';
        s3ListEntry5.Size = 528314;
        s3ListEntry5.StorageClass = 'STANDARD';
        s3.CanonicalUser s3Canonical5 = new s3.CanonicalUser();
        s3Canonical5.Id = 'd5a0fc2be4187ff6fed524cdbe5b32eaf0c574ea5a81a7689dd33bddc842ee1a';
        s3Canonical5.DisplayName = 'bhavi';
        s3ListEntry5.Owner = s3Canonical5;  
        
        //Instance of s3.ListEntry  
        s3.ListEntry s3ListEntry7 = new s3.ListEntry();
        
        s3ListEntry7.Key = 'Account/Test/0019000000xgQxW/Book1.html';
        s3ListEntry7.LastModified = system.now();
        s3ListEntry7.ETag = '17013f6d9c0a7e640194783c4b96b152';
        s3ListEntry7.Size = 528314;
        s3ListEntry7.StorageClass = 'STANDARD';
        s3.CanonicalUser s3Canonical7 = new s3.CanonicalUser();
        s3Canonical7.Id = 'd5a0fc2be4187ff6fed524cdbe5b32eaf0c574ea5a81a7689dd33bddc842ee1a';
        s3Canonical7.DisplayName = 'bhavi';
        s3ListEntry7.Owner = s3Canonical7;  
        
        s3List.add(s3ListEntry); 
        s3List.add(s3ListEntry1); 
        s3List.add(s3ListEntry2); 
        s3List.add(s3ListEntry3); 
        s3List.add(s3ListEntry4); 
        s3List.add(s3ListEntry5); 
        s3List.add(s3ListEntry6);
        s3List.add(s3ListEntry7); 
        
        return s3List;
        
    } 
    //Method to get the delete objects status from amazon
    public static S3.Status getDeleteObjectsStatus() {
        
        //Craete instance of status class to get fake response
        S3.Status status = new S3.Status();
        
        status.Code = 204;   
        status.Description = 'No Content';
         
        return status;
    }
    
    //ListBucket
    public static s3.ListBucketResult getListBucketResult()  {
        
        //Instanciate the list Bucket
        s3.ListBucketResult s3ListBucket = new s3.ListBucketResult();
        
        //Create metadata entry list data
        s3.MetadataEntry[] metaList = new s3.MetadataEntry[]{};
        s3.MetadataEntry mt = new s3.MetadataEntry();
        mt.Name = 'test';
        mt.value = 'ffgfg';    
        metaList.add(mt);
         
        s3ListBucket.Metadata = metaList;
        s3ListBucket.Name = 'Testing';
        s3ListBucket.Prefix = '1';
        s3ListBucket.Marker = '1';
        s3ListBucket.NextMarker = '1';   
        s3ListBucket.MaxKeys = 1;
        s3ListBucket.Delimiter = '.';
        s3ListBucket.IsTruncated = false;
        
        //List of response
        s3.ListEntry[] s3List = new s3.ListEntry[]{};
        
        //Instance of s3.ListEntry  
        s3.ListEntry s3ListEntry = new s3.ListEntry();
        s3ListEntry.Key = 'Account/Test/0019000000xgQxW/Book1.pdf';
        s3ListEntry.LastModified = system.now();
        s3ListEntry.ETag = '17013f6d9c0a7e640194783c4b96b152';
        s3ListEntry.Size = 528314;
        s3ListEntry.StorageClass = 'STANDARD';
        s3.CanonicalUser s3Canonical = new s3.CanonicalUser();
        s3Canonical.Id = 'd5a0fc2be4187ff6fed524cdbe5b32eaf0c574ea5a81a7689dd33bddc842ee1a';
        s3Canonical.DisplayName = 'bhavi';
        s3ListEntry.Owner = s3Canonical;
        s3List.add(s3ListEntry);
        s3ListBucket.Contents = s3List;
        
        s3.PrefixEntry[] prefix = new s3.PrefixEntry[]{};
        s3.PrefixEntry pref = new s3.PrefixEntry();
        pref.Prefix = 'Test';
        prefix.add(pref);
        
        s3ListBucket.CommonPrefixes = prefix;
         
        return s3ListBucket;
    }
    
    //ListAllMyBuckets
    public static s3.ListAllMyBucketsResult getListAllMyBucketResults() {
        
         //Instance of s3.ListAllMyBucketsResult
         s3.ListAllMyBucketsResult s3ListBucket = new s3.ListAllMyBucketsResult();
         
         //create data of canocial user
         s3.CanonicalUser s3Canonical = new s3.CanonicalUser();
         s3Canonical.Id = 'd5a0fc2be4187ff6fed524cdbe5b32eaf0c574ea5a81a7689dd33bddc842ee1a';
         s3Canonical.DisplayName = 'bhavi';
         
         //create data of ListAllMyBucketResult
         s3.ListAllMyBucketsList s3ListAllMyBucket = new s3.ListAllMyBucketsList();
         
         s3.ListAllMyBucketsEntry[] bktEntries = new s3.ListAllMyBucketsEntry[]{};
         s3.ListAllMyBucketsEntry  bktEntry = new s3.ListAllMyBucketsEntry();
         bktEntry.Name = 'Test';
         bktEntry.CreationDate = system.today();
         bktEntries.add(bktEntry); 
         s3ListAllMyBucket.Bucket = bktEntries;
         
         s3ListBucket.Owner = s3Canonical;
         s3ListBucket.Buckets = s3ListAllMyBucket;
    
        return s3ListBucket;
    }
    
    //Copy Object
    public static s3.CopyObjectResult copyObject() {
        
        //create s3.CopyObjectResult instance
        s3.CopyObjectResult cpyResult = new s3.CopyObjectResult();
        cpyResult.LastModified = system.today();
        cpyResult.ETag = 'Test';
        
        return cpyResult;
    }
    
    //putObject
    public static s3.PutObjectResult putObject() {
        
        //create s3.PutObjectResult instance
        s3.PutObjectResult putResult = new s3.PutObjectResult();
        putResult.ETag = 'Test';
        putResult.LastModified = system.today();
        
        return putResult; 
    }
    
    //get object Acl
    public static s3.AccessControlPolicy getObjACL() {
        
        //Create iinstance of s3.AccessControlPolicy
        s3.AccessControlPolicy s3ACL = new s3.AccessControlPolicy();
        
        //Canocial user
        s3.CanonicalUser s3Canonical = new s3.CanonicalUser();
        s3Canonical.Id = 'd5a0fc2be4187ff6fed524cdbe5b32eaf0c574ea5a81a7689dd33bddc842ee1a';
        s3Canonical.DisplayName = 'bhavi';
        
        //Access Controll listt
        s3.AccessControlList aCL = new s3.AccessControlList();
        s3.Grant[] grntList = new s3.Grant[]{};
        s3.Grant grant = new s3.Grant();
        s3.Grantee grantee = new s3.Grantee();
        grant.Grantee = grantee;
        grant.Permission = 'public';
        grntList.add(grant);
         
        aCL.Grant = grntList;
        s3ACL.Owner = s3Canonical;
        s3ACL.AccessControlList = aCL;
          
        return s3ACL;
    }
    
    //get objetc extended
    public static s3.GetObjectResult GetObjectExtended(){
            
        //Craete instance of s3.GetObjectResult     
        s3.GetObjectResult getObjRes = new s3.GetObjectResult();
        
        //Meta data entry
        s3.MetadataEntry[] metaList = new s3.MetadataEntry[]{};
        s3.MetadataEntry mt = new s3.MetadataEntry();
        mt.Name = 'test';
        mt.value = 'ffgfg';    
        metaList.add(mt);
        
        getObjRes.Metadata = metaList;
        getObjRes.Data = 'test';
        getObjRes.ETag = 'test';
        getObjRes.LastModified = system.today();
        
        return getObjRes;
    }
    
    //create bucket
    public static s3.CreateBucketResult createBucket() {
        
        //Craete instanec of  s3.CreateBucketResult
        s3.CreateBucketResult createBukt  = new s3.CreateBucketResult();
        createBukt.BucketName = 'tset';
        
        return createBukt;
    }
    
    //get bucket logging status
    public static s3.BucketLoggingStatus GetBucketLoggingStatus() {
        
        //Craete insytance of s3.BucketLoggingStatus
        s3.BucketLoggingStatus bktLogStatus = new s3.BucketLoggingStatus();
        
        //Logging status
        s3.LoggingSettings lS = new s3.LoggingSettings();
        lS.TargetBucket = 'Test';       
        ls.TargetPrefix = 'TTest';
        
        //Access controll list
        s3.AccessControlList  aCL = new s3.AccessControlList();
        
        s3.Grant[] GrantList = new s3.Grant[]{};
        s3.Grant grnt = new s3.Grant();
        s3.Grantee grantee = new s3.Grantee(); 
        grnt.Grantee = grantee;
        grnt.Permission = 'public';
        GrantList.add(grnt);
        
        aCL.Grant = GrantList;
        ls.TargetGrants = aCL;
        
        bktLogStatus.LoggingEnabled = ls;
        
        return bktLogStatus ;
    }
}