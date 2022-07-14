/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.Sosl_search_placeholder
*/
({
    RESIZE_TIMEOUT: [],
    RESIZE_TIMEOUT_DURATION: 25,
    CALCULATE_EXTRA_MARGIN: 6,
    soslStringChangeTimeout: null,

    getInitInfo : function(component, event, helper) {

        let fields = component.get("v.fields") || [];
        let filters = component.get("v.filters");
        let requiredDefaultFilters = component.get("v.requiredDefaultFilters");

        if(filters && filters.filterFields && filters.filterFields.length > 0) {
            for(const filterField of filters.filterFields) {
                if(!filterField.hidden && !fields.includes(filterField.fieldName) && !requiredDefaultFilters.includes(filterField.fieldName)) {
                    fields.push(filterField.fieldName);
                }
            }
        }

        var params = {
            sObjectName : component.get('v.sObjectName'),
            fields : fields,
            fieldSet: component.get("v.fieldSet")
        };
        var extraOptions = {
            isStorable: true,
        };

        BASE.baseUtils.executeAction(component, helper, "c.getFiltersInitInfo", params, function(component, helper, result) {
            result.fieldDescribe && component.set("v.fieldsDescribe", result.fieldDescribe);
            component.set("v.amountFiltersRenderRemaining", component.get("v.fieldsDescribe").length);
            var labelReference = $A.getReference("$Label.c.Sosl_search_placeholder");
            component.set("v.preloadedLabel", labelReference );

            let components = [
                ['lightning:input', {
                    "aura:id": "sosl-search",
                    type: "search",
                    label: "_",
                    name:"search",
                    value:component.getReference("v.soslString"),
                    placeholder: component.get("v.preloadedLabel"),
                    variant: "label-hidden",
                    "class": "slds-size--1-of-1 sosl-search slds-float--right"
                }]
            ];
			
            let sOSLCompExists = component.get("v.enableSoslFilter");
            if(sOSLCompExists) {
            	BASE.baseUtils.createComponents(component, helper, components, (component, helper, components, scope) => {
                	component.find("sosl-search-input-container").set("v.body", components);
            	});    
            }
            
        }, extraOptions);
    },

    onFilterRender: function(component, event, helper) {
        component.set("v.amountFiltersRenderRemaining", component.get("v.amountFiltersRenderRemaining") - 1);

        if(component.get("v.amountFiltersRenderRemaining") == 0) {

            helper.setHighlightOverflowButton(component, event, helper);
            helper.addResizeListener(component, event, helper);
    
            setTimeout($A.getCallback(function() {
                let filterComponents = [].concat(component.find("DataServiceFilter"));
    
                for(let filterComponent of filterComponents) {
                    if(filterComponent){
                        var element = filterComponent.getElement();
                        if (element != null) {
                            filterComponent.width = element.offsetWidth + helper.CALCULATE_EXTRA_MARGIN;
                            filterComponent.height = element.offsetHeight + helper.CALCULATE_EXTRA_MARGIN;
                        }
                    }

                }
    
                component.set("v.filterComponents", filterComponents);
                component.set("v.overflowFilterComponents", component.find("DataServiceFilterOverflow"));
    
                helper.setShowClearAllButton(component, event, helper);
            }), 1);
            
        }
    },

    closeOverflowFilters: function(component, event, helper) {
        component.find("overflow-dropdown").close();
        helper.setHighlightOverflowButton(component, event, helper);
    },

    closeOtherFilters: function(component, event, helper) {
        var genericComponentEvent = BASE.componentEventUtils.getGenericComponentEvent(event);

        // Close the overflow container when opening a non-overflow filter
        if(genericComponentEvent.getSourceLocalId() == "DataServiceFilter") {
            helper.closeOverflowFilters(component, event, helper);
        }
    },

    setHighlightOverflowButton: function(component, event, helper) {
        // find out if we have filters active in the overflow area so we can highlight the button
        let filterComponents = component.get("v.filterComponents");
        let index = filterComponents.findIndex(filterComponent => filterComponent.isOverflow && filterComponent.getFilterValues().length > 0);
        component.set("v.highlightOverflowButton", index > -1);
    },

    setShowClearAllButton: function(component, event, helper) {
        var filtersOnPage = component.get("v.fieldsDescribe");
		var showClearAllButton = false;
		let filters = component.get("v.filters");
        let filterComponents = component.get("v.filterComponents");
        if(filterComponents){
             let index = filterComponents.findIndex(filterComponent => filterComponent.getFilterValues().length > 0);
             component.set("v.showClearAllButton", index > -1 || (filters && !!filters.soslString));
        }
	},

    isOverflowFilter: function(component, event, helper, fieldName) {
        return component.get("v.fieldsDescribeOverflow").filter(function(field) {
            return field.fieldName == fieldName
        }).length > 0;
    },

    addResizeListener: function(component, event, helper) {
        window.addEventListener('resize', $A.getCallback(function() {
            clearTimeout(helper.RESIZE_TIMEOUT[component.getGlobalId()]);
            if(component.find("rootElement")){
                component.find("rootElement").getElement().style.overflow = "hidden";
                helper.RESIZE_TIMEOUT[component.getGlobalId()] = setTimeout($A.getCallback(function() {
                    helper.determineOverflowFilters(component, event, helper);
                }), 200);
            }

            const rootElement = component.find("rootElement");

            if(rootElement && rootElement.getElement()) {
                rootElement.getElement().style.overflow = "hidden";
            }

            helper.RESIZE_TIMEOUT[component.getGlobalId()] = setTimeout($A.getCallback(function() {
                helper.determineOverflowFilters(component, event, helper);
            }), 200);

        }));

        setTimeout($A.getCallback(function() {
            helper.determineOverflowFilters(component, event, helper);
        }), helper.RESIZE_TIMEOUT_DURATION);
    },

    determineOverflowFilters: function(component, event, helper) {
        let filterComponents = component.get("v.filterComponents");
        let overflowFilterComponents = component.get("v.overflowFilterComponents");

        let widthUsed = 0;
        let availableWidth;
        const rootElement = component.find("rootElement");

        if(rootElement && rootElement.getElement()) {
            availableWidth = rootElement.getElement().clientWidth - 36;
        }
        else {
            return;
        }

        let buttonClear = component.find("button-clear");
        let buttonSoslFilter = component.find("sosl-filter-button")

        if(buttonClear && buttonClear.getElement()) {
            availableWidth -= (buttonClear.getElement().getBoundingClientRect().width + helper.CALCULATE_EXTRA_MARGIN);
        }

        if(buttonSoslFilter && buttonSoslFilter.getElement()) {
            availableWidth -= (buttonSoslFilter.getElement().getBoundingClientRect().width + helper.CALCULATE_EXTRA_MARGIN);
        }

        let isOverflowNeeded = false;

        for(let filterComponent of filterComponents) {
            widthUsed += filterComponent.width;

            if(widthUsed > availableWidth) {
                isOverflowNeeded = true;
            }
            filterComponent.isOverflow = isOverflowNeeded;
        }
        component.set("v.isOverflowNeeded", isOverflowNeeded);

        component.find("rootElement").getElement().style.overflow = "";

        if(!isOverflowNeeded) {
            helper.closeOverflowFilters(component, event, helper);
        }

        for(let [i, filterComponent] of filterComponents.entries()) {
            filterComponent.set("v.hidden", filterComponent.isOverflow);
            filterComponent.setDropdownPosition();
            overflowFilterComponents[i].set("v.hidden", !filterComponent.isOverflow);
        }

        helper.setHighlightOverflowButton(component, event, helper);

    },

    onSoslStringChange: function(component, event, helper) {
        this.soslStringChangeTimeout && clearTimeout(this.soslStringChangeTimeout);

        var callback = function() {
            let soslString = component.get("v.soslString");
            let filters = component.get("v.filters");
            
            if(!filters) {
                return;
            }

            // filter out the sosl operators before applying the sosl search string.
            // Use a `new RegExp()` here since inline regex doesn't work as asterix characters will be replaced with the `\\u002A` Unicode character by the Lightning framework
            // See: https://salesforce.stackexchange.com/questions/162197/lightning-component-regex-doesnt-work/162198
            let soslOperatorsRegex = new RegExp('\\?|\\*|\\(|\\)', 'g');
            soslString = (soslString && soslString.replace(soslOperatorsRegex, '').trim().length >= 2) ? soslString : "";

            if(soslString != (filters.soslString ? filters.soslString : "")) {
                filters.soslString = soslString;
                component.set("v.filters", filters);
            }
            helper.setShowClearAllButton(component, event, helper);
        }

        if(!component.get("v.soslString") || component.get("v.soslString") == '') {
            callback();
        }
        else {
            this.soslStringChangeTimeout = setTimeout($A.getCallback(callback), 500);
        }

    },
})