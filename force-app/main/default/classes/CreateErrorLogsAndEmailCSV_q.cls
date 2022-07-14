public class CreateErrorLogsAndEmailCSV_q implements Queueable, Database.AllowsCallouts {

    public void execute(QueueableContext context) {
        CreateErrorLogsAndEmailCSV celes = new CreateErrorLogsAndEmailCSV();
    }
}