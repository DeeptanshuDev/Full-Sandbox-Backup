/**
*  Purpose      :   Class to have generic core utilities
*  Created By   :   Abhinav Sharma
**/
public without sharing class CoreUtilities 
{
    public static String listToSemiColonSeperatedString(List<String> listOfStrings) 
    {
        if(listOfStrings != null && listOfStrings.size() > 0) 
        {
            String processedString = '';
            for(String strvar : listOfStrings) 
            {
                processedString += strvar + Constants.CHAR_SEMI_COLON;
            }
            if(processedString.endsWith(Constants.CHAR_SEMI_COLON)) 
            {
                processedString = processedString.removeEnd(Constants.CHAR_SEMI_COLON);    
            }
            return processedString;
        }
        else 
        {
            return null;    
        }
    } 
    
    // make sure that this is a valid email address
    public static boolean isValidEmailAddress(String emailAddress)
    {
        Pattern emailRegex = Pattern.compile('[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}');
        Matcher regexMatcher = emailRegex.matcher(emailAddress);
        if(regexMatcher.matches())
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    //Check for Null and if yes, then return blank
    public static String parseNull(String value) 
    {
        if(value == null)
            return '';
        return value;
    }
    
    //Remove the special characters and digits, then return the formatted value
    public static String formatToAlphabatical(String value) 
    {
        if(String.isNotBlank(value))
            return (value.replaceAll('-', ' ')).replaceAll('[^a-zA-Z ]','');
        return value;
    }
    
    //Method to convert a HTML text into a plain text. Normally, it is useful in email handlers.
    public static string HtmlToText(string htmlStr)
    {
        String result = htmlStr.replaceAll('<br/>', '\n');
        result = result.replaceAll('<br />', '\n');
        string HtmlPattern = '<.*?>';
        Matcher match =  Pattern.compile(HtmlPattern).matcher(result);
        return match.replaceAll('');
    }
    
    //Method to Identify for the Production OR Sandbox Instance.
    public static Boolean IS_PRODUCTION_INSTANCE 
    {
        get 
        {
            Boolean IS_PRODUCTION_INSTANCE1;
            if(IS_PRODUCTION_INSTANCE1 == null) 
            {
                IS_PRODUCTION_INSTANCE1 = false;
                List<Organization> organizations = [SELECT Id, IsSandbox  
                                                    FROM Organization 
                                                    LIMIT 1];
                if(organizations != null 
                   && organizations.size() > 0 
                   && organizations[0].IsSandbox == false)
                    IS_PRODUCTION_INSTANCE1 = true;   
            }
            return IS_PRODUCTION_INSTANCE1;
        }
    }
    
    //Method to return a chron expression to run a job once.
    //This is frequently used in Batch jobs that are chained together.
    public static string getChronExpressionFromDateTime(DateTime dt) 
    {
        return '' + dt.second() + ' ' + dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
    }
    
    public static String replaceAllCommaWithBlankString(String stringToProcess) 
    {
        if(String.isNotBlank(stringToProcess)) 
        {
            stringToProcess = stringToProcess.replaceAll(',', '');
            return stringToProcess;
        } 
        else 
        {
            return '';
        }
    }
    
    public static Decimal doPercentageCalculation(Integer dividend, Integer divisor, Integer roundOffUpto) 
    {
        if(roundOffUpto == null) 
        {
            roundOffUpto = 2;    
        }
        
        Decimal resultant;
        if(dividend == null || divisor == null) 
        {
            return 0;   
        }
        else 
        {
            if(divisor == 0) 
            {
                return 0;    
            }
            else 
            {
                resultant = (Decimal.valueOf(dividend)/Decimal.valueOf(divisor))*100;
                return resultant;           
            }
        }
    }
    
    //Unschedule all jobs with no Next Fire date, and un-schedule them.
    public static void unscheduleJobsWithoutNextFireDate() 
    {
        for (CronTrigger job : [SELECT Id, NextFireTime FROM CronTrigger 
                                WHERE NextFireTime = null LIMIT : Limits.getLimitDMLStatements()
                               ]) 
        {
            try 
            {
                system.abortJob(job.Id);
            } 
            catch(Exception ex) 
            {
                if(ex.getMessage().contains('Invalid parameter value'))
                    continue;
                else if(ex.getMessage().contains('Job does not exist or is already aborted'))
                    continue;
                else
                    throw new CustomException(ex.getMessage());
            }
        }
    }
    
    public static String getInstanceName() 
    {
        return UserInfo.getUserName().substringAfterLast(Constants.CHAR_DOT);
    }
    
    //Method to return quoted String
    public static String quotedString(List<String> listOfValues, String seperator) 
    {
        if(listOfValues != null && listOfValues.size() > 0 && String.isNotBlank(seperator)) 
        {
            String valuesStr = '';
            for(String valStr : listOfValues)
            {
                valuesStr += valStr + seperator;	   
            } 
            valuesStr = valuesStr.removeEnd(seperator);
            return valuesStr;
        }
        return null;
    }
    
    public static boolean getCompVisibility(String permissionToCheck)
    {
        if(!Test.isRunningTest()) 
        {
            boolean hasPermission = FeatureManagement.checkPermission(permissionToCheck);
            return hasPermission;
        }
        else 
        {
            return true;    
        }
    }
    
    public static void unscheduleASpecificJobOfCompletedType(String jobName) 
    {
        if(String.isNotBlank(jobName)) 
        {
            
            //Clear all the completed Jobs
            List<CronTrigger> jobsToAbort = [SELECT Id 
                                             FROM CronTrigger 
                                             WHERE CronJobDetail.JobType = '7' 
                                             AND State IN ('COMPLETE', 'DELETED') 
                                             AND CronJobDetail.Name 
                                             LIKE :jobName Order BY CreatedDate Desc 
                                             LIMIT : Limits.getLimitDMLStatements()];
            if(jobsToAbort.size() > 0)
            {
                for(CronTrigger job : jobsToAbort) 
                { 
                    try {
                        system.abortJob(job.Id);
                    } catch(Exception ex) 
                    {
                        if(ex.getMessage().contains('Invalid parameter value'))
                            continue;
                        else if(ex.getMessage().contains('Job does not exist or is already aborted'))
                            continue;
                        else
                            throw new CustomException(ex.getMessage());
                    }
                    
                }    
            }
        }
    }
}