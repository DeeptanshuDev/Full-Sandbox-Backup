@isTest
private class CreateErrorLogsAndEmailCSV_T {
    
    @testSetup
    private static void setup() {
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name = :ProfileConstants.REBEL_SALES_USER];
        User user = TestData.user(new User(ProfileId = salesProfile.Id, Email = 'Test@testing.com'), true);
        Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE DeveloperName = 'Error_Log_Receivers'];
        GroupMember gm = new GroupMember();
        gm.GroupId = g.id;
        gm.UserOrGroupId = user.Id;
        insert gm;
    }
    
    @isTest
    private static void CreateErrorLogsAndEmailCSVTest() {
        Test.startTest();
        CreateErrorLogsAndEmailCSV celes = new CreateErrorLogsAndEmailCSV();
        Test.stopTest();
    }
    
    @isTest
    private static void CreateErrorLogsAndEmailCSVScheduleTest() {
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        Test.startTest();
        String jobID = system.schedule('Testing CSV', CRON_EXP, new CreateErrorLogsAndEmailCSV_s());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        System.assertEquals(CRON_EXP,  ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));        
        Test.stopTest();
    }
    
}