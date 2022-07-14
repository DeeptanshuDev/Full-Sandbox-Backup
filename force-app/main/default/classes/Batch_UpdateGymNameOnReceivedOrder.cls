/*
 * This is controller for Vf page = UpdateGymNameOnReceivedOrder_VF
 */

global class Batch_UpdateGymNameOnReceivedOrder implements Database.Batchable<Sobject> {
    @TestVisible global String debugLog ='';
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM SCMC__Received_Order__c Order By CreatedDate DESC' );
    }
    
    global void execute(Database.BatchableContext bc, List<SCMC__Received_Order__c> records){
        //update records;
        debugLog = DatabaseUtilities.createLog(Database.update(records, false));
    }
    global void finish(Database.BatchableContext bc){
        if(String.isNotBlank(debugLog)) 
        {
            List<User> sfAdminUsers = [Select Id, Email, Profile.Name
                                       FROM User 
                                       WHERE Name =: System.Label.System_Administrator_Name  
                                       AND IsActive = true 
                                       AND Profile.Name =: System.Label.System_Administrator_Profile_Name];
            if(sfAdminUsers.size() > 0) 
            {
                Util.sendBatchStatus(Bc.getJobId(), 'Batch_UpdateAccNumberOnReceivedOrder', debugLog, sfAdminUsers[0].Email);
                
            }
        }
    }    
}