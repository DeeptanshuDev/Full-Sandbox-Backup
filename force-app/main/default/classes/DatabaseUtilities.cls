/**
*	Description   	:	Utilities class to have generic methods those are somehow related to Database/DML operations.
*
* 	Created By		:	Abhinav Sharma   
*
* 	Created Date	:   12/10/2019
* 
*  	Version			:   v1.0 - Created - CR - 00000046 - Abhinav Sharma 
**/ 
public without sharing class DatabaseUtilities 
{
	//Method for create log of DML insert or update opertion
    public Static String createLog(Database.SaveResult[] saveResults) 
    {
        String logMessage = '';
        for (Database.SaveResult saveResult : saveResults) 
        {
            if (!saveResult.isSuccess()) 
            {
                for(Database.Error err : saveResult.getErrors()) 
                {
                    logMessage += err.getStatusCode() + '&nbsp;' + err.getMessage() + '<br>';
                }
            }
        }
        return logMessage;
    }
    
    //Method for create log of DML delete opertion
    public Static String createLog(Database.DeleteResult[] deleteResults) 
    {
        String logMessage = '';
        for(Database.DeleteResult deleteResult : deleteResults) 
        {
            if (!deleteResult.isSuccess()) 
            {
            	for(Database.Error err : deleteResult.getErrors()) 
                {
                    logMessage += err.getStatusCode() + '&nbsp;' + err.getMessage() + '<br>';
                }
            }
        }
        return logMessage;
    }
    
    //Method for create log of DML upsert opertion
    public Static String createLog(Database.UpsertResult[] upsertResults) 
    {
        String logMessage = '';
        for(Database.UpsertResult upsertResult : upsertResults) 
        {
            if (!upsertResult.isSuccess()) 
            {
            	for(Database.Error err : upsertResult.getErrors()) 
                {
                    logMessage += err.getStatusCode() + '&nbsp;' + err.getMessage() + '<br>';
                }
            }
        }
        return logMessage;
    }
    
    //Method for create log of DML opertion errors in HTML format.
    public Static String errorHTMLLog(Database.Error [] errors) 
    {
		String errorHTMLLogs = '';
		for(Database.Error err : errors) 
        {
			errorHTMLLogs += '<tr><td>' + err.getStatusCode() + '</td><td>' + err.getMessage() + '</td></tr>';
        }
        if(errorHTMLLogs != '') 
        {
            errorHTMLLogs = '<table border="1"><tr><th>StatusCode</th><th>Message</th></tr>' + errorHTMLLogs + '</table>';
        }
        return errorHTMLLogs;
    }
}