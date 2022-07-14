/**
 * @description       : 
 * @author            : Seemu Saikia
 * @group             : 
 * @last modified on  : 07-07-2021
 * @last modified by  : Seemu Saikia
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   07-07-2021   Seemu Saikia   Initial Version
 * 2.0	 01-12-2021	  Deeptanshu	 if the “Sales Order Type” is “Sponsor”, to automatically have the SOLI be 0% commission? Should finalize the commission updates.
 * 2.1	 01-11-2022	  Deeptanshu	 added some code in before insert a
**/
public class CustomItemTriggerHandler {
    public static Boolean HasRun = False;
    
    public void beforeInsert(List<Custom_Item__c> items) 
    {
        for(Custom_Item__c i : items)
        {
            if(String.isNotBlank(i.Style__c))
            {
                i.FF_Style__c = i.Style__c;
            }
            
            
        }
        
    }
    
    public void beforeUpdate(List<Custom_Item__c> items, Map<Id, Custom_Item__c> oldItems)
    {
        for(Custom_Item__c i : items)
        {
            if(String.isNotBlank(i.Style__c) && (oldItems.get(i.Id).Style__c != i.Style__c || oldItems.get(i.Id).FF_Style__c != i.FF_Style__c))
            {
                i.FF_Style__c = i.Style__c;
            }
        }
        preventSalesUsersToUpdateWholeSalePrice(items,oldItems);
        //updateRecords(items,oldItems);
        System.debug('you are in update testing');
    }
    
    
    public void preventSalesUsersToUpdateWholeSalePrice(List<Custom_Item__c> items, Map<Id, Custom_Item__c> oldItems) {
        
        set<Id> setCustomIds = new Set<Id>();
        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        if((profileName == 'Rebel Sales User')){
            
            System.debug('You are system Sales user');
            for(Custom_Item__c ci : items){
                if(ci.Price_per_item__c != oldItems.get(ci.Id).Price_per_item__c || ci.Price__c != oldItems.get(ci.Id).Price__c){
                    ci.addError('You can not Modify the Price');
                }
            }
        }
        checkRecursion.setAlredyRun();
    }
    
    public void afterInsert(List<Custom_Item__c> items) {
        ItemNumberAutoNumber autoNumber = new ItemNumberAutoNumber(); //@@
        autoNumber.autoNumber(items);
        Set<Id> oppIds = new Set<Id>();
        Set<Id> itemIds = new Set<Id>();
        
        for(Custom_Item__c item : items)
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
            
            //Added By Shubham Sharma on 22-Oct-2021
            //To post Feed for Design Status set to "(P) Dye-Sub Strike Off Drop Shipped to Customer"
            
            if(item.Design_Status__c == '(P) Dye-Sub Strike Off Drop Shipped to Customer') {
                postFeedForStrikeOffShipped(item.Design_Request__c,item.Opportunity__c);
            }
        }
        
        if(itemIds.size() > 0)
        {
           // populateAccountId(itemIds);
        }
        
        if(oppIds.size() > 0)
        {
            handle_AFS_FieldOnOpportunity(oppIds);
        }
        
