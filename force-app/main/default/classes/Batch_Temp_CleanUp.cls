/**
*	Description   	:		Batch job that can be scheduled on weekly basis and is there to clear out the records older than 
                        	one week. For now for the following objects:
                        	a) ClickLink Log
                        	b) ClickLink Log Line Items
                        	It's generic in nature and we can include another object in near future, 
							without changing the code.
*
* 	Created By		:	Abhinav Sharma   
*
* 	Created Date	:   12/10/2019
* 
*  	Version			:   v1.0 - Created - CR - 00000046 - Abhinav Sharma         
**/ 
global class Batch_Temp_CleanUp implements Database.Batchable<SObject>, Database.Stateful 
{
    global String query ='';
    global String debugLog ='';
    global Batch_Temp_CleanUp(String queryString, String objectName)
    {
        if(String.isNotBlank(objectName))
        {
			Boolean isEligibleForDeletion = false;
            for(ObjectsAvailableToDelete__mdt delObjSetting : [SELECT Id, Object_Api_Name__c, Object_Label__c, 
                                                               Query__c 
                                                               FROM ObjectsAvailableToDelete__mdt 
                                                               WHERE Object_Api_Name__c != null]) 
            {
                if(delObjSetting.Object_Api_Name__c.trim().equalsIgnoreCase(objectName)) 
                {
                    isEligibleForDeletion = true;
                    query = delObjSetting.Query__c;
                    break;
                }
            }
            if(isEligibleForDeletion) 
            {
                if(String.isBlank(query) && String.isNotBlank(queryString)) 
                {
                    if(queryString.containsIgnoreCase(objectName))
                    {
                        query = queryString;
                    } 
                    else 
                    {
                        throw new customException(System.Label.Object_Query_Mismatch_Error);
                    }
                }
                else
                {
                    query = 'SELECT Id From '+ objectName + ' Where CreatedDate < LAST_WEEK';
                }
            }
            else 
            {
                throw new customException(System.Label.Object_Eligibility_Error_Message);
            }
        } 
        else 
        {
        	throw new customException(System.Label.Valid_Object_Name_Error_Message);   
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {   
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Sobject> recordToBeDeleted)
    {
        debugLog = DatabaseUtilities.createLog(Database.delete(recordToBeDeleted, false));
    }   
    global void finish(Database.BatchableContext bc)
    { 
        if(String.isNotBlank(debugLog)) 
        {
            List<User> sfAdminUsers = [Select Id, Email, Profile.Name
                                       FROM User 
                                       WHERE Name =: System.Label.System_Administrator_Name  
                                       AND IsActive = true 
                                       AND Profile.Name =: System.Label.System_Administrator_Profile_Name];
            if(sfAdminUsers.size() > 0) 
            {
                Util.sendBatchStatus(Bc.getJobId(), 'Batch_Temp_CleanUp', debugLog, sfAdminUsers[0].Email);
                
            }
        }
    }
}