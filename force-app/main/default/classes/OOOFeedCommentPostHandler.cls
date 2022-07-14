/**
 *  Description     :  Handler class of Trigger OOOFeedCommentPost Used to send automatic replay of chatter comments when user 
 *                     is in out of office record
 *
 *  Created By      :  Chirag Soni -CR - 00000166
 *
 *  Created Date    :  12/01/2021
 *
 *  Revision Logs   :   V_1.0 - Created 
**/

public class OOOFeedCommentPostHandler {
    public void postOOOReplayInInsert(List<FeedComment> feedComment)
    {
        
        if(feedComment.size()>0)
        {
            Map<String, Out_of_Office__c> mapOfOOO = getMapOfOOO(); //-- out of office records for automatic reply 
            
            List<FeedComment> fdcmt = new List<FeedComment>();
            for(FeedComment fc : feedComment)
            {
                
                if(fc.CommentType == 'TextComment') //-- check if comment type is text
                {
                    system.debug('maps '+mapOfOOO);
                    if(!mapOfOOO.isEmpty())
                    {
                        for( String name : mapOfOOO.keySet())
                        {
                            
                            if(fc.CommentBody.contains(name)) //-- if comment body contains user name who is out of office
                            {
                                FeedComment feedcmt = new FeedComment();
                                feedcmt.CommentBody = mapOfOOO.get(name).Message__c;
                                feedcmt.CommentType = 'TextComment';
                                feedcmt.FeedItemId = fc.FeedItemId;
                                feedcmt.CreatedById =  mapOfOOO.get(name).Owner.id;
                                fdcmt.add(feedcmt);
                            }
                        }
                    }      
                }
            }
            
            insert fdcmt;
        }
    }
    public void postOOOReplayInUpdate(List<FeedComment> feedComment, Map<Id,FeedComment> oldFeedComment)
    {
        if(feedComment.size()>0)
        {    
            Map<String, Out_of_Office__c> mapOfOOO = getMapOfOOO(); //-- out of office records for automatic reply 
            List<FeedComment> fdcmt = new List<FeedComment>();
            for(FeedComment fc : feedComment)
            {
                if(fc.CommentType == 'TextComment' && fc.CommentBody != oldFeedComment.get(fc.Id).CommentBody) //-- check if comment type is text and old body is not equal to new comment body
                {  
                    if(!mapOfOOO.isEmpty())
                    {
                        for( String name : mapOfOOO.keySet())
                        {
                            if(fc.CommentBody.contains(name)) //-- if  new comment body contains user name who is out of office.
                            {
                                FeedComment feedcmt = new FeedComment();
                                feedcmt.CommentBody = mapOfOOO.get(name).Message__c;
                                feedcmt.CommentType = 'TextComment';
                                feedcmt.FeedItemId = fc.FeedItemId;
                                feedcmt.CreatedById =  mapOfOOO.get(name).Owner.id;
                                fdcmt.add(feedcmt);
                            }
                        }
                    }   
                }
            }
            insert fdcmt;
        }
    }
    
    static Map<String, Out_of_Office__c> getMapOfOOO()
    {
        Map<String, Out_of_Office__c> mapOfOOO = new Map<String, Out_of_Office__c>();
        for(Out_of_Office__c outOfOfficeUser : [SELECT Id, Owner.id, Name, End_Date__c, Start_Date__c, Message__c FROM Out_of_Office__c
                                                WHERE End_Date__c >= :Date.today() AND
                                                Start_Date__c <= :Date.today() AND Name != NULL])
        {
            mapOfOOO.put(outOfOfficeUser.Name, outOfOfficeUser);
        }
        return mapOfOOO;
    }
}