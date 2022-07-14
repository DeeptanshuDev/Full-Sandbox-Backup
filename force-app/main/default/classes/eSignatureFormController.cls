/**
*  Description     :   Controller class for eSignature Form Vf page used to create and save record for approve or void 
*                      details along with Digital Signature and some other infomation such as ip address, 
*                      location and device information in eSignature Recipient object. 
*  
*  Created By      :   Chirag Soni
*
*  Created Date    :   2/23/2021
*
*  Revision Logs   :   V_1.0 - Created 
**/

public without sharing class eSignatureFormController {
    
    public String iFrameurl {get; set;}
    public String errorMessage {get; set;}
    public String signatureUrl {get; set;} 
    public String documentStatus {get; set;}
    public decimal latitude { get; set; }       
    public decimal longitude { get; set; }
    public boolean isShow {get;set;}
    private String ipAddress;
    private String deviceInfo;
    private String recipientNameEmail;  
    private String eSignatureStatusId ;
    
    
    
    /**
*  
*  @description    :  Action method of eSignatureForm Vf page, this method is used to get parameters from URL and retrive 
*                     public link for art document and creates public link if not created previously.
*
*  @args           :  N/A
*
*  @return         :  Void
*
*  @revision Log   :   V_1.0 - Created 2/23/2021
* 
**/

    public pagereference fetchURLforIframe() // action method used to fetch art document public link for iframe
    { 
        /* --- Get Parameters from URL --- */
        String ArtDocumentId = ApexPages.currentPage().getparameters().get('docId');
        recipientNameEmail = (EncodingUtil.base64Decode(ApexPages.currentPage().getparameters().get('user'))).toString();
        eSignatureStatusId = ApexPages.currentPage().getparameters().get(constants.HTTP_HEADER_ID);
        /* ------------------------------- */
        //check of the associated design round is already approved
        List<eSignature_Status__c> eSignRec = [SELECT Id, Design_Round__c,Envelop_Status__c FROM eSignature_Status__c WHERE Id =: eSignatureStatusId LIMIT 1];
        //check if the eSignRec is not associated to any DRound
        
        if(eSignRec.size() > 0){
            Design_Round__c drRec = [Select Artwork_Approved__c,Approval_Till_Date__c FROM Design_Round__c WHERE Id =: eSignRec[0].Design_Round__c];
            system.debug('*************************************'+drRec);
            //if user has already approved the esignature
            if(drRec.Artwork_Approved__c){
                
                return Page.eSignatureFormResponsePageApproved;
            }
            
    
            
            //if date has expired to approved the esignature
            if(drRec.Approval_Till_Date__c < date.Today()){
                
                return Page.eSignatureFormResponsePageExpired;
            }
        }
        else{
            //need to creat a new page to show that dround not associated
            return Page.eSignatureFormResponsePageExpired;
        }
        
       

        if(String.isNotBlank(ArtDocumentId))
        {
             //check of the file not available
            List<ContentVersion> cvRec = [Select Id FROM ContentVersion WHERE Id =: ArtDocumentId LIMIT 1];

            system.debug('Size: ' + cvRec.size());
            system.debug('cvRec: ' + cvRec);
            if(cvRec == null || cvRec.size() <= 0) {

                return Page.eSignatureFormResponsePageFileMissing;
            }

            if(String.isNotBlank(eSignatureStatusId)){
                List<ContentDistribution> contentDistribution =  [SELECT Id, ContentVersionId, DistributionPublicUrl 
                                                                  FROM ContentDistribution 
                                                                  WHERE ContentVersionId =:ArtDocumentId]; 
                
                if(contentDistribution.size() > 0) {
                    iFrameurl = contentDistribution[0].DistributionPublicUrl;
                }
                else {
                    ContentDistribution newContentDistribution = new ContentDistribution();
                    newContentDistribution.ContentVersionId = ArtDocumentId;
                    newContentDistribution.Name = 'eSignature Document Link';
                    newContentDistribution.PreferencesNotifyOnVisit = false;
                    newContentDistribution.PreferencesAllowViewInBrowser = true;
                    newContentDistribution.PreferencesAllowOriginalDownload=true;
                    insert newContentDistribution;
                    List<ContentDistribution>  listOfContentDistribution =  [SELECT Id, ContentVersionId, DistributionPublicUrl 
                                                                             FROM ContentDistribution 
                                                                             WHERE ContentVersionId =:ArtDocumentId ];
                    iFrameurl = listOfContentDistribution[0].DistributionPublicUrl;
                }
                eSignatureUpdatesFromSite.updateLastViewedAndEnevlopStatus(eSignatureStatusId);
            }
        }

        return null;
    }
    
    /**
*  
*  @description    :  Method used to create eSignature Recipient record with approve or void details and signature 
*                     image as an attachment on  eSignature status and redirects to response page if succeed.                       
*
*  @args           :  N/A
*
*  @return         :  Page reference (eSignatureFormResponsePage) if succeed else null.
*
*  @revision Log   :   V_1.0 - Created 2/23/2021
* 
**/
    
    public pagereference saveSignatureAndSubmit() {
        
        List<String> recipientNameAndEmail = new List<String>();
        
        if(String.isNotBlank(recipientNameEmail))
            recipientNameAndEmail = recipientNameEmail.split(':');
        
        eSignature_Recipient__c eSignatureRecipient;
        
        try{
            
            /* ---Get Ip Address --- */
            ipAddress = ApexPages.currentPage().getHeaders().get(Constants.TRUE_CLIENT_IP);
            if (ipAddress == '' || ipAddress == null) {
                ipAddress = ApexPages.currentPage().getHeaders().get(Constants.X_SALESFORCE_SIP);
            } 
            else {
                ipAddress = ApexPages.currentPage().getHeaders().get(Constants.X_FORWARDED_FOR);
            }
            /*---------------------*/
            
            // --- Get Device Info --- //
            deviceInfo = ApexPages.currentPage().getHeaders().get(Constants.USER_AGENT);
            /*------------------------*/ 
            
            Attachment eSignatureAttachment = new Attachment();
            eSignatureAttachment.ParentID = eSignatureStatusId;
            eSignatureAttachment.Body = EncodingUtil.base64Decode(signatureUrl);
            eSignatureAttachment.contentType = 'image/jpg';
            String imageName = recipientNameAndEmail.size() > 0 ?recipientNameAndEmail[0]+'.jpg' : 'Art Approval'+'.jpg';   
            eSignatureAttachment.Name = imageName.replaceAll(' ','_');
            
            insert eSignatureAttachment;  
            
            if(documentStatus == 'Approved'){
                eSignatureRecipient = new eSignature_Recipient__c (
                    Recipient_Name__c = recipientNameAndEmail.size() > 0 ? recipientNameAndEmail[0] : '',
                    Recipient_Email__c = recipientNameAndEmail.size() > 0 ? recipientNameAndEmail[1] : '',
                    Recipient_Status__c = 'Approved',
                    eSignature_Status__c = eSignatureStatusId,
                    Approved_Date__c = DateTime.now(),
                    Document_Approved__c = true,
                    Device_Info__c  = deviceInfo,
                    Device_IP_Address__c = ipAddress,
                    Recipient_Location__latitude__s = latitude,
                    Recipient_Location__longitude__s = longitude
                );
                insert eSignatureRecipient;

                updateDesigns(eSignatureStatusId);
                try{
                PostChatter(eSignatureStatusId);
                }
                catch(Exception e){
                    System.debug('Exception occured : '+e);
                    return Page.eSignatureFormResponsePage;
                }

                
            }
            
            
            return Page.eSignatureFormResponsePage;
        }
        catch(Exception ex){
            errorMessage = ex.getMessage()+' Please try after some time';
            return null;
        }
    }
    //added by Seemu Saikia
    @future(callout = true)
    public static void PostChatter(Id eSignID) {
        AuthSetting__c authSetting = [SELECT CLIENT_ID__c, CLIENT_SECRET__c,End_Point__c, PASSWORD__c, USERNAME__c FROM AuthSetting__c];
        HttpRequest httpRequest = new HttpRequest();
        Http http = new Http();
        HttpResponse httpResponse;
        Map<String, Object> response;
        String instance_url;
        String access_token;

        List<eSignature_Status__c> rec = [Select Id,Design_Round__c,Design_Round__r.Design_Request__c, Design_Round__r.Design_Request__r.Assigned_Designer__c,Design_Round__r.Design_Request__r.OwnerId  from eSignature_Status__c where Id =: eSignID LIMIT 1];

        String mentionUserId = String.valueOf(rec[0].Design_Round__r.Design_Request__r.Assigned_Designer__c);
        
        String mentionOwnerId = String.valueOf(rec[0].Design_Round__r.Design_Request__r.OwnerId);

        String postOnRecordId = String.valueOf(rec[0].Design_Round__r.Design_Request__c);
        
        String reqBody = 'grant_type=password' +
                         '&client_id='+authSetting.CLIENT_ID__c+
                         '&client_secret='+authSetting.CLIENT_SECRET__c+
                         '&username='+authSetting.USERNAME__c +
                         '&password='+authSetting.PASSWORD__c;
        
        httpRequest.setMethod('POST');   
        httpRequest.setBody(reqBody);
        httpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        httpRequest.setEndpoint(authSetting.End_Point__c);  
        
        if(Test.isRunningTest())
        {
            httpResponse = new HttpResponse();
            httpResponse.setStatusCode(200);
            httpResponse.setHeader('Content-Type', 'application/json;charset=UTF-8');
             String reqBody1 = '{'+'"access_token": "00D050000008aZM!AQoAQP_2PxMJfGNDSeJW.A.ketAfgcHAW6oRPof4wyZfVc4F8QJFON6qmDRZnp85zP.F9uu4uvSTtapjfZvbj8DUI.Cco1eA",'+
                                '"instance_url": "https://rebelathletic--full.my.salesforce.com",'+
                                '"id": "https://test.salesforce.com/id/00D050000008aZMEAY/0051C000008OvWeQAK",'+
                                '"token_type": "Bearer",'+
                                '"issued_at": "1622820748241",'+
                                '"signature": "5O2JRGbmO+J2fBqTRAwZMnuUe7mAqL8xk2TgtTAn1CM="'+'}';  
            httpResponse.setBody(reqBody1);
        }
        else{
            httpResponse = http.send(httpRequest);  
        }
        system.debug('response code --'+httpResponse.getStatusCode());
        if (httpResponse.getStatusCode() == 200 ) {  
            response = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody());  
            instance_url = (String)response.get('instance_url');
            access_token = (String)response.get('access_token');
        } else {  
            System.debug(' httpResponse ' + httpResponse.getBody() );  
        }
        System.debug(' ** response ** : ' + response );  
        
        httpRequest = new HttpRequest();  
        String requestBody = '';
        httpRequest.setMethod('POST');   
        httpRequest.setEndpoint(instance_url + '/services/data/v51.0/chatter/feed-elements');  
        httpRequest.setHeader('Authorization', 'Bearer ' + access_token);
        httpRequest.setHeader('Content-Type', 'application/json');
        system.debug('mention user '+mentionUserId);
        if(mentionUserId != null){
            requestBody = '{"body":{"messageSegments":[{"type" : "Mention","id" : "'+mentionUserId+'"},'+'{"type":"Text","text":"   "}'+',{"type" : "Mention","id" : "'+mentionOwnerId+'"}'+',{"type":"Text","text":" This AA has been approved successfully."}]},"feedElementType":"FeedItem","subjectId":"'+postOnRecordId+'"}';
        }
        else{
             requestBody = '{"body":{"messageSegments":[{"type" : "Mention","id" : "'+mentionOwnerId+'"}'+',{"type":"Text","text":" This AA has been approved successfully."}]},"feedElementType":"FeedItem","subjectId":"'+postOnRecordId+'"}';
        
        }
        httpRequest.setBody(requestBody);
        system.debug('Request Body : '+httpRequest.getBody());
        http = new Http();   
        if(Test.isRunningTest())
        {
            httpResponse = new HttpResponse();
            httpResponse.setStatusCode(200);
            httpResponse.setHeader('Content-Type', 'text/json');
             String requestBody1 = '{"body":{"messageSegments":[{"type" : "Mention","id" : "'+mentionOwnerId+'"}'+',{"type":"Text","text":" This AA has been approved successfully."}]},"feedElementType":"FeedItem","subjectId":"'+postOnRecordId+'"}';
        
            httpResponse.setBody(requestBody1);
        }
        else{
            try{
        httpResponse = http.send(httpRequest);  
            }catch(Exception e){
                system.debug('ex message--'+e.getMessage());
            }
        }
        system.debug('httpResponse.getStatusCode()--'+httpResponse.getStatusCode());
        if (httpResponse.getStatusCode() == 200 ) {  
            System.debug(' ** response ** : ---' + JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody()) ));  
        } else {  
            System.debug(' httpResponse ' + httpResponse.getBody() );  
        }
    }
    public static void updateDesigns(Id esignId){

        system.debug('**********************************************Updating the Design ...');
        System.debug('the esignatureid aprroved one is  : ' + esignId);
        Set<Id> setCustomItemId = new Set<Id>();

        Set<Id> setStandardizedItemId = new Set<Id>();
        
        Set<Id> setUpdateDesign = new Set<Id>();
        
        List<Design__c> listUpdateDesign = new List<Design__c>();
        
        //get oppid and designRound
        List<eSignature_Status__c> listESign = [SELECT Id,Design_Round__c FROM eSignature_Status__c WHERE Id =: esignId LIMIT 1];
        System.debug('esignature status is : ' + listESign);
        List<Design_Round__c> listDesignRound = [SELECT Id,Design_Request__c,Design_Request__r.Opportunity__c FROM Design_Round__c WHERE Id =: listESign[0].Design_Round__c LIMIT 1];
		System.debug('list of design rounds are : ' + listDesignRound);
    	
        //get all custom items for opp and design request
        List<Custom_Item__c> listCustomItem = [SELECT Id,Opportunity__c,Design_Request__c FROM Custom_Item__c WHERE Design_Request__c=:listDesignRound[0].Design_Request__c AND Opportunity__c=:listDesignRound[0].Design_Request__r.Opportunity__c];

        //get all Standardized items for opp and design request
        List<Standardized_Item__c> listStandardizedItem = [SELECT Id,Opportunity__c,Design_Request__c FROM Standardized_Item__c WHERE Design_Request__c=:listDesignRound[0].Design_Request__c AND Opportunity__c=:listDesignRound[0].Design_Request__r.Opportunity__c];
        
        for(Standardized_Item__c siRec : listStandardizedItem){
            setStandardizedItemId.add(siRec.Id);
        }
        
        
        //get all custom items id
        for(Custom_Item__c ciRec : listCustomItem){
            setCustomItemId.add(ciRec.Id);
        }
system.debug('setCustomItemId--'+setCustomItemId);
        
        List<Design__c> listOftemp = [SELECT Id,Design_Request__c,Design_Round__c,Approved_Art__c,Art_Approval_Created__c,Sent_for_Approval__c FROM Design__c WHERE Design_Round__c IN: listDesignRound];
        for(Design__c obj : listOftemp)
        {
            System.debug('Design are ::::' + obj);
            System.debug('Design reqest on design are ::: ' + obj.Design_Request__c);
            System.debug('are approved are ::: ' + obj.Approved_Art__c);
            System.debug('are approved create are ::: ' + obj.Art_Approval_Created__c);
			System.debug('are approved create are ::: ' + obj.Sent_for_Approval__c);            
        }
        
        
        //get design items 
        Set<Id> setDesigns = new Set<Id>();
        for(Design__c dRec : [SELECT Id,Design_Request__c,Design_Round__c FROM Design__c WHERE Design_Request__c =:listDesignRound[0].Design_Request__c AND Design_Round__c=:listDesignRound[0].Id AND ((Art_Approval_Created__c = true) OR (Sent_for_Approval__c = true))]){
            System.debug('design are /*/**/* : ' + dRec);

            setDesigns.add(dRec.Id);

        }
        system.debug('setDesigns--'+setDesigns);
        //get design to update
        for(Design_Item__c diRec : [SELECT id,Design__c,Custom_Item__c FROM  Design_Item__c WHERE Design__c IN:setDesigns AND (Custom_Item__c IN: setCustomItemId OR Standardized_Item__c IN: setStandardizedItemId)]){
            setUpdateDesign.add(diRec.Design__c);
            
        }
		system.debug('setUpdateDesign--'+setUpdateDesign);
        for(Id designId : setUpdateDesign){
            listUpdateDesign.add(new Design__c(Id = designId, Approved_Art__c = true));
        }

        system.debug('*********listUpdateDesign******************************'+listUpdateDesign);
        if(listUpdateDesign.size() > 0){   
            update listUpdateDesign;
        }   
    }
    public void basicAuthCallout(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://rebelathletic--full.my.salesforce.com');
        req.setMethod('GET');
        
        // Specify the required user name and password to access the endpoint
        // As well as the header and header information
        
        String username = 'abhinav@rebelathletic.com.full';
        String password = 'Fexle$3312#';
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request  
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getStatusCode() + '=='+ res.getStatus());
    }
}