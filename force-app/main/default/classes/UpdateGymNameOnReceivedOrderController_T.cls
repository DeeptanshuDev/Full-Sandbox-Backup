//Test class to programatically test out Batch_UpdateGymNameOnReceivedOrder job associated positive and negative use case from listview button
@isTest(SeeAllData=false)
public class UpdateGymNameOnReceivedOrderController_T 
{
    //Test Method to test out positive use cases
    @isTest static void testPositiveUseCases()
    {
        ApexPages.StandardSetController std;
        UpdateGymNameOnReceivedOrderController updateGymName = new UpdateGymNameOnReceivedOrderController(std);
        UpdateGymNameOnReceivedOrderController.isClassic = true;
        Test.startTest();
        updateGymName.callBatch();
        Test.stopTest();
    }
    //Test Method to test out nagative use cases
    @isTest static void testNagativeUseCases()
    {
        ApexPages.StandardSetController std;
        UpdateGymNameOnReceivedOrderController updateGymName = new UpdateGymNameOnReceivedOrderController(std);
        UpdateGymNameOnReceivedOrderController.isLightning = true;
        
        Test.startTest();
        updateGymName.callBatch();
        Test.stopTest();
    }
}