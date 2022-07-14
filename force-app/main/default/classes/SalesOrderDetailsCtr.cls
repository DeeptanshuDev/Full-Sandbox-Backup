/**
*   Description     :   
*
*   Created By      :   Abhinav Sharma   
*
*   Created Date    :   01/29/2020
* 
*   Version         :   v1.0 - Created - CR - 00000068 - Abhinav Sharma         
**/ 
public class SalesOrderDetailsCtr 
{
    public List<SalesOrderWrapper> salesOrderWrapperList {get;set;}
    public String recordId {get;set;}
    private Set<Id> setOfOppId;
    private ApexPages.StandardController stdController;
    
    public SalesOrderDetailsCtr(ApexPages.StandardController standardController)
    {
        setOfOppId = new Set<Id>();
        stdController = standardController;
        Account acc = (Account)standardController.getRecord();
        recordId = acc.Id; 
        if(acc.Id != null)
        {
            for(Opportunity opp : [SELECT Id FROM opportunity WHERE AccountId =: acc.Id])
            {
                setOfOppId.add(opp.Id);
            }    
        }
        inIt();
    }
     
    public List<Schema.FieldSetMember> getFields() 
    {
        return Schema.SObjectType.SCMC__Sales_Order__c.fieldSets.getMap().get('Sales_Order_Fields').getFields();
    }
    
    public void inIt()
    { 
        salesOrderWrapperList = new List<SalesOrderWrapper>();
        if(setOfOppId.size() > 0) 
        {
            String whereClause = 'WHERE Opportunity__c IN:setOfOppId';
            String orderBy = 'ORDER BY Name ASC '; 
            String salesOrderQuery = FieldSetUtility.getFieldsetQuery('SCMC__Sales_Order__c', getFields(), 
                                                                       new List<String>(),whereClause, orderBy,
                                                                       null, true);  
            Integer cnt = 0;
            for (sObject queriedObject : Database.query(salesOrderQuery)) 
            {
                SalesOrderWrapper salesOrderWrap = new SalesOrderWrapper();
                salesOrderWrap.salesOrder = (SCMC__Sales_Order__c)queriedObject;
                salesOrderWrap.srNo = cnt;
                salesOrderWrap.selectedSalesOrder = false;
                salesOrderWrapperList.add(salesOrderWrap);
            }       
        }
    }
    
    public class SalesOrderWrapper 
    {
        public SCMC__Sales_Order__c salesOrder {get; set;}
        public Boolean selectedSalesOrder {get; set;}
        public Integer srNo {get; set;}
        public SalesOrderWrapper() 
        {
            salesOrder = new SCMC__Sales_Order__c();
            selectedSalesOrder = false;
            srNo = 0;
        }
    }
    
    public void first() {
 		
 	}

 	// returns the last page of records
 	public void last() {
 		
 	}

 	// returns the previous page of records
 	public void previous() {
 		
 	}

 	// returns the next page of records
 	public void next() {
 		
 	}

 	// returns the PageReference of the original page, if known, or the home page.
 	public void cancel() {
 		
 	}
    
}