/** 
* 
* Description : Class operating with AddMultipleStandardItems vf page which is used to insert Standardized Items.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 04/15/2022
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/

public with sharing class AddMultipleStandardItemsController
{
    public String errorMessage {get; set;}
    public List<integer> count {get;set;}
    public Boolean isConstructorError {get;set;}
    public string indexing {get;set;}
    public List<StandardItemWrapper> contactData {get; set;}
    public Standardized_Item__c newStandardItems {get;set;}
    Public Integer inputValue {get;set;}
    Public Integer quantity {get;set;}
    public String currentRecordId {get;set;}
    
    /**
    *
    * @description : this method is used to single field input area at the button click.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/15/2022 - Deeptanshu Bharti
    *
    **/  
    public AddMultipleStandardItemsController(ApexPages.StandardController controller)
    {
        contactData = new List<StandardItemWrapper>();
        contactData.add(new StandardItemWrapper(new Standardized_Item__c(),0,null,null));
        inputValue = 0;
    }
    
    /**
    *
    * @description : this method is used to place values in product code and size column automatically when user enter product code.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/15/2022 - Deeptanshu Bharti
    *
    **/ 
    public PageReference getSelected(){
        Set<Id> setOfPId = new Set<Id>();
        Map<Integer,Id> mapOfId = new Map<Integer,Id>();
        Integer temp;
        for(StandardItemWrapper cw : contactData)
        {
            Standardized_Item__c si = cw.newLines;
            setOfPId.add(si.Product__c);
            temp =cw.index; 
            mapOfId.put(cw.index,si.Product__c);
            for(Product2 obj : [SELECT Id, Name, Size__c, ProductCode FROM Product2 WHERE Id =: mapOfId.get(temp)])
            {
                for(StandardItemWrapper cx : contactData){
                    if(cx.index == temp){
                        cx.procode = obj.ProductCode;
                        cx.prosize = obj.Size__c;
                    }
                }
            }
        }
        return NULL;
    }
    
    /**
    *
    * @description : this method is used to add number of field input area columns in vf page using update button.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/15/2022 - Deeptanshu Bharti
    *
    **/
    public void add(){
        Integer count = 0;
        for(Integer i=0; i<inputValue; i++){
            for(StandardItemWrapper cw : contactData){
                count = cw.index +1;
            }
            contactData.add(new StandardItemWrapper(new Standardized_Item__c(),count,null,null));
        }
    }
    
    /**
    *
    * @description : this method is used to single field input area at the add more button click.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/15/2022 - Deeptanshu Bharti
    *
    **/
    public void addOne(){
        Integer count = 0;
        String code = '';
        for(StandardItemWrapper cw : contactData){
            count = cw.index +1;
            code = cw.procode;
        }
        contactData.add(new StandardItemWrapper(new Standardized_Item__c(),count,null,null));
    }
    
    /**
    *
    * @description : this method is used to remove field input area column at the remove button click.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/15/2022 - Deeptanshu Bharti
    *
    **/
    public void remove(){
        if(contactData.size() > 0){
            contactData.remove(Integer.valueOf(indexing));
        }
        for(StandardItemWrapper cw : contactData){
            if(cw.index > Integer.valueOf(indexing)){
                cw.index = cw.index - 1;
            }
        }
    }
    
    /**
    *
    * @description : this method is used to add similar field input area at the clone button click.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/15/2022 - Deeptanshu Bharti
    *
    **/
    public void cloneItem(){
        Integer count = 0;
        String prdCode;
        String prdCodes;
        String prdsize;
        Decimal stateQuantity;
        Standardized_Item__c sdI = new Standardized_Item__c();
        Integer currentIndex = Integer.valueOf(indexing);
        for(StandardItemWrapper cw : contactData){
            if(cw.index == currentIndex)
            {

                sdI = cw.newLines;
                prdCode = sdI.Product__c;
                stateQuantity = sdI.Stated_Quantity__c;
                count = cw.index +1;
                prdCodes = cw.procode;
                prdsize = cw.prosize;
            }
        }
        contactData.add(new StandardItemWrapper(new Standardized_Item__c(Product__c = prdCode, Stated_Quantity__c = stateQuantity),count,prdCodes,prdsize));
    }
   
    /**
    *
    * @description : this method is called when save button is getting clicked.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/15/2022 - Deeptanshu Bharti
    *
    **/
    public PageReference save() 
    {
        List<Standardized_Item__c> listOfSi = new List<Standardized_Item__c>();
        Boolean check = false;
        for(StandardItemWrapper obj : contactData)
        {
            currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
            Standardized_Item__c si = obj.newLines;
            si.Opportunity__c = currentRecordId;
            si.Quantity__c = si.Stated_Quantity__c;
            si.Stage__c = Constants.stage;
            if(si.Product__c == NULL)
            {
                check = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill out Product details'));  
            }else if(si.Stated_Quantity__c == null){
                check = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill out the Quantity details'));
            }
            else
            {
                listOfSi.add(si);
            }
        }
        if(listOfSi.size()>0 && !check)
        {
            insert listOfSi;
            PageReference reRend = new PageReference('/' + currentRecordId );
            reRend.setRedirect(true);
            return reRend; 
        }
        else
        {
            return NULL;
        }
        
    }
    
    /**
    *
    * @description : this method is called when cancel button is clicked.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/15/2022 - Deeptanshu Bharti
    *
    **/
    public PageReference cancel() 
    {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id'); 
        PageReference reRend = new PageReference('/' + currentRecordId );
        reRend.setRedirect(true);
        return reRend; 
    }
    
    public class StandardItemWrapper
    {
        public Standardized_Item__c newLines {get; set;}
        public Boolean checked {get; set;}
        public List<integer> count {get;set;}
        public integer index {get;set;}  
        public String procode {get;set;}  
        public String prosize {get;set;}  
        public Map<Integer,String> mapProductCode{get;set;}
        
        public StandardItemWrapper(Standardized_Item__c c, Integer ind, String code,string size)
        {
            newLines = c;
            checked = false;
            index = ind;
            count = new list<Integer>();
            procode = code;
            prosize = size;
            count.add(1);
        }
    }
    
    
}