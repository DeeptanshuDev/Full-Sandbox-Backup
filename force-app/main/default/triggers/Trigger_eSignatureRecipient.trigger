/**
 *  Purpose         :   trigger is used to update eSignature Status fields and insert platform event for chatter notification,
 *                      its also update attachment id on eSignature Status object.
 *                      
 *  Created By      :   Chirag Soni
 *
 *  Created Date    :   2/25/2021
 *
 *  Revision Logs   :   V_1.0 - Created
 *            
 **/

trigger Trigger_eSignatureRecipient on eSignature_Recipient__c (after insert) {

    if(Trigger.isAfter && Trigger.isInsert)
    {
        eSignatureRecipientTriggerHandler.updateEsignStatusAndAttachmentInsertEsignatureNotification(Trigger.new);
    }
    
   
}