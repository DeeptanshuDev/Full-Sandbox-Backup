import { LightningElement ,track} from 'lwc';
import createRecordSandboxRefreshDetails from '@salesforce/apex/SandboxCreateAndRefreshManager.createRecordSandboxRefreshDetails';
import getCompVisibility from '@salesforce/apex/SandboxCreateAndRefreshManager.getCompVisibility';
import { CustomEventsUtilities as customEventsUtil , ValidationsUtilities as validationRule} from 'c/utilities';
import * as constant from 'c/constants';
import  * as customLabel from 'c/customlabels';

export default class CreateAndRefreshSanbox extends LightningElement 
{
    //Variable used in Create Sandbox Details
    @track sandboxName;
    @track sandboxDescription;
    @track compVisible;
    @track autoActivate = true;
    @track showSpinner = false;
    Create_Sandbox_Access_Message = customLabel.Create_Sandbox_Access_Message;

    //Variable used for show Notification
    @track showNotification = false;
    @track messageTitle;
    @track message = []; 
    @track severity;

    connectedCallback()
    {
        getCompVisibility()
        .then(result=>{
            this.compVisible = result;
        })
        .catch(error=>{
            this.error = error;
        })    
    }

    handleMultiSelected(event)
    {
        this.targerUserIds = [];
        if(event.detail.length >0 ){
            JSON.parse(JSON.stringify(event.detail)).forEach(element => {
                this.targerUserIds = [...this.targerUserIds, element.id];
            });
        }
    }

    handleChangeForSN(event)
    {
        this.sandboxName = event.target.value;
    }

    handleChangeForSD(event)
    {
        this.sandboxDescription = event.target.value;
    }

    handleCheckedAutoActivate(event)
    {
        this.autoActivate = event.target.checked;
    }

    //Method to have when User click on save button insert the record of Sandbox Refresh Detail
    onCreateSandboxRequest()
    {
        if(this.validatedSuccessfully() === true) 
        {
            if((this.sandboxName !=='' && this.sandboxDescription !=='') || this.targerUserIds != null)
            {
                this.showSpinner = true;
                createRecordSandboxRefreshDetails({sandboxName : this.sandboxName, sandboxDes : this.sandboxDescription, 
                                                   selectedAccounts : this.targerUserIds, autoActivate : this.autoActivate})         
                .then(result=>{
                    // eslint-disable-next-line no-unused-vars
                    customEventsUtil.prototype.showToast(this, constant.TOAST_SUCCESS_TTTLE,constant.SUCCESS_MESSAGE,'','', 
                                                         constant.TOAST_SUCCESS_VARIENT);
                    this.showNotification = false;
                    this.showSpinner = false;
                    this.template.querySelector(".inputBox").value = ' ';
                    this.template.querySelector("lightning-textarea").value = ' ';
                    this.template.querySelector('c-multi-select-lookup').selectedIdSet = [];
					window.location.reload();
                    
                })
                .catch(error=>{
                    this.showNotification = true;
                    this.messageTitle = constant.TOAST_ERROR_TITLE;
                    this.message.push(error);
                    this.severity = constant.TOAST_ERROR_VARIENT;
                })
            }
            else
            {
                this.showNotification = true;
                this.messageTitle = constant.TOAST_ERROR_TITLE;
                this.message.push(customLabel.Create_Sandbox_Error_Message);
                this.severity = constant.TOAST_ERROR_VARIENT;
            }
        }
    }

    validatedSuccessfully() 
    {
        if(this.sandboxDescription !== null && this.sandboxDescription !== '')
        {
            if((validationRule.prototype.validateForMaxCharactersLimits(this.sandboxDescription,this.sandboxDescription.length)) === false) 
            {
                this.showNotification = true;
                this.messageTitle = constant.TOAST_INFO_TITLE;
                this.message.push(customLabel.Validate_SB_Description_Message);
                this.severity = constant.TOAST_INFO_VARIENT;
                return false;
            }
        }
        if((validationRule.prototype.validateForSandboxName(this.sandboxName)) === false) 
        {
            this.showNotification = true;
            this.messageTitle = constant.TOAST_INFO_SB_NAME_TITLE;
            this.message.push(customLabel.Validate_Sandbox_Name_Message);
            this.severity = constant.TOAST_INFO_VARIENT;
            return false;
        }
        return true;
    }

    //Method to have handle event for render the notification component and set showNotification is false
    handleNotificationsRendering(event)
    {
        this.showNotification = event.detail.value;
    }
}