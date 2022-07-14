/**
*   Description     :   Apex Test class for FitFreedomRestServiceFit. 
*
*   Created By      :   
*
*   Created Date    :   05/18/2020
* 
*   Version         :   v1.0 - Created - 05/18/2020
**/
@isTest
public class Test_FitFreedomRestServiceFit
{
    //Get Requests
    /*
    //Valid Find All Fit
    @isTest
    public static void valid_FindAllFit()
    {
        //Creating Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createRecord('Fit2', '222-fit-222', '222-cat-222');
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(2, fits.size());
        
        // Set up a test request
        RestContext.request = createRequest(null, 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.getFitFromSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(2, res.fits.size());
    }
	
	//inValid Find All Fit
    @isTest
    public static void invalid_NoRecordInserted_FindAllFit()
    {
        //Creating Record
        //createRecord('Fit1', '111-fit-111', '111-cat-111');
        //createRecord('Fit2', '222-fit-222', '222-cat-222');
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(0, fits.size());
        
        // Set up a test request
        RestContext.request = createRequest(null, 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.getFitFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.fits.size());
    }
	
	//inValid Find All Fit
    @isTest
    public static void invalid_UpdatingDeleted_FindAllFit()
    {
        //Creating Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createRecord('Fit2', '222-fit-222', '222-cat-222');
        List<Fit__c> fits = [SELECT ID, Deleted_From_FF__c FROM Fit__c];
        System.assertEquals(2, fits.size());
		for(Fit__c fit : fits)
		{
			fit.Deleted_From_FF__c = true;
		}
		update fits;
        
        // Set up a test request
        RestContext.request = createRequest(null, 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.getFitFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.fits.size());
    }
    
    //Valid Find All Fits By Category
    @isTest
    public static void valid_FindFitByCategory()
    {
        //Creating Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createRecord('Fit2', '222-fit-222', '222-cat-222');
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(2, fits.size());
        
        // Set up a test request
        RestContext.request = createRequest(null, 'GET', null, Constants.HTTP_CATEGORY_ID, '111-cat-111');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.getFitFromSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(1, res.fits.size());
    } 
	
	//Valid Find All Fits By Category
    @isTest
    public static void valid_MultipleSameCatId_FindFitByCategory()
    {
        //Creating Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createRecord('Fit2', '222-fit-222', '111-cat-111');
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(2, fits.size());
        
        // Set up a test request
        RestContext.request = createRequest(null, 'GET', null, Constants.HTTP_CATEGORY_ID, '111-cat-111');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.getFitFromSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(2, res.fits.size());
    }

	//inValid Find All Fits By Category
    @isTest
    public static void invalid_NoRecordInserted_FindFitByCategory()
    {
        //Creating Record
        //createRecord('Fit1', '111-fit-111', '111-cat-111');
        //createRecord('Fit2', '222-fit-222', '222-cat-222');
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(0, fits.size());
        
        // Set up a test request
        RestContext.request = createRequest(null, 'GET', null, Constants.HTTP_CATEGORY_ID, '111-cat-111');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.getFitFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.fits.size());
    }

	//inValid Find All Fits By Category
    @isTest
    public static void invalid_InvalidID_FindFitByCategory()
    {
        //Creating Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createRecord('Fit2', '222-fit-222', '222-cat-222');
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(2, fits.size());
        
        // Set up a test request
        RestContext.request = createRequest(null, 'GET', null, Constants.HTTP_CATEGORY_ID, '123-cat-123');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.getFitFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.fits.size());
    }
	
	//inValid Find All Fits By Category
    @isTest
    public static void invalid_UpdatingDeleted_FindFitByCategory()
    {
        //Creating Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createRecord('Fit2', '222-fit-222', '222-cat-222');
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(2, fits.size());
        for(Fit__c fit : fits)
		{
			fit.Deleted_From_FF__c = true;
		}
		update fits;
		
        // Set up a test request
        RestContext.request = createRequest(null, 'GET', null, Constants.HTTP_CATEGORY_ID, '111-cat-111');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.getFitFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.fits.size());
    }
    */
	
