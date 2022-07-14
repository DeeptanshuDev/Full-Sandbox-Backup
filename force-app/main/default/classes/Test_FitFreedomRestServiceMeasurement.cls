/**
*   Description     :   Apex Test class for FitFreedomRestServiceMeasurement . 
*
*   Created By      :   
*
*   Created Date    :   05/19/2020
* 
*   Version         :   v1.0 - Created - 05/19/2020
**/
@isTest
private class Test_FitFreedomRestServiceMeasurement
{
    //Valid Find All Measurement
    @isTest
    public static void valid_FindAllMeasurement()
    {
        //Creating Record
        createRecord('Msrt1', '111-msrt-111');
        createRecord('Msrt1', '222-msrt-222');
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(2, msrts.size());
        
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.getMeasurementFromSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(2, res.measurements.size());
		Test.stopTest();
    }
	
	//inValid Find All Measurement
    @isTest
    public static void invalid_NoRecordInserted_FindAllMeasurement()
    {
        //Creating Record
        //createRecord('Msrt1', '111-msrt-111');
        //createRecord('Msrt1', '222-msrt-222');
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(0, msrts.size());
        
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.getMeasurementFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
		Test.stopTest();
    }
	
	//inValid Find All Measurement
    @isTest
    public static void invalid_UpdatingDeleted_FindAllMeasurement()
    {
        //Creating Record
        createRecord('Msrt1', '111-msrt-111');
        createRecord('Msrt1', '222-msrt-222');
        List<Measurement__c> msrts = [SELECT ID, Deleted_From_FF__c FROM Measurement__c];
        System.assertEquals(2, msrts.size());
		for(Measurement__c ms : msrts)
		{
			ms.Deleted_From_FF__c = true;
		}
		update msrts;
        
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.getMeasurementFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
		Test.stopTest();
    }
    
