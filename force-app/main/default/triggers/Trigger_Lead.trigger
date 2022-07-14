trigger Trigger_Lead on Lead (after update) {
    if(label.Inactive_Lead_Trigger == 'true'){
	LeadTriggerHelper.updateLeadOnConvert(Trigger.New,Trigger.oldMap);
    }
}