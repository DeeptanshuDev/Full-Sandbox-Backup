/*
	Description  : Rating Component Controller class.
	Created By   : Abhinav Sharma
*/
public with sharing class RatingController {

    @AuraEnabled(cacheable=true)
    public static String saveRating(Id thisRecordId, Decimal newRating) {
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static String setMemo(Id thisRecordId, String memoString) {
		return null;
    }

    @AuraEnabled(cacheable=true)
    public static String getMemo(Id thisRecordId) {
        return null;
    }
    public class FLSPermissionCheck{
        @AuraEnabled public boolean rating = false;
        @AuraEnabled public boolean memo   = false;
    }

    @AuraEnabled(cacheable=true)
    public static FLSPermissionCheck getPermission(){
        return new FLSPermissionCheck();
    }
}