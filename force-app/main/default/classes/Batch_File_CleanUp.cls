/**
*	Description   	:		Batch job that can be scheduled on weekly basis and is there to clear out file garbage data older than 
							one week created by custom mapping only.
*
* 	Created By		:	Abhinav Sharma   
*
* 	Created Date	:   1/27/2020
* 
*  	Version			:   v1.0 - Created - CR - 00000055 - Abhinav Sharma         
**/ 
global class Batch_File_CleanUp implements Database.Batchable<SObject>, Database.Stateful 
{
    global String fileIdentification ='';
    global String query ='';
    global Batch_File_CleanUp(String fileIdentifier)
    {
        if(String.isNotBlank(fileIdentifier))
        {
            fileIdentification = fileIdentifier+'%';
            query = 'SELECT Id, Title FROM ContentDocument WHERE Title LIKE \''+ String.escapeSingleQuotes(fileIdentification) + '%\' ';  
        } 
        else 
        {
            throw new customException('Valid File Identification Error Message');   
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {   
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<ContentDocument> contentDocToBeDeleted)
    {
        if(contentDocToBeDeleted.size() > 0)
        {
            delete contentDocToBeDeleted;
        } 
    }   
    global void finish(Database.BatchableContext bc)
    { 
        
    }
}