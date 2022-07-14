/**
 *  Purpose         :  Populate shipping and billing address of associated account when new contract is created and its
 *                     shipping and billing address fields are blank 
 *
 *  Created By       :  Chirag soni
 *
 *  Created Date    :  23/12/2020 
 *
 *  Revision Logs   :   V_1.0 - Created -- CR-00000161
 *            
 **/


trigger TriggerContract on Contract (before insert){
    
    
    if(trigger.isBefore && trigger.isInsert)
    {
        TriggerContractHandler contractHandler = new TriggerContractHandler();
        contractHandler.addContractAddresses(Trigger.new);
    }

}