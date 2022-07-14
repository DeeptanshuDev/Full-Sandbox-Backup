//Batch to fetch contacts, eligible to have community user. 
//If yes and corresponding community user doesn't exists then it will create it
//otherwise just skipped it.
global class Batch_CreateCommunityUsers implements Database.Batchable<sObject>,Database.Stateful 
{
    @TestVisible private static Integer emailLimits = 0;
    global string query;
    global string debugLog = '';
    public Batch_CreateCommunityUsers() 
    {
        if(query == null) 
        {
            query = 'SELECT Id, FirstName, LastName, Name, Email, AccountId, Error_Message__c, Community_User_Id__c FROM Contact ' +
                	'WHERE AccountID != null AND Email != null AND Community_User_Id__c = null AND ' +
                	'CreateCommunityUser__c = true AND Primary__c = true ';
        }
    }
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Contact> contacts)
    {
        String logMessage = '';
        List<Profile> listOfCommunityProfiles = [SELECT Id, Name, UserLicense.Name 
                                                 FROM Profile 
                                                 WHERE Name=: System.Label.Rebel_Customer_Community_Profile_Name  
                                                 LIMIT 1];
        if(listOfCommunityProfiles.size() > 0 && contacts.size() > 0) 
        {
            List<User> listOfNewCommunityUsers = new List<User>();
            
            //Loop over contacts for whom user doesn't exists and create a new one for them.
            for(Contact con : contacts)
            {
                String uniqueStr = String.valueOf(Math.random()).substring(0, 6);
                User user = new User(Alias = con.LastName.left(6), 
                                     Email = con.Email, 
                                     FirstName = con.FirstName,
                                     LastName = con.LastName, 
                                     ProfileId = listOfCommunityProfiles[0].Id, 
                                     UserName = con.Email + System.Label.User_Prefix, 
                                     ContactId = con.Id,
                                     LocaleSidKey ='en_US', 
                                     EmailEncodingKey='UTF-8',
                                     LanguageLocaleKey = 'en_US', 
                                     TimeZoneSidKey = System.Label.TimeZoneSidKey, 
                                     CommunityNickname = uniqueStr);
                listOfNewCommunityUsers.add(user);
            }
            if(listOfNewCommunityUsers.size() > 0) 
            {
                List<Contact> contactsToBeUpdated = new List<Contact>();
                for(RecordsWrapper recordWrapper : Util.processSaveResults(Database.insert((listOfNewCommunityUsers), false), 
                                                                               listOfNewCommunityUsers))
                {
                    for(RecordsWrapper.ErredRecordsWrapper errorWrapper : recordWrapper.errorWrapper)
                    {
                        if(errorWrapper.logMessage != '' && errorWrapper.logMessage.length() < 11999900) 
                        {
                            debugLog += errorWrapper.logMessage;
                            if(errorWrapper.relatedContactId != null) 
                            {
                                contactsToBeUpdated.add(new Contact(Id =errorWrapper.relatedContactId, 
                                                                    Error_Message__c = errorWrapper.logMessage));   
                            }
                        }
                    }
                    
                    for(RecordsWrapper.SuccessfulRecordWrapper successWrapper : recordWrapper.successWrapper)
                    {
                        if(successWrapper.relatedContactId != null && successWrapper.communityUserId != null) 
                        {
                            contactsToBeUpdated.add(new Contact(Id =successWrapper.relatedContactId,
                                                            Community_User_Id__c = successWrapper.communityUserId,
                                                            Error_Message__c = ''
                                                           ));
                        }
                    }
                } 
                if(contactsToBeUpdated.size() > 0) 
                {
                    update contactsToBeUpdated;
                }
            }   
        }
    }
    global void finish(Database.BatchableContext bc)
    {
        if(debugLog != '') 
        {
            List<User> sfAdminUsers = [Select Id, Email 
                                       FROM User 
                                       WHERE Name =: System.Label.System_Administrator_Name  
                                       AND IsActive = true 
                                       AND Profile.Name =: System.Label.System_Administrator_Profile_Name 
                                       AND Email != null LIMIT 1];
            if(sfAdminUsers.size() > 0) 
            {
                Util.sendBatchStatus(BC.getJobId(), 'Batch_CreateCommunityUsers', debugLog, sfAdminUsers[0].Email);
                Batch_CreateCommunityUsers.emailLimits = Limits.getEmailInvocations();
            }
        }
    }
}