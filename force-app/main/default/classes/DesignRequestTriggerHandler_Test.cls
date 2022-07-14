/** 
* 
* Description : Test class for DesignRequestTriggerHandler.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 06/27/2022 
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/
 
@isTest (seeAllData=false)
public class DesignRequestTriggerHandler_Test {
    
    @TestSetup
    private static void setup() {
        Opportunity opp = TestData.opportunity(true);
        Design_Request__c dr = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),true);
                                                      
        Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
            Opportunity__c = opp.Id,
            Design_Request__c = dr.Id,
            Price_per_item__c = 0,
            Product_Style__c = 'Uniform'
        ),true);
        
        
        Account acco = new Account(Name = 'Test4585 Account'); 
        insert acco;
        
        Contact cont1 = new Contact(LastName='conTest1', Preferred_Phone__c='Phone', Email ='sandeep1@gmail.com', AccountId=acco.Id);
        insert cont1;
       
        Opportunity oppr = TestData.opportunity(true);
        oppr.AccountId = acco.Id;
        oppr.Primary_Contact__c = cont1.Id;
        update oppr;
        
    }
    /**
    *
    * @description : Test method for handling trigger
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/27/2022 - Deeptanshu Bharti
    *
    * coverage : 88%
    *
    **/
    static testMethod void myFirstMethod_Test()
    {
        Design_Request__c dr = [SELECT Id FROM Design_Request__c LIMIT 1];
        
        Test.startTest();
        
        dr.High_Priority_DR__c = True;
        update dr;
        Test.stopTest();
    }
    /**
    *
    * @description : Test method for handling trigger
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/27/2022 - Deeptanshu Bharti
    *
    * coverage : 88%
    *
    **/
    static testMethod void myThirdMethod_Test(){
        Design_Request__c dr = [SELECT Id FROM Design_Request__c LIMIT 1];
        dr.Special_Pricing_DR__c = True;
        update dr;
    }
    
    /**
    *
    * @description : Test method for handling trigger
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/27/2022 - Deeptanshu Bharti
    *
    * coverage : 88%
    *
    **/
    static testMethod void myFourthMethod_Test(){
        Design_Request__c dr = [SELECT Id FROM Design_Request__c LIMIT 1];
        dr.Special_Ops_DR__c = True;
        update dr;
    }
    
    /**
    *
    * @description : Test method for handling trigger
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/27/2022 - Deeptanshu Bharti
    *
    * coverage : 88%
    *
    **/
    static testMethod void myFifthMethod_Test(){
        Design_Request__c dr = [SELECT Id FROM Design_Request__c LIMIT 1];
        dr.Live_Design_DR__c = True;
        update dr;
    }
    
    /**
    *
    * @description : Test method for handling trigger
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/27/2022 - Deeptanshu Bharti
    *
    * coverage : 88%
    *
    **/
    static testMethod void mySecondMethod_Test()
    {
        Design_Request__c dr = [SELECT Id FROM Design_Request__c LIMIT 1];
        
        Test.startTest();
        
        dr.High_Priority_DR__c = True;
        dr.Special_Pricing_DR__c = True;
        dr.Special_Ops_DR__c = True;
        update dr;
        Test.stopTest();
    }
    
    
    /**
    *
    * @description : Test method for handling trigger
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/27/2022 - Deeptanshu Bharti
    *
    * coverage : 88%
    *
    **/
    static testMethod void myInsertFirstMethod_Test(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name =: 'Test4585 Account'];
        Contact con = [SELECT Id, Name FROM Contact LIMIT 1];
        Opportunity opp=[SELECT Id, Name FROM Opportunity WHERE AccountId =: acc.Id];
        Test.startTest();
        
        Design_Request__c designRequest = new Design_Request__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Primary_Contact__c = con.id,
            High_Priority_DR__c = true
        );
        insert designRequest;
        
        delete designRequest;
        Design_Request__c designRequest1 = new Design_Request__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Primary_Contact__c = con.id,
            Special_Pricing_DR__c = true
        );
        insert designRequest1;
        
        delete designRequest1;
        Design_Request__c designRequest2 = new Design_Request__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Primary_Contact__c = con.id,
            Live_Design_DR__c = true
        );
        insert designRequest2;
        
        delete designRequest2;
        Design_Request__c designRequest3 = new Design_Request__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Primary_Contact__c = con.id,
            Special_Ops_DR__c = true
        );
        insert designRequest3;
        Test.stopTest();
    }
}