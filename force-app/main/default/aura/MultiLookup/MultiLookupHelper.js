({
    retrieveDisplayValues : function(component, event, helper) {
        var value = component.get('v.value');
        var valueList = value.split(',');
        var params ={
            ids : valueList,
            objectName : component.get('v.referencedObjectName')
        };

        BASE.baseUtils.executeAction(component, helper, "c.retrieveDisplayValues", params, helper.retrieveDisplayDone);
    },
    retrieveDisplayDone : function(component, helper, responseValues) {
        var responseArray = JSON.parse(responseValues);
        var objectList = [];
        for(var x=0,xSize=responseArray.length; x < xSize; x++) {
            var newObject = {"value":responseArray[x].id,"displayValue":responseArray[x].value};
            objectList.push(newObject);
        }
        component.set('v.objectList',objectList);
    },
})