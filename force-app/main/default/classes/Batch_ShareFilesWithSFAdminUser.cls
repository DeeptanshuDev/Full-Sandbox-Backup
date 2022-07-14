global class Batch_ShareFilesWithSFAdminUser implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT ID FROM ContentDocument');
    }
    
    global void execute(Database.BatchableContext BC, List<ContentDocument> contentDocuments){
        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
        for(ContentDocument cD  : contentDocuments) {
            ContentDocumentLink link = new ContentDocumentLink();
            link.LinkedEntityId = Id.valueOf(System.Label.Rebel_Robot_User_ID);
            link.ContentDocumentId = cD.Id;
            link.ShareType = 'C';
            link.Visibility = 'AllUsers';
            contentDocumentLinks.add(link);
        }
        if(contentDocumentLinks.size() > 0) {
            Database.insert(contentDocumentLinks, false);
        }
    }
    
    global void finish(Database.BatchableContext BC) {}
}