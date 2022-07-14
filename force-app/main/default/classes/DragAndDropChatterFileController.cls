global with sharing class DragAndDropChatterFileController 
{
    public Id myId {get;set;}
    public DragAndDropChatterFileController()
    {
        myId = ApexPages.currentPage().getParameters().get('id'); 
    }
    
    @RemoteAction
    global static String saveFile(String filename, String fileContent, String id) 
    {
        String err = null;
        try
        {
            //Adding a Content post
            FeedItem post = new FeedItem();
            post.ParentId = id; //eg. Opportunity id, custom object id..
            post.Body = '';
            post.ContentData = EncodingUtil.base64Decode(fileContent);
            post.ContentFileName = filename;
            if (Schema.SObjectType.FeedItem.isCreateable() &&
                Schema.SObjectType.FeedItem.fields.ParentId.isCreateable() &&
                Schema.SObjectType.FeedItem.fields.Body.isCreateable() &&
                Schema.SObjectType.FeedItem.fields.ContentData.isCreateable() &&
                Schema.SObjectType.FeedItem.fields.ContentFileName.isCreateable()
               ) 
            {
                insert post;
            } else {
                err = 'Current user does not have the priviledges to post on chatter.';
            }
        }
        catch(Exception e){
            err=e.getMessage();
        }
        return err;
    }
}