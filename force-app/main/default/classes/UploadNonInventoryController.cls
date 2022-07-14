public class UploadNonInventoryController {
    
    @AuraEnabled
    public static String uploadNonInventoryData(String nonInventoryObjListString, String opportunityId) {
        Map<Id,Non_Inventory_item__c> mapOfEmailContent = new Map<Id,Non_Inventory_item__c>();
        try {
            List<NonInventoryDataWrapper> wrapperList = 
                (List<NonInventoryDataWrapper>) JSON.deserialize(nonInventoryObjListString, List<NonInventoryDataWrapper>.class);
            List<String> SONumberList = new List<String>();
            for(NonInventoryDataWrapper wrapper : wrapperList) {
                if(String.isNotBlank(wrapper.so)) {
                    SONumberList.add(wrapper.so.trim());
                }
            }
            
            Map<String, SCMC__Sales_Order__c> salesOrderNameMap = new Map<String, SCMC__Sales_Order__c>();
            Map<String, Opportunity> opportunityNameMap = new Map<String, Opportunity>();
            if(!SONumberList.isEmpty()) {
                for(SCMC__Sales_Order__c so :[SELECT Id, Name,Opportunity__c FROM SCMC__Sales_Order__c WHERE Name IN :SONumberList]) {
                    salesOrderNameMap.put(so.Name, so);
                }
            }
            
            List<Non_Inventory_item__c> nonInventoryItemListToInsert = new List<Non_Inventory_item__c>();
            for(NonInventoryDataWrapper wrapper : wrapperList) {
                if(String.isNotBlank(wrapper.so)){
                    Non_Inventory_item__c nonInventoryItem = new Non_Inventory_item__c();
                    nonInventoryItem.PackageTrackingNumber__c = wrapper.packageTrackingNumber;
                    nonInventoryItem.ShipToCompanyorName__c = wrapper.shipToCompanyorName;
                    nonInventoryItem.ShipToAttention__c = wrapper.shipToAttention;
                    nonInventoryItem.ShipToAddress1__c = wrapper.shipToAddress1;
                    nonInventoryItem.ShipToAddress2__c = wrapper.shipToAddress2;
                    nonInventoryItem.ShipToCountryTerritory__c = wrapper.shipToCountryTerritory;
                    nonInventoryItem.ShipToPostalCode__c = wrapper.shipToPostalCode;
                    nonInventoryItem.ShipToCityorTown__c = wrapper.shipToCityorTown;
                    nonInventoryItem.ShipToStateProvinceCounty__c = wrapper.shipToStateProvinceCounty;
                    nonInventoryItem.ShipToTelephone__c = wrapper.shipToTelephone;
                    nonInventoryItem.ShipToEmailAddress__c = wrapper.shipToEmailAddress;
                    nonInventoryItem.ShipToResidentialIndicator__c = wrapper.shipToResidentialIndicator;
                    nonInventoryItem.ShipmentInformationVoidIndicator__c = wrapper.shipmentInformationVoidIndicator;
                    nonInventoryItem.PackageWeight__c = wrapper.packageWeight;
                    nonInventoryItem.Inventory__c = wrapper.inventory;
                    nonInventoryItem.Non_Inventory__c = wrapper.nonInventory;
                    nonInventoryItem.PackageReference1__c = wrapper.packageReference1;
                    nonInventoryItem.PackageReference2__c = wrapper.packageReference2;
                    if(wrapper.carrier == '')
                    {
                        nonInventoryItem.Carrier__c = 'UPS';
                    }
                    else
                    {
                        nonInventoryItem.Carrier__c = wrapper.carrier;
                    }
                    if(String.isNotBlank(wrapper.so) && salesOrderNameMap.containsKey(wrapper.so)) {
                        nonInventoryItem.SO__c = salesOrderNameMap.get(wrapper.so).Id;
                    }
                    system.debug('salesOrderNameMap--'+salesOrderNameMap);
                    if(String.isNotBlank(wrapper.so) && salesOrderNameMap.containsKey(wrapper.so)) {
                        
                        nonInventoryItem.Opportunity__c = salesOrderNameMap.get(wrapper.so).Opportunity__c;
                        //System.assert(false,nonInventoryItem.Opportunity__c);
                        mapOfEmailContent.put(nonInventoryItem.Opportunity__c,nonInventoryItem);
                    }
                    nonInventoryItemListToInsert.add(nonInventoryItem);
                    
                }
            }
            
            if(!nonInventoryItemListToInsert.isEmpty())
            {
                insert nonInventoryItemListToInsert;
                //send(nonInventoryItemListToInsert);
            }
            
        } catch(Exception e) {
            throw new AuraHandledException('Error while insert Non Inventory Data' + e.getMessage() + e.getLineNumber());
        }
        
        return null;
    }
    
    public class NonInventoryDataWrapper {
        public String packageTrackingNumber;
        public String shipToCompanyorName;
        public String shipToAttention;
        public String shipToAddress1;
        public String shipToAddress2;
        public String shipToCountryTerritory;
        public String shipToPostalCode;
        public String shipToCityorTown;
        public String shipToStateProvinceCounty;
        public String shipToTelephone;
        public String shipToEmailAddress;
        public String shipToResidentialIndicator;
        public String shipmentInformationVoidIndicator;
        public String packageWeight;
        public String so;
        public String inventory;
        public String nonInventory;
        public String packageReference1;
        public String packageReference2;
        public String carrier;
    }
    
    /**
    *
    * @description : method is used to send email to so opp owner.
    *
    * @args :	Map<String,List<Non_Inventory_item__c>>
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 05/16/2022 - Deeptanshu Bharti
    *
    **/

    public static void sendMail(Map<Id,Non_Inventory_item__c> mapOfEmail){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Map<Id, Non_Inventory_item__c> mapOfSending = new Map<Id, Non_Inventory_item__c>();
        Map<String, String> mapOfCSI = new Map<String, String>();
        Non_Inventory_item__c ni = new Non_Inventory_item__c();
        for(Opportunity opp : [SELECT Id, Name, OwnerId FROM Opportunity WHERE Id IN : mapOfEmail.keySet()])
        {
            System.debug('the value of opp in email : ' + opp);
            System.debug('the opp owner is : ' + opp.OwnerId);
            mapOfSending.put(opp.OwnerId,mapOfEmail.get(opp.Id));
        }
        for(User us : [SELECT Id, Name, Email FROM User WHERE Id IN : mapOfSending.keySet()])
        {
            String isSuccess='';
            try{
                String OppId = us.Id;
                //System.assert(false,mapOfSending.get(OppId).Id);
                mapOfCSI.put('Name',mapOfSending.get(OppId).Name);
                //System.assert(false,mapOfCSI);
                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                String[] sendingTo = new String[]{us.Email};
                    semail.setToAddresses(sendingTo);
                /*String[] sendingToBccAdd = new String[]{'deeptanshu.bharti@fexle.com'};
                    semail.setBccAddresses(sendingToBccAdd);*/
                semail.setSubject('Custom Item Created');
                semail.setPlainTextBody('Hello!!!!!!!!!!This is a test email to test single email message program');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});     
                isSuccess='SUCCESS';
            }
            catch(Exception ex){
                isSuccess=ex.getMessage()+'\n'+ex.getLineNumber()+'\n'+ex.getCause()+'\n'+ex.getStackTraceString();
            }
        }                  
    }
    
    
}