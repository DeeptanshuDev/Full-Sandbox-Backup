/*
	Created By: Daven Tsai
	Version: 1.0
	Date: 5/05/2022
	Description: Works with VFP "NewLetterOfIntent" for applying customer POs into the LOI object.
*/
public class attachmentLOI {
    // For CPO Upload
    Public Attachment myFile;
    Public Letter_Of_Intent__c myLOI;
    Public Attachment getMyFile(){
        myFile = new Attachment();
        return myFile;
    }
    // For Sales Order Picklist--
    Public List<SCMC__Sales_Order__c> soList{get;set;}
    
    // For MultiSelects
    Public Set<String> originalValues{get;set;}
    Public List<String> leftSelected{get;set;}
    Public List<String> rightSelected{get;set;}
    Set<String> leftValues = new Set<String>();
    Set<String> rightValues = new Set<String>();

    // For showing totals
    Public String msg{get;set;}
    Public Decimal total = 0;    
    
	// Initializes
    public attachmentLOI (ApexPages.StandardController controller){
        loadSOOption();
        leftSelected = new List<String>();
        rightSelected = new List<String>();
        leftValues.addAll(originalValues);
    }
    
    Public Void loadSOOption()
    {
        List<String> optionSO = new List<String>();
        soList = [Select Name from SCMC__Sales_Order__c WHERE (Total_Percentage_Paid__c < 100 AND SCMC__Customer_Account__c = :ApexPages.currentPage().getParameters().get('id'))];
        for (SCMC__Sales_Order__c so:soList){
            optionSO.add(so.Name);
        }
        originalValues = new Set<String>(optionSO);
    }

    Public Letter_Of_Intent__c getMyLOI(){
        myLOI = new Letter_Of_Intent__c();
        return myLOI;
    }
    
    // --Save Button Start--
    Public PageReference saveLOI()
    {
        if (rightValues.size() == 0){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'You need to select Sales Orders.'));
            return null;
        }
        else if(myFile.body == NULL){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'You need to add an attachment.'));
        	return null;
        }
        else{
            String tempStr = 'remove';
            for (String right:rightValues){
                tempStr = right + ';' + tempStr;
            }
            tempStr = tempStr.replace(';remove','');
            myLOI.Sales_Orders__c = tempStr;
            insert myLOI;
            PageReference reRend = new PageReference('/' + myLOI.Id );
            Savedoc();
            reRend.setRedirect(true);
            return reRend;
        }
    }
    Public Pagereference Savedoc(){
        String loiID = myLOI.id;
        Attachment a = new Attachment(parentId = loiID, name=myFile.name, body = myFile.body);
        insert a;
        return NULL;
    }
	// --Save Button End--
    
    // --MultiSelect Start--
    Public PageReference selectClick(){
        rightSelected.clear();
        for(String s : leftSelected){
            leftValues.remove(s);
            rightValues.add(s);
        }
        total=0;
        if (rightValues.size()>0){
            List<SCMC__Sales_Order__c> currentSOs = [SELECT Id, Check_Amount__c FROM SCMC__Sales_Order__c WHERE Name = :rightValues];
            for (SCMC__Sales_Order__c s : currentSOs){
                total += s.Check_Amount__c;
            }
        }
        msg = 'Total checking amount of the selected SO(s): $' + total.setScale(2);
        return NULL;
    }
    Public PageReference unselectClick(){
        leftSelected.clear();
        for(String s : rightSelected){
            rightValues.remove(s);
            leftValues.add(s);
        }
        total=0;
        if (rightValues.size()>0){
            List<SCMC__Sales_Order__c> currentSOs = [SELECT Id, Check_Amount__c FROM SCMC__Sales_Order__c WHERE Name = :rightValues];
            for (SCMC__Sales_Order__c s : currentSOs){
                total += s.Check_Amount__c;
            }
        }
        msg = 'Total checking amount of the selected SO(s): $' + total.setScale(2);
        return NULL;
    }
    Public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options =  new List<SelectOption>();
        List<String> tempList = new List<String>();
        tempList.addAll(leftValues);
        tempList.sort();
        for(string s:tempList)
            	options.add(new SelectOption(s,s));
        return options;
    }
    Public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<String> tempList = new List<String>();
        tempList.addAll(rightValues);
        tempList.sort();
        for(String s:tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    // --MultiSelect End--
}