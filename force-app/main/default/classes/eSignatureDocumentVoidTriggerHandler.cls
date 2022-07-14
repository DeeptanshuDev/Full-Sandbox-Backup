/**
*  Description     :   Handler class for trigger eSignatureDocumentVoidTrigger used to void(delete) existing Art Approval
*                      document which is created more than once on same design items.
* 
*  Created By      :   Chirag Soni
*
*  Created Date    :   3/12/2021
*
*  Revision Logs   :   V_1.0 - Created 
**/

public class eSignatureDocumentVoidTriggerHandler {
    
/**
* 
*  @description    :   Method used to find existing art approval documents created with same design items on design round
if exist this method will void(delete) old AA files.
*
*  @args           :   new list of ContentVersion
*
*  @return         :   void 
*
*  @revision Log   :   V_1.0 - Created  3/12/2021
* 
**/  
    
    public static void deleteOldVersionWithSameDesignItem(List<ContentVersion> listOfContentVersion){
        ///system.assert(false, listOfContentVersion);
        Set<Id> linkedEntityids = new Set<Id>();
        List<String> listOfreasonForChange = new List<String>();
        //List<String> listOfreasonForChange1 = new List<String>();
        if(listOfContentVersion.size()>0){
            for(ContentVersion contentVersion : listOfContentVersion){
                if(String.isNotBlank(contentVersion.ReasonForChange) && contentVersion.ReasonForChange.containsAny(':')){
                    List<String> DesignRoundIdFromReasonForChange = contentVersion.ReasonForChange.split(':');
                    listOfreasonForChange.add(contentVersion.ReasonForChange);
                    //listOfreasonForChange1.add(DesignRoundIdFromReasonForChange[0]);
                    linkedEntityids.add(DesignRoundIdFromReasonForChange[1]);
                }
            }
        }
        System.debug('listOfreasonForChange: ' + listOfreasonForChange);
        //System.debug('listOfreasonForChange1: ' + listOfreasonForChange1);
        //linkedEntityids = addAllLinkedEntityids(linkedEntityids);
        if(linkedEntityids.size()>0)
        {
            System.debug('linkedEntityids: ' + linkedEntityids);
            List<contentDocumentLink> ListOfOldcontentDocumentLink = [SELECT ContentDocumentId FROM contentDocumentLink 
                                                                      WHERE LinkedEntityid IN :linkedEntityids];
            System.debug('ListOfOldcontentDocumentLink: ' + ListOfOldcontentDocumentLink);
            if(ListOfOldcontentDocumentLink.size()>0){
                Set<Id> oldContentdocumentIds = new Set<Id>();
                for(contentDocumentLink contentDocLink : ListOfOldcontentDocumentLink){
                    oldContentdocumentIds.add(contentDocLink.ContentDocumentId);
                }
                if(oldContentdocumentIds.size()>0){
                    List<ContentVersion> listOfOldContentVersons = [SELECT Id, ContentDocumentId, ReasonForChange 
                                                                    FROM ContentVersion WHERE 
                                                                    ContentDocumentId IN :oldContentdocumentIds]; 
                    if(listOfOldContentVersons.size()>0){
                        set<Id> contentDocIdsToBeDeleted = new set<Id>();
                        //set<Id> contentDocIdsToBeDeleted1 = new set<Id>();
                        for(ContentVersion contentVersion : listOfOldContentVersons){
                            if(listOfreasonForChange.contains(contentVersion.ReasonForChange)){
                                contentDocIdsToBeDeleted.add(contentVersion.ContentDocumentId);
                            }
                            /*if(listOfreasonForChange1.contains(contentVersion.ReasonForChange)){
                                contentDocIdsToBeDeleted1.add(contentVersion.ContentDocumentId);
                            }*/
                        }
                        System.debug('contentDocIdsToBeDeleted: ' + contentDocIdsToBeDeleted);
                        //System.debug('contentDocIdsToBeDeleted1: ' + contentDocIdsToBeDeleted1);
                        if(contentDocIdsToBeDeleted.size()>0){
                            List<ContentDocument> contentDocumentsToBeDeleted = [SELECT Id FROM
                                                                                 ContentDocument
                                                                                 WHERE Id IN :contentDocIdsToBeDeleted];
                            if(contentDocumentsToBeDeleted.size()>0){
                                delete contentDocumentsToBeDeleted;
                            }
                        }
                    }
                }
            }
        }
    }
    
