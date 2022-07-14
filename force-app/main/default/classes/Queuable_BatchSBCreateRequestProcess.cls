/**
*  Description     :   Queuable job which run for create sandbox and hit sandboxProcess query records and 
*					   check if a sandbox created request got completed or not.
*
*  Created By      :   Abhinav Sharma
*
*  Created Date    :   02/20/2020
*
*  Current Version :   v1.0
*       
*  Revision Log    :   V_1.0 Created               
**/
global class Queuable_BatchSBCreateRequestProcess implements Queueable, Database.AllowsCallouts 
{
    //List of wrapper that is having SB create request related and record related details
    global List<SandboxCreateWrapper> listOfSandboxCreateResultsWrapper;
    
    public Queuable_BatchSBCreateRequestProcess(List<SandboxCreateWrapper> listOfSandboxCreateResultsWrapper) 
    {
        this.listOfSandboxCreateResultsWrapper = listOfSandboxCreateResultsWrapper;
    }
    
    public void execute(QueueableContext context) 
    {
        if(listOfSandboxCreateResultsWrapper != null && listOfSandboxCreateResultsWrapper.size() > 0) 
        {	
            HttpResponse response = HTTPCalloutUtilities.querySandboxProcessDetails(listOfSandboxCreateResultsWrapper);
            
            if(response != null && Constants.setOfSBCreateSuccessCodes.contains(response.getStatusCode())) 
            {
                SandboxProcessWrapper sBProcWrapper = (SandboxProcessWrapper) System.JSON.deserialize(response.getBody(),
                                                                                                      SandboxProcessWrapper.class);
                
                if(sBProcWrapper != null && sBProcWrapper.records != null  && sBProcWrapper.records.size() > 0) 
                {
                    Boolean scheduleNext = updateCreateSandboxRequestRelatedRecords(sBProcWrapper,listOfSandboxCreateResultsWrapper);
                    
                    if(scheduleNext) 
                    {
                        Scheduler_BatchCreateSBRequestProcess.scheduleAfterMinutes(2, false, listOfSandboxCreateResultsWrapper,true);
                    } 
                    else 
                    {
                        //Send the email to Users who requested the SB creation.//Email Handler
                    }
                }
            }
            /*else 
            {
                throw new customException(System.Label.Tracking_SB_Creation_Error_Message + response);    
            }*/
        }
    }
    
    public static Boolean updateCreateSandboxRequestRelatedRecords(SandboxProcessWrapper sBProcWrapper,
                                                                   List<SandboxCreateWrapper> listOfSandboxCreateResultsWrapper
                                                                  )
    {
        Boolean scheduleNext = false;
        Map<Id,SandboxCreateWrapper> mapOfIdWithSBCreateResWrapper = new Map<Id,SandboxCreateWrapper>();
        Map<Id,SandboxProcessWrapper.Records> mapOfSBInfoIdWithSBProcessWrapper = new Map<Id,SandboxProcessWrapper.Records>();
        
        for(SandboxCreateWrapper sBCreateWrap : listOfSandboxCreateResultsWrapper)
        {
            if(sBCreateWrap.cSRequest != null && String.isNotBlank(sBCreateWrap.cSRequest.SandboxInfo_Id__c))
            {
                mapOfIdWithSBCreateResWrapper.put(sBCreateWrap.cSRequest.SandboxInfo_Id__c,sBCreateWrap);
            }
        }
        
        if(sBProcWrapper != null && sBProcWrapper.records != null  && sBProcWrapper.records.size() > 0)
        {
            Set<Id> setOfCreateSBRequestIds = new Set<Id>();
            List<Create_Sandbox_Request__c> createSBRequestListToBeUpdated = new List<Create_Sandbox_Request__c>();
            
            for(SandboxProcessWrapper.Records sBPRocRecords : sBProcWrapper.records)
            {
                if(sBPRocRecords.Status.equalsIgnoreCase(Constants.SB_STATUS))
                {
                    mapOfSBInfoIdWithSBProcessWrapper.put(sBPRocRecords.SandboxInfoId,sBPRocRecords);
                    setOfCreateSBRequestIds.add(sBPRocRecords.SandboxInfoId);    
                }
                else
                {
                    scheduleNext = true;
                }
            }
            if(setOfCreateSBRequestIds.size() > 0)
            {	
                for(Create_Sandbox_Request__c cSBReq : [Select Id, Sandbox_Id__c, SandboxInfo_Id__c, Status__c, Selected_Account__c,Was_Picked_Alredy__c, 
                                                        CreatedById, CreatedBy.Email 
                                                        FROM Create_Sandbox_Request__c 
                                                        WHERE SandboxInfo_Id__c IN : setOfCreateSBRequestIds]) 
                {	
                    if(String.isNotBlank(cSBReq.Selected_Account__c))
                    {
                        cSBReq.Status__c = System.Label.Sandbox_Created_No_Data_Needed;
                    }
                    else
                    {
                        cSBReq.Status__c = System.Label.Sandbox_Created_Awaiting_Data;
                    } 
                    
                    /*SB Organization Id Populations*/
                    if(mapOfSBInfoIdWithSBProcessWrapper!= null 
                       && mapOfSBInfoIdWithSBProcessWrapper.containsKey(cSBReq.SandboxInfo_Id__c))
                        cSBReq.Sandbox_Id__c = mapOfSBInfoIdWithSBProcessWrapper.get(cSBReq.SandboxInfo_Id__c).SandboxOrganization;       
                    
                    cSBReq.Last_Time_Successfully_Completed__c = system.now();
                    cSBReq.Was_Picked_Alredy__c = true;
                    
                    createSBRequestListToBeUpdated.add(cSBReq);
                }
                
                if(createSBRequestListToBeUpdated.size() > 0)
                {
                    Util.BypassAllTriggers = true;
                    List<Database.SaveResult> updateResult = Database.update(createSBRequestListToBeUpdated, false);
                    List<Create_Sandbox_Request__c> listToUpdateResultSBResult = new List<Create_Sandbox_Request__c>();
                    for (Database.SaveResult result : updateResult) 
                    {
                        if (!result.isSuccess())
                        {
                            for (Database.Error err : result.getErrors())
                            {
                                for(SandboxCreateWrapper sCW : listOfSandboxCreateResultsWrapper)
                                {
                                    sCW.cSRequest.Error_Message__c = err.getMessage();
                                    listToUpdateResultSBResult.add(new Create_Sandbox_Request__c(Id = result.getId(),
                                                                                                 Error_Message__c = sCW.cSRequest.Error_Message__c));
                                } 
                            }
                        }
                    }
                    update listToUpdateResultSBResult;
                    Util.BypassAllTriggers = false;
                }
            }
        }
        return scheduleNext;
    }
}