/*
Description  : News Lightning Component controller class.
Created By   : Abhinav Sharma
*/
public with sharing class NewsController {
    
    public class InitData {
        public QueryStructure.Filter filters;
        public Boolean isCommunityUser;
        
        public InitData() {
            filters = new QueryStructure.Filter();
            isCommunityUser = false;
        }
    }
    
    //Method to fetch live news records
    @AuraEnabled(cacheable=true)
    public static LightningResponseEntity getInit() {
        LightningResponseEntity genericResponse = new LightningResponseEntity();
        try {
            InitData response = new InitData();
            response.isCommunityUser = true;
            QueryStructure.FilterField filterField = new QueryStructure.FilterField();
            filterField.fieldName = 'Status__c';
            filterField.restriction = QueryStructure.RestrictionEnum.EQ;
            QueryStructure.FilterValue filterValue = new QueryStructure.FilterValue();
            filterValue.stringValues.add('Live');
            filterField.filterValue = filterValue;
            response.filters.filterFields.add(filterField);
            genericResponse.setBody(JSON.serialize(response));
        }
        catch(Exception e) {
            genericResponse.setError(e.getMessage());
        }
        return genericResponse;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getInfoMessage() {
        return GenericUtils.getHelpTextConfiguration('News');
    } 
}