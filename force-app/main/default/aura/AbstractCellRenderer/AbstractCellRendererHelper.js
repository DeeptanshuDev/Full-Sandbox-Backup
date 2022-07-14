/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.Base_URL_Classic
*/
({
    getComponentSpec: function(cmp,row,typeDescribe, value,helper) {
        var type = typeDescribe.type;
        var objName = typeDescribe.sObjectName;
        if(typeDescribe.isHiddenField ){
            return null;
        }
        var rowId;
        if(row && row.id){
            rowId = row.id;
        } else if(row && row.Id){
            rowId = row.Id;
        }
        switch (type) {
            case 'STRING':               return helper.createStringField(cmp, helper, row, rowId, typeDescribe, objName, value); break;
            case 'TEXTAREA':             return helper.createTextAreaField(cmp, helper, row, typeDescribe, value); break;
            case 'ENCRYPTEDSTRING':      return helper.createEncryptedStringField(cmp, helper, row, typeDescribe, value); break;
            case 'BOOLEAN':              return helper.createCheckboxField(cmp, helper, row, typeDescribe, value); break;
            case 'CURRENCY':             return helper.createCurrencyField(cmp, helper, row, typeDescribe, value); break;
            case 'DATE':                 return helper.createDateField(cmp, helper, row, typeDescribe, value); break;
            case 'DATETIME':             return helper.createDateTimeField(cmp, helper, row, typeDescribe, value); break;
            case 'EMAIL':                return helper.createEmailField(cmp, helper, row, typeDescribe, value); break;
            case 'DOUBLE':               return helper.createNumberField(cmp, helper, row, rowId, typeDescribe, value); break;
            case 'REFERENCE':            return helper.createLinkField(cmp, helper, row, typeDescribe, value); break;
            case 'PERCENT':              return helper.createPercentField(cmp, helper, row, typeDescribe, value); break;
            case 'MATCHING':             return helper.createMatchingField(cmp, helper, row, typeDescribe, value); break;
            case 'PHONE':                return helper.createPhoneField(cmp, helper, row, typeDescribe, value); break;
            case 'FAX':                  return helper.createStringField(cmp, helper, row, rowId, typeDescribe, objName, value); break;
            case 'PICKLIST':             return helper.createStringField(cmp, helper, row, rowId, typeDescribe, objName, value); break;
            case 'MULTIPICKLIST':        return helper.createStringField(cmp, helper, row, rowId, typeDescribe, objName, value); break;
            case 'URL':                  return helper.createUrlField(cmp, helper, row, typeDescribe, value); break;
            case 'RATING':               return helper.createRatingField(cmp, helper, row, rowId, typeDescribe, value); break;
            case 'DOCUMENTS':            return helper.createDocument(cmp, helper, row, typeDescribe, value); break;
            case 'FAVOURITE':            return helper.createFavourite(cmp, helper, row, rowId, typeDescribe, value); break;
            case 'REQUIREMENTS':         return helper.createTextAreaField(cmp, helper, row, typeDescribe, value); break;
            case 'RICHTEXT':             return helper.createTextAreaField(cmp, helper, row, typeDescribe, value); break;
            default:                     return helper.createStringField(cmp, helper, row, rowId, typeDescribe, objName, value); break;
        }
    },
    
    createStringField: function (controller, helper, row, rowId, type, objName, value) {
        var generateReferenceLink = controller.get("v.generateReferenceLink");
        // Render unescaped HTML for formula fields
        if(type.fieldName && type.fieldName.toLowerCase() =='id' && generateReferenceLink){
            return helper.createLinkField(controller, helper, row, type, value);
        }
        if(type.isCalculated) {
            return {
                 name: 'lightning:formattedRichText',
                 attributes: {
                    value: value
                 }
            }
        }
        else if (type.fieldName && type.fieldName.toLowerCase() === 'name' && generateReferenceLink) {
            
        	var communityUser = controller.get("v.isCommunityUser");
            var navigationType;
            if(controller.get("v.navigationType")) {
            	navigationType = controller.get("v.navigationType");    
            }
            var linkBody;
            if(communityUser) {
                if(value && rowId) {
                    if(navigationType == 'CommunityPage') {
                        if(objName == 'Opportunity') {
                            linkBody = '<a href="/customers/s/opportunity-detail-page?oppId=';
                            linkBody += rowId;
                            linkBody += '&objName=' + objName;
                            linkBody += '&customComponentName=' + '';
                            linkBody += '&isCommunityUser=' + communityUser;
                            linkBody += '&showSpinner=' + 'true';
                            linkBody += '" target="_blank">' + value + '</a>';    
                        }
                    } else if(navigationType == 'Overlay' || objName == 'SCMC__Sales_Order__c') {
                        return {
                            name: BASE.baseUtils.getPackagePrefix(controller)+ ':TableCellReference',
                            attributes: {
                                objName: objName,
                                customComponentName: 'ObjectDetailPage',
                                id:rowId,
                                name: value,
                                isCommunityUser: communityUser
                            }
                        }
                    } else {
                        linkBody = '<a href="/customers/s/detail/'+rowId+ '" target="_blank">' + value + '</a>'; 
                    }
                }
            } else {//Base_URL_Classic $A
                //linkBody = '<a href="/'+rowId+ '" target="_blank">' + value + '</a>';
                let baseUrl = $A.get("$Label.c.Base_URL_Classic");
                baseUrl = baseUrl.endsWith("/")?baseUrl:baseUrl+'/';
                linkBody = '<a href="'+ baseUrl +rowId+ '" target="_blank">' + value + '</a>';
            }
            
            if(value && rowId){
                return {
                    name: 'lightning:formattedRichText',
                    attributes: {
                        value: linkBody
                    }
                }
            }
        }
        // Normal output text
        else {
            return {
                 name: 'ui:outputText',
                 attributes: {
                    value: value
                 }
            }
        }
    },
    createLinkField: function (controller, helper, row, type, value) {
        var linkName = value;
		if(row.extraData && row.extraData[type.fieldName]){
            linkName = row.extraData[type.fieldName].displayValue;
        }
        var linkBody = linkName && value ? '<a href="/'+value+ '" target="_top">' + linkName + '</a>' : '';
        return {
            name: 'lightning:formattedRichText',
            attributes: {
                value: linkBody
            }
        }
    },
    createDocument: function (controller, helper, row, type, value) {
        return {
            name: BASE.baseUtils.getPackagePrefix(controller)+':TableLinkModal',
            attributes: {
                text: value,
                "sObjectName": type.sObjectName
            }
        }
    },
    createFavourite: function (controller, helper, row, rowId, type, value) {
        return {
            name: BASE.baseUtils.getPackagePrefix(controller)+':Favourite',
            attributes: {
                id: rowId,
                value: value,
                row: controller.getReference("v.row")
            }
        }
    },
    createDateField: function (controller, helper, row, type, value) {
        return {
            //  name: row.extraData && row.extraData[type.fieldName] ? 'lightning:formattedDate' : 'ui:outputDate',
            name: 'ui:outputDate',
            attributes: {
                value: row.extraData && row.extraData[type.fieldName] ? row.extraData[type.fieldName].dateValue : value,
                year: 'numeric',
                month: 'numeric',
                day: 'numeric'
            }
        }
    },
    createDateTimeField: function (controller, helper, row, type, value) {
        return {
            name: row.extraData && row.extraData[type.fieldName] ? 'lightning:formattedDateTime' :  'ui:outputDateTime',
            //   name: 'ui:outputDateTime',
            attributes: {
                value: row.extraData && row.extraData[type.fieldName] ? row.extraData[type.fieldName].dateTimeValue : value ,
                year: 'numeric',
                month: 'numeric',
                day: 'numeric',
                hour: 'numeric',
                minute: '2-digit',
                second: '2-digit',
                timeZone: $A.get("$Locale").timezone
            }
        }
    },
    
    createEncryptedStringField: function (controller, helper, row, type, value) {
        return {
            name: 'ui:outputSecret',
            attributes: {
                value: value
            }
        }
    },
    createCheckboxField: function (controller, helper, row, type, value) {
        // Cast the value to boolean if it's a string
        if(typeof value == 'string') {
            value = (value == 'true') ? true : false;
        }
        
        return {
            name: 'ui:outputCheckbox',
            attributes: {
                value: value
            }
        }
    },
    createCurrencyField: function (controller, helper, row, type, value) {
        return {
            name: 'ui:outputCurrency',
            attributes: {
                value: value
            }
        }
    },
    createTextAreaField: function (controller, helper, row, type, value, elementsClassName) {
        elementsClassName = elementsClassName ? elementsClassName : "slds-cell-wrap bh-cell-text-area bh-max-three-lines";
        return {
             name: 'lightning:formattedRichText',
             attributes: {
                value: value,
                class: elementsClassName,
                title: value
             }
        }
    },
    createEmailField: function (controller, helper, row, type, value) {
        return {
            name: 'ui:outputEmail',
            attributes: {
                value: value
            }
        }
    },
    createNumberField: function (controller, helper, row, rowId, type, value) {
        // cast the value to int if it's a string
        if(typeof value == "string") {
            value = parseInt(value, 10);
        }
        if(type.isEditable) {
            return {
                name: BASE.baseUtils.getPackagePrefix(controller)+':TableCellInputField',
                attributes: {
                    id: rowId,
                    value: value,
                    tableHelper:helper,
                    row: controller.getReference("v.row"),
                    type: type
                }
                /*
                name: 'ui:inputNumber',
                attributes: {
                    value: value,
                    class: "input_width_50"
                }*/
            }
        }
        
        return {
            name: 'ui:outputNumber',
            attributes: {
                value: value
            }
        }
    },
    createPercentField: function (controller, helper, row, type, value) {
        return {
            name: 'ui:outputNumber',
            attributes: {
                value: value,
                format: '#,###,###.##%',
            }
        }
    },
    
    createMatchingField : function (controller, helper, row, type, value) {
        return {
            name: BASE.baseUtils.getPackagePrefix(controller)+':Matching',
            attributes: {
                value: value   
            }
        }
    },
    
    createPhoneField: function (controller, helper, row, type, value) {
        return {
            name: 'ui:outputPhone',
            attributes: {
                value: value
            }
        }
    },
    
    createUrlField: function (controller, helper, row, type, value) {
        return {
            name: 'ui:outputURL',
            attributes: {
                value: value,
                label: value,
                target: '_blank'
            }
        }
    },
    
    createRatingField: function (controller, helper, row, rowId, type, value) {
        return {
           name: BASE.baseUtils.getPackagePrefix(controller)+':TableCellRating',
           attributes: {
               id: rowId,
               value: value,
               tableHelper:helper,
               row: controller.getReference("v.row")
           }
        }
    }
    
})