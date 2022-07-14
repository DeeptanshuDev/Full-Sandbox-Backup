(function (BASE) {
    BASE.baseUtils = {
        executeAction: function(component, helper, action, parameters, successCallback, extraOptions) {
            // Accepted extraOptions:
            // scope(Object)               = jsonObject to passthrough to error- and successCallback
            // delayEnqueueAction(Boolean) = use the delays the enqeueAction for 10 ms
            // toastError(Boolean)         = show the error in a toast
            // errorFunction (Function) = execute this function for errorFunction callback
            // afterFunction (Function)    = execute this function after the successCallback and errorCallback functions
            
            var actionName = action+'';
            var action = component.get(action);
            if(action) {
                action.setParams(parameters);
                if(extraOptions && extraOptions.isStorable) {
                    action.setStorable();
                }
                
                //set extraOptions.toastError to true by default. You can override it to false if needed
                if(!extraOptions){
                    extraOptions = {};
                }
                if(extraOptions.toastError == null || extraOptions.toastError == undefined){
                    extraOptions.toastError = true;
                }
                action.setCallback(this, function(response) {
                    var scope = {};
                    if(extraOptions && extraOptions.scope) {
                        scope = extraOptions.scope;
                    }
                    
                    if (response.getState() === "SUCCESS") {
                        var result = response.getReturnValue();
                        if(successCallback) {
                            successCallback(component, helper, result, scope);
                        }
                    }
                    else if (response.getState() === "ERROR") {
                        var errorMessages = response.getError();
                        
                        if(typeof errorMessages === "string") {
                            errorMessages = [{message: errorMessages}];
                        }
                        
                        for(var c = 0; c < errorMessages.length; c++) {
                            var errorMessage = errorMessages[c].message;
                            if(extraOptions && extraOptions.toastError) {
                                this.showToast(errorMessage,"error")
                            }
                        }
                        if(extraOptions && extraOptions.errorFunction) {
                            extraOptions.errorFunction(component, helper, errorMessages, scope);
                        }
                    }
                    
                    if(extraOptions && extraOptions.afterFunction) {
                        extraOptions.afterFunction(component, helper, scope);
                    }
                });
                
                if(extraOptions && extraOptions.delayEnqueueAction) {
                    setTimeout(
                        $A.getCallback(function() {
                            $A.enqueueAction(action);
                        })
                        ,10)
                }
                else {
                    $A.enqueueAction(action);
                }
            }
            else {
                console.log('No action found',action,component, helper, actionName, parameters, successCallback, extraOptions);
            }
        },
        
        /*
        	Method to fire show toast message system event
    	*/
        showToast: function(message, toastType, toastMode) {
            
            // toastTypes : error, warning, success, or info (default is other);
            if(!toastType) {
                toastType = "other";
            }
            
            // toastMode : dismissible(default), pester or sticky;
            if(!toastMode) {
                toastMode = "dismissible";
            }
            
            //showToast System Event
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "message": message,
                "type": toastType,
                "mode": toastMode
            });
            toastEvent.fire();
        },
        
        /*
        	Method to get the package prefix, this will return the prefix without the double underscore or c depending on the situation
    	*/
        getPackagePrefix: function(component) {
            var prefix = component.getType().split(":")[0];
            return prefix;
        },
        
        /*
        	Method to get the object prefix, this will return the prefix with the double underscore or empty depending on the situation
    	*/
        getObjectPrefix: function(component) {
            var prefix = this.getPackagePrefix(component);
            prefix = prefix == 'c' ? '' : prefix+'__';
            return prefix;
        },
        
        /*
        	Method to invoke force:createRecord system event
    	*/
        createRecord: function(sObjectName, packagePrefix, defaultValueParam, recordTypeId) {

            //force:createRecord system event
            var createRecordEvent = $A.get("e.force:createRecord");

            //Checking for the package prefix existance
            if(sObjectName && !sObjectName.includes(packagePrefix + "__") && sObjectName.includes("__c")) {
                sObjectName = packagePrefix + "__" + sObjectName;
            }

            //Paramaters
            var params = {
                "entityApiName": sObjectName,
                "defaultFieldValues": defaultValueParam,
                "recordTypeId": recordTypeId
            };

            //Setting params and firing events
            createRecordEvent.setParams(params);
            createRecordEvent.fire();
    	},

        /*
        	Method to invoke force:editRecord system event
    	*/
        editRecord: function(recordId) {

            //force:editRecord system event for updating the current talent pool record
            var editRecordEvent = $A.get("e.force:editRecord");
            editRecordEvent.setParams({
                "recordId": recordId
            });
            editRecordEvent.fire();
        },

        /*
        	Method to create dynamic confirmation dialog
    	*/
		showConfirmationDialog: function(component, helper, data) {

            // here data accepts attributes defined in dialog.cmp, headerText and bodyText are required
            $A.createComponent(
                BASE.baseUtils.getPackagePrefix(component) + ":Dialog",
                data,
                function(msgBox){
                    if (component.isValid()) {
                        var targetCmp = component.find("ModalDialogPlaceholder");
                        var body = targetCmp.get("v.body");
                        body.push(msgBox);
                        targetCmp.set("v.body", body);
                    }
            });
        },
        
        createComponents:function(component, helper, components, successCallback, scope) {
            $A.createComponents(components,
				function(components, status, errorMessage){
                    if (status === "SUCCESS") {
                        successCallback(component, helper, components, scope);
                    }
                    else if (status === "INCOMPLETE") {
                        this.showToast("No response from server or client is offline.", "error")
                    }
                    else if (status === "ERROR") {
						this.showToast("Error: "+errorMessage, "error")
					}
                }
			);
        },
        
        //This method is used to retry the create component for customer component and package component .
         //First it will try to create customer custom component and after that it will try using package prefix.
        createComponentsWithPrefixFallback: function(component, helper, components, successCallback, scope) {
            var retryFunction = this.createComponents;
            var componentsToCreate = components;
            var packagePrefix = this.getPackagePrefix(component);
            $A.createComponents(componentsToCreate,
                function(componentsToCreate, status, errorMessage) {
                    if (status === "SUCCESS") {
                        successCallback(component, helper, componentsToCreate, scope);
                    } else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.", "error")
                    } else if (status === "ERROR") {

                        var errorMessages = [].concat(errorMessage);
                        for (var i = 0; i < errorMessages.length; i++) {
                            if (errorMessages[i].status === 'ERROR') {

                                var currentComponent = components[i];
                                var componentName = JSON.stringify(Object.values(currentComponent)[0]);
                                var componentPrefix = componentName.substring(1, componentName.indexOf(":"));
                                var prefixUpdate;
                                if (componentPrefix == 'c') {
                                    prefixUpdate = componentName.replace("c:", packagePrefix + ':');
                                } else {
                                    prefixUpdate = componentName.replace(packagePrefix  + ':', "c:");
                                }
                                currentComponent[0] = JSON.parse(prefixUpdate);
                                components[i] = currentComponent;
                            }
                        }

                        retryFunction(component, helper, components, successCallback, scope);
                    }
                }
            );
        },

        navigateToURL:function(redirectURL) {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": redirectURL
            });
            urlEvent.fire();
        },
        
        navigateToCustomComponent:function(customComponentName, selectedRecordId) {
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:" + customComponentName,
                componentAttributes: {
                    selectedRecordId : selectedRecordId
                }
            });
            evt.fire();
        },

        /**
         * Sometimes context is needed from an (onclick) event. The thing is that the event is generated from the element
         * click on and not the element holding the event handler, so we might need to search up through the dom to get the
         * id.
         * @param event The event trigged by the user.
         * @returns either the value of the id attribute closest in the dom, when searching up. Or null when nothing is found.
         */
        getIdFromEvent: function(event) {
            var target = event.currentTarget;

            while(target != null) {
                if(target.id != '' && target.id != undefined) {
                    return target.id;
                }
                else {
                    target = target.parentNode;
                }
            }
            return null;
        },

        
        /*
        * Get a specific label, takes care of the label prefix
        * Also accepts and formats any extra arguments passed:
        *
        * Example:
        *  label 'objectCreated' = '{0} was successfully created'
        *  helper.getLabel(component, 'objectCreated', 'Candidate')
       */
        getLabel: function(component, labelName) {
            var label  = $A.get("$Label.c." + labelName);
            if( label.charCodeAt(0) == 91 || label=='' ) {
                label = this.getLabelDev(component, labelName);
            }
            
            if(arguments.length > 2) {
                for(var i = 0; i < arguments.length - 2; i++) {
                    label = label.replace(new RegExp('\\{'+i+'\\}', 'gi') , arguments[ i + 2 ]);
                }
            }
            
            return label;
        },
        
        getLabelDev: function(component, labelName,forceTr1) {
            var prefix = 'c';
            if(forceTr1) {
                prefix = 'c';
            }
            
            var label  = $A.get("$Label."+prefix+"." + labelName);
            
            if( (label.charCodeAt(0) == 91 || label=='') && !forceTr1 ) {
                this.getLabelDev(component, labelName, true);
            }
            return label;
        },
        
        /*
        	Method to check whether utility bar exists or not
    	*/
        doUtilityBarExists : function(utilityAPI,result) {
            utilityAPI.getAllUtilityInfo().then(function (response) {
                var myUtilityInfo = response[0];
                if(typeof myUtilityInfo !== 'undefined')
                    result(true);
                else
                    result(false);
            });
        },

        /*
            Return a deep copy of a given object
        */
        cloneObject : function(component, event, helper, myObject) {
            if(myObject) {
                try {
                    return JSON.parse(JSON.stringify(myObject));
                }
                catch(e) {
                    console.log('cloneObject failed',e);
                    return myObject;
                }
            }
            else {
                return myObject;
            }
        },

        /**
         * Sometimes context is needed from an (onclick) event. The thing is that the event is generated from the element
         * click on and not the element holding the event handler, so we might need to search up through the dom to get the
         * id.
         * @param event The event trigged by the user.
         * @returns either the value of the id attribute closest in the dom of component with event listener. Or null when nothing is found.
         */
        getIdOfCurrentTargetFromEvent: function(event) {
            var target = event.currentTarget;

            while(target != null) {
                if(target.id != '') {
                    return target.id;
                }
                else {
                    target = target.parentNode;
                }
            }
            return null;
        },

        componentScrollToClass: function(component, helper, className, offset) {
             offset = offset || -160;
             var parentContainer = component.get('v.parentContainer');
             if(parentContainer){
                 // _panelInstance is a standard property of lightning:overlayLibrary object. This hack was done because of modal window.
                 if(parentContainer._panelInstance && parentContainer._panelInstance.elements && parentContainer._panelInstance.elements[0]  ){
                    this.scrollToClass(className, offset,parentContainer._panelInstance.elements[0].querySelector('.scrollable'));
                 }else{
                    this.scrollToClass(className, offset,parentContainer);
                 }
             }
             else{
                 this.scrollToClass(className, offset);
             }
        },
    	
        scrollToClass:function(className, extraOffset, containerElement) {
            function scrollStepToClass(containerElement, scrollIteration, scrollTarget) {
                setTimeout(function() {
                    if (!containerElement) {
                        window.scrollBy(0, scrollTarget/50);
                    }
                    else {
                         containerElement.scrollTop += scrollTarget/50;
                    }
                    var newScrollIteratie = scrollIteration++;
                    if(scrollIteration < 50) {
                        scrollStepToClass(containerElement, scrollIteration, scrollTarget);
                    }
                }, 10);
            }

            setTimeout(function() {
                var elements = document.getElementsByClassName(className);
                if(containerElement) {
                    elements = containerElement.getElementsByClassName(className);
                }
                if(elements.length > 0){
                    if (!containerElement) {
                        scrollStepToClass(null, 0, elements[0].getBoundingClientRect().top + extraOffset);
                    }
                    else {
                        scrollStepToClass(containerElement, 0, elements[0].getBoundingClientRect().top + extraOffset);
                    }
                }
            }, 10);
        },

        /*
            Transforms a Map to an Array so we can iterate over it with an <aura:iteration /> component:

            {
                someKey: "someValue",
                anotherKey: ['some', 'values']
            }

            is transformed to:

            [{
               key: "someKey",
               value: "someValue"
            },{
               key: "anotherKey",
               value: ['some', 'values']
            }];

        */
        transformMapToArray: function(map) {
            if(!map) {
                return;
            }

            var arr = [];

            for(var key in map) {
                if(map.hasOwnProperty(key)) {
                    arr.push({
                        key: key,
                        value: map[key]
                    });
                }
            }
            return arr;
        },

        isArray: function(obj) {
            return Array.isArray(obj);
        },

        /*
        	Method to parse html
        */
        parseHtml: function(htmlString) {
            var parser = new DOMParser;
            return parser.parseFromString('<!doctype html><body>' + htmlString,'text/html').body.textContent;
        },

        /*
         	Method to navigate to sObject
        */
        navigateToSObject:function(recordId) {
            var navigationSObject = $A.get("e.force:navigateToSObject");
            navigationSObject.setParams({
                "recordId": recordId
            });
            navigationSObject.fire();
        },

        /*
         	Method to navigate to Component
        */
        navigateToComponent: function(componentDef, componentAttributes) {
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : componentDef,
                componentAttributes: componentAttributes
            });
            evt.fire();
        },

        resolveDynamicLabel:function(component, name) {
            if(component != null && name != null) {
                var value = component.get(name);

                if(value && value.match('^[a-zA-Z]\\w*$')) {
                    var labelName = '$Label.c.'+value;
                    var labelReference = $A.getReference(labelName);
                    component.set(name, labelReference);
                }
            }
        },

        handleDynamicLabelChange:function(component, name, loadingName) {
            if(component != null && name != null) {
                var value = component.get(name);

                if(value && (value.indexOf('$Label.c.') == 0 || value.indexOf('$Label.cxs'+'rec.') == 0)) {

                    if(value.indexOf('$Label.c.') == 0) {
                        var labelName = value.substring(0, value.indexOf(' ')).replace('c', 'cxs'+'rec');
                        var labelReference = $A.getReference(labelName);
                        component.set(name, labelReference);
                    }

                    if(value.indexOf('$Label.c.') != 0 && value.indexOf('$Label.cxs'+'rec.') == 0) {
                        value = value.substring(0, value.indexOf(' ')).replace('$Label.cxs'+'rec.', '');
                        component.set(name, value);
                    }
                }
            }
        },

        /*
            Add an eventListener to the page that runs the callback when someone clicks outside of the area defined by the array of auraIds.
            Note: all auraIds must refer to html elements, not lightning elements.
        */
        addClickoutsideListener: function(component, event, helper, auraIds, callback) {
            var self = this;
            setTimeout($A.getCallback(function() {
                window.addEventListener('click', $A.getCallback(function(e) {
                    let inside = false;
                    if(!Array.isArray(auraIds)) {
                        auraIds = [auraIds];
                    }

                    for(let auraId of auraIds) {
                        let clickArea = component.find(auraId);
                        if (clickArea) {
                            let clickAreaElement = clickArea.getElement();
                            if(clickAreaElement != null){
                                let rect = clickAreaElement.getBoundingClientRect();
                                if(e.clientX > rect.left && e.clientX < rect.left + rect.width && e.clientY > rect.top && e.clientY < rect.top + rect.height) {
                                    inside = true;
                                    break;
                                }

                            }
                        }
                    }
                    if(inside) {
                        self.addClickoutsideListener(component, event, helper, auraIds, callback);
                    }
                    else {
                        callback.call();
                    }
                }), {
                    once: true
                });

            }), 1);
        },

        /*
         Returns all subStrings between thwo characters in a string
         Example:- getStringsBetween.get("<ul><li>He</li><li>is</li><li>a</li><li>boy</li></ul>","<li>","</li>");
         Result:- He,is,a,boy
        */
        getStringsBetween : {
            results:[],
            string:"",
            getFromBetween: function (sub1,sub2) {
                if(this.string.indexOf(sub1) < 0 || this.string.indexOf(sub2) < 0) return false;
                var SP = this.string.indexOf(sub1)+sub1.length;
                var string1 = this.string.substr(0,SP);
                var string2 = this.string.substr(SP);
                var TP = string1.length + string2.indexOf(sub2);
                return this.string.substring(SP,TP);
            },
            removeFromBetween: function (sub1,sub2) {
                if(this.string.indexOf(sub1) < 0 || this.string.indexOf(sub2) < 0) return false;
                var removal = sub1+this.getFromBetween(sub1,sub2)+sub2;
                this.string = this.string.replace(removal,"");
            },
            getAllResults: function (sub1,sub2) {
                if(this.string.indexOf(sub1) < 0 || this.string.indexOf(sub2) < 0) return;
                var result = this.getFromBetween(sub1,sub2);
                this.results.push(result);
                this.removeFromBetween(sub1,sub2);
                if(this.string.indexOf(sub1) > -1 && this.string.indexOf(sub2) > -1) {
                    this.getAllResults(sub1,sub2);
                }
                else return;
            },
            get: function (string,sub1,sub2) {
                this.results = [];
                this.string = string;
                this.getAllResults(sub1,sub2);
                return this.results;
            }
        },
        /*
        Returns html string by:
        Replacing all <br>,<br/> and </li> with '\n',Parsing HTML,And splitting string with '\n'
        */
        splitHtmlToPoints: function(htmlString) {
            htmlString = htmlString.replace(/<\/li\s*[\/]?>/gi,'\n');
            htmlString = htmlString.replace(/<br\s*[\/]?>/gi,'\n');
            htmlString = this.parseHtml(htmlString);
            return htmlString.split('\n');
        },
        /*
        Compares two RichTextArea Strings by removing:
        Line-breaks, spaces, htmlTags and return boolean result
        */
        compareRichTextChanges: function(string1, string2) {
            string1 = this.parseHtml(decodeURIComponent(string1)).replace(/\r?\n|\r/g,'').replace(/\s/g,'');
            string2 = this.parseHtml(decodeURIComponent(string2)).replace(/\r?\n|\r/g,'').replace(/\s/g,'');
            return string1 == string2;
        },

        isInAppBuilder : function() {
            return window.self !== window.top && window.self.name === 'surfaceFrame';
        },


        getRandomString : function(length) {
            var chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
            var result = '';
            for (var i = length; i > 0; --i) result += chars[Math.floor(Math.random() * chars.length)];
            return result;
        },
        /*
            1- left mouse button
            2- middle mouse button
            3- right mouse button
            3- ctrl+left mouse button
        */
        getMouseButtonCode : function(event) {
           var mouseButtonCode;
           if ("which" in event){ // Gecko (Firefox), WebKit (Safari/Chrome) & Opera
                mouseButtonCode = event.which ;
           }
           else if ("button" in event) { // IE, Opera
                mouseButtonCode = event.button +1;
           }
           if(event.ctrlKey == true){
               mouseButtonCode = 3;
           }
           return mouseButtonCode;
        },


        /**
         * This type provide static methods to make callouts like createComponent(s), executeAction using javascript promises.
         * Typical usage:
         *  BASE.baseUtils.PromiseCall
         *      .createComponent(component, type, params)
         *      .then(result => {
         *          //handle success result
         *      })
         *      .catch(error => {
         *          //handle error
         *      })
         */
        PromiseCall : class PromiseCall {

            /**
             * Create single Aura.Component
             *
             * @param component - current component
             * @param name  - name of the component to be created without namespace
             * @param params    - plain js object with new component attributes name:value
             * @return {Promise<any>}
             */
            static createComponent(component, name, params) {
                let type = name.indexOf(':') !=-1 ? name : (BASE.baseUtils.getPackagePrefix(component) + ':' + name);
                return new Promise((resolve, reject) => {
                    $A.createComponent(type, params, function(newComponent, status, errorMessage) {
                        if (component.isValid() && status === 'SUCCESS') {
                            resolve(newComponent);
                        } else {
                            reject(errorMessage);
                        }
                    });
                });
            }

            /**
             * Create multiply components - Aura.Component[]
             *
             * @param component - current component
             * @param components    - components definitions to be created - [[compName1, params1],[compName2, params2],...]
             * @return {Promise<any>}
             */
            static createComponents(component, components) {
                return new Promise((resolve, reject) => {
                    $A.createComponents(components, function(newComponents, status, errorMessage) {
                        if (component.isValid() && status === 'SUCCESS') {
                            resolve(newComponents);
                        } else {
                            reject(errorMessage);
                        }
                    });
                });

            }

            /**
             * Utility method to create components with builder pattern
             *
             * @param component - current component
             * @return {ComponentsBuilder}
             *
             * @example typical usage:
             *
             * BASE.baseUtils.PromiseCall
             *  .getComponentsBuilder(component)
             *  .append('lightning:button', {'name': 'submit'})
             *  .append('lightning:button', {'name': 'reject'})
             *  .append('c:myComponent', {'aura:id': 'MyComponentLocalId'})
             *  .build()
             *  .then(newComponents => {
             *      //handle success result of components creating
             *  })
             *  .catch(errors => { //handle errors })
             *  .finally(() => { //do something anyway })
             */
            static getComponentsBuilder(component) {
                class ComponentsBuilder {
                    constructor() {
                        this._components = [];
                    }

                    append(type, params) {
                        this._components.push([type, params]);
                        return this;
                    }

                    build() {
                        return BASE.baseUtils.PromiseCall.createComponents(component, this._components);
                    }
                }
                return new ComponentsBuilder();
            }

            /**
             * Execute @AuraEnabled method of Apex controller using using Promise
             *
             * @param component - lightning component with Apex Controller
             * @param name  - name of the @AuraEnabled method (both variants are acceptable: 'getData' and 'c.getData')
             * @param params    - plain js object with method parameters
             * @param flags - array of extra options like storable, eg: ['setStorable','setAbortable']
             * @return {Promise<any>}   - Promise object of the callout execution
             *
             * @example executeAction(component, 'queryRecordsByIds', {'ids': ids}, ['setStorable'])
             *              .then(result => {
             *                  //on success
             *              })
             *              .catch(errors => {
             *                  //on fail
             *              })
             *              .finally(() => {
             *                  //execute anyway
             *              })
             */
            static executeAction(component, name, params, flags) {
                var action = component.get(name && !name.startsWith('c.') ? ('c.' + name) : name);
                if (!$A.util.isEmpty(params) && typeof(params) === 'object') {
                    action.setParams(params);
                } else if (typeof(params) !== 'object') {
                    throw 'Apex method params must be an object';
                }
                return new Promise((resolve, reject) => {
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (component.isValid() && state === 'SUCCESS') {
                            resolve(response.getReturnValue());
                        } else if (component.isValid() && state === 'INCOMPLETE') {
                            reject(response);
                        } else if (component.isValid() && state === 'ERROR') {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    reject(Error('Error message: ' + errors[0].message));
                                }
                            } else {
                                reject(Error('Unknown error'));
                            }
                        }
                    });
                    if (!$A.util.isEmpty(flags)) {
                        try {
                            flags.forEach(f => {
                                if (typeof(action[f]) === 'function') {
                                    action[f]()
                                }
                            });
                        } catch(e) {
                            console.error(e);
                        }

                    }
                    $A.enqueueAction(action);
                });
            }
		},
  	},

	BASE.componentEventUtils = {
        
        GENERIC_EVENT_CHANGED: 'CHANGED',
        GENERIC_EVENT_CANCELLED: 'CANCELLED',
        GENERIC_EVENT_SAVED: 'SAVED',
        GENERIC_EVENT_LOADED: 'LOADED',
        GENERIC_EVENT_DONE: 'DONE',
        GENERIC_EVENT_WORKING: 'WORKING',
        GENERIC_EVENT_WORKING_DONE: 'WORKING_DONE',
        GENERIC_EVENT_ERROR: 'ERROR',
        GENERIC_EVENT_LOOKUP_CHANGED: 'LOOKUP_CHANGED',
        GENERIC_EVENT_FILE_UPLOAD_SUCCESS: 'FILE_UPLOAD_SUCCESS',
        GENERIC_EVENT_FILE_UPLOAD_ERROR: 'FILE_UPLOAD_ERROR',
        GENERIC_EVENT_FILE_DELETE: 'FILE_DELETE',
        GENERIC_EVENT_FIELD_CHANGE: 'FIELD_CHANGE',
        GENERIC_EVENT_FIELD_KEYUP: 'FIELD_KEYUP',
        GENERIC_EVENT_NEXT: 'NEXT',
        GENERIC_EVENT_PREV: 'PREVIOUS',
        GENERIC_EVENT_FINISH: 'FINISH',
        GENERIC_EVENT_ROW_SELECTED: 'ROW_SELECTED',
        GENERIC_EVENT_ROW_DESELECTED: 'ROW_DESELECTED',
        GENERIC_USER_SETTINGS_CHANGED: 'USER_SETTINGS_CHANGED',
        GENERIC_EVENT_RECORD_SELECTED: 'RECORD_SELECTED',
        GENERIC_EVENT_REQUEST_SELECTED_RECORD_CHANGE: 'REQUEST_RECORD_CHANGED',
        GENERIC_EVENT_FILTER_CHANGED: 'FILTER_CHANGED',
        GENERIC_EVENT_FILTER_OPENED: 'FILTER_OPENED',
        GENERIC_EVENT_LISTVIEW_BUTTON_CLICKED: 'LISTVIEW_BUTTON_CLICKED',
        GENERIC_EVENT_RENDERED: 'RENDERED',
        GENERIC_EVENT_NO_ERROR: 'NO ERROR',
        GENERIC_EVENT_DELETE_RECORD : 'RECORD_DELETE',
        GENERIC_EVENT_UPDATE_RECORD : 'RECORD_UPDATE',
      	GENERIC_EVENT_REFRESH_VIEW  : 'REFRESH_VIEW',
      	GENERIC_EVENT_OPEN_MODAL_POPUP : 'OPEN_MODAL_POPUP',
      	GENERIC_EVENT_RATING_UPDATED : 'RATING_UPDATED',
        GENERIC_EVENT_TABLE_CELL_RATING_UPDATED : 'TABLE_CELL_RATING_UPDATED',
        GENERIC_EVENT_METADATA_ERROR: 'METADATA ERROR',
        GENERIC_EVENT_REFRESH_PREVIEW: 'REFRESH_PREVIEW',
        GENERIC_EVENT_STATE_CHANGED: 'STATE_CHANGED',
        GENERIC_EVENT_TABLECELLINPUT_CHANGED: 'TABLECELLINPUT_CHANGED',
        
        fireGenericComponentEvent: function(component, state, data, eventName) {
            var componentName = component.getType().split(":")[1];
            eventName = eventName || 'genericComponentEvent';
            var event = component.getEvent(eventName);
            
            if(!event) {
                console.error("Event not found: %s. Not registered on component?", eventName);
                return;
            }
            
            event.setParams({
                "sourceLocalId": component.getLocalId(),
                "sourceGlobalId": component.getGlobalId(),
                "source": componentName,
                "state": state,
                "data": data
            })
            .fire();
        },
        
        getGenericComponentEvent: function(event, debug) {
            return (function(event, debug) {
                
                if(!event) {
                    throw new Error("event can not be null");
                    return null;
                }
                
                var _event = event;
                var _source = event.getParam("source");
                var _sourceLocalId = event.getParam("sourceLocalId");
                var _sourceGlobalId = event.getParam("sourceGlobalId");
                var _state = event.getParam("state");
                var _data = event.getParam("data");
                
                function getEvent() {
                    return _event;
                }
                function getSource() {
                    return _source;
                }
                function getSourceGlobalId() {
                    return _sourceGlobalId;
                }
                function getSourceLocalId() {
                    return _sourceLocalId;
                }
                function isSource(componentName) {
                    return componentName && _source.toLowerCase() == componentName.toLowerCase();
                }
                function getState() {
                    return _state;
                }
                function getData() {
                    return _data || {};
                }
                
                if(debug) {
                    console.log("genericComponentEvent: ", {
                        sourceLocalId: _sourceLocalId,
                        sourceGlobalId: _sourceGlobalId,
                        source: _source,
                        state: _state,
                        data: _data
                    });
                }
                
                return {
                    getEvent: getEvent,
                    getSourceLocalId: getSourceLocalId,
                    getSourceGlobalId: getSourceGlobalId,
                    getSource: getSource,
                    isSource: isSource,
                    getState: getState,
                    getData: getData
                }
            })(event, debug);
        }
    },
                                   
    /**
		* Utility for creating modal dialogs with using of lightning:overlayLibrary.
        * It is required <lightning:overlayLibrary /> on component's markup.
        * Typical usage inside lightning component js helper:
        *
        openModalDialog: function(component, modalBodyComponent, modalHeaderComponent) {

               BASE.dialogBuilder
                .getInstance(modalBodyComponent, component.find('overlayLibraryLocalId')) // instantiate builder
                .cssClass('slds-modal_large my-custom-class') // provide extra css for modal
                .submitAction('Proceed', component.getReference('c.onSubmit')) // provide reference for submit action (by default appear as lightning brand button in the footer's right conner)
                .rejectAction('Close', component.getReference('c.onReject')) // provide reference for reject action (by default appear as lightning neutral button in the footer's right conner before the submit button)
                .extraAction('back', 'Back', component.getReference('c.onBack'), 'slds-float_left', 'brand', 'utility:back') // extra actions for better interactivity
                .extraAction('forward', 'Forward', component.getReference('c.onForward'), 'slds-float_left', 'brand', 'utility:forward', 'right')
                .extraAction('help', 'Help', component.getReference('c.onHelp'), '', 'success', 'utility:info', 'right')
                .header(modalHeaderComponent) // Aura.Component or plain text
                .body(modalBodyComponent) // Aura.Component or plain text
                .onClose(function() {  // do something on modal close, by default rejectAction is used })
                .build() // build dialog but not yet show in modal
                .showModal(); // open modal overlay panel with embedded dialog
           },

            closeModal: function(component, avoidCloseCallbackBehavior) {
                // avoidCloseCallbackBehavior - (optional) provide ability to avoid running of custom closeCallback on modal close
                BASE.dialogBuilder.closePopup(avoidCloseCallbackBehavior);
            }
	*/

    BASE.dialogBuilder = {

        _overlayLibrary: {},
        _overlayPanel: {},
        _actionsStorage: {},

	    _DialogBuilder: class DialogBuilder {
            constructor(component, overlayLibrary) {
                this.component = component;
                BASE.dialogBuilder._overlayLibrary = overlayLibrary;
                this._defaultActions = {
                    'reject' : [],
                    'submit' : []
                };
                this._extraActions = [];
                BASE.dialogBuilder._actionsStorage = Object.defineProperty({}, '__default__', {
                    enumerable: false,
                    configurable: false,
                    writable: false,
                    value: 'static'
                });

            }
            submitAction(label, callback, properties) {
                this._defaultActions.submit = [['lightning:button', {
                    'name' : 'submit',
                    'label' : label || BASE.baseUtils.getLabel(this.component, 'Apply'),
                    'variant' : 'brand',
                    'disabled' : properties && properties.disabled,
                    'onclick' : this._getCallbackReference('submit', callback)
                }]];
                return this;
            }
            rejectAction(label, callback) {
                this._closeCallback = callback;
                this._defaultActions.reject = [['lightning:button', {
                    'name' : 'reject',
                    'label' : label || BASE.baseUtils.getLabel(this.component, 'Cancel'),
                    'onclick' : this._getCallbackReference('reject', callback)
                }]];
                return this;
            }
            extraAction(name, label, callback, cssClass, variant, iconName, iconPosition) {
                this._extraActions.push(
                    ['lightning:button', {
                        'name' : name,
                        'label' : label,
                        'variant' : variant || 'neutral',
                        'class' : cssClass,
                        'onclick' : this._getCallbackReference(name, callback),
                        'iconName' : iconName,
                        'iconPosition' : iconPosition || 'left'
                    }]
                );
                return this;
            }
            onClose(callback) {
                this._closeCallback = callback;
                return this;
            }
            header(content) {
                this._headerContent = content;
                return this;
            }
            body(content) {
                this._bodyContent = content;
                return this;
            }
            cssClass(cssClass) {
                this._cssClass = cssClass;
                return this;
            }
            build() {
                const _self = this;
                this.showModal = function () {

                    let showCustomModal = function (component, actions) {
                        BASE.dialogBuilder._overlayLibrary.showCustomModal({
                            'header' : _self._headerContent,
                            'body' : _self._bodyContent,
                            'footer' : actions,
                            'showCloseButton' : true,
                            'cssClass' : _self._cssClass,
                            'closeCallback' : function(){
                                if (_self._closeCallback && !BASE.dialogBuilder._dialogActionContext) {
                                    _self._closeCallback()
                                    BASE.dialogBuilder._overlayPanel = null;
                                } else {
                                    BASE.dialogBuilder._dialogActionContext = '';
                                }
                            }
                        }).then(overlay => {
                            overlay['content'] = _self._bodyContent;
                            BASE.dialogBuilder._overlayPanel = overlay;
                        }).catch(overlayError => {
                            console.error('Error on show modal dialog:', overlayError);
                        });
                    }

                    let actionButtons = this._extraActions
                        .concat(_self._defaultActions.reject)
                        .concat(_self._defaultActions.submit);

                    if (!$A.util.isEmpty(actionButtons)) {
                        BASE.baseUtils.PromiseCall.createComponents(_self.component, actionButtons)
                            .then(result => {
                                showCustomModal(_self.component, result)
                            })
                            .catch(errors => {
                                console.log('Error on create action buttons for dialog:', errors)
                            });
                    } else {
                        showCustomModal(_self.component);
                    }

                }
                return this;
            }

            _getCallbackReference(name, callback) {
                if (typeof callback === 'function') {
                    BASE.dialogBuilder._actionsStorage[name] = callback;
                    return function (component, event) {
                        let actionName = event.getSource().get('v.name');
                        BASE.dialogBuilder._actionsStorage[actionName || '__default__']();
                        if (actionName === 'submit' || actionName === 'reject') {
                            this.closePopup(actionName);
                        }
                    }
                }
                return callback;
            }
		},

        getInstance : function(component, overlayLibrary) {
            return new this._DialogBuilder(component, overlayLibrary);
        },

        /**
         * Close modal dialog
         *
         * @param context - provide any significant value (on cast to Boolean it must be "true") 
         * to avoid running custom closeCallback
         */
        closePopup : function (context) {
            this._dialogActionContext = context;
            const panel = this._overlayPanel;
            if (panel && panel.isVisible) {
                this._overlayPanel = null;
                panel.close();
            }
        },
	}                               

})(window.BASE = window.BASE || {});