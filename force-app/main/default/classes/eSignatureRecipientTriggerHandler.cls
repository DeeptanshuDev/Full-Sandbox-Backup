/**
*  Description     :   Handler class for trigger Trigger_eSignatureRecipient used to update envelop status of eSignature Status 
*                      Object record. Also update attachment id on eSignature Status object record.
*                      
*  
*  Created By      :   Chirag Soni
*
*  Created Date    :   2/25/2021
*
*  Revision Logs   :   V_1.0 - Created 
**/

public without sharing class eSignatureRecipientTriggerHandler {
    
    @future
    public static void updateDesignRound(Set<Id> designRoundIdSet){
        system.debug('Executing future');
        List<eSignature_Status__c> designRoundToUpdateList = new List<eSignature_Status__c>();
        for(Id dRId : designRoundIdSet){
        	designRoundToUpdateList.add(new eSignature_Status__c(Id = dRId,eSignature_Approved__c = true));    
        }
        
        update designRoundToUpdateList;
        
    }
    
    /**
* 
*  @description    :   Method used to update attachment id, envelop status and insert plateform event record in order
*                      to place chatter based on status. 
*
*  @args           :   new list of eSignature_Recipient__c
*
*  @return         :   void 
*
*  @revision Log   :   V_1.0 - Created 2/25/2021
* 
**/
    public static void updateEsignStatusAndAttachmentInsertEsignatureNotification(List<eSignature_Recipient__c> listOfeSignatureRecipients)
    {
        List<eSignature_Status__c> listOfeSignatureStatusToBeUpdated = new List<eSignature_Status__c>(); 
        eSignature_Notification__e  eSignatureNotification = new eSignature_Notification__e (); //Platform event object
         Set<Id> designRoundIdSet = new Set<Id>();
        
        List<eSignature_Recipient__c> listOfESignReceipientsDetails = new List<eSignature_Recipient__c>();
        listOfESignReceipientsDetails = [SELECT ID, Document_Approved__c, 
                                         Recipient_Status__c, eSignature_Status__c,
                                         eSignature_Status__r.Design_Round__c,
                                         eSignature_Status__r.Design_Round__r.Name,
                                         Document_Voided__c
                                         FROM eSignature_Recipient__c
                                         WHERE ID IN : listOfeSignatureRecipients
                                        ];
        
        if(listOfeSignatureRecipients.size() > 0)
        {
            for(eSignature_Recipient__c eSign : listOfESignReceipientsDetails)
            {
                if(eSign.Document_Approved__c 
                   && eSign.Recipient_Status__c == 'Approved')
                {
                    listOfeSignatureStatusToBeUpdated.add(new eSignature_Status__c(
                        Id = eSign.eSignature_Status__c,
                        Approved__c = true,
                        Voided__c = false,
                        Envelop_Status__c = 'Approved',
                        Last_Viewed__c = DateTime.now()
                    ));
                    
                    eSignatureNotification.Approved__c = true; //Platform event object's fields
                    eSignatureNotification.Voided__c = false;
                    eSignatureNotification.eSignatureStatus_Id__c = eSign.eSignature_Status__c;
                    eSignatureNotification.DesignRound_Id__c  = eSign.eSignature_Status__r.Design_Round__c; 
                    eSignatureNotification.DesignRound_Name__c  = eSign.eSignature_Status__r.Design_Round__r.Name;
                    
                    //add Design Rounds to update
                    //designRoundIdSet.add(eSign.eSignature_Status__c);
                }
                
                /*else if(eSign.Document_Voided__c  && eSign.Recipient_Status__c == 'Void')
                {
                    listOfeSignatureStatusToBeUpdated.add(new eSignature_Status__c(
                        Id = eSign.eSignature_Status__c,
                        Voided__c  = true,
                        Approved__c = false,
                        Envelop_Status__c = 'Void',
                        Last_Viewed__c = DateTime.now()
                    ));
                    postChatterOnDR.Approved__c = false;
                    postChatterOnDR.Voided__c  = true;
                    postChatterOnDR.eSignatureStatus_Id__c = eSign.eSignature_Status__c;
                    postChatterOnDR.DesignRound_Id__c  = eSign.eSignature_Status__r.Design_Round__c; 
                    postChatterOnDR.DesignRound_Name__c  = eSign.eSignature_Status__r.Design_Round__r.Name;
                    
                }*/
            } 
            
                         if(listOfeSignatureStatusToBeUpdated.size()>0)
            {
                update listOfeSignatureStatusToBeUpdated;
               
                Database.SaveResult sr = EventBus.publish(eSignatureNotification);
            }
        }
        
        //--- update attachment Id on eSignature Status ---// 
        List<eSignature_Status__c> listToUpdateAttachmentId = [SELECT Id,SignatureAttachment_Id__c, Voided__c, 
                                                               (Select id 
                                                                FROM Attachments 
                                                                ORDER BY LastModifiedDate 
                                                                DESC Limit 1 ) 
                                                               FROM eSignature_Status__c 
                                                               WHERE Id IN : listOfeSignatureStatusToBeUpdated];
        
        if(listToUpdateAttachmentId.size()>0) {
            for(eSignature_Status__c eSingature : listToUpdateAttachmentId)
            {
                for(Attachment attachment : eSingature.Attachments)
                {
                    eSingature.SignatureAttachment_Id__c = attachment.id;
                }
            }
            update listToUpdateAttachmentId;
        }
    }
    
   
}