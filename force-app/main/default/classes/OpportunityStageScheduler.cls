global class OpportunityStageScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        OpportunityStageClosingBatch op1 = new OpportunityStageClosingBatch();
        OpportunityStageBalanceDueBatch op2 = new OpportunityStageBalanceDueBatch();

        database.executebatch (op1, 10);
        database.executebatch (op2, 10);
    }
}