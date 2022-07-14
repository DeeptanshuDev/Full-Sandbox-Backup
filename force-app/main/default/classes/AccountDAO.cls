public class AccountDAO {
    
    Public Static List<Account> getAccounts(Set<Id> setOfAccId){
        
        return [SELECT Id, Name, Opp_Approval__c FROM Account WHERE Id IN : setOfAccId];
    }
    Public static List<Account> getAccountsWithX2021_Total_SO(Set<Id> ids){
        
        return [SELECT Id, Name, X2021_Total_SO_Sales__c FROM Account WHERE Id IN : ids];
        
    }

}