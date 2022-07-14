/*
	Created By: Daven Tsai
	Version: 1.0
	Date: 5/05/2022
	Description: Works with VFP "NewCustomerPurchaseOrder" for applying customer POs into the CPO object.
*/
public class attachmentCPO {
    // For CPO Upload
    Public Attachment myFile;
    Public Customer_Purchase_Order__c myCPO;
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
    Public Set<String> leftValues = new Set<String>();
    Public Set<String> rightValues = new Set<String>();
    
    // For showing totals
    Public String msg{get;set;}
    Public Decimal total = 0;

	// Initializes
    public attachmentCPO (ApexPages.StandardController controller){
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

    Public Customer_Purchase_Order__c getMyCPO(){
        myCPO = new Customer_Purchase_Order__c();
        return myCPO;
    }
    
    // --Save Button Start--
    Public PageReference saveCPO()
    {
        if (rightValues.size() == 0){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'You need to select Sales Orders.'));
            return null;
        }
        else if(myFile.body == NULL){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'You need to add an attachment.'));
        	return null;
        }
        else if(myCPO.PO_Number__c == NULL){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'You need to add a PO Number.'));
        	return null;
        }
        else{
            String tempStr = 'remove';
            for (String right:rightValues){
                tempStr = right + ';' + tempStr;
            }
            tempStr = tempStr.replace(';remove','');
            myCPO.Sales_Orders__c = tempStr;
            
            myCPO.PO_Number__c = 'CPO#'+myCPO.PO_Number__c;
            
            insert myCPO;
            PageReference reRend = new PageReference('/' + myCPO.Id );
            Savedoc();
            reRend.setRedirect(true);
            return reRend;
        }
    }
    Public Pagereference Savedoc(){
        String cpoID = myCPO.id;
        Attachment a = new Attachment(parentId = cpoID, name=myFile.name, body = myFile.body);
        insert a;
        return NULL;
    }
	// --Save Button End--
    
    // --MultiSelect Start--
    Public PageReference selectClick(){
        rightSelected.clear();
        //System.assert(false,leftSelected);
        for(String s : leftSelected){
            //System.assert(false,s);
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
    // 
     Public String displayTotals(){
        Double total = 0.00;
        if (rightValues.size()>0){
            List<SCMC__Sales_Order__c> currentSOs = [SELECT Id, Check_Amount__c FROM SCMC__Sales_Order__c WHERE Name = :rightValues];
            for (SCMC__Sales_Order__c s : currentSOs){
                total += s.Check_Amount__c;
            }
        }
        msg = 'Total checking amount of the selected SO(s) are: ' + total;
        return msg;
    }
    
}