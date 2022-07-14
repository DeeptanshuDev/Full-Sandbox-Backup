/*
*	Created By:	Daven Tsai
*	Date: 7/11/2022
*	Version: 1.0
*	Description: Marks Opportunity as Closed - Paid when it is the only SO on the opp that's already Closed - Balance Due
*/
global class OpportunityStageBalanceDueBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BD){
    	String query = 'SELECT Id, Opportunity__c FROM SCMC__Sales_Order__c WHERE (Opportunity_Stage__c = \'Closed - Balance Due\' AND SCMC__Shipment_Status__c = \'Fulfilled\' AND SCMC__Status__c != \'Cancelled\' AND Opportunity__r.Number_of_Open_Items__c = 0 AND Opportunity__r.Number_of_Closed_Items__c > 0  AND Opportunity__r.Number_of_WS_SOs__c = 1 AND Opportunity__r.Number_of_SOs__c = 1 AND Total_Percentage_Paid__c >=100)';
		return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<SCMC__Sales_Order__c> soList){
        List <Opportunity> oppList = new List<Opportunity>();
        System.debug('List size of SOs is: ' + soList.size());
        for (SCMC__Sales_Order__c so:soList){
            Opportunity o = new Opportunity();
            o.id = so.Opportunity__c;
            o.StageName = 'Closed - Paid';
            oppList.add(o);
        }
        try{
            List<Database.SaveResult> results = Database.update(oppList,false);
            for (Database.SaveResult result:results){
                if (!result.isSuccess()){
                    for (Database.Error err:result.getErrors()){
                        System.debug('Update Error: ' + err.getStatusCode() + ' '+ err.getMessage());
                    }
                }
            }
        }
        catch(DmlException de){
            System.debug('other: '+de);
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
}