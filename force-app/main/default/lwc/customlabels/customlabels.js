import { LightningElement } from 'lwc';
import Create_SB_Access_Message from '@salesforce/label/c.Create_SB_Access_Message';
import Create_SB_Error_Message from '@salesforce/label/c.Create_SB_Error_Message';
import Sandbox_Description_Validation_Message from '@salesforce/label/c.Sandbox_Description_Validation_Message';
import Validate_SB_Name_Message from '@salesforce/label/c.Validate_SB_Name_Message'
export default class Customlabels extends LightningElement {}

export const Create_Sandbox_Access_Message = Create_SB_Access_Message;
export const Create_Sandbox_Error_Message = Create_SB_Error_Message;
export const Validate_SB_Description_Message = Sandbox_Description_Validation_Message;
export const Validate_Sandbox_Name_Message = Validate_SB_Name_Message;