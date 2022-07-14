({
    findAll: function(component, auraId) {
        var cmpStack = component.get('v.componentStack');
        var result = [];
        for (var i=0; i < cmpStack.length; i++) {
            var cmp = cmpStack[i].find(auraId);
            if (cmp) {
                result = result.concat(cmp);
            }
        }
        return result;
    }
})