    //Created by Shubham Sharma on 27-Oct-2021
    
    /*private static set<Id> addAllLinkedEntityids(Set<Id> linkedEntityids) {
        Set<Id> allLinkedEntityids = new Set<Id>();
        Set<Id> linkedEntityids1 = new Set<Id>();
        if(linkedEntityids != null && linkedEntityids.size()>0) {
            for(String linkedEntityid : linkedEntityids){
                if(linkedEntityid.substring(0, 3) == 'a0i') {
                    linkedEntityids1.add(linkedEntityid);
                }
            }
            System.debug('linkedEntityids New: ' + linkedEntityids);
            System.debug('linkedEntityids1: ' + linkedEntityids1);
            if(linkedEntityids1 != null && linkedEntityids1.size()>0) {
                List<String> listOfGenderSequence = new List<String>();
                List<Design_Round__c> listOfDesignRound = [SELECT Gender__c FROM Design_Round__c WHERE Id IN :linkedEntityids1];
                for(Design_Round__c dr : listOfDesignRound) {
                    listOfGenderSequence.add(dr.Gender__c);
                }
                System.debug('listOfGenderSequence: ' + listOfGenderSequence);
                
                List<Design_Request__c> listDesignRequest = [SELECT Id, (SELECT Id, Gender__c FROM Design_Rounds__r) 
                                                             FROM Design_Request__c
                                                             WHERE Id IN (SELECT Design_Request__c FROM Design_Round__c WHERE Id IN :linkedEntityids1)];
                
                System.debug('Size Comparision: ' + listOfGenderSequence.size() + ' & ' + listDesignRequest.size());
                if(listDesignRequest != null && listDesignRequest.size() > 0) {
                    Integer i = 0;
                    for(Design_Request__c designRequest : listDesignRequest) {
                        for(Design_Round__c designRound : designRequest.Design_Rounds__r) {
                            if(listOfGenderSequence[i] == designRound.Gender__c) {
                                allLinkedEntityids.add(designRound.id);
                            }
                        }
                        i += 1;
                    }
                }
            } 
        }
        System.debug('allLinkedEntityids: ' + allLinkedEntityids);
        return allLinkedEntityids;
    }*/
    
    /**
    * 
    *  @description    :   Method used to 
    *
    *  @args           :   new list of ContentVersion
    *
    *  @return         :   void 
    *
    *  @revision Log   :   V_1.0 - Created  02/15/2022
    * 
    **/  
    
    public static void soNeededCheckBox(List<ContentVersion> listOfContentVersion, Map<Id, ContentVersion> oldMap){
        
        System.debug('contents are : '  + listOfContentVersion);
        Set<Id> contentVersionId = new Set<Id>();
        List<Opportunity> listOfOppIdtoUpdate = new List<Opportunity>();
        if(listOfContentVersion.size()>0){
            Set<Id> ContentDocumentId = new Set<Id>();
            for(ContentVersion contentVersion : listOfContentVersion){
                String title = contentVersion.Title;
                System.debug('the title is : ' + title);
                //if(title.startsWithIgnoreCase('So-'))
                if(title.contains('SO-'))
                {
                     contentVersionId.add(contentVersion.Id);
                    //system.assert(false, contentVersionId);
                    ContentDocumentId.add(contentVersion.ContentDocumentId);
                }
            }
            System.debug('content document id are : ' + ContentDocumentId);
            Set<Id> setOfOppId = new Set<Id>();
            if(ContentDocumentId.size()>0){
                for(ContentDocumentLink temp : [SELECT Id, ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN : ContentDocumentId])
                {
                    //system.assert(false, temp);
                    Id pId = temp.LinkedEntityId;
                    setOfOppId.add(pId);
                }
                System.debug('opportunity ids are : ' + setOfOppId);
                
                for(Opportunity opp : [SELECT Id, SO_Needed__c FROM Opportunity WHERE Id IN : setOfOppId])
                {
                    //system.assert(false, opp);
                    if(opp.SO_Needed__c == true)
                    {
                        //system.assert(false, opp);
                        opp.SO_Needed__c = false;
                        listOfOppIdtoUpdate.add(opp);
                    }
                }
                
            }
            
        }
        if(listOfOppIdtoUpdate.size()>0)
        {
            update listOfOppIdtoUpdate;
        }
    }
}