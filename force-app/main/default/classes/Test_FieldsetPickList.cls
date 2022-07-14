@isTest(seealldata = false)
public class Test_FieldsetPickList {

    @isTest
    static void test_unitTest() {
         
        Account accounts = new Account(name='Account', Type = 'Pro', Phone = '9685741452');
        insert accounts;
        
        Test.startTest();
        
        VisualEditor.DynamicPickList pickList;
        VisualEditor.DesignTimePageContext context;
		VisualEditor.DynamicPickListRows rows;
        VisualEditor.DataRow dataRows ;
        FieldsetPickList fieldPick = new FieldsetPickList(context);
        
        fieldPick.isValid('Account');
        
        fieldPick.getDefaultValue();

       	fieldPick.getValues();
        
        Test.stopTest();   
        
    }
    
}