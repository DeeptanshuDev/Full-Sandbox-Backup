/**
*   Description     :   Class to clone the custom Item and standard Item from opportunity and create the new record
                        of opprtunity,custom Item and standard Item.
*
*   Version         :   v1.1 - Created - CR - 00000066 - Abhinav Sharma - 01/13/2020      
**/ 
/*
* Instantiate with Id of opportunity to clone.
* Set instance properties on this class, which will be transferred to the new Opportunity.
* Add custom items. These will be inserted into the database by this class.
* Call doClone().
*/
public without sharing class CloneOpportunity 
{
    public Date CloseDate { get; set;}
    public String FactoryShipTo { get; set; }
    public String PrimaryContact {get; set; }    
    private static final String REORDER_CUSTOM_ITEM_RECORD_TYPE_NAME = 'Reorder_Custom_Item';
    
    private Id opportunityId;
    private final Id customItemRecordTypeId;
    private List<Custom_Item__c> items = new List<Custom_Item__c>();
    private List<Standardized_Item__c> standardItems = new List<Standardized_Item__c>();
    
    public CloneOpportunity(Id opportunityId) 
    {
        this.opportunityId = opportunityId;
        customItemRecordTypeId = [SELECT Id FROM RecordType
                                  WHERE DeveloperName = :REORDER_CUSTOM_ITEM_RECORD_TYPE_NAME 
                                  AND SObjectType = 'Custom_Item__c'
                                  LIMIT 1].Id;
    }
    
    public Opportunity doClone() 
    {
        List<Opportunity> oppToBeInsert = new List<Opportunity>();
        if(String.isNotBlank(opportunityId))
        {
            for(Opportunity opp : [Select Id,Name,AccountId,Collection_Picklist__c , 
                                   Category_Picklist__c,Uniform_Style__c,Primary_Contact__c
                                   FROM Opportunity
                                   WHERE Id = :opportunityId])
            {
                Opportunity newOpp = opp.clone();
                newOpp.Probability = .9;
                newOpp.StageName = 'Open';
                newOpp.Prototype_Status__c = 'None';
                newOpp.Type = 'Reorder';
                newOpp.Payment_Status__c = 'Unpaid';
                newOpp.CloseDate = CloseDate;
                newOpp.Factory_Ship_To__c = FactoryShipTo;
                newOpp.Primary_Contact__c = PrimaryContact;
                oppToBeInsert.add(newOpp);
            }
        }
        else
        {  
            return null;
        }
        
        if(oppToBeInsert.size() > 0)
        {
            try
            {
                insert oppToBeInsert;
            }
            catch(Exception ex)
            {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));    
            }
        }
        
        try
        {
        
        if(items.size() > 0 && oppToBeInsert.size() > 0)
        {
            for (Custom_Item__c item : items) 
            {
                if(item.Quantity__c < 0)
                {    
                     throw new customException('Quantity of selected item can not be negative.');         
                }
                else if(item.Quantity__c > 999999999999999999L)
                {
                    throw new customException('Invalid Range. Quantity can not be greater than 18 digits.');   
                }
                item.Opportunity__c = oppToBeInsert[0].Id;
                item.RecordTypeId = customItemRecordTypeId;
            }
        }
        
        If(standardItems.size() > 0 && oppToBeInsert.size() > 0)
        {
            for(Standardized_Item__c stndItem : standardItems)
            {
                if(stndItem.Quantity__c < 0)
                {
                     throw new customException('Quantity of selected item can not be negative.');    
                }
                stndItem.Quantity__c = stndItem.Quantity__c;
                stndItem.Stage__c = 'Confirmed';
                stndItem.Opportunity__c = oppToBeInsert[0].Id;   
            }
        }
        
        
            if (!items.isEmpty()) 
            {
                Util.BypassAllTriggers = true;
                insert items;  
                
                Util.BypassAllTriggers = false;
            }
            
            if(!standardItems.isEmpty())
            {
                insert standardItems;           
            }
            
            return oppToBeInsert[0];
        }
        catch(Exception ex)
        {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage() +'new ---'+ex.getLineNumber()));  
             return null; 
        }
        
    }
    
    public void addCustomItem(Custom_Item__c item) 
    {   
        if(item != null)
        {
            items.add(item);
        }
    }
    
    public void addStandardizedItem(Standardized_Item__c stndrditem) 
    {
        if(stndrditem != null)
        {
            standardItems.add(stndrditem);
        }
    }
    
    public void addCustomItems(List<Custom_Item__c> items) {
        this.items.addAll(items);
    }
    
}