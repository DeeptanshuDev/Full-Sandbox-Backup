global class Batch_CreatePipelineCustomItems_s implements Schedulable {
   global void execute(SchedulableContext sc) {
      Batch_CreatePipelineCustomItems b = new Batch_CreatePipelineCustomItems(); 
      database.executebatch(b);
   }
}