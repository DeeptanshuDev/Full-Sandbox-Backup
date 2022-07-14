public class ArtApprovalLogoStrikeOffPdfCtrl {
    
    public Design_Round__c designRound { get; set; }
    public List<Design__c> designs { get; set; }
    public String OwnerName { 
        get{
            return DesignRequest.Owner.Name;                                 
        }
    }
    private ApexPages.StandardController standardController;
    public String Today { 
        get { 
            return DateTime.newInstance(Date.today().year(), Date.today().month(), Date.today().day()).format('MM/dd/yyyy'); 
        }
    }
    public Design_Request__c DesignRequest { get; set; }
    public String Customer { 
        get { 
            return designRound.Design_Request__r.Account__r.Name; 
        }
    }
    public String Version { 
        get { 
            return designRound.Version__c; 
        }
    }
    public String Designer { 
        get { 
            return designRound.Design_Request__r.Assigned_Designer__r.Name; 
        }
    }
    public String protoTypeStatus {get; set;}
    public String protoTypeSize{get;set;}
    
    public ArtApprovalLogoStrikeOffPdfCtrl(ApexPages.StandardController cont) {
        system.debug('In Logo Strike Off PDF Generation');
        this.standardController = cont;
        List<String> designItemIds = ApexPages.currentPage().getParameters().get('items').split(';');
        designRound = queryDesignRound(cont.getSubject().Id);
        designs = queryDesigns(designRound.Id, designItemIds);
        DesignRequest = queryDesignRequest(designRound.Design_Request__c);
        prototypeSize = 'N/A';
        protoTypeStatus = 'Logo Strike Off - Customer Approval';
    }
    
    public List<Design_Item__c> DesignItems {
        get {
            List<Design_Item__c> designItems = new List<Design_Item__c>();
            for (Design__c d : Designs) {
                for (Design_Item__c di : d.Design_Items__r) {
                    designItems.add(di);
                }
            }
            return designItems;
        }
    }
    
    public String OptionNumbers {
        get {
            String retVal = '';
            for (Design__c design : designs) {
                if (!String.isEmpty(retVal)) {
                    retVal += (', ');
                }
                if (design.Option_Number__c != null) {
                    retVal += design.Option_Number__c;
                }
            }
            return retVal;
        }
    }
    
    public String fetchOptionNumbers()
    {
        return OptionNumbers;
    }
    
    public List<Design_Item__c> fetchDesignItems()
    {
        return DesignItems;
    }
    
    public String fetchVersion()
    {
        return Version;
    }
    
    public String getPromoCode() {
        return DesignRequest.Opportunity__r.Promo_Code__c;
    }
    
    private Design_Round__c queryDesignRound(Id designRoundId) {
        return [
            SELECT Id, Name, toLabel(Version__c), Revision_Notes__c, Design_Request__r.Account__r.Name, 
                Design_Request__r.Assigned_Designer__r.Name, Prototype__c, Gender__c
            FROM Design_Round__c
            WHERE Id = :designRoundId
        ];
    }
    
    private List<Design__c> queryDesigns(Id designRoundId, List<String> itemIds) {
        return [
            SELECT Id, Design_Image_URL__c, Design_Image__c, Content_Version_Id__c, Option_Number__c, Notes__c, 
                (SELECT Id, Name, Tax__c, Total_Price__c, Quantity__c, Design__c, Price__c, Wholesale_Price__c, 
                    Standardized_Item__c, Standardized_Item__r.Name, Standardized_Item__r.Product_Code__c, 
                    Standardized_Item__r.Product_Description__c, Standardized_Item__r.Product_Name__c, 
                    Standardized_Item__r.List_Price__c, Standardized_Item__r.Quantity__c, Design__r.Option_Number__c, 
                    Custom_Item__c, Custom_Item__r.Name, Custom_Item__r.Style__c, Custom_Item__r.Price_per_item__c, 
                    Custom_Item__r.Price__c, Custom_Item__r.Quantity__c, Custom_Item__r.Item_Number_Edit__c
                FROM Design_Items__r WHERE Id IN :itemIds)
            FROM Design__c
            WHERE Design_Round__c = :designRoundId
            AND Id IN (SELECT Design__c FROM Design_Item__c WHERE Id IN :itemIds)
        ];
    }
    
    private Design_Request__c queryDesignRequest(Id designRequestId) {
        return [
            SELECT Id, Opportunity__c, Opportunity__r.Requested_IHD__c, Opportunity__r.CloseDate, Opportunity__r.Promo_Code__c, 
                Opportunity__r.Prototype_Status__c, Opportunity__r.Collection__c, Opportunity__r.Uniform_Style__c, 
                Prototype_Size__c, Boy_Proto_Status__c, Owner.Name
            FROM Design_Request__c WHERE Id = :designRequestId
        ];
    }
    
    public String formatCurrency(Decimal i) {
        if (i == null) 
            return '0.00';
        i = Decimal.valueOf(Math.roundToLong(i * 100)) / 100;
        String s = (i.setScale(2) + (i >= 0 ? 0.001 : -0.001)).format();
        return s.substring(0, s.length() - 1);
    }
}