/**
*   Purpose         :   This is trigger helper class for OrderSizeTrigger
*   Created By      :   
*   Created Date    :   05/28/2020
*   Revision Log    :   v1.0 - Created - 05/28/2020
**/
public with sharing class OrderSizeTriggerHelper 
{
    
    public static void populateReccomendedAndRecommendedOverride(List<Order_Sizes__c> newOrderSizes, Map<Id, Order_Sizes__c> oldmapOrderSizes)
    {
        for(Order_Sizes__c os : newOrderSizes)
        {
            
            if(String.isNotBlank(os.full_recommended_sizes__c))
            {
                if(oldmapOrderSizes != null)
                {
                    if(! os.full_recommended_sizes__c.equals(oldmapOrderSizes.get(os.Id).full_recommended_sizes__c))
                    {
                        
                        if(os.Order_Overrides__c){
                            handleParserOverride(os);
                        }else{
                            handleParser(os);
                        }
                        
                        //Paring of individual measeurement
                        parseIndividualMeasurement(os);
                    }
                }
                else
                {
                    //Paring of individual measeurement
                    parseIndividualMeasurement(os);
                    handleParser(os);
                }
            }
        }
    }
    
    public static void updateNumonOpportunity(List<Order_Sizes__c> newOrderSizes)
    {
        
        Set<Id> CustomItemIds = new Set<Id>();
        Set<Id> setStandardItemId = new Set<Id>();
        Set<Id> opportunityIds = new set<Id>();
        
        
        for(Order_Sizes__c os : newOrderSizes)
        {
            if(os.Order__c != null){
                CustomItemIds.add(os.Order__c);
            }
            
            if(os.standard_order__c != null){
                setStandardItemId.add(os.standard_order__c);
            }
        }
        if(CustomItemIds.size() > 0){
            
            for(Custom_Item__c cc : CustomItemDAO.getCustomItemOppRelation(CustomItemIds)){
                opportunityIds.add(cc.Opportunity__c);
            }
        }
        if(setStandardItemId.size() > 0){
            
            for(Standardized_Item__c cc : StandardizedItemDAO.getStandardizedItemOppRelation(setStandardItemId)){
                opportunityIds.add(cc.Opportunity__c);
            }
        }
        
        system.debug('opp ids ---'+opportunityIds);
        if(opportunityIds.size() > 0){
            OrderSizeTriggerHelper.invokeOpportunityUpdate(opportunityIds);
        }
    }
    
    
    @future(callout=true)
    private static void invokeOpportunityUpdate(Set<Id> opportunityIds) 
    {
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        Map<Id,Opportunity> mapOfOpportunityWithCustomItem = new Map<Id,Opportunity>([select Id,(select Id,order_id__c,Opportunity__c ,Gender__c,Stage__c from Custom_Items__r) from Opportunity where Id IN: opportunityIds]);
        Map<Id,Opportunity> mapOfOpportunityWithStandardizedItem = new Map<Id,Opportunity>([SELECT Id,(select Id, Opportunity__c,order_id__c ,Stage__c,Product_Name__c from Standardized_Items__r) FROM Opportunity where Id IN: opportunityIds]);
        
        Map<Id,Custom_Item__c> mapOfCustomItemWithOrderSize = new Map<Id,Custom_Item__c>([select id,order_id__c,Opportunity__c ,Gender__c,Stage__c,(select id from Order_Sizes__r) from Custom_Item__c where Opportunity__c IN: opportunityIds]);
        Map<Id,Standardized_Item__c> mapOfStandardItemWithOrderSize = new Map<Id,Standardized_Item__c>([SELECT Id, Opportunity__c,order_id__c ,Stage__c,Product_Name__c,(select id from Order_Sizes__r) FROM Standardized_Item__c where  Opportunity__c IN: opportunityIds]);
        
        system.debug('mapOfOpportunityWithCustomItem'+mapOfOpportunityWithCustomItem);
        for(Id oppId : opportunityIds){
            
            Integer customCountMale = 0;
            Integer customCountFeMale = 0;
            Integer standCountMale = 0;
            Integer standCountFeMale = 0;
            
            Opportunity opps = new Opportunity();
            opps.Id= oppId;
            opps.Is_Item_Finished__c = false;
            if(mapOfOpportunityWithCustomItem.containsKey(oppId)){
                
                List<Custom_Item__c> customItems = mapOfOpportunityWithCustomItem.get(oppId).Custom_Items__r;
                
                system.debug('customItems'+customItems);
                for(Custom_Item__c cc : customItems){
                    List<Order_Sizes__c> orderSizes = mapOfCustomItemWithOrderSize.get(cc.Id).Order_Sizes__r;
                    
                    SYstem.debug('order sizes '+ordersizes);
                    if(orderSizes.size() > 0 && String.isNotBlank(cc.order_id__c) && cc.Gender__c == 'Girl' && cc.Stage__c != 'Grey Out'){
                        system.debug('in girl ');
                        customCountFeMale+=1;
                        opps.Finished_Girl_FF_Custom_Items__c = customCountFeMale;
                    }
                    if(orderSizes.size() > 0 && String.isNotBlank(cc.order_id__c) && cc.Gender__c == 'boy' && cc.Stage__c != 'Grey Out'){
                        
                        customCountMale+=1;
                        opps.Finished_Boy_FF_Custom_Items__c = customCountMale;
                    }
                } 
            }
            
            if(mapOfOpportunityWithStandardizedItem.containsKey(oppId)){
                
                List<Standardized_Item__c> standardItems = mapOfOpportunityWithStandardizedItem.get(oppId).Standardized_Items__r;
                for(Standardized_Item__c si : standardItems){
                    List<Order_Sizes__c> orderSizes = mapOfStandardItemWithOrderSize.get(si.Id).Order_Sizes__r;
                    if(orderSizes.size() > 0  && String.isNotBlank(si.order_id__c) && String.isNotBlank(si.Product_Name__c) && (si.Product_Name__c.contains('boy') || si.Product_Name__c.contains('Boy')) && si.Stage__c != 'Grey Out'){
                        
                        standCountMale+=1;
                        opps.Finished_Boy_FF_Standard_Items__c = standCountMale;
                    }
                    if(orderSizes.size() > 0 && String.isNotBlank(si.order_id__c)  && String.isNotBlank(si.Product_Name__c) && (!si.Product_Name__c.contains('boy ') || !si.Product_Name__c.contains('Boy')) && si.Stage__c != 'Grey Out'){
                        
                        standCountFeMale+=1;
                        opps.Finished_Girl_Standard_Items__c = standCountFeMale;
                    }
                }
            }
            
            
            if(customCountFeMale == 0)
                opps.Finished_Girl_FF_Custom_Items__c = 0;
            if(customCountMale == 0)
                opps.Finished_Boy_FF_Custom_Items__c = 0;
            if(standCountMale == 0)
                opps.Finished_Boy_FF_Standard_Items__c = 0;
            if(standCountFeMale == 0)
                opps.Finished_Girl_Standard_Items__c = 0;
            
            oppToUpdate.add(opps);
        }
        
        system.debug('oppToUpdate--'+oppToUpdate);
        if(oppToUpdate.size() > 0){
            update oppToUpdate; 
        }
    }
    
    private static void handleParser(Order_Sizes__c os)
    {
        try
        {
            JSONParser parserRec = JSON.createParser(os.full_recommended_sizes__c);
            while (parserRec.nextToken() != null) 
            {
                if(parserRec.getCurrentName() != parserRec.getText())
                {
                 if(parserRec.getCurrentName() == 'recommended')
                 {
                     os.Recommended__c = parserRec.getText();
                 }
                 
                 if(parserRec.getCurrentName() == 'recommended_override')
                 {
                     os.Recommended_Override__c = parserRec.getText();
                 }
                }
            }
            
            
        }
        catch(Exception e)
        {
            
        }
        
    }
    
  
    
    
    private static void parseIndividualMeasurement(Order_Sizes__c os)
    { 
        try
        {
            SYstem.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
            
            if(os.full_recommended_sizes__c.contains('measured'))
            {
                Map<String,String> mapOfMeasurement = new Map<String,String>
                {
                    'hip-front'  =>  'Hip_Front__c',
                        'shoulder'  =>  'Shoulder__c',
                        'waist-front'  =>  'Waist_Front__c',
                        'chest-front'  =>  'Chest_Front__c',
                        'torso-front'  =>  'Torso_Front__c',
                        'inseam'  =>  'Inseam__c',
                        'inseam-default'  => 'Inseam_Default__c',
                        'sleeve-top-default'  => 'Sleeve_Top_Default__c',
                        'sleeve-bottom-default'  =>  'Sleeve_Bottom_Default__c',
                        'hip-side'  =>  'Hip_Side__c',
                        'waist-side'  =>  'Waist_Side__c',
                        'chest-side'  =>  'Chest_Side__c',
                        'school-skirt-side-straight'  =>  'School_Skirt_Side_Straight__c',
                        'school-skirt-side-diag'  =>  'School_Skirt_Side_Diag__c',
                        'school-skirt-side-top'  => 'School_Skirt_Side_Top__c',
                        'school-skirt-side-bottom'  => 'School_Skirt_Side_Bottom__c',
                        'school-skirt-side'  =>  'School_Skirt_Side__c',
                        'all-star-skirt-side-straight'  =>  'All_Star_Skirt_Side_Straight__c',
                        'all-star-skirt-side-diag'  =>  'All_Star_Skirt_Side_Diag__c',
                        'all-star-skirt-side-top'  =>  'All_Star_Skirt_Side_Top__c',
                        'all-star-skirt-side-bottom'  =>  'All_Star_Skirt_Side_Bottom__c',
                        'all-star-skirt-side'  =>  'All_Star_Skirt_Side__c',
                        'hip'  => 'Hip__c',
                        'waist'  => 'Waist__c',
                        'chest'  =>  'Chest__c',
                        'torso'  =>  'Torso__c',
                        'sleeve'  =>  'Sleeve__c',
                        'body'  =>  'Body__c',
                        'capri'  =>  'Capri__c',
                        'school skirt'  =>  'School_Skirt__c',
                        'all star skirt'  => 'All_Star_Skirt__c',
                        'legging'  => 'Legging__c'
                        };
                            
                String measuredJSON = os.full_recommended_sizes__c.substringBetween('measured":', '}');
                measuredJSON += '}';
                
                System.debug('measuredJSON = ' + measuredJSON);
                
                JSONParser measurementJSON = JSON.createParser(measuredJSON);
                System.debug('Inside measurementJSON');  
                Sobject sObj = os;
                System.debug('Before Soobject');
                
                while (measurementJSON.nextToken() != null) 
                {
                    if(measurementJSON.getCurrentName() != measurementJSON.getText())
                    {
                        if(mapOfMeasurement.containskey(measurementJSON.getCurrentName()))
                        {
                            
                            sObj.put(mapOfMeasurement.get(measurementJSON.getCurrentName()), measurementJSON.getText());
                        }
                    }
                }
                System.debug(sObj);
                os = (Order_Sizes__c)sObj;
            }
            
        }          
        catch(Exception e)
        {
            SYstem.debug('Catch Error = ' + e.getMessage());
        }
        SYstem.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    }
    
    private static void handleParserOverride(Order_Sizes__c os)
    {
        try
        {
            JSONParser parserRec = JSON.createParser(os.full_recommended_sizes__c);
            while (parserRec.nextToken() != null) 
            {
                if(parserRec.getCurrentName() != parserRec.getText())
                {
                 if(parserRec.getCurrentName() == 'recommended')
                 {
                     os.Recommended_Override__c = parserRec.getText();
                 }
                 
                 if(parserRec.getCurrentName() == 'recommended_override')
                 {
                     os.Recommended_Override__c = parserRec.getText();
                 }
                }
            }
        }
        catch(Exception e)
        {
        }
        
    }
    
    public static void updateCustomItemWithRecommendSizes(List<Order_Sizes__c> newOrderSizes, Map<Id, Order_Sizes__c> oldmapOrderSizes){
        
        Set<Id> CustomItemIds = new Set<Id>();
        Set<Id> setStandardItemId = new Set<Id>();
        
        if(oldmapOrderSizes == null || (oldmapOrderSizes != null && newOrderSizes != oldmapOrderSizes.values())){
            for(Order_Sizes__c os : newOrderSizes){
                
                if(os.Order__c != null){
                    CustomItemIds.add(os.Order__c);
                }
                
                if(os.standard_order__c != null){
                    setStandardItemId.add(os.standard_order__c);
                }
            }
        }
        //invokeCountonItems(CustomItemIds,setStandardItemId);
        
    }
    
    @future(callout=true)
    private static void invokeCountonItems(Set<Id> CustomItemIds,Set<Id> setStandardItemId) 
    {
        Integer countCust = 0;
        Integer countStand = 0;
        List<Custom_Item__c> customItemToUpdate = new List<Custom_Item__c>();
        List<Standardized_Item__c> standardItemToUpdate = new List<Standardized_Item__c>();
        
        if(CustomItemIds.size() > 0){
            for(Custom_Item__c cc : CustomItemDAO.getCustomItemInLine(CustomItemIds)){
                countCust = 0;
                Custom_Item__c cust = new Custom_Item__c();
                cust.Id = cc.Id;
                for(Order_Sizes__c oz : cc.Order_Sizes__r){
                    if(String.IsnotBlank(oz.recommended_sizes__c)){
                        countCust+=1;
                    }
                }
                cust.Rollup_of_total_number_of_order_sizes__c = countCust;
                customItemToUpdate.add(cust);
            }
        }
        if(setStandardItemId.size() > 0){
            for(Standardized_Item__c st : StandardizedItemDAO.getStandardizedItemInLine(setStandardItemId)){
                countStand = 0;
                Standardized_Item__c cust = new Standardized_Item__c();
                cust.Id = st.Id;
                for(Order_Sizes__c oz : st.Order_Sizes__r){
                    if(String.IsnotBlank(oz.recommended_sizes__c)){
                        countStand+=1;
                    }
                }
                cust.Rollup_of_total_number_of_order_sizes__c = countStand;
                standardItemToUpdate.add(cust);
            }
        }
        
        if(customItemToUpdate.size() > 0){
            update customItemToUpdate;
        }
        
        if(standardItemToUpdate.size() > 0){
            update standardItemToUpdate;
        }
    }
    public static void updateItemNumberOnOrderSizes(List<Order_Sizes__c> newOrderSizes){
        
        List<Order_Sizes__c> orderSizesToUpdate = new List<Order_Sizes__c>();
        
        for(Order_Sizes__c os : newOrderSizes){
            
            Order_Sizes__c orders = new Order_Sizes__c();
            orders.Id = os.Id;
            orders.Item_Number__c = os.FF_Item_Number__c;
            
            orderSizesToUpdate.add(orders);
        }
        
        if(orderSizesToUpdate.size() > 0){
            update orderSizesToUpdate;
        }
        
    }
    /* public static void updateGenerateAFSOnOpportunity(List<Order_Sizes__c> newOrderSizes){

Set<Id> oppIds = new Set<Id>();

for(Order_Sizes__c os : newOrderSizes){
if(os.Opportunity__c != null){
oppIds.add(os.Opportunity__c);
}

}

List<Opportunity> oppToBeUpdate = new List<opportunity>();

if(oppIds.size() > 0){

for(Opportunity opp : [SELECT Id,Create_Date_AFS__c, Generate_AFS__c FROM Opportunity where Id IN: oppIds]){
for(Order_Sizes__c os : newOrderSizes){
if(os.Opportunity__c == opp.Id){
Opportunity op = new Opportunity();
op.Id = opp.Id;
if(Os.Gender__c == 'Male'){
op.Generate_M_AFS__c = true;
}else if(Os.Gender__c == 'FeMale'){
op.Generate_AFS__c = true;
}
op.Create_Date_AFS__c = system.now();
oppToBeupdate.add(op);
}
}
}

if(oppToBeUpdate.size() > 0){
update oppToBeUpdate;
}

}

}*/
}