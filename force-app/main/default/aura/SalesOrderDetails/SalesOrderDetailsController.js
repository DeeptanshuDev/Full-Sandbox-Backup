({
    doInit : function(component, event, helper) {
        helper.prepareFilters(component, event, helper);
        helper.prepareSo(component, event, helper);
        
    },
    
    /* pagination for standard item */
    doPreviousShippingItem: function(component, event, helper) {
        component.find("shippingNew").doPrevious();
        component.find("shippingItemTable").focusAction();
    },
    
    doNextShippingItem: function(component, event, helper) {
        component.find("shippingNew").doNext();
        component.find("shippingItemTable").focusAction();
    },
    
    doPreviousPicklistItem: function(component, event, helper) {
        component.find("picklistNew").doPrevious();
        component.find("picklistItemTable").focusAction();
    },
    
    doNextPicklistItem: function(component, event, helper) {
        component.find("picklistNew").doNext();
        component.find("picklistItemTable").focusAction();
    },
    
    doPreviousPicklistDetailsItem: function(component, event, helper) {
        component.find("picklistDetailsNew").doPrevious();
        component.find("picklistDetailsItemTable").focusAction();
    },
    
    doNextPicklistDetailsItem: function(component, event, helper) {
        component.find("picklistDetailsNew").doNext();
        component.find("picklistDetailsItemTable").focusAction();
    },
    
    handleToggleSection: function(component, event, helper) {
        
        var openSections = event.getParam('openSections');
        
        console.log('you are inside toggle window');
        console.log('sales order id are : '+ openSections);
        component.set('v.mycolumns1', [
            {label: 'Shipment Number', fieldName: 'Name', type: 'text'},
            {label: 'Status', fieldName: 'SCMC__Status__c', type: 'text'},
            {label: 'Carrier', fieldName: 'SCMC__Carrier__c', type: 'text'},
            {label: 'Carrier Tracking Number', fieldName: 'SCMC__Carrier_Tracking_Number__c', type: 'text'},
        ]);
        component.set('v.mycolumns110', [
            {label: 'Sales Order Number', fieldName: 'Name', type: 'text'},
            {label: 'Shipment Status', fieldName: 'SCMC__Shipment_Status__c', type: 'text'},
            {label: 'Partial Shipments', fieldName: 'SCMC__Partial_Shipments__c', type: 'text'},
            {label: 'Carrier', fieldName: 'Carrier__c', type: 'text'},
            //{label: 'Carrier Service', fieldName: 'Carrier_Service__c', type: 'text'},
            {label: 'Total Value', fieldName: 'SCMC__Total_Value__c', type: 'text'},
            {label: 'Total Open Value', fieldName: 'SCMC__Total_Open_Value__c', type: 'text'},
            //{label: 'Commission Amount', fieldName: 'Commission_Amount__c', type: 'currency'},
            {label: 'Total % Paid', fieldName: 'Total_Percentage_Paid__c', type: 'text'},
            //{label: 'Deposit Amount Paid', fieldName: 'Deposit_Amount_Paid__c', type: 'text'},
            //{label: 'Remaining Payment Balance', fieldName: 'Remaining_Payment_Balance__c', type: 'text'},
            //{label: 'Total Tax', fieldName: 'SCMAVA__Total_Tax__c', type: 'currency'},
            {label: 'Customer Purchase Order', fieldName: 'SCMC__Customer_Purchase_Order__c', type: 'text'},
        ]);
        component.set('v.mycolumns6', [
            {label: 'Item Number ID', fieldName: 'Name', type: 'text'},
            {label: 'Item', fieldName: 'Item__c', type: 'text'},
            {label: 'Custom Item Number', fieldName: 'Custom_Item_Number__c', type: 'text'},
            {label: 'Status', fieldName: 'SCMC__Status__c', type: 'text'},
            {label: 'Quantity', fieldName: 'SCMC__Quantity__c', type: 'text'},
            {label: 'Quantity Shipped', fieldName: 'SCMC__Quantity_Shipped__c', type: 'text'},
            {label: 'Ext. Price', fieldName: 'SCMC__Extended_Price__c', type: 'text'},
        ]);
            
        component.set('v.mycolumns7', [
            {label: 'User', fieldName: 'parentName', type: 'text',initialWidth: 150},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'text',initialWidth: 150},
            {label: 'Action', fieldName: 'action', type: 'text'},
        ]);
        
        if (openSections.length === 0) {
            console.log('good');
        } 
        else 
        {
            
            console.log('id are : '  + openSections);
            var action = component.get("c.getSalesOrderdisplay");
            console.log('id isssss :  ' + openSections.join(', '));
            action.setParams({
                "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state sis : '  + state);
                if (state === "SUCCESS") {
                    component.set("v.sodisplayList", response.getReturnValue());
                    console.log('sales order on '+ openSections + ' are : ' + JSON.stringify((response.getReturnValue())));
                    
                }
                else
                {
                    var errors = response.getError();
                    console.log(errors);
                    console.log('err : '+ errors[0].message); 
                }
                
            });
            $A.enqueueAction(action);
            console.log('done with the sales order');
            
            
            var action = component.get("c.getShipping");
            console.log('id isssss :  ' + openSections.join(', '));
            action.setParams({
                "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state sis : '  + state);
                if (state === "SUCCESS") {
                    component.set("v.shList", response.getReturnValue());
                    console.log('shipping on '+ openSections + ' are : ' + response.getReturnValue());
                    
                }
                else
                {
                    var errors = response.getError();
                    console.log(errors);
                    console.log('err : '+ errors[0].message); 
                }
                
            });
            $A.enqueueAction(action);
            console.log('done with the shipping');
            console.log('is it shipping id or opp id : ' +openSections.join(','));
            var action = component.get("c.getNonInvenItem");
            action.setParams({
                "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state sis : '  + state);
                if (state === "SUCCESS") {
                    component.set("v.niiList", response.getReturnValue());
                    console.log('non inventory item to dispaly on si '+ openSections + ' are : ' + response.getReturnValue());
                    
                }
                else
                {
                    var errors = response.getError();
                    console.log(errors);
                    console.log('err : '+ errors[0].message); 
                }
                
            });
            $A.enqueueAction(action);
            
            console.log('it is sales order id : ' +openSections.join(','));
            
            var action = component.get("c.getSOLI");
            action.setParams({
                "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state sis : '  + state);
                if (state === "SUCCESS") {
                    component.set("v.soliList", response.getReturnValue());
                    console.log('SOLI item to dispaly on so '+ openSections + ' are : ' + response.getReturnValue());
                    
                }
                else
                {
                    var errors = response.getError();
                    console.log(errors);
                    console.log('err : '+ errors[0].message); 
                }
                
            });
            $A.enqueueAction(action);
            
            var action = component.get("c.getSOH");
            action.setParams({
                "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state sis : '  + state);
                if (state === "SUCCESS") {
                    component.set("v.soHList", response.getReturnValue());
                    console.log('SOH item to dispaly on so '+ openSections + ' are : ' + JSON.stringify(response.getReturnValue()));
                }
                else
                {
                    var errors = response.getError();
                    console.log(errors);
                    console.log('err : '+ errors[0].message); 
                }
                
            });
            $A.enqueueAction(action); 
            var action = component.get("c.getSOHdisplay");
            action.setParams({
                "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state sis : '  + state);
                if (state === "SUCCESS") {
                    component.set("v.soHdisplayList", response.getReturnValue());
                    //alert('the value of SOH wrapper is : ' + JSON.stringify(response.getReturnValue()));
                    console.log('SOH item to dispaly on so '+ openSections + ' are : ' + JSON.stringify(response.getReturnValue()));
                }
                else
                {
                    var errors = response.getError();
                    console.log(errors);
                    console.log('err : '+ errors[0].message); 
                }
                
            });
            $A.enqueueAction(action); 
            
            
            
            component.set('v.mycolumns4', [
                
                {label: 'Sales Invoice Name', fieldName: 'Name', type: 'text'},
                {label: 'Status', fieldName: 'c2g__InvoiceStatus__c', type: 'text'},
            ]);
                var action = component.get("c.getSI");
                console.log('id isssss :  ' + openSections.join(', '));
                action.setParams({
                "sid" : openSections.join(','),
                });
                action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state sis : '  + state);
                if (state === "SUCCESS") {
                component.set("v.siList", response.getReturnValue());
                console.log('sales invoice on '+ openSections + ' are : ' + JSON.stringify((response.getReturnValue())));
                
                }
                else
                {
                var errors = response.getError();
                console.log(errors);
                console.log('err : '+ errors[0].message);
            
        		}
        
    			});
                $A.enqueueAction(action);
                console.log('done with the picklist');
            component.set('v.mycolumns5', [
                
                {label: 'Invoice Name', fieldName: 'Name', type: 'text'},
                {label: 'Status', fieldName: 'SCMC__Status__c', type: 'text'},
            ]);
            var action = component.get("c.getSI");
            console.log('id isssss :  ' + openSections.join(', '));
            action.setParams({
                "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state sis : '  + state);
                if (state === "SUCCESS") {
                    component.set("v.inList", response.getReturnValue());
                    console.log('invoice on '+ openSections + ' are : ' + JSON.stringify((response.getReturnValue())));
                    
                }
                else
                {
                    var errors = response.getError();
                    console.log(errors);
                    console.log('err : '+ errors[0].message); 
                }
            });
            $A.enqueueAction(action);
            console.log('done with the picklist'); 
            }
},
    
    handleToggleSection2: function(component, event, helper) {
        var openSections = event.getParam('openSections');
        console.log('you are inside shipping toggle window');
        console.log('shipping id for getting picklist are : '+ openSections);
        component.set('v.mycolumns2', [
            {label: 'Packaging Name', fieldName: 'Name', type: 'text'},
            {label: 'Status', fieldName: 'SCMC__Status__c', type: 'text'},
            {label: 'Drop/Bulk Address', fieldName: 'Drop_Bulk_Address__c', type: 'text'},
            
        ]);
            component.set('v.mycolumns1', [
            {label: 'Shipment Number', fieldName: 'Name', type: 'text'},
            {label: 'Status', fieldName: 'SCMC__Status__c', type: 'text'},
            {label: 'Carrier', fieldName: 'SCMC__Carrier__c', type: 'text'},
            {label: 'Carrier Tracking Number', fieldName: 'SCMC__Carrier_Tracking_Number__c', type: 'text'},
            {label: 'Carrier Service', fieldName: 'SCMC__Carrier_Service__c', type: 'text'},
            {label: 'Number of Boxes', fieldName: 'SCMC__Number_of_Boxes__c', type: 'text'},
            {label: 'Shipment Date/Time', fieldName: 'SCMC__Shipment_Date_Time__c',type: 'date',
             typeAttributes:{day:'numeric',month:'short',year:'numeric',hour:'2-digit',minute:'2-digit',hour12:true,timeZone:'CST'}},
        ]);
        
        if (openSections.length === 0) {
            console.log('good');
            
        } else {
            console.log('shipping table for whcihc we have to display table is  : ' +openSections );
            var action = component.get("c.getdisplayShipping");
            action.setParams({
                "sId" : openSections.join(','),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state sis : '  + state);
                if (state === "SUCCESS") {
                    var results =  response.getReturnValue();
                    results.forEach(function(rec){
                        /*rec.dropbulkadd = String(rec.SCMC__Picklist__r.Drop_Bulk_Address__c);*/
                        var temp = new Date(rec.SCMC__Shipment_Date_Time__c);
                        rec.shipmentDate = temp;
                    })
                    component.set("v.shdisplayList", results);
                    console.log('shiiping to display '+ openSections + ' are : ' + JSON.stringify((response.getReturnValue())));
                    
                }
                else
                {
                    var errors = response.getError();
                    console.log(errors);
                    console.log('err : '+ errors[0].message); 
                }
                
            });
            $A.enqueueAction(action);
            
            console.log('shipping id are : '  + openSections);
            
            var action = component.get("c.getPicklist");
            console.log('id isssss :  ' + openSections.join(', '));
            action.setParams({
                "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state sis : '  + state);
                if (state === "SUCCESS") {
                    component.set("v.pkList", response.getReturnValue());
                    console.log('Picklist on shipping id '+ openSections + ' are : ' + JSON.stringify((response.getReturnValue())));
                    
                }
                else
                {
                    var errors = response.getError();
                    console.log(errors);
                    console.log('err : '+ errors[0].message); 
                }
                
            });
            $A.enqueueAction(action);
            console.log('done with the picklist');
        }
    },
        
	handleToggleSection3: function(component, event, helper) {                 
        var openSections = event.getParam('openSections');
        console.log('you are insssssssssssssssssssssside picklist toggle with id :  ' + openSections.join(', '));
        console.log('you are inside picklist toggle window');
        console.log('picklist id are : '+ openSections);
        component.set('v.mycolumns3', [
            {label: 'Packaging List Name', fieldName: 'Name', type: 'text'},
            {label: 'Status', fieldName: 'SCMC__Status__c', type: 'text'},
            {label: 'Item', fieldName: 'itemName', type: 'text'},
            {label: 'Quantity', fieldName: 'SCMC__Quantity__c', type: 'text'},
            
            
        ]);
            component.set('v.mycolumns2', [
            {label: 'Packaging Name', fieldName: 'Name', type: 'text'},
            {label: 'Status', fieldName: 'SCMC__Status__c', type: 'text'},
            {label: 'Drop/Bulk Address', fieldName: 'Drop_Bulk_Address__c', type: 'text'},
            
        ]);
        
        component.set('v.mycolumns8', [
            
            {label: 'Action', fieldName: 'action', type: 'text'},
            {label: 'Created Date', fieldName: 'createdDate',type: 'date',
             typeAttributes:{day:'numeric',month:'short',year:'numeric',hour:'2-digit',minute:'2-digit',hour12:true,timeZone:'CST'}},
            {label: 'Last Modified By', fieldName: 'lastModifiedBy', type: 'text'},
            
            
        ]);
            
            if (openSections.length === 0) {
            console.log('good');
            
            } else {
            
            console.log('id are : '  + openSections);
            var action = component.get("c.getPicklistdisplay");
            console.log('picklist id isssss to get picklistdetails is :  ' + openSections.join(', '));
            action.setParams({
            "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state sis : '  + state);
            if (state === "SUCCESS") {
            var results =  response.getReturnValue();
            results.forEach(function(rec){
            var temp = rec.Drop_Bulk_Address__c.replace(/\<br\>/g," ")
            rec.Drop_Bulk_Address__c = temp;
            
            })
            component.set("v.pkdisplayList", results);
            console.log('picklist on '+ openSections + ' are : ' +  JSON.stringify((response.getReturnValue())));
            
            }
            else
            {
            var errors = response.getError();
            console.log(errors);
            console.log('err : '+ errors[0].message); 
    		}

			});
            $A.enqueueAction(action);
            console.log('done with the picklist');
            
            var action = component.get("c.getPicklistDetail");
            console.log('picklist id isssss to get picklistdetails is :  ' + openSections.join(', '));
            action.setParams({
            "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state sis : '  + state);
            if (state === "SUCCESS") {
            var results =  response.getReturnValue();
            results.forEach(function(rec){
            rec.itemName = rec.SCMC__Item__r.Name;
            })
            component.set("v.pklList", results);
            console.log('picklistdetail on '+ openSections + ' are : ' +  JSON.stringify((response.getReturnValue())));
            
            }
            else
            {
            var errors = response.getError();
            console.log(errors);
            console.log('err : '+ errors[0].message); 
    		}

			});
            $A.enqueueAction(action);
            console.log('done with the picklistdetail');
			
			var action = component.get("c.getInventoryActionQueue");
            console.log('picklist  ids :  ' + openSections.join(', '));
            action.setParams({
            "pId" : openSections.join(','),
            });
            action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state sis : '  + state);
            if (state === "SUCCESS") {
                
            
                component.set("v.iaqList", response.getReturnValue());
                console.log('inventory action queue on '+ openSections + ' are : ' +  JSON.stringify((response.getReturnValue())));
            
            }
            else
            {
                var errors = response.getError();
                console.log(errors);
                console.log('err : '+ errors[0].message); 
    		}

			});
            $A.enqueueAction(action);
            console.log('done with the inventory action queue');


   		}
    },
    handleToggleSection5: function(component, event, helper){
        var openSections = event.getParam('openSections');
        console.log('You are inside non inventory js and nii id is : ' + openSections.join(', '));
        component.set('v.mycolumns5', [
            {label: 'Custom Item Shipment Name', fieldName: 'Name', type: 'text'},
            {label: 'Package Tracking Number', fieldName: 'PackageTrackingNumber__c', type: 'text'},
            {label: 'Custom Item Number', fieldName: 'Non_Inventory__c', type: 'text'},
            {label: 'Ship To Company or Name', fieldName: 'ShipToCompanyorName__c', type: 'text'},
            {label: 'Ship To Attention', fieldName: 'ShipToAttention__c', type: 'text'},
        ]);
            
            if (openSections.length === 0) {
            	console.log('good');
            
            } else{
            	console.log(' ids are : '  + openSections);
            
            var action = component.get("c.getNonInvenItemdisplay");
            console.log('non iitems id isssss :  ' + openSections.join(', '));
            action.setParams({
            "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state sis : '  + state);
            if (state === "SUCCESS") {
            var results3 =  response.getReturnValue();
            component.set("v.niidisplayList", results3);
            console.log('non invertory item on '+ openSections + ' are : ' + response.getReturnValue());
            
            }
            else
            {
                var errors = response.getError();
                console.log(errors);
                console.log('err : '+ errors[0].message); 
    		}

            });
            $A.enqueueAction(action);
            console.log('done with the non inventory item');
            
            
		}
    },
    handleToggleSection6: function(component, event, helper){
        
        var openSections = event.getParam('openSections');
        console.log('You are inside soli js and soli id is : ' + openSections.join(', '));
        component.set('v.mycolumns6', [
            {label: 'Custom Item Number', fieldName: 'Custom_Item_Number__c', type: 'text'},
            {label: 'Item', fieldName: 'Item__c', type: 'text'},
            
            {label: 'Status', fieldName: 'SCMC__Status__c', type: 'text'},
            {label: 'Quantity', fieldName: 'SCMC__Quantity__c', type: 'text'},
            {label: 'Quantity Shipped', fieldName: 'SCMC__Quantity_Shipped__c', type: 'text'},
            {label: 'Ext. Price', fieldName: 'SCMC__Extended_Price__c', type: 'text'},
        ]);
            component.set('v.mycolumns3', [
            {label: 'Packaging List Name', fieldName: 'Name', type: 'text'},
            {label: 'Status', fieldName: 'SCMC__Status__c', type: 'text'},
            {label: 'Item', fieldName: 'Item_Name__c', type: 'text'},
            {label: 'Quantity', fieldName: 'SCMC__Quantity__c', type: 'text'},
            {label: 'Issuing Warehouse', fieldName: 'SCMC__Issueing_Warehouse__c	', type: 'text'},
        ]);
        
        if (openSections.length === 0) {
            console.log('good');
            
        } else{
            console.log(' ids are : '  + openSections);
            
            var action = component.get("c.getSOLIdisplay");
            console.log('non iitems id isssss :  ' + openSections.join(', '));
            action.setParams({
                "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state sis : '  + state);
                if (state === "SUCCESS") {
                    component.set("v.solidisplayList", response.getReturnValue());
                    console.log('SOLI on '+ openSections + ' are : ' + response.getReturnValue());
                    
                }
                else
                {
                    var errors = response.getError();
                    console.log(errors);
                    console.log('err : '+ errors[0].message); 
                }
                
            });
            $A.enqueueAction(action);
            console.log('done with the SOLI');
            
            var action = component.get("c.getPicklistDetail");
            console.log('picklist id isssss to get picklistdetails is :  ' + openSections.join(', '));
            action.setParams({
                "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state sis : '  + state);
                if (state === "SUCCESS") {
                    var results =  response.getReturnValue();
                    results.forEach(function(rec){
                        rec.itemName = rec.SCMC__Item__r.Name;
                    })
                    component.set("v.pklList", results);
                    console.log('picklistdetail on '+ openSections + ' are : ' +  JSON.stringify((response.getReturnValue())));
                    
                }
                else
                {
                    var errors = response.getError();
                    console.log(errors);
                    console.log('err : '+ errors[0].message); 
                }
                
            });
            $A.enqueueAction(action);
            console.log('done with the picklistdetail');
            
        }
    },
    handleToggleSection7: function(component, event, helper){
        var openSections = event.getParam('openSections');
            if (openSections.length === 0) {
                console.log('good');
            } 
            else{
                console.log(' ids are : '  + openSections);
                var action = component.get("c.getPicklistDetaildisplay");
                console.log('PicklistDetail id isssss :  ' + openSections.join(', '));
                action.setParams({
                    "sid" : openSections.join(','),
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    console.log('state sis : '  + state);
                    if (state === "SUCCESS") {
                        component.set("v.pkldisplayList", response.getReturnValue());
                        console.log('PicklistDetail on '+ openSections + ' are : ' + response.getReturnValue());
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
            
	handleToggleSection8: function(component, event, helper){
        var openSections = event.getParam('openSections');
        console.log('You are inside Sales order history and id is : ' + JSON.stringify(response.getReturnValue()));
        component.set('v.mycolumns7', [
            {label: 'User', fieldName: 'parentName', type: 'text',initialWidth: 150},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'text',initialWidth: 150},
            {label: 'Action', fieldName: 'action', type: 'text'},
            
        ]);
        if (openSections.length === 0) {
            console.log('good');
            } 
        else{
            console.log(' ids are : '  + openSections);
            var action = component.get("c.getSOHdisplay");
            console.log('non iitems id isssss :  ' + openSections.join(', '));
            action.setParams({
            "sid" : openSections.join(','),
            });
            action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state sis : '  + state);
            if (state === "SUCCESS") {
            component.set("v.soHdisplayList", response.getReturnValue());
            console.log('SOH on '+ openSections + ' are : ' + response.getReturnValue());
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
        handleToggleSection9 : function(component, event, helper){
            var openSections = event.getParam('openSections');
            if (openSections.length === 0) {
                console.log('good');
            } 
            else{
                console.log(' ids are : '  + openSections);
                var action = component.get("c.getInventoryActionQueuedisplay");
                console.log('InventoryActionQueued id isssss :  ' + openSections.join(', '));
                action.setParams({
                    "pId" : openSections.join(','),
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    console.log('state sis : '  + state);
                    if (state === "SUCCESS") {
                        component.set("v.iaqdisplayList", response.getReturnValue());
                        console.log('IA on '+ openSections + ' are : ' + response.getReturnValue());
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
        }
    
})