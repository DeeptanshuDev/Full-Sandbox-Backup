/**
*  Description     :   This class is used to update Envelop Status and last viewed field of eSignature Status object record 
*                      when eSignature form opened by user from dynamic URL.
*  
*  Created By      :   Chirag Soni
*
*  Created Date    :   2/23/2021
*
*  Revision Logs   :   V_1.0 - Created 
**/

public without sharing class eSignatureUpdatesFromSite {
    
    /**
*  
*  @description    :  Update last viewed and enevelop status  fields of eSignature Status Object. This method is 
*                     invoked from eSignatureFormHandler.
*
*  @args           :  Record id of eSignature Status Object
*
*  @return         :  Void
*
*  @revision Log   :   V_1.0 - Created 2/23/2021
* 
**/
    
    public static void updateLastViewedAndEnevlopStatus(String eSignatureStatusId)
    {
        List<eSignature_Status__c> eSignStatus = [SELECT Id, Approved__c, Voided__c, Last_Viewed__c, Envelop_Status__c 
                                                  FROM eSignature_Status__c 
                                                  WHERE Id = :eSignatureStatusId];
        
        if(eSignStatus.size()>0){
            if(!(eSignStatus[0].Approved__c) && !(eSignStatus[0].Voided__c))
            {
                eSignStatus[0].Envelop_Status__c = 'Delivered';
                eSignStatus[0].Voided__c = false;
                eSignStatus[0].Approved__c = false;
                eSignStatus[0].Last_Viewed__c = DateTime.now();
            }
            update eSignStatus; 
        }
    }
}