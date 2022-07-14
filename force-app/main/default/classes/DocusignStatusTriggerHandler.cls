public class DocusignStatusTriggerHandler {

    public static void invokeChatterThroughApex(List<dsfs__DocuSign_Status__c> docusignDetails,Map<Id,dsfs__DocuSign_Status__c> oldDetails){
        
        Set<Id> docsIds = new Set<Id>();
        Set<Id> designRoundIds = new Set<Id>();
        
        for(dsfs__DocuSign_Status__c ds : docusignDetails){
           
            if(ds.dsfs__Envelope_Status__c == 'Voided' && oldDetails.get(ds.Id).dsfs__Envelope_Status__c != ds.dsfs__Envelope_Status__c){
                docsIds.add(ds.Id);
            }
            if(ds.dsfs__Envelope_Status__c == 'Declined' && oldDetails.get(ds.Id).dsfs__Envelope_Status__c != ds.dsfs__Envelope_Status__c){
                docsIds.add(ds.Id);
            }
        }
        
        
        if(docsIds.size() > 0){
            List<dsfs__DocuSign_Status__c> docs = [select id,name,dsfs__Minutes_to_Complete__c,dsfs__Envelope_Status__c,Design_Round__c from dsfs__DocuSign_Status__c where id IN: docsIds];
            
            for(dsfs__DocuSign_Status__c dd : docs){
                
                designRoundIds.add(dd.Design_Round__c);
            }
            
            List<Design_Round__c> des = [select id,name from Design_Round__c where id IN: designRoundIds];
            
            FeedItem post = new FeedItem();
            
            post.ParentId = des[0].Id;
            
            if(docs[0].dsfs__Envelope_Status__c == 'Voided'){
            post.Body = 'Envelope for Design_Round__c "'+des[0].Name+'" was voided in DocuSign.\n View DocuSign Status:'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+docs[0].Id;
           
            }else if(docs[0].dsfs__Envelope_Status__c == 'Declined'){
               post.Body = 'Envelope for Design_Round__c "'+des[0].Name+'" was declined in DocuSign.\n View DocuSign Status:'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+docs[0].Id;
            
            }
                insert post;
        }
    }
}