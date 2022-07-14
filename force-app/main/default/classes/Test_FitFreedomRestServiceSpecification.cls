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
*  Description     :   Test class to test the functionality of FitFreedomRestServiceSpecification class.
*            
*  Create By       :   Abhinav Sharma
*
*  Created Date    :   19-05-2020
*
*  Revision Log    :   V_1.0 - Created - Abhinav Sharma
*
*  Coverage        :   93%
*
**/

@isTest(seeAllData = false)
private with sharing class Test_FitFreedomRestServiceSpecification
{
    
    //Create Specification data
    static void createSpecifications(){
        
        List<Specification__c> specifications = new List<Specification__c>();
        specifications.add(new Specification__c(Name = 'Test Specification 001' , defined_measures__c = '1.2' , active__c = '1' , finalized__c = 'A' , Created_at__c = String.valueOf(System.today()) , Spec_Id__c = 'SpecId3'));
        specifications.add(new Specification__c(Name = 'Test Specification 002' , defined_measures__c = '1.3' , active__c = '1' , finalized__c = 'A' , Created_at__c = String.valueOf(System.today())));
        specifications.add(new Specification__c(Name = 'Test Specification 003' , defined_measures__c = '1.4' , active__c = '1' , finalized__c = 'A' , Created_at__c = String.valueOf(System.today())));
        insert specifications;
    }
    
    //Get Specifications (check for no record found)
    static testMethod void test_GetSpecificationFromSFDC()
    {
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_SPECIFICATION;
        request.httpMethod = 'GET';
        request.requestBody = Blob.valueof('');
        RestContext.request = request;
        
        Test.startTest();
        
        FitFreedomRestServiceSpecification.SpecResponseWrapper res = new FitFreedomRestServiceSpecification.SpecResponseWrapper();
        res = FitFreedomRestServiceSpecification.getSpecificationFromSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('No specification found.' , res.message);
        System.assertEquals(0 , res.specifications.size());
        
        Test.stopTest();
        
    }
    
    //Get Specification (check for specification records)
    static testMethod void test_GetSpecificationFromSFDC1()
    {
        //Create data
        createSpecifications();
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_SPECIFICATION;
        request.httpMethod = 'GET';
        request.requestBody = Blob.valueof('');
        RestContext.request = request;
        
        Test.startTest();

        FitFreedomRestServiceSpecification.SpecResponseWrapper res = new FitFreedomRestServiceSpecification.SpecResponseWrapper();
        res = FitFreedomRestServiceSpecification.getSpecificationFromSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals('Get Specifications/Get all charts info' , res.message);
        System.assertEquals(3 , res.specifications.size());
        
        Test.stopTest();

    }
    
    //Insert Specification records (check for specification records successfully created)
    static testMethod void test_InsertSpecificationAtSFDC()
    {        
        //Create data
        createSpecifications();
        
        String reqBody = '';
        
        reqBody = '{ "name" : "TestSpec1", "defined_measures" : "1.2", "id":"SpecId3", "active":"1", "finalized":"A", "Created_at":"" }';
        
        List<Specification__c> getSpecifications = new List<Specification__c>();
        
        // Set up a test request
        RestRequest request = new RestRequest();
        
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_SPECIFICATION;
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(reqBody);
        RestContext.request = request;
        
        Test.startTest();

        FitFreedomRestServiceSpecification.SpecResponseWrapper res = new FitFreedomRestServiceSpecification.SpecResponseWrapper();
        res = FitFreedomRestServiceSpecification.insertSpecificationAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                            Constants.CHAR_SPACE + 'Specification Created Successful' , res.message);
        
        getSpecifications = [SELECT Id , Name FROM Specification__c ORDER BY Name];
        System.assertEquals(3 , getSpecifications.size());
        
        reqBody = '{ "name" : "TestSpec1", "defined_measures" : "1.2", "id":"SpecId4", "active":"1", "finalized":"A", "Created_at":"" }';

        request.requestBody = Blob.valueOf(reqBody);
        RestContext.request = request;

        res = FitFreedomRestServiceSpecification.insertSpecificationAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                            Constants.CHAR_SPACE + 'Specification Created Successful' , res.message);
        
        getSpecifications = [SELECT Id , Name FROM Specification__c ORDER BY Name];
        System.assertEquals(4 , getSpecifications.size());

        // Set up a test request
        request.requestBody = Blob.valueOf('');
        RestContext.request = request;
        
        res = FitFreedomRestServiceSpecification.insertSpecificationAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('Please provide the valid request body' , res.message);
        
        reqBody = '{ "name" : "TestSpec1", "defined_measures" : "1.2", "id":"", "active":"1", "finalized":"A", "Created_at":"" }';

        // Set up a test request
        request.requestBody = Blob.valueOf(reqBody);
        RestContext.request = request;
        
        res = FitFreedomRestServiceSpecification.insertSpecificationAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('Please Specify the spec_id in the request body' , res.message);
        
        reqBody = '{ "name" : "TestSpec1", "defined_measures" : "1.2", "id":"", "active":"1", "finalized":"A", "Created_at":"" , "Spec_Id__c" = "SpecId3" }';

        // Set up a test request
        request.requestBody = Blob.valueOf(reqBody);
        RestContext.request = request;
        
        res = FitFreedomRestServiceSpecification.insertSpecificationAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);

        // Set up a test request
        request.requestBody = null;
        RestContext.request = request;
        
        res = FitFreedomRestServiceSpecification.insertSpecificationAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('Please provide the valid request body' , res.message);

        Test.stopTest();
        
    }
    
    //Delete Specification record (check for specification records successfully deleted)
    static testMethod void test_DeleteSpecificationByIdInSFDC()
    {     
        
        //Create data
        createSpecifications();

        List<Specification__c> getSpecifications = new List<Specification__c>();

        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_SPECIFICATION;
        request.httpMethod = 'DEL';
        request.addParameter(Constants.HTTP_HEADER_ID, 'SpecId3');
        request.requestBody = Blob.valueOf('');
        RestContext.request = request;
        
        Test.startTest();

        FitFreedomRestServiceSpecification.SpecResponseWrapper res = new FitFreedomRestServiceSpecification.SpecResponseWrapper();
        res = FitFreedomRestServiceSpecification.deleteSpecificationByIdInSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals(Constants.HTTP_RESPONSE_SPECIFICATION_DELETE , res.message);
        
        getSpecifications = [SELECT Id , Name FROM Specification__c WHERE Deleted_From_FF__c = false ORDER BY Name];
        System.assertEquals(2 , getSpecifications.size());

        // Set up a test request
        request.addParameter(Constants.HTTP_HEADER_ID, 'SpecId4');
        request.requestBody = Blob.valueOf('');
        RestContext.request = request;
        
        res = FitFreedomRestServiceSpecification.deleteSpecificationByIdInSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('Unable to find specification to delete for the mentioned id.' , res.message);

        // Set up a test request
        request.addParameter(Constants.HTTP_HEADER_ID, '');
        request.requestBody = Blob.valueOf('');
        RestContext.request = request;
        
        res = FitFreedomRestServiceSpecification.deleteSpecificationByIdInSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('Please specify a id (spec id).' , res.message);
        
        Test.stopTest();
        
    }

}