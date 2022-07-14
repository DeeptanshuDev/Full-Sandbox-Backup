import { LightningElement, track } from 'lwc';
import getPicklistValue from '@salesforce/apex/PrototypeStatusValues.getPicklistValue';

export default class ComboboxRequired extends LightningElement {
    value = 'prototype';

    get options() {
        return [
            { label: 'Prototype Status', value: 'prototype' },
            
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;

    }

    clickedButtonLabel;
    @track values;
    @track error;
    @track selectedStep = 'Step3';

    handleClick(event) {
        getPicklistValue()
            .then(result => {
                this.values = result;
            })
            .catch(error => {
                this.error = error;
            });

    }
}