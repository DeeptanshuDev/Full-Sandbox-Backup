/*
*	Created By:	Daven Tsai
*	Date: 7/11/2022
*	Version: 1.0
*	Description: Marks Opportunity as Closed - Paid or Closed - Balance Due if there's only 1 SO on the opp which is fulfilled.
*/
global class OpportunityStageClosingBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BD){
    	String query = 'SELECT Id, Opportunity__c, Total_Percentage_Paid__c,  FROM SCMC__Sales_Order__c WHERE (Opportunity_Stage__c = \'Open\' AND SCMC__Shipment_Status__c = \'Fulfilled\' AND SCMC__Status__c != \'Cancelled\' AND Opportunity__r.Number_of_Open_Items__c = 0 AND Opportunity__r.Number_of_Closed_Items__c > 0 AND Opportunity__r.Number_of_WS_SOs__c = 1 AND Opportunity__r.Number_of_SOs__c = 1)';
		return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<SCMC__Sales_Order__c> soList){
        List<Opportunity> oppList = new List<Opportunity>();
        System.debug('List size of SOs is: ' + soList.size());
        for (SCMC__Sales_Order__c so:soList){
            Opportunity o = new Opportunity();
            if (so.Total_Percentage_Paid__c >= 100 || so.Total_Percentage_Paid__c == null){
                o.id = so.Opportunity__c;
                o.StageName = 'Closed - Paid';
                oppList.add(o);
            }
            else if (so.Total_Percentage_Paid__c < 100){
                o.id = so.Opportunity__c;
                o.StageName = 'Closed - Balance Due';
                oppList.add(o);
            }
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