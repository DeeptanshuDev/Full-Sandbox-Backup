({
    afterRender: function(component, helper) {
        this.superAfterRender();
        BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_RENDERED, {}, 'onRender');
    }
})