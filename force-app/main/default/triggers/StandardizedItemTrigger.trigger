trigger StandardizedItemTrigger on Standardized_Item__c (before insert, before update, after insert, after update) 
{
    if(Util.BypassAllTriggers) 
    {
        return;    
    }
    
    StandardizedItemManager sItemManager = new StandardizedItemManager();
    
    if (Trigger.isBefore && Trigger.isInsert) 
    {
        sItemManager.beforeInsert(Trigger.new);
    }
    
    if (Trigger.isBefore && Trigger.isUpdate) 
    {
        sItemManager.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
    
    if (Trigger.isAfter && Trigger.isInsert) 
    {
        sItemManager.updateStyleOnStandardizedItem(Trigger.new, Trigger.oldMap);
        sItemManager.afterInsert(Trigger.new, Trigger.newMap);
        sItemManager.updateFitOnStandardizedItem(Trigger.new, null);
    }
    
    
    if (Trigger.isAfter && Trigger.isUpdate) 
    {
        sItemManager.updateStyleOnStandardizedItem(Trigger.new, Trigger.oldMap);
        sItemManager.updateFitOnStandardizedItem(Trigger.new, Trigger.oldMap);
        sItemManager.updateAFSCheckboxOpp(Trigger.new,Trigger.oldMap);
        sItemManager.afterUpdate(Trigger.new, Trigger.oldMap);
    }

    //added - seemu saikia - 06/15/2021 
    if(Trigger.isAfter){
        if( Trigger.isUpdate || Trigger.isInsert){
            sItemManager.updateMaxQuantityOnOpp(Trigger.new);
        }
    }
}