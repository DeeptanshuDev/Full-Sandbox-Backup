//Scheduler class to schedule batch to create community users
global class Schedule_CreateCommunityUsers implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {
        Batch_CreateCommunityUsers batch = new Batch_CreateCommunityUsers(); 
        database.executebatch(batch, Integer.valueOf(System.Label.Create_Community_User_Batch_Size));
    }
}