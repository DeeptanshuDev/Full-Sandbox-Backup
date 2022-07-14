public with sharing class TestUtilities {
	
	public Contact 		aContac			{get; set;}
	public Attachment 	aAttachment		{get; set;}
     public static Account CreateNewAccount(boolean CreateAndInsert) {
        // get the us corporate record type id
        return CreateNewAccount('US Corporate', CreateAndInsert);
    }
    
    public static Account CreateNewAccount(String RecordTypeLabel, boolean CreateAndInsert) {
        Account retAccount = new Account();
        retAccount.Name = 'TestHospital-' + crypto.getRandomInteger();

        if (CreateAndInsert)
            insert retAccount;
        
        return retAccount;
    }
	public void generateContact(){

	    this.aContac 				= new Contact();
	    this.aContac.firstName 		= 'Test';
	    this.aContac.LastName 		= 'Test'; 
	    
	    insert this.aContac;

	    this.aAttachment = new Attachment();
	    this.aAttachment.Body = Blob.valueOf('String');
	}
	
	public static TestUtilities generateTest(){
		TestUtilities e = new TestUtilities();
		e.generateContact();
		return e;
	}
}