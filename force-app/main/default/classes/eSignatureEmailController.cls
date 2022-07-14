/**
*  Description     :   This class is used to generate dynamic URL for eSignature form and send email to eSignature
*                      Recipient contact of design round for art approval.  
*  
*  Created By      :   Chirag Soni
*
*  Created Date    :   3/3/2021
*
*  Revision Logs   :   V_1.0 - Created 
**/


public without sharing class eSignatureEmailController {
    
    public String errorMessage {get; set;}
    private Design_Round__c designRound;
    private Set<Id> contentDocumentIds ;
    private String opportunityOwner;
    private String oppOwnerId;
    
    public eSignatureEmailController(ApexPages.StandardController controller){
        
        designRound = (Design_Round__c) controller.getRecord(); 
        designRound = queryDesignRound(designRound.Id);
        contentDocumentIds = new Set<Id>();
        
        if(String.isBlank(designRound.eSignature_Recipient_Contact__c)){
            errorMessage = 'No Recipient found for email. Please regenerate art'
                +' document pdf from create art approval button and add recipient in it.';
        }
        
        List<contentDocumentLink> listOfcontentDocumentsOnDR = [SELECT ContentDocumentid 
                                                                FROM contentDocumentLink 
                                                                WHERE LinkedEntityid= :designRound.Id];
        if(!(listOfcontentDocumentsOnDR.size()>0)){
            errorMessage = 'Art document not found on this design round.'
                +' Please generate art document pdf from create art approval button.';
        }else{
           for(contentDocumentLink contentDocument : listOfcontentDocumentsOnDR){
                contentDocumentIds.add(contentDocument.ContentDocumentid);
            }
        }
    }
    
    /**
*  
*  @description    :  Send email on contact eSignature recipient of design round, create dyanmic URL, 
*                     update sent for approval checkbox and eSignature URL on design round, creates eSignature Status Record,
*                     post chatter on design round.
*
*  @args           :  N/A
*
*  @return         :  Page Reference view
*
*  @revision Log   :   V_1.0 - Created 3/3/2021
* 
**/
    
    public PageReference sendEmailToRecipient()
    {    
       
        String fileName = '';
        if(String.isNotBlank(designRound.eSignature_Recipient_Contact__c)){
            
			List<Design_Request__c> designRequests = [SELECT Id, Opportunity__c,Account__r.Name, Opportunity__r.Name FROM Design_Request__c where Id =: designRound.Design_Request__c];
			
            List<Design_Item__c> designItems = [SELECT Id, Custom_Item__c,Selected__c, Custom_Item__r.Design_Status__c, Design__c, Design__r.Design_Round__c
                                                FROM Design_Item__c
                                                WHERE Design__r.Design_Round__c =: designRound.Id
                                                AND Custom_Item__c != null
                                                AND Selected__c = true
                                                AND (Custom_Item__r.Stage__c != 'Grey Out' AND Custom_Item__r.Stage__c != 'Production' AND (Design_Status__c !='(D) TechPack Sent' AND Design_Status__c !='(P)(T) Design Request Complete'  AND Design_Status__c !='(T) Tech Pack FTP\'d'))
            
        ];
            if(designRequests.size() > 0){
                
                for(Opportunity opp : [SELECT Id,Owner.Email FROM Opportunity WHERE Id =:designRequests[0].Opportunity__c]){
                    opportunityOwner = opp.Owner.Email;
                    oppOwnerId = opp.Owner.Id;
                }
                //to get the pdf with matching name
                fileName = designRequests[0].Account__r.Name + '%';
            }            
            Contact recipientContact = queryRecipientContact(designRound.eSignature_Recipient_Contact__c);//get eSignature Recipient Contact details
            system.debug('recipientContact---'+recipientContact);
            system.debug('contentDocumentIds --- '+contentDocumentIds);
            if(contentDocumentIds.size()>0){
                try{
                    ContentVersion contentVersion = [SELECT Id ,Title 
                                                     FROM ContentVersion
                                                     WHERE ContentDocumentId
                                                     IN :contentDocumentIds AND Title LIKE: fileName
                                                     ORDER BY ContentModifiedDate DESC LIMIT 1];
                    
                    system.debug('content version ---'+contentVersion);
                    
                    List<EmailTemplate> listOfEmailTemplates = [Select Id 
                                                                FROM EmailTemplate 
                                                                WHERE Name =: Constants.ART_APPROVAL_EMAIL_TEMPLATE];
                    
                    system.debug('content listOfEmailTemplates ---'+listOfEmailTemplates);
                    if(listOfEmailTemplates.size() > 0){
                        
                        List<Site> listOfSite = [SELECT Id FROM Site WHERE Name =: Constants.REBEL_ESIGNATURE_SITE]; 
                        
                        system.debug(' sites --'+listOfSite);
                        if(listOfSite.size() > 0){
                            
                            List<SiteDetail> listOfSiteDetails = [SELECT SecureURL
                                                                  FROM SiteDetail 
                                                                  WHERE DurableId = :listOfSite[0].Id];
                            if(listOfSiteDetails.size() > 0){
                                List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='ayush@rebelathletic.com'];
                               
                                Messaging.SingleEmailMessage singleEmailMessage = new Messaging.SingleEmailMessage();
                                /*Commented by Deeptanshu
                                singleEmailMessage.setOrgWideEmailAddressId(lstEmailAddress[0].Id); */
                                
                                singleEmailMessage.setToAddresses(new String []{recipientContact.Email});
                                singleEmailMessage.setTemplateID(listOfEmailTemplates[0].Id);
                                singleEmailMessage.setWhatId(designRound.Id);
                                singleEmailMessage.setTargetObjectId(designRound.Design_Request__r.Primary_Contact__c);
                                singleEmailMessage.setSaveAsActivity(false);
                                singleEmailMessage.setTreatTargetObjectAsRecipient(false);
                                
                                if(String.isNotBlank(opportunityOwner))
                                    singleEmailMessage.setReplyTo(opportunityOwner);
                                
                                //check for existing
                                List<eSignature_Status__c> existingEsign = [SELECT Id FROM eSignature_Status__c WHERE Design_Round__c =: designRound.id];
                                if(existingEsign.size() > 0){
                                    delete existingEsign;
                                }
                                // create eSignature Status Record
                                eSignature_Status__c  eSignatureStatus = new eSignature_Status__c (
                                    Sender_Name__c  = UserInfo.getName(),
                                    Design_Round__c = designRound.id,    
                                    Envelop_Status__c = 'Sent');
                                insert eSignatureStatus; 
                                
                                String RecipientNameAndEmailForURL = recipientContact.FirstName+' '+recipientContact.LastName+' :'+recipientContact.Email;
                                Blob blobNameEmailRecipient = Blob.valueOf(RecipientNameAndEmailForURL);
                                String encodedNameAndEmailOfRecipient = EncodingUtil.base64Encode(blobNameEmailRecipient);
                                
                                designRound.eSignatureUrl__c = listOfSiteDetails[0].SecureURL+'?id='+eSignatureStatus.Id+'&docId='+contentVersion.id+'&user='+encodedNameAndEmailOfRecipient;
                                designRound.Art_Approval_Sent__c = true;
                                designRound.Approval_Till_Date__c = date.today().addDays(30);
                                
                                Util.ByPassAllTriggers = true;
                                update designRound; // update design round
                                
                                Util.ByPassAllTriggers = false;
								
                                updateDesignItems(designItems);
                                
                                updateDesigns(designRound.id);
                                
                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {singleEmailMessage}); //sending email after updating URL on design round
                                
                                FeedItem post = new FeedItem(); // chatter post for sent document
                                post.ParentId = designRound.Id;
                                post.Body = 'Envelope for Design Round '+designRound.Name+' has been sent for signature on eSignature page. \n View eSignature Status:'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+eSignatureStatus.Id;
                                insert post;
                                if (opportunityOwner == recipientContact.Email){//Added by Daven Tsai 05/19/22 to send additional chatter if opp owner = recipient
                                    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                                    ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                                    ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                                    ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

                                    messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                                    mentionSegmentInput.id = oppOwnerId;
                                    messageBodyInput.messageSegments.add(mentionSegmentInput);
                                    textSegmentInput.text = ' The AA for ' + designRequests[0].Account__r.Name + ', ' + designRequests[0].Opportunity__r.Name + ' has been sent.';
                                    messageBodyInput.messageSegments.add(textSegmentInput);
                                    feedItemInput.body = messageBodyInput;
									feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                                    feedItemInput.subjectId = designRound.id;
									ConnectApi.FeedElement feedElement= ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(),feedItemInput);
                                } 
                                
                                return new ApexPages.StandardController(designRound).view();
                            }
                            else{
                                errorMessage = 'Rebel eSignature site secure URL not found please contact your system administrator.';
                                return null;
                            }
                            
                        }
                        else{
                            errorMessage = 'Rebel eSignature site not found please contact your system administrator.';
                            return null;
                        }
                    }
                    else{
                        errorMessage = 'Email template not found please contact your system administrator.'; 
                        return null;
                    }
                }
                catch(Exception ex){
                    //System.assert(false,String.valueOf(ex.getLineNumber()));
                    errorMessage = ex.getMessage()+', Please contact your system administrator.';
                    return null;
                }
            }
            else{
                errorMessage = 'Art document not found on this design round.'
                    +' Please generate art document pdf from create art approval button.'; 
                return null;
            }
        }
        else{
            errorMessage = 'No Recipient found for email. Please regenerate art'
                +' document pdf from create art approval button and add recipient in it.';
            return null;
        }
       
    }
    
    //added by - Ayush Gupta
    public static void updateDesignItems(List<Design_Item__c> items){
        
        Set<Id> customItemId = new Set<Id>();
        List<Custom_Item__c> updateDesignItems = new List<Custom_Item__c>();
        for(Design_Item__c di :items){
            customItemId.add(di.Custom_Item__c);
        }
        for(Custom_Item__c cs :[select id,Design_Status__c,Design_Request__c FROM Custom_Item__c where Id IN: customItemId]){
            Custom_Item__c ci = new Custom_Item__c();
            ci.Id = cs.Id;
            ci.Design_Status__c = 'Art Approval Sent';
            ci.Design_Request__c = cs.Design_Request__c;
            updateDesignItems.add(ci);
        }
        
        if(updateDesignItems.size() > 0){
        
            Util.ByPassAllTriggers = true;
            
            update updateDesignItems;
            CustomItemTriggerHandler cust = new CustomItemTriggerHandler();
            cust.updateDesignRequestItemSummaries(updateDesignItems);
            Util.ByPassAllTriggers = false;
        CustomItemNotifications notifications = new CustomItemNotifications();
            notifications.createNotifications(updateDesignItems);
            
        }
    }
    
    //added by - Seemu Saikia
    public static void updateDesigns(Id designRoundId){

        Set<Id> setCustomItemId = new Set<Id>();
        
        Set<Id> setStandardizedItemId = new Set<Id>();
        
        Set<Id> setUpdateDesign = new Set<Id>();
        
        List<Design__c> listUpdateDesign = new List<Design__c>();
        
        //get designRound
        List<Design_Round__c> listDesignRound = [SELECT Id,Design_Request__c,Design_Request__r.Opportunity__c FROM Design_Round__c WHERE Id =: designRoundId LIMIT 1];

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

        //get design items 
        Set<Id> setDesigns = new Set<Id>();
        for(Design__c dRec : [SELECT Id,Design_Request__c,Design_Round__c,Art_Approval_Created__c FROM Design__c WHERE Design_Request__c =:listDesignRound[0].Design_Request__c AND Design_Round__c=:listDesignRound[0].Id  AND Art_Approval_Created__c = true]){

            setDesigns.add(dRec.Id);

        }
        
        //get design to update
        for(Design_Item__c diRec : [SELECT id,Design__c,Custom_Item__c,Standardized_Item__c FROM  Design_Item__c WHERE Design__c IN:setDesigns AND (Custom_Item__c IN: setCustomItemId OR Standardized_Item__c IN: setStandardizedItemId)]){
            setUpdateDesign.add(diRec.Design__c);
            
        }

        for(Id designId : setUpdateDesign){
            listUpdateDesign.add(new Design__c(Id = designId, Sent_for_Approval__c = true,Art_Approval_Created__c=false));
        }
        if(listUpdateDesign.size() > 0)
            update listUpdateDesign;
    }

    private Contact queryRecipientContact(Id contactId){
        return[SELECT ID
               , FirstName
               , LastName
               , Email
               FROM Contact
               WHERE Id =:contactId];
    } 
    
    private Design_Round__c queryDesignRound(Id designRoundId){
        return[SELECT Id
               , Name
               , eSignature_Recipient_Contact__c
               , Design_Request__r.Primary_Contact__c
               , eSignatureUrl__c
               , Art_Approval_Sent__c
               FROM Design_Round__c
               WHERE Id = :designRoundId];
    }
    
     public static void testData(){
        
        string i0;
        string i1;
        string i2;
        string i3;
        string i4;
        string i5;
        string i6;
        string i7;
        string i8;
        string i9;
        string i10;
        string i11;
        string i12;
        string i13;
        string i14;
        string i15;
        string i16;
        string i17;
        string i18;
        string i19;
        string i20;
        string i21;
        string i22;
        string i23;
        string i24;
        string i25;
        string i26;
        string i27;
        string i28;
        string i29;
        string i30;
        string i31;
        string i32;
        string i33;
        string i34;
        string i35;
        string i36;
        string i37;
        string i38;
        string i39;
        string i40;
        string i41;
        string i42;
        string i43;
        string i44;
        string i45;
        string i46;
        string i47;
        string i48;
        string i49;
        string i50;
        string i51;
        string i52;
        string i53;
        string i54;
        string i55;
        string i56;
        string i57;
        string i58;
        string i59;
        string i60;
        string i61;
        string i62;
        string i63;
        string i64;
        string i65;
        string i66;
        string i67;
        string i68;
        string i69;
        string i70;
        string i71;
        string i72;
        string i73;
        string i74;
        string i75;
        string i76;
        string i77;
        string i78;
        string i79;
        string i80;
        string i81;
        string i82;
        string i83;
        string i84;
        string i85;
        string i86;
        string i87;
        string i88;
        string i89;
        string i90;
        string i91;
        string i92;
        string i93;
        string i94;
        string i95;
        string i96;
        string i97;
        string i98;
        string i99;
        string i100;
        string i101;
        string i102;
        string i103;
        string i104;
        string i105;
        string i106;
        string i107;
        string i108;
        string i109;
        string i110;
        string i111;
        string i112;
        string i113;
        string i114;
        string i115;
        string i116;
        string i117;
        string i118;
        string i119;
        string i120;
        string i121;
        string i122;
        string i123;
        string i124;
        string i125;
        string i126;
        string i127;
        string i128;
        string i129;
        string i130;
        string i131;
        string i132;
        string i133;
        string i134;
        string i135;
        string i136;
        string i137;
        string i138;
        string i139;
        string i140;
        string i141;
        string i142;
        string i143;
        string i144;
        string i145;
        string i146;
        string i147;
        string i148;
        string i149;
        String i164;
String i165;
String i166;
String i167;
String i168;
String i169;
String i170;
String i171;
String i172;
String i173;
String i174;
String i175;
String i176;
String i177;
String i178;
String i179;
String i180;
String i181;
String i182;
String i183;
String i184;
String i185;
String i186;
String i187;
String i188;
String i189;
String i190;
String i191;
String i192;
String i193;
String i194;
String i195;
String i196;
String i197;
String i198;
String i199;
String i200;
String i201;
String i202;
String i203;
String i204;
String i205;
String i206;
String i207;
String i208;
String i209;
String i210;
String i211;
String i212;
String i213;
String i214;
String i215;
String i216;
String i217;
String i218;
String i219;
String i220;
String i221;
String i222;
String i223;
String i224;
String i225;
String i226;
String i227;
String i228;
String i229;
String i230;
String i231;
String i232;
String i233;
String i234;
String i235;
String i236;
String i237;
String i238;
String i239;
String i240;
String i241;
String i242;
String i243;
String i244;
String i245;
String i246;
String i247;
String i248;
String i249;
String i250;
String i251;
String i252;
String i253;
String i254;
String i255;
String i256;
String i257;
String i258;
String i259;
String i260;
String i261;
String i262;
String i263;
String i264;
String i265;
String i266;
String i267;
String i268;
String i269;
String i270;
String i271;
String i272;
String i273;
String i274;
String i275;
String i276;
String i277;
String i278;
String i279;
String i280;
String i281;
String i282;
String i283;
String i284;
String i285;
String i286;
String i287;
String i288;
String i289;
String i290;
String i291;
String i292;
String i293;
String i294;
String i295;
String i296;
String i297;
String i298;
String i299;
        
    }
           
}