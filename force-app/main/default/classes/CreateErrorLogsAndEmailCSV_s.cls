global class CreateErrorLogsAndEmailCSV_s implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        System.enqueueJob(new CreateErrorLogsAndEmailCSV_q());
    }
}