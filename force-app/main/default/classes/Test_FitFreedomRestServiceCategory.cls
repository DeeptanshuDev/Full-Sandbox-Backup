/** 
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/

/**
*  Description     :   Test class to test the functionality rest service category.
*            
*  Create By       :   Abhinav Sharma
*
*  Created Date    :   18-05-2020
*
*  Revision Log    :   V_1.0 - Created - Abhinav Sharma
*
*  Coverage        :   91%
*
**/

@isTest(seeAllData = false)
private with sharing class Test_FitFreedomRestServiceCategory {
    
    //Create category data
    static void createData(){
        
        List<Category__c> categories = new List<Category__c>();
        categories.add(new Category__c(Name = 'Warmup Tops' , category_type__c = 'tops' , sort__c = '140' , created_at__c = String.valueOf(System.today()) , modified_at__c = String.valueOf(System.today())));
        categories.add(new Category__c(Name = 'Practice Wear Bottoms' , category_type__c = 'bottoms' , sort__c = '90' , created_at__c = String.valueOf(System.today()) , modified_at__c = String.valueOf(System.today())));
        categories.add(new Category__c(Name = 'Warmup Bottoms' , category_type__c = 'tops' , sort__c = '150' , created_at__c = String.valueOf(System.today()) , modified_at__c = String.valueOf(System.today())));
		insert categories;
    }

    //Get Category get request (check for no record found)
    static testMethod void test_GetCategoryFromSFDC()
    {
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_CATEGORY;
        request.httpMethod = 'GET';
        request.requestBody = Blob.valueof('');
        RestContext.request = request;

        FitFreedomRestServiceCategory.CategoryResonseWrapper res = new FitFreedomRestServiceCategory.CategoryResonseWrapper();
		res = FitFreedomRestServiceCategory.getCategoryFromSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('No category found.' , res.message);
        System.assertEquals(0 , res.categories.size());

    }
    
    //Get Category get request (check for categories records)
    static testMethod void test_GetCategoryFromSFDC1()
    {
        //Create data
        createData();
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_CATEGORY;
        request.httpMethod = 'GET';
        request.requestBody = Blob.valueof('');
        RestContext.request = request;

        Test.startTest();
        
        FitFreedomRestServiceCategory.CategoryResonseWrapper res = new FitFreedomRestServiceCategory.CategoryResonseWrapper();
		res = FitFreedomRestServiceCategory.getCategoryFromSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals('Get Category Successful' , res.message);
        System.assertEquals(3 , res.categories.size());
        
        Test.stopTest();

    }
}