({
    doInit: function(component, event, helper) {
        var defaultFilters = component.get("v.defaultFilters");

        if(defaultFilters && defaultFilters.filterFields) {
            for(var filterField of defaultFilters.filterFields) {
                if(filterField.fieldName == component.get("v.fieldDescribe").fieldName) {

                    filterField = new CXSDataServiceFilterField(filterField);

                    component.set("v.filterField", filterField);
                    component.set("v.amountSelected", filterField.getValuesLength());
                }
            }
        }
        if(!component.get("v.filterField")) {
            component.set("v.filterField", new CXSDataServiceFilterField({
                fieldName: component.get("v.fieldDescribe").fieldName,
                restriction: 'VALUEIN'
            }));
        }
    },

    findAllFilterValues: function(component, event, helper) {
        helper.findFilterValues(component, event, helper, true);
    },

    toggleFilterValue: function(component, event, helper) {
        helper.toggleFilterValue(component, event, helper);
    },

    onTermChange: function(component, event, helper) {
        // Don't do anything if the filter isn't opened
        if(!component.find("dropdown").isOpen()) {
            return;
        }

        helper.onTermChange(component, event, helper);
    },

    clear: function(component, event, helper) {
        helper.clear(component, event, helper);
    },

    applyFilter: function(component, event, helper) {
        helper.applyFilter(component, event, helper);
    },

    setValues: function(component, event, helper) {
        helper.setFilterValues(component, event, helper, event.getParams().arguments.values);
    },

    getValues: function(component, event, helper) {
        return component.get("v.filterField").getValues();
    },

    onFilterOpen: function(component, event, helper) {
        helper.onFilterOpen(component, event, helper);
    },

    onFilterClose: function(component, event, helper) {
        helper.onFilterClose(component, event, helper);
    },

    setDropdownPosition: function(component, event, helper) {
        helper.setDropdownPosition(component, event, helper);
    }
})