/**
*  Description     :   Scheduler Class to Schedule Create Sandbox Process
*
*  Created By      :   Abhinav Sharma
*
*  Created Date    :   03/12/2020
*
*  Current Version :   v1.0
*       
*  Revision Log    :   V_1.0 Created               
**/
global class Scheduler_CreateSBRequest implements Schedulable,Database.AllowsCallouts 
{
    global void execute(SchedulableContext sc)
    {		
        //Calling a batch class so that the batch class is call one by one and send the reuest.         
        Batch_CreateSBRequest b = new Batch_CreateSBRequest();
        Database.executeBatch(b, 1); 
    }
}