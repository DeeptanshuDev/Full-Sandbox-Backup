/**
*  Description     :  DAO Class to handle the soqls for DesignRequest
*
*  Created By      :  Ajay
*
*  Created Date    :  13/05/2022
*
*  Revision Logs   :  V1.0 - Created By - Ajay
*
**/
public class DesignRequestDAO {
    /**
     *
     *   @description    :  method to return list of Design_Request__c with opportunity__c
     * 
     *   @args           :  Set<Id>, Set<Id>
     *
     *   @return         :  List<Design_Request__c>
     *
     *   @revision Log   :   V1.1 - Created  -  13/05/2022 	-		Ajay 
     * 
     **/
    public static List<Design_Request__c> getDesignRequestFromIds(Set<Id> setIdDesignRequestesMale, Set<Id> setIdDesignRequestesFemale){
        return [SELECT Id,Opportunity__c FROM Design_Request__c WHERE (Id IN: setIdDesignRequestesMale) OR (Id IN: setIdDesignRequestesFemale) ];
    }
}