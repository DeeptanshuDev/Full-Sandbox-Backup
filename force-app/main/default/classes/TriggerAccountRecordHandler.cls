/**
*  Description     :  Handler class of trigger 'TriggerAccountRecord' used to update shipping and billing
*                     address of contracts with associated account's shipping and billing address .
*
*  Created By      :  Chirag Soni
*
*  Created Date    :  23/12/2020
*
*  Revision Logs   :   V_1.0 - Created -- CR-00000161 
**/

public class TriggerAccountRecordHandler {
    
    public void preventPodtoChangeowner(List<Account> newAccount,Map<Id,Account> oldAccount){
        
        String currentUserId = UserInfo.getUserId();
        
        User usr = [SELECT Id, UserRole.name FROM User where Id =: currentUserId];
        System.debug('user is :' + usr);
        if(usr != null && string.isNotBlank(usr.UserRole.Name)){
            if(usr.UserRole.Name.startsWith('Pod Team Member') || usr.UserRole.Name.startsWith('Pod Rookie Member')){
                for(Account acc : newAccount){
                    if(oldAccount!= null && oldAccount.get(acc.Id).OwnerId != acc.OwnerId){
                        acc.addError('POD Team Member can not change the Account Owner');
                    }
                }
            }
            
        }
        
    }
    
    public void updateContractAddress(List<Account> newAccount, Map<Id,Account> oldAccount)
    {
        if(newAccount.size()>0 && oldAccount != null)
        {   
            List<Contract> contractListToBeUpdate = new List<Contract>();
            
            for(Account account : newAccount)
            {
                String newBillingAddress = account.BillingStreet+' '+account.BillingCity+', '+account.BillingState+' '+
                    account.BillingPostalCode+' '+account.BillingCountry;
                
                String oldBillingAddress = oldAccount.get(account.id).BillingStreet+' '+oldAccount.get(account.id).BillingCity+
                    ', '+oldAccount.get(account.id).BillingState+' '+oldAccount.get(account.id).BillingPostalCode+
                    ' '+oldAccount.get(account.id).BillingCountry;
                
                String newShippingAddress = account.ShippingStreet+' '+account.ShippingCity+', '+account.ShippingState+' '+
                    account.ShippingPostalCode+' '+account.ShippingCountry;
                
                String oldsShippingAddress = oldAccount.get(account.id).ShippingStreet+' '+oldAccount.get(account.id).ShippingCity+
                    ', '+oldAccount.get(account.id).ShippingState+' '+oldAccount.get(account.id).ShippingPostalCode+
                    ' '+oldAccount.get(account.id).ShippingCountry;   
                
                //------------ If both billing and shipping address changed -----------------------//
                if(newBillingAddress != oldBillingAddress && newShippingAddress != oldsShippingAddress)
                {
                    List<Contract> contractListBillingShipping = [SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                                                                  BillingCountry, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode,
                                                                  ShippingCountry FROM Contract WHERE AccountId  =: account.id];
                    if(contractListBillingShipping.size()>0)
                    {
                        for(Contract contract : contractListBillingShipping)
                        {   
                            //------------ for billing ---------------//
                            contract.BillingStreet = account.BillingStreet;
                            contract.BillingCity = account.BillingCity;
                            contract.BillingState = account.BillingState;
                            contract.BillingPostalCode = account.BillingPostalCode;
                            contract.BillingCountry = account.BillingCountry;
                            //------------ for shipping ---------------//
                            contract.ShippingStreet = account.ShippingStreet;
                            contract.ShippingCity = account.ShippingCity;
                            contract.ShippingState = account.ShippingState;
                            contract.ShippingPostalCode = account.ShippingPostalCode;
                            contract.ShippingCountry = account.ShippingCountry;
                            contractListToBeUpdate.add(contract);
                        }
                    }
                }
                //------------------ If only billing address changed ---------------------------//
                else  if(newBillingAddress != oldBillingAddress)
                {
                    List<Contract> contractListBilling = [SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                                                          BillingCountry FROM Contract WHERE AccountId =: account.id];
                    if(contractListBilling.size()>0)
                    {
                        for(Contract contract : contractListBilling)
                        {
                            contract.BillingStreet = account.BillingStreet;
                            contract.BillingCity = account.BillingCity;
                            contract.BillingState = account.BillingState;
                            contract.BillingPostalCode = account.BillingPostalCode;
                            contract.BillingCountry = account.BillingCountry;
                            contractListToBeUpdate.add(contract);
                        }
                    }
                    
                }
                //---------------------- If only shipping address changed -----------------------//
                else if(newShippingAddress != oldsShippingAddress)
                {
                    List<Contract> contractListShipping = [SELECT Id, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode,
                                                           ShippingCountry FROM Contract WHERE AccountId =: account.id];
                    if(contractListShipping.size()>0)
                    {
                        for(Contract contract : contractListShipping)
                        {
                            contract.ShippingStreet = account.ShippingStreet;
                            contract.ShippingCity = account.ShippingCity;
                            contract.ShippingState = account.ShippingState;
                            contract.ShippingPostalCode = account.ShippingPostalCode;
                            contract.ShippingCountry = account.ShippingCountry;
                            contractListToBeUpdate.add(contract);
                            
                        }
                    }
                    
                }
            }
            if(contractListToBeUpdate.size()>0)
            {     
                Util.BypassAllTriggers = true;
                update contractListToBeUpdate;
                Util.BypassAllTriggers = false;
            }    
            
        }   
    }      
}