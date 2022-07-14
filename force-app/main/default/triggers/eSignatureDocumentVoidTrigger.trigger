/**
 *  Purpose         :   ContentVersion Trigger to delete existing file on design round if created using same design items.
 *
 *  Created By      :   Chirag Soni
 *
 *  Created Date    :   3/12/2021
 *
 *  Revision Logs   :   V_1.0 - Created
 *            
 **/

trigger eSignatureDocumentVoidTrigger on ContentVersion (before insert,after insert,after update) {

    if(Trigger.isBefore && Trigger.isInsert){
        eSignatureDocumentVoidTriggerHandler.deleteOldVersionWithSameDesignItem(Trigger.new);
    }
    if(Trigger.isAfter)
    {
        eSignatureDocumentVoidTriggerHandler.soNeededCheckBox(Trigger.new, Trigger.oldMap);
    }
	

}