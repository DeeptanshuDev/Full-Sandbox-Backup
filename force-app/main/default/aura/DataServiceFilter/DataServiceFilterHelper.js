({
    /**
     * attribute to store the timeout used for the 'debounce' functionality on the search term input field
     */
    termChangedTimeout: null,

    onFilterOpen: function(component, event, helper) {
        let localSelectedValues = [];
        localSelectedValues = component.get("v.filterField").getValues().map(x => x != null ? helper.formatValue(component, x.toString()) : x);
        component.set("v.localSelectedValues", localSelectedValues);
        helper.findFilterValues(component, event, helper);
        BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_FILTER_OPENED, component.get("v.filterField"), 'onOpen');

        setTimeout($A.getCallback(() => {
            !component.get('v.fieldDescribe').hasGeolocationSearch && component.find('search-input').focus();
        }), 100);
    },

    onFilterClose: function(component, event, helper) {
        setTimeout($A.getCallback(function() {
            component.set("v.filterValues", null);
            component.set("v.term", null);
        }), 1);
    },

    setDropdownPosition: function(component, event, helper) {
        component.find("dropdown").setDropdownPosition();
    },

    setFilterValues: function(component, event, helper, values) {
        var filterField = component.get("v.filterField");
        var fieldDescribe = component.get("v.fieldDescribe");
		filterField.setValues(values, fieldDescribe.schemaType);
		component.set("v.amountSelected", fieldDescribe.hasGeolocationSearch ? 0 : values.length);
        component.set("v.filterField", filterField);
    },

    applyFilter: function(component, event, helper) {
        helper.setFilterValues(component, event, helper, component.get("v.localSelectedValues").slice());
        component.find("dropdown").close();
        helper.fireFilterChangeEvent(component, event, helper);  
    },

    clear: function(component, event, helper) {
        helper.setFilterValues(component, event, helper, []);
        component.find("dropdown").close();
        helper.fireFilterChangeEvent(component, event, helper);
    },

    fireFilterChangeEvent: function(component, event, helper) {
        BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_FILTER_CHANGED, component.get("v.filterField"), 'onChange');
    },

    findFilterValues: function(component, event, helper, showAllResults) {
        component.set("v.showSpinner", true);

        var params = {
            encryptedQueryStructureJson: component.get('v.queryStructure'),
            fieldDescribeJson: JSON.stringify(component.get("v.fieldDescribe")),
            term: component.get("v.term") || '',
            showAllResults: showAllResults,
            filterFieldJson: JSON.stringify(component.get("v.filterField"))
        };
        var extraOptions = {
            isStorable: true,
        };
        
        BASE.baseUtils.executeAction(component, helper, "c.getFilterValues", params, function(component,helper, result) {
            component.set("v.showSpinner", false);
            
            let filterValues = result.body.filterValues.map(x => {
                if($A.util.isEmpty(x.value)) {
                    x.value = null;
                } else {
                    x.value = helper.formatValue(component, x.value);
                }
                return x;
            });
            
            if(result && result.isSuccess) {
                component.set("v.filterValues", result.body.filterValues);
                component.set("v.hasMoreResults", result.body.hasMoreResults);
            }
            else {
                BASE.baseUtils.showToast(result.message, 'error');
            }
            helper.setFilterValuesCheckmarks(component, event, helper);

            // Determine the amount of selected filtervalues so we can show in the UI which have been selected
            let amountSelected = result.body.filterValues.filter(filterValue => filterValue.selected).length;
            component.set("v.amountSelectedVisible", amountSelected);

        }, extraOptions);

    },

    onTermChange: function(component, event, helper) {
        this.termChangedTimeout && clearTimeout(this.termChangedTimeout);
		var callback = function() {
            helper.findFilterValues(component, event, helper);
        }
		if(!component.get("v.term") || component.get("v.term") == '') {
            callback();
        }
        else {
            this.termChangedTimeout = setTimeout($A.getCallback(callback), 250);
        }
    },

    toggleFilterValue: function(component, event, helper) {
        var dataset = event.currentTarget.dataset;
        var localSelectedValues = component.get("v.localSelectedValues");
        var selectedValue = dataset.value;
		if(selectedValue == "null") {
            selectedValue = null;
        }
        // locally store the selected value
        if(localSelectedValues.indexOf(selectedValue) == -1) {
            localSelectedValues.push(selectedValue);
        }
        else {
            localSelectedValues = localSelectedValues.filter(function(value) {
                return value != selectedValue;
            });
        }
		component.set("v.localSelectedValues", localSelectedValues);
		this.setFilterValuesCheckmarks(component, event, helper);
    },

    /**
     *  Compare the selected values and localSelected values to determine which filterVaues should have the selected checkmark
     */
    setFilterValuesCheckmarks: function(component, event, helper) {
        // loop through the filterValues and set selected accordingly
        var filterValues = component.get("v.filterValues") || [];
        var localSelectedValues = component.get("v.localSelectedValues") || [];
        
        for(var filterValue of filterValues) {
            var value = helper.formatValue(component, filterValue.value);
            filterValue.selected = localSelectedValues.indexOf(value) > -1 || (!$A.util.isEmpty(value)  && localSelectedValues.indexOf(value.toString()) > -1);
        }
        component.set("v.filterValues", filterValues);
    },
            
    formatValue: function(component, recordId) {
        var isFieldTypeReference = component.get("v.fieldDescribe").type == "REFERENCE";
        // Convert a 18 character Id to an 15 character Id
        if(isFieldTypeReference && recordId && recordId.length > 15) {
            return recordId.slice(0, 15)
        }
        return recordId;
    },
})