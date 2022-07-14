/*
	Description  : Search Component Controller class.
	Created By   : Abhinav Sharma
*/
public with sharing class SearchComponentController {

    public class Result{
        @AuraEnabled
        public List<Field> searchFields{get;set;}

        public Result(){
            this.searchFields = new List<Field>();
        }
    }

    @AuraEnabled
    public static Result RetrieveFieldSetData(String sObjectName, String fieldSetName) {
        
        //Get field describe from the QueryStructure
        QueryStructure qs = QueryStructure.create();
        qs.fromSObject(sObjectName);
        qs.addFieldSet(fieldsetName);

        Result fieldResult = new Result();
        fieldResult.searchFields.addAll(qs.getFieldsDescribe().values());

        //Set all fields to not sortable
        for(Field fld:fieldResult.searchFields){
            fld.setIsSortable(false);
        }

        //return field describe result
        return fieldResult;
    }
}