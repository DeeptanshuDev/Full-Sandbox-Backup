global class SalesOrderAllocateScheduler implements Schedulable
{
	global void execute(SchedulableContext sc) 
	{
		Database.executeBatch(new SalesOrderAllocateBatch(null), SalesOrderAllocateService.getBatchSize());
	}
}