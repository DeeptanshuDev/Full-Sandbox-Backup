/**
 * @description       : 
 * @author            : Seemu Saikia
 * @group             : 
 * @last modified on  : 05-03-2021
 * @last modified by  : Seemu Saikia
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   04-29-2021   Seemu Saikia   Initial Version
**/
public class AFSMFinalController {
	private string oppId;
    private final Opportunity opp;
    private Boolean isTrue = false;
    
    public AFSMFinalController(ApexPages.StandardController stdController){
        this.opp = (opportunity)stdController.getRecord();
        oppId = opp.Id;
    }
    public PageReference goBack(){
        return new ApexPages.StandardController(opp).view();
    }
    	
    public PageReference validateAFSFileOnOpportunity(){
        Id attachmentId ;
        set<Id> contenetDocumentId = new set<Id>();
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        for(ContentDocumentLink contentDocumentLink : [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink  WHERE LinkedEntityId =: oppId ]){
                                                        
            contenetDocumentId.add(contentDocumentLink.ContentDocumentId);
        }
        
        if(contenetDocumentId.size() > 0){
            
            contentVersions = [SELECT Id, ContentDocumentId,Title, ContentUrl, ContentBodyId  FROM ContentVersion  WHERE ContentDocumentId IN: contenetDocumentId  ORDER BY CreatedDate ASC];
        }
        
        if(contentVersions.size() > 0){
            for(ContentVersion cv : contentVersions){
                if(cv.Title.contains('AFS') && cv.Title.contains('-M-')){
                    isTrue = true;
                    attachmentId = cv.ContentDocumentId;
                }                
            }
        }
        
        if(isTrue){

            try{
                ///update the opportunity field
                Opportunity updateOpp = new Opportunity(Id = opp.Id, AFS_M_Final__c = true);
                update updateOpp;

                //send emails to group members
                notifyUsers(opp.Id, attachmentId);

                //String message = '{0F915000000E0aO}The AFS is reviewed for Male.';

                List<CollaborationGroup> collaborationGroup = [SELECT Id, Name FROM CollaborationGroup where name ='SOA Team' LIMIT 1];

                if(Test.isRunningTest()){
                    collaborationGroup = [SELECT Id, Name FROM CollaborationGroup where name ='Test Team' LIMIT 1];
                }
                //ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(null,opp.Id, message);
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                
                messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                
                mentionSegmentInput.id = collaborationGroup[0].Id;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                textSegmentInput.text = ' The AFS is reviewed for Male.';
                messageBodyInput.messageSegments.add(textSegmentInput);
                
                feedItemInput.body = messageBodyInput;
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                feedItemInput.subjectId = opp.Id;
                
                // Now connect the feeditem to our already uploaded file.
                feedItemInput.capabilities = new ConnectAPI.FeedElementCapabilitiesInput();
                feedItemInput.capabilities.files = new ConnectAPI.FilesCapabilityInput();
                feedItemInput.capabilities.files.items = new List<ConnectAPI.FileIdInput>();
                ConnectAPI.FileIdInput attachFile = new ConnectAPI.FileIDInput();
                
                //**** Here is where we attach the specific file to the post!
                attachFile.id = attachmentId; 
                feedItemInput.capabilities.files.items.add(attachFile);
                
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
            }
            catch(Exception e){
                system.debug('Exception :'+e);
            }
            
        }
        else{
            system.debug('No file found');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'No AFS found for male category.'));
            return null;
        }
         return new ApexPages.StandardController(opp).view();
    }

    public static void notifyUsers(Id oppRecId, Id attachmentsId){

        List<ContentVersion> file = [SELECT Id, Title, FileType, VersionData, isLatest, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentsId];
        
        List<Opportunity> oppRec = [SELECT Id,Name,OwnerId,Primary_Contact__c FROM Opportunity WHERE Id =: oppRecId LIMIT 1];
        
        String subject = 'AFS Review';
        String body = '';
        List<EmailTemplate> emailTemplate = [Select Id FROM EmailTemplate WHERE DeveloperName = 'AFS_Notification' LIMIT 1];
        //email details

        //List<Messaging.SingleEmailMessage> listMails = new List<Messaging.SingleEmailMessage>();
        
        List<String> emailAddress = new List<String>();
        //iterate over all user in the group
        List<User> users = [SELECT Email FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember WHERE Group.Name = 'SOA')];

        for(User u : users){
            emailAddress.add(u.email);
        }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(file[0].Title);
        efa.setBody(file[0].VersionData);
        //efa.setContentType(file[0].FileType);
        attachments.add(efa);

        mail.setToAddresses(emailAddress);
        mail.setTargetObjectId(oppRec[0].Primary_Contact__c ); 
        mail.setSenderDisplayName('Rebel Athletic'); 
        mail.setReplyTo('no-reply@rebel.com');
        mail.setUseSignature(false); 
        mail.setBccSender(false); 
        mail.setSaveAsActivity(false); 
        mail.setTemplateID(emailTemplate[0].Id); 
        mail.setWhatId(oppRecId);    
        mail.setFileAttachments(attachments);

        Messaging.SingleEmailMessage[] mails = new List<Messaging.SingleEmailMessage> {mail};
        if(!Test.isRunningTest()){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);  

            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } 
            else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }
            
    }
    
}