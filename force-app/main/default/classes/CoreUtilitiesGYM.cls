public class CoreUtilitiesGYM {

      /**
    *	@description	:	Method use to get Fit Id and Name using Custom Setting.
    *	
    *	@arg			:	
    *
    *	@return			:   Fit_Freedom_Configuration_Settings__c
    *
    *	@Revision Log	:	V1.0 - created - 05/11/20202 - Abhinav Sharma
    *
	**/

    public static Fit_Freedom_Configuration_Settings__c getFitFreedomConfiguration() 
    {
        
       //This instanse hold Custom Setting details
       Fit_Freedom_Configuration_Settings__c fitFreedomConfiSetting = Fit_Freedom_Configuration_Settings__c.getInstance(UserInfo.getUserId());
        
        fitFreedomConfiSetting = Fit_Freedom_Configuration_Settings__c.getInstance(UserInfo.getUserId());

        if(fitFreedomConfiSetting == null)
            fitFreedomConfiSetting = Fit_Freedom_Configuration_Settings__c.getOrgDefaults();
        
        return fitFreedomConfiSetting;
    }

}