/*
$Label.c.Record_has_been_clone_successfully
*/
({
    doInit : function(component, event, helper) {
        
        var utilityAPI = component.find('utilitybar');
        if(utilityAPI) {
            BASE.baseUtils.doUtilityBarExists(utilityAPI,function(hasUtilityBar) {
                component.set("v.hasUtilityBar",hasUtilityBar);
            });
        }
        component.set("v.fieldSetsDetails", helper.prepareResults(component, event, helper));
        
        var extraOptions = {
            toastError: true,
        };
        BASE.baseUtils.executeAction(component, helper, "c.checkCommunityUser", {}, helper.doInitSuccess, extraOptions);
    },
    
    //Success Method for getInit callback
    doInitSuccess : function(component, helper, result, event) {
        if(result) {
            component.set("v.isCommunityUser", result);
        }
        component.set("v.initDone",true);
    },
    
    prepareFilters : function(component, event, helper, recId, dataFilters) {
        var selectedOrderRecordId = component.get("v.selectedOrderRecordId");
        if(selectedOrderRecordId != null) {
            helper.prepareFilterForOrders(component, event, helper, selectedOrderRecordId);
            helper.prepareFiltersForCustomItems(component, event, helper, selectedOrderRecordId);
        }
    },
    
    /* filter values for the single opportunity table */
    prepareFilterForOrders : function(component, event, helper, recId) {
        let updatedFilterField = [];
        let opportunityFilter = {
            "restriction": "EQ",
            "filterValue": {
                "stringValues": [recId],
                "integerValues": [],
                "booleanValues": []
            },
            "fieldName": "id"
        }
        updatedFilterField.push(opportunityFilter);
        component.set("v.filtersOpp.filterFields", updatedFilterField);
    },
    
    /* filter values for the custom item table */
    prepareFiltersForCustomItems : function(component, event, helper, recId) {
        let updatedFilterField = [];
        let customItemFilter = {
            "restriction": "EQ",
            "filterValue": {
                "stringValues": [recId],
                "integerValues": [],
                "booleanValues": []
            },
            "fieldName": "Opportunity__c"
        }
        updatedFilterField.push(customItemFilter);
        
        let customItemGreyOutFilter = {
            "restriction": "NE",
            "filterValue": {
                "stringValues": ['Grey out'],
                "integerValues": [],
                "booleanValues": []
            },
            "fieldName": "Stage__c"
        }
        updatedFilterField.push(customItemGreyOutFilter);
        
        component.set("v.filtersCustomItem.filterFields", updatedFilterField);
    },    
    
    prepareResults : function(component, event, helper) {
        let results = [
            {
                "sectionHeader":"Selected Order",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Orders_Items_Reorder",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "Opportunity",
                "selectedRecordId": component.get("v.selectedOrderRecordId"),
                "recordTypeId": null,
                "readOnly": false,
                "isEmbedded": true,
                "buttonsVisible": false,
                "showToast": false,
                "editmodeAllowed":true,
                "columns": '2'
            }
        ];
        return results;
    },
    
    doDataClone: function(component, event, helper) {
        var fieldSet = component.find("oopFieldset");
        let customItemWrap = [];
        let oppDataWrap = {
            id : component.get("v.selectedOrderRecordId")
        };
        if(fieldSet) {
            var fieldSetArr = [].concat(fieldSet);
            let data = fieldSetArr[0].getAllDataAction(); //not working insafari
            for(let key in data) {
                oppDataWrap[data[key].name] = data[key].value;
            }
        }
        
        var selectedCustomItems = component.get("v.selectedCustomItems");
        let changedCustomItems = {};
        for(let item in selectedCustomItems){
            changedCustomItems[selectedCustomItems[item].id] = selectedCustomItems[item].Quantity__c; 
        }
        
        var dataScopeCustomItem = component.get("v.dataScopeCustomItem");
        for(let key in dataScopeCustomItem) {
            let recordId = dataScopeCustomItem[key].id;
            if(changedCustomItems.hasOwnProperty(recordId)) {
                customItemWrap.push({
                    quantity : dataScopeCustomItem[key]['Quantity__c'],
                    Id : recordId
                });
            }
        }
        var extraOptions = {
            toastError: true,
            isStorable:false
        };
        
        var parameters = {
            oppDataWrap: JSON.stringify(oppDataWrap), 
            customItemWrap: JSON.stringify(customItemWrap)
        };
        
        BASE.baseUtils.executeAction(component, helper, "c.doClone", parameters, helper.doDataCloneSuccess, extraOptions);
    },
    
    doDataCloneSuccess: function(component, helper, result) {
        if(result) {
            if(result.isSuccess) {
                component.set("v.doRefreshParent",true);
                component.set('v.successMessage', BASE.baseUtils.getLabel(component,'Record_has_been_clone_successfully'));
                component.set("v.showReorderSpinner",true);
                window.setTimeout(function(){
                    BASE.componentEventUtils.fireGenericComponentEvent(component, null, null, 'closeReorderOverlay');
                },3000);
            } else {
                BASE.baseUtils.showToast(result.message, result.status);
            }
        }
        component.set("v.initDone", true);
    }
})