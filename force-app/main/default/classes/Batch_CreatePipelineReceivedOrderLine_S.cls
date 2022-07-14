global class Batch_CreatePipelineReceivedOrderLine_S implements Schedulable {
   global void execute(SchedulableContext sc) {
      Batch_CreatePipelineReceivedOrderLine b = new Batch_CreatePipelineReceivedOrderLine(); 
      database.executebatch(b);
   }
}