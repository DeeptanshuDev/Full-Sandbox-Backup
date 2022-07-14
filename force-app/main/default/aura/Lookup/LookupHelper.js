({
    DEBOUNCE_TIMEOUT: null,
    DEBOUNCE_DURATION: 250,

    searchFor:  function (component, helper, searchString) {
        clearTimeout(helper.DEBOUNCE_TIMEOUT);
        helper.DEBOUNCE_TIMEOUT = setTimeout($A.getCallback(
            function() { 
                component.set("v.hasId", false);
                var showAllResultsLink = component.get("v.showAllResultsLink");
                var isOptional = component.get("v.isOptional");
                helper.openResultBox(component, helper, searchString, !showAllResultsLink && isOptional);
            }
        ), helper.DEBOUNCE_DURATION);
    },

    openResultBox: function (component, helper, searchString, removeFilters) {
        if(!component.get("v.isInitDone")) {
            window.setTimeout(
                $A.getCallback(function() {
                    helper.openResultBox(component, helper, searchString);
                }), 100
            );
        }
        else {
            var extraResultFields = component.get('v.extraResultFields');
            var whereField = component.get('v.whereField');
            var whereValue = component.get('v.whereValue');
            var params ={
                type : component.get("v.referencedObjectName"),
                searchString : searchString,
                fieldList: JSON.stringify(component.get('v.fieldList')),
                removeFilters: removeFilters
            };
            
            if(extraResultFields && extraResultFields.length > 0) {
                params['extraResultFields'] = extraResultFields;
            }
            
            if(whereField && whereValue) {
                params['whereField'] = whereField;
                params['whereValue'] = whereValue;
            }
            
            BASE.baseUtils.executeAction(component, helper, "c.searchSObject", params, helper.searchDone);
            helper.showResults(component, helper);
            component.set("v.showResults", true);
            BASE.baseUtils.addClickoutsideListener(component, null, helper, ['cxsLookupOptionsContainer','searchInput'], function() {
                helper.onClickOutside(component, null, helper);
            });
        }
    },

    searchDone: function(component, helper, responseValues) {
        var responseArray = JSON.parse(responseValues);
        component.set("v.searchResultList", null);
        component.set("v.searchResultMap", null);
        var searchResultList = component.get("v.searchResultList");
        var searchResultMap = component.get("v.searchResultMap");
        if(searchResultList == null) {
            searchResultList = [];
        }
        if(searchResultMap == null) {
            searchResultMap = {};
        }
        for(var x in responseArray) {
            var thisResponse = responseArray[x];
            if(!searchResultMap[thisResponse.id]) {
                searchResultMap[thisResponse.id] = thisResponse.value;
                searchResultList.push(thisResponse);
            }
        }
        component.set("v.searchResultMap", searchResultMap);
        component.set("v.searchResultList", searchResultList);

        // empty the focusedResult
        component.set("v.focusedResult", null);

        helper.showResults(component, helper,true);
        component.set("v.showResultsList",true);
    },

    showResults: function(component, helper, withServerResults) {
         if(withServerResults) {
             component.set("v.showSearchSpinner", false);
         }
         else {
             component.set("v.showSearchSpinner", true);
             component.set("v.showResults", true);
         }
         var autoSelectExactName = component.get('v.autoSelectExactName');
         var showResults = [];
         var searchResultList = component.get("v.searchResultList");
         var valueString = component.get("v.displayValue");
         if(valueString) {
             valueString = valueString.trim();
         }
         if (typeof valueString == 'undefined') {
            valueString = '';
         }

         var limit = 20;
         for(var thisResult of searchResultList) {
             var findIndex = -1;
            if (typeof valueString != 'undefined') {
                 findIndex = thisResult.value.toLowerCase().indexOf(valueString.toLowerCase());
             }
             if(findIndex != -1) {
                 var part1 = thisResult.value.substring(0, findIndex);
                 var part2 = thisResult.value.substr(findIndex, valueString.length);
                 var part3 = thisResult.value.substr(findIndex + valueString.length);
                 var showValue = part1 + '<mark>' + part2 + '</mark>' + part3;
                 var extraInfo = thisResult.extraResultData.slice(0).join(', ');
                 showResults.push({
                     "id": thisResult.id,
                     "value": thisResult.value,
                     "showValue": showValue,
                     "index": findIndex,
                     "extraInfo": extraInfo
                 });
             }
         }
         if(valueString == '') {
             showResults.sort(helper.sortAll);
         }
         else {
             showResults.sort(helper.sortResults);
         }
         if(showResults.length > limit) {
             showResults.length = limit;
         }

        // clear the value for blue
         component.set("v.valueOnBlur", {});

         // set the value when there was single record in result, this would be used for onBlur operation
         if(showResults != undefined && showResults.length === 1 && autoSelectExactName != false && showResults[0].value.toLowerCase() == valueString.toLowerCase()) {
             var param = {
                 "value": showResults[0].id,
                 "displayValue": showResults[0].value
             };
             component.set("v.valueOnBlur", param);
         }

         component.set("v.results", showResults);

         if(withServerResults && (showResults != undefined && showResults.length === 0)) {
             component.set("v.noResultsFound", true);
         }
         else {
             component.set("v.noResultsFound", false);
         }
    },

    hideResults: function(component, event, helper) {
        var valueOnBlur = component.get("v.valueOnBlur");
        // onBlur it would auto-select the record if single record was present in search result
        if(valueOnBlur && valueOnBlur.value && valueOnBlur.displayValue) {
            helper.setLookupAttributes(component, event, helper, valueOnBlur);
        }
        component.set("v.showResults", false);
        
        component.set("v.showAllResultsLink",component.get("v.isOptional"));
        component.set("v.showResultsList",false);

        var searchString = component.get("v.displayValue");
        if(component.get("v.hasId") != true && searchString != null && searchString != "") {
            component.set("v.error", 'Invalid Reference');
        }
        else {
            component.set("v.error","");
        }

        component.set("v.focusedResult", null);
    },

    focusResult: function(component, event, helper, direction) {
        var results = component.get("v.results");
        var focusedResult = component.get("v.focusedResult");
        var index = -1;

        if(!results || results.length == 0) {
            return;
        }

        // find the currently focused result's index
        for(var i = 0; i < results.length; i++) {
            if(results[i].id == focusedResult) {
                index = i;
                break;
            }
        }

        if(index == -1) {
            index = direction == 'DOWN' ? 0 : results.length - 1;
        }
        else {
            // navigate up or down
            index = index + (direction == 'DOWN' ? 1 : -1);

            if(index < 0) {
                index = results.length - 1;
            }
            if(index > results.length - 1) {
                index = 0;
            }
        }

        var container = component.find('cxsLookupOptionsContainer');
        var options = component.find('cxsLookupOption');

        if(container && !Array.isArray(container)) {
        	container = [container];
        }

        if(options && !Array.isArray(options)) {
        	options = [options];
        }

        if(container && container.length > 0 && options && options.length > 0) {
        	const containerElement = container[0].getElement(),
        		  optionElement = options[index].getElement(),
        		  topPos = optionElement.offsetTop,
        		  optionHeight = optionElement.clientHeight,
        		  containerHeight = containerElement.clientHeight,
        		  scrollTop = containerElement.scrollTop;

        	if(topPos + optionHeight > containerHeight + scrollTop || topPos < scrollTop) {
        	    if(direction == 'DOWN') {
        		    containerElement.scrollTop = topPos + optionHeight - containerHeight;
                }
                else {
                    containerElement.scrollTop = topPos;
                }
        	}

        }

        component.set("v.focusedResult", results[index].id);
    },

    selectResult: function(component, event, helper, id) {

        var searchResultMap = component.get("v.searchResultMap");
        var chosenResult = searchResultMap[id];

        var param = {
            "value": id,
            "displayValue": chosenResult
        };
        helper.setLookupAttributes(component, event, helper, param);

        helper.hideResults(component, event, helper);
        var el = document.getElementById('search-input');
		el.focus();
    },

    sortResults: function(a, b) {
        if(a == b) {
            if(a.showValue < b.showValue) return -1;
            if(a.showValue > b.showValue) return 1;
        }
        return a.index - b.index;
    },

    sortAll: function(a, b) {
        if(a.showValue < b.showValue) return -1;
        if(a.showValue > b.showValue) return 1;
        return 0;
    },

    setObjectLabel: function(component, event, helper) {
        var namePointingList = component.get('v.namePointingList');
        if(namePointingList.length > 1) {
            var referencedObjectName =  component.get('v.referencedObjectName');
            var referencedObjectLabel = component.get('v.referencedObjectLabel');
            for(var x = 0, xSize = namePointingList.length; x < xSize; x++) {
                if(namePointingList[x].objectName == referencedObjectName) {
                    referencedObjectLabel = namePointingList[x].objectLabel;
                }
            }
            component.set('v.referencedObjectLabel', referencedObjectLabel);
            component.set("v.extraResultFields", []);
        }
    },

    setLookupAttributes: function(component, event, helper, param) {

        if(param && param.value && param.displayValue) {
            component.set("v.value", param.value);
            component.set("v.displayValue", param.displayValue);
            component.set("v.hasId", true);

            if(param.value && component.get("v.oldValue") !== param.value) {
                helper.fireEventOnLookupChange(component, event, helper);
            }
            component.set("v.oldValue", param.value);
        }
    },

    clearField: function(component, event, helper) {
        if(component.get("v.value")) {
            component.set("v.value", null);
            helper.fireEventOnLookupChange(component, event, helper);
        }
        component.set("v.displayValue", "");
        component.set("v.value", null);
        component.set("v.oldValue", null);
        component.set("v.hasId", true);
        component.set("v.valueOnBlur", {});
        // Clearing these will clear the local cache.
        //component.set("v.searchResultMap", {});
        //component.set("v.searchResultList", []);
        component.set("v.results", []);
        component.set("v.error", "");
        component.set("v.showResults", false);
        component.set("v.focusedResult", null);
    },

    fireEventOnLookupChange: function(component, event, helper) {

        var lookupName = component.get("v.lookupApiName");
        // fire lookup event with the lookup related data
        var lookupData = {
            "value": component.get("v.value"),
            "oldValue": component.get("v.oldValue"),
            "displayValue": component.get("v.displayValue"),
            "fieldName": lookupName
        };
        BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_LOOKUP_CHANGED, lookupData);
    },

    onClickOutside: function(component, event, helper) {
        var valueOnBlur = component.get("v.valueOnBlur");
        // onclose it would auto-select the record if single record was present in search result
        if(valueOnBlur && valueOnBlur.value && valueOnBlur.displayValue) {
            helper.setLookupAttributes(component, event, helper, valueOnBlur);
        }
        helper.hideResults(component, event, helper);
    },

    onKey: function(component, event, helper, type) {
        var keyCode = event.getParams().keyCode;

        if(type == 'keyup') {
            
            var searchString = component.get("v.displayValue");

            // Enter/return key
            if(keyCode == 13) {
                event.preventDefault();
                event.stopPropagation();

                var focusedResult = component.get("v.focusedResult");
                if(focusedResult) {
                    helper.selectResult(component, event, helper, focusedResult);
                }
                return;
            }
            // tab key and arrow keys are processed on keydown, so ignore it on keyup
            else if (keyCode == 9 || keyCode == 38 || keyCode == 40) {
                return;
            }

            if(searchString) {
                searchString = searchString.trim();
            }

            if(searchString != null) {
                helper.searchFor(component, helper, searchString);
            }
            else if (searchString == null || searchString == '') {
                helper.clearField(component, event, helper);
                component.set("v.showResults", false);

                if(component.get("v.oldValue") !== component.get("v.value")) {
                    helper.fireEventOnLookupChange(component, event, helper);
                }
            }
            else {
                component.set("v.hasId", true);
                component.set("v.showResults", false);
            }
            component.set("v.value", null);

        }

        else if(type == 'keydown') {
            // Tab key
            if(keyCode == 9) {
                helper.hideResults(component, event, helper);
            }
            // UpArrow/DownArrow keys
            else if(keyCode == 38 || keyCode == 40) {
                helper.focusResult(component, event, helper, keyCode == 38 ? 'UP' : 'DOWN');
                return;
            }
        }
    }
})