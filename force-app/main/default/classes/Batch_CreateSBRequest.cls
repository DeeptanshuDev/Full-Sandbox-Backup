/**
*  Description     :   Batch Class for "SandboxCreateANDRefresh" to Create a Sandbox using Tooling API.
*
*  Created By      :   Abhinav Sharma
*
*  Created Date    :    03/12/2020
*
*  Current Version :   v1.0
*       
*  Revision Log    :   V_1.0 Created               
**/
global class Batch_CreateSBRequest implements Database.Batchable<sObject>, Database.AllowsCallouts 
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
      	String status = System.Label.Sandbox_Request_Awaiting_Sandbox_Creation;
        String query = 'SELECT Id, Sandbox_Name__c,Sandbox_Description__c, Auto_Activate__c,Status__c, SandboxInfo_Id__c, Was_Picked_Alredy__c, Error_Message__c '+ 
            			'FROM Create_Sandbox_Request__c Where Status__c =: status AND Was_Picked_Alredy__c = false ';
        system.debug(query);
        system.debug(Database.query(query));
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Create_Sandbox_Request__c> listOfCreateSBReqs)
    {
        for(Create_Sandbox_Request__c cSBR : listOfCreateSBReqs)
        {
            if(String.isBlank(cSBR.Error_Message__c))
            {
                SandboxCreateWrapper sCW = new SandboxCreateWrapper();
                sCW.cSRequest = listOfCreateSBReqs[0];
                SandboxCreateAndRefreshManager sBCRM = new SandboxCreateAndRefreshManager();
                sCW = sBCRM.createAndRefreshSandbox(sCW, listOfCreateSBReqs[0].Auto_Activate__c, null, false);    
            }  
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    	//Calling schedular so it will track all the processing of Batch job. 
    	Scheduler_BatchCreateSBRequestProcess.scheduleAfterMinutes(1, false, null, true);   
    }
}