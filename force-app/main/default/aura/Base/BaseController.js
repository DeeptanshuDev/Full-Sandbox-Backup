/* LABEL PRELOADS, DO NOT REMOVE
$Label.c.Agree_terms_and_conditions
*/
({
    doInit:function(component, event, helper) {
        var cmpStack = [];
        cmpStack.push(component);
        component.set('v.componentStack',cmpStack);
        if($A.get("$Label.c.Agree_terms_and_conditions").indexOf("$Label") != 0) {
            component.set("v.packagePrefix", component.getType().split(":")[0] + "__");
            component.set("v.labelPrefix", component.getType().split(":")[0]);
        }
    }
})