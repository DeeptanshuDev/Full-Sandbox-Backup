/*
 Description  : My Invoices Lightning Component controller class.
 Created By   : Abhinav Sharma
*/
public with sharing class MyInvoicesController {
    
    public class InitData {
        public QueryStructure.Filter filters;
        public Boolean isCommunityUser;
        
        public InitData() {
            filters = new QueryStructure.Filter();
            isCommunityUser = false;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static LightningResponseEntity getInit() {
        LightningResponseEntity genericResponse = new LightningResponseEntity();
        try {
            InitData response = new InitData();
            String userId = UserInfo.getUserId();
            List<User> users = [Select Id, Contact.AccountId from User WHERE Id =: userId];
            if(users != null && users.size() == 1) {
                if(String.isNotBlank(users[0].Contact.AccountId)) {
                    response.isCommunityUser = true;
                    QueryStructure.FilterField filterField = new QueryStructure.FilterField();
                    filterField.fieldName = 'Opportunity__r.AccountId';
                    filterField.restriction = QueryStructure.RestrictionEnum.EQ;
                    
                    QueryStructure.FilterValue filterValue = new QueryStructure.FilterValue();
                    filterValue.stringValues.add(users[0].Contact.AccountId);
                    filterField.filterValue = filterValue;
                    response.filters.filterFields.add(filterField);
                    
                } else {}
            }
            genericResponse.setBody(JSON.serialize(response));
        }
        catch(Exception e) {
            genericResponse.setError(e.getMessage());
        }
        return genericResponse;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getInfoMessage() {
        return GenericUtils.getHelpTextConfiguration('MyInvoices');
    }
}