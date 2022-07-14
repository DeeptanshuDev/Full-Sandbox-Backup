/* eslint-disable no-console */
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Utilities extends LightningElement {}

class CoreUtilities 
{
    isSatisfyingRegexCriteria(stringToCheck, regexExpression) 
    {
        const regex = RegExp(regexExpression);
        return regex.test(stringToCheck);
    }
}
class DatabaseUtilities {}

class DataTableUtilities extends DatabaseUtilities
{
    sortData(fieldname, direction, datarows) 
    {
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(datarows));

        // Return the value stored in the field
        let keyValue = a => {
            return a[fieldname];
        };

        // cheking reverse direction
        let isReverse = direction === "asc" ? 1 : -1;

        // sorting data
        parseData.sort((x, y) => {

            x = keyValue(x) ? keyValue(x) : ""; // handling null values
            y = keyValue(y) ? keyValue(y) : "";

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        return parseData;
    }
}
class CustomEventsUtilities 
{
    showToast(component, title, message, sandboxId, sandboxName, variant) 
    {
        component.dispatchEvent(
            new ShowToastEvent({
                title: title, 
                message: message,
                messageData : ['Salesforce',{
                    url: '/'+sandboxId,
                    label: sandboxName,
                    }
                ],
                variant: variant
            }),
        );
    }

    fireCustomEvent(customEventName, details, component) 
    {
        const selectedEvent = new CustomEvent(customEventName, {
            detail: details
        })
        component.dispatchEvent(selectedEvent);
    }

}
class ValidationsUtilities
{
    validateForMaxCharactersLimits(charactersString, noOfAllowedCharacters) 
    {
        if(noOfAllowedCharacters !== null && noOfAllowedCharacters !== '' && Number.isInteger(noOfAllowedCharacters)) 
        {
            if(isAnInteger(noOfAllowedCharacters) > 255) 
            {
                return false;
            }
            return true;
        }
        return false;
    }

    validateForSandboxName(sandboxName) 
    {
        const underAllowedCharactersLimit = ValidationsUtilities.prototype.validateForMaxCharactersLimits(sandboxName, 10);
        if(underAllowedCharactersLimit) 
        {
            return CoreUtilities.prototype.isSatisfyingRegexCriteria(sandboxName, "^[a-zA-Z0-9]*$");
        }   
        return false;
    }
}

function isAnInteger(noOfAllowedCharacters) 
{
    // eslint-disable-next-line radix
    return Number.parseInt(noOfAllowedCharacters);
}

export {CoreUtilities, DatabaseUtilities, DataTableUtilities, CustomEventsUtilities, ValidationsUtilities};