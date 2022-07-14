/**
*	Description		:	Schedule Job for Batch_Temp_CleanUp batch that is basically there for logs data deletion. 
*
*	Created By		:   Abhinav Sharma
*
*	Created Date	:   10/12/2019
* 
*	Version			:   v1.0 - Created - CR - 00000046 - Abhinav Sharma         
**/
global class Scheduled_Batch_Temp_CleanUp implements Schedulable 
{
    global String query = '';
    global String ObjectName = '';
    
    global Scheduled_Batch_Temp_CleanUp() {}
    
    global void execute(SchedulableContext sc) 
    {
        Batch_Temp_CleanUp batch = new Batch_Temp_CleanUp(query,ObjectName); 
        database.executebatch(batch);
    }
}