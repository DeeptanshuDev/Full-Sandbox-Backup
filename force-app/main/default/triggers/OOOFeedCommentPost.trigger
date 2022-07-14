/**
 *  Purpose         :   Trigger used to send automatic replay of chatter comments when user is in out of office record 
 *
 *  Created By       :  Chirag Soni - CR - 00000166
 *
 *  Created Date    :   12/01/2021
 *
 *  Revision Logs   :   V_1.0 - Created
 *            
 **/

trigger OOOFeedCommentPost on FeedComment (after insert, after update) {
 if (Trigger.isInsert && Trigger.isAfter)
{
    OOOFeedCommentPostHandler postComment = new OOOFeedCommentPostHandler();
    postComment.postOOOReplayInInsert(Trigger.new);
}
if(Trigger.isUpdate && Trigger.isAfter)    
{
    OOOFeedCommentPostHandler postComment = new OOOFeedCommentPostHandler();
    postComment.postOOOReplayInUpdate(Trigger.new, Trigger.oldMap );
}
}