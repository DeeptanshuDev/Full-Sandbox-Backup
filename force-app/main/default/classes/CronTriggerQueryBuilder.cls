/**
*  Purpose      :   "Crom Trigger" Query Builder class
*  Created By   :   Abhinav Sharma
**/
public with sharing class CronTriggerQueryBuilder 
{
    public static List<CronTrigger> getAllAllowedJobsWithoutNextFireTime() 
    {
        return [SELECT Id, NextFireTime FROM CronTrigger 
                WHERE NextFireTime = null 
                LIMIT : Limits.getLimitDMLStatements()];        
    }
    
    public static List<CronTrigger> getCronJobDetails(Set<String> setOfStatuses, String cronJobName) 
    {
        if(setOfStatuses != null && setOfStatuses.size() > 0 && String.isNotBlank(cronJobName)) 
        {
            return [SELECT Id, State, NextFireTime, CronJobDetailId, CronJobDetail.Name  
                    FROM CronTrigger 
                    WHERE State IN: setOfStatuses 
                    AND CronJobDetail.Name =: System.Label.Create_Sandbox_Schedule_Job_Name];        
        }
        else 
        {
        	return null;    
        }
    }
}