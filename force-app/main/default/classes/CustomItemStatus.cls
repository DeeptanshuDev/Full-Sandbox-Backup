public class CustomItemStatus {
    
    public void setCustomItemStatusFromDesign(List<Design__c> newDesigns,
                                              Map<Id, Design__c> oldDesignsMap) 
    {
        List<StatusFromDesignRule> rules = new List<StatusFromDesignRule> {
            new InPricingStatusRule(),
                new SentForApprovalStatusRule()
                };
                    Map<Id, String> statusesByDesignId = new Map<Id, String>();
        
        for (Design__c newDesign : newDesigns) {
            for (StatusFromDesignRule r : rules) {
                String status = r.evaluate(newDesign, oldDesignsMap.get(newDesign.Id));
                system.debug('status ---'+status);
                if (status != null) {
                    statusesByDesignId.put(newDesign.Id, status);
                }
            }
        }
        system.debug('statusesByDesignId --- '+statusesByDesignId);
        List<Design__c> designs = DesignDAO.getDesigns(new List<Id>(statusesByDesignId.keySet()));
        List<Custom_Item__c> customItems = new List<Custom_Item__c>();
        Map<Id,Custom_Item__c> customItemMap = new Map<Id,Custom_Item__c>();
        system.debug('designs---'+designs);
        for (Design__c d : designs) {
            for (Design_Item__c di : d.Design_Items__r) {
                if (di.Custom_Item__c != null) {
                    if(!customItemMap.containsKey(di.Custom_Item__c)){
                        system.debug('statusesByDesignId----'+statusesByDesignId.get(d.Id));
                        
                        //06/17/2021 - Seemu Saikia - Trcak the date of art approval
                        if(statusesByDesignId.get(d.Id) == '(S) Artwork Approved'){
                            customItemMap.put(di.Custom_Item__c,new Custom_Item__c( Id = di.Custom_Item__c, Design_Status__c = statusesByDesignId.get(d.Id), Approved_Date__c = Date.Today()));
                        }
                        else{
                            customItemMap.put(di.Custom_Item__c,new Custom_Item__c( Id = di.Custom_Item__c, Design_Status__c = statusesByDesignId.get(d.Id)));
                        }
                    }
                }
            }
        }
        if (customItemMap != null && customItemMap.size() > 0) {
            update customItemMap.values();
        }
    }
    
    public void setCustomItemStatusFromDesignRound(List<Design_Round__c> newRounds,
                                                   Map<Id, Design_Round__c> oldRoundsMap) 
    {
        
        
        List<StatusFromDesignRoundRule> rules = new List<StatusFromDesignRoundRule> {
            new PricingCompleteStatusRule(),
                new ArtApprovalSentStatusRule(),
                new ArtworkApprovedStatusRule(),
                new PrototypeCommentsPostedStatusRule(),
                new RevisionCommentsPostedStatusRule()
                };
                    Map<Id, String> statusesByDesignRoundId = new Map<Id, String>();
       
        for (Design_Round__c newRound : newRounds) {
            
            
            for (StatusFromDesignRoundRule r : rules) {
                //System.assert(false,oldRoundsMap.get(newRound.Id));
                String status = r.evaluate(newRound, oldRoundsMap.get(newRound.Id));
                
                //status = '(S) Revision Comments Sent, Waiting for Revised Art';
                // System.assert(false,status);  
                if(!String.isBlank(status))
                {
                    //System.assert(false,'Not NULL');
                    statusesByDesignRoundId.put(newRound.Id, status);
                }
            }
        }
        //system.assert(false,statusesByDesignRoundId);
        List<Design_Item__c> designItems = DesignItemDAO.getDesignItemsByRound(new List<Id>(statusesByDesignRoundId.keySet()));
       
        system.debug('design items ---'+designItems);
        Map<Id, Custom_Item__c> customItemMap = new Map<Id, Custom_Item__c>();
        for (Design_Item__c di : designItems) {
            String status = statusesByDesignRoundId.get(di.Design__r.Design_Round__c);
             
            if (status != null && status != di.Custom_Item__r.Design_Status__c) {
                if (customItemMap.containsKey(di.Custom_Item__c)) {
                    Logger.warn('Custom item already slated for a new status: '
                                + customItemMap.get(di.Custom_Item__c).Design_Status__c
                                +  '. This status would have been: ' + status
                                + '. Custom Item: ' + di.Custom_Item__c);
                    continue;
                }
                customItemMap.put(di.Custom_Item__c, new Custom_Item__c(
                    Id = di.Custom_Item__c,
                    Design_Status__c = status
                ));
            }
        }
        if (!customItemMap.isEmpty()) {
            update customItemMap.values();
        }
    }
    
    public void setCustomItemStatusFromDesignRequest(List<Design_Request__c> newRequests,
                                                     Map<Id, Design_Request__c> oldRequestsMap) 
    {
        List<StatusFromDesignRequestRule> rules = new List<StatusFromDesignRequestRule> {
            new AssignedDesignerStatusRule()
                };
                    Map<Id, String> statusesByDesignRequestId = new Map<Id, String>();
        for (Design_Request__c newRequest : newRequests) {
            for (StatusFromDesignRequestRule r : rules) {
                String status = r.evaluate(newRequest, oldRequestsMap.get(newRequest.Id));
                if (status != null) {
                    statusesByDesignRequestId.put(newRequest.Id, status);
                }
            }
        }
        List<Custom_Item__c> customItems = CustomItemDAO.getCustomItemByDesignRequestIds(new List<Id>(statusesByDesignRequestId.keySet()));
        List<Custom_Item__c> customItemsToUpdate = new List<Custom_Item__c>();
        for (Custom_Item__c ci : customItems) {
            String status = statusesByDesignRequestId.get(ci.Design_Request__c);
            if (status != null && status != ci.Design_Status__c) {
                customItemsToUpdate.add(new Custom_Item__c(
                    Id = ci.Id,
                    Design_Status__c = status
                ));
            }
        }
        
        if (!customItemsToUpdate.isEmpty()) {
            update customItemsToUpdate;
        }
    }
    
    public void setCustomItemStatusFromNewDesignItems(List<Design_Item__c> designItems) 
    {
        designItems = DesignItemDAO.getDesignItemByIdWithCustomItemAndDesignStatus(new List<Id>(new Map<Id, Design_Item__c>(designItems).keySet()));
        system.debug('designItems '+designItems);
        Map<Id,Custom_Item__c> customItemMap = new Map<Id,Custom_Item__c>();
        List<Custom_Item__c> customItems = new List<Custom_Item__c>();
        for (Design_Item__c di : designItems) {
            if (di.Design__r.Needs_Pricing__c && di.Custom_Item__c != null
                && di.Custom_Item__r.Design_Status__c != '(D) In Pricing') {
                   
                    if(!customItemMap.containsKey(di.Custom_Item__c)){
                       customItemMap.put(di.Custom_Item__c,new Custom_Item__c( Id = di.Custom_Item__c, Design_Status__c = '(D) In Pricing'));
                    }
                }
        }
        system.debug('customItemMap---'+customItemMap);
        if (customItemMap != null && customItemMap.size() > 0) {
            update customItemMap.values();
        }
    }

    
    
    interface StatusFromDesignRule {
        String evaluate(Design__c newDesign, Design__c oldDesign);
    }
    
    class InPricingStatusRule implements StatusFromDesignRule 
    {
        public String evaluate(Design__c newDesign, Design__c oldDesign) {
            String retVal = null;
            system.debug('oldDesign.Needs_Pricing__c--'+oldDesign.Needs_Pricing__c);
            system.debug('newDesign.Needs_Pricing__c--'+newDesign.Needs_Pricing__c);
            if ((oldDesign != null && !oldDesign.Needs_Pricing__c) && newDesign.Needs_Pricing__c) {
                retVal = '(D) In Pricing';
            }
            return retVal;
        }
    }
    
    class SentForApprovalStatusRule implements StatusFromDesignRule 
    {
        public String evaluate(Design__c newDesign, Design__c oldDesign) {
            String retVal = null;
            Map<Id, Design__c> designMap = new Map<Id, Design__c>();
            if(!designMap.containsKey(oldDesign.Id))
                designMap.put(oldDesign.Id, oldDesign);
            CustomItemStatus customItemStatus = new CustomItemStatus();
            List<Design__c> designs  = DesignDAO.getDesigns(new List<Id>(designMap.keySet()));
            Boolean artworkApproved = false;
            String version;
            
            if(designs.size() > 0){
                version  = designs[0].Design_Round__r.Version__c;
                //artworkApproved = designs[0].Design_Round__r.Artwork_Approved__c ;
            }
            
            if ((oldDesign == null || !oldDesign.Art_Approval_Created__c) && newDesign.Art_Approval_Created__c) 
            {
                retVal = 'Confirmed to Send';
            }
            if((version == '12' || version == '13' || version == '14' || version == '15' || version == '16' ) &&
               (oldDesign == null || !oldDesign.Approved_Art__c) && newDesign.Approved_Art__c)
            {
                retval = '(S) Proto Revision Artwork Approved, Proto Change Form Attached';
                
            }
            else if ((version != '12' && version != '13' && version != '14' && version != '15' && version != '16' ) && newDesign.Approved_Art__c) {
                retval = '(S) Artwork Approved';
            }  
           
            return retVal;
        }
    }
    
    interface StatusFromDesignRoundRule {
        String evaluate(Design_Round__c newRound, Design_Round__c oldRound);
    }
    
    class PricingCompleteStatusRule implements StatusFromDesignRoundRule 
    {
        private final Map<String, String> statusByVersion = new Map<String, String> 
        {
            '1' => '(D) Initial Art Completed and Sent',
                '2' => '(D) Revision 1 Complete',
                '3' => '(D) Revision 2 Complete',
                '4' => '(D) Revision 3 Complete',
                '5' => '(D) Revision 4 Complete',
                '6' => '(D) Revision 5 Complete',
                '7' => '(D) Revision 6 Complete',
                '8' => '(D) Revision 7 Complete',
                '9' => '(D) Revision 8 Complete',
                '10' => '(D) Revision 9 Complete',
                '11' => '(D) Revision 10 Complete',
                '12' => '(P) Prototype Revision 1 Art Sent, Need Comments',
                '13' => '(P) Prototype Revision 2 Art Sent, Need Comments',
                '14' => '(P) Prototype Revision 3 Art Sent, Need Comments',
                '15' => '(P) Prototype Revision 4 Art Sent, Need Comments',
                '16' => '(P) Prototype Revision 5 Art Sent, Need Comments'
		};
                    
		public String evaluate(Design_Round__c newRound, Design_Round__c oldRound) {
			String status = null;
            if ((!oldRound.Pricing_Complete__c && newRound.Pricing_Complete__c)
                || (newRound.Version__c != oldRound.Version__c && newRound.Pricing_Complete__c)) 
            {
                status = statusByVersion.get(newRound.Version__c);
            }
            return status;
        }
    }
    
    class ArtApprovalSentStatusRule implements StatusFromDesignRoundRule {
        public String evaluate(Design_Round__c newRound, Design_Round__c oldRound) {
            String status = null;
            if (newRound.Art_Approval_Sent__c && !oldRound.Art_Approval_Sent__c) {
                status = 'Art Approval Sent';
            }
            return status;
        }
    }
    
    class ArtworkApprovedStatusRule implements StatusFromDesignRoundRule {
        public String evaluate(Design_Round__c newRound, Design_Round__c oldRound) {
            String status = null;
            String version = newRound.Version__c;
            
            Map<Id, Design_Round__c> designRoundMap = new Map<Id, Design_Round__c>();
            
            if(!designRoundMap.containsKey(oldRound.Id))
                designRoundMap.put(oldRound.Id, oldRound);
           
            CustomItemStatus customItemStatus = new CustomItemStatus();
           
            List<Design__c> designs  = DesignDAO.getDesignsByRoundWithApprovedArt(new List<Id>(designRoundMap.keySet()));
           
            Boolean approvalSentForOneItem = false;
            if(designs.size() > 0){
                for(Design__c desgn :designs){
                    if(desgn.Sent_for_Approval__c){
                        approvalSentForOneItem = true;
                        break;
                    }
                  
                }
            }
            	
            if(approvalSentForOneItem && (version == '12' || version == '13' || version == '14' || version == '15' || version == '16' ) &&
               (oldRound == null ||!oldRound.Artwork_Approved__c) && newRound.Artwork_Approved__c){
                   
                   status = '(S) Proto Revision Artwork Approved, Proto Change Form Attached';
                  
               }
            else if (approvalSentForOneItem && newRound.Artwork_Approved__c && !oldRound.Artwork_Approved__c) {
                status = '(S) Artwork Approved';
            }
           
        
            return status;
        }
    }
    
    class PrototypeCommentsPostedStatusRule implements StatusFromDesignRoundRule {
        public String evaluate(Design_Round__c newRound, Design_Round__c oldRound) {
            String status = null;
            Integer newRoundVersion;
            if(String.isNotBlank(newRound.Version__c))
            	newRoundVersion = Integer.valueOf(newRound.Version__c);
            if ((newRound.Proto_Revision_Comments_Posted__c && !oldRound.Proto_Revision_Comments_Posted__c)
                ) {
                    status = '(S) Prototype Revision Comments Sent, Waiting for Revised Art';
                }
            return status;
        }
    }
    
    class RevisionCommentsPostedStatusRule implements StatusFromDesignRoundRule {
        public String evaluate(Design_Round__c newRound, Design_Round__c oldRound) {
            String status = null;
            Integer newRoundVersion;
            
            if(String.isNotBlank(newRound.Version__c))
            	newRoundVersion = Integer.valueOf(newRound.Version__c);
            //System.assert(false,oldRound.Revision_Comments_Posted__c ); 
            
            //if ((newRound.Revision_Comments_Posted__c && !oldRound.Revision_Comments_Posted__c)
            //System.assert(false,'the value of newRound.Revision_Notes__c is :'+newRound.Revision_Notes__c+' and oldRound.Revision_Notes__c is '+oldRound.Revision_Notes__c);
            System.debug('the value of newRound.Revision_Comments_Posted__c is '+  newRound.Revision_Comments_Posted__c);
            System.debug('the value of oldRound.Revision_Comments_Posted__c is ' + oldRound.Revision_Comments_Posted__c);
            /*if ((newRound.Revision_Comments_Posted__c != oldRound.Revision_Comments_Posted__c)
                ) {
                    status = '(S) Revision Comments Sent, Waiting for Revised Art';
                }*/
            if(newRound.Revision_Notes__c!=oldRound.Revision_Notes__c)
            {
                status = '(S) Revision Comments Sent, Waiting for Revised Art';
            }
            return status;
        }
    }
    
    interface StatusFromDesignRequestRule {
        String evaluate(Design_Request__c newRequest, Design_Request__c oldRequest);
    }
    
    class AssignedDesignerStatusRule implements StatusFromDesignRequestRule {
        public String evaluate(Design_Request__c newRequest, Design_Request__c oldRequest) {
            String status = null;
            if (newRequest.Assigned_Designer__c != null && oldRequest.Assigned_Designer__c == null) {
                status = 'Initial Art in Process';
            }
            return status;
        }
    }
}