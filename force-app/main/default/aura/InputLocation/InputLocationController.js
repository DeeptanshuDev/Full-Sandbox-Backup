({
    onKeyUp: function(component, event, helper) {
        helper.onKey(component, event, helper, 'keyup');
    },

    onKeyDown: function(component, event, helper) {
        helper.onKey(component, event, helper, 'keydown');
    },

    clickResult: function(component, event, helper) {
        event.preventDefault();
        helper.selectResult(component, event, helper, event.currentTarget.dataset.index);
    },

    clearField: function(component, event, helper) {
        event.preventDefault();
        helper.clearField(component, event, helper);
    },

    focus : function (component, event, helper) {
        const inputComponent = component.find('search-input');
        if (typeof(inputComponent.focus) === 'function') {
            inputComponent.focus();
        }
    }
})