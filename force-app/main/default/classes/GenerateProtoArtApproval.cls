public class GenerateProtoArtApproval {
    
    @future (callout=true)
    public static void sendEmailToOppForApproval(List<Id> customId){
        
        List<Custom_Item__c> listNewCustomItem = [select id, Design_Status__c FROM Custom_Item__c where Id IN: customId];
        Set<Id> setCustomItemId = new Set<Id>();
        for(Custom_Item__c ci: listNewCustomItem){
            if((ci.Design_Status__c == '(P) Prototype Received and Sent to Customer') ||
               (ci.Design_Status__c == '(P) Need PP Picture Approval from Sales') ||
               (ci.Design_Status__c == '(P) Dye-Sub Strike Off Drop Shipped to Customer') ||
               (ci.Design_Status__c == '(P) Revised Proto Received and Sent to Customer')||
               (ci.Design_Status__c == '(P) Revised PP Pics Sent - Need Approval from Sales')){
                   setCustomItemId.add(ci.Id);
                   
               }
        }
system.debug('setCustomItemId --'+setCustomItemId);
        if(setCustomItemId.size() > 0){
            
            List<Design_item__c> desingItem = [SELECT  id ,  Design__r.Design_round__c From  Design_item__c WHERE Custom_item__c IN: setCustomItemId];
            
            List<string> designItemIds = new List<string>();
            Id designRoundId ;
            for(Design_item__c ids : desingItem){
                designItemIds.add(ids.id);
                designRoundId = ids.Design__r.Design_round__c ; 
            }
            system.debug('designRoundId----'+designRoundId);
            system.debug('designItemIds----'+designItemIds);
            
            PageReference pr = Page.ElectronicProtoApprovalpdf;
            pr.getParameters().put('id', designRoundId);
            pr.getParameters().put('items', String.join(designItemIds, ';'));
            pr.setRedirect(true);
           
            Blob pdfData;
            Blob boddy;
            try {
                //pdfData = pr.getContentAsPDF();
                pdfData = pr.getContentAsPDF();
            }
            catch (Exception e) {
                system.debug('exception '+e.getMessage());
                // ignore. exception will always be thrown in test context.
                pdfData = Blob.valueOf('123');
            }
            
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = 'ProtoArtApproval.pdf';//File title
            contentVersion.PathOnClient = 'ProtoArtApproval.pdf';
            contentVersion.VersionData = pdfData ;//File body (Add content or body of uploaded file)
            
            insert contentVersion;
            system.debug('@@@@@@@@' + contentVersion);
            
            //Create Chatter Post
        FeedItem feedItem = new FeedItem();
        feedItem.Body = 'Art Approval Document Generated';
        feedItem.ParentId = designRoundId; //Record Id
        
        insert feedItem;
        
        //Associate attachment to the post
        FeedAttachment feedAttachment = new FeedAttachment();
        feedAttachment.FeedEntityId = feedItem.Id;//Chatter Post Id
        feedAttachment.RecordId = contentVersion.Id;//Document Id
        
        feedAttachment.Type = 'CONTENT'; 
        insert feedAttachment; 
            
            List<Custom_Item__c> listOfCustomItemProtoStatus = [SELECT Id, Opportunity__r.OwnerId, Design_Request__c, Design_Request__r.Prototype_Status__c,
                                                            Opportunity__r.Primary_Contact__c,
                                                            Opportunity__r.Primary_Contact__r.Email, 
                                                            Opportunity__r.Primary_Contact__r.FirstName,
                                                            Opportunity__r.Primary_Contact__r.LastName,
                                                            Opportunity__r.Owner.Email FROM Custom_Item__c WHERE Id IN : setCustomItemId];

            if (listOfCustomItemProtoStatus.size()>0) {    
                // list of all designRequest to check for esignature
                List<Id> listDesignRequestIds = new List<Id>();
                for (Custom_Item__c ci : listOfCustomItemProtoStatus) {
                    if(String.isNotBlank(ci.Design_Request__c)){
                        listDesignRequestIds.add(ci.Design_Request__c);
                    }
                }
                        
                // check for email template
                List<EmailTemplate> listOfEmailTemplate = [SELECT Id , Name FROM EmailTemplate WHERE Name = 'Prototype Approval Email' OR Name = 'PP Picture Approval' ORDER BY Name];
                
                EmailTemplate  templatePP = new EmailTemplate() ;
                EmailTemplate templateProto = new EmailTemplate() ;             	
                if (listOfEmailTemplate.size()>0) {
                    for(EmailTemplate listTemp : listOfEmailTemplate ){
                        
                        if(listTemp.Name == 'Prototype Approval Email' ){
                            templatePP = listTemp ;
                        }                        
                        if(listTemp.Name == 'PP Picture Approval' ){
                            templateProto = listTemp ;
                        }
                    }                
                
                    List<Site> listOfSite = [SELECT Id FROM Site WHERE Name =: Constants.REBEL_ESIGNATURE_SITE]; 
                    if(listOfSite.size() > 0){
                        
                        List<SiteDetail> listOfSiteDetails = [SELECT SecureURL
                                                                FROM SiteDetail 
                                                                WHERE DurableId = :listOfSite[0].Id];
                                                                        
                        if (listOfSiteDetails.size() > 0){
                            // instance of custom item 
                            Custom_Item__c ci = listOfCustomItemProtoStatus[0] ;
                            
                            // for mail 
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.toAddresses = new String[] {ci.Opportunity__r.Primary_Contact__r.Email};
                            mail.setTargetObjectId(ci.Opportunity__r.Primary_Contact__c);
                           // mail.ccaddresses = new String[] {ci.Opportunity__r.Owner.Email,'deeptanshu.bharti@fexle.com'};
                            mail.setWhatId(designRoundId);
                            if(String.isNotBlank(ci.Opportunity__r.Owner.Email))
                                    mail.setReplyTo(ci.Opportunity__r.Owner.Email); 
                            // Select Email templet 
                            if (ci.Design_Request__r.Prototype_Status__c == 'Proto' || ci.Design_Request__r.Prototype_Status__c == 'Dye Sub Strike Off') {
                                mail.setTemplateId(templateProto.Id);
                            }else if(ci.Design_Request__r.Prototype_Status__c == 'PP Pics'){
                                mail.setTemplateId(templatePP.Id);
                            }

                            eSignature_Status__c  eSignatureStatus = new eSignature_Status__c (
                                                                            Sender_Name__c  = UserInfo.getName(),
                                                                            Design_Round__c = designRoundId,    
                                                                            Envelop_Status__c = 'Sent');
                            insert eSignatureStatus ;

                            String RecipientNameAndEmailForURL = ci.Opportunity__r.Primary_Contact__r.FirstName+' '+ci.Opportunity__r.Primary_Contact__r.LastName+' :'+ci.Opportunity__r.Primary_Contact__r.Email;
                            Blob blobNameEmailRecipient = Blob.valueOf(RecipientNameAndEmailForURL);
                            String encodedNameAndEmailOfRecipient = EncodingUtil.base64Encode(blobNameEmailRecipient);

                            Design_round__c designRound = new Design_round__c(Id = designRoundId);
                            designRound.eSignatureUrl__c = listOfSiteDetails[0].SecureURL+'?id='+eSignatureStatus.Id+'&docId='+contentVersion.id+'&user='+encodedNameAndEmailOfRecipient;
                        
                            Util.ByPassAllTriggers = true;
                            update designRound; // update design round
                            Util.ByPassAllTriggers = false;

                            //sending email after updating URL on design round
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 

                            // for chatter 
                            List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();

                            
                                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                                ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

                                messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

                                mentionSegmentInput.id = ci.Opportunity__r.OwnerId;
                                messageBodyInput.messageSegments.add(mentionSegmentInput);

                                textSegmentInput.text = ' Proto Approval Form has been sent for signature on eSignature page';
                                messageBodyInput.messageSegments.add(textSegmentInput);

                                feedItemInput.body = messageBodyInput;
                                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                                feedItemInput.subjectId = ci.Design_Request__c; //swap in your record/User Id depending on where this post is supposed to go

                                ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
                                batchInputs.add(batchInput);
                            

                            ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);

                        }
                        else{
                            listOfCustomItemProtoStatus[0].addError('Rebel eSignature site secure URL not found please contact your system administrator.');
                        }
                    }
                    else{
                        listOfCustomItemProtoStatus[0].addError('Rebel eSignature site not found please contact your system administrator.');
                    }
                }
                else{
                    listOfCustomItemProtoStatus[0].addError('Email template not found please contact your system administrator.'); 
                }
            }
        }
        
    }
}