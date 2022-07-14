public class DesignArtPricingCtrl 
{
    private final ApexPages.StandardController controller;
    private final Design_Request__c designRequest;
    
    public DesignArtPricingCtrl(ApexPages.StandardController controller) 
    {
        this.controller = controller;
        this.designRequest = (Design_Request__c) controller.getRecord();
        initVersions();
        findDesigns();
        //onLoad();
        this.ImageWidthInPixles = '600';
    }
    
    public String DesignRequestId { get { return designRequest.Id; }}
    public List<SelectOption> VersionSelectOptions { get; set; }
    public String SelectedVersion { get; set; }
    public List<Design__c> Designs { get; set; }
    public String ImageWidthInPixles { get; set; }
    public Boolean ShowItems { get; set; }
    public String SelectedDesignRoundId { get; set; }
    public Boolean SaveSuccess { get; set; }
    public String positions {get; set;}
    public String positions2 {get; set;}
    public string DIID { get; set;}
    public String collectionValue{get;set;} 
    public void noop() { }
    
    public void save() 
    {
        try 
        {
            SaveSuccess = false;
            List<Design_Item__c> items = new List<Design_Item__c>();
            for (Design__c d : Designs) 
            {
                for(Design_Item__c dis : d.Design_Items__r)
                {
                    dis.DI_categotry__c = dis.Custom_Item_Category__c;
                    dis.DI_Collection__c = dis.Custom_Item_Collection__c;
                }
                items.addAll(d.Design_Items__r);
            }
            update designRequest.Opportunity__r;
 
            update items;
            SaveSuccess = true;
        }
        catch(Exception ex) 
        {   
            List<String> msg = new List<String>();
            SaveSuccess = false;
            
            if(ex.getMessage().contains('CustomException')){
                msg = (ex.getMessage().split('CustomException:'))[1].split('Class');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg[0]));
            }
            else{
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); 
            }
        }
    }
    
    private void initVersions() 
    {
        List<Design_Round__c> rounds = [SELECT Id, Version__c FROM Design_Round__c
                                        WHERE Design_Request__c = :designRequest.Id];
        Set<String> applicableVersions = new Set<String>();
        for (Design_Round__c round : rounds) 
        {
            if (round.Version__c != null) 
            {
                applicableVersions.add(round.Version__c);
            }
        }
        VersionSelectOptions = new List<SelectOption>();
        for (Schema.PicklistEntry pl : Schema.sObjectType.Design_Round__c.fields.Version__c.picklistValues) 
        {
            if (applicableVersions != null && applicableVersions.contains(pl.getValue())) 
            {
                VersionSelectOptions.add(new SelectOption(pl.value, pl.label));
            }
        }
        if (!applicableVersions.isEmpty()) 
        {
            SelectedVersion = VersionSelectOptions[VersionSelectOptions.size() - 1].getValue();
        }
    }
    
    public PageReference redirectToDesignRounds() 
    {
        String dRoundId = ApexPages.CurrentPage().getParameters().get('designRoundId');
        PageReference pg = new PageReference(url.getSalesforceBaseUrl().toExternalForm()+'/' + SelectedDesignRoundId);
        pg.setRedirect(true);
        return pg; 
    } 
    
    public PageReference redirectToDesignRequests() 
    {
       
        String dRequestId = ApexPages.CurrentPage().getParameters().get('designRequestId');
      
        PageReference pg = new PageReference('/' + dRequestId);
        pg.setRedirect(true);
        return pg; 
    }   
    
    public void findDesigns() 
    {
        List<Design_Round__c> designRounds = new List<Design_Round__c>();
        
        designRounds = [
            Select Id,Name,version__c
            FROM Design_Round__c
            WHERE Design_Request__c = :designRequest.Id
            AND Version__c = :SelectedVersion
        ];
        
        if(designRounds.size() > 0) 
        {
            this.SelectedDesignRoundId = designRounds[0].Id;
        }
        
        this.Designs = [
            SELECT Id
            , Name
            , Version__c
            , Approved_Art__c
            , Design_Image__c
            , Design_Image_URL__c
            , Final_Art__c
            , Needs_Pricing__c
            , Notes__c
            , Option_Number__c
            , Pricing_Complete__c
            , Revision_Number__c
            , Sales_Rep__c
            , Submit_for_Approval__c
            , Content_Version_Id__c
            , Markup__c
            , (
                SELECT Id
                , Name
                , Custom_Item__c
                , Custom_Item__r.Name
                , Custom_Item__r.Product_Style__c
                , Custom_Item__r.Category__c
                , Custom_Item__r.Collection__c
                , Early_Bird_Price__c
                , Early_Bird_Volume_Price__c
                , International_Pricing__c
                , MSRP__c
                , Partner_Price__c
                , Price__c
                , Sales_Rep__c
                , Standardized_Item__c
                , Standardized_Item__r.Name
                , Wholesale_Price__c
                , Wholesale_Volume_Price__c
                , Wholesale_Special_Offer__c
                , Wholesale_Special_Offer_Type__c
                , Stated_Quantity__c
                , Quantity__c
                , Shipping_per_Item__c
                , Shipping__c
                , Sponsorship_Type__c
                , Tax__c
                , Commission_Option__c
                , Type_of_Discount__c
                , Markup__c
                , Crystal_Count__c
                ,P_commission__c
                , DI_categotry__c
                , DI_Product_Style__c
                , DI_Collection__c 
                , Custom_Item_Collection__c
                , Custom_Item_Category__c
                
                
                FROM Design_Items__r
                WHERE Custom_Item__c != null
            )
            FROM Design__c
            WHERE
            Design_Request__c = :designRequest.Id
            AND Design_Round__r.Version__c = :SelectedVersion
        ];
    }
    
    
    //Added by Deeptanshu
    public List<SelectOption> getdynamiclist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Couture','Couture'));
        options.add(new SelectOption('Dance Uniforms','Dance Uniforms'));
        options.add(new SelectOption('Poly','Poly'));
        options.add(new SelectOption('Purple Label','Purple Label'));
        options.add(new SelectOption('School Competition','School Competition'));
        options.add(new SelectOption('Silver Label Allstar','Silver Label Allstar'));
        
        return options;
    } 
    
    public List<SelectOption> getdynamiclist2() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('N/A','N/A'));
        /*options.add(new SelectOption('Couture','Couture'));
        options.add(new SelectOption('Dance Uniforms','Dance Uniforms'));
        options.add(new SelectOption('Poly','Poly'));
        options.add(new SelectOption('Purple Label','Purple Label'));
        options.add(new SelectOption('School Competition','School Competition'));
        options.add(new SelectOption('Silver Label Allstar','Silver Label Allstar'));*/
        return options;
    }
    public List<SelectOption> getdynamiclist3() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('N/A','N/A'));
        options.add(new SelectOption('All Star','All Star'));
        options.add(new SelectOption('Gymnastics','Gymnastic'));
        options.add(new SelectOption('IEP','IEP'));
        options.add(new SelectOption('Pro','Pro'));
        options.add(new SelectOption('School','School'));
        options.add(new SelectOption('Studio','Studio'));
        return options;
    }
    public List<SelectOption> getcategorylist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All Star','All Star'));
        options.add(new SelectOption('Gymnastics','Gymnastic'));
        options.add(new SelectOption('IEP','IEP'));
        options.add(new SelectOption('Pro','Pro'));
        options.add(new SelectOption('School','School'));
        options.add(new SelectOption('Studio','Studio'));
        
        return options;
    }
    
    
}