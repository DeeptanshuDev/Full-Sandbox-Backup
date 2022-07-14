/*
Description  : My Orders Items Lightning Component controller class.
Created By   : Abhinav Sharma
* Revision Logs : V1.0 - edited - Deeptanshu Bharti - a new method getDesigns2 is added for design whose apporved_art is false
*/
public with sharing class MyOrdersItemsController {
    
    public class InitData {
        public QueryStructure.Filter filters;
        public Boolean isCommunityUser;
        
        public InitData() {
            filters = new QueryStructure.Filter();
            isCommunityUser = false;
        }
    }
    
    //Method to first determine the account related to current logged in community user contact
    //and accordingly applying by default filters in order to only display appropriate records to the logged in user
    @AuraEnabled(cacheable=true)
    public static LightningResponseEntity getDesigns(String selectedOrderId) {
        LightningResponseEntity genericResponse = new LightningResponseEntity();
        try {
            
            List<String> designsIds = new List<String>();
            InitData response = new InitData();
            String userId = UserInfo.getUserId();
            List<User> users = [Select Id, Contact.AccountId from User WHERE Id =: userId];
            if(users != null && users.size() == 1) {
                if(String.isNotBlank(users[0].Contact.AccountId)) {
                    response.isCommunityUser = true;
                }
            }
            
            QueryStructure.FilterField filterField = new QueryStructure.FilterField();
            filterField.fieldName = 'Id';
            filterField.restriction = QueryStructure.RestrictionEnum.VALUEIN;
            
            QueryStructure.FilterValue filterValue = new QueryStructure.FilterValue();
            filterValue.stringValues.addAll(designsIds);
            filterField.filterValue = filterValue;
            
            List<Design_Request__c> designRequests = [SELECT ID, Opportunity__c FROM Design_Request__c 
                                                      WHERE Opportunity__c =: selectedOrderId
                                                     ];
            if(designRequests.size() > 0) {
                List<Design_Round__c> approvedDesignRounds = [SELECT ID, Artwork_Approved__c FROM Design_Round__c 
                                                              WHERE Design_Request__c =: designRequests
                                                              AND Artwork_Approved__c = true
                                                             ];
                if(approvedDesignRounds.size() > 0) {
                    for(Design__c design : [SELECT ID, Approved_Art__c FROM Design__c
                                            WHERE Design_Round__c IN : approvedDesignRounds
                                            AND Approved_Art__c = true
                                           ]) {
                                               designsIds.add(design.Id);
                                               
                                           }
                    if(designsIds.size() > 0) {
                        filterValue.stringValues.addAll(designsIds);       
                    }
                }
            }
            response.filters.filterFields.add(filterField);
            
            genericResponse.setBody(JSON.serialize(response));
            
        }
        catch(Exception e) {
            genericResponse.setError(e.getMessage());
        }
        return genericResponse;
    }
    
    /**
*
* @description : it is used for adding new table whose apporved_art is not true.
*
* @args :   String selectedOrderId
*
* @return : LightningResponseEntity
*
* @revision Log : V1.1 - Created - 12/07/2021 - Deeptanshu Bharti
*
**/
    
    @AuraEnabled(cacheable=true)
    public static LightningResponseEntity getDesigns2(String selectedOrderId) {
        LightningResponseEntity genericResponse = new LightningResponseEntity();
        try {
            
            List<String> unapprovedDesignsIds = new List<String>();

            InitData response = new InitData();
            String userId = UserInfo.getUserId();
            List<User> users = [Select Id, Contact.AccountId from User WHERE Id =: userId];
            if(users != null && users.size() == 1) {
                if(String.isNotBlank(users[0].Contact.AccountId)) {
                    response.isCommunityUser = true;
                }
            }
            
            QueryStructure.FilterField filterField = new QueryStructure.FilterField();
            filterField.fieldName = 'Id';
            filterField.restriction = QueryStructure.RestrictionEnum.VALUEIN;
            
            QueryStructure.FilterValue filterValue = new QueryStructure.FilterValue();
            filterValue.stringValues.addAll(unapprovedDesignsIds);
            filterField.filterValue = filterValue;            
            
            List<Design_Request__c> designRequests = [SELECT ID, Opportunity__c FROM Design_Request__c 
                                                      WHERE Opportunity__c =: selectedOrderId
                                                     ];
            if(designRequests.size() > 0) {
                List<Design_Round__c> unapprovedDesignRounds = [SELECT ID, Artwork_Approved__c FROM Design_Round__c 
                                                                WHERE Design_Request__c =: designRequests AND
                                                                Artwork_Approved__c = false
                                                               ];
                if(unapprovedDesignRounds.size() > 0) {
                    for(Design__c design : [SELECT ID, Approved_Art__c, Name, Design_Round__c, Option_Number__c FROM Design__c
                                            WHERE Design_Round__c IN : unapprovedDesignRounds
                                            AND Approved_Art__c = false
                                           ]) 
                    {
                        unapprovedDesignsIds.add(design.Id);
                        
                    }  
                    
                    if(unapprovedDesignsIds.size() > 0) {
                        filterValue.stringValues.addAll(unapprovedDesignsIds);       
                    }
                }
            }
            
            response.filters.filterFields.add(filterField);
            
            genericResponse.setBody(JSON.serialize(response));
        }
        catch(Exception e) {
            genericResponse.setError(e.getMessage());            
        }
        
        return genericResponse;        
    }
    
    @AuraEnabled
    public static LightningResponseEntity approveDesigns(List<String> designIdList, String signatureResponse) {
         LightningResponseEntity genericResponse = new LightningResponseEntity();
        try {
            List<Design__c> designsToApprove = [SELECT ID, Approved_Art__c, Name, Design_Round__c, Option_Number__c FROM Design__c
                                                WHERE ID IN :designIdList];
            Set<Id> designRoundIds = new Set<Id>();
            if(!designsToApprove.isEmpty()) {
                for(Design__c design :designsToApprove) {
                    design.Approved_Art__c = true;
                    designRoundIds.add(design.Design_Round__c);
                }
                List<Design_Round__c> designRoundsToApprove = [SELECT ID, Artwork_Approved__c FROM Design_Round__c 
                                                              WHERE ID IN :designRoundIds];
                if(!designRoundsToApprove.isEmpty()) {
                    Map<Id, Attachment> designRoundIdAttachmentMap = new Map<Id, Attachment>();
                    for(Design_Round__c designRound :designRoundsToApprove) {
                        designRound.Artwork_Approved__c = true;
                        Attachment att = new Attachment();
                        //You will want to tie your attachment to some type of custom or standard object
                        att.ParentId = designRound.Id;
                        att.Name = 'Signature_'+String.valueOf(Date.today()).substring(0,10)+'_'+designRound.Id;
                        att.Body =  EncodingUtil.base64Decode(signatureResponse); 
                        att.contentType = 'image/jpeg';
                        designRoundIdAttachmentMap.put(designRound.Id, att);
                    }
                    if(!designRoundIdAttachmentMap.isEmpty()) {
                        insert designRoundIdAttachmentMap.values();
                        List<eSignature_Status__c> eSignatureStatusList = new List<eSignature_Status__c>();
                        for(Design_Round__c designRound :designRoundsToApprove) {
                        	eSignature_Status__c eSignatureStatus = new eSignature_Status__c();
                            eSignatureStatus.Approved__c = true;
                            eSignatureStatus.Design_Round__c = designRound.Id;
                            eSignatureStatus.Sender_Name__c = UserInfo.getName();
                            eSignatureStatus.Envelop_Status__c = 'Approved';
                            eSignatureStatus.SignatureAttachment_Id__c = designRoundIdAttachmentMap.get(designRound.Id).Id;                            
                            eSignatureStatusList.add(eSignatureStatus);
                        }
                        if(!eSignatureStatusList.isEmpty()) {
                            insert eSignatureStatusList;
                        }
                    }
                }
                update designsToApprove;
            }
            genericResponse.setBody('Success');
        } catch(Exception e) {
            genericResponse.setError(e.getMessage());
        }
        return genericResponse;
    }
    
}