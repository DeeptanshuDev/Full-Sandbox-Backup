public with sharing class CreateFitKitRequestCtrl 
{
    //private attribute
    private ApexPages.StandardController standardController;
    private List<Fit_Kit_Request_Product__c> deletedProducts = new List<Fit_Kit_Request_Product__c>();
    private Map<Id, Custom_Item__c> customItemMap = new Map<Id, Custom_Item__c>();
    private Fit_Kit_Request__c request;
    
    //public attribute
    public String FittingDate { get; set; }
    public Account Account1 { get; set; }
    public String OpportunityName { get; set; }
    public String Deposit { get; set; }
    public Task DummyTask {get{return new Task();} }
    public List<ItemWrapper> ItemWrappers { get; set; }
    public Id opportunityId {get;set;}
    public List<StandardizedItemWrapper> StandardizedItemWrappers { get; set; }
    public List<SelectOption> DepositSelectOptions 
    { 
        get
        {
    		List<SelectOption> options = new List<SelectOption>();
            for (Deposit__c d : Account1.Deposits__r) 
            {
                if (d.Status__c == 'Pending' || d.Status__c == 'Deposit Paid') 
                {
                    options.add(new SelectOption(d.Id, 'Deposit on file: ' + d.Name + ', ' + d.Amount__c + ', ' + d.Status__c));
                }
            }
            options.add(new SelectOption('*new-check', 'Create new deposit - check'));
            options.add(new SelectOption('*new-creditcard', 'Create new deposit - credit card'));
            options.add(new SelectOption('*waiver', 'Request waiver'));
            options.add(new SelectOption('*inperson', 'No deposit - In-person fitting'));
            return options;
         }
    }
    
    //constructor
    public CreateFitKitRequestCtrl(ApexPages.StandardController cont) 
    {
        this.standardController = cont;
        request = (Fit_Kit_Request__c) cont.getRecord();
        opportunityId = request.Opportunity__c;
        if (opportunityId == null) 
        {
            throw new ApplicationException('Fit Kit Requests must be created from the Opportunity.');
        }
        Opportunity opp = new OpportunityRepo().findById(opportunityId);
        OpportunityName = opp.Name;
        Account1 = new AccountRepo().findById(opp.AccountId);
        List<Custom_Item__c> items = new CustomItemRepo().findByOpportunity(request.Opportunity__c);
        customItemMap = new Map<Id, Custom_Item__c>(items);
        initItemWrappers();
        initStandardizedItemWrappers(new StandardizedItemRepo().findByOpportunityId(request.Opportunity__c));
    }
    
    public PageReference createRequest() 
    {
        List<String> errors = validate();
        if (!errors.isEmpty()) 
        {
            
            for (String e : errors)
            {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e));
            }
            return null;
        }
        else{
            Savepoint savepoint = Database.setSavepoint();
            try {
                if (!Deposit.startsWith('*')) {
                    request.Deposit__c = Id.valueOf(Deposit);
                }
                else if (Deposit.startsWith('*new')) {
                    Deposit__c dep = new Deposit__c(
                        Status__c = 'Pending',
                        Amount__c = 300,
                        Account__c = Account1.Id,
                        Payment_Type__c = Deposit.indexOf('check') != -1 ? 'Check' : 'Credit Card'
                    );
                    insert dep;
                    request.Deposit__c = dep.Id;
                }
                else if (Deposit == '*waiver') {
                    request.Deposit_Waiver__c = 'Requested';
                }
                request.Account__c = Account1.Id;
                insert request;
                CustomItemFitAttributeRepo customItemFitAttributeRepo = new CustomItemFitAttributeRepo();
                List<Fit_Kit_Request_Product__c> fkrProducts = new List<Fit_Kit_Request_Product__c>();
                List<Fit_Kit_Request_Custom_Item__c> fkrCustomItems =
                    new List<Fit_Kit_Request_Custom_Item__c>();
                for (ItemWrapper w : ItemWrappers) {
                    if (!w.Selected) {
                        continue;
                    }
                    fkrCustomItems.add(new Fit_Kit_Request_Custom_Item__c(
                        Fit_Kit_Request__c = request.Id,
                        Custom_Item__c = w.Item.Id
                    ));
                    Fit_Kit_Request_Product__c p = new Fit_Kit_Request_Product__c();
                    p.Fit_Kit_Request__c = request.Id;
                    p.Custom_Item__c = w.item.Id;
                    Custom_Item_Fit_Attribute__c attribute = customItemFitAttributeRepo.findByStyleAndFabric(
                        w.item.Style_Number__c, w.item.Fabric_Options__c);
                    if (attribute != null) {
                        p.Product__c = attribute.Product__c;
                    }
                    fkrProducts.add(p);
                }
                
                insert fkrProducts;
                insert fkrCustomItems;
                
                List<Fit_Kit_Request_Standardized_Item__c> fkrStandardItems =
                    new List<Fit_Kit_Request_Standardized_Item__c>();
                for (StandardizedItemWrapper w : StandardizedItemWrappers) {
                    if (!w.Selected) {
                        continue;
                    }
                    Fit_Kit_Request_Standardized_Item__c p = new Fit_Kit_Request_Standardized_Item__c();
                    p.Fit_Kit_Request__c = request.Id;
                    p.Standardized_Item__c = w.item.Id;
                    fkrStandardItems.add(p);
                }
                
                insert fkrStandardItems;
                
                if (request.Deposit_Waiver__c == 'Requested') {
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setObjectId(request.Id);
                    approvalRequest.setSubmitterId(userInfo.getUserId());
                    approvalRequest.setProcessDefinitionNameOrId('Deposit_Waiver');
                    approvalRequest.setSkipEntryCriteria(true);
                    Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
                    
                    if (!approvalResult.isSuccess()) {
                        throw new ApplicationException('Unable to submit approval request. '
                                                       + approvalResult.getErrors()[0].getMessage());
                    }
                }
                
                return new ApexPages.StandardController(request).view();
            }
            catch (Exception ex) {
               
                Logger.error(ex);
                Database.rollback(savepoint);
                request.Id = null;
                ApexPages.addMessages(ex);
            }
        }
        return null;
    }
    
    //show error message on the basis of validation
    private List<String> validate() {
        List<String> messages = new List<String>();
        if (request.Special_Date_Request__c == null && request.Scheduled_Fitting_Date__c == null || (request.Special_Date_Request__c == 'Normal Priority: Ship based on fitting date' && request.Scheduled_Fitting_Date__c == null)) 
        {
            messages.add('Fitting date must be populated.');
        }
        if (String.isNotBlank(request.Shipping_Option__c) && (request.Shipping_Street__c == null|| 
            request.Shipping_City__c == null || request.Shipping_State__c == null|| request.Shipping_Postal_Code__c == null))
        {
            messages.add('All shipping address fields must be populated.');
        }
        Boolean hasCustomItems = false;
       
        for (ItemWrapper w : ItemWrappers) {
            if (w.Selected) {
                hasCustomItems = true;
                break;
            }
        }
        
        if(ItemWrappers.size() >0 && hasCustomItems == false){
            messages.add('At least one custom item must be selected.');
        }
        else if(hasCustomItems == false && ItemWrappers.size() ==  0){
        	messages.add('Before creating fit kit request please create one custom item.');
        }
        /*if (!hasCustomItems) {
            messages.add('At least one custom item must be selected.');
        }*/
        return messages;
    }
    
    private void initItemWrappers() {
        List<ItemWrapper> wrappers = new List<ItemWrapper>();
        for (Custom_Item__c item : customItemMap.values()) {
            wrappers.add(new ItemWrapper(item));
        }
        ItemWrappers = wrappers;
    }
    
    private void initStandardizedItemWrappers(List<Standardized_Item__c> items) {
        List<StandardizedItemWrapper> wrappers = new List<StandardizedItemWrapper>();
        for (Standardized_Item__c item : items) {
            if(String.isNotBlank(item.Product_Name__c) || String.isNotBlank(item.Product_Code__c)){
            	wrappers.add(new StandardizedItemWrapper(item));
            }
        }
        StandardizedItemWrappers = wrappers;
    }
    
    //Custom Item wrapper 
    public class ItemWrapper 
    {
        public ItemWrapper(Custom_Item__c item) 
        {
            this.item = item;
            this.Selected = false;
        }
        public Boolean Selected { get; set; }
        public Custom_Item__c item { get; set; }
    }
    
    //Standard item wrapper
    public class StandardizedItemWrapper 
    {
        public StandardizedItemWrapper(Standardized_Item__c item) 
        {
            this.item = item;
            this.Selected = false;
        }
        public Boolean Selected { get; set; }
        public Standardized_Item__c item { get; set; }
    }
    
}