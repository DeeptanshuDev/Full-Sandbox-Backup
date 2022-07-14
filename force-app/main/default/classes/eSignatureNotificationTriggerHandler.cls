/**
*  Description     :   Handler class for trigger eSignatureNotificationTrigger used to post chatter for approved 
*                      by automated process and update design round's art work approved check box in case of approved. 
* 
*  Created By      :   Chirag Soni
*
*  Created Date    :   2/26/2021
*
*  Revision Logs   :   V_1.0 - Created 
**/

public without sharing class eSignatureNotificationTriggerHandler {
    
    /**
    * 
    *  @description    :   Method used to update design round's art work approved checkbox when status is approved and
    *                      Post chatter for Approve and Void case by automated process. 
    *
    *  @args           :   new list of platform event object eSignature_Notification__e
    *
    *  @return         :   void 
    *
    *  @revision Log   :   V_1.0 - Created  2/26/2021
    * 
    **/     
    public static void postApproveVoidChatterAndUpdateDesignRound(List<eSignature_Notification__e> eSignatureNotification) {
        try{
            Set<Id> setDRequest = new Set<Id>();
            Set<Id> setCDocId = new Set<Id>();
            List<ContentVersion> contentVersions = new List<ContentVersion>();
            String fileTitle = '';
            String designRoundId = '';
            if(eSignatureNotification.size()>0) {
                List<FeedItem> listOfchatterForApproveVoidOnDR = new List<FeedItem>(); 
                //List<ConnectApi.FeedItem> listOfchatterForApproveVoidOnDR = new List<ConnectApi.FeedItem>();
                Set<Id> designRoundIds = new Set<Id>();
                //Map<String,String> mapOfDesignRoundIdAndMessage = new Map<String,String>();
                for(eSignature_Notification__e eSNotifcation : eSignatureNotification) {
                    designRoundId = eSNotifcation.DesignRound_Id__c;
                    if(eSNotifcation.Approved__c  && String.isNotBlank(eSNotifcation.DesignRound_Id__c)) {
                        listOfchatterForApproveVoidOnDR.add( new FeedItem(
                            ParentId = eSNotifcation.DesignRound_Id__c,
                            Body = 'Envelope for Design Round '+eSNotifcation.DesignRound_Name__c+
                            ' has been signed and approved. \n View eSignature Status: '+
                            URL.getSalesforceBaseUrl().toExternalForm()+'/'+eSNotifcation.eSignatureStatus_Id__c));
                        designRoundIds.add(eSNotifcation.DesignRound_Id__c); //designRound Ids to update Artwork Approved checkbox 
                    }
                }
                if(designRoundIds.size()>0){
                    List<Design__c> designs = new List<Design__c>();
                    List<Design__c> designsToBeUpdate = new List<Design__c>();
                    List<Design_Round__c> listOfDesignRoundToBeUpdated = [SELECT id, Artwork_Approved__c, Design_Request__c, Design_Request__r.Assigned_Designer__c,
                                                                          (select id,Art_Approval_Created__c,Sent_for_Approval__c,Approved_Art__c from Designs__r WHERE Sent_for_Approval__c= true AND Approved_Art__c = false) 
                                                                          FROM Design_Round__c 
                                                                          WHERE Id IN :designRoundIds];
                    List<Design_Item__c> designItems = [SELECT Id, Custom_Item__c,Selected__c, Custom_Item__r.Design_Status__c, Design__c, Design__r.Design_Round__c
                                                        FROM Design_Item__c
                                                        WHERE Design__r.Design_Round__c IN :designRoundIds
                                                        AND Custom_Item__c != null
                                                        AND Selected__c = true
                                                        AND (Custom_Item__r.Stage__c != 'Grey Out' AND Custom_Item__r.Stage__c != 'Production' AND (Design_Status__c !='(D) TechPack Sent' AND Design_Status__c !='(P)(T) Design Request Complete'  AND Design_Status__c !='(T) Tech Pack FTP\'d'))
                                                        
                                                       ];
                    if(listOfDesignRoundToBeUpdated.size()>0)
                    {
                        for(Design_Round__c designRound : listOfDesignRoundToBeUpdated){
                            designRound.Artwork_Approved__c = true;
                            setDRequest.add(designRound.Design_Request__c); 
                        }
                    }
                    if(test.isRunningTest()){
                        update listOfDesignRoundToBeUpdated;
                    }else{
                        Util.ByPassAllTriggers = true;
                        update listOfDesignRoundToBeUpdated;
                        Util.ByPassAllTriggers = false;
                    } 
                    if(designItems.size() > 0){
                        Set<Id> customItemId = new Set<Id>();
                        List<Custom_Item__c> updateDesignItems = new List<Custom_Item__c>();
                        for(Design_Item__c di :designItems){
                            customItemId.add(di.Custom_Item__c);
                        }
                        for(Custom_Item__c cs :[select id,Design_Status__c,Design_Request__c FROM Custom_Item__c where Id IN: customItemId]){
                            Custom_Item__c ci = new Custom_Item__c();
                            ci.Id = cs.Id;
                            ci.Design_Status__c = '(S) Artwork Approved';
                            ci.Design_Request__c= cs.Design_Request__c;
                            updateDesignItems.add(ci);
                        }
                        if(updateDesignItems.size() > 0){
                            if(Test.isRunningTest()){
                                update updateDesignItems;
                            }else{
                                Util.ByPassAllTriggers = true;
                                update updateDesignItems;
                                CustomItemTriggerHandler cust = new CustomItemTriggerHandler();
                                cust.updateDesignRequestItemSummaries(updateDesignItems);
                                Util.ByPassAllTriggers = false;
                            }
                        }
                    }
                }
                if(setDRequest.size() > 0){
                    for(Design_Request__c dr : [SELECT Account__r.Name FROM Design_Request__c WHERE Id IN:setDRequest AND Account__c != null]){
                        //file name to match on contentversion
                        fileTitle = dr.Account__r.Name + '%';
                        break;
                    }
                }
                if(listOfchatterForApproveVoidOnDR.size() > 0) {
                    List<ContentDocumentLink> contentDocumentLink = [SELECT ContentDocumentId, LinkedEntityId, SystemModstamp  
                                                                     FROM ContentDocumentLink 
                                                                     WHERE LinkedEntityId =: designRoundId ORDER By SystemModstamp DESC];
                    for(ContentDocumentLink cdl : contentDocumentLink){
                        setCDocId.add(cdl.ContentDocumentId);
                    }
                    if(contentDocumentLink.size() > 0){
                        for(ContentVersion cv : [SELECT Id,Title, ContentDocumentId, ContentUrl, ContentBodyId 
                                                 FROM ContentVersion 
                                                 WHERE ContentDocumentId IN: setCDocId AND Title Like :fileTitle ORDER By Createddate DESC]){
                                                     //get the latest content version with matching file name
                                                     contentVersions.add(cv);
                                                     break;  
                                                 }
                        if(contentVersions.size() > 0){
                            insert listOfchatterForApproveVoidOnDR; 
                            FeedAttachment feedAttachmentOnChatter = new FeedAttachment();
                            feedAttachmentOnChatter.FeedEntityId = listOfchatterForApproveVoidOnDR[0].Id;//Chatter Post Id
                            feedAttachmentOnChatter.RecordId = contentVersions[0].Id;//Document Id
                            feedAttachmentOnChatter.Type = 'CONTENT'; 
                            insert feedAttachmentOnChatter;
                        }
                    }
                }           
            } 
        }
        catch(Exception e){
            List<Web_Service_Log__c> listOfWS = new List<Web_Service_Log__c>();
            Web_Service_Log__c ws = new Web_Service_Log__c();
            ws.Operation_Name__c = 'Art Approval';
            ws.Type__c = 'Others';
            ws.Response_Body__c = e.getMessage();
            listOfWS.add(ws);
            if(listOfWS!=NULL)
            {
                insert listOfWS;
            }
        }
    }
}