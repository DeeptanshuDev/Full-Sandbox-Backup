({
    RESIZE_TIMEOUT: [],
    RESIZE_TIMEOUT_DURATION: 25,

    columnWidths: [],
    tableWidth: [],
    infoColumnWidth: [],
    actionColumnWidth: [],

    hideOverflow : function(component, event, helper, dataChanged) {
        var container = component.find("container");

        // Wait till all components are showing.
        if(container == null || container.getElement() == null || (container.getElement().querySelector("th:last-child") != null && container.getElement().querySelector("th:last-child").offsetWidth == 16)) {
            window.setTimeout(
                $A.getCallback(function() {
                    helper.hideOverflow(component, event, helper, dataChanged);
                }), 100
            );
        }
        else {
            if(dataChanged || helper.columnWidths[component.getGlobalId()] == null) {
                helper.recalculateColumnWidths(container, component, helper);
            }

            let infoColumnWidth = helper.getWidthBySelector(container, '.cxs-info-column');
            let actionColumnWidth = helper.getWidthBySelector(container, '.cxs-action-column');

            let containerWidth = helper.calculateContainerWidth(component, container, helper, infoColumnWidth, actionColumnWidth );
            if(!isNaN(containerWidth)) {
                let tableWidth = helper.tableWidth[component.getGlobalId()];

                let showing = (containerWidth >= tableWidth-infoColumnWidth);
                helper.toggleInfoIconState(component, !showing);

                helper.showHideColumns(component, helper, container, containerWidth, showing, tableWidth);
            }
        }
    },

    showHideColumns: function(component, helper, container, containerWidth, showing, tableWidth) {
        let selectable = component.get('v.selectable');
        let actionFields = component.get('v.actionFields');
        let lastColumnIndex = actionFields + selectable?2:1;

        let columnWidths = helper.columnWidths[component.getGlobalId()];

        if(isNaN(tableWidth)) {
            let infoColumnWidth = helper.getWidthBySelector(container, '.cxs-info-column');
            
            tableWidth = helper.tableWidth[component.getGlobalId()];
            showing = (containerWidth >= tableWidth-infoColumnWidth);
            helper.toggleInfoIconState(component, !showing);
        }

        // use retry mechanism if columnWidths is undefined because columns was nor rendered.
        if(!columnWidths && containerWidth && isNaN(tableWidth)) {
            window.setTimeout(
                $A.getCallback(function() {
                    helper.showHideColumns(component, helper, container, containerWidth, showing, tableWidth);
                }), 250
            );
        }

        if(columnWidths) {
            let showingElements = columnWidths.length;
            for(let c = columnWidths.length-1; c >= lastColumnIndex; c--) {
                if(!showing) {
                    tableWidth -= columnWidths[c];
                }

                let elements = container.getElement().querySelectorAll('td:nth-child('+(c+1)+'), th:nth-child('+(c+1)+')');
                for(let e = 0; e < elements.length; e++) {
                    if(showing) {
                        elements[e].classList.remove("slds-hide");
                    }
                    else {
                        elements[e].classList.add("slds-hide");
                    }
                }
                
                if(!showing && (c == lastColumnIndex || containerWidth >= tableWidth + 20 + (selectable?columnWidths[0]:0))) {
                    showing = true;
                    showingElements = c;
                }
            }

            let remainingPixels = containerWidth-tableWidth;
            let paddingPixels = remainingPixels/(showingElements - (selectable?1:0) - actionFields);

            /*console.group("Calculations for component with global id: " + component.getGlobalId());
            console.log('actionFields', actionFields);
            console.log('lastColumnIndex', lastColumnIndex);
            console.log('containerWidth', containerWidth);
            console.log('tableWidth', tableWidth);
            console.log('helper.infoColumnWidth', helper.infoColumnWidth[component.getGlobalId()]);
            console.log('helper.actionColumnWidth', helper.actionColumnWidth[component.getGlobalId()]);
            console.log('selectable', selectable);
            console.log('remainingPixels', remainingPixels);
            console.log('paddingPixels', paddingPixels);
            console.log('showingElements', showingElements);
            console.groupEnd();*/

            for(let c = (selectable?1:0) + actionFields; c < showingElements; c++) {
                let columnWidth = columnWidths[c] + paddingPixels;

                let headerElement = container.getElement().querySelector('th:nth-child('+(c+1)+')');
                if(headerElement != null) {
                    headerElement.style = 'width: '+columnWidth+'px';
                }

                let headerTruncateElement = container.getElement().querySelector('th:nth-child('+(c+1)+') div.slds-truncate');
                if(headerTruncateElement != null) {
                    headerTruncateElement.style = 'max-width: '+(columnWidth-20)+'px';
                }

                let truncateElements = container.getElement().querySelectorAll('td:nth-child('+(c+1)+') div.slds-truncate');
                for(let e = 0; e < truncateElements.length; e++) {
                    truncateElements[e].style = 'max-width: '+(columnWidth-20)+'px';
                }
            }
        }
        component.set("v.isLoading", false);
    },

    calculateContainerWidth: function(component, container, helper, infoColumnWidth, actionColumnWidth ) {
        let containerWidth = container.getElement().parentNode.offsetWidth;
        let buttonsSizeDifference = helper.infoColumnWidth[component.getGlobalId()] - infoColumnWidth + helper.actionColumnWidth[component.getGlobalId()] - actionColumnWidth;
        return containerWidth + (buttonsSizeDifference || 0);
    },

    getWidthBySelector: function(container, selector) {
        let column = container.getElement().querySelector(selector);
        return column == null?0:column.offsetWidth;
    },

    recalculateColumnWidths: function(container, component, helper) {
        if(!container.getElement() || !component.find("thead").getElement() || container.getElement().querySelectorAll("th.cxs-data-row").length == 0) {
            // still loading/rendering data.
            window.setTimeout(
                $A.getCallback(function() {
                    helper.recalculateColumnWidths(container, component, helper);
                }), 250
            );
        }
        else {
            let globalId = component.getGlobalId();

            let dataColumns = component.find("thead").getElement().querySelectorAll('th');
            helper.columnWidths[globalId] = [];
            helper.infoColumnWidth[globalId] = 0;
            helper.actionColumnWidth[globalId] = 0;
            helper.tableWidth[globalId] = component.find("table").getElement().offsetWidth;

            for(let c = 0; c < dataColumns.length; c++) {
                let dataColumn = dataColumns[c];
                let columnWidth = dataColumn.offsetWidth;
                
                if(dataColumn.className.indexOf('cxs-info-column') != -1) {
                    helper.infoColumnWidth[globalId] = columnWidth;
                }
                else if(dataColumn.className.indexOf('cxs-action-column') != -1) {
                    helper.actionColumnWidth[globalId] = columnWidth;
                }
                else {
                    helper.columnWidths[globalId].push(columnWidth);
                }
            }
        }
    },

    addResizeListener: function(component, event, helper) {
        window.addEventListener('resize', $A.getCallback(function() {
            clearTimeout(helper.RESIZE_TIMEOUT[component.getGlobalId()]);

            helper.RESIZE_TIMEOUT[component.getGlobalId()] = setTimeout($A.getCallback(function() {
                helper.hideOverflow(component, event, helper, false);
            }), 200);
        }));
    },

    refreshData:function(component, event, helper, redo) {
        var container = component.find("container");

        if(container && container.getElement() != null) {
            let hiddenElements = container.getElement().querySelectorAll('th.slds-hide, td.slds-hide');
            for(var c = 0; c < hiddenElements.length; c++) {
                hiddenElements[c].classList.remove("slds-hide");
            }

            let truncatedElements = container.getElement().querySelectorAll('.slds-truncate');
            for(var c = 0; c < truncatedElements.length; c++) {
                truncatedElements[c].style = '';
            }

            helper.recalculateColumnWidths(container, component, helper);

            if(redo) {
                helper.hideOverflow(component, event, helper, false);
            }
        }
        else {
            // we failed our component is probably hidden.
            window.setTimeout(
                $A.getCallback(function() {
                    helper.refreshData(component, event, helper, true);
                }), 250
            );
        }
    },

    toggleInfoIconState: function(component, hasOverflow) {
        if(component.get("v.isHideInfoIcon") == true) {
            component.set('v.hasOverflow', hasOverflow);
        }
    }
})