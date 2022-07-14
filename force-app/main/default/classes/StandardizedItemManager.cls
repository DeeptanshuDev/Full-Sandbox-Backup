public class StandardizedItemManager {
    
    
    public void beforeInsert(List<Standardized_Item__c> items)
    {
        setCalculatedFields(items); //@@
    }
    
    public void beforeUpdate(List<Standardized_Item__c> items, Map<Id, Standardized_Item__c> oldItemMap)
    {
        setCalculatedFields(items); //@@
    }
    
    public void afterInsert(List<Standardized_Item__c> items, Map<Id, Standardized_Item__c> newItemMap)
    {
        Set<Id> oppIds = new Set<Id>();
        Set<Id> itemIds = new Set<Id>();
        
        for(Standardized_Item__c item : items)
        {
            //Handling for AFS field on Opportunity
            if( item.Opportunity__c != null && (item.FF_Is_Submitted__c || item.FF_Create_Item_Successful__c || String.isNotBlank(item.order_id__c)))
            {
                oppIds.add(item.Opportunity__c);
            }
            
            //Getting item id whose Opportunity != null to Popolate Account Lookup
            if(item.Opportunity__c != null)
            {
                itemIds.add(item.Id);
            }
        }
        
        if(itemIds.size() > 0)
        {
            populateAccountId(itemIds);
        }
        
        System.debug('After Insert = ' + oppIds);
        if(oppIds.size() > 0)
        {
            handle_AFS_FieldOnOpportunity(oppIds);
        }
    }
    
    public void afterUpdate(List<Standardized_Item__c> items, Map<Id, Standardized_Item__c> oldItemMap)
    {
        Set<Id> oppIds = new Set<Id>();
        Set<Id> itemIds = new Set<Id>();
        
        for(Standardized_Item__c item : items)
        {
            //Handling for AFS field on Opportunity
            if( item.Opportunity__c != null 
               && (item.Opportunity__c != oldItemMap.get(item.Id).Opportunity__c
                   || item.FF_Is_Submitted__c != oldItemMap.get(item.Id).FF_Is_Submitted__c
                   || item.order_id__c != oldItemMap.get(item.id).order_id__c
                   || item.FF_Create_Item_Successful__c != oldItemMap.get(item.id).FF_Create_Item_Successful__c
                   
                  )
              )
            {
                oppIds.add(item.Opportunity__c);
            }
            
            //Getting item id whose Opportunity != null to Popolate Account Lookup
            if(item.Opportunity__c != null && (item.Account_Lookup__c == null || item.Opportunity__c != oldItemMap.get(item.Id).Opportunity__c))
            {
                itemIds.add(item.Id);
            }
        }
        
        if(itemIds.size() > 0)
        {
            populateAccountId(itemIds);
        }
        
        System.debug('Hello = ' + oppIds);
        if(oppIds.size() > 0)
        {
            handle_AFS_FieldOnOpportunity(oppIds);
        }
    }

    private void populateAccountId(Set<Id> itemIds)
    {
        SYstem.debug('itemIds = ' + itemIds);
                List<Standardized_Item__c> itemsToUpdate = new List<Standardized_Item__c>();

        List<Standardized_Item__c> items = StandardizedItemDAO.getStandardizedItemAccLookup(itemIds);
        
        for(Standardized_Item__c item : items)
        {
            if(item.Opportunity__r.Account.Id != null)
            {
                Standardized_Item__c cc = new Standardized_Item__c();
                cc.Id = item.Id;
                cc.Account_Lookup__c = item.Opportunity__r.Account.Id;
                itemsToUpdate.add(cc);
            }
        }
        
        if(itemsToUpdate.size() > 0)
        {
            update itemsToUpdate;
        }
    }
    
    private void handle_AFS_FieldOnOpportunity (Set<Id> oppIds)
    {
        System.debug('opportunityIds = ' + oppIds);
        Set<Id> removedOpps = new Set<Id>();
        List<Standardized_Item__c> sItems = StandardizedItemDAO.StandardizedItems(oppIds);
        
        for(Standardized_Item__c item : sItems)
        {
            System.debug('sitem' +  ' - ' + item.id  + ' - ' + item.FF_Is_Submitted__c + ' - ' + item.FF_Create_Item_Successful__c  + ' - ' + item.order_id__c);
            if(oppIds.contains(item.Opportunity__c))
            {
                if(item.FF_Is_Submitted__c == FALSE && item.FF_Create_Item_Successful__c == FALSE && String.isBlank(item.order_id__c) 
                   || (item.FF_Is_Submitted__c && item.FF_Create_Item_Successful__c && String.isNotBlank(item.order_id__c)) 
                  )
                {
                    System.debug('x');
                    continue;
                }
                else
                {
                    System.debug('1');
                    removedOpps.add(item.Opportunity__c);
                    oppIds.remove(item.Opportunity__c);
                }
            }
        }
        
        System.debug('opportunityIds = ' + oppIds);
        if(oppIds.size() > 0)
        {
            List<Custom_Item__c> cItems = CustomItemDAO.getCustomItemWithOpportunity(oppIds);
            
            for(Custom_Item__c item : cItems)
            {
                System.debug('Citem' + ' - ' + item.id  + ' - ' + item.FF_Is_Submitted__c + ' - ' + item.FF_Create_Item_Successful__c + ' - ' + item.order_id__c);
                if(oppIds.contains(item.Opportunity__c))
                {
                    if(item.FF_Is_Submitted__c == FALSE && item.FF_Create_Item_Successful__c == FALSE && String.isBlank(item.order_id__c) 
                       || (item.FF_Is_Submitted__c && item.FF_Create_Item_Successful__c && String.isNotBlank(item.order_id__c)) 
                      )
                    {
                        System.debug('y');
                        continue;
                    }
                    else
                    {
                        System.debug('2');
                        removedOpps.add(item.Opportunity__c);
                        oppIds.remove(item.Opportunity__c);
                    }
                }
            }
            
            System.debug('opportunityIds = ' + oppIds);
            if(oppIds.size() > 0)
            {
                List<Opportunity> oppsToUpdate = new List<Opportunity>();
                for(ID oId : oppIds)
                {
                    oppsToUpdate.add(new  Opportunity(Id = oId, Create_AFS__c = TRUE));
                }
                
                if(oppsToUpdate.size() > 0)
                {
                    Util.BypassAllTriggers = true;
                    update oppsToUpdate;
                    Util.BypassAllTriggers = false;
                }
            }
        }
        
        System.debug('remove' + removedOpps);
        if(removedOpps.size() > 0)
        {
            List<Opportunity> oppsToUpdate = new List<Opportunity>();
            for(ID oId : removedOpps)
            {
                oppsToUpdate.add(new  Opportunity(Id = oId, Create_AFS__c = false));
            }
            
            if(oppsToUpdate.size() > 0)
            {
                Util.BypassAllTriggers = true;
                update oppsToUpdate;
                Util.BypassAllTriggers = false;
            }
        }
    }
    
    private void setCalculatedFields(List<Standardized_Item__c> items) {
        for (Standardized_Item__c item : items) {
            item.Shipping_per_Item__c = null;
            if (item.Total_Price_per_Item__c != null) {
                item.Shipping_per_Item__c = item.Total_Price_per_Item__c
                    * Constants.STANDARDIZED_ITEM_SHIPPING_RATE;
            }
        }
    }
    
    
    /*
    *	Method is used to update the FIt on the Standardized Items 
    */    
    public void updateFitOnStandardizedItem(List<Standardized_Item__c> items, Map<Id, Standardized_Item__c> oldItems)
    {
        Set<String> setStandardizedItemsStyles = new Set<String>();
        Map<Id,List<Fit__c>> mapFitWithCustomItems = new Map<Id,List<Fit__c>>();
        for(Standardized_Item__c si : items)
        {
            if((String.isNotBlank(si.Style__c) && oldItems == null) || (oldItems!= null && si.Style__c != oldItems.get(si.Id).style__c))
            {
                List<String> str = si.Style__c.split('-');
                setStandardizedItemsStyles.add(str[0].trim());
            }
        }
        
        List<Standardized_Item__c> standardizedItemToUpdate = new List<Standardized_Item__c>();
         List<Fit__c> fitDet = new List<Fit__c>();
        
        for(Fit__c fits : FitDAO.getFits())
        {
            for(String str : setStandardizedItemsStyles){
                if(fits.Name.contains(str))
                {
                    fitDet.add(fits);   
                }
            }   
        }
        
        system.debug('fit det'+fitDet);
            for(Standardized_Item__c cc : items){
                if(String.isnotBlank(cc.Style__c) ){
                    for(String str : setStandardizedItemsStyles){
                        for(Fit__c fits : fitDet){
                            if(cc.Style__c.contains(str) && fits.Name.startswith(str)){
                                if(!mapFitWithCustomItems.containskey(cc.Id)){
                                    mapFitWithCustomItems.put(cc.Id,new List<Fit__c>{fits});
                                }else{
                                    mapFitWithCustomItems.get(cc.Id).add(fits);
                                }
                            }
                        }
                    }
                }
            }
         for(Standardized_Item__c cc : items){
            if(String.isnotBlank(cc.Style__c)){
                system.debug('mapFitWithCustomItems '+mapFitWithCustomItems);
                    if(mapFitWithCustomItems != null && mapFitWithCustomItems.size()> 0 && mapFitWithCustomItems.containskey(cc.Id) && mapFitWithCustomItems.get(cc.Id).size() <= 1){
                        Standardized_Item__c cust = new Standardized_Item__c();
                        cust.Fit__c = mapFitWithCustomItems.get(cc.Id)[0].Id;
                        cust.Id = cc.Id;
                        standardizedItemToUpdate.add(cust);
                }
            }
        }
      
        system.debug('standardizedItemToUpdate----'+standardizedItemToUpdate);
        if(standardizedItemToUpdate.size() > 0)
        {
            update standardizedItemToUpdate;
        }
    }
    
    public void updateAFSCheckboxOpp(List<Standardized_Item__c> items, Map<Id, Standardized_Item__c> oldItems){
        
        set<Id> custIds = new Set<Id>();
        List<Opportunity> oppToBeUpdate = new List<Opportunity>();
        List<Standardized_Item__c> customItemToUpdate = new List<Standardized_Item__c>();
        for(Standardized_Item__c cus : items){
            if(cus.is_submitted__c == 'true' && cus.is_submitted__c != oldItems.get(cus.Id).is_submitted__c){
                custIds.add(cus.Id);
            }
        }
       
        for(Standardized_Item__c cs : StandardizedItemDAO.standardizedItemsInLineQuery(custIds)){
            
            if(cs.Order_sizes__r.size() > 0){
                Opportunity op = new Opportunity();
                Standardized_Item__c cust = new Standardized_Item__c();
                for(Order_sizes__c oz : cs.Order_Sizes__r){
                    
                    cust.Id = cs.Id;
                    cust.Pushed_to_AFS__c = true;
                    op.Id = cs.Opportunity__c;
                    if(Oz.Gender__c == 'Male'){
                        op.Generate_M_AFS__c = true;
                    }else if(Oz.Gender__c == 'Female'){
                        op.Generate_AFS__c = true;
                    }
                    op.Create_Date_AFS__c = system.now();
                    
                }
                customItemToUpdate.add(cust);
                oppToBeUpdate.add(op);
            }
        }
        
        if(customItemToUpdate.size() > 0){
            
            update customItemToUpdate;
        }
        system.debug('opportunity '+oppToBeUpdate);
        if(oppToBeUpdate.size() > 0){
            
            update oppToBeUpdate;
        }
    }
    
    public void updateStyleOnStandardizedItem(List<Standardized_Item__c> items, Map<Id, Standardized_Item__c> oldItems)
    {
        Map<String,String> setStandardizedItemsStyles = new Map<String,String>();
        for(Standardized_Item__c si : items)
        {
            if((String.isNotBlank(si.Product__c) && oldItems == null) || (oldItems!= null && si.Product__c != oldItems.get(si.Id).Product__c && String.isNotBlank(si.Product__c)))
            {
               
                setStandardizedItemsStyles.put(si.Id,si.Product__c);
            }
        }
        
        List<Product2> products = ProductsDAO.getProducts(setStandardizedItemsStyles.values());
        List<Standardized_Item__c> standardizedItemToUpdate = new List<Standardized_Item__c>();
        
        for(Standardized_Item__c si : items){
            for(Product2 str : products){
                if(setStandardizedItemsStyles.get(si.Id) == str.Id){
                    Standardized_Item__c sitem = new Standardized_Item__c();
                    sitem.Style__c = str.Standardized_Style_Number__c;
                    sitem.Id = si.Id;
                    standardizedItemToUpdate.add(sitem);
                }
            }
        }
        
        if(standardizedItemToUpdate.size() > 0)
        {
            update standardizedItemToUpdate;
        }
    }
    
    //added - Seemu Saikia - 06/15/2021
    public void updateMaxQuantityOnOpp(List<Standardized_Item__c> items){
        Set<Id> setOpportunity = new Set<Id>();
        Map<Id,Decimal> mapMaxQuantity  = new Map<Id,Decimal>();
        List<Opportunity> listUpdateOpp = new List<Opportunity>();
        
        for(Standardized_Item__c rec : items){
            setOpportunity.add(rec.Opportunity__c);
        }
        
        for(AggregateResult ar :[SELECT Opportunity__c, MAX(Quantity__c) maxQuantity FROM Standardized_Item__c WHERE Opportunity__c IN :setOpportunity GROUP BY Opportunity__c]){

            mapMaxQuantity.put((Id)ar.get('Opportunity__c'),(Decimal)ar.get('maxQuantity'));
        }
        
        for(AggregateResult ar :[SELECT Opportunity__c, MAX(Quantity__c) maxQuantity FROM Custom_Item__c WHERE Opportunity__c IN :setOpportunity GROUP BY Opportunity__c]){
			
            if(mapMaxQuantity.containsKey((Id)ar.get('Opportunity__c')) && (Decimal)ar.get('maxQuantity') > mapMaxQuantity.get((Id)ar.get('Opportunity__c'))){
            	mapMaxQuantity.put((Id)ar.get('Opportunity__c'),(Decimal)ar.get('maxQuantity'));    
            }
            
        }
        
        for(Id oppId : setOpportunity){
            
            listUpdateOpp.add(new Opportunity(Id = oppId,Max_Quantity_on_Custom_Items__c = mapMaxQuantity.get((oppId))));    
        }
        
        if(listUpdateOpp.size() > 0){
            update listUpdateOpp;
            
        }
	}
        
    
}