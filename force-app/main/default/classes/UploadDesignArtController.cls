/**
 * This class is used to upload design and create record of design round, design and design item under design request.
 */
public with sharing class UploadDesignArtController {
    
    //To get existing custom and standrard item under design request.
    @AuraEnabled
    public static List<CustomStandardizedItemWrapper> getCustomStandardizedItemsWrapper(String designRequestId) {
        
        try
        {
            if(String.isNotBlank(designRequestId))
            {
                List<Custom_Item__c> customItems = [Select Id, Name, Item_Number_Edit__c, Gender__c From Custom_Item__c where Design_Request__c =: designRequestId];
                List<Standardized_Item__c> standardizedItems = [Select Id, Product__r.Name, Product_Code__c From Standardized_Item__c where Design_Request__c =: designRequestId];
                
                List<CustomStandardizedItemWrapper> customItemWrappers = new List<CustomStandardizedItemWrapper>();
                if(customItems.size() > 0)
                {
                    for(Custom_Item__c customItem : customItems)
                    {
                        CustomStandardizedItemWrapper customItemWrapper = new CustomStandardizedItemWrapper(customItem.Id, customItem.Item_Number_Edit__c, customItem.Gender__c, customItem.Name, 'Custom');
                        customItemWrappers.add(customItemWrapper);
                    } 
                }
                if(standardizedItems.size() > 0)
                {
                    for(Standardized_Item__c standardizedItem : standardizedItems)
                    {
                        CustomStandardizedItemWrapper customItemWrapper = new CustomStandardizedItemWrapper(standardizedItem.Id, standardizedItem.Product_Code__c, '', standardizedItem.Product__r.Name, 'Standardized');
                        customItemWrappers.add(customItemWrapper);
                    }
                }
                if(customItemWrappers.size() > 0)
                {
                    return customItemWrappers;
                }
                else 
                {
                    return null;    
                }  
            }
            else
            {
                return null;
            }
        }
        catch (Exception e) 
        {
            throw new AuraHandledException('Exception occured:\r\n' + e.getMessage() + '\r\n' + e.getStackTraceString() + '\r\n'); 
        }
    }  
    //To get field deatils for design object using field set on object.
    @AuraEnabled
    public static String getFieldSet(String designObjApiName, String fieldSetForDesignObj) {
        String result = '';
        try{
            if(String.isNotBlank(designObjApiName) && String.isNotBlank(fieldSetForDesignObj))
            {
                SObjectType objToken = Schema.getGlobalDescribe().get(designObjApiName);
                Schema.DescribeSObjectResult d = objToken.getDescribe();
                Map<String, Schema.FieldSet> FsMap = d.fieldSets.getMap();
                if(FsMap.containsKey(fieldSetForDesignObj))
                    for(Schema.FieldSetMember f : FsMap.get(fieldSetForDesignObj).getFields()) {
                        if(result != ''){
                            result += ',';
                        }
                        String jsonPart = '{';
                        jsonPart += '"label":"' + f.getLabel() + '",';
                        jsonPart += '"required":"' + (f.getDBRequired() || f.getRequired()) + '",';
                        jsonPart += '"type":"' + (f.getType()) + '",';
                        jsonPart += '"name":"' + f.getFieldPath() + '"';
                        jsonPart += '}';
                        result += jsonPart;
                    }
            }
            else
            {
                return null;
            }
        }
        catch(Exception e){
            result += e.getLineNumber() + ' : ' + e.getMessage();
        }
        return '['+result+']';
    }
    //To clean up file garbage under design request.
    @AuraEnabled
    public static List<ContentDocument> cleanUp(String designRequestId, List<String> documentIds){
      
        try
        {
            if(String.isNotBlank(designRequestId) && documentIds.size() > 0)
            {
                List<ContentDocumentLink> cdls = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: designRequestId AND ContentDocument.Id IN : documentIds];
                delete cdls;
                
                List<ContentDocument> documents = [SELECT Id FROM ContentDocument WHERE Id IN :documentIds AND ParentId =:designRequestId];
                delete documents;
                List<ContentDocument> contentDocToBeUpdated = new List<ContentDocument>();
                for(ContentDocument contentDoc: [SELECT Id, Title FROM ContentDocument WHERE Id IN :documentIds])
                {
                    String title = '';
                    title+='Custom_'+contentDoc.Title;
                    contentDocToBeUpdated.add(new ContentDocument(Id = contentDoc.Id, Title = title));
                }
                if(contentDocToBeUpdated.size() > 0)
                {
                    update contentDocToBeUpdated;
                }
                return contentDocToBeUpdated;      
            }        
            else
            {
                return null;
            }
        }
        catch (Exception e) 
        {
            throw new AuraHandledException('Exception occured:\r\n' + e.getMessage() + '\r\n' + e.getStackTraceString() + '\r\n'); 
        }
    }
   
    //To create record of design round, design and design item under design request.
    @AuraEnabled
    public static List<SobjectRecordsWithError> recordsSave(String recordId, String sObjectName, String objectForDataToBeCreated,
                                                            List<List<Map<String,String>>> allDetailsOfDesignRound, 
                                                            String designObjApiName, List<List<Map<String,String>>> allDetailsOfDesign, 
                                                            List<String> selectedCustomItemsIds){
        System.debug('record id is : ' + recordId);
        System.debug('sobject name is : '+sObjectName);
        System.debug('objeect for data to be created  :' + objectForDataToBeCreated);
        System.debug('all details of design round are : ' + allDetailsOfDesignRound);
        System.debug('design object api name are : '+ designObjApiName);
        System.debug('all detail of design are : ' + allDetailsOfDesign);
        System.debug('selected custom items ids are : ' + selectedCustomItemsIds);
       
        //Describe call for specific object
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(new List<String>{sObjectName, objectForDataToBeCreated, designObjApiName});
                                                            
        Schema.SObjectType sobjType = results[1].getSobjectType();
        Map<String, Schema.SObjectField> fieldMap = results[1].fields.getMap();
      	
        //Initialize the string variable of sobject type
        String listType = 'List<' + sobjType + '>';
        Savepoint sp = Database.setSavepoint();
        //Convert sobject type
        List<SObject> sobjRecordsForMainObject = (List<SObject>)Type.forName(listType).newInstance();
       
        Set<String> setOfCustomItemNames = new Set<String>();
     	List<Custom_Item__c> customItemsToUpdate  = new List<Custom_Item__c>();
		List<Standardized_Item__c> standItems = [SELECT ID, Stage__c FROM Standardized_Item__c WHERE Id IN : selectedCustomItemsIds AND Design_Request__c =: recordId];                                                                
        List<Custom_Item__c> customItems = [SELECT ID, Item_Number__c, Gender__c, Design_Status__c, Stage__c, Product_Style_Subcategory__c FROM Custom_Item__c WHERE Id IN : selectedCustomItemsIds AND Design_Request__c =: recordId];
      	List<Design_Round__c> designs = [select id, Version__c,Gender__c,Reason_for_Revision__c,design_request__c,Account_Number__c FROM design_Round__c where design_request__c  =: recordId];
 		Boolean isCheck = false;
		Boolean ischeck2 = false;
        Boolean ischeck3 = false;
        String str = '';
        String c;
        if(String.isNotBlank(sObjectName) && allDetailsOfDesignRound.size() > 0){
            for(List<Map<String,String>> indiviualRecord :  allDetailsOfDesignRound){
                SObject newSobj = sobjType.newSObject();
                
                newSobj.put('Design_Request__c',recordId); 
                for(Design_Round__c drs : designs){   
                    System.debug('drs : ' + drs);
                    for(Map<String, String>  columnMap : indiviualRecord){
                        
                        List<String> fieldAPIWithvalue = columnMap.Values();
                        System.debug('complete value: '+ fieldAPIWithvalue);
                   
                        str =drs.Id;
                        system.debug('val '+fieldAPIWithvalue[0]);
                        system.debug('val '+fieldAPIWithvalue[1]);
                        System.debug('fieldAPIWithvalue[1] : ' + fieldAPIWithvalue[1]);
                        System.debug('drs version is  : ' + drs.Version__c);
                        if(fieldAPIWithvalue[0] == 'Version__c' ){
                            System.debug('inside fieldAPIWithvalue[0]');
                            
                            if(fieldAPIWithvalue[1] == drs.Version__c){
                                System.debug('you are inside fieldAPIWithvalue[1]00');
                                isCheck = true;
                            }else{
                                isCheck = false;
                            }
                        }
                        
                        System.debug('fieldAPIWithvalue[0] are : ' + fieldAPIWithvalue[0]);

                         if(fieldAPIWithvalue[0] == 'Gender__c' ){
                             System.debug('you are inside : ' + fieldAPIWithvalue[0]);
                             //System.assert(false,fieldAPIWithvalue[1]);
                            if(fieldAPIWithvalue[1] == drs.Gender__c){
                                //System.assert(false,'Good');
                                System.debug('you are inside fieldAPIWithvalue[1] : ' + fieldAPIWithvalue[1] );
                                ischeck2 = true;
                            }else{
                                ischeck2 = false;
                                
                            }
                        }
                        if(fieldAPIWithvalue[0] == 'Reason_for_Revision__c' ){
                            System.debug('you are inside : ' + fieldAPIWithvalue[0]);
                            c = fieldAPIWithvalue[0];
                            if(fieldAPIWithvalue[1] == drs.Reason_for_Revision__c){
                                //System.assert(false,str);
                                System.debug('you are inside fieldAPIWithvalue[1] : ' + fieldAPIWithvalue[1] );
                                ischeck3 = true;
                                
                            }else{
                                
                                ischeck3 = false;
                                
                            }
                        }
                        system.debug('value of check '+isCheck);
                        system.debug('value of check2 '+isCheck2);
                        
                        
                        if(ischeck && ischeck2 && !ischeck3)
                        {
                            //System.assert(false,fieldAPIWithvalue[0]);
                            if(fieldAPIWithvalue[0] == 'Reason_for_Revision__c' ){
                                //System.assert(false,fieldAPIWithvalue[1]);
                                //System.assert(false,drs.Reason_for_Revision__c);
                                System.debug('you are inside : ' + fieldAPIWithvalue[0]);
                                if(fieldAPIWithvalue[1] != drs.Reason_for_Revision__c){
                                    //System.assert(false,'Inside');
                                    //System.assert(false,fieldAPIWithvalue[1]);
                                    if((String.isBlank(fieldAPIWithvalue[1])) &&(drs.Reason_for_Revision__c == NULL))
                                    {
                                        //System.assert(false,'IsBlank');
                                        newSobj.put('Id', str);
                                        
                                    }
                                    else
                                    {
                                        //System.assert(false,'No in else');
                                    }
                                    
                                }
                                else
                                {
                                    //System.assert(false,'In else0');
                                    
                                }
                            }
                            
                        }
                        
                        
                    }
                    if(ischeck && ischeck2 && ischeck3){
                        //System.assert(false,str);
                        newSobj.put('Id', str); 
                        system.debug('newSobj: ' + newSobj);
                        ischeck = false;
                        ischeck2 = false;
                        ischeck3 = false;
                    }
                    
                    
                    /*if(ischeck && ischeck2 && ischeck3){
                        newSobj.put('Id', str);
                        system.debug('newSobj: ' + newSobj); 
                    }
                    
                    else if(ischeck && ischeck2 && c.length()<0)
                    {
                        newSobj.put('Id', str);
                        system.debug('newSobj: ' + newSobj); 
                    }*/
                    
                    /*for(Map<String, String>  columnMap : indiviualRecord){
                        
                        List<String> fieldAPIWithvalue = columnMap.Values();
                        System.debug('complete value: '+ fieldAPIWithvalue);
                   
                        str =drs.Id;
                        system.debug('val '+fieldAPIWithvalue[0]);
                        system.debug('val '+fieldAPIWithvalue[1]);
                        System.debug('fieldAPIWithvalue[1] : ' + fieldAPIWithvalue[1]);
                        System.debug('drs version is  : ' + drs.Version__c);
                        if(fieldAPIWithvalue[0] == 'Version__c' ){
                            System.debug('inside fieldAPIWithvalue[0]');
                            
                            if(fieldAPIWithvalue[1] == drs.Version__c){
                                System.debug('you are inside fieldAPIWithvalue[1]00');
                                isCheck = true;
                            }else{
                                isCheck = false;
                            }
                        }
                        
                        System.debug('fieldAPIWithvalue[0] are : ' + fieldAPIWithvalue[0]);

                         if(fieldAPIWithvalue[0] == 'Gender__c' ){
                             System.assert(false,'you are inside gender');
                             System.debug('you are inside : ' + fieldAPIWithvalue[0]);
                             //System.assert(false,fieldAPIWithvalue[1]);
                            if(fieldAPIWithvalue[1] == drs.Gender__c){
                                //System.assert(false,'Good');
                                System.debug('you are inside fieldAPIWithvalue[1] : ' + fieldAPIWithvalue[1] );
                                ischeck2 = true;
                            }else{
                                ischeck2 = false;
                                
                            }
                        }
                        System.assert(false,ischeck2);
                        if(fieldAPIWithvalue[0] == 'Reason_for_Revision__c' ){
                             System.debug('you are inside : ' + fieldAPIWithvalue[0]);
                            if(fieldAPIWithvalue[1] == drs.Reason_for_Revision__c){
                                System.debug('you are inside fieldAPIWithvalue[1] : ' + fieldAPIWithvalue[1] );
                                ischeck3 = true;
                            }else{
                                ischeck3 = false;
                                
                            }
                        }
                        system.debug('value of check '+isCheck);
                        system.debug('value of check2 '+isCheck2);
                        if(ischeck && ischeck2 && ischeck3){
                            
                            
                            newSobj.put('Id', str);
                            system.debug('newSobj: ' + newSobj);
                            
                        }
                        
                    }*/
                }
                    
                      
                for(Map<String, String>  columnMap : indiviualRecord){
                  
                    List<String> fieldAPIWithvalue = columnMap.Values();
                    
                    Schema.DisplayType fielddataType = fieldMap.get(fieldAPIWithvalue[0]).getDescribe().getType();
                    system.debug('fieldAPIWithvalue[0],fieldAPIWithvalue[1]) ==  '+fieldAPIWithvalue[0]+'   '+fieldAPIWithvalue[1]);
                    if(!fieldAPIWithvalue[0].equalsIgnoreCase('ID')){
                        if(fielddataType == Schema.DisplayType.String || 
                           fielddataType == Schema.DisplayType.TextArea ||
                           fielddataType == Schema.DisplayType.Id ||
                           fielddataType == Schema.DisplayType.Picklist ||
                           fielddataType == Schema.DisplayType.Reference ||
                           fielddataType == Schema.DisplayType.Phone ||
                           fielddataType == Schema.DisplayType.Email ||
                           fielddataType == Schema.DisplayType.URL){
                               system.debug('new api ss -'+fieldAPIWithvalue[0]);
                               //build your logic if the Field data type is String/TextArea/Id/Picklist/Reference/Phone/Email/URL
                               newSobj.put(fieldAPIWithvalue[0],fieldAPIWithvalue[1]);
                               
                           }
                        
                        if(fielddataType == Schema.DisplayType.Integer) {
                            //build your logic if the Field data type is Integer
                            newSobj.put(fieldAPIWithvalue[0], INTEGER.valueOf(fieldAPIWithvalue[1]));
                        }
                        
                        if(fielddataType == Schema.DisplayType.Date) {
                            //build your logic if the Field data type is Date
                            newSobj.put(fieldAPIWithvalue[0],DATE.valueOf(fieldAPIWithvalue[1]));
                        }
                        
                        if(fielddataType == Schema.DisplayType.DateTime) {
                            //build your logic if the Field data type is DateTime
                            newSobj.put(fieldAPIWithvalue[0],DATETIME.valueOf(fieldAPIWithvalue[1]));
                        }
                    }
                }
               System.debug('after newSobj : ' + newSobj);
                
                sobjRecordsForMainObject.add(newSobj); 
            }
        }
        List<Design_Round__c> listofdr = [SELECT Id, Design_Request__c FROM Design_Round__c WHERE Design_Request__c =: recordId];
        System.debug('Your design round before insertion is  : ' + listofdr);
        system.debug('sobjRecordsForMainObject---'+sobjRecordsForMainObject);
        if(sobjRecordsForMainObject.size()>0){
            sp = Database.setSavepoint();
            System.debug('record to insert or update are : ' + sobjRecordsForMainObject);
            upsert sobjRecordsForMainObject;
            //insert sobjRecordsForMainObject;
        }
        List<Design_Round__c> listofdr2 = [SELECT Id, Design_Request__c FROM Design_Round__c WHERE Design_Request__c =: recordId];
        System.debug('Your design round after insertion is  : ' + listofdr2);
        sobjType = results[2].getSobjectType();
        fieldMap = results[2].fields.getMap();
        
        //Initialize the string variable of sobject type
        listType = 'List<' + sobjType + '>';
        //Convert sobject type
        List<Sobject> sobjRecordsForInternalObject = (List<SObject>)Type.forName(listType).newInstance();
        
        List<String> docIds =  new List<String>();
        List<String> docNames = new List<String>();
        List<ContentDocumentLink> contentDocLinks = new List<ContentDocumentLink>();
        Integer count=0;
        //Check for the size and blank
        if(String.isNotBlank(designObjApiName) && allDetailsOfDesign.size() > 0){
            for(List<Map<String,String>> indiviualRecord :  allDetailsOfDesign){
                SObject newSobj = sobjType.newSObject();
                newSobj.put('Design_Request__c',recordId);
                if(sobjRecordsForMainObject.size() > 0 && String.isNotBlank(sobjRecordsForMainObject[0].Id))
                	newSobj.put('Design_Round__c',sobjRecordsForMainObject[0].Id);    
                               
                for(Map<String, String>  columnMap : indiviualRecord){
                    
                    List<String> fieldAPIWithvalue = columnMap.Values();
                   
                    if(fieldAPIWithvalue.contains('DocumentId') && String.isNotBlank(fieldAPIWithvalue[2])){
                        docIds.add(fieldAPIWithvalue[2]);
                    }
                    if(fieldAPIWithvalue.contains('DocumentName')  && String.isNotBlank(fieldAPIWithvalue[2])){
                        docNames.add(fieldAPIWithvalue[2].split('\\.')[0]);
                    }
                    
                    if((!fieldAPIWithvalue.contains('DocumentId') && !fieldAPIWithvalue.contains('DocumentName')) && String.isNotBlank(fieldAPIWithvalue[1]) && 
                       String.isNotBlank(fieldAPIWithvalue[2])){
                        system.debug('fieldAPIWithvalue--'+fieldAPIWithvalue);
                        system.debug('fieldMap--'+fieldMap);   
                        Schema.DisplayType fielddataType = fieldMap.get(fieldAPIWithvalue[1]).getDescribe().getType();
                       system.debug('field datatype '+fielddataType);
                           
                           system.debug('fieldAPIWithvalue[1] ---'+fieldAPIWithvalue[1]);
                           system.debug('fieldAPIWithvalue[2]==='+fieldAPIWithvalue[2]);

                           system.debug('customItemsToUpdate---' + customItemsToUpdate);
                        if(fielddataType == Schema.DisplayType.String || 
                           fielddataType == Schema.DisplayType.TextArea ||
                           fielddataType == Schema.DisplayType.Id ||
                           fielddataType == Schema.DisplayType.Picklist ||
                           fielddataType == Schema.DisplayType.Reference ||
                           fielddataType == Schema.DisplayType.Phone ||
                           fielddataType == Schema.DisplayType.Email ||
                           fielddataType == Schema.DisplayType.URL){
                               //build your logic if the Field data type is String
                               newSobj.put(fieldAPIWithvalue[1],fieldAPIWithvalue[2]);
                             
                           }
                       
                        if(fielddataType == Schema.DisplayType.BOOLEAN && String.isNotBlank(fieldAPIWithvalue[2])) {
                           
                            //build your logic if the Field data type is Integer
                            newSobj.put(fieldAPIWithvalue[1], Boolean.valueOf(fieldAPIWithvalue[2]));
                        }
                        
                        if(fielddataType == Schema.DisplayType.Integer && String.isNotBlank(fieldAPIWithvalue[2])) {
                            //build your logic if the Field data type is Integer
                            newSobj.put(fieldAPIWithvalue[1], INTEGER.valueOf(fieldAPIWithvalue[2]));
                        }
                        
                        if(fielddataType == Schema.DisplayType.Date  && String.isNotBlank(fieldAPIWithvalue[2])) {
                            //build your logic if the Field data type is DateTime
                            newSobj.put(fieldAPIWithvalue[1],DATE.valueOf(fieldAPIWithvalue[2]));
                        }
                        
                        if(fielddataType == Schema.DisplayType.DateTime  && String.isNotBlank(fieldAPIWithvalue[2])) {
                            //build your logic if the Field data type is DateTime
                            newSobj.put(fieldAPIWithvalue[1],DATETIME.valueOf(fieldAPIWithvalue[2]));
                        }
                    }
                }
                sobjRecordsForInternalObject.add(newSobj); 
            }
        }
        
		system.debug('sobjRecordsForInternalObject --'+sobjRecordsForInternalObject);
        //Insert Study Product records 
        if(sobjRecordsForInternalObject.size() > 0){
            
            List<SobjectRecordsWithError> sObjectRecordsWithErrors = new List<SobjectRecordsWithError>();
            Database.SaveResult[] srList = Database.insert(sobjRecordsForInternalObject, false);
            
            Integer recSequence = 0;
            Boolean errorExist = false;
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                recSequence++;
               
                system.debug('recSequence --'+recSequence);
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    SobjectRecordsWithError sObjectRecordsWithError = new SobjectRecordsWithError(String.valueOf(recSequence), '');
                    sObjectRecordsWithErrors.add(sObjectRecordsWithError);
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                        
                    }
                    
                    SobjectRecordsWithError sObjectRecordsWithError = new SobjectRecordsWithError(String.valueOf(recSequence), String.valueOf(sr.getErrors()));
                    sObjectRecordsWithErrors.add(sObjectRecordsWithError);
                    errorExist = true;
                }
            }
           system.debug('errorExist==='+errorExist);
            if(!errorExist){
                List<ContentVersion> contentVs = [SELECT ID, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN : docIds];
                Map<Id,Id> docIdWithDocVersionIds = new Map<Id,Id>();
                
                for(ContentVersion conV : contentVs){
                    if(!docIdWithDocVersionIds.containsKey(conV.ContentDocumentId))
                        docIdWithDocVersionIds.put(conV.ContentDocumentId, conV.ID);
                }
                List<Sobject> internalObjectToBeUpdated = (List<SObject>)Type.forName(listType).newInstance();
                List<Design_Item__c> designItemsToBeCreate = new List<Design_Item__c>();
                
                system.debug('sobjRecordsForInternalObject --- '+sobjRecordsForInternalObject);
                
                for(Sobject sobj: sobjRecordsForInternalObject){
                    for(Custom_Item__c customItem : customItems){
                       Design_Item__c designItem = new Design_Item__c();
                       designItem.Design__c =  sobj.Id;
                       designItem.Custom_Item__c = customItem.Id;
                       designItemsToBeCreate.add(designItem) ;
                    }
                    
                    for(Standardized_Item__c std : standItems){
                       Design_Item__c designItem = new Design_Item__c();
                       designItem.Design__c =  sobj.Id;
                       designItem.Standardized_Item__c = std.Id;
                       designItemsToBeCreate.add(designItem) ;
                    }
                }
                
                for(Sobject sobj: sobjRecordsForInternalObject){
                    ContentDocumentLink cDe = new ContentDocumentLink();
                    cDe.ContentDocumentId = docIds[count];
                    cDe.LinkedEntityId = (Id)sobj.get('Id');
                    cDe.ShareType = 'I';
                    cDe.Visibility = 'AllUsers';
                    contentDocLinks.add(cDe);
                    
                    SObject newSobj = sobjType.newSObject();
                    newSobj.put('Id',(Id)sobj.get('Id'));
                    newSobj.put('Content_Version_Id__c', docIdWithDocVersionIds.get(docIds[count]));
                    
                    internalObjectToBeUpdated.add(newSobj);
                    count++;
                    
                }
                if(internalObjectToBeUpdated.size() > 0){
                    update internalObjectToBeUpdated;
                }
                if(contentDocLinks.size() > 0){
                    insert contentDocLinks;
                } 
                List<ContentDocument> contentDocuments = [SELECT Id, Title FROM ContentDocument WHERE Id IN : docIds];
                List<ContentDocument> updatedContentDocuments = new List<ContentDocument>();
                for(ContentDocument contentDoc : contentDocuments)
                {
                    String title='Verified_';
                    title+=contentDoc.Title;
                    updatedContentDocuments.add(new ContentDocument(Id = contentDoc.Id, Title = title));
                }
                if(updatedContentDocuments.size() > 0)
                {
                    update updatedContentDocuments;
                }
                if(designItemsToBeCreate.size()>0){
                    insert designItemsToBeCreate;
                }
            }
            else{
                if(sObjectRecordsWithErrors.size() > 0)
                    Database.rollback(sp);
            }
            System.debug('sObjectRecordsWithErrors are : ' + sObjectRecordsWithErrors);
            return sObjectRecordsWithErrors;
        }
        
        return null;
    }
    //This wrapper is used to hold error with sequence.
    public class SobjectRecordsWithError {
        
        @AuraEnabled public String recSeq{get;set;}
        @AuraEnabled public String error{get;set;}
        
        public SobjectRecordsWithError(String recSeq, String error){
            this.recSeq = recSeq;
            this.error = error; 
        }      
    }
    //This wrapper is used custom and standard item deatils under design request.
    public class CustomStandardizedItemWrapper{
        
        @AuraEnabled public String id{get;set;}
        @AuraEnabled public String itemNumber{get;set;}
        @AuraEnabled public String gender{get;set;}
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String type{get;set;}
        
        public CustomStandardizedItemWrapper(String id, String itemNumber, String gender, String name, String type){
            this.id = id;
            this.itemNumber = itemNumber;
            this.gender = gender;
            this.name = name;
            this.type = type; 
        }      
    }
}