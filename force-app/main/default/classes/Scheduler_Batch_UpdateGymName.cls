global class Scheduler_Batch_UpdateGymName implements schedulable{

    global void execute(SchedulableContext sc)
    {
        Batch_UpdateGymNameOnReceivedOrder b = new Batch_UpdateGymNameOnReceivedOrder();
        database.executebatch(b, Integer.valueOf(System.Label.UpdateGymNameOnReceivedOrder_BatchSize));
    }
}