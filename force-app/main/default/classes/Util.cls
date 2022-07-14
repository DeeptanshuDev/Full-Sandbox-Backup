public class Util 
{
    public static boolean BypassAllTriggers = false;
    public Static List<RecordsWrapper> processSaveResults(Database.SaveResult[] saveResults, List<User> listOfNewCommunityUsers) 
    {
        
        String logMessage = '';
        integer recordIndex=0;
        List<RecordsWrapper> recordWrappers = new List<RecordsWrapper>();
        List<RecordsWrapper.ErredRecordsWrapper> errorRecordWrappers = new List<RecordsWrapper.ErredRecordsWrapper>();
        List<RecordsWrapper.SuccessfulRecordWrapper> successRecordWrappers = new List<RecordsWrapper.SuccessfulRecordWrapper>();
        
        for (Database.SaveResult saveResult : saveResults) 
        {
            if (!saveResult.isSuccess()) 
            {
                for(Database.Error err : saveResult.getErrors()) 
                {
                    logMessage += err.getStatusCode() + '&nbsp;' + err.getMessage() + '<br>';
                }
                if(listOfNewCommunityUsers != null && listOfNewCommunityUsers.get(recordIndex) != null) 
                {
                    User user = listOfNewCommunityUsers.get(recordIndex);
                    RecordsWrapper.ErredRecordsWrapper erredRecord = new RecordsWrapper.ErredRecordsWrapper(logMessage, user.ContactId,recordIndex);
                    errorRecordWrappers.add(erredRecord);
                }
            }
            else {
                if(listOfNewCommunityUsers != null && listOfNewCommunityUsers.get(recordIndex) != null) 
                {
                    User user = listOfNewCommunityUsers.get(recordIndex);
                    RecordsWrapper.SuccessfulRecordWrapper erredRecord = new RecordsWrapper.SuccessfulRecordWrapper(user.ContactId, saveResult.getId(), recordIndex);
                    successRecordWrappers.add(erredRecord);
                }
            }
            recordIndex +=1;
            logMessage = '';
        }
        
        RecordsWrapper recordWrapper = new RecordsWrapper(successRecordWrappers, errorRecordWrappers);
        recordWrappers.add(recordWrapper);
        
        return recordWrappers;
    }
    public Static void sendBatchStatus(Id batchJobId, String batchName, String errors, String emailRecipient) 
    {
        List<AsyncApexJob> aSyncJobs = [SELECT Id, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email 
                                        FROM AsyncApexJob
                                        WHERE id = :batchJobId];
        if(aSyncJobs.size() > 0) 
        {
            // Send email indicating the completion of this batch
            String emailMessage = 'Your batch job \"' + batchName + '\" has finished.  It processed job items'
                + aSyncJobs[0].totalJobItems +
                ' batches. Of which, '
                + aSyncJobs[0].JobItemsProcessed
                + ' processed without any exceptions thrown and '
                + aSyncJobs[0].numberOfErrors
                + ' batches threw unhandled exceptions.' + '<br>' + errors;
            EmailHandler.sendEmail(emailRecipient, batchName + ' has been completed', '', emailMessage);        
        }
    }
    
    //Method to process string literal on the basis of count and side value provided to it
    public Static String processStringLiteral(String stringLiteral, Integer countFromLeft, String whichSide) 
    {
        if(String.isNotBlank(stringLiteral) && String.isNotBlank(whichSide)
           && countFromLeft != null && countFromLeft > 0) 
        {
            if(whichSide.equalsIgnoreCase('left')) 
            {
                if(stringLiteral.length() > countFromLeft) 
                {
                    return stringLiteral.left(countFromLeft);
                }
                else
                {
                    return stringLiteral;
                }    
            }
            else if (whichSide.equalsIgnoreCase('right')) 
            {
                if(stringLiteral.length() > countFromLeft) 
                {
                    return stringLiteral.right(countFromLeft);
                }
                else
                {
                    return stringLiteral;
                }
            } 
            else 
            {
                return '';
            }
        }
        else 
        {
            return '';    
        }
    }        
}