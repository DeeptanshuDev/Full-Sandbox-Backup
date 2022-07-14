/**
    Description   :   
    Created By    :   Abhinav Sharma
    Created Date  :  
    Version       :   V1.0 Created
**/ 
public class UploadAthletesController 
{
    private Map<String, Schema.SObjectType> globalSchemaDesc  = Schema.getGlobalDescribe() ;
    private String[] csvFileLines{get;set;}
    
    public Id accId;
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    
    public List<Contact> existingAthletes{get;set;}
    public UploadAthletesController(ApexPages.StandardController standardController)
    {
        this.accId = ApexPages.currentPage().getParameters().get('id'); 
        csvFileLines = new String[]{};
        existingAthletes = new List<Contact>(); 
    }
    public pageReference importCSVFile(){
        try{
            List<Contact> athletes = new List<Contact>();
            
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n'); 
            
            for(Integer i=1;i<csvFileLines.size();i++){
                Contact athlete = new Contact();
                athlete.AccountId = accId;
                string[] csvRecordData = csvFileLines[i].split(',');
                athlete.FirstName = csvRecordData[0] ;             
                athlete.LastName = csvRecordData[1];
                athlete.Gender__c = csvRecordData[2];
                athlete.Fit_Freedom_type__c = 'Athlete';   
                athlete.Preferred_Phone__c = csvRecordData[3];
                athletes.add(athlete);   
            }
            insert athletes;
            existingAthletes.addAll(athletes);  
            PageReference page = new PageReference('/' + accId);
            page.setRedirect(true);
            return page; 
        }
        catch (Exception e)
        {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importing data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }  
        
        return null;
  }
    public pageReference back() 
    {   
        String idForNavigation;
        String objectprefix= globalSchemaDesc.get('Account').getDescribe().getKeyPrefix();
        
        if(String.isNotBlank(accId))
        {
            idForNavigation = accId;
        }   
        
        PageReference page = new PageReference('/' + idForNavigation);
        page.setRedirect(true);
        return page;  
    }   
}