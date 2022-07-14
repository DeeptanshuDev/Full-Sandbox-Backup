public class DesignRoundTriggerHandler {

  public void afterUpdate(List<Design_Round__c> newRounds, Map<Id, Design_Round__c> oldRoundsMap) {
    CustomItemStatus status = new CustomItemStatus();
    status.setCustomItemStatusFromDesignRound(newRounds, oldRoundsMap);
  }
    
    public void updateLengthCheckbox(List<Design_Round__c> newRounds,Map<Id, Design_Round__c> oldRoundsMap) {
        
        Set<Id> designRequestesMale = new Set<id>();
        Set<Id> designRequestesFeMale = new Set<id>();
            List<opportunity> oppToBeUpdate = new List<Opportunity>();
        Set<Id> designRequestesMalefalse = new Set<id>();
        Set<Id> designRequestesFeMalefalse = new Set<id>();
        
        for(Design_Round__c dr : newRounds){
            if((dr.Artwork_Approved__c == true) && (dr.Uniform_Sold_as_Practicewear__c == true || dr.No_Length_Adjustments__c == true) && (oldRoundsMap == null || (dr.No_Length_Adjustments__c  != oldRoundsMap.get(dr.Id).No_Length_Adjustments__c || dr.Uniform_Sold_as_Practicewear__c  != oldRoundsMap.get(dr.Id).Uniform_Sold_as_Practicewear__c || dr.Artwork_Approved__c != oldRoundsMap.get(dr.Id).Artwork_Approved__c) )){
                
                if(dr.Gender__c == 'Boy'){
                    designRequestesMale.add(dr.Design_Request__c);
                }else if(dr.Gender__c == 'Girl'){
                    designRequestesFeMale.add(dr.Design_Request__c);
                }
            }else if(dr.Artwork_Approved__c == true && (dr.Uniform_Sold_as_Practicewear__c == false || dr.No_Length_Adjustments__c == false) && (oldRoundsMap == null || (dr.No_Length_Adjustments__c  != oldRoundsMap.get(dr.Id).No_Length_Adjustments__c || dr.Uniform_Sold_as_Practicewear__c  != oldRoundsMap.get(dr.Id).Uniform_Sold_as_Practicewear__c  || dr.Artwork_Approved__c != oldRoundsMap.get(dr.Id).Artwork_Approved__c) )){
                if(dr.Gender__c == 'Boy'){
                    designRequestesMalefalse.add(dr.Design_Request__c);
                }else if(dr.Gender__c == 'Girl'){
                    designRequestesFeMalefalse.add(dr.Design_Request__c);
                }
            }
        }
        
        system.debug('design request set '+designRequestesFeMale);
        if(designRequestesMale.size() > 0 || designRequestesFeMale.size() > 0){
            
            Set<Id> Opportunities = new Set<Id>();
            for( Design_Request__c designReq : DesignRequestDAO.getDesignRequestFromIds(designRequestesMale, designRequestesFeMale)){
                Opportunities.add(designReq.opportunity__c);
            }
            
            system.debug('opportunities ---'+opportunities);
            for(Opportunity opp : OpportunityDAO.getOpportunityWithNoLengthAdjustments(opportunities)){
                
                Opportunity opps = new Opportunity();
                opps.Id = opp.Id;
                if(designRequestesMale.size() > 0){
                    system.debug('check this11 '+designRequestesMale);
                    opps.No_Length_adjustments__c = true;
                }
                if(designRequestesFeMale.size() > 0){
                    system.debug('check this22 '+designRequestesFeMale);
                    opps.No_Length_Adjustments_Female__c = true;
                }
                oppTOBeUpdate.add(opps);
            }
        }
        else if(designRequestesMalefalse.size() > 0 || designRequestesFeMalefalse.size() > 0){
            
             Set<Id> Opportunities = new Set<Id>();
            for( Design_Request__c designReq : DesignRequestDAO.getDesignRequestFromIds(designRequestesMalefalse, designRequestesFeMalefalse)){
                Opportunities.add(designReq.opportunity__c);
            }
            
            for(Opportunity opp : OpportunityDAO.getOpportunityWithNoLengthAdjustments(opportunities)){
                
                Opportunity opps = new Opportunity();
                opps.Id = opp.Id;
                if(designRequestesMalefalse.size() > 0){
                    opps.No_Length_adjustments__c = false;
                }
                if(designRequestesFeMalefalse.size() > 0){
                    opps.No_Length_Adjustments_Female__c = false;
                }
                oppTOBeUpdate.add(opps);
            }
        }
        system.debug('opp to ypdate '+oppToBeUpdate);
        if(oppToBeUpdate.size() > 0){
            update oppToBeUpdate;
        }
    }
    
    /**
    *
    * @description : This method is being used for updating value in designroundflag field in desing request based on design round update.
    *
    * @args : List<Design_Round__c>, Map<Id, Design_Round__c>
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 05/10/2022 - Deeptanshu Bharti
    *
    **/ 
    public void updateDesingRequestFlag(List<Design_Round__c> newRounds,Map<Id, Design_Round__c> oldRoundsMap)
    {
        //Set<Id> setOfDRId =  new Set<Id>();
        Map<Id,String> mapOfIds = new Map<Id,String>();
        List<Design_Request__c> listOfDr = new List<Design_Request__c>();
        for(Design_Round__c obj : newRounds){
            System.debug('the desing round is : ' + obj);
            System.debug('the value of Design_Round_Flag__c is : ' + obj.Design_Round_Flag__c);
            if(oldRoundsMap == null || (obj.Design_Round_Flag__c != oldRoundsMap.get(obj.Id).Design_Round_Flag__c) || (obj.Design_Round_Flag__c!=NULL)){
                System.debug('the value of desing round flag has changed');
                //setOfDRId.add(obj.Design_Request__c);
                mapOfIds.put(obj.Design_Request__c,obj.Design_Round_Flag__c);          
            }
        }
        //System.assert(false,mapOfIds);
        if(!mapOfIds.isEmpty()){
            //for(Design_Request__c dr : [SELECT Id, Name, Design_Round_Flag__c FROM Design_Request__c WHERE Id IN:setOfDRId]){
            for(Design_Request__c dr : [SELECT Id, Name, Design_Round_Flag__c FROM Design_Request__c WHERE Id IN:mapOfIds.keySet()]){
                System.debug('the design request is  : ' + dr);
                System.debug('the value of desing round flag in desing request is  : ' + dr.Design_Round_Flag__c);
                String temp = mapOfIds.get(dr.Id);
                
                System.debug('the value of design round which we need to update is  : ' + temp);
                Design_Request__c dReq = new Design_Request__c();
                dr.Design_Round_Flag__c = temp;
                //if(!String.isBlank(temp)){
                if(temp!=NULL){
                    // dr.Design_Round_Flag__c = temp;
                    //System.assert(false,dr.Design_Round_Flag__c);
                }
                listOfDr.add(dr);
            }
        }
        if(listOfDr.size()>0){
            update listOfDr;
        }
    }
    
    
  /**
    *
    *   @description    :  ON basis of Design Round  version we update the coustom item Design Status 
    *
    *   @args           :  List<Design_Round__c> new and updated design round  
    *
    *   @return         :  
    *
    *   @revision Log   :   V1.1 - Created  - 23/05/2022 - Abhishek gangele - Comment
    * 
    **/
    public Static void updateChatterBox(List<Design_Round__c> newRounds){
        
        // Store all the Id in setOfDrId if condition is satisfied
        set<Id> setOfDrId = new set<Id>();
        
        // itrate Over each Design Round And check condition if it satisfied so add id in set
        for(Design_Round__c dr : newRounds){
            
            if((dr.Version__c == '17' || dr.Version__c == '18') && (dr.Pricing_Complete__c == True)){
                setOfDrId.add(dr.Id);               
            }                        
        }
        // we store all the Design item whose relate custom item we have to update 
        List<Design_Item__c> DesignItems = new List<Design_Item__c>();
        
        if(setOfDrId.size() > 0){
        	Map<Id , Design__c > mapOfIdToDesign = new map<Id , Design__c >([Select Id, Name from Design__c where Design_Round__C IN :setOfDrId]);
        
            if(mapOfIdToDesign.keyset().size() > 0){
        
            	DesignItems = [Select  Name , Custom_Item__c from Design_Item__c where Design__c IN : mapOfIdToDesign.keyset()];
            }
        }
        List<Custom_Item__c> updateCustomStatus = new List<Custom_Item__c>();
        
        // Itrate over each Design item and update related Custom item
        for(Design_Item__c DI : DesignItems){
            
            updateCustomStatus.add(new Custom_Item__c(Id = DI.Custom_Item__c , Design_Status__c = '(P)(T) Design Request Complete'));
            
        }
        if (updateCustomStatus.size()>0){
             update updateCustomStatus ;
        }      
    }
}