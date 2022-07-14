/**
 *  Purpose         :   Platform event's trigger used to post chatter for approved or voided status.
 *
 *  Created By      :   Chirag Soni
 *
 *  Created Date    :   2/26/2021
 *
 *  Revision Logs   :   V_1.0 - Created
 *            
 **/

trigger eSignatureNotificationTrigger on eSignature_Notification__e ( after insert) {
    
     if(trigger.isAfter && trigger.isInsert)
     {
         eSignatureNotificationTriggerHandler.postApproveVoidChatterAndUpdateDesignRound(trigger.new);
     }
}