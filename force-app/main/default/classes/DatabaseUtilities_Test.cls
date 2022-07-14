/**
*	Description		:	Apex Test class for . 
*
*	Created By		:   Abhinav Sharma
*
*	Created Date	:   10/12/2019
* 
*	Version			:   v1.0 - Created - CR - 00000046 - Abhinav Sharma         
**/
@isTest(seealldata = false)
private class DatabaseUtilities_Test {

    @isTest
    Static void test_unitMethod(){
    
        Test.startTest();
        //Insert and upsert Contact record
        Contact con = new Contact( Phone = '1234567123');
        DatabaseUtilities.createLog(Database.insert( new Contact[]{con, new Contact(Phone = '2456781231')}, false));
        DatabaseUtilities.createLog(Database.upsert( new Contact[]{con}, false));
        
         
        Contact con1 = new Contact( Phone = '1234567123');
        Database.SaveResult[] saveList = Database.insert( new Contact[]{con1}, false);
        Database.Error[] err = saveList[0].getErrors(); 
        DatabaseUtilities.errorHTMLLog(err);
        
        //Delete account record
        Account acc = new Account();
        acc.Name = 'Test Record';
        insert acc;
        DatabaseUtilities.createLog(Database.delete(new Account[]{acc}, false));
        
        
        Test.stopTest();
    }
}