({
    doInit: function (component, event, helper) {
        var thisRecordId = component.get('v.thisRecordId');
        if(thisRecordId != null) {
            var params = {"thisRecordId":thisRecordId};
            BASE.baseUtils.executeAction(component, helper, "c.getMemo", params, helper.getMemoSuccess, {toastError:true});
        }
    },
    
    editMemo: function (component, event, helper) {
        if(component.get('v.readOnlyMode') == true){
            component.set('v.edit',true);
            var memo = component.get('v.memo');
            if(memo) {
                memo = memo.split("<br>").join("\n");
                component.set('v.memo',memo);
            }
            if(ratingStatus) {
                ratingStatus.setEdit();
            }
            
            setTimeout(function(){
                component.find('memo-textarea').focus();
            }, 100);
        }
    },
    
    readMemo: function (component, event, helper) {
        helper.readMemo(component,helper);
    },
    
    doKeyup: function(component, event, helper) {
        
        if(event.keyCode == 27) {
            helper.closeMemo(component, event, helper);
        }
        if (event.keyCode == 9) {
            component.find('memo-textarea').focus();
        }
    },
    
    delayedReadMemo: function (component, event, helper) {
        setTimeout(function(){
            helper.readMemo(component,helper);
        },700);
    },
    
    save: function (component, event, helper) {
        var thisRecordId = component.get('v.thisRecordId');
        var memoString = component.find("memo-textarea").get('v.value');
        var params = {"thisRecordId":thisRecordId, "memoString":memoString};
        BASE.baseUtils.executeAction(component, helper, "c.setMemo", params, helper.getMemoSuccess, {toastError:true});
        component.set('v.memoOld',memoString.split("\n").join("<br>"));
        helper.mouseleave(component, event, helper);
    },
    
    setMemoValue: function (component, event, helper) {
        var args = event.getParams().arguments;
        component.set('v.memo',args.value);
    },
    
    doKeydown: function(component, event, helper) {
        if (event.keyCode == 9) {
            component.find('memo-textarea').focus();
        }
        if(event.keyCode == 27) {
            helper.closeMemo(component, event, helper);
        }
    },
})