    //Valid Update Fit
    @isTest
    public static void valid_UpdateFit()
    {
        //Inserting Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createValidRrcordForCreateRequest();
        
        List<Fit__c> fits = [SELECT category__c, specification__c, Edit__c FROM Fit__c];
        System.assertEquals(1, fits.size());
        System.assertEquals(null, fits[0].category__c);
        System.assertEquals(null, fits[0].specification__c);
        System.assertEquals(null, fits[0].Edit__c);
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"111-cat-111","spec_id":"111-spec-111","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'PUT', body, Constants.HTTP_FIT_ID, '111-fit-111');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.updateFITATSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        //System.assertEquals(0, res.fits.size());
        
        List<Fit__c> fitsUpdated = [SELECT category__c, specification__c, Edit__c FROM Fit__c];
        System.assertEquals(1, fitsUpdated.size());
        System.assertNotEquals(null, fitsUpdated[0].category__c);
        System.assertNotEquals(null, fitsUpdated[0].specification__c);
        System.assertNotEquals(null, fitsUpdated[0].Edit__c);
    }
	
     //inValid Update Fit
    @isTest
    public static void invalid_WrongFItIdInParam_UpdateFit()
    {
        //Inserting Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createValidRrcordForCreateRequest();
        
        List<Fit__c> fits = [SELECT category__c, specification__c, Edit__c FROM Fit__c];
        System.assertEquals(1, fits.size());
        System.assertEquals(null, fits[0].category__c);
        System.assertEquals(null, fits[0].specification__c);
        System.assertEquals(null, fits[0].Edit__c);
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"111-cat-111","spec_id":"111-spec-111","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'PUT', body, Constants.HTTP_FIT_ID, '123-fit-123');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.updateFITATSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        
        List<Fit__c> fitsUpdated = [SELECT category__c, specification__c, Edit__c FROM Fit__c];
        System.assertEquals(1, fitsUpdated.size());
        System.assertEquals(null, fitsUpdated[0].category__c);
        System.assertEquals(null, fitsUpdated[0].specification__c);
        System.assertEquals(null, fitsUpdated[0].Edit__c);
    }
	
	
	 //inValid Update Fit
    @isTest
    public static void invalid_BlankFItIdInParam_UpdateFit()
    {
        //Inserting Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createValidRrcordForCreateRequest();
        
        List<Fit__c> fits = [SELECT category__c, specification__c, Edit__c FROM Fit__c];
        System.assertEquals(1, fits.size());
        System.assertEquals(null, fits[0].category__c);
        System.assertEquals(null, fits[0].specification__c);
        System.assertEquals(null, fits[0].Edit__c);
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"111-cat-111","spec_id":"111-spec-111","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'PUT', body, Constants.HTTP_FIT_ID, '');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.updateFITATSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        
        List<Fit__c> fitsUpdated = [SELECT category__c, specification__c, Edit__c FROM Fit__c];
        System.assertEquals(1, fitsUpdated.size());
        System.assertEquals(null, fitsUpdated[0].category__c);
        System.assertEquals(null, fitsUpdated[0].specification__c);
        System.assertEquals(null, fitsUpdated[0].Edit__c);
    }
	
	 //inValid Update Fit
    @isTest
    public static void invalid_WrongParam_UpdateFit()
    {
        //Inserting Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createValidRrcordForCreateRequest();
        
        List<Fit__c> fits = [SELECT category__c, specification__c, Edit__c FROM Fit__c];
        System.assertEquals(1, fits.size());
        System.assertEquals(null, fits[0].category__c);
        System.assertEquals(null, fits[0].specification__c);
        System.assertEquals(null, fits[0].Edit__c);
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"111-cat-111","spec_id":"111-spec-111","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'PUT', body, 'xyz', '111-fit-111');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.updateFITATSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        
        List<Fit__c> fitsUpdated = [SELECT category__c, specification__c, Edit__c FROM Fit__c];
        System.assertEquals(1, fitsUpdated.size());
        System.assertEquals(null, fitsUpdated[0].category__c);
        System.assertEquals(null, fitsUpdated[0].specification__c);
        System.assertEquals(null, fitsUpdated[0].Edit__c);
    }
	
