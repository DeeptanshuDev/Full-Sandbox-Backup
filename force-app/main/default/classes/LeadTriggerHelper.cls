public class LeadTriggerHelper {
    
    public static Boolean isFirstTime = true;
    public static void updateLeadOnConvert(List<Lead> leads,Map<Id,Lead>mapOldLeads){
        List<Lead> leadToBeUpdate = new List<Lead>();
        for(Lead lead: leads) {
            if (isFirstTime && Lead.IsConverted && String.isNotBlank(Lead.LeadSource) && String.isBlank(Lead.Lead_Source__c)){
                isFirstTime = false;
                Lead ld = new Lead();
                ld.Id = lead.Id;
                ld.Lead_Source__c = lead.LeadSource;
                leadToBeUpdate.add(ld);
            }   
        }
        If(leadToBeUpdate.size() > 0){
            
            update leadToBeUpdate;
        }
    }
}