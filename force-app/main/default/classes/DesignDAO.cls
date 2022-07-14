/**
*  Description     :  DAO Class to handle the soqls for Designs 
*
*  Created By      :  Ajay
*
*  Created Date    :  13/05/2022
*
*  Revision Logs   :  V1.0 - Created By - Ajay
*
**/
public class DesignDAO {
    /**
     *
     *   @description    :  method to return list of Designs by ids
     * 
     *   @args           :  List<Id>
     *
     *   @return         :  List<Design__c>
     *
     *   @revision Log   :   V1.1 - Created  -  13/05/2022 	-	Ajay 
     * 
     **/
    public static List<Design__c> getDesigns(List<Id> designIds) {
        return [
            SELECT Id
            , Needs_Pricing__c
            , Design_Round__c
            , Design_Round__r.Version__c
            , Design_Round__r.Artwork_Approved__c
            , (
                SELECT Id, Custom_Item__c FROM Design_Items__r 
                WHERE Custom_Item__c != null 
                	AND (Custom_Item__r.Stage__c != 'Grey Out' AND Custom_Item__r.Stage__c != 'Production'AND (Design_Status__c !='(D) TechPack Sent' AND Design_Status__c !='(P)(T) Design Request Complete' AND Design_Status__c !='(T) Tech Pack FTP\'d'))
            )
            FROM Design__c
            WHERE Id IN :designIds
        ];
    }
    
    /**
     *
     *   @description    :  method to return list of Design Items by ids
     * 
     *   @args           :  List<Id>
     *
     *   @return         :  List<Design__c>
     *
     *   @revision Log   :   V1.1 - Created  -  13/05/2022 	-		Ajay 
     * 
     **/
    public static List<Design__c> getDesignsByRoundWithApprovedArt(List<Id> designRoundIds) {
        return [
            SELECT Id
            , Needs_Pricing__c
            , Design_Round__c
            , Design_Round__r.Version__c
            , Approved_Art__c
            , Sent_for_Approval__c
            FROM Design__c
            WHERE Design_Round__c IN :designRoundIds
        ];
    }
}