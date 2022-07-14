/**
*  Description     :   Scheduler Class to Schedule Create Sandbox Process
*
*  Created By      :   Abhinav Sharma
*
*  Created Date    :   02/20/2020
*
*  Current Version :   v1.0
*       
*  Revision Log    :   V_1.0 Created               
**/
global class Scheduler_BatchCreateSBRequestProcess implements Schedulable,Database.AllowsCallouts 
{
    public Boolean isPageContext = false;
    public Id sandboxCreateRequestRecordId;
    public List<SandboxCreateWrapper> listOfSandboxCreateResultsWrapper;
    public Boolean progressCheck = false;
    global void execute(SchedulableContext sc)
    {
        List<AsyncApexJob> listQueueableJobs = AsyncApexJobQueryBuilder.getJobsRelatedToBatch(Constants.setOfJobStatus, 
                                                                                              System.Label.Queuable_Job_Name_For_Sandbox_Creation, 
                                                                                              Constants.JOB_TYPE_QUEUEABLE);
        
        List<CronTrigger> listCron = CronTriggerQueryBuilder.getCronJobDetails(Constants.setOfJobStatus, System.Label.Create_Sandbox_Schedule_Job_Name);
        
        if(listCron != null && listCron.size() == 0 
           && (listQueueableJobs !=null && listQueueableJobs.size() == 0 
               && (Limits.getLimitQueueableJobs() - Limits.getQueueableJobs()) > 0
              )
          ) 
        {  
            //If running in VF page context
            if(isPageContext)
            {
                if(listOfSandboxCreateResultsWrapper != null && listOfSandboxCreateResultsWrapper.size() > 0) {
                    sandboxCreateRequestRecordId = listOfSandboxCreateResultsWrapper[0].cSRequest.Id;
                }
                
                if(sandboxCreateRequestRecordId != null && String.isNotBlank(sandboxCreateRequestRecordId)) 
                {
                    List<SandboxCreateWrapper> listOfSandboxCreateWrapper = new List<SandboxCreateWrapper>();
                    
                    for(Create_Sandbox_Request__c cSBRequest : [SELECT Id, Sandbox_Name__c,Sandbox_Description__c,
                                                                Auto_Activate__c,Status__c, SandboxInfo_Id__c,
                                                                Was_Picked_Alredy__c, Last_Time_Successfully_Completed__c, Error_Message__c 
                                                                FROM Create_Sandbox_Request__c 
                                                                WHERE Id =: sandboxCreateRequestRecordId])
                    {
                        SandboxCreateWrapper sCW = new SandboxCreateWrapper();
                        sCW.cSRequest = cSBRequest;
                        sCW.isSBCreateRequestSuccessive = true;
                        sCW.messageDetails = System.Label.SB_Create_Req_Success_Msg;
                        listOfSandboxCreateWrapper.add(sCW);
                    } 
                    if(listOfSandboxCreateWrapper.size() > 0) 
                    {
                        Queuable_BatchSBCreateRequestProcess queueJob = new Queuable_BatchSBCreateRequestProcess(listOfSandboxCreateWrapper);
                        System.enqueueJob(queueJob);
                    }     
                }
                else 
                {
                    throw new customException(System.Label.SB_Create_Req_Record_Id_Missing);
                }
            }
            else
            {
                List<SandboxCreateWrapper> listOfSandboxCreates = new List<SandboxCreateWrapper>();
                
                String status = '';
                
                if(progressCheck)
                    status = System.Label.Sandbox_Create_In_Progress;
                else
                    status = System.Label.Sandbox_Request_Awaiting_Sandbox_Creation;
                
                for(Create_Sandbox_Request__c cSBRequest : [SELECT Id,Sandbox_Name__c,Sandbox_Description__c,Auto_Activate__c,Status__c, SandboxInfo_Id__c,
                                                            Was_Picked_Alredy__c, Last_Time_Successfully_Completed__c,Error_Message__c 
                                                            FROM Create_Sandbox_Request__c 
                                                            WHERE Was_Picked_Alredy__c = false 
                                                            AND Last_Time_Successfully_Completed__c = null 
                                                            AND Status__c =: status])
                {
                    SandboxCreateWrapper sCW = new SandboxCreateWrapper();
                    sCW.cSRequest = cSBRequest;
                    SandboxCreateAndRefreshManager sBCRM = new SandboxCreateAndRefreshManager();
                    sCW = sBCRM.createAndRefreshSandbox(sCW, cSBRequest.Auto_Activate__c, null, false);
                    listOfSandboxCreates.add(sCW);                
                } 
                if(listOfSandboxCreates.size() > 0) 
                {
                    Queuable_BatchSBCreateRequestProcess queueJob = new Queuable_BatchSBCreateRequestProcess(listOfSandboxCreates);
                    System.enqueueJob(queueJob);
                }
            }
        }
        else
        {
            //scheduleAfterMinutes(Integer.valueOf(System.Label.Time_Duration_Recursive_Sandbox_Process_Job_Status), false);
        }
    }
    
    //Schedule the Apex Job after n Minutes 
    public static void scheduleAfterMinutesForPage(Integer minutes, Boolean isRunningInPageContext, List<SandboxCreateWrapper> listOfSandboxCreateResultsWrapper) 
    {
        Scheduler_BatchCreateSBRequestProcess.scheduleAfterMinutes(minutes, isRunningInPageContext,  listOfSandboxCreateResultsWrapper, false);
    }
    
    //Schedule the Apex Job after n Minutes 
    public static void scheduleAfterMinutes(Integer minutes, Boolean isRunningInPageContext, List<SandboxCreateWrapper> listOfSandboxCreateResultsWrapper, Boolean progressCheck) 
    {
        CoreUtilities.unscheduleASpecificJobOfCompletedType(System.Label.Create_Sandbox_Schedule_Job_Name_For_Abort_Job);
        
        //Reschedule the Job after n minutes
        DateTime sysTime = dateTime.now().addMinutes(minutes);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        Scheduler_BatchCreateSBRequestProcess sched_Job = new Scheduler_BatchCreateSBRequestProcess();
        sched_Job.listOfSandboxCreateResultsWrapper = listOfSandboxCreateResultsWrapper;
        sched_Job.progressCheck = progressCheck;
        if(isRunningInPageContext) 
        {
            sched_Job.isPageContext = true;
        }
        else 
        {
            sched_Job.isPageContext = false;
        }
        System.schedule(System.Label.Create_Sandbox_Schedule_Job_Name_For_Abort_Job + String.valueOf(Math.random()), chron_exp, sched_Job);
    }
}