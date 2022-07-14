({
    doInit: function (component, event, helper) {
        var links = [];
        var text = component.get('v.text');
        if(text && text.indexOf('href="')!=-1){
            text = text.substr(text.indexOf('href="'));
            var linksStrings = text.split('href="');
            for(var a in linksStrings) {
                var thisLink = linksStrings[a];
                if(thisLink != '') {
                    var linkUrl = thisLink.substring(0,thisLink.indexOf('"'));
                    var linkText = thisLink.substring(thisLink.indexOf('>')+1,thisLink.indexOf('</a>'));
                    if(linkUrl && linkText) {
                        links.push({"url":linkUrl,"txt":linkText,"num":links.length});
                    }
                }
            }
        }
        component.set('v.links',links);
    },
    
    openLink: function (component, event, helper) {
        event.preventDefault();
        var linkNum = event.currentTarget.dataset.index;
        var link = component.get('v.links')[linkNum];
        var linkUrl = link.url;
        linkUrl = linkUrl.replace(/&amp;/g, '&');
        var params = {
            "url" : linkUrl,
            "sObjectName": component.get("v.sObjectName")
        };
        helper.openModalDialog(component, helper, params);
    }
})