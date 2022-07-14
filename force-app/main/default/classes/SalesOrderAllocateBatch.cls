public with sharing class SalesOrderAllocateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful
{
	private Set<Id> soIds;
	private Boolean isCalculateTax;
	private Map<Id, String> errors;
	private Integer totalRecords;
	
	public SalesOrderAllocateBatch(Set<Id> soIds)
    {
        this.soIds = soIds; 
        isCalculateTax = SalesOrderAllocateService.getIsCalculateTax();
        errors = new Map<Id, String>();
        totalRecords = 0;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
    	String m_query;
    	String soqlCriteria = SalesOrderAllocateService.getSOQLCriteria();
    	if(String.isBlank(soqlCriteria))
    	{
    		soqlCriteria = 'SCMC__Status__c = \'New\' and RecordType.Name = \'Inventory\'';
    	}
    	
    	if(this.soIds != null && !this.soIds.isEmpty())
   			m_query = 'SELECT Id FROM SCMC__Sales_Order__c WHERE Id in : soIds and ' + soqlCriteria;
   		else
   			m_query = 'SELECT Id FROM SCMC__Sales_Order__c WHERE ' + soqlCriteria;
   		
   		Database.QueryLocator queryLocator;
    	try 
    	{
    		 queryLocator  = Database.getQueryLocator(m_query);
    	}
		catch(QueryException ex) 
		{
			errors.put(null, ex.getMessage());
			queryLocator = Database.getQueryLocator('SELECT Id FROM SCMC__Sales_Order__c WHERE Id=null');
		}
		
		return queryLocator;
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> records)
    {
    	Set<Id> soIdSet = new Set<Id>();
    	for(sObject record : records)
    		soIdSet.add(record.Id);
    		
    	totalRecords += records.size();
		
		if(isCalculateTax)
    	{
    		errors.putAll(SalesOrderAllocateService.calculateTaxForSalesOrders(soIdSet));
    	}
    	
    	soIdSet.removeAll(errors.keyset());
    	errors.putAll(SalesOrderAllocateService.allocateSalesOrders(soIdSet));
	    soIdSet.removeAll(errors.keyset());
    	errors.putAll(SalesOrderAllocateService.approveSalesOrders(soIdSet));
    }
    
    public void finish(Database.BatchableContext bc)
   	{
		sendMailBatchStatus(BC.getJobId(), totalRecords, errors);
		SalesOrderAllocateService.emailsCount = Limits.getEmailInvocations();
   	}
   	
   	private void sendMailBatchStatus(Id jobId, Integer totalRecords, Map<Id, String> errors)
    {
        AsyncApexJob apexJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =: jobId];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {apexJob.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        if(SalesOrderAllocation__c.getOrgDefaults() != null && SalesOrderAllocation__c.getOrgDefaults().EmailReceipents__c != null && SalesOrderAllocation__c.getOrgDefaults().EmailReceipents__c != '')
        {
            String[] ccAddresses = (SalesOrderAllocation__c.getOrgDefaults().EmailReceipents__c).split(',');
            mail.setCcAddresses(ccAddresses);
        }  
        mail.setSubject('Sales Order allocation process is completed');
         
        String tableForSuccessAndFailure = '';
        String salesforceBaseUrl = URL.getSalesforceBaseUrl().toExternalForm().replace('http:' , 'https:');
        
        //Create Failure Table
        if(errors.size() > 0)
        {
            tableForSuccessAndFailure = tableForSuccessAndFailure + '<b>Errors:</b> <br/><table border="1"> <tr> <td> <b> Sales Order Number </b> </td> <td> <b> Failure Reason </b> </td> </tr>';
            Map<Id, SCMC__Sales_Order__c> soMap = new Map<Id, SCMC__Sales_Order__c>([SELECT Name FROM SCMC__Sales_Order__c WHERE Id in : errors.keySet()]);
            
            for(Id soId : errors.keySet())
            {
                if(soId == null)
                {
                    tableForSuccessAndFailure = tableForSuccessAndFailure + '<tr>' + '<td> null </td>' 
            			+  '<td>' + errors.get(null) + '</td>' + '</tr>';
            	}
            	else
            	{
                	tableForSuccessAndFailure = tableForSuccessAndFailure + '<tr>' + '<td>' + '<a href="' + salesforceBaseUrl + '/' + soId + '">'+ soMap.get(soId).Name +  '</a>' +  '</td>' 
            			+  '<td>' + errors.get(soId) + '</td>' + '</tr>';
            	}
            } 
            tableForSuccessAndFailure = tableForSuccessAndFailure + '</table>'; 
        }
        
        String mailBody = 'Sales Orders allocation process is completed with '+ errors.size() + ' errors';
        mailBody += '<br/><br/>';
        mailBody += 'Total Records Processed : '+String.Valueof(totalRecords);
        mailBody += '<br/><br/>';
        mailBody += tableForSuccessAndFailure;
        mail.setHtmlBody(mailBody); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}