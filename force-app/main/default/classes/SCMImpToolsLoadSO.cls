/*
* FinancialForce.com, inc. claims copyright in this software, its screen
* display designs and supporting documentation. FinancialForce and
* FinancialForce.com are trademarks of FinancialForce.com, inc. Any
* unauthorized use, copying or sale of the above may constitute an
* infringement of copyright and may result in criminal or other legal
* proceedings.
*
* Copyright (c) 2015 FinancialForce.com, inc. All rights reserved.
*/
global with sharing class SCMImpToolsLoadSO implements Schedulable, Database.Batchable<SObject>{
	private ApexPages.StandardSetController setController;
	private Map<String, Schema.SObjectField> stagefs = Schema.SObjectType.SCMImpToolsSO_Stage__c.fields.getMap();
	private Map<String, Schema.SObjectField> headfs = Schema.SObjectType.SCMC__Sales_Order__c.fields.getMap();
	private Map<String, Schema.SObjectField> linefs = Schema.SObjectType.SCMC__Sales_Order_line_Item__c.fields.getMap();
	
	global SCMImpToolsLoadSO() {
	}

    // this constructor is invoked from the multi select on the SOStage object view
    public SCMImpToolsLoadSO(ApexPages.StandardSetController controller) {
    	this.setcontroller = controller;
	}
    
	public PageReference process() {
		Database.executeBatch(this, 30);
		Schema.DescribeSObjectResult r = SCMC__Sales_Order__c.sObjectType.getDescribe(); 
		String keyPrefix = r.getKeyPrefix();
		PageReference retPage = new PageReference('/' + keyPrefix + '/o');
		
		return retPage;
	}
	
	public PageReference goback() {
		PageReference retPage = setController.cancel();
		return retPage;
	}
	
	global void execute(SchedulableContext ctx) {       
        // Start Batch Apex job to pull requests and create requisitions
        Database.executeBatch(new SCMImpToolsLoadSO(),30);              
    }
    
   	global Database.QueryLocator start(Database.BatchableContext ctx) {
        // Select all requests that are not already loaded
			
		String querySO = 'select id';
		for(SObjectField field : stagefs.values()){
			Schema.DescribeFieldResult f = field.getDescribe();
			if(f.isAutoNumber()){
				//skip autonumber fields
				continue;
			} else if (f.isCalculated()){
				//skip calculated fields
				continue;
			} else if (!f.isCreateable()){
				//skip this field if the user cannot create the field
				continue;
			} else {
				querySO += ', ' + f.getName();
			}
		}
		querySO += ' from SCMImpToolsSO_Stage__c where Loaded__c = false ';
		querySO += ' order by Existing_SO_Number__c, Existing_SO_Line_No__c';
		System.debug('query stage for loadSO ' + querySO);
		SCMC__Sales_Order__c sorder = null;
		return Database.getQueryLocator(querySO);
    }
   
    global void execute(Database.BatchableContext ctx, List<SObject> records){
    	Map<String, SCMC__Sales_Order__c>so = 
    		new Map<String, SCMC__Sales_Order__c>();
    	Map<String, List<SCMC__Sales_Order_Line_Item__c>> lines =
    		new Map<String, List<SCMC__Sales_Order_Line_Item__c>>();
    	String currSO = '';
    	Map<String, SCMC__Sales_Order__c>existSO = new Map<String, SCMC__Sales_Order__c>();
    	Map<String, SCMC__Item__c>items = new Map<String, SCMC__Item__c>();
    	Map<String, SCMC__Ownership_Code__c>owns = new Map<String, SCMC__Ownership_Code__c>();
    	Map<String, Account>customers =	new Map<String, Account>();
    	Map<ID, Account>accounts = new Map<ID, Account>();
    	Map<String, User>users = new Map<String, User>();
    	Map<String, SCMC__Currency_Master__c>currs = new Map<String, SCMC__Currency_Master__c>();
		Map<String, SCMC__Customer_Address__c>caddrs = new Map<String, SCMC__Customer_Address__c>();
		Map<String, SCMC__Supplier_Site__c>suppliers = new Map<String, SCMC__Supplier_Site__c>();
		Map<String, Contact>contacts = new Map<String, Contact>();
		Map<String, RecordType>headType = new Map<String, RecordType>();
		Map<String, RecordType>lineType = new Map<String, RecordType>();
        Map<String, sObject>companies = new Map<String, sObject>();
    	for (SObject record : records){
    		SCMImpToolsSO_Stage__c stage = (SCMImpToolsSO_Stage__c)record;
    		stage.Error__c = false;
    		stage.Error_Message__c = '';
    		items.put(stage.Item__c, null);
    		if (stage.Account__c == null){
     			String customer = stage.Customer__c;
    			customers.put(customer, null);
    		}else {
    			accounts.put(stage.Account__c, null);
			}
			String oBilling = (String)getData(stage,'Override_Billing_Account__c');
			if (oBilling != null)
    		{
    			customers.put(oBilling, null);
    		}
    	
     		existSO.put(stage.Existing_SO_Number__c, null);

    		String oABillAddr = (String)getdata(stage, 'Override_Billing_Account_Address__c');
    		if (oABillAddr != null ){
    			caddrs.put(oABillAddr, null);
    		}

    		String oBillAddr = (String)getdata(stage, 'Override_Bill_To_Address__c');
    		if (oBillAddr != null ){
    			caddrs.put(oBillAddr, null);
    		}

	   		String oShipAddr = (String)getdata(stage, 'Override_Ship_To_Address__c');
    		if (oShipAddr != null ){
    			caddrs.put(oShipAddr, null);
    		}


    		String suppSite = (String)getData(stage, 'Supplier_Site__c');
    		if (suppSite != null &&
    				suppSite != 'NULL') {
    			suppliers.put(suppSite, null);
    		}
            
            String company = (String)getData(stage, 'Company__c');
            if (company != null){
                companies.put(company, null);
            }
    	}
    	
        
    	//see if SO is already loaded
    	List<SCMC__Sales_Order__c>exSOs = [select id, Existing_SO_Number__c from SCMC__Sales_Order__c
    			where Existing_SO_Number__c in :existSO.Keyset()];
    	for (SCMC__Sales_Order__c exSO : exSOs){
    		existSO.put(exSO.Existing_SO_Number__c, exSO);
    	}
    	List<SCMC__Currency_Master__c>cmasters = [select id
    			,name
    		from SCMC__Currency_Master__c
			limit 500];
		for (SCMC__Currency_Master__c cmaster : cmasters){
			currs.put(cmaster.name, cmaster);
		}
    	List<SCMC__Item__c>lItems = [select id, name 
    			from SCMC__Item__c
    			where name in :items.keySet()];
    	for (SCMC__Item__c item : lItems){
    		items.put(item.name, item);
    	}
    	

       	List<Account>sSites = [select id, name 
     				,SCMC__Active__c
     				,SCMC__Temporary_Hold__c
     				,SCMC__Customer__c
    			from Account
    			where name in :customers.keySet() and
    			SCMC__Active__c = true ];
    	System.debug('ssites ' + ssites);
    	for (Account site : sSites){
    		customers.put(site.name, site);
    	}
    	
    	List<Account>ISites = [select id, name 
     				,SCMC__Active__c
     				,SCMC__Temporary_Hold__c
     				,SCMC__Customer__c
    			from Account
    			where id in :accounts.keySet() and
    			SCMC__Active__c = true ];
    	for (Account site : ISites){
    		accounts.put(site.id, site);
    	}
    	
     	
    	SCMC__Customer_Address__c[] laddrs = [select id, name from SCMC__Customer_Address__c where name in :caddrs.Keyset()];
    	for (SCMC__Customer_Address__c addr : laddrs){
    		caddrs.put(addr.name, addr);
    	}
    	
    	SCMC__Supplier_Site__c[] susites = [select id, name from SCMC__Supplier_Site__c where name in :suppliers.Keyset()];
		for (SCMC__Supplier_Site__c site : susites){
			suppliers.put(site.name, site);
		}
        if (companies.Keyset().Size() >0){
            //companies have been specified
            Set<String>cnames = companies.Keyset();
            String queryCompany = 'select id, name from c2g__codaCompany__c where name in :cnames';
            sObject[]tcompanies = Database.query(queryCompany);
            for (sObject tcompany : tcompanies){
                String cname = (String)tcompany.get('Name');
                companies.put(cname, tcompany);
            }
        }
		
    	List<RecordType>rhtypes = [select id, name
    		from RecordType
    		where SobjectType = 'SCMC__Sales_Order__c'];

    	for (RecordType rhtype : rhtypes){
    		headType.put(rhtype.name, rhtype);
    	}

    	List<RecordType>rltypes = [select id, name
    		from RecordType
    		where SobjectType = 'SCMC__Sales_Order_Line_Item__c'];

     	for (RecordType rltype : rltypes){
    		lineType.put(rltype.name, rltype);
    	}
   		
    	boolean headErr = false;
    	for (SObject record : records){
    		SCMImpToolsSO_Stage__c stage = (SCMImpToolsSO_Stage__c)record;
    		stage.Error__c = false;
    		stage.Error_Message__c = '';
    		Integer lineNum = 0;
    		if (currSO != stage.Existing_SO_Number__c){
    			//we have the full SO start a new 
    			lineNum = 0;
    			currSO = stage.Existing_SO_Number__c;
    			headErr = false;
    			SCMC__Sales_Order__c head = existSO.get(currSO);
    			if (head != null){
    				System.debug('SO already exists for ' + currSO);
    			} else {
    				System.debug('Creating new head for ' + currSO);
    				head = new SCMC__Sales_Order__c();
	     			head.SCMC__Customer_Purchase_Order__c = stage.Customer_PO__c;
	     			head.Existing_SO_Number__c = stage.Existing_SO_Number__c;
	     			if (stage.Currency__c != null){
	     				head.SCMC__Currency__c = currs.get(stage.Currency__c).id;	
	     			}
	     			
	     			//String supplier = stage.Supplier__c.substring(8);
	     			Account site = null;
	     			if (stage.Account__c != null) {
	     				site = Accounts.get(stage.Account__c);
	     			} else if (stage.Customer__c != null){
	     				site = Customers.get(stage.Customer__c);
	     			}
	    			if (site == null){
                        setStageError(stage, 'Unknown customer/Account ' + stage.Customer__c +  ' / ' + stage.Account__c);
	    			} else if (site.SCMC__Active__c == false){
	                        setStageError(stage, 'Customer must be active for a sales order ' + stage.Customer__c +  ' / ' + stage.Account__c);
	    			} else if (site.SCMC__Temporary_Hold__c != null){
                        setStageError(stage, 'Customer must not be on hold for a sales order ' + stage.Customer__c +  ' / ' + stage.Account__c);	    				
	    			} else if (site.SCMC__Customer__c != true) {
                        setStageError(stage, 'Customer must be flagged as a customer ' + stage.Customer__c +  ' / ' + stage.Account__c);	    				
	    			}else {
	    				head.SCMC__Customer_Account__c  = site.id;
	    			}
	    			head.SCMC__Shipment_Status__c = stage.Status__c;
	    			if (stage.Status__c == 'Fulfilled' ||
	    				stage.Status__c == 'Partially Shipped') {
	    				head.SCMC__Status__c = 'Approved';
	    			}

	    			Date fillDate = (Date)getData(stage, 'Fulfillment_Date__c');
	    			if (fillDate != null) {
	    				head.SCMC__Fulfillment_Date__c = fillDate;
	    			}
	    			
	    			Boolean pInvoice = (Boolean)getData(stage, 'Partial_Invoicing__c');
	    			Schema.SObjectField sfield = stagefs.get('Partial_Invoicing__c');
    				if (pInvoice != null &&
    					pInvoice) {
	    				head.SCMC__Partial_Invoicing__c = 'Yes';
	    			} else {
	    				head.SCMC__Partial_Invoicing__c = 'No';
	    			}
	    			boolean pship = (Boolean)getData(stage, 'Partial_Shipment__c');
	    			if (pShip != null &&
	    				pShip) {
	    				head.SCMC__Partial_Shipments__c = 'Yes';
	    			} else {
	    				head.SCMC__Partial_Shipments__c = 'No';
	    			}
		    		String oBill = (String)getData(stage, 'Override_Billing_Account__c ');
	    			if (oBill !=  null)
	    			{
	    				Account ob = customers.get(oBill);
	    				if (ob == null)
	    				{
                           setStageError(stage, 'Override billing account is not defined ' + oBill);
	    				} else {
	    					head.SCMC__Override_Billing_Account__c = ob.id;
	    					
	    				}
	    			}

	    			String oshipTo = (String)getData(stage, 'Override_Ship_To__c');
	    			if (oshipTo != null){
	    				SCMC__Customer_Address__c caddr = caddrs.get('oshipTo');
	    				if (caddr == null){
                            setStageError(stage, 'Unknown override shipping  address ' + oshipTo);
	    				} else {
	    					head.SCMC__Actual_Ship_To_Address__c = caddr.id;
	    				}
	    			}


	    			String obillTo = (String)getData(stage, 'Override_Bill_To__c');
	    			if (obillTo != null){
	    				SCMC__Customer_Address__c caddr = caddrs.get('obillTo');
	    				if (caddr == null){
                            setStageError(stage, 'Unknown override billing address ' + oBillTo);
	    				} else {
	    					head.SCMC__Actual_Ship_To_Address__c = caddr.id;
	    				}
	    			}

	    			if (stage.SO_Date__c != null){
	    				head.SCMC__Sales_Order_Date__c = stage.SO_Date__c;
	    			}
	    			
	    			
	    			RecordType rtypeID = null;
	    			if (stage.SO_Record_Type__c != null){
	    				//get record type
	    				rtypeID = headType.get(stage.SO_Record_Type__c);
	    			} 
	    			if (rtypeID != null){
	    				head.recordtypeID = rtypeID.id;
	    			}
                    sObject company = null;
                    if (stage.Company__c != null){
                        company = companies.get(stage.Company__c);
                        if (company == null){
                            setStageError(stage, 'Unknown Company ' + stage.Company__c);
                        }else {
                            head.put('SCMFFA__Company__c', company.id);
                        }
                    }
	    			for(SObjectField hfield  : headfs.Values())
	    			{
						Schema.DescribeFieldResult hdfield = hfield.getDescribe();
						if(hdfield.isAutoNumber()){
							//skip autonumber fields
							continue;
						} else if (hdfield.isCalculated()){
							//skip calculated fields
							continue;
						} else if (!hdfield.isCreateable()){
							//skip this field if the user cannot create the field
							continue;
						} else {
							String hfname =  hdfield.getName();
							System.debug('head field ' + hfname);
                            if (hfname.length() > 6){
								if (hfname.startswith('scmc__') ||
                                   hfname.startswith('scmffa__')){
									Continue;
                                }
							}
                            if (stagefs.containsKey(hfname)){
                                Object tcont = head.get(hfname);
                                //only over write field if it is currently empty
                                if (tcont == Null &&
                                    stage.get(hfname) != 'NULL')
                                {
                                    head.put(hfname, stage.get(hfname));
                                }                            
                            }
                        }
	    			}
	    		}
	    		System.debug('so head ' + head);
	    		if (stage.Error__c){
	    			headErr = true;
	    		} else {
    				so.put(currsO, head);
	    			List<SCMC__Sales_Order_Line_Item__c>soLines =
	    				new List<SCMC__Sales_Order_Line_Item__c>();
	     			lines.put(currSO, soLines);	
	    		}
    		}
   		if (headErr){
    			stage.Error__c = true;
    		} else {
				List<SCMC__Sales_Order_Line_Item__c>soLines =
					lines.get(currSO);
				//create line and add to list
				SCMC__Sales_Order_Line_Item__c lItem =
					new SCMC__Sales_Order_Line_Item__c();
				lItem.SCMC__Price__c = stage.Unit_Price__c;
				lItem.SCMC__Taxable__c = false;
				lItem.SCMC__Quantity__c = stage.Quantity__c;
				//lItem.SCMC__Quantity_Allocated__c = stage.Quantity_Allocated__c;
				Decimal bo = (Decimal)getData(stage, 'Quantity_Backordered__c');
				if (bo != null){
					lItem.SCMC__Quantity_Backordered__c = bo;
				}
				Decimal squantity = (Decimal)getData(stage, 'Quantity_Shipped__c');
				if (squantity != null &&
					squantity != 0){
					lItem.SCMC__Quantity_Shipped__c = squantity;
					if (squantity >= stage.Quantity__c){
						lItem.SCMC__Status__c = 'Shipped';
					} else {
						lItem.SCMC__Status__c = 'Partially Shipped';
					}

				}
				Decimal bquantity = (Decimal)getData(stage, 'Quantity_Billed__c');
				if (bquantity != null){
					lItem.SCMC__Quantity_Billed__c = bquantity;
				}
				String supplier = (String)getData(stage, 'Supplier_Site__c');
				if (supplier != null)
				{
					SCMC__Supplier_Site__c lisite = suppliers.get(supplier);
					if (lisite == null){
						//stage.Error__c = true;
						//stage.Error_Message__c += 'unknown supplier ' + stage.Supplier_Site__c;
                        setStageError(stage, 'unknown supplier ' + supplier);
					} else {
						lItem.SCMC__Supplier_Site__c = lisite.id;
					}
				}
				lItem.SCMC__Line_Number__c = (++lineNum);
				SCMC__Item__c titem = items.get(stage.Item__c);
				if (tItem == null){
					//stage.Error__c = true;
					//stage.Error_Message__c = 'Unknown item ' + stage.Item__c;
                    setStageError(stage, 'Unknown item ' + stage.Item__c);
				} else {
					lItem.SCMC__Item_Master__c = titem.id;
				}
				RecordType rTypeId = null;
    			if (stage.SO_Line_Record_Type__c != null){
    				//get record type
    				rtypeID = lineType.get(stage.SO_Line_Record_Type__c);
    			} 
    			if (rtypeID != null){
    				lItem.recordtypeID = rtypeID.id;
    			}
				if (!stage.Error__c){
					soLines.add(lItem);
				}
    		}
       	}
       	Map<String,SCMC__Sales_Order__c>insSO = new Map<String, SCMC__Sales_Order__c>();
       	List<SCMC__Sales_Order_Line_Item__c>inssolines = 
       		new List<SCMC__Sales_Order_Line_Item__c>();
       	for (SObject record : records){
    		SCMImpToolsSO_Stage__c stage = (SCMImpToolsSO_Stage__c)record;
    		if (stage.Error__c){
    			//skip past error lines
    			continue;
    		} else {
    			insSO.put(stage.Existing_SO_Number__c,so.get(stage.Existing_SO_Number__c));
    		}
    		
       	}
       	System.debug('so to insert ' + insSO);
       	if (insSO.Values().size() > 0){
       		upsert insSO.values();
       	}
       	
       	for (String NSSO : lines.keyset()){
       		List<SCMC__Sales_Order_Line_Item__c>nslines = 
       			lines.get(NSSO);
       		SCMC__Sales_Order__c nsHead = so.get(NSSO);
       		for(SCMC__Sales_Order_Line_Item__c nsline : nslines){
       			nsline.SCMC__Sales_Order__c = nsHead.id;
       		}
       		inssolines.addall(nslines);
       	}
       	insert inssolines;
        for (SObject record : records){
    		SCMImpToolsSO_Stage__c stage = (SCMImpToolsSO_Stage__c)record;
    		if (stage.Error__c){
    			//skip past error lines
    			continue;
    		}
    		stage.Loaded__c = true;
        }
        update records;
    }
    
    global void finish(Database.BatchableContext ctx) {
    }
    
    
    private void setStageError(SCMImpToolsSO_Stage__c target, string message){
        target.Error__c = true;
        if(target.Error_Message__c != null){
        	target.Error_Message__c += ', ' + message;
   		}else{
            target.Error_Message__c = message;
    	}
        system.debug('Stage error set: ' + message);
    }

    private Object getData(SCMImpToolsSO_Stage__c stage, String column) {
    	Object retValue  = null;
    	Schema.SObjectField sfield =  stagefs.get(column);	
    	if (sfield !=  null){
    		retValue = stage.get(column);
    	}
    	return retValue;
    }

}