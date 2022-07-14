// initialize baseUtils library and add it to the BASE namespace on the window object
(function (BASE) {

	BASE.dataServiceDesignUtil = {
		// orderDesignAttributeValue - is optional attributes that needed for DataService in queryOnly mode
		getOrders: function(component, event, helper,orderDesignAttributeValue,orderAttributeToSet) {
		    var orders=orderDesignAttributeValue;
            if(orders) {
                //ordersList
                component.set("v." + orderAttributeToSet, orders.split(',').map(orderFieldStatement => {
                    let tokens = orderFieldStatement.trim().split(/\s+/);

                    return {
                        fieldName: tokens[0],
                        direction: tokens[1]
                    }
                }));
            }
        },
        // filterDesignAttributeValue - is optional attributes that needed for DataService in queryOnly mode
        getFilters: function(component, event, helper,filterDesignAttributeValue,filterLogicAttributeValue,filterAttributeToSet,isQueryService) {
            var recordId;
            if(!isQueryService) {
                recordId = component.get('v.recordId');
            }
            //filters
            var filters = filterDesignAttributeValue;


            if(filters) {
                var filterLogic = filterLogicAttributeValue;

                var filterObject = {};
                filterObject.filterFields = [];

                if(filterLogic){
                    filterObject.filterLogic = filterLogic;
                }

                var filterFieldStatement = filters.split(/\,(?![^\(]*\))/g).map(x => x.trim());

                let idValueInPattern = /(id[\s]{0,}valuein[\s]{0,})(\(('[\d\w]{18}'[,]{0,})+\))/gi;   //match all case-ignore strings like "Id VALUEIN ('0123456789ABCDEFab','0123456789ABCDEFac',...'0123456789ABCDEFaf')"

                for(var i = 0; i < filterFieldStatement.length; i++){
                    var filterPath;

                    //check case when filterFieldStatement contains Id VALUE IN (...listOfIds...)
                    let idValueInMatch = idValueInPattern.exec(filterFieldStatement[i]);
                    if (idValueInMatch) {
                        let filter = new CXSDataServiceFilterField();
                        filter.fieldName = 'Id';
                        filter.restriction = 'VALUEIN';
                        let values = idValueInMatch[2].replace(/[\(\)']/g,'').split(',');
                        values.forEach(v => {
                            filter.addValue(v);
                        });
                        filterObject.filterFields.push(filter);
                        continue;
                    }

                    if(filterFieldStatement[i].indexOf(' (') != -1){
                        filterPath = filterFieldStatement[i].substring(0,filterFieldStatement[i].indexOf(' (')).split(/\s+(?![^\(]*\))/g).map(x => x.trim());
                        filterPath.push(filterFieldStatement[i].substring(filterFieldStatement[i].indexOf('(')));
                    }else{
                        filterPath = filterFieldStatement[i].split(/\s+(?![^\(]*\))/g).map(x => x.trim());
                    }

                   // var filterPath = filterFieldStatement[i].split(/\s+(?![^\(]*\))/g).map(x => x.trim());

                    var filter = new CXSDataServiceFilterField();
                    filter.fieldName = filterPath[0];
                    filter.restriction = filterPath[1];

                    if (filterPath.length < 2) {
                        filterPath[1]='';
                        filterPath[2]='';
                    }
                    if (filterPath.length < 3) {
                        if (filterPath[1].indexOf('(') != -1) {
                            var part2and3 = filterPath[1].split(/\(/g);
                            filterPath[1] = part2and3[0];
                            filterPath[2] = part2and3[1];
                        }
                        else {
                            filterPath[2] = '';
                        }
                    }

                    var values;
                    if(filterPath[2].indexOf('(\'') != -1){
                        values = (filterPath[2].replace('(\'','\'').replace('\')','\'')).split('\',\'');

                    }else{
                        values = (filterPath[2].replace('(','').replace(')','')).split(',');
                    }
                    //var values = (filterPath[2].replace('(','').replace(')','')).split(',');


                    if(filterPath[2].indexOf('\'') != -1) {
                        values.forEach(value => {
                            if(value == "'{recordId}'") {
                                filter.addValue(recordId);
                            }
                            else {
                               filter.addValue(value.substring(1,value.length -1));
                               // filter.addValue(value.replace(new RegExp('\'', 'g') , ''));
                            }
                        })
                    }
                    else{
                        if(values[0] == 'true' || values[0] == 'false') {
                            values.forEach(value => {
                                filter.addValue(value == 'true');
                            })
                        }
                        else {
                            if(!isNaN(parseInt(values[0], 10))) {
                                values.forEach(value => {
                                    filter.addValue(parseInt(value, 10));
                                });
                            }
                        }
                    }
                    filterObject.filterFields.push(filter);
                }
                component.set('v.' + filterAttributeToSet,filterObject);
            }
        },
        // fieldsDesignAttributeValue - is optional attributes that needed for DataService in queryOnly mode
        getFields: function(component, event, helper, fieldsDesignAttributeValue,fieldsAttributeToSet) {
            var fields = fieldsDesignAttributeValue;

            if(fields) {
                component.set("v." + fieldsAttributeToSet, fields.split(',').map(field => field.trim()));
            }
        },
        // fieldSetsDesignAttributeValue - is optional attributes that needed for DataService in queryOnly mode
        getFieldSets: function(component, event, helper , fieldSetsDesignAttributeValue,fieldSetsAttributeToSet) {
            var fieldSets= fieldSetsDesignAttributeValue;
            if(fieldSets) {
                component.set("v." + fieldSetsAttributeToSet, fieldSets.split(',').map(fieldset => fieldset.trim()));
            }
        }

	}

})(window.BASE = window.BASE || {});

