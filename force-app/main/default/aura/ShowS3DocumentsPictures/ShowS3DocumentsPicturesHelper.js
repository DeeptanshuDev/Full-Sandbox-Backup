({
	setTableColumns : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'S3 Document Name', fieldName: 'Name', type: 'text'},
            {label: 'File Name', fieldName: 'File_Name__c', type: 'text'},
            {label: 'Gender', fieldName: 'Gender__c', type: 'text'},
            {label: 'Approved Proto Selection', fieldName: 'Approved_Proto_Selection__c', type: 'boolean'},
            {label: 'Category', fieldName: 'Categories__c', type: 'text'},
            {label: 'Subcategory', fieldName: 'Subcategory__c', type: 'text'},
            {label: 'Description', fieldName: 'Description__c', type: 'text'},
            {label: 'File Link', fieldName: 'File_Link__c', type: 'url', typeAttributes: { label: 'Check File' , target: '_blank'}},
            {label: 'Last Modified', fieldName: 'LastModifiedDate', type: 'text'}
        ]);
    },
    
    setTableData : function(component, event, helper, result) {
        var documentCategoryList = result.documentCategory;
        var documentList = result.documentList;
        var documentSubcategoryList = [];
        var mainList = [];
        for(var docListIndex in documentList) {
            if(documentList[docListIndex].Subcategory__c != undefined && !documentSubcategoryList.includes(documentList[docListIndex].Subcategory__c)) {
                documentSubcategoryList.push(documentList[docListIndex].Subcategory__c);
            }
        }
        //console.log("documentSubcategoryList:", documentSubcategoryList);
        for(var indexDocCat in documentCategoryList) {
            var subcategoryList = [];
            var subcategoryObject = {};
            //console.log('current Cat:', documentCategoryList[indexDocCat]);
            var listObjectMap = {};
            for(var indexsubcatList in documentSubcategoryList) {
                var docList = [];
                for(var indexDocList in documentList) {
                    var individualDocCat = documentList[indexDocList].Categories__c;
                    var individualDocSubcat = documentList[indexDocList].Subcategory__c;
                    if(individualDocCat == documentCategoryList[indexDocCat] && individualDocSubcat == documentSubcategoryList[indexsubcatList]) {
                        if(documentList[indexDocList].Account__r != undefined) {
                            documentList[indexDocList].Account_Name = documentList[indexDocList].Account__r.Name;
                        }
                        docList.push(documentList[indexDocList]);
                    }
                }
                listObjectMap[documentSubcategoryList[indexsubcatList]] = docList;
            }
            //console.log('listObjectMap:', listObjectMap);
            for(var key in listObjectMap) {
                if(listObjectMap[key].length > 0) {
                    var listObject = {};
                    listObject.subcategory = key;
                    listObject.documentList = listObjectMap[key];
                    subcategoryList.push(listObject);
                }
            }
            subcategoryObject.documentCategory = documentCategoryList[indexDocCat];
            subcategoryObject.subcategoryList = subcategoryList;
            mainList.push(subcategoryObject);
        }
        component.set("v.S3Documents", mainList);
        //console.log("mainList:", mainList);
    }
})