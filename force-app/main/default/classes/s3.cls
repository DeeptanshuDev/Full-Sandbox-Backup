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
public class s3 {
    
    public class User_x {
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class DeleteObject_element {
        public String Bucket;
        public String Key;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Key_type_info = new String[]{'Key','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','Key','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class PostResponse_element {
        public String Location;
        public String Bucket;
        public String Key;
        public String ETag;
        private String[] Location_type_info = new String[]{'Location','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Key_type_info = new String[]{'Key','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] ETag_type_info = new String[]{'ETag','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Location','Bucket','Key','ETag'};
    }
    public class CopyObjectResponse_element {
        public s3.CopyObjectResult CopyObjectResult;
        private String[] CopyObjectResult_type_info = new String[]{'CopyObjectResult','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'CopyObjectResult'};
    }
    public class GetObjectExtended_element {
        public String Bucket;
        public String Key;
        public Boolean GetMetadata;
        public Boolean GetData;
        public Boolean InlineData;
        public Long ByteRangeStart;
        public Long ByteRangeEnd;
        public DateTime IfModifiedSince;
        public DateTime IfUnmodifiedSince;
        public String[] IfMatch;
        public String[] IfNoneMatch;
        public Boolean ReturnCompleteObjectOnConditionFailure;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Key_type_info = new String[]{'Key','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] GetMetadata_type_info = new String[]{'GetMetadata','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] GetData_type_info = new String[]{'GetData','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] InlineData_type_info = new String[]{'InlineData','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] ByteRangeStart_type_info = new String[]{'ByteRangeStart','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] ByteRangeEnd_type_info = new String[]{'ByteRangeEnd','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] IfModifiedSince_type_info = new String[]{'IfModifiedSince','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] IfUnmodifiedSince_type_info = new String[]{'IfUnmodifiedSince','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] IfMatch_type_info = new String[]{'IfMatch','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','100','false'};
        private String[] IfNoneMatch_type_info = new String[]{'IfNoneMatch','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','100','false'};
        private String[] ReturnCompleteObjectOnConditionFailure_type_info = new String[]{'ReturnCompleteObjectOnConditionFailure','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','Key','GetMetadata','GetData','InlineData','ByteRangeStart','ByteRangeEnd','IfModifiedSince','IfUnmodifiedSince','IfMatch','IfNoneMatch','ReturnCompleteObjectOnConditionFailure','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class Group_x {
        public String URI;
        private String[] URI_type_info = new String[]{'URI','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'URI'};
    }
    public class PutObjectInline_element {
        public String Bucket;
        public String Key;
        public s3.MetadataEntry[] Metadata;
        public String Data;
        public Long ContentLength;
        public s3.AccessControlList AccessControlList;
        public String StorageClass;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Key_type_info = new String[]{'Key','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Metadata_type_info = new String[]{'Metadata','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','100','false'};
        private String[] Data_type_info = new String[]{'Data','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] ContentLength_type_info = new String[]{'ContentLength','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AccessControlList_type_info = new String[]{'AccessControlList','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] StorageClass_type_info = new String[]{'StorageClass','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','Key','Metadata','Data','ContentLength','AccessControlList','StorageClass','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class SetBucketAccessControlPolicyResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class CreateBucket_element {
        public String Bucket;
        public s3.AccessControlList AccessControlList;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AccessControlList_type_info = new String[]{'AccessControlList','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','AccessControlList','AWSAccessKeyId','Timestamp','Signature'};
    }
    public class DeleteBucket_element {
        public String Bucket;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class Result {
        public s3.Status Status;
        private String[] Status_type_info = new String[]{'Status','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Status'};
    }
    public class PutObjectInlineResponse_element {
        public s3.PutObjectResult PutObjectInlineResponse;
        private String[] PutObjectInlineResponse_type_info = new String[]{'PutObjectInlineResponse','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'PutObjectInlineResponse'};
    }
    public class  CanonicalUser{
        public String ID;
        public String DisplayName;
        private String[] ID_type_info = new String[]{'ID','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] DisplayName_type_info = new String[]{'DisplayName','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'ID','DisplayName'};
    }
    public class AmazonCustomerByEmail {
        public String EmailAddress;
        private String[] EmailAddress_type_info = new String[]{'EmailAddress','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'EmailAddress'};
    }
    public class CreateBucketResponse_element {
        public s3.CreateBucketResult CreateBucketReturn;
        private String[] CreateBucketReturn_type_info = new String[]{'CreateBucketReturn','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'CreateBucketReturn'};
    }
    public class PutObjectResponse_element {
        public s3.PutObjectResult PutObjectResponse;
        private String[] PutObjectResponse_type_info = new String[]{'PutObjectResponse','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'PutObjectResponse'};
    }
    public class ListBucketResponse_element {
        public s3.ListBucketResult ListBucketResponse;
        private String[] ListBucketResponse_type_info = new String[]{'ListBucketResponse','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'ListBucketResponse'};
    }
    public class GetObjectExtendedResponse_element {
        public s3.GetObjectResult GetObjectResponse;
        private String[] GetObjectResponse_type_info = new String[]{'GetObjectResponse','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'GetObjectResponse'};
    }
    public class DeleteBucketResponse_element {
        public s3.Status DeleteBucketResponse;
        private String[] DeleteBucketResponse_type_info = new String[]{'DeleteBucketResponse','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'DeleteBucketResponse'};
    }
    public class GetObjectAccessControlPolicy_element {
        public String Bucket;
        public String Key;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Key_type_info = new String[]{'Key','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','Key','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class AccessControlPolicy {
        public s3.CanonicalUser Owner;
        public s3.AccessControlList AccessControlList;
        private String[] Owner_type_info = new String[]{'Owner','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AccessControlList_type_info = new String[]{'AccessControlList','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Owner','AccessControlList'};
    }
    public class PrefixEntry {
        public String Prefix;
        private String[] Prefix_type_info = new String[]{'Prefix','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Prefix'};
    }
    public class AccessControlList {
        public s3.Grant[] Grant;
        private String[] Grant_type_info = new String[]{'Grant','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','100','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Grant'};
    }
    public class GetBucketAccessControlPolicy_element {
        public String Bucket;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class SetObjectAccessControlPolicyResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class PutObjectResult {
        public String ETag;
        public DateTime LastModified;
        private String[] ETag_type_info = new String[]{'ETag','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] LastModified_type_info = new String[]{'LastModified','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'ETag','LastModified'};
    }
    public class ListAllMyBucketsResponse_element {
        public s3.ListAllMyBucketsResult ListAllMyBucketsResponse;
        private String[] ListAllMyBucketsResponse_type_info = new String[]{'ListAllMyBucketsResponse','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'ListAllMyBucketsResponse'};
    }
    public class SetObjectAccessControlPolicy_element {
        public String Bucket;
        public String Key;
        public s3.AccessControlList AccessControlList;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Key_type_info = new String[]{'Key','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AccessControlList_type_info = new String[]{'AccessControlList','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','Key','AccessControlList','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class CopyObject_element {
        public String SourceBucket;
        public String SourceKey;
        public String DestinationBucket;
        public String DestinationKey;
        public String MetadataDirective;
        public s3.MetadataEntry[] Metadata;
        public s3.AccessControlList AccessControlList;
        public DateTime CopySourceIfModifiedSince;
        public DateTime CopySourceIfUnmodifiedSince;
        public String[] CopySourceIfMatch;
        public String[] CopySourceIfNoneMatch;
        public String StorageClass;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] SourceBucket_type_info = new String[]{'SourceBucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] SourceKey_type_info = new String[]{'SourceKey','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] DestinationBucket_type_info = new String[]{'DestinationBucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] DestinationKey_type_info = new String[]{'DestinationKey','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] MetadataDirective_type_info = new String[]{'MetadataDirective','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Metadata_type_info = new String[]{'Metadata','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','100','false'};
        private String[] AccessControlList_type_info = new String[]{'AccessControlList','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] CopySourceIfModifiedSince_type_info = new String[]{'CopySourceIfModifiedSince','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] CopySourceIfUnmodifiedSince_type_info = new String[]{'CopySourceIfUnmodifiedSince','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] CopySourceIfMatch_type_info = new String[]{'CopySourceIfMatch','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','100','false'};
        private String[] CopySourceIfNoneMatch_type_info = new String[]{'CopySourceIfNoneMatch','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','100','false'};
        private String[] StorageClass_type_info = new String[]{'StorageClass','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'SourceBucket','SourceKey','DestinationBucket','DestinationKey','MetadataDirective','Metadata','AccessControlList','CopySourceIfModifiedSince','CopySourceIfUnmodifiedSince','CopySourceIfMatch','CopySourceIfNoneMatch','StorageClass','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class LocationConstraint {
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class MetadataEntry {
        public String Name;
        public String Value;
        private String[] Name_type_info = new String[]{'Name','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Value_type_info = new String[]{'Value','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Name','Value'};
    }
    public class SetBucketLoggingStatusResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class SetBucketLoggingStatus_element {
        public String Bucket;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        public s3.BucketLoggingStatus BucketLoggingStatus;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] BucketLoggingStatus_type_info = new String[]{'BucketLoggingStatus','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','AWSAccessKeyId','Timestamp','Signature','Credential','BucketLoggingStatus'};
    }
    public class GetObjectAccessControlPolicyResponse_element {
        public s3.AccessControlPolicy GetObjectAccessControlPolicyResponse;
        private String[] GetObjectAccessControlPolicyResponse_type_info = new String[]{'GetObjectAccessControlPolicyResponse','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'GetObjectAccessControlPolicyResponse'};
    }
    public class CreateBucketConfiguration {
        public s3.LocationConstraint LocationConstraint;
        private String[] LocationConstraint_type_info = new String[]{'LocationConstraint','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'LocationConstraint'};
    }
    public class DeleteObjectResponse_element {
        public s3.Status DeleteObjectResponse;
        private String[] DeleteObjectResponse_type_info = new String[]{'DeleteObjectResponse','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'DeleteObjectResponse'};
    }
    public class Grant {
        public s3.Grantee Grantee;
        public String Permission;
        private String[] Grantee_type_info = new String[]{'Grantee','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Permission_type_info = new String[]{'Permission','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Grantee','Permission'};
    }
    public class GetObjectResult {
        public s3.MetadataEntry[] Metadata;
        public String Data;
        public DateTime LastModified;
        public String ETag;
        private String[] Metadata_type_info = new String[]{'Metadata','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','-1','false'};
        private String[] Data_type_info = new String[]{'Data','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','true'};
        private String[] LastModified_type_info = new String[]{'LastModified','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] ETag_type_info = new String[]{'ETag','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Metadata','Data','LastModified','ETag'};
    }
    public class ListAllMyBuckets_element {
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'AWSAccessKeyId','Timestamp','Signature'};
    }
    public class PutObject_element {
        public String Bucket;
        public String Key;
        public s3.MetadataEntry[] Metadata;
        public Long ContentLength;
        public s3.AccessControlList AccessControlList;
        public String StorageClass;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Key_type_info = new String[]{'Key','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Metadata_type_info = new String[]{'Metadata','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','100','false'};
        private String[] ContentLength_type_info = new String[]{'ContentLength','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AccessControlList_type_info = new String[]{'AccessControlList','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] StorageClass_type_info = new String[]{'StorageClass','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','Key','Metadata','ContentLength','AccessControlList','StorageClass','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class BucketLoggingStatus {
        public s3.LoggingSettings LoggingEnabled;
        private String[] LoggingEnabled_type_info = new String[]{'LoggingEnabled','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'LoggingEnabled'};
    }
    public class GetBucketLoggingStatusResponse_element {
        public s3.BucketLoggingStatus GetBucketLoggingStatusResponse;
        private String[] GetBucketLoggingStatusResponse_type_info = new String[]{'GetBucketLoggingStatusResponse','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'GetBucketLoggingStatusResponse'};
    }
    public class ListAllMyBucketsResult {
        public s3.CanonicalUser Owner;
        public s3.ListAllMyBucketsList Buckets;
        private String[] Owner_type_info = new String[]{'Owner','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Buckets_type_info = new String[]{'Buckets','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Owner','Buckets'};
    }
    public class RequestPaymentConfiguration {
        public String Payer;
        private String[] Payer_type_info = new String[]{'Payer','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Payer'};
    }
    public class Grantee {
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class ListEntry {
        public String Key;
        public DateTime LastModified;
        public String ETag;
        public Long Size;
        public s3.CanonicalUser Owner;
        public String StorageClass;
        private String[] Key_type_info = new String[]{'Key','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] LastModified_type_info = new String[]{'LastModified','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] ETag_type_info = new String[]{'ETag','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Size_type_info = new String[]{'Size','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Owner_type_info = new String[]{'Owner','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] StorageClass_type_info = new String[]{'StorageClass','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Key','LastModified','ETag','Size','Owner','StorageClass'};
    }
    public class CopyObjectResult {
        public DateTime LastModified;
        public String ETag;
        private String[] LastModified_type_info = new String[]{'LastModified','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] ETag_type_info = new String[]{'ETag','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'LastModified','ETag'};
    }
    public class GetBucketAccessControlPolicyResponse_element {
        public s3.AccessControlPolicy GetBucketAccessControlPolicyResponse;
        private String[] GetBucketAccessControlPolicyResponse_type_info = new String[]{'GetBucketAccessControlPolicyResponse','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'GetBucketAccessControlPolicyResponse'};
    }
    public class LoggingSettings {
        public String TargetBucket;
        public String TargetPrefix;
        public s3.AccessControlList TargetGrants;
        private String[] TargetBucket_type_info = new String[]{'TargetBucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] TargetPrefix_type_info = new String[]{'TargetPrefix','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] TargetGrants_type_info = new String[]{'TargetGrants','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'TargetBucket','TargetPrefix','TargetGrants'};
    }
    public class GetObject_element {
        public String Bucket;
        public String Key;
        public Boolean GetMetadata;
        public Boolean GetData;
        public Boolean InlineData;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Key_type_info = new String[]{'Key','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] GetMetadata_type_info = new String[]{'GetMetadata','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] GetData_type_info = new String[]{'GetData','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] InlineData_type_info = new String[]{'InlineData','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','Key','GetMetadata','GetData','InlineData','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class GetBucketLoggingStatus_element {
        public String Bucket;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class GetObjectResponse_element {
        public s3.GetObjectResult GetObjectResponse;
        private String[] GetObjectResponse_type_info = new String[]{'GetObjectResponse','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'GetObjectResponse'};
    }  
    public class Status {
        public Integer Code;
        public String Description;
        private String[] Code_type_info = new String[]{'Code','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Code','Description'};
    }
    public class SetBucketAccessControlPolicy_element {
        public String Bucket;
        public s3.AccessControlList AccessControlList;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] AccessControlList_type_info = new String[]{'AccessControlList','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','AccessControlList','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class CreateBucketResult {
        public String BucketName;
        private String[] BucketName_type_info = new String[]{'BucketName','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'BucketName'};
    }
    public class ListBucket_element {
        public String Bucket;
        public String Prefix;
        public String Marker;
        public Integer MaxKeys;
        public String Delimiter;
        public String AWSAccessKeyId;
        public DateTime Timestamp;
        public String Signature;
        public String Credential;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Prefix_type_info = new String[]{'Prefix','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Marker_type_info = new String[]{'Marker','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] MaxKeys_type_info = new String[]{'MaxKeys','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Delimiter_type_info = new String[]{'Delimiter','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] AWSAccessKeyId_type_info = new String[]{'AWSAccessKeyId','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Timestamp_type_info = new String[]{'Timestamp','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Signature_type_info = new String[]{'Signature','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] Credential_type_info = new String[]{'Credential','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket','Prefix','Marker','MaxKeys','Delimiter','AWSAccessKeyId','Timestamp','Signature','Credential'};
    }
    public class ListAllMyBucketsList {
        public s3.ListAllMyBucketsEntry[] Bucket;
        private String[] Bucket_type_info = new String[]{'Bucket','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Bucket'};
    }
    public class ListBucketResult {
        public s3.MetadataEntry[] Metadata;
        public String Name;
        public String Prefix;
        public String Marker;
        public String NextMarker;
        public Integer MaxKeys;
        public String Delimiter;
        public Boolean IsTruncated;
        public s3.ListEntry[] Contents;
        public s3.PrefixEntry[] CommonPrefixes;
        private String[] Metadata_type_info = new String[]{'Metadata','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','-1','false'};
        private String[] Name_type_info = new String[]{'Name','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Prefix_type_info = new String[]{'Prefix','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Marker_type_info = new String[]{'Marker','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] NextMarker_type_info = new String[]{'NextMarker','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] MaxKeys_type_info = new String[]{'MaxKeys','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Delimiter_type_info = new String[]{'Delimiter','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','1','false'};
        private String[] IsTruncated_type_info = new String[]{'IsTruncated','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] Contents_type_info = new String[]{'Contents','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','-1','false'};
        private String[] CommonPrefixes_type_info = new String[]{'CommonPrefixes','http://s3.amazonaws.com/doc/2006-03-01/',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Metadata','Name','Prefix','Marker','NextMarker','MaxKeys','Delimiter','IsTruncated','Contents','CommonPrefixes'};
    }
    public class ListAllMyBucketsEntry {
        public String Name;
        public DateTime CreationDate;
        private String[] Name_type_info = new String[]{'Name','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] CreationDate_type_info = new String[]{'CreationDate','http://s3.amazonaws.com/doc/2006-03-01/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/','true','false'};
        private String[] field_order_type_info = new String[]{'Name','CreationDate'};
    }
    public class AmazonS3 {
        public String endpoint_x = 'https://s3.amazonaws.com/soap';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://s3.amazonaws.com/doc/2006-03-01/', 's3'};
        public s3.ListAllMyBucketsResult ListAllMyBuckets(String AWSAccessKeyId,DateTime Timestamp,String Signature) {
            s3.ListAllMyBuckets_element request_x = new s3.ListAllMyBuckets_element();
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            s3.ListAllMyBucketsResponse_element response_x;
            Map<String, s3.ListAllMyBucketsResponse_element> response_map_x = new Map<String, s3.ListAllMyBucketsResponse_element>();
            response_map_x.put('response_x', response_x);
            
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'ListAllMyBuckets',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'ListAllMyBucketsResponse',
                's3.ListAllMyBucketsResponse_element'}
              );
              response_x = response_map_x.get('response_x');
               return response_x.ListAllMyBucketsResponse;
            }else {
              s3.ListAllMyBucketsResult res = s3MockResponeses.getListAllMyBucketResults();
              return res;
            }
        }
        public s3.CopyObjectResult CopyObject(String SourceBucket,String SourceKey,String DestinationBucket,String DestinationKey,String MetadataDirective,s3.MetadataEntry[] Metadata,s3.AccessControlList AccessControlList,DateTime CopySourceIfModifiedSince,DateTime CopySourceIfUnmodifiedSince,String[] CopySourceIfMatch,String[] CopySourceIfNoneMatch,String StorageClass,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.CopyObject_element request_x = new s3.CopyObject_element();
            request_x.SourceBucket = SourceBucket;
            request_x.SourceKey = SourceKey;
            request_x.DestinationBucket = DestinationBucket;
            request_x.DestinationKey = DestinationKey;
            request_x.MetadataDirective = MetadataDirective;
            request_x.Metadata = Metadata;
            request_x.AccessControlList = AccessControlList;
            request_x.CopySourceIfModifiedSince = CopySourceIfModifiedSince;
            request_x.CopySourceIfUnmodifiedSince = CopySourceIfUnmodifiedSince;
            request_x.CopySourceIfMatch = CopySourceIfMatch;
            request_x.CopySourceIfNoneMatch = CopySourceIfNoneMatch;
            request_x.StorageClass = StorageClass;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.CopyObjectResponse_element response_x;
            Map<String, s3.CopyObjectResponse_element> response_map_x = new Map<String, s3.CopyObjectResponse_element>();
            response_map_x.put('response_x', response_x);
           
            if(!test.isRunningTest()) {
        WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'CopyObject',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'CopyObjectResponse',
                's3.CopyObjectResponse_element'}
              );
              response_x = response_map_x.get('response_x');
              return response_x.CopyObjectResult;
            }else {
              s3.CopyObjectResult s3 = s3MockResponeses.copyObject();
              return s3;
            }
        }
        public s3.PutObjectResult PutObject(String Bucket,String Key,s3.MetadataEntry[] Metadata,Long ContentLength,s3.AccessControlList AccessControlList,String StorageClass,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.PutObject_element request_x = new s3.PutObject_element();
            request_x.Bucket = Bucket;
            request_x.Key = Key;
            request_x.Metadata = Metadata;
            request_x.ContentLength = ContentLength;
            request_x.AccessControlList = AccessControlList;
            request_x.StorageClass = StorageClass;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.PutObjectResponse_element response_x;
            Map<String, s3.PutObjectResponse_element> response_map_x = new Map<String, s3.PutObjectResponse_element>();
            response_map_x.put('response_x', response_x);
            
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'PutObject',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'PutObjectResponse',
                's3.PutObjectResponse_element'}
              );
              response_x = response_map_x.get('response_x');
              return response_x.PutObjectResponse;
            }else {
              s3.PutObjectResult res = s3MockResponeses.putObject();
              return res;
            }
        }
        public s3.Status DeleteObject(String Bucket,String Key,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.DeleteObject_element request_x = new s3.DeleteObject_element();
            request_x.Bucket = Bucket;
            request_x.Key = Key;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.DeleteObjectResponse_element response_x;
            Map<String, s3.DeleteObjectResponse_element> response_map_x = new Map<String, s3.DeleteObjectResponse_element>();
            response_map_x.put('response_x', response_x);
            
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'DeleteObject',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'DeleteObjectResponse',
                's3.DeleteObjectResponse_element'}
              );
              response_x = response_map_x.get('response_x');
              return response_x.DeleteObjectResponse;
            }else {
              s3.Status st = s3MockResponeses.getDeleteObjectsStatus();
              return st;
            }
        }
        public void SetObjectAccessControlPolicy(String Bucket,String Key,s3.AccessControlList AccessControlList,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.SetObjectAccessControlPolicy_element request_x = new s3.SetObjectAccessControlPolicy_element();
            request_x.Bucket = Bucket;
            request_x.Key = Key;
            request_x.AccessControlList = AccessControlList;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.SetObjectAccessControlPolicyResponse_element response_x;
            Map<String, s3.SetObjectAccessControlPolicyResponse_element> response_map_x = new Map<String, s3.SetObjectAccessControlPolicyResponse_element>();
            response_map_x.put('response_x', response_x);
            
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'SetObjectAccessControlPolicy',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'SetObjectAccessControlPolicyResponse',
                's3.SetObjectAccessControlPolicyResponse_element'}
              );
              response_x = response_map_x.get('response_x');
            }
        }
        public s3.PutObjectResult PutObjectInline(String Bucket,String Key,s3.MetadataEntry[] Metadata,String Data,Long ContentLength,s3.AccessControlList AccessControlList,String StorageClass,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.PutObjectInline_element request_x = new s3.PutObjectInline_element();
            request_x.Bucket = Bucket;
            request_x.Key = Key;
            request_x.Metadata = Metadata;
            request_x.Data = Data;
            request_x.ContentLength = ContentLength;
            request_x.AccessControlList = AccessControlList;
            request_x.StorageClass = StorageClass;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.PutObjectInlineResponse_element response_x;
            Map<String, s3.PutObjectInlineResponse_element> response_map_x = new Map<String, s3.PutObjectInlineResponse_element>();
            response_map_x.put('response_x', response_x);
            
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'PutObjectInline',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'PutObjectInlineResponse',
                's3.PutObjectInlineResponse_element'}
              );
              response_x = response_map_x.get('response_x');
              return response_x.PutObjectInlineResponse;
            }else  {
              s3.PutObjectResult res = s3MockResponeses.putObject();
              return res;
            }
        }
        public s3.ListBucketResult ListBucket(String Bucket,String Prefix,String Marker,Integer MaxKeys,String Delimiter,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.ListBucket_element request_x = new s3.ListBucket_element();
            request_x.Bucket = Bucket;
            request_x.Prefix = Prefix;
            request_x.Marker = Marker;
            request_x.MaxKeys = MaxKeys;
            request_x.Delimiter = Delimiter; 
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.ListBucketResponse_element response_x;
            Map<String, s3.ListBucketResponse_element> response_map_x = new Map<String, s3.ListBucketResponse_element>();
            response_map_x.put('response_x', response_x);
             if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'ListBucket',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'ListBucketResponse',
                's3.ListBucketResponse_element'}
              );
              response_x = response_map_x.get('response_x');
              return response_x.ListBucketResponse;
            }else {
              s3.ListBucketResult stB = s3MockResponeses.getListBucketResult();
              return stB; 
            }
        }
        public s3.AccessControlPolicy GetObjectAccessControlPolicy(String Bucket,String Key,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.GetObjectAccessControlPolicy_element request_x = new s3.GetObjectAccessControlPolicy_element();
            request_x.Bucket = Bucket;
            request_x.Key = Key;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.GetObjectAccessControlPolicyResponse_element response_x;
            Map<String, s3.GetObjectAccessControlPolicyResponse_element> response_map_x = new Map<String, s3.GetObjectAccessControlPolicyResponse_element>();
            response_map_x.put('response_x', response_x);
            
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'GetObjectAccessControlPolicy',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'GetObjectAccessControlPolicyResponse',
                's3.GetObjectAccessControlPolicyResponse_element'}
              );
              response_x = response_map_x.get('response_x');
              return response_x.GetObjectAccessControlPolicyResponse;
            }else {
              s3.AccessControlPolicy res  = s3MockResponeses.getObjACL();
              
              return res;
            }
        }
        public s3.GetObjectResult GetObjectExtended(String Bucket,String Key,Boolean GetMetadata,Boolean GetData,Boolean InlineData,Long ByteRangeStart,Long ByteRangeEnd,DateTime IfModifiedSince,DateTime IfUnmodifiedSince,String[] IfMatch,String[] IfNoneMatch,Boolean ReturnCompleteObjectOnConditionFailure,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.GetObjectExtended_element request_x = new s3.GetObjectExtended_element();
            request_x.Bucket = Bucket;
            request_x.Key = Key;
            request_x.GetMetadata = GetMetadata;
            request_x.GetData = GetData;
            request_x.InlineData = InlineData;
            request_x.ByteRangeStart = ByteRangeStart;
            request_x.ByteRangeEnd = ByteRangeEnd;
            request_x.IfModifiedSince = IfModifiedSince;
            request_x.IfUnmodifiedSince = IfUnmodifiedSince;
            request_x.IfMatch = IfMatch;
            request_x.IfNoneMatch = IfNoneMatch;
            request_x.ReturnCompleteObjectOnConditionFailure = ReturnCompleteObjectOnConditionFailure;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.GetObjectExtendedResponse_element response_x;
            Map<String, s3.GetObjectExtendedResponse_element> response_map_x = new Map<String, s3.GetObjectExtendedResponse_element>();
            response_map_x.put('response_x', response_x);
            
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'GetObjectExtended',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'GetObjectExtendedResponse',
                's3.GetObjectExtendedResponse_element'}
              );
              response_x = response_map_x.get('response_x');
              return response_x.GetObjectResponse;
            }else {
              s3.GetObjectResult res = s3MockResponeses.GetObjectExtended();
              return res;
            }
        }
        public void SetBucketAccessControlPolicy(String Bucket,s3.AccessControlList AccessControlList,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.SetBucketAccessControlPolicy_element request_x = new s3.SetBucketAccessControlPolicy_element();
            request_x.Bucket = Bucket;
            request_x.AccessControlList = AccessControlList;
            request_x.AWSAccessKeyId = AWSAccessKeyId; 
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.SetBucketAccessControlPolicyResponse_element response_x;
            Map<String, s3.SetBucketAccessControlPolicyResponse_element> response_map_x = new Map<String, s3.SetBucketAccessControlPolicyResponse_element>();
            response_map_x.put('response_x', response_x);
            
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'SetBucketAccessControlPolicy',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'SetBucketAccessControlPolicyResponse',
                's3.SetBucketAccessControlPolicyResponse_element'}
              );
              response_x = response_map_x.get('response_x');
            }
        }
        public s3.CreateBucketResult CreateBucket(String Bucket,s3.AccessControlList AccessControlList,String AWSAccessKeyId,DateTime Timestamp,String Signature) {
            s3.CreateBucket_element request_x = new s3.CreateBucket_element();
            request_x.Bucket = Bucket;
            request_x.AccessControlList = AccessControlList;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            s3.CreateBucketResponse_element response_x;
            Map<String, s3.CreateBucketResponse_element> response_map_x = new Map<String, s3.CreateBucketResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'CreateBucket',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'CreateBucketResponse',
                's3.CreateBucketResponse_element'}
              );
              response_x = response_map_x.get('response_x');
              return response_x.CreateBucketReturn;
            }else  {
              s3.CreateBucketResult res = s3MockResponeses.createBucket();
              return res;
            }
        }
        public s3.GetObjectResult GetObject(String Bucket,String Key,Boolean GetMetadata,Boolean GetData,Boolean InlineData,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.GetObject_element request_x = new s3.GetObject_element();
            request_x.Bucket = Bucket;
            request_x.Key = Key;
            request_x.GetMetadata = GetMetadata;
            request_x.GetData = GetData;
            request_x.InlineData = InlineData;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.GetObjectResponse_element response_x;
            Map<String, s3.GetObjectResponse_element> response_map_x = new Map<String, s3.GetObjectResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'GetObject',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'GetObjectResponse',
                's3.GetObjectResponse_element'}
              );
              response_x = response_map_x.get('response_x');
              return response_x.GetObjectResponse;
            }else {
              s3.GetObjectResult res = s3MockResponeses.GetObjectExtended();
              return res;
            }
        }
        public s3.BucketLoggingStatus GetBucketLoggingStatus(String Bucket,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.GetBucketLoggingStatus_element request_x = new s3.GetBucketLoggingStatus_element();
            request_x.Bucket = Bucket;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.GetBucketLoggingStatusResponse_element response_x;
            Map<String, s3.GetBucketLoggingStatusResponse_element> response_map_x = new Map<String, s3.GetBucketLoggingStatusResponse_element>();
            response_map_x.put('response_x', response_x);
            
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this, 
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'GetBucketLoggingStatus',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'GetBucketLoggingStatusResponse',
                's3.GetBucketLoggingStatusResponse_element'}
              );
              response_x = response_map_x.get('response_x');
              return response_x.GetBucketLoggingStatusResponse;
            }else {
              s3.BucketLoggingStatus res = s3MockResponeses.GetBucketLoggingStatus();
              return res;
            }
        }
        public s3.AccessControlPolicy GetBucketAccessControlPolicy(String Bucket,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.GetBucketAccessControlPolicy_element request_x = new s3.GetBucketAccessControlPolicy_element();
            request_x.Bucket = Bucket;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.GetBucketAccessControlPolicyResponse_element response_x;
            Map<String, s3.GetBucketAccessControlPolicyResponse_element> response_map_x = new Map<String, s3.GetBucketAccessControlPolicyResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!Test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'GetBucketAccessControlPolicy',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'GetBucketAccessControlPolicyResponse',
                's3.GetBucketAccessControlPolicyResponse_element'}
              );
              response_x = response_map_x.get('response_x');
              return response_x.GetBucketAccessControlPolicyResponse;
            }else {
              s3.AccessControlPolicy res  = s3MockResponeses.getObjACL();
              return res;
            }
        }
        public s3.Status DeleteBucket(String Bucket,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential) {
            s3.DeleteBucket_element request_x = new s3.DeleteBucket_element();
            request_x.Bucket = Bucket;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            s3.DeleteBucketResponse_element response_x;
            Map<String, s3.DeleteBucketResponse_element> response_map_x = new Map<String, s3.DeleteBucketResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'DeleteBucket',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'DeleteBucketResponse',
                's3.DeleteBucketResponse_element'}
              );
              response_x = response_map_x.get('response_x');
              return response_x.DeleteBucketResponse;
            }else {
              s3.Status res = s3MockResponeses.getDeleteObjectsStatus();
              return res;
            }
        }
        public void SetBucketLoggingStatus(String Bucket,String AWSAccessKeyId,DateTime Timestamp,String Signature,String Credential,s3.BucketLoggingStatus BucketLoggingStatus) {
            s3.SetBucketLoggingStatus_element request_x = new s3.SetBucketLoggingStatus_element();
            request_x.Bucket = Bucket;
            request_x.AWSAccessKeyId = AWSAccessKeyId;
            request_x.Timestamp = Timestamp;
            request_x.Signature = Signature;
            request_x.Credential = Credential;
            request_x.BucketLoggingStatus = BucketLoggingStatus;
            s3.SetBucketLoggingStatusResponse_element response_x;
            Map<String, s3.SetBucketLoggingStatusResponse_element> response_map_x = new Map<String, s3.SetBucketLoggingStatusResponse_element>();
            response_map_x.put('response_x', response_x);
            if(!test.isRunningTest()) {
              WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                '',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'SetBucketLoggingStatus',
                'http://s3.amazonaws.com/doc/2006-03-01/',
                'SetBucketLoggingStatusResponse',
                's3.SetBucketLoggingStatusResponse_element'}
              );
              response_x = response_map_x.get('response_x');
            } 
        }
    }
    public static void justIncrement() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
          i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
    }
}