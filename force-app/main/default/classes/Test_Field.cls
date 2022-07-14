@IsTest
public class Test_Field {
    public static List<Field.NamePoint> namePointList;
    public static List<Field.Option> optionList;
    
    @testSetup static void setup() {
        Field.Option optionObject = new Field.Option('Ajmer','Address');
        System.assertEquals('Ajmer',optionObject.value);
        System.assertEquals('Address',optionObject.label);
        optionObject = new Field.Option('Ajmer','Address',true);
        System.assertEquals('Ajmer',optionObject.value);
        System.assertEquals('Address',optionObject.label);
        System.assertEquals(true,optionObject.disabled);
        Field.NamePoint namePointObject = new Field.NamePoint('Expert__c','Expert');
        System.assertEquals('Expert__c',namePointObject.objectName);
        System.assertEquals('Expert',namePointObject.objectLabel);
        optionList = new List<Field.Option> ();
        optionList.add(optionObject);
        namePointList = new List<Field.NamePoint>();
        namePointList.add(namePointObject);
    }
    @IsTest static  void testFieldDataIntialize(){
        
        Schema.FieldSetMember fsMember;
        Field fl = new Field();
        fl = new Field('Address__c','Address','to store address','Text',true,true,true,'ajmer','ajmr'); 
        System.assertEquals('Address__c',fl.name);
        System.assertEquals('Address',fl.label);
        System.assertEquals('to store address',fl.help);
        System.assertEquals('Text',fl.type);
        System.assertEquals(true,fl.required);
        System.assertEquals(true,fl.viewable);
        System.assertEquals(true,fl.readOnly);
        System.assertEquals('ajmer',fl.value);
        System.assertEquals('ajmr',fl.displayValue);
        fl = new Field('Name','Address','Text',true,fsMember); 
        System.assertEquals('Name',fl.name);
        System.assertEquals('Address',fl.label);
        System.assertEquals(true,fl.viewable);
        System.assertEquals('Text',fl.type);
        System.assertEquals(null,fl.fsMember);
        fl = new Field('Address','ajmer','Text',true);
        System.assertEquals('Address',fl.label);
        System.assertEquals(true,fl.viewable);
        System.assertEquals('ajmer',fl.value);
        System.assertEquals('Text',fl.type);
        fl = new Field(fl);
        System.assertEquals('Address',fl.label);
        System.assertEquals('Text',fl.type);
        System.assertEquals(true,fl.viewable);
        System.assertEquals('ajmer',fl.value);
    }
    
    @IsTest static  void testFieldData(){
        setup();
        Field fl = new Field();
        fl.setMaxLength(23);
        System.assertEquals(23,fl.maxLength);
        
        fl.setReferencedObjectname('Expert__c');
        System.assertEquals('Expert__c',fl.referencedObjectName);
        
        fl.setReferencedObjectLabel('Expert');
        System.assertEquals('Expert',fl.referencedObjectLabel);
        
        fl.setFormat('DESC');
        System.assertEquals('DESC',fl.format);
        
        fl.setStyleClass('style');
        System.assertEquals('style',fl.styleClass);
        
        fl.setPlaceholder('enter field name');
        System.assertEquals('enter field name',fl.Placeholder);
        
        fl.setValue('Ajmer');
        System.assertEquals('Ajmer',fl.value);
        
        fl.setFieldPath('name');
        System.assertEquals('name',fl.fieldPath);
        
        fl.setIsCalculated(true);
        System.assertEquals(true,fl.isCalculated);
        
        fl.setIsSortable(true);
        System.assertEquals(true,fl.isSortable);
        
        fl.setIsGroupable(true);
        System.assertEquals(true,fl.isGroupable);
        
        fl.setType('Text');
        System.assertEquals('Text',fl.type);
        List<String> str = new List<String>{'Abc','Def'};
            
        System.assertEquals(fl,fl.setExtraResultFields(str));
        System.assertEquals(fl,fl.setNamePointingList(namePointList));
        System.assertEquals(fl,fl.setOptions(optionList));
        DisplayType dt ;
        System.assertEquals(fl,fl.setSchemaType(dt)); 
    } 
}