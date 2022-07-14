public with sharing class SalesOrderAllocateService 
{
	public static Integer emailsCount;
	
	public static Map<Id, String> allocateSalesOrders(Set<Id> soIds)
    {
    	Map<Id, String> errors = new Map<Id, String>();
    	if(soIds != null && !soIds.isEmpty())
    	{
	    	SCMC.SalesOrderAPI soAPI = new SCMC.SalesOrderAPI();
	    	List<SCMC__Sales_Order_Line_Item__c> solList = [SELECT Id, SCMC__Sales_Order__c FROM SCMC__Sales_Order_Line_Item__c WHERE SCMC__Sales_Order__c IN : soIds];
	    	Map<Id, Set<Id>> mapSOL = new Map<Id, Set<Id>>();
	    	
	    	for(SCMC__Sales_Order_Line_Item__c sol : solList)
	    	{
	    		if(mapSOL.containsKey(sol.SCMC__Sales_Order__c))
	    			mapSOL.get(sol.SCMC__Sales_Order__c).add(sol.Id);
	    		else
	    			mapSOL.put(sol.SCMC__Sales_Order__c, new Set<Id>{sol.Id});
	    	}
	    	
	        for(Id soId : soIds)
	        {
	            try
	            {
		            soAPI.allocateLines(soId, mapSOL.get(soId));
	            }
	            catch(Exception ex)
	            {
	            	errors.put(soId, ex.getMessage());
	            }
	        }
    	}
        return errors;
    }
	
	public static Map<Id, String> approveSalesOrders(Set<Id> soIdsSet)
    {
    	Map<Id, String> errors = new Map<Id, String>();
    	if(soIdsSet != null && !soIdsSet.isEmpty())
    	{
	    	List<Id> soIds = new List<Id>(soIdsSet);
	    	List<Approval.ProcessSubmitRequest> submits = new List<Approval.ProcessSubmitRequest>();
			for (Id soId : soIds)
			{
				Approval.ProcessSubmitRequest submit = new Approval.ProcessSubmitRequest();
				submit.setComments('Approve or Disapprove this sales order');
				submit.setObjectId(soId);
				submits.add(submit);
			}
			List<Approval.Processresult> results = Approval.process(submits);
			
			for(integer i =0; i < soIds.size(); i++)
			{
				Approval.Processresult result = results[i];
				if (!result.isSuccess())
				{
					String errorMsg = '';
					for(Database.Error error : result.getErrors()) 
					{
						errorMsg += error.getMessage() + '\n';
					}	
					errors.put(soIds[i], errorMsg);
				}
			}
    	}
		return errors;
	}
    
    public static Map<Id, String> calculateTaxForSalesOrders(Set<Id> soIds)
    {
    	Map<Id, String> errors = new Map<Id, String>();
    	if(soIds != null && !soIds.isEmpty())
    	{
	    	for(Id soId : soIds)
	    	{
		    	try
		    	{
		    		SCMAVA.TaxAPI.CalculateTaxSO(soId);
		    	}
		    	catch(Exception ex)
		        {
		        	errors.put(soId, ex.getMessage());
		        }
	    	}
    	}
    	return errors;
    }
    
    public static Boolean getIsCalculateTax()
    {
    	SalesOrderAllocation__c soTax = SalesOrderAllocation__c.getOrgDefaults();
    	return soTax.CalculateTax__c;
    }
    
    public static Integer getBatchSize()
    {
    	Integer batchSize;
    	SalesOrderAllocation__c soTax = SalesOrderAllocation__c.getOrgDefaults();
    	if(soTax.BatchSize__c == null ||  soTax.BatchSize__c <= 0)
			batchSize = 1;
		else
			batchSize = Integer.valueOf(soTax.BatchSize__c);
		return batchSize;
    }
    
    public static String getSOQLCriteria()
    {
    	SalesOrderAllocation__c soCriteria = SalesOrderAllocation__c.getOrgDefaults();
    	return soCriteria.SOQL_Criteria__c;
    }
}