        Logger.info('afterInsert'); //@@
        CustomItemNotifications notifications = new CustomItemNotifications();
        notifications.createNotifications(items);
        updateDesignRequestItemSummaries(items);
    }
    
    public void updateSalesOrderLineItems(List<Custom_Item__c> items, Map<Id, Custom_Item__c> oldItems) {
        set<Id> setCustomIds = new Set<Id>();
        if((items != NULL) &&(oldItems == NULL)){
            system.debug('inside insert');
            for(Custom_Item__c cs : items){
                setCustomIds.add(cs.Id);
            }
        }
        if(oldItems != NULL){
            system.debug('inside update');
            for(ID id : oldItems.keySet())
            {
                setCustomIds.add(oldItems.get(id).Id);
            }
        }
        System.debug('custom ids are  :'+ setCustomIds);
        
        List<SCMC__Sales_Order_Line_Item__c> soliToUpdate = new List<SCMC__Sales_Order_Line_Item__c>();
        
        for(SCMC__Sales_Order_Line_Item__c si : [SELECT Id, Custom_Item__c,Shipment_Status__c,Commission_Rate__c,Custom_Item__r.Commission_Rate__c FROM SCMC__Sales_Order_Line_Item__c WHERE Custom_Item__c IN: setCustomIds]){
            
            String userId = Userinfo.getUserId();
            System.debug('userId : '+ userId);
            System.debug(SCMC__Sales_Order_Line_Item__c.sObjectType.getDescribe().isCreateable());
            System.debug(SCMC__Sales_Order_Line_Item__c.sObjectType.getDescribe().isUpdateable());
            System.debug(Schema.SObjectType.SCMC__Sales_Order_Line_Item__c.isAccessible());
            System.debug('si.Shipment_Status__c : '+ si.Shipment_Status__c);
            //if(si.Shipment_Status__c != 'Fulfilled' ){
            if((si.Shipment_Status__c != 'Fulfilled' ) && (SCMC__Sales_Order_Line_Item__c.sObjectType.getDescribe().isCreateable()) && (SCMC__Sales_Order_Line_Item__c.sObjectType.getDescribe().isUpdateable())){
            	System.debug('si.Shipment_Status__c : '+si.Shipment_Status__c);
            
                System.debug('Inside not fulfil');
                SCMC__Sales_Order_Line_Item__c sc = new SCMC__Sales_Order_Line_Item__c();
                
                sc.Id = si.Id;
                System.debug('id and commission rate are :'+ sc.Id + ' and '+ sc.Commission_Rate__c);
                sc.Commission_Rate__c = si.Custom_Item__r.Commission_Rate__c;
                System.debug('after update id and commission rate are :'+ sc.Id + ' and '+ sc.Commission_Rate__c);
                soliToUpdate.add(sc);
                
            }
        }
        
        if(soliToUpdate.size() > 0){
            System.debug('updating');
            update soliToUpdate;   
        }
    }
    public void afterUpdate(List<Custom_Item__c> items, Map<Id, Custom_Item__c> oldItems) {
        
        sendEmailToOppForApproval(items,oldItems);
        
        Set<Id> oppIds = new Set<Id>();
        Set<Id> itemIds = new Set<Id>();
        List<Custom_Item__c> statusChanged = new List<Custom_Item__c>();
                List<Custom_Item__c> statusChangedDRS = new List<Custom_Item__c>();

        for (Custom_Item__c item : items) 
        {

            system.debug('item.Design_Status__c---'+item.Design_Status__c);
            system.debug('current user '+userinfo.getUserId());
            String userId = userinfo.getUserId();
            // Custom_Item__c old = oldItems.get(i.Id);
            if ((item.Design_Status__c != oldItems.get(item.Id).Design_Status__c) && userId != '0054R00000B6oXjQAJ') {//@@
                statusChanged.add(item);
            }
            
            // Custom_Item__c old = oldItems.get(i.Id);
            if ((item.Commission_Rate__c != oldItems.get(item.Id).Commission_Rate__c)) {//@@
                updateSalesOrderLineItems(items,oldItems);
            }
            
            // Custom_Item__c old = oldItems.get(i.Id);
            if ((item.Design_Status__c != oldItems.get(item.Id).Design_Status__c)) {//@@
                statusChangedDRS.add(item);
            }
            
            //Handling for AFS field on Opportunity
            if( item.Opportunity__c != null 
               && (item.Opportunity__c != oldItems.get(item.Id).Opportunity__c
                   || item.FF_Is_Submitted__c != oldItems.get(item.Id).FF_Is_Submitted__c
                   || item.order_id__c != oldItems.get(item.id).order_id__c
                   || item.FF_Create_Item_Successful__c != oldItems.get(item.id).FF_Create_Item_Successful__c
                  )
              )
            {
                oppIds.add(item.Opportunity__c);
            }
            
            //Getting item id whose Opportunity != null to Popolate Account Lookup
            if(item.Opportunity__c != null && (item.Account_Lookup__c == null || item.Opportunity__c != oldItems.get(item.Id).Opportunity__c))
            {
                itemIds.add(item.Id);
            }
            
            //Added By Shubham Sharma on 22-Oct-2021
            //To post Feed for Design Status changed to "(P) Dye-Sub Strike Off Drop Shipped to Customer"
            
            if(item.Design_Status__c == '(P) Dye-Sub Strike Off Drop Shipped to Customer' && oldItems.get(item.Id).Design_Status__c != '(P) Dye-Sub Strike Off Drop Shipped to Customer') {
                postFeedForStrikeOffShipped(item.Design_Request__c,item.Opportunity__c);
            }
        }
        
        if(itemIds.size() > 0)
        {
            populateAccountId(itemIds);
        }
        
        if(oppIds.size() > 0)
        {
            handle_AFS_FieldOnOpportunity(oppIds);
        }
        
        //@@
        
        if (!statusChanged.isEmpty()) {
            
            CustomItemNotifications notifications = new CustomItemNotifications();
            notifications.createNotifications(statusChanged);
        }
        
        
        if (!statusChangedDRS.isEmpty()) {
            

             updateDesignRequestItemSummaries(items);
        }
       
    }
    
    public void updateDesignRequestItemSummaries(List<Custom_Item__c> items) {
        Set<Id> designRequestIds = new Set<Id>();
        for (Custom_Item__c i : items) {
            designRequestIds.add(i.Design_Request__c);
        }
        DesignRequestItemSummaryManager m = new DesignRequestItemSummaryManager();
        m.updateFromDesignRequestIds(new List<ID>(designRequestIds));
    }
    
    private void populateAccountId(Set<Id> itemIds)
    {
        List<Custom_Item__c> itemsToUpdate = new List<Custom_Item__c>();
        List<Custom_Item__c> items = [SELECT Id,Account_Lookup__c, Opportunity__r.Account.Id FROM Custom_Item__c Where ID =: itemIds];
        
        for(Custom_Item__c item : items)
        {
            if(item.Opportunity__r.Account.Id != null)
            {
                Custom_Item__c cc = new Custom_Item__c();
                cc.Id = item.Id;
                cc.Account_Lookup__c = item.Opportunity__r.Account.Id;
                itemsToUpdate.add(cc);
            }
        }
        if(itemsToUpdate.size() > 0)
        {
            Util.BypassAllTriggers = true;
            update itemsToUpdate;
            Util.BypassAllTriggers =false;
        }
    }
    
    /*
*	Method is used to update the FIt on the Custom Items 
*/
    
    public void updateFitOnCustomItem(List<Custom_Item__c> items, Map<Id, Custom_Item__c> oldItems)
    {
        List<Custom_Item__c> customItemToUpdate = new List<Custom_Item__c>();
        Map<Id,List<Fit__c>> mapFitWithCustomItems = new Map<Id,List<Fit__c>>();
        Set<String> setCustomItemsStyles = new Set<String>();
        
        for(Custom_Item__c cc : items)
        {
            if((String.isNotBlank(cc.FF_Style__c) && oldItems == null) || (oldItems!= null && cc.FF_Style__c != oldItems.get(cc.Id).FF_Style__c))
            {
                List<String> str = cc.FF_Style__c.split('-');
                setCustomItemsStyles.add(str[0].trim());
            }
        }
        if(setCustomItemsStyles.size() > 0){
            
            
            List<Fit__c> fitDet = new List<Fit__c>();
            
            for(Fit__c fits : [SELECT Id, Name FROM Fit__c])
            {
                for(String str : setCustomItemsStyles){
                    if(fits.Name.startswith(str))
                    {                     	                        
                        fitDet.add(fits);   
                    }
                }   
            }
            for(Custom_Item__c cc : items){
                if(String.isnotBlank(cc.FF_Style__c)){
                    for(String str : setCustomItemsStyles){
                        for(Fit__c fits : fitDet){
                            if(cc.FF_Style__c.contains(str) && fits.Name.startswith(str)){
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
        }
        for(Custom_Item__c cc : items){
            if(String.isnotBlank(cc.FF_Style__c)){
                    if(mapFitWithCustomItems != null && mapFitWithCustomItems.size()> 0 && mapFitWithCustomItems.containskey(cc.Id) ){
                        Custom_Item__c cust = new Custom_Item__c();
                        cust.Fit__c = mapFitWithCustomItems.get(cc.Id)[0].Id;
                        cust.Id = cc.Id;
                        customItemToUpdate.add(cust);
                }
            }
        }
        if(customItemToUpdate.size() > 0)
        {
            update customItemToUpdate;
            
        }
    }
    
    
    private void handle_AFS_FieldOnOpportunity (Set<Id> oppIds)
    {
        Set<Id> removedOpps = new Set<Id>();
        List<Custom_Item__c> cItems = [SELECT Id, Opportunity__c, FF_Is_Submitted__c, order_id__c, FF_Create_Item_Successful__c
                                       FROM Custom_Item__c
                                       WHERE Opportunity__c =: oppIds];
        
        for(Custom_Item__c item : cItems)
        {
            
            if(oppIds.contains(item.Opportunity__c))
            {
                if(item.FF_Is_Submitted__c == FALSE && item.FF_Create_Item_Successful__c == FALSE && String.isBlank(item.order_id__c) 
                   || (item.FF_Is_Submitted__c && item.FF_Create_Item_Successful__c && String.isNotBlank(item.order_id__c)) 
                  )
                {
                    
                    continue;
                }
                else
                {
                    removedOpps.add(item.Opportunity__c);
                    oppIds.remove(item.Opportunity__c);
                }
            }
        }
        
        if(oppIds.size() > 0)
        {
            List<Standardized_Item__c> sItems = [SELECT Id, Opportunity__c, FF_Is_Submitted__c, order_id__c, FF_Create_Item_Successful__c
                                                 FROM Standardized_Item__c
                                                 WHERE Opportunity__c =: oppIds];
            
            for(Standardized_Item__c item : sItems)
            {
               if(oppIds.contains(item.Opportunity__c))
                {
                    if(item.FF_Is_Submitted__c == FALSE && item.FF_Create_Item_Successful__c == FALSE && String.isBlank(item.order_id__c) 
                       || (item.FF_Is_Submitted__c && item.FF_Create_Item_Successful__c && String.isNotBlank(item.order_id__c)) 
                      )
                    {
                       continue;
                    }
                    else
                    {
                        removedOpps.add(item.Opportunity__c);
                        oppIds.remove(item.Opportunity__c);
                    }
                }
            }
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
    
    public void updateAFSCheckboxOpp(List<Custom_Item__c> items, Map<Id, Custom_Item__c> oldItems){
        Set<Id> oppIds = new Set<Id>();
        set<Id> custIds = new Set<Id>();
        List<Opportunity> oppToBeUpdate = new List<Opportunity>();
        List<custom_Item__c> customItemToUpdate = new List<Custom_Item__c>();
        for(Custom_Item__c cus : items){
            if(cus.is_submitted__c == 'true' && cus.is_submitted__c != oldItems.get(cus.Id).is_submitted__c){
                custIds.add(cus.Id);
            }
        }
        if(custIds.size() > 0){
        Map<Id,List<order_sizes__c>> mapCIOS = new Map<Id,List<order_sizes__c>>();
        List<order_sizes__c> listOS = [SELECT Id,Gender__c,Order__c FROM order_sizes__c WHERE Order__c IN: custIds];
        
            for(Id cID : custIds ){
                List<order_sizes__c> tempList = new List<order_sizes__c>();
                for(order_sizes__c osRec : listOS){
                    if(osRec.Order__c == cID){
                        tempList.add(osRec);
                    }
                }
                mapCIOS.put(cID,tempList);
                
            }
            
            for(Custom_Item__c cs : [SELECT Id,Name,Pushed_to_AFS__c,Opportunity__c FROM Custom_Item__c WHERE Id IN: custIds]){
                
                if(mapCIOS.containskey(cs.Id)){
                    
                    Opportunity op = new Opportunity();
                    Custom_Item__c cust = new Custom_Item__c();
                    if(mapCIOS.get(cs.Id).size() > 0){
                        
                        for(Order_sizes__c oz : mapCIOS.get(cs.Id)){
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
                        if(! oppIds.contains(op.id)){
                            oppIds.add(op.id);
                            oppToBeUpdate.add(op);    
                        }   
                    }   
                }
            }
        }
        if(customItemToUpdate.size() > 0){
            update customItemToUpdate;
        }
        if(oppToBeUpdate.size() > 0){
            
            update oppToBeUpdate;
        }
    }
    
    //added - Seemu Saikia - 06/15/2021
    public void updateMaxQuantityOnOpp(List<Custom_Item__c> items){
        Set<Id> setOpportunity = new Set<Id>();
        Map<Id,Decimal> mapMaxQuantity  = new Map<Id,Decimal>();
        List<Opportunity> listUpdateOpp = new List<Opportunity>();
        
        for(Custom_Item__c rec : items){
            setOpportunity.add(rec.Opportunity__c);
        }
        
        for(AggregateResult ar :[SELECT Opportunity__c, MAX(Quantity__c) maxQuantity FROM Custom_Item__c WHERE Opportunity__c IN :setOpportunity GROUP BY Opportunity__c]){

            mapMaxQuantity.put((Id)ar.get('Opportunity__c'),(Decimal)ar.get('maxQuantity'));
        }
        
        for(AggregateResult ar :[SELECT Opportunity__c, MAX(Quantity__c) maxQuantity FROM Standardized_Item__c WHERE Opportunity__c IN :setOpportunity GROUP BY Opportunity__c]){
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
    
    
    // Created By Shubham Sharma - 22-Oct-2021
    // To Post a Feed with mentioning the Opportunity owner about the Strike-Off of the Dye-Sub
     
    private void postFeedForStrikeOffShipped(String DesignRequestId, String OppId) {
        if(String.isNotBlank(OppId) && String.isNotBlank(DesignRequestId)) {
            List<Opportunity> opp = [SELECT Id, Name, OwnerId, Account.name FROM Opportunity WHERE id = :OppId];
            if(opp != null && opp.size() > 0) {
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
                ConnectApi.TextSegmentInput textSegmentInput2 = new ConnectApi.TextSegmentInput();
                ConnectApi.TextSegmentInput textSegmentInput3 = new ConnectApi.TextSegmentInput();
                ConnectApi.TextSegmentInput textSegmentInput4 = new ConnectApi.TextSegmentInput();
                ConnectApi.MarkupBeginSegmentInput markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
                ConnectApi.MarkupEndSegmentInput markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
                
                messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                
                markupBeginSegment.markupType = ConnectApi.MarkupType.Paragraph;
                messageBodyInput.messageSegments.add(markupBeginSegment);
                
                mentionSegmentInput.id = opp[0].OwnerId;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                textSegmentInput1.text = '&nbsp; Dye sub strike off has been drop shipped to the customer.';
                messageBodyInput.messageSegments.add(textSegmentInput1);
                
                markupEndSegment.markupType = ConnectApi.MarkupType.Paragraph;
                messageBodyInput.messageSegments.add(markupEndSegment);
                
                markupBeginSegment.markupType = ConnectApi.MarkupType.Paragraph;
                messageBodyInput.messageSegments.add(markupBeginSegment);
                
                textSegmentInput4.text = '&nbsp;';
                messageBodyInput.messageSegments.add(textSegmentInput4);
                
                markupEndSegment.markupType = ConnectApi.MarkupType.Paragraph;
                messageBodyInput.messageSegments.add(markupEndSegment);
                
                markupBeginSegment.markupType = ConnectApi.MarkupType.Paragraph;
                messageBodyInput.messageSegments.add(markupBeginSegment);
                
                textSegmentInput2.text = 'Opportunity: ' + opp[0].Name;
                messageBodyInput.messageSegments.add(textSegmentInput2);
                
                markupEndSegment.markupType = ConnectApi.MarkupType.Paragraph;
                messageBodyInput.messageSegments.add(markupEndSegment);
                
                markupBeginSegment.markupType = ConnectApi.MarkupType.Paragraph;
                messageBodyInput.messageSegments.add(markupBeginSegment);
                
                textSegmentInput3.text = 'Account: ' + opp[0].Account.name;
                messageBodyInput.messageSegments.add(textSegmentInput3);
                
                markupEndSegment.markupType = ConnectApi.MarkupType.Paragraph;
                messageBodyInput.messageSegments.add(markupEndSegment);
                
                feedItemInput.body = messageBodyInput;
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                feedItemInput.subjectId = DesignRequestId;
                
                if(!test.isRunningTest())
                    ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
            }   
        }   
    }
    
    /**
    *
    * @description : this method is used to place chatter on Opportunity based on custom item status.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 03/24/2022 - Deeptanshu Bharti
    *
    **/

    public static void statusChatter(List<Custom_Item__c> items, Map<Id, Custom_Item__c> oldItems)
    {
        if(HasRun != true)
        {
            for(Custom_Item__c des : items)
            {
                System.debug(des);
                System.debug('the custom item status are : ' + des.Design_Status__c);
                String temp = des.Design_Status__c;
                //System.assert(false,temp);
                //if(temp.length()>0)
                if(temp!=NULL)
                {
                    if(temp.containsIgnoreCase('Waiting on Sales rep confirmation'))
                    {
                        System.debug('it is matching');
                        System.debug('design request are : ' + des.Opportunity__c);
                        if(des.Design_Request__c != NULL)
                        {
                             placeChatter(des.Design_Request__c);   
                        }
                    }
                } 
            }
        }
        
    }
    public static void placeChatter(Id dsId)
    {
        User objUser = new User();
        objUser = [ SELECT Name, Id FROM User WHERE Id = : UserInfo.getUserId() ];
        system.debug( 'User Id ' + objUser.Name );
        Design_Request__c ds = [SELECT Id, Name,OwnerId FROM Design_Request__c WHERE Id =: dsId];
        User usr = [SELECT Id, Name FROM User WHERE Id =: ds.OwnerId];
        /*String body = usr.Name+', ' + objUser.Name+' is waiting on further confirmation';
        System.debug('body for chatter are : ' + body);
        FeedItem post = new FeedItem();
        post.ParentId = ds.Id;
        post.Body = body;
        insert post;*/
        
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput2 = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        ConnectApi.TextSegmentInput textSegmentInput2 = new ConnectApi.TextSegmentInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        // Mention a group.
        mentionSegmentInput.id = usr.Id;
        messageBodyInput.messageSegments.add(mentionSegmentInput);
        textSegmentInput2.text = ' ';
        messageBodyInput.messageSegments.add(textSegmentInput2);
        mentionSegmentInput2.id = objUser.Id;
        messageBodyInput.messageSegments.add(mentionSegmentInput2);
        textSegmentInput.text = ' is waiting on further confirmation';
        messageBodyInput.messageSegments.add(textSegmentInput);
        
        
        
        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        
        // Use a record ID for the subject ID.
        feedItemInput.subjectId = ds.Id;
        
        ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput);
        
        
        
        HasRun = true;
    }
    
    /**
    *
    *   @description    :  on basis of design status and proto status send approval email
    *
    *   @args           :  List<Custom_Item__c>, Map<Id, Custom_Item__c>  
    *
    *   @return         :  
    *
    *   @revision Log   :   V1.1 - Created  - 13/07/2022 - Abhishek
    * 
    **/        
    public static void sendEmailToOppForApproval(List<Custom_Item__c> listNewCustomItem, Map<Id, Custom_Item__c> mapOldCustomItem) {
        
        List<Id> customId = new List<Id>();
        if(mapOldCustomItem != null){
            for(Custom_Item__c ci: listNewCustomItem){
                if (ci.Design_Status__c != mapOldCustomItem.get(ci.Id).Design_Status__c){        
            		customId.add(ci.Id);
                }
        	}
        }
        
        GenerateProtoArtApproval.sendEmailToOppForApproval(customId);
    }
    
}