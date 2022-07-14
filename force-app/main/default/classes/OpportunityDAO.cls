public class OpportunityDAO {
    
    public static List<Opportunity> getOpportunitys(Set<Id> setOfOppId){
        
        return [SELECT Id, Name, Business_Development__c, Business_Development_Approval_Checkbox__c FROM Opportunity WHERE Id IN : setOfOppId];
    }
	
    /**
     *
     *   @description    :  method to return list of opportunities with no length Adjustments For male and female from given set of ids
     * 
     *   @args           :  Set<Id>
     *
     *   @return         :  List<Opportunity>
     *
     *   @revision Log   :   V1.1 - Created  -  13/05/2022 	-		Ajay 
     * 
     **/
    public static List<Opportunity> getOpportunityWithNoLengthAdjustments(Set<Id> setOpportunityIds){
        return [select id,No_Length_Adjustments_Female__c,No_Length_adjustments__c FROM Opportunity where id IN: setOpportunityIds];
    }
    
    public static List<Opportunity> getOpportunityWithOnerID(String OppId){
        
        return [SELECT Id, Name, OwnerId, Account.name FROM Opportunity WHERE id = :OppId];
    }
}