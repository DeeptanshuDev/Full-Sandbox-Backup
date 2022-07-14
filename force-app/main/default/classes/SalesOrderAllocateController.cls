public with sharing class SalesOrderAllocateController 
{
    public Boolean isSuccess{get; set;}
    public Boolean isError{get; set;}
    
    private Set<Id> soIds;
    
    /**
     * Constructor
    */
    public SalesOrderAllocateController(ApexPages.StandardSetController stdController) 
    {
        isSuccess = false;
        isError = false;
        
	    //get selected so ids
	    soIds = new Set<Id>();
	    if(!stdController.getSelected().isEmpty())
	    {
	        for(SCMC__Sales_Order__c so : (List<SCMC__Sales_Order__c>)stdController.getSelected())
	            soIds.add(so.Id);
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'You have selected ' + soIds.size() + ' sales orders. Do you want to continue allocation for these sales orders?'));
	    }
	    else
	    {
	        isError = true;
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Please select at least one sales order'));
	    }
    }
    
     /**
     * This method triggers the Sales Order allocation batch execution.
     * @return a PageReference. 
     */
    public PageReference allocate()
    { 
        isSuccess = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Sales Order Allocation process is in progress. You will be notified by email when process is complete.'));
        SalesOrderAllocateBatch soAllocationBatch = new SalesOrderAllocateBatch(soIds);
   		Database.executebatch(soAllocationBatch, SalesOrderAllocateService.getBatchSize());
        
        return null;
    }
    
    
}