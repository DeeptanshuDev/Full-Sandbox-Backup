/**
*  Purpose      :   "AsyncApexJob" Query Builder class
*  Created By   :   Abhinav Sharma
**/
public with sharing class AsyncApexJobQueryBuilder 
{
    public static List<AsyncApexJob> getJobsRelatedToBatch(Id batchJobId) 
    {
        return [SELECT Id, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email 
                FROM AsyncApexJob
                WHERE Id =: batchJobId];    
    }
    
    public static List<AsyncApexJob> getJobsRelatedToBatch(Set<String> setOfStatuses, String apexClassName, String jobType) 
    {
        if(setOfStatuses != null && setOfStatuses.size() > 0 
           && String.isNotBlank(apexClassName) && String.isNotBlank(jobType)
        ) 
        {
            return [SELECT Id  
                    FROM AsyncApexJob 
                    WHERE Status IN: setOfStatuses 
                    AND ApexClass.Name =: apexClassName 
                    AND JobType =: jobType];    
        }
        else
        {
        	return null;    
        }    
    }
}