@isTest(seealldata = false)
public class Test_RatingController {
    
    @isTest
    static void test_saveRating() {
        Id recordId  = Id.valueOf('0011500001GEDVxAAP');
        String saveResult =  RatingController.saveRating(recordId, 2);
        System.assertEquals(null, saveResult);
    }
    
    @isTest
    static void test_setMemo() {
        Id recordId  = Id.valueOf('0011500001GEDVxAAP');
        String memoResult =  RatingController.setMemo(recordId, 'test');
        System.assertEquals(null, memoResult);
    }
    
    @isTest
    static void test_getMemo() {
        Id recordId  = Id.valueOf('0011500001GEDVxAAP');
        String memoResult =  RatingController.getMemo(recordId);
        System.assertEquals(null, memoResult);
    }
    
    @isTest
    static void test_getPermission() {
      	RatingController.getPermission();
    }
}