public with sharing class UserRepo {

  public User findById(Id userId) {
    return [
      SELECT Id
        , Username
        , Profile.Name
        , ProfileId
      FROM User
      WHERE Id = :userId
    ];
  }
}