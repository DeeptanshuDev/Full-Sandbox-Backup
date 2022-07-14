global class schedularOfBatchToUpdateCustomItem implements Schedulable {
    
    global void execute(SchedulableContext ctx){
      Batch_ToBlankUpdateCustomItem batch = new Batch_ToBlankUpdateCustomItem();
      Database.executebatch(batch);
    }
}