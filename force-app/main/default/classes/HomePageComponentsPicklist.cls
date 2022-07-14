global class HomePageComponentsPicklist extends VisualEditor.DynamicPickList
{
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(System.Label.Default_Custom_Link_Name, System.Label.Default_Custom_Link_Label);
        system.debug('defaultValue--'+defaultValue);
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() 
    {
        List<Home_Page_Component__mdt> homePageComponents = [SELECT Id, Label, MasterLabel FROM Home_Page_Component__mdt];
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        if(homePageComponents.size() > 0) 
        {
    		for(Home_Page_Component__mdt hPC : homePageComponents) 
            {
                myValues.addRow(new VisualEditor.DataRow(hPC.MasterLabel, hPC.Label));
            }
        }
        return myValues;
    }
}