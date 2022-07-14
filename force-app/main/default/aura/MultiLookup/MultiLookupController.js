({
        doInit : function(component, event, helper) {
            var value = component.get('v.value');
            if(value) {
                helper.retrieveDisplayValues(component, event, helper);
            }
        },

        LookupChanged: function(component, event, helper) {
            setTimeout(function(){
                var lookupValue = component.get('v.lookupValue');
                var lookupDisplayValue = component.get('v.lookupDisplay');
                var multiValue = component.get('v.objectList');
                if(lookupValue && lookupValue != '' && lookupDisplayValue != '') {
                    var found = false;
                    for(var x=0,xSize=multiValue.length; x < xSize; x++) {
                        if(multiValue[x].value ==lookupValue) {
                            found = true;
                        }
                    }
                    if(!found) {
                        multiValue.push({"value":lookupValue,"displayValue":lookupDisplayValue});
                    }

                    component.set('v.lookupValue','');
                    component.set('v.lookupDisplay','');
                    component.set('v.objectList',multiValue);
                    component.set('v.error','');
                }
            },300);
        },

        removeSelected: function(component, event, helper) {
            var multiValue = component.get('v.objectList');
            event.preventDefault();
            var chosenId = event.currentTarget.dataset.index;
            for(var x=0,xSize=multiValue.length; x < xSize; x++) {
                if(multiValue[x].value == chosenId) {
                    multiValue.splice(x,1);
                    component.set('v.objectList',multiValue);
                    break;
                }
            }
        },

        objectListChanged: function(component, event, helper) {
            var objectList = component.get('v.objectList');
            var newValue = '';
            var sep = '';
            for(var x=0,xSize=objectList.length; x < xSize; x++) {
                newValue += sep + objectList[x].value;
                sep = ',';
            }

            component.set('v.value',newValue);
        },

        setLookupValueAction: function(component, event, helper) {
            var params = event.getParam('arguments');
            var value = params.data.lookupValue;
            component.set("v.value", value);
            if (value) {
                helper.retrieveDisplayValues(component, event, helper);
            }
            else {
                var objectList = [];
                component.set('v.objectList',objectList);
            }
        },
})