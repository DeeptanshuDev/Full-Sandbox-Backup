({
    DEBOUNCE_TIMEOUT: null,
    DEBOUNCE_DURATION: 600,

    searchFor: function (component, helper, searchString) {
        component.set("v.latitude", null);
        component.set("v.longitude", null);
        component.set("v.isLocationModified", true);

        helper.showSpinner(component);

        clearTimeout(helper.DEBOUNCE_TIMEOUT);
        helper.DEBOUNCE_TIMEOUT = setTimeout($A.getCallback(
            function() {
                helper.openResultBox(component, helper, searchString);
            }
        ), helper.DEBOUNCE_DURATION);
    },

    openResultBox: function (component, helper, searchString) {

        component.set("v.error", "");

        var sessionToken = "" || component.get("v.sessionToken");
        var params = {
          "input": component.get("v.value") || '',
          "types": "geocode",
          "sessionToken": sessionToken
        }
        var extraOptions = {
            afterFunction: helper.hideSpinner
        };
        BASE.baseUtils.executeAction(component, helper, "c.getPredictions", params, helper.getPredictionsSuccess, extraOptions);

        BASE.baseUtils.addClickoutsideListener(component, null, helper, ['cxsLookupOptionsContainer','searchInput'], function() {

            if(component.get("v.isCallingPlacesApi") == true) {
                // added a timeout to clears out location after get places call which happens on click of a result
                setTimeout($A.getCallback(function() {
                    helper.onClickOutside(component, null, helper);
                }), 1000);
            }
            else {
                helper.onClickOutside(component, null, helper);
            }
        });
    },

    getPredictionsSuccess: function(component, helper, responseValues){

		if(responseValues.isSuccess) {
		    var response = responseValues.body;
		    var showResults = [];

		    var valueString = component.get("v.value");
            if(valueString) {
                valueString = valueString.trim();
            }

            component.set("v.showResults", true);

            if(response.sessionToken) {
                component.set("v.sessionToken", response.sessionToken);
            }
            if(response.predictions && response.predictions.length) {

                component.set("v.noResultsFound", false);

                for(var thisResult of response.predictions) {
                    var findIndex = -1;
                    if (typeof valueString != 'undefined') {
                        findIndex = thisResult.description.toLowerCase().indexOf(valueString.toLowerCase());
                    }
                    var label = thisResult.description;
                    if(findIndex != -1) {
                        var part1 = thisResult.description.substring(0, findIndex);
                        var part2 = thisResult.description.substr(findIndex, valueString.length);
                        var part3 = thisResult.description.substr(findIndex + valueString.length);
                        var formattedLabel = part1 + "<mark>" + part2 + "</mark>" + part3;
                        label = formattedLabel;
                    }
                    showResults.push({
                        "prediction": thisResult,
                        "formattedLabel": label
                    });
                }

                component.set("v.predictions", showResults);
            } else {
                component.set("v.noResultsFound", true);
                component.set("v.predictions", []);
            }
        }
	},

	onClickOutside: function(component, event, helper) {
        if(component.get("v.isLocationModified") == true) {
            if(component.get("v.latitude") == null && component.get("v.longitude") == null) {
                helper.showInvalidReferenceError(component, helper);
            } else {
                component.set("v.error", "");
            }
        }
    },

	selectResult: function(component, event, helper, index) {
        helper.showSpinner(component);
	    var extraOptions = {
            afterFunction: helper.getPlaceDetailsAfterFunction
        };
        component.set("v.isCallingPlacesApi", true);
        var placeId = component.get("v.predictions")[index].prediction.place_id;

        var params = {
            "placeId" : placeId,
            "sessionToken": component.get("v.sessionToken")
        };
        component.set("v.sessionToken", "");
        component.set("v.value", event.currentTarget.dataset.description);

        BASE.baseUtils.executeAction(component, helper, "c.getPlaceDetails", params, helper.getPlaceDetailsSuccess, extraOptions);
        
        var el = document.getElementById('search-location-input');
        el.focus();
	},

	getPlaceDetailsSuccess: function(component, helper, responseValues){

        if(responseValues.isSuccess) {
            var response = responseValues.body;
            component.set("v.predictions", []);
            component.set("v.showResults", false);

            var country = "";
            for(var addressComponent of response.result.address_components) {
                if(addressComponent.types.indexOf("country") !== -1) {
                    country = addressComponent.long_name;
                    break;
                }
            }
            var value = component.get("v.value");
            var countryIndexStart = value.indexOf(", " + country);
            if(countryIndexStart !== -1) {
                value = value.slice(0, countryIndexStart);
                component.set("v.value", value);
            }
            helper.setLocation(component, response.result.geometry.location.lat, response.result.geometry.location.lng);
            helper.fireLocationChangedEvent(component, response.result.geometry.location.lat, response.result.geometry.location.lng, country);
        }
	},

	getPlaceDetailsAfterFunction: function(component) {
	    component.set("v.isCallingPlacesApi", false);
	    component.set("v.showSearchSpinner", false);
    },

    clearField: function(component, event, helper) {
        component.set("v.value", "");
        component.set("v.predictions", []);
        component.set("v.showResults", false);
        helper.setLocation(component, null, null);
        helper.fireLocationChangedEvent(component, null, null, null);
    },

	fireLocationChangedEvent: function(component, lat, lng, country) {

	    var namespacePrefix = BASE.baseUtils.getObjectPrefix(component);
        var data = [{
            "name": namespacePrefix + "Geolocation__Latitude__s",
            "value": lat,
        }, {
            "name": namespacePrefix + "Geolocation__Longitude__s",
            "value": lng,
        }, {
            "name": namespacePrefix + "GeoLocation_status__c",
            "value": "Prefilled"
        }, {
            "name": namespacePrefix + "Country__c",
            "value": country
        }];

        BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_CHANGED, data);
    },

    setLocation: function(component, lat, lng) {
        component.set("v.latitude", lat);
        component.set("v.longitude", lng);
    },

	onKey: function(component, event, helper, type) {
        var keyCode = event.getParams().keyCode;

        if(type == 'keyup') {

            var searchString = component.get("v.value");

            // Enter/return key
            if(keyCode == 13) {
                event.preventDefault();
                event.stopPropagation();
                return;
            }
            // tab key and arrow keys are processed on keydown, so ignore it on keyup
            else if (keyCode == 9 || keyCode == 38 || keyCode == 40) {
                return;
            }

            if(searchString) {
                searchString = searchString.trim();
            }

            if(searchString) {
                helper.searchFor(component, helper, searchString);
            }
        }

        else if(type == 'keydown') {
            // Tab key
            if(keyCode == 9) {
                helper.onClickOutside(component, null, helper);
            }
            // UpArrow/DownArrow keys
            else if(keyCode == 38 || keyCode == 40) {
                return;
            }
        }
    },

    showInvalidReferenceError: function(component, helper) {
        var value = component.get("v.value");
        if(value) {
            component.set("v.error", "Invalid Reference");
        }
        component.set("v.predictions", []);
        component.set("v.showResults", false);
        helper.fireLocationChangedEvent(component, null, null, null);
    },

    hideSpinner:function(component) {
        component.set("v.showSearchSpinner", false);
    },

    showSpinner:function(component) {
        component.set("v.showSearchSpinner", true);
    }
})