global class Batch_CreatePipelineStandardItems_S implements Schedulable {
   global void execute(SchedulableContext sc) {
      Batch_CreatePipelineStandardItems b = new Batch_CreatePipelineStandardItems(); 
      database.executebatch(b);
   }
}