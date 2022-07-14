global class Schedule_BatchInsertPublicLinksForDesign implements Schedulable {
    global void execute(SchedulableContext sc) {
        Batch_InsertPublicLinksForDesigns b = new Batch_InsertPublicLinksForDesigns(); 
        database.executebatch(b);
    }
}