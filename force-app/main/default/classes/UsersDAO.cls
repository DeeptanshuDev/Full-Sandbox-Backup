public class UsersDAO {
    
    public static List<User> getUsers(Set<String> usersName){
        
        return [SELECT Id, Name FROM USER WHERE Name IN : usersName];
    }
    
    public static List<User> getUsersById(String accOwnerId){
        
        return [SELECT Id, Name FROM User WHERE Id =:accOwnerId];
    }
    
    public static User getUsersWithEmail(Id currentUserId){
        
        return [SELECT Id, Email FROM User WHERE Id =: currentUserId];
    }

}