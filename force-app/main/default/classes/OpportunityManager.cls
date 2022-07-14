public class OpportunityManager {

 
  private List<Inventory_Transaction__c> transactionsToCreate =
    new List<Inventory_Transaction__c>();

  public void beforeUpdate(List<Opportunity> opps, List<Opportunity> oldOpps) {
    setName(opps);
//    new OpportunityDates().setDates(opps);
  }

  public void beforeInsert(List<Opportunity> opps) {
    setName(opps);
//    new OpportunityDates().setDates(opps);
  }

  private void setName(List<Opportunity> opps) {
    for (Opportunity opp : opps) {
    	if (opp.Type == 'Reorder') {
      		if(collection(opp.Collection_Picklist__c)=='N/A' || collection(opp.Collection_Picklist__c)=='None' || collection(opp.Collection_Picklist__c)==''){
            opp.Name = 'RO ' + ifNull(opp.Category_Picklist__c) + ' '
              + ifNull(opp.Uniform_Style__c) + ' ' + ifNull(opp.Additional_Description__c);
      		}
        	else{
            opp.Name = 'RO ' + ifNull(opp.Category_Picklist__c) + ' '
              + collection(opp.Collection_Picklist__c)
              + ' ' + ifNull(opp.Uniform_Style__c) + ' ' + ifNull(opp.Additional_Description__c);
          	}
      	}
      	else {
        	if(collection(opp.Collection_Picklist__c)=='N/A' || collection(opp.Collection_Picklist__c)=='None' || collection(opp.Collection_Picklist__c)==''){
                opp.Name = ifNull(opp.Category_Picklist__c) + ' '
                + ifNull(opp.Uniform_Style__c) + ' ' + ifNull(opp.Additional_Description__c);
            }
            else{
                opp.Name = ifNull(opp.Category_Picklist__c) + ' ' + collection(opp.Collection_Picklist__c)
                + ' ' + ifNull(opp.Uniform_Style__c) + ' ' + ifNull(opp.Additional_Description__c);
            }
      	}
    }
  }

    public void updateRelatedCustomItemAFS(List<Opportunity> opportunities,Map<Id,Opportunity> oldOpportunities){
        
        Set<Id> oppIdsMale = new Set<Id>();
        Set<Id> oppIdsFeMale = new Set<Id>();
        List<Custom_Item__c> custItemToUpdate = new List<Custom_Item__c>();
        List<Standardized_Item__c> stanToUpdate = new List<Standardized_Item__c>();
        for(Opportunity os : opportunities){
            if(os.Generate_M_AFS__c != oldOpportunities.get(os.Id).Generate_M_AFS__c){
                if(!os.Generate_M_AFS__c){
                    oppIdsMale.add(os.Id);
                }
            }
            if(os.Generate_AFS__c != oldOpportunities.get(os.Id).Generate_AFS__c){
                if(!os.Generate_AFS__c){
                    oppIdsFeMale.add(os.Id);
                }
            }
        }
        system.debug('oppIdsMale' +oppIdsMale);
        if(oppIdsMale.size() > 0){
            //manage the Order Size for the Custom Items
            Set<Id> setCustomItems = new Set<Id>();
            List<Custom_Item__c> boyCustomITem = CustomItemDAO.getCustomItem(oppIdsMale,Constants.BOY);
            //get all custom items 
            for(Custom_Item__c cus : boyCustomITem){
                
                setCustomItems.add(cus.Id);
            }
            //fill map with Order Size
            if(setCustomItems.size() > 0){
                Map<Id,List<order_sizes__c>> mapCIOS = new Map<Id,List<order_sizes__c>>();
                List<order_sizes__c> listOS = OrderSizesDAO.getOrderSizes(setCustomItems);
                for(Id cID : setCustomItems){
                    List<order_sizes__c> tempList = new List<order_sizes__c>();
                    for(order_sizes__c osRec : listOS){
                        if(osRec.Order__c == cID){
                            tempList.add(osRec);
                        }
                    }
                    mapCIOS.put(cID,tempList);
                    
                }
                //get Custom Items to update
                for(Custom_Item__c cs : CustomItemDAO.getCustomItem(oppIdsMale,Constants.BOY) ){
                    
                    if(mapCIOS.containskey(cs.Id) && mapCIOS.get(cs.Id).size() > 0){
                        Custom_Item__c cust = new Custom_Item__c();
                        cust.Id = cs.Id;
                        cust.Pushed_to_AFS__c = false;
                        custItemToUpdate.add(cust);
                    }
                }
            }
			
			//manage the Order Size for the Standardized Items            
            Set<Id> setStdItems = new Set<Id>();
            for(Standardized_Item__c cus : StandardizedItemDAO.getStandardizedItem(oppIdsMale)){
                
                setStdItems.add(cus.Id);
            }
            
            //fill map with Order Size
            if(setStdItems.size() > 0){
                Map<Id,List<order_sizes__c>> mapSIOS = new Map<Id,List<order_sizes__c>>();
                List<order_sizes__c> listOS = OrderSizesDAO.getOrderSizesWithStandardOrder(setStdItems);
                for(Id cID : setStdItems){
                    List<order_sizes__c> tempList = new List<order_sizes__c>();
                    for(order_sizes__c osRec : listOS){
                        if(osRec.standard_order__c == cID){
                            tempList.add(osRec);
                        }
                    }
                    mapSIOS.put(cID,tempList);
                    
                }
                //get Standardized Items to update
                for(Standardized_Item__c cs : StandardizedItemDAO.getStandardizedItem(oppIdsMale)){
                    if(mapSIOS.containskey(cs.Id) && mapSIOS.get(cs.Id).size() > 0){
                        
                        Standardized_Item__c cust = new Standardized_Item__c();
                        cust.Id = cs.Id;
                        cust.Pushed_to_AFS__c = false;
                        stanToUpdate.add(cust);
                    }
                }
            }
            
        }
         system.debug('oppIdsFeMale '+oppIdsFeMale);
          if(oppIdsFeMale.size() > 0){
              
              //manage the Order Size for the Custom Items
              Set<Id> setCustomItemF = new Set<Id>();
              List<Custom_Item__c> girlCustomITem = CustomItemDAO.getCustomItem(oppIdsFeMale,Constants.GIRL);
              for(Custom_Item__c cus :girlCustomITem){
                  
                  setCustomItemF.add(cus.Id);
              }
              //fill map with Order Size
              if(setCustomItemF.size() > 0){
                  
                  Map<Id,List<order_sizes__c>> mapCIOSF = new Map<Id,List<order_sizes__c>>();
                  List<order_sizes__c> listOS = OrderSizesDAO.getOrderSizes(setCustomItemF);
                  for(Id cID : setCustomItemF){
                      List<order_sizes__c> tempList = new List<order_sizes__c>();
                      for(order_sizes__c osRec : listOS){
                          if(osRec.Order__c == cID){
                              tempList.add(osRec);
                          }
                      }
                      mapCIOSF.put(cID,tempList);
                      
                  }
                  //get Custom Items to update
                  for(Custom_Item__c cs :CustomItemDAO.getCustomItem(oppIdsFeMale,Constants.GIRL)){
                      if(mapCIOSF.containskey(cs.Id) && mapCIOSF.get(cs.Id).size() > 0){
                          Custom_Item__c cust = new Custom_Item__c();
                          cust.Id = cs.Id;
                          cust.Pushed_to_AFS__c = false;
                          custItemToUpdate.add(cust);
                      }
                  }
              }
              
              
              //manage the Order Size for the Standardized Items
              Set<Id> setStdItemF = new Set<Id>();
              for(Standardized_Item__c cus : StandardizedItemDAO.getStandardizedItem(oppIdsFeMale)){
                  
                  setStdItemF.add(cus.Id);
              }
              //fill map with Order Size
              if(setStdItemF.size() > 0){
                  Map<Id,List<order_sizes__c>> mapSIOSF = new Map<Id,List<order_sizes__c>>();
                  List<order_sizes__c> listOS = OrderSizesDAO.getOrderSizesWithStandardOrder(setStdItemF);
                  for(Id cID : setStdItemF){
                      List<order_sizes__c> tempList = new List<order_sizes__c>();
                      for(order_sizes__c osRec : listOS){
                          if(osRec.standard_order__c == cID){
                              tempList.add(osRec);
                          }
                      }
                      mapSIOSF.put(cID,tempList);
                      
                  }
                  //get Standardized Items to update
                  for(Standardized_Item__c cs :StandardizedItemDAO.getStandardizedItem(oppIdsFeMale)){
                      
                      if(mapSIOSF.containskey(cs.Id) && mapSIOSF.get(cs.Id).size() > 0){
                          Standardized_Item__c cust = new Standardized_Item__c();
                          cust.Id = cs.Id;
                          cust.Pushed_to_AFS__c = false;
                          stanToUpdate.add(cust);
                      }
                  }
              }
          }
       	system.debug('end afs '+limits.getQueries());
        if(custItemToUpdate.size() > 0){
            Util.BypassAllTriggers = true;
            update custItemToUpdate;
            Util.BypassAllTriggers = false;
        }
        
        if(stanToUpdate.size() > 0){
            Util.BypassAllTriggers = true;
           // update stanToUpdate;
            Util.BypassAllTriggers = false;
        }
    }
  private String collection(String start) {
    return ((start == null || start == 'N/A')
      ? '' : start);
  }

  private String ifNull(String str) {
    return str != null ? str : '';
  }
public static void updateReleatedItems(List<Opportunity> opps, Map<Id,Opportunity> oldOpps) {
    system.debug('after update  updateReleatedItems');
    system.debug('first items '+limits.getQueries());
        Set<Id> oppsId = new Set<Id>();
    Set<Id> oppsIdFalse = new Set<Id>();
        Map<Id,Id> mapCustomItemIdWithStyle = new Map<Id,Id>();
        Map<Id,Id> mapStandardItemIdWithStyle = new Map<Id,Id>();
        
        List<custom_Item__c> custToBeUpdate = new List<custom_Item__c>();
        List<Standardized_Item__c> standToBeUpdate = new List<Standardized_Item__c>();
        
        for(Opportunity op : opps){
            if(op.No_Length_Adjustments_Female__c != oldOpps.get(op.Id).No_Length_Adjustments_Female__c || op.No_Length_adjustments__c != oldOpps.get(op.Id).No_Length_adjustments__c){
                if(op.No_Length_adjustments__c == true || op.No_Length_Adjustments_Female__c == true){
                    oppsId.add(op.Id);
                }else if(op.No_Length_adjustments__c == false || op.No_Length_Adjustments_Female__c == false){
                    oppsIdFalse.add(op.Id);
                }
            }
        }
    
    system.debug('ioos Id '+oppsId);
        if(oppsId.size() > 0){
            List<Custom_Item__c> customItems = CustomItemDAO.getCustomItemWithStyle(oppsId);
            List<Standardized_Item__c> standardItems = StandardizedItemDAO.getStandardizedItemWithStyle(oppsId);
            
            for(Fit__c ft : [select id,name from Fit__c]){
                
                for(Custom_Item__c str : customItems){
                    if(string.isNotBlank(str.style__c)){
                        List<String> fitDet = str.style__c.split('-');
                        if(ft.Name.contains(fitDet[0].trim()) && ft.Name.startsWith('X')){
                            mapCustomItemIdWithStyle.put(str.Id,ft.id);
                        }
                    }
                }
                for(Standardized_Item__c str : standardItems){
                    if(string.isNotBlank(str.style__c)){
                        List<String> fitDet = str.style__c.split('-');
                        if(ft.Name.contains(fitDet[0].trim()) && ft.Name.startsWith('X')){
                            mapStandardItemIdWithStyle.put(str.Id,ft.id);
                        }
                    }
                }
            }
            for(String str : mapCustomItemIdWithStyle.keyset()){
                Custom_Item__c cust = new custom_Item__C();
                cust.Id = str;
                cust.fit__c = mapCustomItemIdWithStyle.get(str);
                custToBeUpdate.add(cust);
            }
            
            for(String str : mapStandardItemIdWithStyle.keyset()){
                Standardized_Item__c cust = new Standardized_Item__c();
                cust.Id = str;
                cust.fit__c = mapStandardItemIdWithStyle.get(str);
                standToBeUpdate.add(cust);
            }
            if(custToBeUpdate.size() > 0){   
                update custToBeUpdate;
            }
            if(standToBeUpdate.size() > 0){
                update standToBeUpdate;
            }
        }
    system.debug('oppsIdFalse--- '+oppsIdFalse);
    if(oppsIdFalse.size() > 0){
            List<Custom_Item__c> customItems = CustomItemDAO.getCustomItemWithStyle(oppsIdFalse);
            List<Standardized_Item__c> standardItems = StandardizedItemDAO.getStandardizedItemWithStyle(oppsIdFalse);
            
            for(Fit__c ft : [select id,name from Fit__c]){

                for(Custom_Item__c str : customItems){
                    if(string.isNotBlank(str.style__c)){
                        List<String> fitDet = str.style__c.split('-');
                        if(ft.Name.contains(fitDet[0].trim()) && !ft.Name.startsWith('X')){
                            mapCustomItemIdWithStyle.put(str.Id,ft.id);
                        }
                    }
                }
                system.debug('map cust '+mapCustomItemIdWithStyle);
                for(Standardized_Item__c str : standardItems){
                    if(string.isNotBlank(str.style__c)){
                        List<String> fitDet = str.style__c.split('-');
                        if(ft.Name.contains(fitDet[0].trim()) && !ft.Name.startsWith('X')){
                            mapStandardItemIdWithStyle.put(str.Id,ft.id);
                        }
                    }
                }
            }
            for(String str : mapCustomItemIdWithStyle.keyset()){
                Custom_Item__c cust = new custom_Item__C();
                cust.Id = str;
                cust.fit__c = mapCustomItemIdWithStyle.get(str);
                custToBeUpdate.add(cust);
            }
            
            for(String str : mapStandardItemIdWithStyle.keyset()){
                Standardized_Item__c cust = new Standardized_Item__c();
                cust.Id = str;
                cust.fit__c = mapStandardItemIdWithStyle.get(str);
                standToBeUpdate.add(cust);
            }
        
        system.debug('contact ot bupdate '+custToBeUpdate);
            if(custToBeUpdate.size() > 0){   
                update custToBeUpdate;
            }
            if(standToBeUpdate.size() > 0){
                update standToBeUpdate;
            }
        }
    system.debug('end items '+limits.getQueries());
    }
    
      // Funtion to upedate Order Referral processed checkbox of account associated with Opportunity  and update 
    // 'Number of production referral' of account which is referrar of account associated with opportunity. 
    
   /* public void updateAccountReferralProduction(List<Opportunity> newOpp, Map<Id,Opportunity> oldOpp)
    {
        if(newOpp.size()>0)
        {
            Set<Id> accIds = new Set<Id>();
            for(Opportunity opp : newOpp)
            {
                if(opp.StageName == 'Closed - Paid' && oldOpp.get(opp.Id).StageName != 'Closed - Paid' && String.isNotBlank(opp.AccountId) && opp.Collection_Picklist__c != 'None')
                {
                    accIds.add(opp.AccountId);
                }
            }
            if(accIds.size()>0)
            {
                List<Account> accountsTObeUpdate = new List<Account>();
                List<Account>referrerAccountToBeUpdate = new List<Account>();
                Set<Id> referreAccount = new Set<Id>();
                for(Account acc : [SELECT Id, Name, Affiliate_Gym_Referrer__c, Order_Referral_Processed__c, (SELECT Id FROM Opportunities WHERE StageName ='Closed - Paid') FROM Account WHERE Id IN: accIds])
                {
                    // check for multiple closepaid opportunity, Affiliate gym referre field and order referral
                    if( acc.Opportunities.size()==1 && String.isNotBlank(acc.Affiliate_Gym_Referrer__c) && (!acc.Order_Referral_Processed__c))
                    {
                        acc.Order_Referral_Processed__c = true;
                        referreAccount.add(acc.Affiliate_Gym_Referrer__c);
                        accountsTObeUpdate.add(acc);
                    }
                }
                for(Account referrerAccount : [SELECT Id, Name, Number_of_Production_Referral__c FROM Account WHERE Id IN: referreAccount])
                {
                    referrerAccount.Number_of_Production_Referral__c += 1;
                    referrerAccountToBeUpdate.add(referrerAccount);
                }
                Util.BypassAllTriggers = true;
                update accountsTObeUpdate;
                update referrerAccountToBeUpdate;
                Util.BypassAllTriggers = false;
            }
        }
    }*/
    
    
    
    public static void invokeApprovalProcessForOpportunity(List<Opportunity> newOpportunities,Map<Id,Opportunity> oldOpportunities){
        for(Id oppId : oldOpportunities.keySet())
        {
            System.debug('map old value is : '  + oldOpportunities.get(oppId));
            System.debug('opp Bd checkbox value in old map are : ' + oldOpportunities.get(oppId).Business_Development_Approval_Checkbox__c);
            System.debug('opp Bd picklist value in old map are : ' + oldOpportunities.get(oppId).Business_Development__c);
            
        }
        for(Opportunity opp : newOpportunities)
        {
            System.debug('Your opp value are : ' + opp);
            System.debug('opp Bd checkbox value in new are : ' + opp.Business_Development__c);
            System.debug('opp Bd picklist value in new are : ' + opp.Business_Development_Approval_Checkbox__c);
            
        }
        Set<Id> oppIdsFeMale = new Set<Id>();
        Id currentUserId = userinfo.getUserId();
        System.debug('current user id is : ' + currentUserId);
        Boolean isProcess = false;
        String userRoleLabel = System.Label.BussinessDevelopmentUsers;
        Set<String> usersName = new Set<String>();
        
        if(userRoleLabel != null)
        {
            for(String str : userRoleLabel.split(','))
            {
                usersName.add(str);
            }
        }
        if(usersName.size()>0)
        {
            List<User> users = UsersDAO.getUsers(usersName);
            System.debug('total number of specific users are : ' + users);
            System.debug('total numerb of users are : ' +users.size());
            if(users.size() > 0){
                for(User us : users){
                    System.debug('candace heckman user id is :'+us.Id);
                    if(currentUserId == us.Id){
                        isProcess = true;
                    }
                }
            }
        }
        
    
        System.debug('value of isPRocess is : '  + isProcess);
        if(isProcess){
            for(Opportunity opp : newOpportunities){         
                if(currentUserId == opp.OwnerId && opp.Business_Development_Approval_Checkbox__c == true
                   && opp.Business_Development_Approval_Checkbox__c != oldOpportunities.get(opp.Id).Business_Development_Approval_Checkbox__c){
                       if(opp.Account_Owner__c != opp.OwnerId){
                           Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                           approvalRequest.setComments('Offer Submitted for approval');
                           approvalRequest.setObjectId(opp.Id);
                           approvalRequest.setNextApproverIds(new List<Id>{opp.Account_Owner__c});
                           system.debug('approvalResult--'+approvalRequest);
                           Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
                           sendMail(opp.Id);
                           opp.Approval_for_BD__c = true;
                           opp.Business_Development__c = oldOpportunities.get(opp.Id).Business_Development__c;
                           
                       }                       
                   }else{
                       if(opp.Business_Development_Approval_Checkbox__c == true
                          && opp.Business_Development_Approval_Checkbox__c != oldOpportunities.get(opp.Id).Business_Development_Approval_Checkbox__c){
                              Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                              approvalRequest.setComments('Offer Submitted for approval');
                              approvalRequest.setObjectId(opp.Id);
                              approvalRequest.setNextApproverIds(new List<Id>{opp.OwnerId});
                              
                           system.debug('approvalResult11--'+approvalRequest);
                              Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
                              opp.Approval_for_BD__c = true;
                              opp.Business_Development__c = oldOpportunities.get(opp.Id).Business_Development__c; 
                              
                          }
                   }
            }
            }
        else{
            for(Opportunity opp : newOpportunities){
                if(opp.Business_Development_Approval_Checkbox__c == true
                   && opp.Business_Development_Approval_Checkbox__c != oldOpportunities.get(opp.Id).Business_Development_Approval_Checkbox__c){
                       if(currentUserId != opp.OwnerId){
                           Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                           approvalRequest.setComments('Offer Submitted for approval');
                           approvalRequest.setObjectId(opp.Id);
                           approvalRequest.setNextApproverIds(new List<Id>{opp.OwnerId});
                           system.debug('opp.Id---'+opp.Id);
                           system.debug('opp.OwnerId---'+opp.OwnerId);
                           system.debug('approvalRequest---'+approvalRequest);
                           Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
                           opp.Business_Development__c = oldOpportunities.get(opp.Id).Business_Development__c;
                           opp.Approval_for_BD__c = true;
                           
                           if(opp.BD_status__c == 'Rejected')
                           {
                               for(Id oppId : oldOpportunities.keySet())
                               {
                                   if(opp.Id == oldOpportunities.get(oppId).Id)
                                   {
                                       opp.Business_Development__c = oldOpportunities.get(oppId).Business_Development__c;
                                       
                                   }
                                   
                               }
                           }
                           
                       }
                   }
                
            }                    
        }
           
        /*for(Opportunity opp : newOpportunities){
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            approvalRequest.setComments('Offer Submitted for approval');
            approvalRequest.setObjectId(opp.Id);
            approvalRequest.setNextApproverIds(new List<Id>{'0056u000000P3fg'});
            Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
        }*/
        
        /*Set<Id> oppOwnerIds = new Set<Id>();
        Set<Id> oppIdsFeMale = new Set<Id>();
        Map<Id,Id> mapOfOppIdWithOwnerId = new Map<Id,Id>();
        Id currentUserId = userinfo.getUserId();
        Boolean isProcess = false;
        List<User> users = [SELECT Id, Name FROM USER WHERE Name = 'Candace Heckman'];
        if(users.size() > 0){
            for(User us : users){
                System.debug('candace heckman user id is :'+us.Id);
                if(currentUserId == us.Id){
                    isProcess = true;
                }
            }
        }
        if(isProcess){
            for(Opportunity opp : newOpportunities){
                System.debug('current user id is : ' + currentUserId);
                System.debug('opportunity owner id is : ' + opp.OwnerId);
                System.debug('BDA checked box for new trigger is : '+ opp.Business_Development_Approval_Checkbox__c);
                System.debug('BDA checkbox for old map is : ' + oldOpportunities.get(opp.Id).Business_Development_Approval_Checkbox__c);
                
                if(currentUserId == opp.OwnerId && opp.Business_Development_Approval_Checkbox__c == true
                   && opp.Business_Development_Approval_Checkbox__c != oldOpportunities.get(opp.Id).Business_Development_Approval_Checkbox__c){
                       
                    System.debug('account owner name is : '+opp.Account_Owner__c);
                    mapOfOppIdWithOwnerId.put(opp.Id,opp.Account_Owner__c);
                    oppOwnerIds.add(opp.Id);
                }else{
                    oppIdsFeMale.add(opp.Id);
                    mapOfOppIdWithOwnerId.put(opp.Id,opp.OwnerId);
                }
            }
            
            if(oppOwnerIds.size() > 0){
                System.debug('your user name as well as opp owner name is same so account owner will get the approval request');
                for(Id oppIds : mapOfOppIdWithOwnerId.keyset()){
                    System.debug('map key are : ' + oppIds);
                    
                    Id temp = mapOfOppIdWithOwnerId.get(oppIds);
                    System.debug('map key value are : ' + temp);
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setComments('Offer Submitted for approval');
                    approvalRequest.setObjectId(oppIds);
                    
                    approvalRequest.setNextApproverIds(new List<Id>{temp});
                    Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
                    System.debug('offer submitted for approval successfully: '+approvalResult .isSuccess());
                }
            }
            else if(oppIdsFeMale.size() > 0){
            }
        }*/    
    }
    
   
    
    public static void approvalCheckOnAccount(List<Opportunity> newOpportunities,Map<Id,Opportunity> oldOpportunities)
    {
        Id currentUserId = userinfo.getUserId();
        Boolean isProcess = false;
        String userRoleLabel = System.Label.BussinessDevelopmentUsers;
        Set<String> usersName = new Set<String>();
        
        if(userRoleLabel != null)
        {
            for(String str : userRoleLabel.split(','))
            {
                usersName.add(str);
            }
        }
        if(usersName.size()>0)
        {
            List<User> users = UsersDAO.getUsers(usersName);
            System.debug('total number of specific users are : ' + users);
            System.debug('total numerb of users are : ' +users.size());
            if(users.size() > 0){
                for(User us : users){
                    System.debug('candace heckman user id is :'+us.Id);
                    if(currentUserId == us.Id){
                        isProcess = true;
                    }
                }
            }
        }
        
        
        Set<Id> setOfOppReady = new Set<Id>();
        List<Opportunity> listOfOpp = new List<Opportunity>();
        Set<Id> setOfAccId = new Set<Id> ();
        List<Account> listAcc = new List<Account> ();
        Set<Id> listToUpdateOpp = new Set<Id>();
        List<Account> listOfAcc = new List<Account> ();
        
        if(isProcess)
        {
            for(Opportunity opp : newOpportunities)
            {
                
                System.debug('new opportunity which you want to insert are : ' + opp);
                System.debug('new opportunity can be inserted or not : ' + opp.Account.Opp_Approval__c);
                System.debug('user name is  : ' + currentUserId);
                if((opp.Account.Opp_Approval__c == false) &&(opp.Account_Owner__c != opp.OwnerId))
                {
                    System.debug(opp + ' is having a account checked box false');
                    Id Temp = opp.Account.OwnerId;
                    System.debug('account owner id in temp is  : '  + Temp);
                    System.debug('account id in temp is  : '  + opp.AccountId);
                    System.debug('account checkbox is  : '  + opp.Account.Opp_Approval__c);
                    //System.assert(false,opp);
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setComments('Send to account owner for Approval');
                    approvalRequest.setObjectId(opp.Id);
                    approvalRequest.setNextApproverIds(new List<Id>{opp.Account_Owner__c});
                    Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
                    
                    System.debug('appproval request is  :  ' + approvalResult);
                    if(approvalResult.isSuccess() && opp!=NULL)
                    {
                        
                        System.debug('checkbox on account is : ' +opp.Account.Opp_Approval__c);
                        //opp.Account.Opp_Approval__c = true;
                        setOfAccId.add(opp.AccountId);
                    }
                }
                else
                {
                    setOfOppReady.add(opp.Id);        
                    System.debug(opp + ' is having a account checked box true');
                    listOfOpp.add(opp);
                }
                
            }
        }
        
        
        if(setOfAccId != NULL)
        {
            for(Account acc : AccountDAO.getAccounts(setOfAccId))
            {
                System.debug('opp approver are : '  + acc.Opp_Approval__c);
                acc.Opp_Approval__c = true;
                System.debug('opp approver are : '  + acc.Opp_Approval__c);
                listAcc.add(acc);
            }
        }
        if(listAcc!=NULL)
        {
            update listAcc;
        }
        
        if(listOfOpp != NULL){
            System.debug('your opportunity is being ccreated ' + listOfOpp);
            
            /*for(Id ids : setOfOppReady){
                Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                approvalRequest.setComments('Offer Submitted for approval');
                approvalRequest.setObjectId(ids);
                approvalRequest.setNextApproverIds(new List<Id>{ids});
                Approval.ProcessResult approvalResult = Approval.process(approvalRequest);                
            }*/            
        }
        
        for(Account acc : listAcc)
        {
            System.debug('account checkbox field is : ' + acc.Opp_Approval__c);
            if(acc.Opp_Approval__c == true)
            {
               acc.Opp_Approval__c = false;
                listOfAcc.add(acc);
            }            
        }
        if(listOfAcc != NULL)
        {
            update listOfAcc;
        }
    }
        
    public static void approvalRejectMethod(List<Opportunity> newOpportunities,Map<Id,Opportunity> oldOpportunities)
    {
        System.debug('YOu are updating');
        List<Opportunity> listOfOpp = new List<Opportunity>();
        Map<String, Opportunity> mapOfOpp = new map<String, Opportunity> ();
        String accOwnerId;
        for(Opportunity opp : newOpportunities)
        {
            //System.assert(false,opp.Business_Development_Approval_Checkbox__c);
            System.debug('your bd status value is : ' + opp.BD_status__c);
            if((opp.BD_status__c == 'Rejected') &&(opp.Approval_for_BD__c == false))
            {
                System.debug('your approval request has been rejected and also you need to change its owner');
                System.debug('opp accont owner name uis : ' + opp.Account.Owner.Name);
                System.debug('opp owner id is : ' + opp.OwnerId);
                /*System.debug('opp account ownern id is : ' + opp.AccountId);
                
                opp.OwnerId = opp.Account.OwnerId;
                System.debug('account owner id is : ' + opp.Account.Owner);*/
                System.debug(opp.Account_Owner__c);
                accOwnerId = opp.Account_Owner__c;
                mapOfOpp.put(opp.Account_Owner__c, opp);
            }
            
            
        }
        if((mapOfOpp != null)&&(accOwnerId != NULL)){
            for(User obj : UsersDAO.getUsersById(accOwnerId))
            {
                System.debug('the account owner name us  : ' + obj.Name);
                System.debug('the account owner id is : ' + obj.Id);
                System.debug(mapOfOpp.get(accOwnerId));
                Opportunity opp = mapOfOpp.get(accOwnerId);
                opp.OwnerId = obj.Id;
            }
        }
    }
    
    
    public static void opportunityShareDelete(List<Opportunity> newOpportunities,Map<Id,Opportunity> oldOpportunities)
    {
	/*
        Id currentUserId = userinfo.getUserId();
        System.debug('current user id is : ' + currentUserId);
        Boolean isProcess = false;
        List<OpportunityShare> listOfOppShare = new List<OpportunityShare>();
        List<User> listOfUser = new List<User>();
        List<Opportunity> listOfOpp = new List<Opportunity>();
        List<OpportunityTeamMember> listOfOppTM = new List<OpportunityTeamMember>();
        
        
        String userRoleLabel = System.Label.BussinessDevelopmentUsers;
        Set<String> usersName = new Set<String>();
        
        if(userRoleLabel != null)
        {
            for(String str : userRoleLabel.split(','))
            {
                usersName.add(str);
            }
        }
        
        if(usersName.size() > 0){
            List<User> users = [SELECT Id, Name FROM USER WHERE Name IN : usersName];
            System.debug('total number of specific users are : ' + users);
            System.debug('total numerb of users are : ' +users.size());
            if(users.size() > 0){
                for(User us : users){
                    System.debug('candace heckman user id is :'+us.Id);
                    if(currentUserId == us.Id){
                        isProcess = true;
                        listOfUser.add(us);
                    }
                }
            }
        }
        if(listOfUser!= NULL)
        {
            for(Opportunity opp : newOpportunities)
            {
                System.debug('opp bd status are : ' + opp.BD_status__c);
                if((opp.BD_status__c == 'Rejected')&&(opp.Approval_for_BD__c == false))
                {
                    listOfOpp.add(opp);
                }
            }
        }
        
        if(listOfOpp.size() > 0){
            String userLabel = System.Label.UnApproverIdList;
            Set<String> usersId = new Set<String>();
            
            if(userLabel != null)
            {
                for(String str : userLabel.split(','))
                {
                    usersId.add(str);
                }
            }
            if(usersId.size()>0)
            {
                for(OpportunityTeamMember opp : [select id,CreatedById, LastModifiedBy.Name,OpportunityAccessLevel, OpportunityId, TeamMemberRole from OpportunityTeamMember where OpportunityId IN : listOfOpp  AND CreatedById IN : usersId])
                {
                    System.debug('opp team member are : ' + opp);
                    listOfOppTM.add(opp);
                }
            }
            
            
            System.debug('opp team member that is gooing to delete are : ' + listOfOppTM);
            if(listOfOppTM != NULL)
            {
                delete listOfOppTM;
            }
            
            if(usersId.size()>0)
            {
                for(OpportunityShare oppSh : [SELECT Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel, LastModifiedById FROM OpportunityShare where OpportunityId IN : listOfOpp AND UserOrGroupId IN : usersId])
                {
                    listOfOppShare.add(oppSh);
                }  
            }
            
            
        System.debug('the opp share going to delete are : ' + listOfOppShare);
        if(listOfOppShare != NULL)
        {
            
            delete listOfOppShare;
        }
        }*/
        
    }
    
    public static void sendMail(Id oppId)
    {
        
        Id currentUserId = userinfo.getUserId();
        User us = UsersDAO.getUsersWithEmail(currentUserId);
        //Opportunity opp = [SELECT Id, Email FROM Opportunity WHERE Id  =: oppId];
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
        String email = us.Email;
		semail.setToAddresses( new String[] {UserInfo.getUserEmail()} );
		semail.setSubject('Sending an Approval Request to its Account Owner');
		semail.setPlainTextBody('Sorry, but you are not allowed to manipulate with Opportunity until it is approved, ask you account owner for approval');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
    }
    
    
    /**
    *
    * @description : we are using this method for inserting Bd picklist value of Bd user is inserting opp;
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 03/24/2022 - Deeptanshu Bharti
    *
    **/

    public static void forBdPicklistValueForBdUser(List<Opportunity> newOpportunities,Map<Id,Opportunity> oldOpportunities)
    {
       
        Set<Id> oppIdsFeMale = new Set<Id>();
        List<Opportunity> listOfOppToUpdate = new List<Opportunity>();
        Map<Id, Id> mapOfAccOppId = new Map<Id, Id>();
        Id currentUserId = userinfo.getUserId();
        System.debug('current user id is : ' + currentUserId);
        Boolean isProcess = false;
        String userRoleLabel = System.Label.BussinessDevelopmentUsers;
        Set<String> usersName = new Set<String>();
        List<String> pickListValuesList= new List<String>();
        if(userRoleLabel != null)
        {
            for(String str : userRoleLabel.split(','))
            {
                usersName.add(str);
            }
        }
        if(usersName.size()>0)
        {
            List<User> users = UsersDAO.getUsers(usersName);
            System.debug('total number of specific users are : ' + users);
            System.debug('total numerb of users are : ' +users.size());
            if(users.size() > 0){
                for(User us : users){
                    System.debug('candace heckman user id is :'+us.Id);
                    if(currentUserId == us.Id){
                        isProcess = true;
                    }
                }
            }
        }
        
         
        if(isProcess)
        {
            String str;
            Set<Id> setOfOppUpdateId = new Set<Id>();
            for(Opportunity opp : newOpportunities)
            {
                mapOfAccOppId.put(opp.AccountId,opp.Id);
                System.debug('the value in map are :  ' + mapOfAccOppId);
            }
            for(Account acc : AccountDAO.getAccountsWithX2021_Total_SO(mapOfAccOppId.keySet()))
            {
                System.debug('the account value is  : '  + acc);
                if((acc.X2021_Total_SO_Sales__c == null || acc.X2021_Total_SO_Sales__c <100)&&(acc!=NULL))
                {
                    System.debug('you are inside good account');
                    String uName = UserInfo.getFirstName();
                    Schema.DescribeFieldResult fieldResult = Opportunity.Business_Development__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    for( Schema.PicklistEntry pickListVal : ple){
                        System.debug('picklist value is : ' + pickListVal.getLabel());
                        pickListValuesList.add(pickListVal.getLabel());
                        str = pickListVal.getLabel();
                        Boolean b = str.containsIgnoreCase(uName);
                        system.debug('name '+b);
                        if(b){
                            setOfOppUpdateId.add(mapOfAccOppId.get(acc.Id));
                            System.debug('the opp if is L '+ mapOfAccOppId.get(acc.Id));
                            for(Opportunity opp : newOpportunities)
                            {
                                if(opp.Type == 'New Order'){
                                System.debug('opp value is : ' + opp);
                                System.debug('opp bussiness value is : ' + opp.Business_Development__c);
                                opp.Business_Development__c = str;
                                }
                                
                            }
                        }
                    }
                }
            }
            
            
            
            /*for(Opportunity opp : newOpportunities)
            {
                system.debug('account id --'+opp.AccountId);
                Account acc = [SELECT Id, Name, X2021_Total_SO_Sales__c FROM Account WHERE Id =: opp.AccountId];
                system.debug('account id --'+acc.X2021_Total_SO_Sales__c);
                //System.assert(false,acc.X2021_Total_SO_Sales__c);
                if((acc.X2021_Total_SO_Sales__c == null || acc.X2021_Total_SO_Sales__c <100)&&(acc!=NULL)){
                    String uName = UserInfo.getFirstName();
                    Schema.DescribeFieldResult fieldResult = Opportunity.Business_Development__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    for( Schema.PicklistEntry pickListVal : ple){
                        System.debug('picklist value is : ' + pickListVal.getLabel());
                        pickListValuesList.add(pickListVal.getLabel());
                        String str = pickListVal.getLabel();
                        Boolean b = str.containsIgnoreCase(uName);
                        system.debug('name '+b);
                        if(b){
                            opp.Business_Development__c = str;
                        }
                    } 
                }
                    
            }*/
        }
    }
    
    /**
    *
    * @description : we are using this method for updating the value of Bd approval checkbox when Bd picklist value is getting changed;
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 03/24/2022 - Deeptanshu Bharti
    *
    **/
    public static void bdApprovalCheckboxChanges(List<Opportunity> newOpportunities,Map<Id,Opportunity> oldOpportunities){
        Set<Id> setOfOppId = new Set<Id>();
        Map<Id,Opportunity> mapOfOpp = new Map<Id,Opportunity>();
        List<Opportunity> listOfOpp = new List<Opportunity>();
      
        for(Opportunity opp : newOpportunities){
            if((opp.Business_Development_Approval_Checkbox__c == true)&&(opp.Business_Development__c != oldOpportunities.get(opp.Id).Business_Development__c)){                
                setOfOppId.add(opp.Id);
            }
        }
        for(Opportunity opp : OpportunityDAO.getOpportunitys(setOfOppId)){
            opp.Business_Development_Approval_Checkbox__c = false;
            listOfOpp.add(opp);
        }
        if(listOfOpp.size()>0){
            update listOfOpp;
        }
    }
}