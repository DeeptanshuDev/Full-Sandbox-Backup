/**
 *  Description     :  Handler class of trigger 'TriggerContract' used to populate shipping and billing
 *                     address of associated account when new contract is created and it shipping and billing address
 *                     fields are blank.
 *
 *  Created By      :  Chirag Soni
 *
 *  Created Date    :  23/12/2020
 *
 *  Revision Logs   :   V_1.0 - Created -- CR-00000161 
**/



public class TriggerContractHandler {
    
    public void addContractAddresses(List<Contract> newContract)
    {
        if(newContract.size()>0)
        {   
           
            Map<Id,List<Contract>> mapOfIdContract = new Map<Id,List<Contract>>();
            
            
            for(Contract contract : newContract)
            {
                if(String.isNotBlank(contract.AccountId))
                {
                    //--------------------- if both address sub-fields have some value -----------------//
                    if(!(contract.BillingStreet != null || contract.BillingCity != null || contract.BillingState != null 
                         || contract.BillingPostalCode != null)||!(contract.ShippingStreet != null || contract.ShippingCity != null || contract.ShippingState != null
                                                                   || contract.ShippingPostalCode != null))
                    {
                        if(mapOfIdContract.containsKey(contract.AccountId))
                        {
                            List<contract> contractList = mapOfIdContract.get(contract.AccountId);
                            contractList.add(contract);
                        }
                        else{
                            mapOfIdContract.put(contract.AccountId, new List<Contract>{contract});
                        }
                    }
                    
                    
                }
            }
            if(mapOfIdContract.size()>0 && mapOfIdContract!= null)
            {
                for( Id accID : mapOfIdContract.keyset())
                {
                    Account accountRecord = [SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                                             BillingCountry, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode,
                                             ShippingCountry FROM Account WHERE Id  =: accID];
                
                    for(Contract contract : mapOfIdContract.get(accID))
                    {
                        boolean isBillingBlank;
                        boolean isShippingBlank;    
                        if(contract.BillingStreet != null || contract.BillingCity != null || contract.BillingState != null 
                           || contract.BillingPostalCode != null)
                        {
                            isBillingBlank = false;
                        }
                        else
                        {
                            isBillingBlank = true;
                        }
                        if(contract.ShippingStreet != null || contract.ShippingCity != null || contract.ShippingState != null
                           || contract.ShippingPostalCode != null)
                        {
                            isShippingBlank = false;
                        }
                        else
                        {
                            isShippingBlank = true;
                        }
                        //------------ If both billing and shipping address are blank -----------------------//
                        if(isBillingBlank && isShippingBlank)
                        {   
                            //------------ for billing ---------------//
                            contract.BillingStreet = accountRecord.BillingStreet; 
                            contract.BillingCity = accountRecord.BillingCity;
                            contract.BillingState = accountRecord.BillingState;
                            contract.BillingPostalCode = accountRecord.BillingPostalCode;
                            contract.BillingCountry = accountRecord.BillingCountry;
                            //------------ for shipping ---------------//
                            contract.ShippingStreet = accountRecord.ShippingStreet;
                            contract.ShippingCity = accountRecord.ShippingCity;
                            contract.ShippingState = accountRecord.ShippingState;
                            contract.ShippingPostalCode = accountRecord.ShippingPostalCode;
                            contract.ShippingCountry = accountRecord.ShippingCountry;
                            
                            
                        }
                         //------------------ If only billing address is blank ---------------------------//
                        else if (isBillingBlank)
                        {
                            contract.BillingStreet = accountRecord.BillingStreet; 
                            contract.BillingCity = accountRecord.BillingCity;
                            contract.BillingState = accountRecord.BillingState;
                            contract.BillingPostalCode = accountRecord.BillingPostalCode;
                            contract.BillingCountry = accountRecord.BillingCountry;
                            
                            
                        }
                         //------------------ If only shipping address is blank ---------------------------//
                        else if (isShippingBlank)
                        {
                            contract.ShippingStreet = accountRecord.ShippingStreet;
                            contract.ShippingCity = accountRecord.ShippingCity;
                            contract.ShippingState = accountRecord.ShippingState;
                            contract.ShippingPostalCode = accountRecord.ShippingPostalCode;
                            contract.ShippingCountry = accountRecord.ShippingCountry;
                            
                        }
                    }
                }
               
            }
            
        }
    }
}