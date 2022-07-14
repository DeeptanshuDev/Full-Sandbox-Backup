/**
 *  Description     :  SO Summary Controller class of SoSummary Vf page. Used to create Sales Order Summary Record 
 *                     and Update SO Summary Id in Selected Sales Order.
 *
 *  Created By      :  Chirag Soni
 *
 *  Created Date    :  04/12/2020
 *
 *  Revision Logs   :  V_1.0 - Created -- CR- 00000120 
**/



public with sharing class SoSummaryCtrl 
{
    
    public List<SalesOrderWrapper> salesOrderList {get;set;}
    public SO_Summary__c soSummary { get; set; }
    private final Account acc;
    private final ApexPages.StandardController controller;
    
    public SoSummaryCtrl(ApexPages.StandardController cont)
    {
        
        soSummary = new SO_Summary__c();
        controller = cont;
        acc = (Account) controller.getRecord();
        salesOrderList = new List<SalesOrderWrapper>();
        List<SCMC__Sales_Order__c> salesOrder = new List<SCMC__Sales_Order__c>();
        if(String.isNotBlank(acc.Id))
        {
            for(SCMC__Sales_Order__c sOrder : [SELECT Id, Account_Number__c, Sales_Order_Number_Text__c, SCMC__Sales_Order_Date__c,
                                               Opportunity__c, Opportunity_Number__c, SCMC__Status__c, Total_Percentage_Paid__c,
                                               Remaining_Payment_Balance__c
                                               FROM SCMC__Sales_Order__c 
                                               WHERE SCMC__Customer_Account__c = :acc.Id])
            {
                salesOrderList.add(new SalesOrderWrapper(sOrder));
            }
        }
    }

     /**
     * 
     *  @description    :   Invoked From So Summary VF Page to create SO summary Record and Update Sales Order Records 
     *
     *  @args           :   Void
     *
     *  @return         :   PageReference view 
     *
     *  @revision Log   :   V_1.0 - Created
     * 
     **/
    public PageReference saveSoSummary()
    { 
         if(salesOrderList.size()>0) // check for SalesOrderWrapper
        {
         List<SCMC__Sales_Order__c> sOrder = new List<SCMC__Sales_Order__c>();   
            system.debug('sales --'+salesOrderList);
          for(SalesOrderWrapper sOwrap : salesOrderList)
           {
               system.debug('selected --'+sowrap.selected);
            if(sOwrap.Selected)
             {
              sOrder.add(sOwrap.item);
             }
           }
            if(sOrder.size()>0) 
             {
              try{
                 soSummary.SO_Account__c = acc.Id; // adding account id to So Summary
                 insert soSummary; //creating a new SO Summary Record
               } 
               catch(Exception ex){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); 
               }
               for(SCMC__Sales_Order__c salesOrder : sOrder){
                salesOrder.SO_Summary__c = soSummary.Id; // adding SO summary Id to SalesOrder 
               } 
               try{
                update sOrder;
                return new ApexPages.StandardController(soSummary).view();
               }
               catch(Exception ex){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
               return null;   
               } 
             }
            else
             { 
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select Sales Order')); // Select Sales Order Error 
              return null;   
             }    
        }
      else
        {
           return null;
        }    
     
  }  
    //Wrapper Class to get Selected SalesOrders From VF Page 
    public class SalesOrderWrapper
    {
        public SalesOrderWrapper(SCMC__Sales_Order__c sOrder)
        {
            this.item = sOrder;
        }
        public SCMC__Sales_Order__c item {get;set;}
        public boolean Selected {get;set;}
        
    }
    
}