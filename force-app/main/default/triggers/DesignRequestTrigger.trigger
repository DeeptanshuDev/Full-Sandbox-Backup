trigger DesignRequestTrigger on Design_Request__c (after update, before insert, before update, after insert) {
    if(Trigger.isBefore)
    {
        DesignRequestTriggerHandler.updateApproveField(Trigger.new,Trigger.oldMap); 
        DesignRequestTriggerHandler.updateRejectField(Trigger.new,Trigger.oldMap); 
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        new DesignRequestTriggerHandler().afterUpdate(Trigger.new, Trigger.oldMap);
        //DesignRequestTriggerHandler.sendingApprovalBasedonDR(Trigger.new,Trigger.oldMap);
    }

    /* Added by: Daven Tsai
     * Date 05/11/2022
    */
    if (Trigger.isBefore && Trigger.isInsert){
        new DesignRequestTriggerHandler().beforeInsert(Trigger.new);
    }
    if(trigger.isAfter && Trigger.isInsert)
    {
        DesignRequestTriggerHandler.sendingApprovalBasedonDR2(Trigger.new,Trigger.oldMap);
    }
    if(trigger.isAfter && Trigger.isUpdate)
    {
        DesignRequestTriggerHandler.sendingApprovalBasedonDR(Trigger.new,Trigger.oldMap);
    }
}