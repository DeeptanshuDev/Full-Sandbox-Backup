/**
 *  Purpose         :  Update shipping and billing address of all the associated contracts when account's 
 *                     shipping and billing address is updated. 
 *
 *  Created By       :  Chirag soni
 *
 *  Created Date    :  23/12/2020 
 *
 *  Revision Logs   :   V_1.0 - Created -- CR-00000161
 *            
 **/

trigger TriggerAccountRecord on Account (after update,before insert, after insert, before update) {
      
    if(trigger.isAfter && trigger.isUpdate)
    {
        TriggerAccountRecordHandler conaddress = new TriggerAccountRecordHandler();
        conaddress.updateContractAddress(Trigger.new,Trigger.oldMap);
        
    }
    if(trigger.isBefore)
    {
        TriggerAccountRecordHandler conaddress = new TriggerAccountRecordHandler();
        conaddress.preventPodtoChangeowner(Trigger.new,Trigger.oldMap);
    }
}