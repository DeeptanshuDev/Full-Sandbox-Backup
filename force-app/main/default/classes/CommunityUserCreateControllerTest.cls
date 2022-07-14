//Test class to programatically test out Batch_CreateCommunityUsers job associated positive and negative use case from listview button
@isTest(SeeAllData=false)
public class CommunityUserCreateControllerTest 
{
    //Test Method to test out positive use cases
    @isTest static void testPositiveUseCases()
    {
        ApexPages.StandardSetController acon;
        CommunityUserCreateController communityUserController = new CommunityUserCreateController(acon);
        CommunityUserCreateController.isClassic = true;
        
        Test.startTest();
        communityUserController.callBatchToCreateCommunityUser();
        Test.stopTest();
    }
    //Test Method to test out nagative use cases
    @isTest static void testNagativeUseCases()
    {
        ApexPages.StandardSetController acon;
        CommunityUserCreateController communityUserController = new CommunityUserCreateController(acon);
        CommunityUserCreateController.isLightning = true;
        
        Test.startTest();
        communityUserController.callBatchToCreateCommunityUser();
        Test.stopTest();
    }
}