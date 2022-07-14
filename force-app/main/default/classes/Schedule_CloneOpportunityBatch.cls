global class Schedule_CloneOpportunityBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
      CloneOpportunityBatch b = new CloneOpportunityBatch(); 
      database.executebatch(b);
   }
}