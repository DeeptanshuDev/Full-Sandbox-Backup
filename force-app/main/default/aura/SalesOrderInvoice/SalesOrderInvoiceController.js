({
    doInit : function(component, event, helper) {
        helper.prepareSo(component, event, helper);

    },
    handleToggleSection: function(component, event, helper){
        var openSections = event.getParam('openSections');
        console.log('you are inside toggle window');
        console.log('sales order id are : '+ openSections);
            if (openSections.length === 0) {
            console.log('good');
        	}
            else{
            	
            	console.log('id are : '  + openSections);
				var action = component.get("c.getSalesOrderInvoice");
                console.log('id :  ' + openSections.join(', '));
                action.setParams({
                "sId" : openSections.join(','),
                });
                
                action.setCallback(this, function(response){
                    var state = response.getState();
                    console.log('state sis : '  + state);
                   
                    if (state === "SUCCESS") {
                        component.set("v.inList", response.getReturnValue());
                        console.log('invoiceing on '+ openSections + ' are : ' + response.getReturnValue());
                        
                    }
                    else
                    {
                        var errors = response.getError();
                        console.log(errors);
                        console.log('err : '+ errors[0].message); 
                    }
                
                });
                $A.enqueueAction(action);
                console.log('done with the invoicing');
                
                
            }
            
    },
    handleToggleSection2: function(component, event, helper){
        var openSections = event.getParam('openSections');
        console.log('inovice are :' + openSections.join(', '));
        component.set('v.mycolumns1', [
            {label: 'Invoice Number', fieldName: 'Name', type: 'text'},
                {label: 'Invoice Date', fieldName: 'SCMC__Invoice_Date__c', type: 'text'},
            	{label: 'Status', fieldName: 'SCMC__Status__c', type: 'text'},
            	{label: 'Payment Status', fieldName: 'Payment_Status__c', type: 'text'},
            	{label: 'Invoice Total', fieldName: 'SCMC__Total_Invoice__c', type: 'text'},
            	{label: 'Deposit Amount ', fieldName: 'Deposit_Amount__c', type: 'text'},
            ]);
            if (openSections.length === 0) {
            console.log('good');
        	}
            else{
            	var action = component.get("c.getSalesOrderInvoicedisplay");
                action.setParams({
                    "sId" : openSections.join(','),
                    });
                    action.setCallback(this, function(response){
                        var state = response.getState();
                        console.log('state sis : '  + state);
                        if (state === "SUCCESS") {
                            component.set("v.indisplayList", response.getReturnValue());
                            console.log('invoicing to displayyyyy on '+ openSections + ' are : ' + JSON.stringify((response.getReturnValue())));
                            
                        }
                        else
                        {
                            var errors = response.getError();
                            console.log(errors);
                            console.log('err : '+ errors[0].message); 
                        }
                    
                    });
                    $A.enqueueAction(action);  
					console.log('you are inside invoiceing andi its id is : ' +openSections.join(','));
					var action = component.get("c.getSalesInvoice");
                    action.setParams({
                        "sId" : openSections.join(','),
                        });
                        action.setCallback(this, function(response){
                            var state = response.getState();
                            console.log('state sis : '  + state);
                            if (state === "SUCCESS") {
                                component.set("v.sainList", response.getReturnValue());
                                console.log('salesInvoice to displayyyyy on '+ openSections + ' are : ' + JSON.stringify((response.getReturnValue())));
                                
                            }
                            else
                            {
                                var errors = response.getError();
                                console.log(errors);
                                console.log('err : '+ errors[0].message); 
                            }
                        
                        });
                        $A.enqueueAction(action);
            	}
    },
    handleToggleSection3: function(component, event, helper){
        var openSections = event.getParam('openSections');
        console.log('Sales inovicess are :' + openSections.join(', '));
        component.set('v.mycolumns2', [
            {label: 'Invoice Number', fieldName: 'Name', type: 'text'},
            	{label: 'Convenience Fee', fieldName: 'Convenience_Fee__c', type: 'text'},
            	{label: 'Subtotal', fieldName: 'Subtotal__c', type: 'text'},
            	{label: 'Invoice Total', fieldName: 'c2g__InvoiceTotal__c', type: 'text'},
            	{label: 'Generated Date', fieldName: 'Latest_Document_Created_Date__c', type: 'text'},
            ]);
            if (openSections.length === 0) {
            console.log('good');
        	}
            else{
            	var action = component.get("c.getSalesInvoicedisplay");
                action.setParams({
                    "sId" : openSections.join(','),
                    });
                    action.setCallback(this, function(response){
                        var state = response.getState();
                        console.log('state sis : '  + state);
                        if (state === "SUCCESS") {
                            component.set("v.saindisplayList", response.getReturnValue());
                            console.log('sales invoice to displayiii on '+ openSections + ' are : ' + JSON.stringify((response.getReturnValue())));
                            
                        }
                        else
                        {
                            var errors = response.getError();
                            console.log(errors);
                            console.log('err : '+ errors[0].message); 
                        }
                    
                    });
                    $A.enqueueAction(action);            
            	}
    },
            
    
})