global class RepricingScheduler implements Schedulable {
    global void execute(SchedulableContext sc)
        {
            CustomItemRepricing c = new CustomItemRepricing ();
           
            //Parameters of ExecuteBatch(context,BatchSize)
            database.executebatch(c,10);
        }
}