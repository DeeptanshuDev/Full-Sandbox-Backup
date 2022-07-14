@isTest
public class DragAndDropChatterFileControllerTest {
	@isTest
    static void ControllerConstructorTest(){
        Account fakeAccount = new Account(name = 'Account Plan Test123');
        insert fakeAccount;
        
        System.currentPageReference().getParameters().put('id', fakeAccount.Id);
 
        DragAndDropChatterFileController controller = new DragAndDropChatterFileController();
        System.assertEquals(fakeAccount.Id, controller.myId); 
    }
    
    @isTest
    static void DragAndUploadFileSuccessTest() {
        Account fakeAccount = new Account(name = 'Account Plan Test123');
        insert fakeAccount;
        
        string err = DragAndDropChatterFileController.saveFile('test.txt', 'aGVsbG8=', fakeAccount.Id);
        
        FeedItem item = [select Id, ParentId, ContentData, ContentFileName from FeedItem where ParentId=:fakeAccount.Id];
        System.assert(item != null);
        System.assert(err == null);
        String decodedData = EncodingUtil.base64Encode(item.ContentData);
        System.assertEquals('aGVsbG8=', decodedData);
        System.assertEquals('test.txt', item.ContentFileName);
    }
    
    
    @isTest
    static void DragAndUploadFileFailureTest() {
        string err = DragAndDropChatterFileController.saveFile('test.txt', 'aGVsbG8=', 'invalid');
        System.assert(err != null);
    }
}