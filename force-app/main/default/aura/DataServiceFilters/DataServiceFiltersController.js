({
    doInit: function(component, event, helper) {
        var filters = component.get("v.filters");
        if(!filters) {
            component.set("v.filters", {
                filterFields: []
            });
        }else{
            // needed to restore a sosl search string after navigation (fpr example from browse mode)
            if(filters.soslString){
               component.set('v.soslString' , filters.soslString) ;
            }
        }

        helper.getInitInfo(component, event, helper);
    },

    clearAll: function(component, event, helper) {
        var filterComponents = component.find('DataServiceFilter');

        if(BASE.baseUtils.isArray(filterComponents)) {
            for(var filterComponent of filterComponents) {
                filterComponent.clear();
            }
        }
        else {
            filterComponents && filterComponents.clear();
        }

        component.set("v.soslString", "");
    },

    onFilterOpen: function(component, event, helper) {
        helper.closeOtherFilters(component, event, helper);
    },

    onFilterChange: function(component, event, helper) {
        var genericComponentEvent = BASE.componentEventUtils.getGenericComponentEvent(event);
        var filterField = genericComponentEvent.getData();

        var filters = component.get("v.filters");
        if(!filters){
           filters = {};
           filters.filterFields = [];
        }
        var index = filters.filterFields.findIndex(x => x.fieldName == filterField.fieldName);

        filterField = new CXSDataServiceFilterField(filterField);

        // Change (or remove) the filterField in the filterFields array
        if(index != -1) {
            if(filterField.hasValues()) {
                filters.filterFields.splice(index, 1, new CXSDataServiceFilterField(filterField));
            }
            // No filter values, remove the filterField from the filterFields array
            else {
                filters.filterFields.splice(index, 1);
            }
        }
        // Add the filterField to the filterFields array if there are values selected
        else if(filterField.hasValues()) {
            filters.filterFields.push(filterField);
        }

        component.set("v.filters", filters);

        helper.setHighlightOverflowButton(component, event, helper);

        // Find the corresponding overflow (or non-overflow) filter and apply the same values to it
        let sourceFilters = genericComponentEvent.getSourceLocalId() == "DataServiceFilter" ? component.get("v.filterComponents") : component.get("v.overflowFilterComponents");
        let targetFilters = genericComponentEvent.getSourceLocalId() == "DataServiceFilter" ? component.get("v.overflowFilterComponents") : component.get("v.filterComponents");

        index = sourceFilters.findIndex(filterComponent => filterComponent.getGlobalId() == genericComponentEvent.getSourceGlobalId());

        if(index != -1) {
            targetFilters[index].setFilterValues(filterField.getValues());
        }

        helper.setShowClearAllButton(component, event, helper);

        // recalcuate the overflow filters
        setTimeout($A.getCallback(function() {
            helper.determineOverflowFilters(component, event, helper);
        }), helper.RESIZE_TIMEOUT_DURATION)
    },

    onFilterRender: function(component, event, helper) {
        helper.onFilterRender(component, event, helper);
    },

    onSoslStringChange: function(component, event, helper) {
        helper.onSoslStringChange(component, event, helper);
    },
    
    toggleSoslFilter: function(component, event, helper) {
        component.set("v.showSoslFilter", !component.get("v.showSoslFilter"));
        setTimeout($A.getCallback(() => {
            if(component.get("v.showSoslFilter")) {
                component.find("sosl-search").focus();
            }
        }), 100);
    }
    
})