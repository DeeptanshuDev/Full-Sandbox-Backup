({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 1, //Chunk Max to insert non inventory records 
    
    // Upload File
    uploadHelper: function(component, event, helper, fileObj) {
        return new Promise($A.getCallback(function(resolve, reject) {
            component.set("v.showLoadingSpinner", true);
            var file = fileObj;
            var self = helper;
            // check the selected file size, if select file size greter then MAX_FILE_SIZE,
            // then show a alert msg to user,hide the loading spinner and return from function  
            if (file.size > self.MAX_FILE_SIZE) {
                component.set("v.showLoadingSpinner", false);
                component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
                reject('Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            } else {
                var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.csv)$/;
                var fileName = component.get("v.fileName");
                if (regex.test(fileName.toLowerCase())) {
                    if (typeof(FileReader) != "undefined") {
                        var reader = new FileReader();
                        reader.onload = function(e) {
                            var actualColumnValues = ['PackageTrackingNumber','ShipToCompanyorName','ShipToAttention',
                                                      'ShipToAddress1','ShipToAddress2','ShipToCountryTerritory','ShipToPostalCode',
                                                      'ShipToCityorTown','ShipToStateProvinceCounty','ShipToTelephone',
                                                      'ShipToEmailAddress','ShipToResidentialIndicator','ShipmentInformationVoidIndicator',
                                                      'PackageWeight','PackageReference1','PackageReference2',
                                                      'SO','Inventory','Non Inventory','Carrier'];
                            var requiredFieldColumnValues = [];
                            var fileText = e.target.result;
                            if(fileText) {
                                var csvrows = fileText.split("\r\n");
                                if(csvrows && csvrows.length > 0) {
                                    var expectedColumnValues = [];
                                    var expectedColumnAndIndexMap = {};
                                    var columnHeaderText = csvrows[0];
                                    if(columnHeaderText) {
                                        var headerCols = columnHeaderText.split(",");
                                        for(var i=0; i<headerCols.length; i++) {
                                            expectedColumnValues.push(headerCols[i]);
                                            expectedColumnAndIndexMap[headerCols[i].toLowerCase()] = i;
                                        }
                                        console.log(expectedColumnAndIndexMap);
                                        console.log(expectedColumnValues);
                                    } else {
                                        component.set("v.showLoadingSpinner", false);
                                        component.set("v.fileName", 'Alert : No Header in CSV');
                                        reject('Alert : No Header in CSV');
                                    }
                                    if(helper.checkCSVHeaderValid(actualColumnValues, expectedColumnValues, expectedColumnAndIndexMap)) {
                                        var nonInventoryObjList = [];
                                        for(var i=1; i<csvrows.length; i++) {
                                            var columnValuesText = csvrows[i];
                                            var valuesCols = columnValuesText.split(",");
                                            nonInventoryObjList.push(helper.createNonInventoryObj(actualColumnValues, expectedColumnAndIndexMap, valuesCols));
                                        }
                                        helper.uploadNonInventoryData(component, event, helper, nonInventoryObjList).then(
                                            // resolve handler
                                            $A.getCallback(function(result) {
                                                resolve('');
                                            }),
                                            
                                            // reject handler
                                            $A.getCallback(function(error) {
                                                component.set("v.showLoadingSpinner", false);
                                                component.set("v.fileName", error);
                                                reject(error);
                                            })
                                        );
                                    } else {
                                        component.set("v.showLoadingSpinner", false);
                                        component.set("v.fileName", 'Alert : Invalid Header');
                                        reject('Alert : Invalid Header');
                                    }
                                } else {
                                    component.set("v.showLoadingSpinner", false);
                                    component.set("v.fileName", 'Alert : No Values in CSV');
                                    reject('Alert : No Values in CSV');
                                }
                            } else {
                                component.set("v.showLoadingSpinner", false);
                                component.set("v.fileName", 'Alert : No Values in CSV');
                                reject('Alert : No Values in CSV');
                            }
                        }  
                        reader.readAsText(file);
                    } else {
                        component.set("v.showLoadingSpinner", false);
                        component.set("v.fileName", 'Alert : Your browser does not support HTML5!');
                        reject('Alert : Your browser does not support HTML5!');
                    }
                } else {
                    component.set("v.showLoadingSpinner", false);
                    component.set("v.fileName", 'Alert : Invalid File, Only Upload the CSV files');
                    reject('Alert : Invalid File, Only Upload the CSV files');
                }
            }
        }));
    },
    
    uploadNonInventoryData : function(component, event, helper, nonInventoryObjList) {
        return new Promise($A.getCallback(function(resolve, reject) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.uploadNonInventoryData");
            action.setParams({
                // Take current object's opened record. You can set dynamic values here as well
                nonInventoryObjListString: JSON.stringify(nonInventoryObjList),
                opportunityId: oppId
            });
            action.setCallback(this, function(response) {                
                var state = response.getState();
                if (state === "SUCCESS") {
                    resolve('');
                } else if (state === "INCOMPLETE") {
                    var err = response.getReturnValue();
                    reject(err);
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            reject("Error message: " + errors[0].message);
                        }
                    } else {
                        reject("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }));
    },
    
    checkCSVHeaderValid : function(actualColumnValues, expectedColumnValues, expectedColumnAndIndexMap) {
        if (!expectedColumnValues) {
            return false;
        }
        
        if (actualColumnValues.length != expectedColumnValues.length) {
            return false;
        }
        
        for (var i = 0, l=actualColumnValues.length; i < l; i++) {
            var columnValue = actualColumnValues[i];
            var indexValueInExpected = expectedColumnAndIndexMap[columnValue.toLowerCase()];
            if(typeof indexValueInExpected != "undefined") {
                if (actualColumnValues[i] != expectedColumnValues[indexValueInExpected]) { 
                    return false;   
                }
            } else {
                return false;
            }
        }
        return true;
    },
    
    createNonInventoryObj : function(actualColumnValues, expectedColumnAndIndexMap, valuesCols) {
        var nonInventoryObj = {};
        for (var i = 0, l=actualColumnValues.length; i < l; i++) {
            var columnValue = actualColumnValues[i];
            var indexValueInExpected = expectedColumnAndIndexMap[columnValue.toLowerCase()];
            var value = '';
            if(typeof indexValueInExpected != "undefined") {
                if(valuesCols && indexValueInExpected < valuesCols.length) {
                    value = valuesCols[indexValueInExpected];
                }
            }
            
            if(i==0) {
                nonInventoryObj['packageTrackingNumber'] = value;
            } else if(i==1) {
                nonInventoryObj['shipToCompanyorName'] = value;
            } else if(i==2) {
                nonInventoryObj['shipToAttention'] = value;
            } else if(i==3) {
                nonInventoryObj['shipToAddress1'] = value;
            } else if(i==4) {
                nonInventoryObj['shipToAddress2'] = value;
            } else if(i==5) {
                nonInventoryObj['shipToCountryTerritory'] = value;
            } else if(i==6) {
                nonInventoryObj['shipToPostalCode'] = value;
            } else if(i==7) {
                nonInventoryObj['shipToCityorTown'] = value;
            } else if(i==8) {
                nonInventoryObj['shipToStateProvinceCounty'] = value;
            } else if(i==9) {
                nonInventoryObj['shipToTelephone'] = value;
            } else if(i==10) {
                nonInventoryObj['shipToEmailAddress'] = value;
            } else if(i==11) {
                nonInventoryObj['shipToResidentialIndicator'] = value;
            } else if(i==12) {
                nonInventoryObj['shipmentInformationVoidIndicator'] = value;
            } else if(i==13) {
                nonInventoryObj['packageWeight'] = value;
            } else if(i==14) {
                nonInventoryObj['packageReference1'] = value;
            } else if(i==15) {
                nonInventoryObj['packageReference2'] = value;
            } else if(i==16) {
                nonInventoryObj['so'] = value;
            } else if(i==17) {
                nonInventoryObj['inventory'] = value;
            } else if(i==18) {
                nonInventoryObj['nonInventory'] = value;
            }
            else if(i==19) {
                nonInventoryObj['carrier'] = value;
            }
        }
        
        return nonInventoryObj;
    }   
})