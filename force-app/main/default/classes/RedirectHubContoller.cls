/**
Desription      :   Controller of Redirect hub-Vf page acting as redirect center for multiple buttons 
Created By      :   Abhinav Sharma
Created Date    :   01/07/2020
Revision Logs   :   v1 - Created
**/
public class RedirectHubContoller 
{
    public String envID {get; set;}
    public String navigateURL {get; set;}
    public String theme;
    public Boolean visibleEnv {get; set;}    
    public boolean hasError 
    {
        get {
            return (apexPages.getMessages().size() > 0);
        }
        set;
    }
    public Map<String,String>mapOfParameters {get; set;} 
    public String JsonMap {get;set;}
    public RedirectHubContoller() 
    { 
        envID= '';
        visibleEnv = false;
        theme = userinfo.getUiThemeDisplayed() ;
        mapOfParameters = new Map<String,String>();
        mapOfParameters = ApexPages.currentPage().getParameters();
        JsonMap=JSON.serialize(mapOfParameters);
    }
    
    //Method to evaluate various pages and their functionality
    public void evaluate()
    {
        switch on mapOfparameters.get('location') 
        {
            when 'New_Design_Request' 
            {
                navigateToNewDesignRequest();
            }
            when else 
            {
                //Do something here      
            }
        }
    }
    public void setupEnv(){}
    
    public pagereference navigateToNewDesignRequest() 
    {
        String opportunityId = ApexPages.currentPage().getParameters().get('oppId');
       
        if(String.isNotBlank(opportunityId)) 
        {
            List<Opportunity> opportunities = new List<Opportunity>([SELECT ID, Custom_Item_Numbers__c, Name, AccountId, 
                                                                     Account.Name, Primary_Contact__c,
                                                                     Primary_Contact__r.Name
                                                                     FROM Opportunity
                                                                     WHERE ID =: opportunityId
                                                                    ]);
            if(opportunities.size() > 0) 
            {
                if(String.isBlank(opportunities[0].Custom_Item_Numbers__c)) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please create custom items before creating a design request.'));
                }
                else 
                {
                     
                    if(theme == 'Theme2' || theme == 'Theme3') 
                    {
                        String objPrefix = Design_Request__c.sObjecttype.getDescribe().getKeyPrefix();
                        navigateURL =  '/' + objPrefix + '/e';
                        navigateURL +=  '?retURL=' + opportunities[0].Id;
                        //navigateURL +=  '&saveURL=' + productLeads[0].Id;
                        navigateURL +=  '&cancelURL=' + opportunities[0].Id;
                        navigateURL +=  '&CF00N1500000CJ53X=' + opportunities[0].Name;
                        navigateURL +=  '&CF00N1500000CJ53X_lkid='+ opportunities[0].Id;
                        navigateURL +=  '&CF00N1500000CJ53S=' + opportunities[0].Account.Name;
                        navigateURL +=  '&CF00N1500000CJ53S_lkid=' + opportunities[0].AccountId;
                        navigateURL +=  '&CF00N1500000CJ53r=' + opportunities[0].Primary_Contact__r.Name;
                        navigateURL +=  '&CF00N1500000CJ53r_lkid=' + opportunities[0].Primary_Contact__c;
                       
                    }
                    else 
                    {
                        navigateURL = '/apex/URLNavigator?operationtype=createRecord&entityName=Design_Request__c&recordTypeSelection=false'; 
                        navigateURL += '&fields=Opportunity__c@~@Account__c@~@Primary_Contact__c';
                        navigateURL += '&defaults=' + opportunities[0].Id + '@~@' + opportunities[0].AccountId+ '@~@' +opportunities[0].Primary_Contact__c;   
                        navigateURL += '&returnURL=' + opportunities[0].Id; 
           				
                    }
                }
            }
            else 
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please select/specify an opportunity to create new design request.'));
            }
        }
        return null;    
    }
}