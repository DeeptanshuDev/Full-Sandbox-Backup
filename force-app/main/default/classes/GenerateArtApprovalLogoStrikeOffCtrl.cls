public with sharing class GenerateArtApprovalLogoStrikeOffCtrl {
    
    public List<DesignWrapper> DesignWrappers { get; set; }
    public Date EventDate { get; set; }
    public Date RequestedIHD { get; set; }
    public Contact opportunityContacts {get;set;}// for eSignature
    public Contact designRequestContacts {get;set;}// for eSignature
    public Design_Round__c  desingRoundLookupContact {get;set;} // for eSignature
    public String selectedRecipient {get;set;}// for eSignature
    private Design_Round__c designRound;
    public boolean isCorrectStatus {get; set;}
    private ApexPages.StandardController standardController;
    
	public GenerateArtApprovalLogoStrikeOffCtrl(ApexPages.StandardController cont) {
        standardController = cont;
        designRound = queryDesignRound(cont.getRecord().Id);
        desingRoundLookupContact = new Design_Round__c();
        Design_Request__c designRequest = queryDesignRequest(designRound.Design_Request__c);
        opportunityContacts = queryContactForOpportunity(designRequest.Opportunity__r.Primary_Contact__c);// for eSignature
        designRequestContacts = queryContactForOpportunity(designRequest.Primary_Contact__c);// for eSignature
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
        
        for (Design__c d : queryDesigns(designRound.Id)) {
            designWrapperMap.put(d.Id, new DesignWrapper(d));
        }
        
        for (Design_Item__c di : queryDesignItems(designWrapperMap.keySet())) {
            if(customItemIdWithApprovedStatus != null && customItemIdWithApprovedStatus.containsKey(di.Custom_Item__r.Id)){
                //Skip This Record
            }
            else{
                //Otherwise include it in Create Art Approval page
                designWrapperMap.get(di.Design__c).items.add(new DesignItemWrapper(di));
            }  
        }
        DesignWrappers = designWrapperMap.values();
        
        if(designRequest.Opportunity__r.Uniform_Style__c.contains('Bag') || 
           designRequest.Opportunity__r.Uniform_Style__c.contains('Pack') || 
           designRequest.Opportunity__r.Uniform_Style__c.contains('Luggage')) {
            isCorrectStatus = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 
                                                       'You can not generate this pdf because you have selected Bag or Pack or Luggage in Opportunity\'s Style Description'));
        } else if(designRequest.Opportunity__r.Prototype_Status__c != 'Logo Strike Off - Customer Approval') {
            isCorrectStatus = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You can not generate this pdf for '
                                                       +designRequest.Opportunity__r.Prototype_Status__c+' status '));
        } else {
            isCorrectStatus = true;
        }
    }
    
    public PageReference approve() {
        
        //added - 05/05/21
        List<Design_Item__c> listUpdateDesignItems = new List<Design_Item__c>();

        if(selectedRecipient == '*'){
            designRound.eSignature_Recipient_Contact__c = desingRoundLookupContact.eSignature_Recipient_Contact__c;
        }
        else{
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
                
                if(designRound != null){
                     update designRound;
                }
                if (!designs.isEmpty()) {
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
        Set<Id> designItemIds = new Set<Id>();
        for(String ids : itemIds){
            designItemIds.add(ids);
        }
        PageReference pr = Page.ArtApprovalLogoStrikeOff;
        pr.getParameters().put('id', designRound.Id);
        pr.getParameters().put('items', String.join(itemIds, ';'));
        Blob pdfData = Blob.valueOf('abc');
        try {
            pdfData = pr.getContentAsPDF();
        }
        catch (Exception e) {
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
        insert contentVersion;
        
        //Create Chatter Post
        FeedItem feedItem = new FeedItem();
        feedItem.Body = 'Logo strike off has been drop shipped to the customer.';
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
        
        Set<Id> designItemIds = new Set<Id>();
        if (itemIds.isEmpty()) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select at least one item.'));
        }
        else{
            for(String ids : itemIds){
            	designItemIds.add(ids);
        	}
            PageReference pr = Page.ArtApprovalStrikeOffPdf;
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
    
    private Design_Request__c queryDesignRequest(Id designRequestId) {
        return [
            SELECT Id, Boy_Proto_Status__c, Opportunity__c, Primary_Contact__c, Opportunity__r.Primary_Contact__c, 
                Opportunity__r.Requested_IHD__c, Opportunity__r.Prototype_Status__c, Opportunity__r.Collection_Picklist__c, 
                Opportunity__r.Uniform_Style__c, Opportunity__r.CloseDate
            FROM Design_Request__c WHERE Id = :designRequestId
        ];
    }
    
    private Contact queryContactForOpportunity(Id contactId){
        return [
            SELECT Id, FirstName, LastName
            FROM Contact 
            WHERE Id = :contactId
        ];
    }
    
    private Design_Round__c queryDesignRound(Id designRoundId) {
        return [
            SELECT Id, Name, Version__c, Revision_Notes__c, Gender__c, Design_Request__r.Account__r.Name, 
                Design_Request__r.Opportunity__r.Prototype_Status__c
            FROM Design_Round__c
            WHERE Id = :designRoundId
        ];
    }
    
    private List<Design__c> queryDesigns(Id designRoundId) {
        return [
            SELECT Id, Design_Image_URL__c, Design_Image__c, Content_Version_Id__c, Version__c, 
                Option_Number__c, Notes__c, Approved_Art__c
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
            SELECT Id, Name, Tax__c, Total_Price__c, Quantity__c, Design__c, Price__c, Wholesale_Price__c, 
                Standardized_Item__c, Standardized_Item__r.Name, Standardized_Item__r.Product_Code__c, 
                Standardized_Item__r.Product_Description__c, Standardized_Item__r.Product_Name__c, 
                Standardized_Item__r.List_Price__c, Standardized_Item__r.Quantity__c, Custom_Item__c, 
                Custom_Item__r.Name, Custom_Item__r.Style__c, Custom_Item__r.Price_per_item__c, 
                Custom_Item__r.Total_Price__c, Custom_Item__r.Quantity__c, Custom_Item__r.Item_Number_Edit__c, 
                Custom_Item__r.Stage__c
            FROM Design_Item__c
            WHERE Design__c IN :designIds
            AND ((Custom_Item__c != null AND Custom_Item__r.Stage__c NOT IN: setOfStagesNeedToBypass) 
                OR (Standardized_Item__c != null))
            ORDER BY Custom_Item__r.Item_Number_Edit__c
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