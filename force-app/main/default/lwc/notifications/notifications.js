import { LightningElement, api } from 'lwc';
import { CustomEventsUtilities as customEventsUtils} from 'c/utilities';

export default class Notifications extends LightningElement 
{
    @api size = 'small';
    @api severity = 'info';
    @api inverse = false;

    messageIconNameClass = '';
    allowCloseClassName = '';
    borderClassName = '';

    @api messageTitle = '';
    @api messages = [];

    @api isShow;
    @api allowClosing = false;
    @api theme = '';
    @api divider = false;
    @api className = '';
    @api roundedBorders = false;
    @api border = false;
    
    @api isNeededWordWrap = false;
    @api classNameForUl = '';
    @api messageIconName = '';
    
    connectedCallback() 
    {
        //Setting defaults
        this.isShow = true;
        this.className = 'slds-col ';
        this.classNameForUl = 'slds-list--dotted slds-p-left--medium ';

        if(this.messageIconName === '') 
        {
            this.messageIconName = 'utility:';
            this.messageIconName += this.severity;
        }

        if(this.isNeededWordWrap) 
        {
            this.classNameForUl += 'wrapMessageText';
        }
        else 
        {
            this.classNameForUl += '';
        }

        if(this.divider) 
        {
            this.className += 'slds-border--left slds-p-left--medium';
        } 
        else 
        {
            this.className += '';
        }

        if(this.inverse) 
        {
            this.messageIconNameClass = 'inverse';
            this.allowCloseClassName = 'inverse';
            this.theme = this.severity;
        }
        else 
        {
            this.allowCloseClassName = '';
            this.theme = 'default';
            if(this.severity === 'info') 
            {
                this.messageIconNameClass = '';
            }
            else 
            {
                this.messageIconNameClass = this.severity;
            }
        }

        if(this.border) 
        {
            this.borderClassName = 'slds-box';
        }
        else 
        {
            this.borderClassName = '';
        }

        if(this.isShow) 
        {
            this.borderClassName += '';
        }
        else 
        {
            this.borderClassName += 'slds-hide';
        }
        this.borderClassName += 'slds-scoped-notification slds-media slds-media_center allowClosing_' + this.allowClosing.toString();
        this.borderClassName += ' slds-theme_' + this.theme;
        this.borderClassName += ' cNotification';
        if(this.roundedBorders) 
        {
            this.borderClassName +=' roundedBorders ';
        }
        else 
        {
            this.borderClassName +='';
        }
    }

    closeMessage()
    {
        if(this.allowClosing) 
        {
            this.messages = [];
            this.messageTitle = '';
            this.isShow = false;
            this.borderClassName = '';
            customEventsUtils.prototype.fireCustomEvent("rendernotifications", this.isShow, this);
        }
    }
}