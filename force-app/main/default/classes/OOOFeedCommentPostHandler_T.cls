/**
 *  Description     :  Test class used to test 'OOOFeedCommentPost' Trigger and 'OOOFeedCommentPostHandler' class 
 *
 *  Created By      :  Chirag Soni -CR - 00000166
 *
 *  Created Date    :  12/01/2021
 *
 *  Revision Logs   :   V_1.0 - Created 
**/


@isTest(SeeAllData=false)
private class OOOFeedCommentPostHandler_T {
    
    @isTest
    private static void TestAutoReplyForOutOfOfficeUsers()
    { 
        //-- Select profile to create a new user --//
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        //-- Create user who tag user in chatters and comments --//
        User CommentrEmp = new User(Alias = 'userFeed', 
                                    Email='standarduser@testorg.com', 
                                    EmailEncodingKey='UTF-8', 
                                    FirstName = 'Commentr',
                                    LastName='Emp',
                                    LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p.Id, 
                                    TimeZoneSidKey='America/Los_Angeles', 
                                    UserName='standarduser@invalid.com');
        insert CommentrEmp;
        
        //--  Create a user who automatically replay by using out of office record --//
        User OOOEmp = new User(Alias = 'userOOO', 
                               Email='standarduser@testorg.com', 
                               EmailEncodingKey='UTF-8', 
                               FirstName = 'OOO',
                               LastName='Emp', 
                               LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', 
                               UserName='oooEmp@testorg.invalid.com');
        insert OOOEmp; 
        
        //--  Create Out of office record for auto replay if any is tag respective user in chatter --//
        Out_of_Office__c outOfOffice = new Out_of_Office__c();
        outOfOffice.Name = 'OOO Emp';
        outOfOffice.Start_Date__c = Date.today();
        outOfOffice.End_Date__c = Date.today()+3;
        outOfOffice.Message__c = 'Hi I\'am out of office today'; 
        outOfOffice.OwnerId = OOOEmp.Id; 
        insert outOfOffice;
        
        //-- Create a chatter  by first user --//
        FeedItem chttrPost = new FeedItem();
        chttrPost.ParentId = CommentrEmp.Id ;
        chttrPost.Type = 'TextPost'; 
        chttrPost.Body = 'Hello every i\'am  gonna test Out of office now'; 
        insert chttrPost;
        
        // Add comment to above chatter post --//
        FeedComment chttrCmt = new FeedComment();
        chttrCmt.CommentType = 'TextComment';
        chttrCmt.CommentBody = 'Hi @OOO Emp can you look into it and replay?.'; 
        chttrCmt.FeedItemId =  chttrPost.Id;
        chttrCmt.CreatedById = CommentrEmp.Id; 
        insert chttrCmt;
        
        Test.startTest();
        
        //-- Select auto reply from user who is out of office now --//
        FeedComment rplyCmt = [SELECT CommentType, CreatedById, CommentBody, FeedItemId FROM FeedComment WHERE CreatedById = :OOOEmp.Id];
        System.assertEquals('Hi I\'am out of office today', rplyCmt.CommentBody);
        System.assertEquals(OOOEmp.Id, rplyCmt.CreatedById); 
        System.assertEquals('TextComment', rplyCmt.CommentType);
        System.assertEquals(chttrPost.Id, rplyCmt.FeedItemId); 
        
        //-- Update Last Comment and test again for auto replay -- //
        FeedComment updateComment = [SELECT CommentType, CommentBody, FeedItemId, CreatedById FROM FeedComment WHERE CreatedById = :CommentrEmp.Id] ;
        updateComment.CommentBody = 'Hi @OOO Emp can you update once again, wanna your test your rply in update case.'; 
        update updateComment; 
        
        //-- Select Most recent auto reply from user who is out of office now --//
        FeedComment rplyCmtUpdated = [SELECT CommentType, CreatedById, CommentBody, FeedItemId FROM FeedComment WHERE CreatedById = :OOOEmp.Id ORDER BY CreatedDate, ID DESC LIMIT 1];
        System.assertEquals('Hi I\'am out of office today', rplyCmtUpdated.CommentBody);
        System.assertEquals(OOOEmp.Id, rplyCmtUpdated.CreatedById); 
        System.assertEquals('TextComment', rplyCmtUpdated.CommentType);
        System.assertEquals(chttrPost.Id, rplyCmtUpdated.FeedItemId);  
        
        Test.stopTest(); 
    }
}