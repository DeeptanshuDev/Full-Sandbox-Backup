/**
*  Description     :  Trigger Handler to check and Design request on opportunity 
*
*  Created By      :  Abhishek gangele
*  Created Date    :  06/05/2022
*
*  Revision Logs   :  V1.0 - Created - Abhishek gangele
*
**/
public class DesignRequestCheck {
    
    /**
    *
    *   @description    :  check if there is any Design request already in opportunity or not if there so show some error
    *   @args           :  List<Design_Request__c> all the new Design Request are come under it
    *
    *   @return         :   void
    *
    *   @revision Log   :   V1.1 - Created  -  06/05/2022 - Abhishek gangele - Comment
    * 
    **/
    public static void checkDesignRequest(List<Design_Request__c> dr){
        // store all the Opportunity Id in a list
        List<Id> Ids = new List<ID>();
        for (Design_Request__c d : dr){
            Ids.add(d.Opportunity__c);
        }
        // Fetch if there any previous design  
       List<AggregateResult> designRequestList = new List<AggregateResult>([SELECT COUNT(Design_Request__c)icount , Id FROM Opportunity WHERE Id IN: Ids GROUP BY Id]);
        
        // If Parent opportunity has the design_request so show error
        
        for (Design_Request__c d : dr){
              for (AggregateResult arResult : designRequestList) {
                  
                  if((arResult.get('Id') == d.Opportunity__c) && (Integer)arResult.get('icount') != 0){
                      d.addError('We Cant add more the one Design Request in a opportunity');
                  }
                  
                 

        }        
        
    }

}
}