	 //inValid Update Fit
    @isTest
    public static void invalid_nullBody_UpdateFit()
    {
        //Inserting Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createValidRrcordForCreateRequest();
        
        List<Fit__c> fits = [SELECT category__c, specification__c, Edit__c FROM Fit__c];
        System.assertEquals(1, fits.size());
        System.assertEquals(null, fits[0].category__c);
        System.assertEquals(null, fits[0].specification__c);
        System.assertEquals(null, fits[0].Edit__c);
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"111-cat-111","spec_id":"111-spec-111","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'PUT', null, Constants.HTTP_FIT_ID, '111-fit-111');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.updateFITATSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        
        List<Fit__c> fitsUpdated = [SELECT category__c, specification__c, Edit__c FROM Fit__c];
        System.assertEquals(1, fitsUpdated.size());
        System.assertEquals(null, fitsUpdated[0].category__c);
        System.assertEquals(null, fitsUpdated[0].specification__c);
        System.assertEquals(null, fitsUpdated[0].Edit__c);
    }
	
	 //inValid Update Fit
    @isTest
    public static void invalid_coverCatchBlock_UpdateFit()
    {
        //Inserting Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createValidRrcordForCreateRequest();
        
        List<Fit__c> fits = [SELECT category__c, specification__c, Edit__c FROM Fit__c];
        System.assertEquals(1, fits.size());
        System.assertEquals(null, fits[0].category__c);
        System.assertEquals(null, fits[0].specification__c);
        System.assertEquals(null, fits[0].Edit__c);
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111category_id":"111-cat-111","spec_id":"111-spec-111","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'PUT', body, Constants.HTTP_FIT_ID, '111-fit-111');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.updateFITATSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        
        List<Fit__c> fitsUpdated = [SELECT category__c, specification__c, Edit__c FROM Fit__c];
        System.assertEquals(1, fitsUpdated.size());
        System.assertEquals(null, fitsUpdated[0].category__c);
        System.assertEquals(null, fitsUpdated[0].specification__c);
        System.assertEquals(null, fitsUpdated[0].Edit__c);
    }
    
    //Create Requests
    //Valid Create Fit
    @isTest
    public static void valid_CreateFit()
    {
        //Inserting Record
        createValidRrcordForCreateRequest();
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"111-cat-111","spec_id":"111-spec-111","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.insertFitAtSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        //System.assertEquals(0, res.fits.size());
        
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(1, fits.size());
    }
	
	//inValid Create Fit
    @isTest
    public static void invalid_DupLicateId_CreateFit()
    {
        //Inserting Record
		createRecord('Fit1', '111-fit-111', '111-cat-111');
        createValidRrcordForCreateRequest();
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"111-cat-111","spec_id":"111-spec-111","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.insertFitAtSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        //System.assertEquals(0, res.fits.size());
        
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(1, fits.size());
    }
	
	//inValid Create Fit
    @isTest
    public static void invalid_DupLicateIdDeleted_CreateFit()
    {
        //Inserting Record
		createRecord('Fit1', '111-fit-111', '111-cat-111');
		List<Fit__c> fits1 = [SELECT ID FROM Fit__c];
		System.assertEquals(1, fits1.size());
		fits1[0].Deleted_From_FF__c = true;
		update fits1;
        createValidRrcordForCreateRequest();
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"111-cat-111","spec_id":"111-spec-111","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.insertFitAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        //System.assertEquals(0, res.fits.size());
        
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(1, fits.size());
    }
	
	//inValid Create Fit
    @isTest
    public static void invalid_BlankBody_CreateFit()
    {
        //Inserting Record
        createValidRrcordForCreateRequest();
            
        // Set up a test request
        String body = '';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.insertFitAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        //System.assertEquals(0, res.fits.size());
        
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(0, fits.size());
    }
	
	//inValid Create Fit
    @isTest
    public static void invalid_NullBody_CreateFit()
    {
        //Inserting Record
        createValidRrcordForCreateRequest();
            
        // Set up a test request
        RestContext.request = createRequest(null, 'POST', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.insertFitAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        //System.assertEquals(0, res.fits.size());
        
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(0, fits.size());
    }
	
	//inValid Create Fit
    @isTest
    public static void invalid_BlankFitId_CreateFit()
    {
        //Inserting Record
        createValidRrcordForCreateRequest();
            
        // Set up a test request
        String body = '{"fit_id":"","category_id":"111-cat-111","spec_id":"111-spec-111","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.insertFitAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        //System.assertEquals(0, res.fits.size());
        
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(0, fits.size());
    }
	
	//inValid Create Fit
    @isTest
    public static void invalid_BlankCatId_CreateFit()
    {
        //Inserting Record
        createValidRrcordForCreateRequest();
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"","spec_id":"111-spec-111","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.insertFitAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        //System.assertEquals(0, res.fits.size());
        
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(0, fits.size());
    }

	//inValid Create Fit
    @isTest
    public static void invalid_BlankSpecId_CreateFit()
    {
        //Inserting Record
        createValidRrcordForCreateRequest();
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"111-cat-111","spec_id":"","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.insertFitAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        //System.assertEquals(0, res.fits.size());
        
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(0, fits.size());
    }
	
	//inValid Create Fit
    @isTest
    public static void invalid_BlankEditId_CreateFit()
    {
        //Inserting Record
        createValidRrcordForCreateRequest();
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"111-cat-111","spec_id":"111-spec-111","edit_id":"","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.insertFitAtSFDC();
       
    }
	
	//inValid Create Fit
    @isTest
    public static void invalid_InValidCatId_CreateFit()
    {
        //Inserting Record
        createValidRrcordForCreateRequest();
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"123-cat-123","spec_id":"111-spec-111","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.insertFitAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        //System.assertEquals(0, res.fits.size());
        
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(0, fits.size());
    }
	
    /*
     * This use case is not required for now
	//inValid Create Fit
    @isTest
    public static void invalid_InValidSpecId_CreateFit()
    {
        //Inserting Record
        createValidRrcordForCreateRequest();
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"111-cat-111","spec_id":"123-spec-123","edit_id":"111-edit-111","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.insertFitAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        //System.assertEquals(0, res.fits.size());
        
        List<Fit__c> fits = [SELECT ID FROM Fit__c];
        System.assertEquals(0, fits.size());
    }
	*/
	//inValid Create Fit
    @isTest
    public static void invalid_InValidEditId_CreateFit()
    {
        //Inserting Record
        createValidRrcordForCreateRequest();
            
        // Set up a test request
        String body = '{"fit_id":"111-fit-111","category_id":"111-cat-111","spec_id":"111-spec-111","edit_id":"123-edit-123","created_by":"111-crtby-111","Name":"U110GirlsConversionBiketard","fit_desc":"Desc-1","fit_number":"01245","conditions_apply":"1","fabric":"cotton","fit_image":"Img-1","is_Deleted":"0","lining":"1","modified_at":"1.02.123","created_at":"02.13.12"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.insertFitAtSFDC();
        
        
    }
    
    
    //Delete Requests
    /*
    //Valid Delete Fit
    @isTest
    public static void valid_DeleteFit()
    {
        //Creating Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createRecord('Fit2', '222-fit-222', '222-cat-222');
        List<Fit__c> fits = [SELECT ID FROM Fit__c WHERE Deleted_From_FF__c = false];
        System.assertEquals(2, fits.size());
        
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.FIT_AT_DELETE_FIT_BY_ID, 'DELETE', null, Constants.HTTP_FIT_ID, '111-fit-111');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.deleteFitByIdInSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        List<Fit__c> newFits = [SELECT ID FROM Fit__c WHERE Deleted_From_FF__c = true];
        System.assertEquals(1, newFits.size());
    }
    
    //inValid Delete Fit
    @isTest
    public static void invalid_inValidId_DeleteFit()
    {
        //Creating Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createRecord('Fit2', '222-fit-222', '222-cat-222');
        List<Fit__c> fits = [SELECT ID FROM Fit__c WHERE Deleted_From_FF__c = false];
        System.assertEquals(2, fits.size());
        
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.FIT_AT_DELETE_FIT_BY_ID, 'DELETE', null, Constants.HTTP_FIT_ID, '123-fit-123');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.deleteFitByIdInSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        List<Fit__c> newFits = [SELECT ID FROM Fit__c WHERE Deleted_From_FF__c = false];
        System.assertEquals(2, newFits.size());
    }
    
    
    //inValid Delete Fit
    @isTest
    public static void invalid_noParam_DeleteFit()
    {
        //Creating Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createRecord('Fit2', '222-fit-222', '222-cat-222');
        List<Fit__c> fits = [SELECT ID FROM Fit__c WHERE Deleted_From_FF__c = false];
        System.assertEquals(2, fits.size());
        
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.FIT_AT_DELETE_FIT_BY_ID, 'DELETE', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.deleteFitByIdInSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        List<Fit__c> newFits = [SELECT ID FROM Fit__c WHERE Deleted_From_FF__c = false];
        System.assertEquals(2, newFits.size());
    }
    
    //inValid Delete Fit
    @isTest
    public static void invalid_wrongActionType_DeleteFit()
    {
        //Creating Record
        createRecord('Fit1', '111-fit-111', '111-cat-111');
        createRecord('Fit2', '222-fit-222', '222-cat-222');
        List<Fit__c> fits = [SELECT ID FROM Fit__c WHERE Deleted_From_FF__c = false];
        System.assertEquals(2, fits.size());
        
        // Set up a test request
        RestContext.request = createRequest('xyz', 'DELETE', null, Constants.HTTP_FIT_ID, '111-fit-111');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.deleteFitByIdInSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        List<Fit__c> newFits = [SELECT ID FROM Fit__c WHERE Deleted_From_FF__c = false];
        System.assertEquals(2, newFits.size());
    }
    
    //inValid Delete Fit
    @isTest
    public static void invalid_NoRecordInserted_DeleteFit()
    {
        
        
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.FIT_AT_DELETE_FIT_BY_ID, 'DELETE', null, Constants.HTTP_FIT_ID, '111-fit-111');
        
        //Calling Method
        FitFreedomRestServiceFit.FitResponseWrapper res = new FitFreedomRestServiceFit.FitResponseWrapper();
        res = FitFreedomRestServiceFit.deleteFitByIdInSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        
    }
	*/
    
    static RestRequest createRequest(String requestUrl, String method, String body, String paramKey, String paramValue)
    {
        RestRequest request = new RestRequest();
        if(requestUrl != null)
        {
           request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_FIT + requestUrl + '/'; 
        }
        else
        {
            request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_FIT; 
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
    
    static Id createRecord(String name,String extId, String catId)
    {
        Fit__c record = new Fit__c();
        record.name = name;
        record.categories_id__c = catId;
        record.fit_id__c = extId;
        insert record;
        return record.Id;
    }
    
    static void createValidRrcordForCreateRequest()
    {
        List<Sobject> sobjs = new List<Sobject>();
        Sobject sobjcat = new Category__c();
        sobjcat.put('Name', 'Cat1');
        sobjcat.put('category_id__c', '111-cat-111');
        sobjs.add(sobjcat);
        
        Sobject sobjEdit = new Edit__c();
        sobjEdit.put('Name', 'Edit1');
        sobjEdit.put('edit_id__c', '111-edit-111');
        sobjs.add(sobjEdit);
        
        Sobject sobjSpec = new Specification__c();
        sobjSpec.put('Name', 'Memeber1');
        sobjSpec.put('spec_id__c', '111-spec-111');
        sobjs.add(sobjSpec);
        
        insert sobjs;
    }
}