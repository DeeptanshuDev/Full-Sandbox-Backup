/*
 * Creates chatter posts based on Custom Items' status values and Item Status Notification records.
 *
 */
public class CustomItemNotifications {

  public static Boolean disableNotifications = false;

  private ItemNotifcationSettingRepo itemNotifcationSettingRepo = new ItemNotifcationSettingRepo();
  private DesignRequestRepo designRequestRepo = new DesignRequestRepo();

  public void createNotifications(List<Custom_Item__c> items) {
      
    Map<Id, Set<String>> statusByDesignRequestId = new Map<Id, Set<String>>();
    Set<Id> designRequestIds = new Set<Id>();
    for (Custom_Item__c item : items) {
      if (item.Design_Request__c == null || item.Design_Status__c == null) {
        continue;
      }
        
      Set<String> statuses = statusByDesignRequestId.get(item.Design_Request__c);
        
      if (statuses == null) {
        statuses = new Set<String>();
        statusByDesignRequestId.put(item.Design_Request__c, statuses);
      }
      statuses.add(item.Design_Status__c);
      designRequestIds.add(item.Design_Request__c);
        
    }

    Map<Id, Design_Request__c> designRequestsById = new Map<Id, Design_Request__c>(
      designRequestRepo.findByIds(new List<Id>(designRequestIds))
    );

    Map<String, String> messageByStatus = getMessageByStatus();

    for (Id designRequestId : statusByDesignRequestId.keySet()) {
      Set<String> statuses = statusByDesignRequestId.get(designRequestId);

      for (String status : statuses) {
          
        String message = messageByStatus.get(status);
        if (message == null) {
          continue;
        }
        Design_Request__c designRequest = designRequestsById.get(designRequestId);
          
		
        if (!disableNotifications) {
            //System.assert(false,'hereds');
            //System.assert(false,designRequest.Design_Round_Flag__c);
            if(designRequest.Design_Round_Flag__c == 'Green Flag')
            {
              //  System.assert(false,designRequest.Design_Round_Flag__c);
                makeChatterPost(designRequest, message); 
            }
            else 
            {
                placeChatter(designRequest);
            }
        }
      }
    }
  }

  private void makeChatterPost(Design_Request__c designRequest, String message) {
      
    message = FormulaEvaluator.evaluate(designRequest, message);
    ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(null,
      designRequest.Id, message);
  }

  private Map<String, String> getMessageByStatus() {
      
    List<Item_Notification_Setting__mdt> settings = itemNotifcationSettingRepo.findAll();

       
    Map<String, String> messageByStatus = new Map<String, String>();
    for (Item_Notification_Setting__mdt setting : settings) {
      List<String> statuses = setting.Status__c.split(';');
      for (String status : statuses) {
          
        messageByStatus.put(status, setting.Message__c);
      }
    }

    return messageByStatus;
  }
    /**
    *
    * @description : This method is used for placing chatter when design round flag is None.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 07/05/2022 - Deeptanshu Bharti
    *
    **/
    public void placeChatter(Design_Request__c designRequest){
        /*FeedItem post = new FeedItem();
            post.ParentId = designRequest.Id;
            String str = '@'+designRequest.Assigned_Designer__r.Name +' \n\n Revision Comments have been posted for '+designRequest.Name + '.This round is flagged None. \n'+designRequest.Detail_Link__c+'\n'+designRequest.Account__r.Name;  
            post.Body = str;
            insert post;*/ 
        if((designRequest.Assigned_Designer__c != NULL) &&(designRequest.id != NULL))
        {
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            mentionSegmentInput.id = designRequest.Assigned_Designer__c;
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            
            // post body
            String postBody = '\n\n Revision Comments have been posted for '+designRequest.Name + '.This round is flagged None. \n\n'+designRequest.Detail_Link__c+'\n'+designRequest.Account__r.Name;
            
            textSegmentInput.text = postBody;
            messageBodyInput.messageSegments.add(textSegmentInput);
            feedItemInput.body = messageBodyInput;
            
            
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            //post on Account record
            feedItemInput.subjectId = designRequest.id;
            //post the chatter
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);  
        }
        
        
    }
}