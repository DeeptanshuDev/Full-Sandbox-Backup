trigger CustomItemTrigger on Custom_Item__c (before insert, before update, after insert, after update) 
{   
   
    if(Util.BypassAllTriggers) 
    {
        return;    
    }
    
    CustomItemTriggerHandler handler = new CustomItemTriggerHandler();
    
    if (Trigger.isBefore && Trigger.isInsert) 
    {
        handler.beforeInsert(Trigger.new);
        
        
        
    }
    
    if (Trigger.isBefore && Trigger.isUpdate) 
    {
        System.debug('B4');
        if(!checkRecursion.hasAlreadyRun())
        {
            //handler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        
    }
    
    if (Trigger.isAfter && Trigger.isInsert) 
    {
        handler.afterInsert(Trigger.new);
        handler.updateFitOnCustomItem(Trigger.new,null);
        //handler.addFitOnCustomItem(Trigger.new);
       
        //added - Deeptanshu Bharti - 01/12/2021
        System.debug('inside trigger');
       handler.updateSalesOrderLineItems(Trigger.new, null);
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) 
    {
        //handler.updateAFSCheckboxOpp(Trigger.new,Trigger.oldMap);
        handler.afterUpdate(Trigger.new, Trigger.oldMap);
       //handler.updateFitOnCustomItem(Trigger.new,Trigger.oldMap);

       //added - Deeptanshu Bharti - 01/12/2021
       handler.updateSalesOrderLineItems(Trigger.new, Trigger.oldMap);
    }
    //added - seemu saikia - 06/15/2021 
    if(Trigger.isAfter){
        if( Trigger.isUpdate || Trigger.isInsert){
            //handler.updateMaxQuantityOnOpp(Trigger.new);
            CustomItemTriggerHandler.statusChatter(Trigger.new, Trigger.oldMap);
        }
    }
}