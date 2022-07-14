/*
     Description  : Controller class for Mass update Sales Order Line Items from Sales Order.
     Created By   : Abhinav Sharma
     Created Date : 10/14/2019
     Revision Log : v1.0
*/
public with sharing class SOLineItemsMassUpdateController 
{
    public SCMC__Sales_Order__c salesOrder {get; set;}
    public ApexPages.StandardController stdCon {get; set;}
    
    public List<SalesOrderLineItemWrapper> listOfSalesOrderLineItemsWrapper { get; set; }
    
    public List<SelectOption> lineItemDiscountReasonOptions{get;set;}
    public List<SelectOption> updatableItemsScopeOptions{get;set;}
    public List<SelectOption> lineItemLineTypeOptions{get;set;}
    public Decimal discountValue{get;set;}
    public String discountNote{get;set;}
    
    Set<Id> setOfEligibleLineTypesIds;
    
    public SOLineItemsMassUpdateController(ApexPages.StandardController stdController) 
    {
        stdCon = stdController;
        salesOrder = (SCMC__Sales_Order__c)stdController.getRecord();
        listOfSalesOrderLineItemsWrapper = new List<SalesOrderLineItemWrapper>();
        discountNote = '';
        if (salesOrder != null) 
        {
            try 
            {
                setOfEligibleLineTypesIds = new Set<Id>();
                setOfEligibleLineTypesIds.add(Schema.SObjectType.SCMC__Sales_Order_Line_Item__c.getRecordTypeInfosByDeveloperName().get('Item').getRecordTypeId());
                setOfEligibleLineTypesIds.add(Schema.SObjectType.SCMC__Sales_Order_Line_Item__c.getRecordTypeInfosByDeveloperName().get('Drop_Ship').getRecordTypeId());
        		
                Integer cnt = 1;
                for (SCMC__Sales_Order_Line_Item__c item : [SELECT Id, Name, Discount_Reason__c, RecordType.Name ,RecordTypeId,
                                                            Discount__c, Discount_Notes__c, SCMC__Line_Type__c,
                                                            SCMC__Sales_Order__c, SCMC__Status__c, Item__c
                                                            FROM SCMC__Sales_Order_Line_Item__c
                                                            WHERE SCMC__Sales_Order__c != null
                                                            AND SCMC__Sales_Order__c =: salesOrder.Id
                                                           ])
                {
                    if(setOfEligibleLineTypesIds.contains(item.RecordTypeId)) 
                    {
                    	listOfSalesOrderLineItemsWrapper.add(new SalesOrderLineItemWrapper(item, false, cnt, true));
                    }
                    else 
                    {
                    	listOfSalesOrderLineItemsWrapper.add(new SalesOrderLineItemWrapper(item, false, cnt, false));    
                    }
                    cnt++;
                }
                
                initSalesOrderLineItemDiscountReasonOptions();
                initUpdatableItemsScopeOptions();
                initSalesOrderLineItemLineTypeOptions(setOfEligibleLineTypesIds);
            }
            catch (System.QueryException ex) 
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, System.Label.Unable_To_Find_Sales_Order));
            }
            catch (System.Exception ex) 
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage()));
            }
        }
        else 
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, System.Label.Unable_To_Find_Sales_Order));    
        }
    }
    public Pagereference doSave() 
    {
        if(listOfSalesOrderLineItemsWrapper.size() > 0) 
        {
            try 
            {
                List<SCMC__Sales_Order_Line_Item__c> listOfSOLineItemsToBeUpdated = new List<SCMC__Sales_Order_Line_Item__c>();
                for(SalesOrderLineItemWrapper sOLW : listOfSalesOrderLineItemsWrapper) 
                {
                    if(sOLW.Item != null) 
                    {
                        listOfSOLineItemsToBeUpdated.add(sOLW.Item);
                        sOLW.errorMessage = null;
                    }    
                }
                if(listOfSOLineItemsToBeUpdated.size() > 0) 
                {
                    Integer recordCount = 0;
                    Boolean isErrorExists = false;
                    for(Database.SaveResult updateResult : Database.update(listOfSOLineItemsToBeUpdated, false)) 
                    {
                        if(!updateResult.isSuccess()) 
                        {
                            for(Database.Error err : updateResult.getErrors()) 
                            {
                                listOfSalesOrderLineItemsWrapper[recordCount].errorMessage = '<b>' + 'Row ' + listOfSalesOrderLineItemsWrapper[recordCount].srNo + ' : </b> ' + err.getMessage() + '<br/>';
                            }
                            isErrorExists = true;
                        } 
                        else {}
                        recordCount++;
                    }
                    if(isErrorExists) 
                    {
                        for(SalesOrderLineItemWrapper sW : listOfSalesOrderLineItemsWrapper) 
                        {
                            if(String.isNotBlank(sW.errorMessage)) 
                            {
                            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, sW.errorMessage));        
                            }
                        }
                        return null;
                    }
                }
                return stdCon.view();
            }
            catch (System.Exception ex) 
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage()));
                return null;
            }
        }
        else 
        {
            return stdCon.view();        
        }
    }
    public class SalesOrderLineItemWrapper 
    {
        public SCMC__Sales_Order_Line_Item__c Item { get; set; }
        public Boolean selected {get; set;}
        public Integer srNo {get; set;}
        public string errorMessage {get; set;}
        public Boolean isUpdatableLineType {get; set;}
        public SalesOrderLineItemWrapper(SCMC__Sales_Order_Line_Item__c Item, Boolean selected, Integer srNo, Boolean isUpdatableLineType) 
        {
            this.item = item;
            this.selected = selected;
            this.srNo = srNo;
            this.errorMessage = null;
            this.isUpdatableLineType = isUpdatableLineType;
        }
    }
    private void initUpdatableItemsScopeOptions() 
    {
        updatableItemsScopeOptions = new List<SelectOption>();
        updatableItemsScopeOptions.add(new SelectOption('ALL', 'Set All items to...'));
        updatableItemsScopeOptions.add(new SelectOption('SELECTED', 'Set Selected items to...'));
    }
    private void initSalesOrderLineItemDiscountReasonOptions() 
    {
        Schema.DescribeFieldResult customItemField = Schema.sObjectType.SCMC__Sales_Order_Line_Item__c.fields.Discount_Reason__c;
        List<Schema.PicklistEntry> pickListEntries = customItemField.picklistValues;
        lineItemDiscountReasonOptions = new List<SelectOption>();
        lineItemDiscountReasonOptions.add(new SelectOption('', '--none--'));
        for (Schema.PicklistEntry pl : pickListEntries) 
        {
            lineItemDiscountReasonOptions.add(new SelectOption(pl.value, pl.label));
        }
    }
    private void initSalesOrderLineItemLineTypeOptions(Set<Id> setOfEligibleLineTypesIds) 
    {
        if(setOfEligibleLineTypesIds.size() > 0) 
        {
            lineItemLineTypeOptions = new List<SelectOption>();
            for (RecordTypeInfo rtf : SCMC__Sales_Order_Line_Item__c.SObjectType.getDescribe().getRecordTypeInfos()) 
            {
                if(setOfEligibleLineTypesIds.contains(rtf.getRecordTypeId())) 
                {
                    lineItemLineTypeOptions.add(new SelectOption(rtf.getRecordTypeId(), rtf.getName()));         
                }
            }        
        }
    }
}