    //Valid Find One Measurement
    @isTest
    public static void valid_FindOneMeasurement()
    {
        //Creating Record
        createRecord('Msrt1', '111-msrt-111');
        createRecord('Msrt1', '222-msrt-222');
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(2, msrts.size());
        
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, Constants.HTTP_PARAM_MEASUREMENT_ID, '111-msrt-111');
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.getMeasurementFromSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(1, res.measurements.size());
		Test.stopTest();
    } 

	//inValid Find One Measurement
    @isTest
    public static void invalid_NoRecordInserted_FindOneMeasurement()
    {
        //Creating Record
        //createRecord('Msrt1', '111-msrt-111');
        //createRecord('Msrt1', '222-msrt-222');
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(0, msrts.size());
        
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, Constants.HTTP_PARAM_MEASUREMENT_ID, '111-msrt-111');
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.getMeasurementFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
		Test.stopTest();
    }

	//inValid Find One Measurement
    @isTest
    public static void invalid_InvalidID_FindOneMeasurement()
    {
        //Creating Record
        createRecord('Msrt1', '111-msrt-111');
        createRecord('Msrt1', '222-msrt-222');
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(2, msrts.size());
        
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, Constants.HTTP_PARAM_MEASUREMENT_ID, '123-msrt-123');
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.getMeasurementFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
		Test.stopTest();
    }
	
	//inValid Find One Measurement
    @isTest
    public static void invalid_UpdatingDeleted_FindOneMeasurement()
    {
        //Creating Record
        createRecord('Msrt1', '111-msrt-111');
        createRecord('Msrt1', '222-msrt-222');
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(2, msrts.size());
        for(Measurement__c ms : msrts)
		{
			ms.Deleted_From_FF__c = true;
		}
		update msrts;
		
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, Constants.HTTP_PARAM_MEASUREMENT_ID, '111-msrt-111');
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.getMeasurementFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
		Test.stopTest();
    }
    
    //Valid Create Measurement
    @isTest
    public static void valid_CreateMeasurement()
    {
        //Inserting Record
        createValidRrcordForCreateMeasurementRequest();
            
        // Set up a test request
		Test.startTest();
        String body = '{"measure_id":"111-msrt-11","name":"Measurement1","person_height":"65","member_id":"111-mem-111","measured_sizes":"{leg:78}","y_values":"{leg:78:","team_id":"111-team-111","measured_by":"111-msby-111","active":"1","createdat":"","Modifiedat":""}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.insertMeasurementAtSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(0, res.measurements.size());
        
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(1, msrts.size());
		Test.stopTest();
    }
	
	//inValid Create Measurement
    @isTest
    public static void invalid_DuplicateMesurementId_CreateMeasurement()
    {
        //Inserting Record
		createRecord('Msrt1', '111-msrt-111');
        createValidRrcordForCreateMeasurementRequest();
            
        // Set up a test request
		Test.startTest();
        String body = '{"measure_id":"111-msrt-111","name":"Measurement1","person_height":"65","member_id":"111-mem-111","measured_sizes":"{leg:78}","y_values":"{leg:78:","team_id":"111-team-111","measured_by":"111-msby-111","active":"1","createdat":"","Modifiedat":""}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.insertMeasurementAtSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(0, res.measurements.size());
        
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(1, msrts.size());
		Test.stopTest();
    }
	
    //inValid Create Measurement
    @isTest
    public static void invalid_DuplicateMesurementIdDeleted_CreateMeasurement()
    {
        //Inserting Record
		createRecord('Msrt1', '111-msrt-111');
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(1, msrts.size());
        for(Measurement__c ms : msrts)
        {
            ms.Deleted_From_FF__c = true;
        }
        update msrts;
        createValidRrcordForCreateMeasurementRequest();

        // Set up a test request
		Test.startTest();
        String body = '{"measure_id":"111-msrt-111","name":"Measurement1","person_height":"65","member_id":"111-mem-111","measured_sizes":"{leg:78}","y_values":"{leg:78:","team_id":"111-team-111","measured_by":"111-msby-111","active":"1","createdat":"","Modifiedat":""}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.insertMeasurementAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
        
        List<Measurement__c> msrtsupdated = [SELECT ID FROM Measurement__c];
        System.assertEquals(1, msrtsupdated.size());
		Test.stopTest();
    }
    
	//inValid Create Measurement
    @isTest
    public static void invalid_Blankbody_CreateMeasurement()
    {
        //Inserting Record
        createValidRrcordForCreateMeasurementRequest();
            
        // Set up a test request
		Test.startTest();
        String body = '';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.insertMeasurementAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
        
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(0, msrts.size());
		Test.stopTest();
    }
	
	//inValid Create Measurement
    @isTest
    public static void invalid_NullBody_CreateMeasurement()
    {
        //Inserting Record
        createValidRrcordForCreateMeasurementRequest();
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(null, 'POST', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.insertMeasurementAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
        
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(0, msrts.size());
		Test.stopTest();
    }
	
	//inValid Create Measurement
    @isTest
    public static void invalid_BlankMeasueId_CreateMeasurement()
    {
        //Inserting Record
        createValidRrcordForCreateMeasurementRequest();
            
        // Set up a test request
		Test.startTest();
        String body = '{"measure_id":"","name":"Measurement1","person_height":"65","member_id":"111-mem-111","measured_sizes":"{leg:78}","y_values":"{leg:78:","team_id":"111-team-111","measured_by":"111-msby-111","active":"1","createdat":"","Modifiedat":""}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.insertMeasurementAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
        
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(0, msrts.size());
		Test.stopTest();
    }
	
	//inValid Create Measurement
    @isTest
    public static void invalid_BlankMemberId_CreateMeasurement()
    {
        //Inserting Record
        createValidRrcordForCreateMeasurementRequest();
            
        // Set up a test request
		Test.startTest();
        String body = '{"measure_id":"111-msrt-111","name":"Measurement1","person_height":"65","member_id":"","measured_sizes":"{leg:78}","y_values":"{leg:78:","team_id":"111-team-111","measured_by":"111-msby-111","active":"1","createdat":"","Modifiedat":""}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.insertMeasurementAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
        
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(0, msrts.size());
		Test.stopTest();
    }
	
	//inValid Create Measurement
    @isTest
    public static void invalid_BlankTeanId_CreateMeasurement()
    {
        //Inserting Record
        createValidRrcordForCreateMeasurementRequest();
            
        // Set up a test request
		Test.startTest();
        String body = '{"measure_id":"111-msrt-111","name":"Measurement1","person_height":"65","member_id":"111-mem-111","measured_sizes":"{leg:78}","y_values":"{leg:78:","team_id":"","measured_by":"111-msby-111","active":"1","createdat":"","Modifiedat":""}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.insertMeasurementAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
        
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(0, msrts.size());
		Test.stopTest();
    }
	
	//inValid Create Measurement
    @isTest
    public static void invalid_BlankMeasuredBy_CreateMeasurement()
    {
        //Inserting Record
        createValidRrcordForCreateMeasurementRequest();
            
        // Set up a test request
		Test.startTest();
        String body = '{"measure_id":"111-msrt-111","name":"Measurement1","person_height":"65","member_id":"111-mem-111","measured_sizes":"{leg:78}","y_values":"{leg:78:","team_id":"111-team-111","measured_by":"","active":"1","createdat":"","Modifiedat":""}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.insertMeasurementAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
        
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(0, msrts.size());
		Test.stopTest();
    }
	
	//inValid Create Measurement
    @isTest
    public static void invalid_InvalidMemberId_CreateMeasurement()
    {
        //Inserting Record
        createValidRrcordForCreateMeasurementRequest();
            
        // Set up a test request
		Test.startTest();
        String body = '{"measure_id":"111-msrt-111","name":"Measurement1","person_height":"65","member_id":"123-mem-123","measured_sizes":"{leg:78}","y_values":"{leg:78:","team_id":"111-team-111","measured_by":"111-msby-111","active":"1","createdat":"","Modifiedat":""}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.insertMeasurementAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
        
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(0, msrts.size());
		Test.stopTest();
    }
    
	//inValid Create Measurement
    @isTest
    public static void invalid_InvalidMeasuredBy_CreateMeasurement()
    {
        //Inserting Record
        createValidRrcordForCreateMeasurementRequest();
            
        // Set up a test request
		Test.startTest();
        String body = '{"measure_id":"111-msrt-111","name":"Measurement1","person_height":"65","member_id":"111-mem-111","measured_sizes":"{leg:78}","y_values":"{leg:78:","team_id":"111-team-111","measured_by":"123-msby-123","active":"1","createdat":"","Modifiedat":""}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.insertMeasurementAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
        
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(0, msrts.size());
		Test.stopTest();
    }
	
	//inValid Create Measurement
    @isTest
    public static void invalid_InvalidTeamID_CreateMeasurement()
    {
        //Inserting Record
        createValidRrcordForCreateMeasurementRequest();
            
        // Set up a test request
		Test.startTest();
        String body = '{"measure_id":"111-msrt-111","name":"Measurement1","person_height":"65","member_id":"111-mem-111","measured_sizes":"{leg:78}","y_values":"{leg:78:","team_id":"123-team-123","measured_by":"111-msby-111","active":"1","createdat":"","Modifiedat":""}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceMeasurement.MeasurementResponseWrapper res = new FitFreedomRestServiceMeasurement.MeasurementResponseWrapper();
        res = FitFreedomRestServiceMeasurement.insertMeasurementAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.measurements.size());
        
        List<Measurement__c> msrts = [SELECT ID FROM Measurement__c];
        System.assertEquals(0, msrts.size());
		Test.stopTest();
    }
	
    static RestRequest createRequest(String requestUrl, String method, String body, String paramKey, String paramValue)
    {
        RestRequest request = new RestRequest();
        if(requestUrl != null)
        {
           request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_MEASUREMENT + requestUrl; 
        }
        else
        {
            request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_MEASUREMENT; 
        }
        
        request.httpMethod = method.toUpperCase();
        
        if(body != null)
        {
            request.requestBody = Blob.valueof(body);
        }
        if(paramKey != null && paramValue != null)
        {
            request.addParameter(paramKey, paramValue);
        }
        return request;
    }
    
    static Id createRecord(String name,String extId)
    {
        Measurement__c record = new Measurement__c();
        record.name = name;
        record.measure_id__c = extId;
        insert record;
        return record.Id;
    }
    
    static void createValidRrcordForCreateMeasurementRequest()
    {
        List<Sobject> sobjs = new List<Sobject>();
        
        //Inserting Team (Opportunity)
        Sobject sobjTeam = new Rosters__c();
        sobjTeam.put('Name', 'Team1');
        sobjTeam.put('rosters_id__c', '111-team-111');
        sobjs.add(sobjTeam);
        
        //Inserting Contact (Measured By)
        Sobject sobjMsBy = new Contact();
        sobjMsBy.put('LastName', 'MsBy1');
        sobjMsBy.put('member_id__c', '111-msby-111');
        sobjs.add(sobjMsBy);
        
        //Inserting Contact (Member)
        Sobject sobjMem = new Contact();
        sobjMem.put('LastName', 'Memeber1');
        sobjMem.put('member_id__c', '111-mem-111');
        sobjs.add(sobjMem);
        
        insert sobjs;
    }
}