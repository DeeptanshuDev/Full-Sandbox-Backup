/**
*   Description     :   Class to clone the custom Item and standard Item from opportunity and create the new record
                        of opprtunity,custom Item and standard Item.
* 
*   Version         :   v1.1 - Created - CR - 00000066 - Abhinav Sharma - 01/13/2020       
**/ 
public with sharing class CloneOpportunityCtrl 
{
    public List<CustomItemWrapper> customItemList {get;set;}
    public List<StandardizedItemWrapper> StandardizedItemList{ get; set; }
    
    private final Opportunity opp;
    private final ApexPages.StandardController controller;
    
    public CloneOpportunityCtrl(ApexPages.StandardController cont) 
    {
        controller = cont;
        opp = (Opportunity) controller.getRecord();
        StandardizedItemList = new List<StandardizedItemWrapper>();
        customItemList = new List<CustomItemWrapper>();
        List<Custom_Item__c> customItems = new List<Custom_Item__c>();
        List<Standardized_Item__c> standardizedItems = new List<Standardized_Item__c>();
        
        if(String.isNotBlank(opp.Id))
        {
            for(Custom_Item__c item : [Select Name,Category__c,Collection__c,Gender__c,Fabric_Options__c,
                                       Price_per_item__c,Item_Number_Edit__c,Style__c,Style_Name__c,Category_Subtype__c,
                                       Sub_Collection__c,Product_Style__c,Product_Style_Subcategory__c,
                                       Style_Category__c,Style_Subcategory__c 
                                       FROM Custom_Item__c
                                       WHERE Opportunity__c = :opp.Id 
                                       AND Stage__c !=: System.Label.Stage_Grey_Out])
            {
                Custom_Item__c newItem = item.clone();
                newItem.Quantity__c = 0;
                newItem.Item_Number_Edit__c = null;
                newItem.Custom_Item_Reorder__c = item.Id;
                customItemList.add(new CustomItemWrapper(newItem));
            }
        
            for(Standardized_Item__c stndItem : [Select Name,Opportunity__c,Stage__c,Fulfillment_Type__c,Product__c,Product_Code__c,
                                                 Product_Description__c,Quantity__c,Pipeline_Category__c,Stated_Quantity__c,
                                                 Stock_Item__c,Product_Family__c
                                                 FROM Standardized_Item__c
                                                 WHERE Opportunity__c = :opp.Id 
                                                 AND Stage__c !=: System.Label.Stage_Grey_Out])
            {
                Standardized_Item__c newStndItem = stndItem.clone();
                newStndItem.Quantity__c = 0;
                if(newStndItem.Stated_Quantity__c == 0 || newStndItem.Stated_Quantity__c == null)
                    newStndItem.Stated_Quantity__c = 0;
               
                StandardizedItemList.add(new StandardizedItemWrapper(newStndItem));
            }
        }
    }
    
    //Method to perform clone functionality
    public PageReference doClone() 
    {   
        Date oppCreatedDate = system.today();
        Date validDate = Date.newInstance(2019, 12, 08);
        
        If( oppCreatedDate > validDate && opp.CloseDate < Date.ValueOf(oppCreatedDate))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Event Date should be greater than Today\''+'s Date.'));
            return null; 
        } 
        else
        {
            try
            {
                CloneOpportunity cloneOpp = new CloneOpportunity(opp.Id);
                cloneOpp.CloseDate = opp.CloseDate;
                cloneOpp.FactoryShipTo = opp.Factory_Ship_To__c;
                cloneOpp.PrimaryContact = opp.Primary_Contact__c;
                if(customItemList.size() > 0)
                {
                    for (CustomItemWrapper item : customItemList) 
                    {
                        if (item.Selected) 
                        {
                            cloneOpp.addCustomItem(item.customItem);
                        }
                    }
                }
                
                if(StandardizedItemList.size() > 0)
                {
                    for (StandardizedItemWrapper stndrditem : StandardizedItemList) 
                    {
                        if (stndrditem.Selected) 
                        {
                            cloneOpp.addStandardizedItem(stndrditem.standardItem);
                        }
                    }
                }
                
                Opportunity newOpp = cloneOpp.doClone();
                if(newOpp != null)
                {
                    return new ApexPages.StandardController(newOpp).view();
                }
                else{
                    return null;
                } 
            }
            catch(DMLException ex)
            {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));   
                return null;
            }   
        }
        
    }
    
    public class CustomItemWrapper 
    {
        public CustomItemWrapper(Custom_Item__c item) 
        {
            this.customItem = item;
        }
        public Custom_Item__c customItem {get;set;}
        public Boolean Selected {get;set;}
    }
    
    public class StandardizedItemWrapper 
    {
        public StandardizedItemWrapper(Standardized_Item__c item)
        {
            this.standardItem = item;
        }
        public Standardized_Item__c standardItem {get;set;}
        public Boolean Selected {get;set;}
    }
    
}