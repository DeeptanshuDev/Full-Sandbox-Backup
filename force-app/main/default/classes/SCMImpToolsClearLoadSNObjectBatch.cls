public with sharing class SCMImpToolsClearLoadSNObjectBatch implements Database.Batchable<sObject>, Database.Stateful {
	
	public Database.QueryLocator start(Database.BatchableContext ctx){
		return Database.getQueryLocator([Select Id
											from SCMImpToolsLoad_Serial_Numbers__c
										   where Has_Error__c = false
										     and Serial_Number_Loaded__c = true]);
	}
	
	public void execute(Database.BatchableContext ctx, List<SObject> records) {
		try {
			delete records;
		} catch (Exception ex) {
			SCMC.ErrorLog.log('SCMImpToolsClearLoadSNObjectBatch.execute', 'Error with deleting records: ', ex);
			SCMC.ErrorLog.flush();
		}
	}
	
	public void finish(Database.BatchableContext ctx) {
	}
	
}