public class ElectronicProtoApprovalPdfCtrl {
    
    public Design_Round__c designRound { get; set; }
    public List<Design__c> designs { get; set; }
    public String OwnerName { get{ return DesignRequest.Owner.Name; }}
    
    public String Today { get { return DateTime.newInstance(Date.today().year(), Date.today().month(), Date.today().day()).format('MM/dd/yyyy'); }}
    
    public Design_Request__c DesignRequest { get; set; }
    public String Customer { get { return designRound.Design_Request__r.Account__r.Name; }} 
    
    public String Version { get { return designRound.Version__c; }}
    
    public String Designer { get { return designRound.Design_Request__r.Assigned_Designer__r.Name; }}
    public String DR { get { return designRound.Design_Request__r.Name; }}
    
    public String OpportunityName { get { return designRound.Design_Request__r.Opportunity__r.Name; }}
    
    public String customNum { get { return queryCustomItem(designRound.Design_Request__c);}}
    
    public  ElectronicProtoApprovalPdfCtrl(ApexPages.StandardController cont) {

        this.standardController = cont;
        List<String> designItemIds = ApexPages.currentPage().getParameters().get('items').split(';');
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ' +designItemIds);
        
        designRound = queryDesignRound(cont.getSubject().Id);
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ' +cont.getSubject().Id);
        
        
        //designRound = queryDesignRound(DesignRoundId);
        
        designs = queryDesigns(designRound.id,designItemIds);
        system.debug('ddesi n--'+designs);
        
        DesignRequest = queryDesignRequest(designRound.Design_Request__c);
        system.debug('rqeuest --'+DesignRequest);
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
    
    private ApexPages.StandardController standardController;
    
    private Design_Round__c queryDesignRound(Id designRoundId) {
        return [
            SELECT Id
            , Name
            , toLabel(Version__c)
            , Revision_Notes__c
            , Design_Request__r.Account__r.Name
            , Design_Request__r.Assigned_Designer__r.Name
            , Prototype__c
            , Design_Request__R.Name
            , Design_Request__r.Opportunity__r.Name
            , Design_Request__r.Opportunity__r.Prototype_Status__c
            FROM Design_Round__c
            WHERE Id = :designRoundId
        ];
        
    }
    
    private List<Design__c> queryDesigns(Id designRoundId, List<String> itemIds) {
        return [
            SELECT Id
            , Design_Image_URL__c
            , Design_Image__c
            , Content_Version_Id__c
            , Option_Number__c
            , Notes__c
            , (
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
                , Design__r.Option_Number__c
                , Custom_Item__c
                , Custom_Item__r.Name
                , Custom_Item__r.Style__c
                , Custom_Item__r.Price_per_item__c
                , Custom_Item__r.Price__c
                , Custom_Item__r.Quantity__c
                , Custom_Item__r.Item_Number_Edit__c
                FROM Design_Items__r WHERE Id IN :itemIds
            )
            FROM Design__c
            WHERE Design_Round__c = :designRoundId
            AND Id IN (SELECT Design__c FROM Design_Item__c WHERE Id IN :itemIds)
        ];
    }
    
    private Design_Request__c queryDesignRequest(Id designRequestId) {
        return [
            SELECT Id
            , Opportunity__c
            , Opportunity__r.Requested_IHD__c
            , Opportunity__r.CloseDate
            , Opportunity__r.Promo_Code__c
            , Prototype_Size__c
            , Owner.Name
            FROM Design_Request__c WHERE Id = :designRequestId
        ];
    }
    private string queryCustomItem(Id designRequestId){
        string itemNumber = '' ;
        List<custom_item__c > cust = [SELECT Item_Number_Edit__c FROM Custom_item__c Where Design_Request__c =: designRequestId AND Design_Status__c != '(S) Grey Out'];
        if(cust.size() > 0 ){
            integer num = 1 ;
            for(custom_item__c c : cust){
                if(num == 1){
                    itemNumber += c.Item_Number_Edit__c ;
                    num += 1;
                }
                else
                    itemNumber += ','+' '+ c.Item_Number_Edit__c;
            }          
        }
        return itemNumber ;
    }    
    public String formatCurrency(Decimal i) {
        if (i == null) return '0.00';
        i = Decimal.valueOf(Math.roundToLong(i * 100)) / 100;
        String s = (i.setScale(2) + (i >= 0 ? 0.001 : -0.001)).format();
        return s.substring(0, s.length() - 1);
    }
    
}