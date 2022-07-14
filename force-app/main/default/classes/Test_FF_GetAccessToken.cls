/**
*  Description     :   Test class for FF_GetAccessToken.
*            
*  Create By       :   
*
*  Created Date    :   03-07-2020
*
*  Revision Log    :   V_1.0 - Created - 03-07-2020
*
*  Coverage        :   
*
**/

@isTest(seeAllData = false)
private class Test_FF_GetAccessToken
{
        
    @isTest
    private static void test_getAccessToken() 
    {
        //Insert Custom Setting data
        FF_Credentials__c ffCreds = new FF_Credentials__c();
        ffCreds.Endpoint__c = 'http://example.com/';
        ffCreds.User_Id__c = 'user@user.com';
        ffCreds.Password__c = 'user@123';
        insert ffCreds;
        
        //Setting Mock 
        FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
        Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
        mapMock.put('http://example.com/',accessTokenMock);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        //Start Test
        Test.startTest();
        
        FF_GetAccessToken.getAccessToken();
        
        Test.stopTest();
    }
}