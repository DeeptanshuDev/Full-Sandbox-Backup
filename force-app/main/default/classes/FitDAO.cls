public class FitDAO {
	
    public static List<Fit__c> getFits(){
        
        return [SELECT Id, Name FROM Fit__c];
    }
}