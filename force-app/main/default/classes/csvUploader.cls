/** 
* 
* Description : Class for inserting record in shipping object based on csv file.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 01/28/2022
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/

public class csvUploader {
    
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public List<SCMC__Shipping__c> acclist{get;set;}
    public csvUploader(ApexPages.StandardController controller){
        csvFileLines = new String[]{};
        acclist = New List<SCMC__Shipping__c>(); 
      }
    
    /**
    *
    * @description : using this method we are fetching and inserting shipping record from csv file.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 01/28/2022 - Deeptanshu Bharti
    *
    **/
      public void importCSVFile(){
           try{
               csvAsString = csvFileBody.toString();
               csvFileLines = csvAsString.split('\n'); 
                
               for(Integer i=1;i<csvFileLines.size();i++){
                   SCMC__Shipping__c accObj = new SCMC__Shipping__c() ;
                   string[] csvRecordData = csvFileLines[i].split(',');
                   System.debug('sales order is :  ' + csvRecordData[0]);
                   String salesOrderNumber = csvRecordData[0];
                   SCMC__Sales_Order__c so = [SELECT Id FROM SCMC__Sales_Order__c WHERE Sales_Order_Number_Text__c =: csvRecordData[0]];
                   String soId = so.Id;
                   System.debug('sales order id is: '+ soId);
                   accObj.SCMC__Sales_Order__c= soId;  
                   System.debug('carrier :  ' + csvRecordData[1]);
                   accObj.SCMC__Carrier__c = csvRecordData[1];
                   System.debug('status :  ' + csvRecordData[2]);
                   accObj.SCMC__Status__c = csvRecordData[2];
                   
                   acclist.add(accObj);   
               }
            insert acclist;
            }
            catch (Exception e)
            {
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importing data. Please make sure input csv file is correct');
                ApexPages.addMessage(errorMessage);
            }  
      }

}