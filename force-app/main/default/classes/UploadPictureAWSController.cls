/**
 * @description       : 
 * @author            : Seemu Saikia
 * @group             : 
 * @last modified on  : 06-30-2021
 * @last modified by  : Seemu Saikia
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   05-12-2021   Seemu Saikia   Initial Version
**/
public with sharing class UploadPictureAWSController {
    
    //Variables
    public Id recordId;
    public Id oppId;
    
    //Properties
    public sObjectType objectName {get; set;}
    public String objectLabel{get;set;}
    public string bucketName  {get; set;}
    public string AWS_key     {get; set;}
    public string urlPrefix   {get; set;}
    public string fileName    {get; set;}
    public string secretKey   {get; set;}
    public string encodedAWS_Key {get; set;}
    public string encodedSecretKey {get; set;}   
    public string encodedBucketName {get; set;}
    public integer awsKeyLength {get; set;}
    public integer secretKeyLength  {get; set;}
    public integer bucketNameLength {get;set;}
    public string fieldAPIName {get;set;}
    public string pkgPrefix {get; set;}
    public string amazonFileURL {get;set;}
    public string amazonFileName {get;set;}
    public string deletedKeyString{get;set;}
    public boolean displayFileLoader{get;set;}
    public boolean displaySelection{get;set;}
    public List<awsWrapper> listWrapper {get;set;}
    public string updateKeyString{get;Set;}
    public String descriptionToBeUpdate{get;set;}
    public String selectedCategory{get;set;}
    public String dependentField{get;set;}
    public string extension{get;Set;}
    public String dependentVal{get;set;}
    public List<AWS_Documents__c> awsDocs;
    String gender = null;
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Boy','Boy')); 
        options.add(new SelectOption('Girl','Girl')); 
        return options;
    }
    public list<SelectOption> getCategories(){
        list<SelectOption> options = new list<SelectOption>();
        Schema.DescribeFieldResult category = AWS_Documents__c.Categories__c.getDescribe();
        List<Schema.PicklistEntry> values = category.getPicklistValues();
        options.add(new SelectOption('None','None'));
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a : values)
        { 
            options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return options;
    }
    
    public List<SelectOption> getCities()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        system.debug('selectedCategory'+selectedCategory);
        if(selectedCategory == 'RC Proto Pics')
        {       
            options.add(new SelectOption('RC Proto Pics 1','RC Proto Pics 1'));
            options.add(new SelectOption('RC Revised Proto Pics 1','RC Revised Proto Pics 1'));
            options.add(new SelectOption('RC Revised Proto Pics 2','RC Revised Proto Pics 2'));
            options.add(new SelectOption('RC Revised Proto Pics 3','RC Revised Proto Pics 3'));
            options.add(new SelectOption('RC Revised Proto Pics 4','RC Revised Proto Pics 4'));
            options.add(new SelectOption('RC Revised Proto Pics 5','RC Revised Proto Pics 5'));
        }
        else if(selectedCategory == 'RD Proto Pics')
        {       
             options.add(new SelectOption('RD Proto Pics 1','RD Proto Pics 1'));
             options.add(new SelectOption('RD Revised Proto Pics 1','RD Revised Proto Pics 1'));
            options.add(new SelectOption('RD Revised Proto Pics 2','RD Revised Proto Pics 2'));
            options.add(new SelectOption('RD Revised Proto Pics 3','RD Revised Proto Pics 3'));
            options.add(new SelectOption('RD Revised Proto Pics 4','RD Revised Proto Pics 4'));
            options.add(new SelectOption('RD Revised Proto Pics 5','RD Revised Proto Pics 5'));
        }
        else if(selectedCategory == 'PP Pics')
        {       
            options.add(new SelectOption('PP Pics 1','PP Pics 1'));
            options.add(new SelectOption('Revised PP Pics 1','Revised PP Pics 1'));
            options.add(new SelectOption('Revised PP Pics 2','Revised PP Pics 2'));
            options.add(new SelectOption('Revised PP Pics 3','Revised PP Pics 3'));
            options.add(new SelectOption('Revised PP Pics 4','Revised PP Pics 4'));
            options.add(new SelectOption('Revised PP Pics 5','Revised PP Pics 5'));
        }
        else if(selectedCategory == 'Dyesub Strike Off')
        {       
           options.add(new SelectOption('Dye-Sub Strike Off 1','Dye-Sub Strike Off 1'));
            options.add(new SelectOption('Revised Dye-Sub Strike Off 1','Revised Dye-Sub Strike Off 1'));
            options.add(new SelectOption('Revised Dye-Sub Strike Off 2','Revised Dye-Sub Strike Off 2'));
            options.add(new SelectOption('Revised Dye-Sub Strike Off 3','Revised Dye-Sub Strike Off 3'));
            options.add(new SelectOption('Revised Dye-Sub Strike Off 4','Revised Dye-Sub Strike Off 4'));
            options.add(new SelectOption('Revised Dye-Sub Strike Off 5','Revised Dye-Sub Strike Off 5'));
        }
        else if(selectedCategory == 'Inspiration Pics - Proto Phase')
        {       
            options.add(new SelectOption('Inspiration Pics - Proto Phase Revision Round 1','Inspiration Pics - Proto Phase Revision Round 1'));
            options.add(new SelectOption('Inspiration Pics - Proto Phase Revision Round 2','Inspiration Pics - Proto Phase Revision Round 2'));
            options.add(new SelectOption('Inspiration Pics - Proto Phase Revision Round 3','Inspiration Pics - Proto Phase Revision Round 3'));
            options.add(new SelectOption('Inspiration Pics - Proto Phase Revision Round 4','Inspiration Pics - Proto Phase Revision Round 4'));
            options.add(new SelectOption('Inspiration Pics - Proto Phase Revision Round 5','Inspiration Pics - Proto Phase Revision Round 5'));
        }
        else if(selectedCategory == 'Inspiration Pics - Art Phase')
        {       
            options.add(new SelectOption('Inspiration Pics Art Phase - Revision Round 1','Inspiration Pics Art Phase - Revision Round 1'));
            options.add(new SelectOption('Inspiration Pics Art Phase - Revision Round 2','Inspiration Pics Art Phase - Revision Round 2'));
            options.add(new SelectOption('Inspiration Pics Art Phase - Revision Round 3','Inspiration Pics Art Phase - Revision Round 3'));
            options.add(new SelectOption('Inspiration Pics Art Phase - Revision Round 4','Inspiration Pics Art Phase - Revision Round 4'));
            options.add(new SelectOption('Inspiration Pics Art Phase - Revision Round 5','Inspiration Pics Art Phase - Revision Round 5'));
        }
        else if(selectedCategory == 'Remake/Rework')
        {       
            
        }
          
        return options;
    }       
    public String getGender() {
        return gender;
    }

    public void setGender(String gender) { this.gender = gender; }

    public Boolean protoSelection{get;set;}
    public Boolean showNoRecordsSection{get;set;}

        
    //Initilize Constructer
    public UploadPictureAWSController() {
        //Load defaults   
        inIt();  
     awsDocs = new List<AWS_Documents__c>(); 
    }
    
    //Method to load defaults
    public void inIt() { 
        this.displaySelection = true;
 		
        //initilize package prefix
        pkgPrefix = '';
        
        //Getting current records Id and name
        recordId = ApexPages.currentPage().getParameters().get('Id');
        //oppId = ApexPages.currentPage().getParameters().get('oppId');
        
        //get the Documents
        fetchS3Documents(recordId);

        //Object Name   
        objectName =  recordId.getSobjectType();
        objectLabel = recordId.getSobjectType().getDescribe().getLabel();
        
        //query through custom setting to get the keys , bucket name and local server path
        List<S3_Defaults__c> s3Defaults = [Select Id, AWS_Access_Key__c, AWS_Secret_Key__c, Bucket_Name__c, File_Name__c, File_Path__c,
                                           Package_Prefix__c From  S3_Defaults__c LIMIT 1];
        
        //check for list size
        if(s3Defaults.size() >0) {
            secretKey = s3Defaults[0].AWS_Secret_Key__c; // Get Aws secret key
            AWS_key =   s3Defaults[0].AWS_Access_Key__c; // Get Aws Access key
            bucketName = s3Defaults[0].Bucket_Name__c; //Get Aws bucket name
            urlPrefix = s3Defaults[0].File_Path__c;//Location of the file where php file is placed
            fileName = s3Defaults[0].File_Name__c; //php file name
            pkgPrefix = s3Defaults[0].Package_Prefix__c ;//package prefix
        }

        /* Process to get the api name of the feild , which is going to be  parent of aws_document */
        //Describe aws_documnts record to get the field map
        Schema.DescribeSObjectResult describeObjResult = AWS_Documents__c.sObjectType.getDescribe();
        
        //describe feilds and create map 
        Map<string,Schema.SObjectField> fielsMap = describeObjResult.fields.getMap();
        
        //map to hold the feild all its describe results
        Map<string,Schema.DescribeFieldResult>  MapFieldWithDescribeResults = new Map<string,Schema.DescribeFieldResult>();
        
        //loop through feilds to describe all feild
        for(string field : fielsMap.keySet()) {
            
            // schema methods to describe fields  
            Schema.DescribeFieldResult dr = fielsMap.get(field).getDescribe();  
            
            //map to hold feild with all its describe results
            MapFieldWithDescribeResults.put(field,dr);
        } 
        
        //loop on describe values 
        for(Schema.DescribeFieldResult fieldValue : MapFieldWithDescribeResults.values()) {
            
            //List of sobject toReference field     
            List<sObjectType> refField  = fieldValue.getReferenceTo();
            
            if(refField.size() > 0) {
                
                //Loop through sobject list
                for(sObjectType sO :  refField) {
                    
                    //check if object name is equal to reference feild
                    if(sO == objectName) {
                        
                        //hold that feilds api name 
                        fieldAPIName =   fieldValue.getName();
                        
                    }
                }
            }
        }
        
        /*[Encryption]Create encoding paqrameter for php file to get when local server hits*/
        //AES crypto keyKEY
        Blob cryptoKey = EncodingUtil.base64Decode('mRMjHmlC1C+1L/Dkz8EJuw==');  
        
        //AES initialization vector     
        blob iV = EncodingUtil.base64Decode('mJvcYX94Y9+K/w17qdAb2Q==');
        
        // Encrypt the data with initialization vector
        Blob encryptedAWS_KeyData = Crypto.encrypt('AES128',cryptoKey,iV  ,blob.valueOf(AWS_key));
        
        Blob encryptedSecretKeyData = Crypto.encrypt('AES128',cryptoKey,iV,blob.valueOf(secretKey)); 
        
        Blob encryptedBucketNameData = Crypto.encrypt('AES128',cryptoKey, iV,blob.valueOf(bucketName));
        
        //convert blob into string
        encodedAWS_Key = EncodingUtil.base64Encode(encryptedAWS_KeyData);         
        encodedSecretKey = EncodingUtil.base64Encode(encryptedSecretKeyData); 
        encodedBucketName = EncodingUtil.base64Encode(encryptedBucketNameData);
        
        //get length of all three parameters using to hit local server
        awsKeyLength = AWS_key.length();
        secretKeyLength = secretKey.length();
        bucketNameLength = bucketName.length(); 
    }  
    
    //Method is used to create the S3 doc record after file uplaod in amazon
    public void createS3DocRec() {
        //List of aws document
        List<AWS_Documents__c> awsDocToBeDelete = new List<AWS_Documents__c>();
        
        ///Checking for string not blank
        if(string.isNotBlank(amazonFileURL) && string.isNotBlank(amazonFileName)) {
            
            //Checking if any file exist with the same name  delete
            awsDocToBeDelete = [Select Id, File_Name__c From AWS_Documents__c WHERE File_Name__c =: amazonFileName];
                        

            //Delete existing rec
            if(awsDocToBeDelete.size() >0)
                delete awsDocToBeDelete;
            

            //Updated by Saurabh Kumar on 08/13/2020
            String fileType = amazonFileName.substringAfterLast('.');
            //get opportunity for Design Request
            List<Design_Request__c> recDR = [SELECT Id,Opportunity__c FROM Design_Request__c WHERE Id =: recordId LIMIT 1];
            
            //Create new Record of AWS Documents
            AWS_Documents__c awsDocument = new AWS_Documents__c(File_Name__c = amazonFileName, File_Link__c = amazonFileURL,
                                                                Parent_Record_Id__c = recordId, File_Type__c = fileType, Approved_Proto_Selection__c = this.protoSelection, Gender__c = this.gender,Subcategory__c = this.dependentField, Categories__c = this.selectedCategory);
            awsDocument.put(fieldAPIName, recordId);
            insert awsDocument; 

            awsDocs.add(awsDocument);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'File modified on AWS and Salesforce record created/modified.'));
        }
    }
    
   
    
    //Method to delete file when Delete link is clicked from the page
    public void deleteSelectedFile() {
        //List of Aws_Documents to be delete
        List<AWS_Documents__c> listAWSDocsToBeDelete = new List<AWS_Documents__c>();
        
        system.debug('@@@@@@@@@'+deletedKeyString);
        
        //Check for null
        if(deletedKeyString != '') {  
            
            //Cretaing key
            string recId = string.valueOf(recordId).substring(0,15);
            string recName = ApexPages.currentPage().getParameters().get('recordName');
            string filekey = objectName+'/'+recName+'/'+recId+'/'+deletedKeyString;
            system.debug('@@@@@@@@@'+filekey);
            //String oppsId = String.valueOf(oppId).subString(0, 15);
            filekey = objectLabel+'/'+recName+'/'+recId+'/'+deletedKeyString;
            system.debug('@@@filekey : '+filekey);
            filekey = 'https://rebelathletic.s3.us-east-2.amazonaws.com/' + filekey.replaceAll( '\\s+', '%20');            
            system.debug('@@@filekey : '+filekey);
            
            //Getting today's Date Time
            DateTime now = DateTime.Now(); 
            
            //Format date time into string 
            string formattednow = now.formatGmt('yyyy-MM-dd')+'T'+now.formatGmt('HH:mm:ss')+'.'+now.formatGMT('SSS')+'Z';
            
            //Create Signature
            //Canonical string
            String canonical = 'AmazonS3'+'DeleteObject'+formattednow;
            
            //Encrypt the string to get signature
            Blob bsig = Crypto.generateMac('HmacSHA1', Blob.valueOf(canonical), Blob.valueOf(secretKey));
            
            //Get signature
            String signature = EncodingUtil.base64Encode(bsig);
            
            //Initilize WSDL method 
            s3.AmazonS3 Aws3 = new s3.AmazonS3();
            
            try {
                S3.Status delObjReslt;
                if(!test.isRunningTest()){
                    
                    //Calling delete object method to delete object from    Amazon
                    delObjReslt = Aws3.DeleteObject(bucketName,filekey,AWS_key,now,signature,secretKey); 
                    
                    
                    //Check the access on ChatApp object and if not show page message
                    if( ! AWS_Documents__c.sObjectType.getDescribe().isAccessible() ){
                        
                        //adding a page message
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Insufficient read access to AWS Documents object'));
                        
                        return;
                    }
                    if(!Schema.sObjectType.AWS_Documents__c.fields.File_Link__c.isAccessible()){
                        
                        //adding a page message
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Insufficient access to fields of AWS Documents object'));
                        
                        return;
                    }
                    
                    
                    //Loop through  Aws doc to delete aws record 
                    //'https://s3.amazonaws.com/'+bucketName+'/'+filekey replaced by 'https://rebelathletic.s3.us-east-2.amazonaws.com/'+filekey
                    for(AWS_Documents__c aws : [Select Id, File_Link__c FROM AWS_Documents__c WHERE File_Link__c =: 'https://rebelathletic.s3.us-east-2.amazonaws.com/'+filekey]) {
                        listAWSDocsToBeDelete.add(aws);
                        system.debug('listAWSDocsToBeDelete :'+listAWSDocsToBeDelete);
                    }     
                    
                }else { 
                    delObjReslt = s3MockResponeses.getDeleteObjectsStatus();
                }
            }catch(exception e) {
                ApexPages.addMessages(e);     
            }                                                    
            
            
            if( ! AWS_Documents__c.sObjectType.getDescribe().isDeletable() ){
                
                //adding a page message
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Insufficient delete access to AWS Documents object'));
                
                return;
            }
            //Check size of  Aws document list
            if(listAWSDocsToBeDelete.size() >0)
                delete listAWSDocsToBeDelete;
            
            //Re-initilize list of aws document   
            listAWSDocsToBeDelete = new List<AWS_Documents__c>();   
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'File has been deleted.'));
        }
    }
    
    //Method to update mediaDescription
    public void updateMediaDescription() {
        String recId = String.valueOf(recordId).subString(0, 15);
        
        system.debug('awsDocs' +awsDocs); 
        //String oppsId = String.valueOf(oppId).subString(0, 15);
        string recName = ApexPages.currentPage().getParameters().get('recordName');
        
        string filekey = objectLabel+'/'+recName+'/'+recId+'/'+updateKeyString;
        
        filekey = filekey.replaceAll( '\\s+', '%20');
        String files = '';
        List<AWS_Documents__c> listAWSDocsToBeUpdate = new List<AWS_Documents__c>();
        
        List<String> allowedExtension = new List<String>{'jpeg','png','jpg','gif','TIFF','BMP'};
            system.debug('updateKeyString--'+updateKeyString);
        system.debug('extension--'+extension);
        system.debug('amazonFileURL---'+amazonFileURL);
        
        
        if(updateKeyString.contains('.jpeg') || updateKeyString.contains('.png') ||updateKeyString.contains('.jpg') 
           ||updateKeyString.contains('.gif') ||updateKeyString.contains('.JPG') ||updateKeyString.contains('.TIFF') ||updateKeyString.contains('.BMP') ){
               
               files = 'https://rebelathletic.s3.us-east-2.amazonaws.com//'+filekey;
           }else{
               files = 'https://rebelathletic.s3.us-east-2.amazonaws.com//'+filekey+'.'+extension;
           }
        system.debug('files ---'+files);
        //Loop through  Aws doc to update aws record 
        for(AWS_Documents__c aws : [Select Id, File_Link__c,Design_Request__c FROM AWS_Documents__c WHERE Design_Request__c =:recId AND File_Link__c =: files]) {
            aws.Description__c = descriptionToBeUpdate;
            listAWSDocsToBeUpdate.add(aws);
        }   
        
        system.debug('listAWSDocsToBeUpdate '+listAWSDocsToBeUpdate);
        //Check size of  Aws document list
        if(listAWSDocsToBeUpdate.size() >0)
            update listAWSDocsToBeUpdate;
        
        //Re-initilize list of aws document   
        listAWSDocsToBeUpdate = new List<AWS_Documents__c>();
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Description updated successfully.'));
    }
    
    //Added by Saurabh Kumar on 08/13/2020
    public PageReference closeWindow(){
        
        PageReference pr = new PageReference('/'+recordId);
        return pr;
    }

    public void hidePopup(){

        if(String.isBlank(this.gender)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please Select A Gender To Proceed.'));
        }
        else{
            this.displayFileLoader = true;
            this.displaySelection = false;
        }
        
    }

    public void fetchS3Documents(Id designRequestId){
        listWrapper = new List<awsWrapper>();
        for(AWS_Documents__c docRec : [SELECT Id,File_Name__c,Gender__c,Name,Design_Request__c,Description__c,File_Link__c FROM AWS_Documents__c WHERE Design_Request__c =: designRequestId]){

            this.listWrapper.add(new awsWrapper(docRec.Name, docRec.File_Name__c, docRec.Gender__c,docRec.Description__c,docRec.File_Link__c));
        
        }

        if(this.listWrapper.size() > 0){
            this.showNoRecordsSection = false;
        }
        else{
            this.showNoRecordsSection = true;
        }

    
    }

    public class awsWrapper {
        public string docName{get;set;}
        public string docFileName{get;set;}
        public string docGender{get;set;}
        public string docDesc{get;set;}
        public string docFileLink{get;set;}
        
        public awsWrapper(String dn, String dfn, String dg,String dd, String dfl) {
            docName = dn;
            docFileName = dfn;
            docGender = dg;
            docDesc = dd;
            docFileLink = dfl;
        }
    }
}