/**
* Purpose		: Class to retrieve custom links details from the correspodning custom metadata types.
*
* Created by	: Abhinav Sharma
* 	
* Created Date : 10/26/2019
* 
* Version		: V.0 Created
**/
public class CustomLinkRetrieveController 
{
    @AuraEnabled(cacheable=true)
    public static List<ResponseWrapper> getCustomLinksDetails(String homePageComponentName)
    {   
        system.debug('ticket---'+ homePageComponentName);
        List<ResponseWrapper> responseWrapperList = new List<ResponseWrapper>();
        List<Home_Page_Component__mdt> homePageComponents = [SELECT Id, Label FROM Home_Page_Component__mdt
                                                             WHERE Label =: homePageComponentName
                                                            ];
        if(homePageComponents.size() > 0) 
        {
            List<Home_Page_Link__mdt> customLinks = [SELECT Id, Label, MasterLabel, Custom_Link_Name__c,
                                                     Custom_Link_URL__c, Home_Page_Component__c,
                                                     Custom_Link_URL_2__c
                                                     FROM Home_Page_Link__mdt
                                                     WHERE Home_Page_Component__c =: homePageComponents[0].Id
                                                    ];
            if(customLinks.size() >0)
            {
                for(Home_Page_Link__mdt customLinkData: customLinks)
                {
                    ResponseWrapper wrapObj = new ResponseWrapper();
                    wrapObj.labelString = customLinkData.Label;
                    wrapObj.masterLabelString = customLinkData.MasterLabel;
                    wrapObj.customLinkName = customLinkData.Custom_Link_Name__c;
                    if(customLinkData.Custom_Link_URL_2__c == null) {
                    	customLinkData.Custom_Link_URL_2__c = '';    
                    }
                    wrapObj.customLinkURL = customLinkData.Custom_Link_URL__c + customLinkData.Custom_Link_URL_2__c;
                    wrapObj.errorMessage = null;
                    responseWrapperList.add(wrapObj);
                }
            }
            else 
            {
                responseWrapperList.add(new ResponseWrapper(System.Label.Error_No_Home_Page_Custom_Links_Exists ));    
            }
        }
        else 
        {
            responseWrapperList.add(new ResponseWrapper(System.Label.Error_No_Home_Page_Component_Exists )); 	    
        }
        return responseWrapperList;
    }
    
    public class ResponseWrapper
    {
        @AuraEnabled public String labelString {get;set;}
        @AuraEnabled public String masterLabelString {get;set;}
        @AuraEnabled public String customLinkName {get;set;}
        @AuraEnabled public String customLinkURL {get;set;}    
        @AuraEnabled public String errorMessage {get;set;}
        public ResponseWrapper() 
        {
            errorMessage = null;
        }
        public ResponseWrapper(String errorMessage) 
        {
            this.errorMessage = errorMessage;
        }
    }
}