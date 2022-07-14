'use strict';

window.CXSDataServiceFilterField = class CXSDataServiceFilterField {

   /*
    *   Constructs a new instance of the CXSFilterField object. When `obj` is given, data from `obj` will be used to create a new instance
    */
    constructor(obj) {

        // Class variables
        this.fieldName = undefined;
        this.restriction = undefined;
        this.filterValue = undefined;
        this.hidden = false;
        
        if(obj) {

            this.fieldName = obj.fieldName;
            this.restriction = obj.restriction;
            this.hidden = obj.hidden;
            this._initializeValues();

            if(obj.filterValue) {
                this.filterValue.stringValues = obj.filterValue.stringValues;
                this.filterValue.integerValues = obj.filterValue.integerValues;
                this.filterValue.booleanValues = obj.filterValue.booleanValues;
                this.filterValue.geolocationValues = obj.filterValue.geolocationValues;
            }
        }
        else {
            this._initializeValues();
        }
    }

   /*
    *   sets fieldName
    *   This method is chainable
    */
    setFieldName(fieldName) {
        this.fieldName = fieldName;
        return this;
    }

   /*
    *   sets restriction
    *   This method is chainable
    */
    setRestriction(restriction) {
        this.restriction = restriction;
        return this;
    }

   /*
    *   sets hidden
    *   This method is chainable
    */
    setHidden(hidden) {
        this.hidden = hidden;
        return this;
    }

   /*
    *   Initalizes the values arrays
    */
    _initializeValues() {
        this.filterValue = {
            stringValues: [],
            integerValues: [],
            booleanValues: [],
            geolocationValues: []
        }
    }

   /**
    *   Determine the values and returns it. Returns an empty array if no values are set
    */
    getValues() {
        if(this.filterValue.stringValues.length) {
            return this.filterValue.stringValues;
        }
        else if(this.filterValue.integerValues.length) {
            return this.filterValue.integerValues;
        }
        else if(this.filterValue.booleanValues.length) {
            return this.filterValue.booleanValues;
        }
        else if(this.filterValue.geolocationValues.length) {
            return this.filterValue.geolocationValues;
        }
        return [];
    }

   /*
    *   Sets the appropriate values array based on the contents of the provided `values` array
    *   This method is chainable
    */
    setValues(values, type) {
        if(!values || !values.length) {
            this._initializeValues();
            return;
        }

        this._initializeValues();

        for(let value of values) {
            this.addValue(value, type)
        }
        return this;
    }

   /*
    *   Adds the provided `value` to the appropriate values array
    *   This method is chainable
    */
    addValue(value, type) {
        if(value === undefined || value === '') {
            return;
        }

        // If no type specified, use the value's type
        if(!type) {
            if(typeof value == "string") {
                type = "TEXT"
            }
            else if(typeof value == "number") {
                type = "INTEGER";
            }
            else if(typeof value == "boolean") {
                type = "BOOLEAN";
            }
        }

        if(["TEXT", "STRING", "TEXTAREA"].includes(type)) {
            this.filterValue.stringValues.push(value);
        }
        else if(["INTEGER", "DOUBLE"].includes(type)
            && !(value instanceof CXSDataServiceGeolocationValue)) {
            this.filterValue.integerValues.push(value);
        }
        else if(type == "BOOLEAN") {
            // make sure we add the value as a boolean
            if(typeof value == "string") {
                value = (value == "true") ? true : false;
            }
            this.filterValue.booleanValues.push(value);
        }
        else if(value instanceof CXSDataServiceGeolocationValue) {
            this.filterValue.geolocationValues.push(value);
        }
        // add to stringvalues if all else fails
        else {
            this.filterValue.stringValues.push(value);
        }

        return this;
    }

   /**
    *   Returns `true` or `false` based on whether values are set
    */
    hasValues() {
        return this.getValuesLength() > 0;
    }

   /**
    *   Returns the amount of values
    */
    getValuesLength() {
        let values = this.getValues();
        return values ? values.length : 0;
    }

};

window.CXSDataServiceGeolocationValue = class CXSDataServiceGeolocationValue {

    constructor(lat, long, radius) {
        this.latitude = lat;
        this.longitude = long;
        this.radius = radius;
    }
}
