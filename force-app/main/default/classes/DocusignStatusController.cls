public class DocusignStatusController {
    
    public static void invokeChatterThroughApex(List<dsfs__DocuSign_Recipient_Status__c> docusignDetails,Map<Id,dsfs__DocuSign_Recipient_Status__c> OlddocusignDetails){
        
        Set<Id> docsIds = new Set<Id>();
        Set<Id> designRoundIds = new Set<Id>();
        Set<Id> docsIdsUpdate = new Set<Id>();
        
        Set<Id> SentdocsIds = new Set<Id>();
        for(dsfs__DocuSign_Recipient_Status__c ds : docusignDetails){
           
           if(ds.dsfs__Recipient_Status__c == 'Sent' && olddocusignDetails == null){
                SentdocsIds.add(ds.dsfs__Parent_Status_Record__c);
            } 
            else if(ds.dsfs__Recipient_Status__c == 'Completed' && olddocusignDetails != null && olddocusignDetails.get(ds.Id).dsfs__Recipient_Status__c != 'Completed'){
                docsIdsUpdate.add(ds.dsfs__Parent_Status_Record__c);
            }
        }
        system.debug('docsIdsUpdate' +docsIdsUpdate);
        if(docsIdsUpdate.size() > 0){
            List<dsfs__DocuSign_Recipient_Status__c> resStatus = [select id,dsfs__Recipient_Status__c,dsfs__Parent_Status_Record__c from dsfs__DocuSign_Recipient_Status__c where dsfs__Parent_Status_Record__c IN: docsIdsUpdate order by createddate desc];
            
                List<dsfs__DocuSign_Status__c> docs = [select id,name,dsfs__Minutes_to_Complete__c,Design_Round__c from dsfs__DocuSign_Status__c where id IN: docsIdsUpdate];
                system.debug('docs 2222'+docs);
                
                for(dsfs__DocuSign_Status__c dd : docs){
                    
                    designRoundIds.add(dd.Design_Round__c);
                }
                
                List<Design_Round__c> des = [select id,name from Design_Round__c where id IN: designRoundIds];
                
                List<ContentDocumentLink> cdt = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId =: docs[0].Id ];
                system.debug('cdt '+cdt);
                if(cdt.size() > 0){
                    List<ContentVersion> cv = [SELECT Id, ContentDocumentId, ContentUrl, ContentBodyId FROM ContentVersion where ContentDocumentId =: cdt[0].ContentDocumentId];
                    
                    if(cv.size() > 0){
                        FeedItem post = new FeedItem();
                        
                        post.ParentId = des[0].Id;
                        post.Body = 'Envelope for Design_Round__c "'+des[0].Name+'" was signed and completed in DocuSign. Elapsed Time: '+docs[0].dsfs__Minutes_to_Complete__c+' minutes \n View DocuSign Status:'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+docs[0].Id;
                        insert post;
                        
                        FeedAttachment fa = new FeedAttachment();
                        fa.FeedEntityId = post.Id;//Chatter Post Id
                        fa.RecordId = cv[0].Id;//Document Id
                        fa.Type = 'CONTENT'; 
                        insert fa;
                    }
            }
        }
       
        else if(SentdocsIds.size() > 0){
             List<dsfs__DocuSign_Status__c> docs = [select id,name,dsfs__Minutes_to_Complete__c,Design_Round__c from dsfs__DocuSign_Status__c where id IN: SentdocsIds];
           system.debug('docs '+docs);
            
            for(dsfs__DocuSign_Status__c dd : docs){
                
                designRoundIds.add(dd.Design_Round__c);
            }
            
            List<Design_Round__c> des = [select id,name from Design_Round__c where id IN: designRoundIds];
            FeedItem post = new FeedItem();
            post.ParentId = des[0].Id;
            post.Body = 'Envelope for Design_Round__c "'+des[0].Name+'" was sent for signature in DocuSign. \n View DocuSign Status:'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+docs[0].Id;
            insert post;
            
        }
    }
}