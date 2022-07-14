/** 
* 
* Description : Class operating with nonInventoryTrigger.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 04/13/2022
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/

public class nonInventoryTriggerHandler {
    /**
    *
    * @description : this method is used to send email whenever non inventory item is created.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/13/2022 - Deeptanshu Bharti
    *
    **/
    public static void nonInventoryMail(List<Non_Inventory_item__c> newList, Map<Id, Non_Inventory_item__c> oldMap)
    {
        try{ 
            
            //Set<Id> setOfOppId = new Set<Id>();
            List<Id> listOfOppId = new List<Id>();
            Map<String,Non_Inventory_item__c> mapOfVal = new Map<String,Non_Inventory_item__c>(); 
            Map<String,Non_Inventory_item__c> mapOfVal2 = new Map<String,Non_Inventory_item__c>();
            Map<String, String> mapOfValues = new Map<String,String>();
            
            if(newList.size() > 0)
            {
                for(Non_Inventory_item__c obj : newList)
                {
                    System.debug('opp on this custom item shipment is  L: ' + obj);
                    if(obj.Opportunity__c != NULL)
                    {
                        sendMail(obj.Opportunity__c,obj);
                    }
                    
                }
            }
        }
        catch(DmlException e){
            List<Web_Service_Log__c> listOfWS = new List<Web_Service_Log__c>();
            Web_Service_Log__c ws = new Web_Service_Log__c();
            ws.Operation_Name__c = 'esignatureNotificationTriggerHandler Error';
            ws.Type__c = 'Others';
            ws.Response_Body__c = e.getMessage();
            listOfWS.add(ws);
            if(listOfWS!=NULL)
            {
                //System.assert(false,e.getMessage());
                insert listOfWS;
            }
        }
        
        
    }
    
    public static string getOpp(Id id)
    {
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Id =: id];
        return opp.Name;
    }
    public static string getSo(Id id)
    {
        SCMC__Sales_Order__c opp = [SELECT Id, Name FROM SCMC__Sales_Order__c WHERE Id =: id];
        return opp.Name;
    }
    
    
     /**
    *
    * @description : this method is used to send email.
    *
    * @args : Id,Non_Inventory_Item__c
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/13/2022 - Deeptanshu Bharti
    *
    **/
    public static void sendMail(Id opp, Non_Inventory_Item__c nII)
    {
        Opportunity oppor = [SELECT Id, Name, OwnerId FROM Opportunity WHERE Id =: opp];
        Id oppId = oppor.OwnerId;
        //system.assert(false,nII);
        System.debug('Sending Mail');
        System.debug('Opp value is : '+ oppId);
        System.debug('Non_Inventory_Item__c value is : '+ nII);
        Map<String, String> mapOfValues = new Map<String,String>();	
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        String oppName = getOpp(nII.Opportunity__c);
        String address;
        String soName = getSo(nII.SO__c);
        if(nII.ShipToAddress1__c != NULL)
        {
            address = nII.ShipToAddress1__c+', ';
        }
        if(nII.ShipToAddress2__c != NULL)
        {
            address = address+nII.ShipToAddress2__c+', ';
        }
        if(nII.ShipToCityorTown__c != NULL)
        {
            address = address+nII.ShipToCityorTown__c+', ';
        }
        if(nII.ShipToStateProvinceCounty__c != NULL)
        {
            address = address+nII.ShipToStateProvinceCounty__c+', ';
        }
        if(nII.ShipToCountryTerritory__c != NULL)
        {
            address = address+nII.ShipToCountryTerritory__c+' ';
        }
        
        mapOfValues.put('Custom Item Shipment Name', nII.Name);
        mapOfValues.put('Package Tracking Number', nII.PackageTrackingNumber__c);
        mapOfValues.put('Ship To Company or Name', nII.ShipToCompanyorName__c);
        mapOfValues.put('Ship To Attention', nII.ShipToAttention__c);
        mapOfValues.put('Address', address);
        mapOfValues.put('Opportunity Name', oppName);
        mapOfValues.put('Sales Order Number', soName);
        mapOfValues.put('Id', nII.Id);
        mapOfValues.put('Custom Items', nII.Non_Inventory__c);
        //System.assert(false,mapOfValues);
        
        for(User ur : [SELECT Id, Name, Email FROM User WHERE Id =: oppId])
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            sendTo.add(ur.Email);
            mail.setToAddresses(sendTo);
            // Step 3: Set who the email is sent from
            mail.setSenderDisplayName('Rebel');
            
            // (Optional) Set list of people who should be CC'ed
           /* List<String> ccTo = new List<String>();
            ccTo.add('deeptanshu.bharti@fexle.com');
            mail.setCcAddresses(ccTo);*/
            
            // Step 4. Set email contents - you can use variables!
            String sub = 'Custom Item Shipment Details for '+mapOfValues.get('Ship To Company or Name')+', '+mapOfValues.get('Sales Order Number');
            mail.setSubject(sub);
            String body = 'Here is the custom item shipment tracking details with ';
            body = body+ 'Package Tracking Number: '+'<br/>'+mapOfValues.get('Package Tracking Number');
            body = body+'<br/><br/>'+'Shipment Details: ';
            body = body+'<br/>'+'Ship To Company or Name: '+mapOfValues.get('Ship To Company or Name');
            body = body+'<br/>'+'Opportunity Name: '+mapOfValues.get('Opportunity Name');
            body = body+'<br/>'+'Sales Order Number: '+mapOfValues.get('Sales Order Number');
            body = body+'<br/>'+'Custom Items: '+mapOfValues.get('Custom Items');
            body = body+'<br/>'+'Address: '+mapOfValues.get('Address');
            
            mail.setHtmlBody(body);
            
            // Step 5. Add your email to the master list
            mails.add(mail); 
            System.debug('the value of mail is : ' + mail);
        }
        //System.assert(false,mails);
        Messaging.sendEmail(mails);
        
    }
    
}