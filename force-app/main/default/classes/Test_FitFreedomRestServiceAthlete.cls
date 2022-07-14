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
*  Description     :   Test class to test the functionality FitFreedomRestServiceAthlete apex class.
*            
*  Create By       :   Abhinav Sharma
*
*  Created Date    :   18-05-2020
*
*  Revision Log    :   V_1.0 - Created - Abhinav Sharma
*
*  Coverage        :   98%
*
**/

@isTest(seeAllData = false)
private with sharing class Test_FitFreedomRestServiceAthlete 
{
     //Create Athlete data
    static List<Contact> createContacts(){
                
        //Insert Contact record
        //List to hold Contact records
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(LastName = '001' , FirstName = 'Contact Demo ' , Email = 'contactdemo001@gmail.com' , gender__c = 'Male' , team_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8t4' , member_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8m3' , gym_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8g3' , Fit_Freedom_Type__c = 'Athlete'));
        contacts.add(new Contact(LastName = '002' , FirstName = 'Contact Demo ' , Email = 'contactdemo002@gmail.com' , gender__c = 'Female' , team_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8t5' , member_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8m4'));
        contacts.add(new Contact(LastName = '003' , FirstName = 'Contact Demo ' , Email = 'contactdemo003@gmail.com' , gender__c = 'Male' , team_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8t6' , member_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8m5'));
        insert contacts;
        return contacts;

    }

    //Get Atheletes by Id (check for no record found)
    static testMethod void test_GetAthleteFromSFDC()
    {

        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ATHLETE;
        request.httpMethod = 'GET';
        request.addParameter(Constants.HTTP_HEADER_ID, '');
        request.requestBody = Blob.valueof('');
        RestContext.request = request;

        FitFreedomRestServiceAthlete.AthleteResponseWrapper res = new FitFreedomRestServiceAthlete.AthleteResponseWrapper();
        
        Test.startTest();
        
		res = FitFreedomRestServiceAthlete.getAthleteFromSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('Please specify a id (athlete id) in request params.' , res.message);
        
        Test.stopTest();

    }
    
    //Get Atheletes by Id (Get Contacts)
    static testMethod void test_GetAthleteFromSFDC1()
    {
        //Create data
        List<Contact> contacts = createContacts();
                
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ATHLETE;
        request.httpMethod = 'GET';
        request.addParameter(Constants.HTTP_HEADER_ID, contacts[0].member_id__c);
        request.requestBody = Blob.valueof('');
        RestContext.request = request;

        FitFreedomRestServiceAthlete.AthleteResponseWrapper res = new FitFreedomRestServiceAthlete.AthleteResponseWrapper();
        
        Test.startTest();

		res = FitFreedomRestServiceAthlete.getAthleteFromSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals('Get Athlete Successful' , res.message);
        System.assertEquals(1 , res.athletes.size());
        
        request.addParameter(Constants.HTTP_HEADER_ID, 'newMember');
        request.requestBody = Blob.valueof('');
        RestContext.request = request;
        
        res = FitFreedomRestServiceAthlete.getAthleteFromSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('No athlete found for the specified id (athlete id)' , res.message);

        Test.stopTest();

    }
    
    //Add team member (Create Contact)
    static testMethod void test_AthletePostRequest()
    {
        //Create data
        createContacts();
        
        //Insert Account
        Account newAccount = new Account(Name = 'Account Demo 1' , gym_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8g3' , Type = 'All Star');
        insert newAccount;
        //Insert team
        Rosters__c rosters = new Rosters__c(rosters_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8t4', gym_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8g3', Name = 'Rosters Demo 001' , Account__c = newAccount.Id );
        insert rosters;
        
        //Insert team
        //Team__c newTeam = new Team__c(Name = 'Fusion All Star' , team_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8t4' , gym_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8g3');
        //insert newTeam;
        
        
                
        String reqBody = '';

        reqBody = '{"age":"1","first_name":"bertha","last_name":"Login","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3","gym_id":"b3284308-8a19-41dc-bb94-ee231039f8g3","email":"test@test.com"}';
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ATHLETE +  FitFreedomUrlMappings.ATHLETE_AT_ADD_TEAM_MEMBER + '/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;

        FitFreedomRestServiceAthlete.AthleteResponseWrapper res = new FitFreedomRestServiceAthlete.AthleteResponseWrapper();
        
        Test.startTest();

		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        
        
        //Error Handling
        reqBody = '{"age":"1","first_name":"bertha","last_name":"Login","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"","gym_id":"b3284308-8a19-41dc-bb94-ee231039f8g3","email":"test@test.com"}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please specify member_id for Athlete in the request body' , res.message);

        //Error Handling
        reqBody = '{"age":"1","first_name":"bertha","last_name":"Login","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3","gym_id":"","email":"test@test.com"}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please specify gym_id for Athlete in the request body' , res.message);
        
        //Error Handling
        reqBody = '{"age":"1","first_name":"bertha","last_name":"Login","gender":"Female","team_id":"","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3","gym_id":"b3284308-8a19-41dc-bb94-ee231039f8g3","email":"test@test.com"}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please specify team_id for Athlete in the request body' , res.message);
        
        //Error Handling
        reqBody = '{"age":"1","first_name":"bertha","last_name":"","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3","gym_id":"b3284308-8a19-41dc-bb94-ee231039f8g3","email":"test@test.com"}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please specify last_name for Athlete in the request body' , res.message);

        //Error Handling
        reqBody = '{"age":"1","first_name":"bertha","last_name":"Login","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f824","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3","gym_id":"b3284308-8a19-41dc-bb94-ee231039f8g3","email":"test@test.com"}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('unable to find a team for the team_id that we have in the request body' , res.message);

        //Error Handling
        reqBody = '{"age":"1","first_name":"bertha","last_name":"Login","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3","gym_id":"b3284308-8a19-41dc-bb94-ee231039f823","email":"test@test.com"}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('unable to find a gym for the gym_id that we have in the request body' , res.message);
        
        //Error Handling
        request.requestBody = null;
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('Please provide the valid request body' , res.message);

        //Error Handling
        reqBody = '{"age":"1","first_name":"bertha",last_name":"Login","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3","gym_id":"b3284308-8a19-41dc-bb94-ee231039f823","email":"test@test.com"}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();

        Test.stopTest();

    }
    
    //Get Athletes By Team (Get Contact)
    static testMethod void test_AthletePostRequest1()
    {
        
        //Create data
        createContacts();
 
        String reqBody = '';

        reqBody = '{"team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4"}';
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ATHLETE+ FitFreedomUrlMappings.ATHLETE_AT_GET_ATHLETE_BY_TEAM_ID + '/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;

        FitFreedomRestServiceAthlete.AthleteResponseWrapper res = new FitFreedomRestServiceAthlete.AthleteResponseWrapper();
        
        Test.startTest();

		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals('Get Athlete By Team Succcessful' , res.message);
        System.assertEquals(1 , res.athletes.size());
        
        //Error handling
        reqBody = '{"team_id":""}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please specify team_id for Get Athlete in the request body' , res.message);

        //Error handling
        reqBody = '{"team_id":"b3284308-8a19-41dc-bb94-ee231039f824"}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('No athlete found for the specified team_id ' , res.message);
        
        //Error handling
        reqBody = '';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please have a valid request body for Get Athletes By Team request.' , res.message);

        Test.stopTest();

    }
    
    //Remove Athletes (Delete Contact)
    static testMethod void test_AthletePostRequest2()
    {
        
        //Create data
        createContacts();
 
        String reqBody = '';

        reqBody = '{"team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3"}';
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ATHLETE+ FitFreedomUrlMappings.ATHLETE_AT_REMOVE_ATHLETE + '/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;

        FitFreedomRestServiceAthlete.AthleteResponseWrapper res = new FitFreedomRestServiceAthlete.AthleteResponseWrapper();
        
         FitFreedomRestServiceAthlete.AthleteResponseWrapper res1 = new FitFreedomRestServiceAthlete.AthleteResponseWrapper();
        
        Test.startTest();

		res = FitFreedomRestServiceAthlete.athletePostRequest();
        
        res1= FitFreedomRestServiceAthlete.removeathlete(); 
        
        //Error handling part
        reqBody = '{"team_id":"b3284308-8a19-41dc-bb94-ee231039f24","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3"}';

        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        
        //Error handling part
        reqBody = '{"team_id":"","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3"}';

        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        
        //Error handling part
        reqBody = '{"team_id":"b3284308-8a19-41dc-bb94-ee231039f24","member_id":""}';

        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
       
        //Error handling part
        reqBody = '';

        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
       
        Test.stopTest();

    }
    
    //Create Coach Athletes (Create Contact)
    static testMethod void test_AthletePostRequest3()
    {
        
        //Create data
        createContacts();
 
        //Insert Account
        Account newAccount = new Account(Name = 'Account Demo 1' , gym_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8g3' , Type = 'All Star');
        insert newAccount;

        //Insert team
        Rosters__c rosters = new Rosters__c(rosters_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8t4', gym_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8g3', Name = 'Rosters Demo 001' , Account__c = newAccount.Id );
        insert rosters;
        
        String reqBody = '';

        reqBody = '{"age":"1","first_name":"bertha","last_name":"Login","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3","gym_id":"b3284308-8a19-41dc-bb94-ee231039f8g3","email":"test@test.com"}';
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ATHLETE+ FitFreedomUrlMappings.ATHLETE_AT_CREATE_COACH + '/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;

        FitFreedomRestServiceAthlete.AthleteResponseWrapper res = new FitFreedomRestServiceAthlete.AthleteResponseWrapper();
        
        Test.startTest();

		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                            + Constants.CHAR_SPACE + 'Create Coach Successful' , res.message);
        
        //Error Handling
        reqBody = '{"age":"1","first_name":"bertha","last_name":"Login","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"","gym_id":"b3284308-8a19-41dc-bb94-ee231039f8g3","email":"test@test.com"}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please specify member_id for Athlete in the request body' , res.message);

        //Error Handling
        reqBody = '{"age":"1","first_name":"bertha","last_name":"Login","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3","gym_id":"","email":"test@test.com"}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please specify gym_id for Athlete in the request body' , res.message);
        
        //Error Handling
        reqBody = '{"age":"1","first_name":"bertha","last_name":"","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3","gym_id":"b3284308-8a19-41dc-bb94-ee231039f8g3","email":"test@test.com"}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please specify last_name for Athlete in the request body' , res.message);
        
        //Error Handling
        reqBody = '{"age":"1","first_name":"bertha","last_name":"Login","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3","gym_id":"b3284308-8a19-41dc-bb94-ee231039f83","email":"test@test.com"}';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        
        //Error Handling
        reqBody = '';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        
        //Error Handling
        reqBody = '{"age":"1","first_name":"bertha","last_name":"Login","gender":"Female","team_id":"b3284308-8a19-41dc-bb94-ee231039f8t4","member_id":"b3284308-8a19-41dc-bb94-ee231039f8m3","gym_id":"b3284308-8a19-41dc-bb94-ee231039f8g3","email":"test@test.com"}';
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ATHLETE+ 'create-coacha/';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
		res = FitFreedomRestServiceAthlete.athletePostRequest();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
      
        Test.stopTest();

    }

}