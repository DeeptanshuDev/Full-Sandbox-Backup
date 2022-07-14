/**
*	Description		:	Apex Test class for FitFreedomRestServiceGym. 
*
*	Created By		:   
*
*	Created Date	:   05/18/2020
* 
*	Version			:   v1.0 - Created - 05/18/2020
**/
@isTest
private class Test_FitFreedomRestServiceEdit
{

    //Vaild Get All Edits
    @isTest
    static void vaild_GetAllEdits()
    {
        createEdit('Edit1', '111-edit-111');
        createEdit('Edit2', '222-edit-222');
        List<Edit__c> edits = [SELECT ID, Deleted_From_FF__c FROM Edit__c WHERE Deleted_From_FF__c = false];
        System.assert(edits.size() == 2);
        
        // Set up test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, null, null);
        
        FitFreedomRestServiceEdit.EditResonseWrapper res = new FitFreedomRestServiceEdit.EditResonseWrapper();
        res = FitFreedomRestServiceEdit.getEditFromSFDC();
        
        //Asserts
        System.assertEquals(200, res.statusCode);
        System.assertEquals(2, res.edits.size());
        List<Edit__c> editsUpdated = [SELECT ID, Deleted_From_FF__c FROM Edit__c WHERE Deleted_From_FF__c = false];
        System.assert(editsUpdated.size() == 2);
        Test.stopTest();
    }
    
    //inVaild Get All Edits
    @isTest
    static void invaild_1Deleted_GetAllEdits()
    {
        createEdit('Edit1', '111-edit-111');
        createEdit('Edit2', '222-edit-222');
        List<Edit__c> edits = [SELECT ID, Deleted_From_FF__c FROM Edit__c WHERE Deleted_From_FF__c = false];
        System.assert(edits.size() == 2);
        
        edits[0].Deleted_From_FF__c = true;
        update edits;
        
        // Set up test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, null, null);
        
        FitFreedomRestServiceEdit.EditResonseWrapper res = new FitFreedomRestServiceEdit.EditResonseWrapper();
        res = FitFreedomRestServiceEdit.getEditFromSFDC();
        
        //Asserts
        System.assertEquals(200, res.statusCode);
        System.assertEquals(1, res.edits.size());
        List<Edit__c> editsUpdated = [SELECT ID, Deleted_From_FF__c FROM Edit__c WHERE Deleted_From_FF__c = false];
        System.assert(editsUpdated.size() == 1);
        Test.stopTest();
    }
    
    //inVaild Get All Edits
    @isTest
    static void invaild_AllDeleted_GetAllEdits()
    {
        createEdit('Edit1', '111-edit-111');
        createEdit('Edit2', '222-edit-222');
        
        List<Edit__c> edits = [SELECT ID, Deleted_From_FF__c FROM Edit__c WHERE Deleted_From_FF__c = false ];
        System.assert(edits.size() == 2);
        
        edits[0].Deleted_From_FF__c = true;
        edits[1].Deleted_From_FF__c = true;
        update edits;
        
        // Set up test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, null, null);
        
        FitFreedomRestServiceEdit.EditResonseWrapper res = new FitFreedomRestServiceEdit.EditResonseWrapper();
        res = FitFreedomRestServiceEdit.getEditFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statusCode);
        
        List<Edit__c> editsAfterDel = [SELECT Deleted_From_FF__c FROM Edit__c ];
        System.assert(editsAfterDel.size() == 2);
        for(Edit__c ed : editsAfterDel)
        {
            System.assert(ed.Deleted_From_FF__c == true);
        }
        Test.stopTest();
    }
    
    //inVaild Get All Edits
    @isTest
    static void invaild_noDataInserted_GetAllEdits()
    {
        // Set up test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, null, null);
        
        FitFreedomRestServiceEdit.EditResonseWrapper res = new FitFreedomRestServiceEdit.EditResonseWrapper();
        res = FitFreedomRestServiceEdit.getEditFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statusCode);
        
        List<Edit__c> editsAfterDel = [SELECT Deleted_From_FF__c FROM Edit__c ];
        System.assert(editsAfterDel.size() == 0);
        Test.stopTest();
    }
    
    
    
    static RestRequest createRequest(String requestUrl, String method, String body, String paramKey, String paramValue)
    {
        RestRequest request = new RestRequest();
        if(requestUrl != null)
        {
           request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_EDIT + requestUrl; 
        }
        else
        {
            request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_EDIT; 
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
    
    static Id createEdit(String name,String extId)
    {
        Edit__c ed = new Edit__c();
        ed.name = name;
        ed.edit_id__c = extId;
        insert ed;
        return ed.Id;
    }
}