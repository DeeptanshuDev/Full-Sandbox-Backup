/**
*  Description     :   Controller class for GenerateArtApprovalProto Vf Page used to generate AA document from CreateArtApprovalProtoPdf 
*                      Vf page when ProtoType Status is Proto of Opportunity.
* 
*  Created By      :   Chirag Soni
*
*  Created Date    :   3/9/2021
* 
*  Modified By     :   Shubham Sharma
*
*  Modified Date   :   10/05/2021
*
*  Revision Logs   :   V_1.0 - Created 
*  1. Added condition to also check Style description contains Pack.
*
**/


public with sharing class GenerateArtApprovalProtoCtrl {
    
    public List<DesignWrapper> DesignWrappers { get; set; }
    public Date EventDate { get; set; }
    public Date RequestedIHD { get; set; }
    public Contact opportunityContacts {get;set;}// for eSignature
    public Contact designRequestContats {get;set;}// for eSignature
    public Design_Round__c  desingRoundLookupContact {get;set;} // for eSignature
    public String selectedRecipient {get;set;}// for eSignature
    private Design_Round__c designRound;
    public boolean isCorrectStatus {get; set;}
    private ApexPages.StandardController standardController;
    
    public GenerateArtApprovalProtoCtrl(ApexPages.StandardController cont) {
        
        standardController = cont;
        designRound = queryDesignRound(cont.getRecord().Id);
        desingRoundLookupContact = new Design_Round__c();
        Design_Request__c designRequest = queryDesignRequest(designRound.Design_Request__c);
        
        if(designRequest.Opportunity__r.Primary_Contact__c != null){
        	
            opportunityContacts = queryContactForOpportunity(designRequest.Opportunity__r.Primary_Contact__c);// for eSignature
            designRequestContats = queryContactForDesignRequest(designRequest.Primary_Contact__c);// for eSignature
            Id oppId = designRequest.Opportunity__c;
            EventDate = designRequest.Opportunity__r.CloseDate;
            RequestedIHD = designRequest.Opportunity__r.Requested_IHD__c;
            Map<Id, DesignWrapper> designWrapperMap = new Map<Id, DesignWrapper>();
            Map<Id,Custom_Item__c> mapOfCustomItems = new Map<Id,Custom_Item__c>([SELECT ID, (SELECT ID, Approved__c FROM Design_Items__r) FROM Custom_Item__c  WHERE Opportunity__c =: oppId]);
            Map<Id,Boolean> customItemIdWithApprovedStatus = new Map<Id,Boolean>();
            if(mapOfCustomItems != null){
                for(Id customItemId : mapOfCustomItems.keySet()){
                    for(Design_Item__c designItem : mapOfCustomItems.get(customItemId).Design_Items__r){
                        if(designItem.Approved__c && !customItemIdWithApprovedStatus.containsKey(customItemId)){
                            customItemIdWithApprovedStatus.put(customItemId, true);
                            break;
                        }
                    }
                }
            }
            
            system.debug('*********************designRound.Id :'+designRound.Id);
            for (Design__c d : queryDesigns(designRound.Id)) {
                designWrapperMap.put(d.Id, new DesignWrapper(d));
            }
            
            system.debug(designWrapperMap);
            for (Design_Item__c di : queryDesignItems(designWrapperMap.keySet())) {
                system.debug('*****************************di:'+di);
                if(customItemIdWithApprovedStatus != null && customItemIdWithApprovedStatus.containsKey(di.Custom_Item__r.Id)){
                    //Skip This Record
                }
                else{
                    //Otherwise include it in Create Art Approval page
                    designWrapperMap.get(di.Design__c).items.add(new DesignItemWrapper(di));
                }  
            }
            system.debug(designWrapperMap);
            DesignWrappers = designWrapperMap.values();
            system.debug(DesignWrappers);
            
            //added by - Sshubham Sharma - 22-Sept-2021 
            //Conditions chaneged for to work properly with new button added.
            if(designRequest.Opportunity__r.Uniform_Style__c.contains('Bag') || 
               designRequest.Opportunity__r.Uniform_Style__c.contains('Pack') ||
               designRequest.Opportunity__r.Uniform_Style__c.contains('Luggage')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 
                                                           'You can not generate this pdf because you have selected Bag or Pack or Luggage in Opportunity\'s Style Description')); 
                isCorrectStatus=false;
            } else if(designRound.Gender__c == 'Boy'  && designRequest.Boy_Proto_Status__c == 'No') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 
                                                           'You can not generate this pdf for Boy because Boy Proto Type is NO in Opportunity')); 
                isCorrectStatus=false;
            } else if(designRequest.Opportunity__r.Prototype_Status__c == 'Proto') {
                           isCorrectStatus=true;
            } else {
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You can not generate this pdf for '
                                                           +designRequest.Opportunity__r.Prototype_Status__c+' status.'));
            	isCorrectStatus=false;
            }
        }
        else{
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Opprtunity has no primary contact.'));
        
        }
        
    }
    
    
    public PageReference approve() {
        //added - 04/29/21
        system.debug('Apex1');
        List<Design_Item__c> listUpdateDesignItems = new List<Design_Item__c>();

        if(selectedRecipient == '*'){
        system.debug('Apex2');
            designRound.eSignature_Recipient_Contact__c = desingRoundLookupContact.eSignature_Recipient_Contact__c;
        }
        else{
        system.debug('Apex3');
            designRound.eSignature_Recipient_Contact__c = selectedRecipient;
        }
        designRound.Art_Approval_Sent__c = false;
        designRound.Artwork_Approved__c = false;
        //added - 05/24/2021 - Seemu Saikia
        //designRound.Approval_Till_Date__c = date.today().addDays(2);
        
        List<String> itemIds = selectedItemIds();
        if (itemIds.isEmpty() ) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select atleast one item.'));
            return null;
        }
        else {
            try {
                system.debug('Apex4');
                Set<Id> setDesignIds = new Set<Id>();
                createAndAttachPdf(itemIds);
                List<Design__c> designs = new List<Design__c>();
                for (DesignWrapper dw : DesignWrappers) {
                    if (dw.Design.Approved_Art__c) {
                        continue;
                    }
                    dw.Design.Sent_for_Approval__c = false;
                    designs.add(dw.Design);
                    
                    for (DesignItemWrapper diw : dw.Items) {
                        system.debug('diw'+diw.Selected);
                        if (diw.Selected) {
                            listUpdateDesignItems.add(new Design_Item__c(Id = diw.DesignItem.Id,Selected__c = true));
                            Logger.warn('Selected');
                            //dw.Design.Sent_for_Approval__c = true;
                            if(!setDesignIds.contains(dw.Design.Id)){
                                dw.Design.Art_Approval_Created__c = true;
                                setDesignIds.add(dw.Design.Id);
                            }
                            
                            //break;
                        }
                        else {
                            Logger.warn('Not Selected');
                        }
                    }
                }
                system.debug('setDesignIds--'+setDesignIds);
                if(designRound != null){
                     update designRound;
                }
                system.debug('designs----'+designs);
                for(Design__c d :designs){
                    system.debug('*****updating designs :'+d);
                }
                if (!designs.isEmpty()) {
                    system.debug('*/*//***/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/* listUpdateDesignItems :'+listUpdateDesignItems);
                    update listUpdateDesignItems;

                    update designs;
                   
                }
                return standardController.view();
            }
            catch (Exception ex) {
                //ApexPages.addMessages(ex);
                system.debug('Error Message -'+ ex.getMessage());
                return null;
            }
        }
        
    }
    
    public void createAndAttachPdf(List<String> itemIds) {
        
        system.debug('Apex5');
        PageReference pr = Page.ArtApprovalProtoPdf;
        pr.getParameters().put('id', designRound.Id);
        pr.getParameters().put('items', String.join(itemIds, ';'));
        Blob pdfData = Blob.valueOf('abc');
        try {
            system.debug('Apex6: ' + pr);
            pdfData = pr.getContentAsPDF();
            system.debug('Apex6.1: ' + pdfData);
            system.debug('Apex6.2: ' + pr.getContent());
        }
        catch (Exception e) {
            
            system.debug('Apex7:' + e.getMessage());
            // ignore. exception will always be thrown in test context.
        }
        //Upload File
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = designRound.Design_Request__r.Account__r.Name + ' - ' + designRound.Name
            + '.pdf';//File title
        contentVersion.PathOnClient = designRound.Design_Request__r.Account__r.Name + ' - ' + designRound.Name
            + '.pdf'; //File name
        contentVersion.VersionData = pdfData ;//File body (Add content or body of uploaded file)
        String itemIdsString =  itemIds.toString().replaceAll('[()]', '');
        contentVersion.ReasonForChange = itemIdsString+':'+designRound.Id;
        System.debug('itemIdsString: ' + itemIdsString);
        //contentVersion.ReasonForChange = itemIdsString+':'+designRound.Design_Request__c;
        insert contentVersion;
        
        //Create Chatter Post
        FeedItem feedItem = new FeedItem();
        feedItem.Body = 'Proto Art Approval Document Generated';
        feedItem.ParentId = designRound.Id; //Record Id
        insert feedItem;
        
        //Associate attachment to the post
        FeedAttachment feedAttachment = new FeedAttachment();
        feedAttachment.FeedEntityId = feedItem.Id;//Chatter Post Id
        feedAttachment.RecordId = contentVersion.Id;//Document Id
        feedAttachment.Type = 'CONTENT'; 
        insert feedAttachment;       
        
    }
    
    public PageReference viewPdf() {
        List<String> itemIds = selectedItemIds();
        if (itemIds.isEmpty()) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select at least one item.'));
        }
        else{
            PageReference pr = Page.ArtApprovalProtoPdf;
            pr.getParameters().put('id', designRound.Id);
            pr.getParameters().put('items', String.join(itemIds, ';'));
            return pr;
        }
        return null;
    }
    
    public PageReference cancel() {
        return standardController.view();
    }
    
    private List<String> selectedItemIds() {
        List<String> itemIds = new List<String>();
        for (DesignWrapper dw : DesignWrappers) {
            if(dw.Items.size() > 0){
                for (DesignItemWrapper diw : dw.Items) {
                    if (diw.Selected) {
                        itemIds.add(diw.DesignItem.Id);
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select at least one item.'));
                    }
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please create Custom item or Standard item for given Design.'));
            }
        }
        return itemIds;
    }
    
    private Design_Round__c queryDesignRound(Id designRoundId) {
        return [
            SELECT Id
            , Name
            , Version__c
            , Revision_Notes__c
            , Gender__c
            , Design_Request__r.Account__r.Name
            , Design_Request__r.Opportunity__r.Prototype_Status__c
            FROM Design_Round__c
            WHERE Id = :designRoundId
        ];
    }
    
    private Contact queryContactForOpportunity(Id contactId){
        return[SELECT Id 
               , FirstName
               , LastName
               FROM Contact 
               WHERE Id = :contactId];
    }
    
    private Contact queryContactForDesignRequest(Id contactId){
        return[SELECT Id 
               , FirstName
               , LastName
               FROM Contact 
               WHERE Id = :contactId];
    }
    
    private List<Design__c> queryDesigns(Id designRoundId) {
        return [
            SELECT Id
            , Design_Image_URL__c
            , Design_Image__c
            , Content_Version_Id__c
            , Version__c
            , Option_Number__c
            , Notes__c
            , Approved_Art__c
            FROM Design__c
            WHERE Design_Round__c = :designRoundId
            Order By Option_Number__c
        ];
    }
    
    private List<Design_Item__c> queryDesignItems(Set<Id> designIds) {
        Set<String> setOfStagesNeedToBypass = new Set<String>();
        for(String stageValue : System.Label.StageValues.split(',')) {
            setOfStagesNeedToBypass.add(stageValue);
        }
        return [
            SELECT Id
            , Name
            , Tax__c
            , Total_Price__c
            , Quantity__c
            , Design__c
            , Price__c
            , Wholesale_Price__c
            , Standardized_Item__c
            , Standardized_Item__r.Name
            , Standardized_Item__r.Product_Code__c
            , Standardized_Item__r.Product_Description__c
            , Standardized_Item__r.Product_Name__c
            , Standardized_Item__r.List_Price__c
            , Standardized_Item__r.Quantity__c
            , Standardized_Item__r.Product_Family__c
            , Custom_Item__c
            , Custom_Item__r.Name
            , Custom_Item__r.Style__c
            , Custom_Item__r.Price_per_item__c
            , Custom_Item__r.Total_Price__c
            , Custom_Item__r.Quantity__c
            , Custom_Item__r.Item_Number_Edit__c
            , Custom_Item__r.Stage__c
            FROM Design_Item__c
            WHERE Design__c IN :designIds
            AND ((Custom_Item__c != null AND Custom_Item__r.Stage__c NOT IN: setOfStagesNeedToBypass) 
                 OR (Standardized_Item__c != null))
            ORDER BY Custom_Item__r.Item_Number_Edit__c
        ];
    }
    
    private Design_Request__c queryDesignRequest(Id designRequestId) {
        return [
            SELECT Id
            , Opportunity__c
            , Primary_Contact__c
            , Boy_Proto_Status__c
            , Opportunity__r.Prototype_Status__c 
            , Opportunity__r.Collection_Picklist__c  
            , Opportunity__r.Uniform_Style__c 
            , Opportunity__r.Primary_Contact__c
            , Opportunity__r.Requested_IHD__c
            , Opportunity__r.CloseDate
            FROM Design_Request__c WHERE Id = :designRequestId
        ];
    }
    
    public Class DesignWrapper {
        public Design__c Design { get; set; }
        public List<DesignItemWrapper> Items { get; set; }
        public DesignWrapper(Design__c d) { 
            Design = d; 
            items = new List<DesignItemWrapper>(); 
        }  
    }
    
    public Class DesignItemWrapper {
        public Design_Item__c DesignItem { get; set; }
        public Boolean Selected { get; set; }
        public DesignItemWrapper(Design_Item__c di) 
        { 
            DesignItem = di; 
            Selected = false; 
        }
        
        public String Type { 
            get {
                return DesignItem.Custom_Item__c != null ? 'Custom' : 'Standard';
            }
        }
    }
}