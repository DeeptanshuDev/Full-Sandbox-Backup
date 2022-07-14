/*
 Description  : Field Set component design component field set options.
 Created By   : Abhinav Sharma
*/
global with sharing class FieldsetPickList extends VisualEditor.DynamicPickList{

    private VisualEditor.DesignTimePageContext context;

    global FieldsetPickList(VisualEditor.DesignTimePageContext context) {
        this.context = context;
    }

    global override Boolean isValid(Object attributeValue) {
        return true;
    }

    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(null, null);
        return defaultValue;
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        myValues.addRow(new VisualEditor.DataRow(null, null));
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();

        if(context != null && String.isNotBlank((context.entityName))) {
            Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(context.entityName);
            Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
            
            Map<String, Schema.FieldSet> fieldSetMap = describeSObjectResultObj.FieldSets.getMap();
            for (String fieldSetName : fieldSetMap.keySet()) {
                Schema.FieldSet fieldSet = fieldSetMap.get(fieldSetName);
                myValues.addRow(new VisualEditor.DataRow(describeSObjectResultObj.getLabel()+' - '+fieldSet.getLabel(),context.entityName+'.'+fieldSetName));
            }
    	}
        return myValues;
    }
}