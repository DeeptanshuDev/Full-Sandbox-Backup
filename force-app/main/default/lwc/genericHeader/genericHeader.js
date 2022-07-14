import { LightningElement, api } from 'lwc';
export default class Header extends LightningElement 
{
    @api title = '';
    @api label = '';
    @api outerDivClass = 'slds-p-left_small slds-p-right_small';
    @api iconName = '';
    @api alternativeText = '';
    @api showHeader = false;

    get titleAndLabelAreNotBlank() 
    {
        return (this.title !== '' || this.label !== '') ? true : false;
    }

    get titleNotBlank() 
    {
        return (this.title !== '') ? true : false;
    }

    get labelNotBlank() 
    {
        return (this.label !== '') ? true : false;
    }

}