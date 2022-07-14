public class SandboxCreateWrapper 
{
    public Create_Sandbox_Request__c cSRequest {get; set;}
    public String messageDetails {get; set;}
    public Integer statusCode {get; set;}
    public Boolean isSBCreateRequestSuccessive {get; set;}
    
    public SandboxCreateWrapper() 
    {
    	cSRequest = new Create_Sandbox_Request__c(); 
        isSBCreateRequestSuccessive = false;
    }
    
    public SandboxCreateWrapper(Create_Sandbox_Request__c cSRequest, String messageDetails, Integer statusCode) 
    {
    	this.cSRequest = cSRequest;
        this.messageDetails = messageDetails;
        this.statusCode = statusCode;
    }
}