public class GenericUtils {
    public static Boolean isCommunityUser = false;
    public static Set<String> bypassObjectAccess = new Set<String>{'Opportunity', 'opportunity'};
    private final static String ENCODING_KEY = 'JN6TP4GX78GAOu+m3WIgoUnWszCLBiGlsTRgElGCyxE=';
	private static Blob cryptoKey; // this will be generated when required
	public final static String ENCRYPTED_START = '#AES256#';
    private static final String[] JS_DECODED = new String[] { '\\', '\'', '\n', '\r', '"', '!--', '/', '<', '>' };
    private static final String[] JS_ENCODED = new String[] { '\\\\', '\\\'', '\\n', '\\r', '\\"', '\\!--', '\\/', '\\u003C', '\\u003E' };
    private static final String[] JSINHTML_DECODED = new String[] { '&', '\\', '\'', '"', '\r', '\n', '<', '>' };
    private static final String[] JSINHTML_ENCODED = new String[] { '\\&amp;', '\\\\', '\\&#39;', '\\&quot;', '\\r', '\\n', '&lt;', '&gt;' };
    public final static Map<String, Set<String>> HTML_ATTRIBUTE_WHITELIST = new Map<String, Set<String>>{
            'a' => new Set<String>{'href', 'target'},
            'b' => new Set<String>(), 
            'br' => new Set<String>(),
            'div' => new Set<String>{'id', 'style'},
            'em' => new Set<String>(),
            'h1' => new Set<String>{'style'},
            'h2' => new Set<String>{'style'},
            'h3' => new Set<String>{'style'},
            'h4' => new Set<String>{'style'},
            'h5' => new Set<String>{'style'},
            'h6' => new Set<String>{'style'},
            'hr' => new Set<String>{'size', 'style'},
            'i' => new Set<String>(),
            'img' => new Set<String>{'src', 'style'},
            'li' => new Set<String>(),
            'link' => new Set<String>{'href', 'type'},
            'meta' => new Set<String>{'name', 'content'},
            'ol' => new Set<String>(),
            'option' => new Set<String>{'selected'},
            'p' => new Set<String>(),
            'span' => new Set<String>{'id', 'style'},
            'strike' => new Set<String>(),
            'strong' => new Set<String>(),
            'table' => new Set<String>{'style'},
            'tbody' => new Set<String>{'style'},
            'td' => new Set<String>{'style'},
            'th' => new Set<String>{'style'},
            'thead' => new Set<String>{'style'},
            'tr' => new Set<String>{'style'},
            'u' => new Set<String>(),
            'ul' => new Set<String>()
    };
        
    // List of safe HTML attributes comes from here: https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.md#xss-prevention-rules-summary
    public final static Set<String> safeHtmlAttributes = new Set<String>{'align', 'alink', 'alt', 'bgcolor', 'border', 'cellpadding', 'cellspacing', 'class', 'color', 'cols', 'colspan', 'coords', 'dir', 'face', 'height', 'hspace', 'ismap', 'lang', 'marginheight', 'marginwidth', 'multiple', 'nohref', 'noresize', 'noshade', 'nowrap', 'ref', 'rel', 'rev', 'rows', 'rowspan', 'scrolling', 'shape', 'span', 'summary', 'tabindex', 'title', 'usemap', 'valign', 'value', 'vlink', 'vspace', 'width'};
    
    public class ValidationException extends Exception {}
    
    private static String pkgPrefix = null;
    public static String NAME_SPACE = null;
    public static String getPackagePrefix(){
    	if (pkgPrefix == null) {
    		pkgPrefix = GenericUtils.getNameSpacePrefix(GenericUtils.NAME_SPACE);
    	}
    	return pkgPrefix;
    }
    
    public static String getNameSpacePrefix(String strClassName) {
		if(String.IsBlank(NAME_SPACE)) {
            ApexClass cs = [Select NamespacePrefix from ApexClass where Name = 'MyOrdersController'];
            String nameSpaceName = cs.NamespacePrefix;
            if(nameSpaceName == null) nameSpaceName = '';
            else nameSpaceName += '__';
			NAME_SPACE = nameSpaceName;
		}
		return NAME_SPACE;
	}
    
    private static Blob getCryptoKey() {
		if(cryptoKey == null) {
			cryptoKey = EncodingUtil.base64Decode(ENCODING_KEY);
		}
		return cryptoKey;
	}
    
    public static String encrypt(String input) {
		Blob data = Blob.valueOf(input);
		Blob encryptedData = Crypto.encryptWithManagedIV('AES256', getCryptoKey(), data);
		return EncodingUtil.base64Encode(encryptedData);	
	}
	
	public static String decrypt(String input) {
		Blob data = EncodingUtil.base64Decode(input);
		System.debug(input);
		Blob decryptedData = Crypto.decryptWithManagedIV('AES256', getCryptoKey(), data);
		return decryptedData.toString();
	}

    public static String getConvertedFieldPath(Schema.FieldSetMember fsMember) {
        return getConvertedFieldPath(fsMember.getFieldPath(),String.valueOf(fsMember.getType()));
    }

    public static String getConvertedFieldPath(String fieldPath , String fieldType) {
        String fieldName = fieldPath;

        if (fieldName == 'Id') {
            fieldName = 'Id';
        }
        else if (fieldPath.endsWith('Id')) {
            fieldName = fieldPath.left(fieldPath.length()-2) + '.Name';
        }
        else if(fieldType  == 'REFERENCE') {
            if (fieldName.endsWith('__c')) {
                fieldName = fieldName.replace('__c', '__r.Name');
            } else {
                fieldName += '.Name';
            }
        }
		return fieldName;
    }
    
    public static String getArrayStringForQuery(Object objectList){
		String objectListString = String.valueOf(objectList);
		return getArrayStringForQuery(objectListString);
	}
    
	/**
      *  Method to return good formated string for SOQL query based on Array values.
      *  Use in SoqlBuilder for field in: array where condition , without passing bound attribute.
      *  @param  objectListString string Array.
      *  @return - good formated string for SOQL query. Format : ('a1H0Y000001hXtVUAU','a1H0Y000001hdfyUAA','a1H0Y000001hdg3UAA')
     */
	public static String getArrayStringForQuery(String objectListString){
		String soqlFormatArrayString = '';
		Pattern p = Pattern.compile('[^,{\\s][^\\,]*[^,]*[^,}\\s]');
		Matcher m = p.matcher(String.escapeSingleQuotes(objectListString));
		List<String> listValues = new List<String>();
		while (m.find() == true) {
			listValues.add('\'' + m.group(0) + '\'');
		}
		if(!listValues.isEmpty()){
			soqlFormatArrayString +=  '(' + String.join(listValues, ',') + ')';
		}else{
			soqlFormatArrayString = '(\'\')';
		}
		return soqlFormatArrayString;
	}
    
    public static Schema.DescribeSObjectResult getsObjectDescribe(String sObjectName) {
		Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
		String goodObjectName = sObjectName;
		Schema.SObjectType sobjectType = Schema.getGlobalDescribe().get(goodObjectName);
		return getsObjectDescribe(sobjectType);
	}
    
	/**
      *  Method to return describe for sObject based on SObjectType.
      *  This method check sObject CRUD.
      *  @param  sObjectType Schema.SObjectType.
      *  @return - sObject describe.
    */
	private static Schema.DescribeSObjectResult getsObjectDescribe(Schema.SObjectType sObjectType) {
		Schema.DescribeSObjectResult sobjectTypeDescribe = sobjectType.getDescribe();
		/*if(!sobjectTypeDescribe.isAccessible() || !sobjectTypeDescribe.isQueryable()){
			throw new ValidationException('Object not Accessible');
		}*/
		return sobjectTypeDescribe;
	}
    
    /**
    *  Method to return list of fields name form FieldSet.
    *  @param  sObjectName sObject record.
    *  @param  fieldSetname sObject FieldSet name.
    *  @return - List<String> - list of fields name.
    */
    public static List<String> getFieldSetsFields(String sObjectName , String fieldSetname) {

		List<String> fieldsName = new List<String>();
		Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();

		Schema.SObjectType SObjectTypeObj;
		if(GlobalDescribeMap.containsKey(sObjectName)){
			SObjectTypeObj = GlobalDescribeMap.get(sObjectName);
		}else{
			SObjectTypeObj = GlobalDescribeMap.get(sObjectName);
		}
		if(SObjectTypeObj == null){
			throw new ValidationException('Invalid Object');
		}
		Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

		Map<String,Schema.FieldSet> sObjectFieldSets = DescribeSObjectResultObj.FieldSets.getMap();

		String goodFieldSetName = fieldSetName;
		if(!sObjectFieldSets.containsKey(goodFieldSetName)){
			goodFieldSetName = fieldSetName;
			if(!sObjectFieldSets.containsKey(goodFieldSetName)){
				return fieldsName;
			}
		}
		for(Schema.FieldSetMember fieldSetMemberObj : sObjectFieldSets.get(goodFieldSetName).getFields()){
			fieldsName.add(fieldSetMemberObj.getFieldPath());
		}
		return fieldsName;
	}
    
    /**
      *  Method to return describe for list of sObject fields.
      *  This method check sObject FLS and CRUD.
      *  @param  sObjectDescribe sObject describe.
      *  @param  fieldsName sObject FieldSet name.
      *  @return - fields DescribeFieldResult.
    */
	private static Map<String,Schema.DescribeFieldResult> getsObjectFieldsDescribe(Schema.DescribeSObjectResult sObjectDescribe , List<String> fieldsName) {
		Map<String,Schema.SObjectField> objectFields = sObjectDescribe.fields.getMap();
		Map<String,Schema.DescribeFieldResult> fieldsDescribe = new Map<String, Schema.DescribeFieldResult>();
		for(String fieldName : fieldsName){
			String goodFieldName = fieldName;
			Schema.DescribeFieldResult fieldDescribe;
			if(objectFields.containsKey(goodFieldName)){
				fieldDescribe = objectFields.get(goodFieldName).getDescribe();
			}else{
				if(objectFields.containsKey(fieldName)){
					goodFieldName = fieldName;
					fieldDescribe = objectFields.get(goodFieldName).getDescribe();
				}else{ //describe for reference fields
					if(goodFieldName.indexOf('.')!=-1){
						//goodFieldName
						fieldDescribe = getReferenceFieldDescribeResult(sObjectDescribe,goodFieldName);
					}
				}
			}
			//if(fieldDescribe != null && fieldDescribe.isAccessible()){
				fieldsDescribe.put(goodFieldName,fieldDescribe);
			//}
		}
		return fieldsDescribe;
	}
    
    /**
    *  Method to get a describe of sObject relationship field up to 5 level of a hierarchy.
    *  Method allso work fine with a polymorphic fields (like an Owner..).
    *  This method check FLS.
    *  @param  sObjectDescribe sObject describe info.
    *  @param  fieldName relationship field path name.
    *  @return - field describe.
    */
	public static Schema.DescribeFieldResult getReferenceFieldDescribeResult(Schema.DescribeSObjectResult sObjectDescribe, String fieldName) {
		List<String> path = fieldName.split('\\.');
		Schema.DescribeSObjectResult type = sObjectDescribe;
		while (path.size() > 1) {
			String lookupName = getLookupName(path.remove(0));
			String goodLookupName = lookupName;
			Map<String,Schema.SObjectField> objectFields = type.fields.getMap();
			if(!objectFields.containsKey(goodLookupName)){
				goodLookupName = lookupName;

				if(!objectFields.containsKey(goodLookupName)){
					return null;
				}

			}
			Schema.DescribeFieldResult describe = objectFields.get(goodLookupName).getDescribe();
			/*if(!describe.isAccessible()){
				return null;
			}*/
			List <Schema.sObjectType> referenceTypes = describe.getReferenceTo();
			if(referenceTypes.isEmpty()){
				return null;
			}
			if( referenceTypes.size() == 1){
				type = describe.getReferenceTo()[0].getDescribe();
			}
			else{
				Boolean fieldFound = false;
				for(Integer i=0; i<referenceTypes.size() ; i++){
					if(referenceTypes[i].getDescribe().fields.getMap().containsKey(goodLookupName)){
						type = describe.getReferenceTo()[i].getDescribe();
						fieldFound = true;
					}
				}
				if(!fieldFound){
					return null;
				}
			}
		}
		String lastPathFieldName = path[0];
		if(!type.fields.getMap().containsKey(lastPathFieldName)){
			lastPathFieldName = path[0];
			if(!type.fields.getMap().containsKey(lastPathFieldName)){
				return null;
			}

		}
		return type.fields.getMap().get(lastPathFieldName).getDescribe();
	}
    
    private static String getLookupName(String crossObjectReference) {
		return crossObjectReference.endsWith('__r') ?
				crossObjectReference.replace('__r', '__c') :
				crossObjectReference + 'Id';
	}
    
    /**
      *  Method to return describe for list of sObject fields.
      *  @param  sObjectName sObject record.
      *  @param  fieldsNames sObject FieldSet name.
      *  @return - fields DescribeFieldResult.
    */
	public static Map<String,Schema.DescribeFieldResult> getsObjectFieldsDescribe(String sObjectName , List<String> fieldsNames) {
		Schema.DescribeSObjectResult sObjectDescribe = getsObjectDescribe(sObjectName);
		if(sObjectDescribe == null){
			return null;
		}
		return getsObjectFieldsDescribe(sObjectDescribe,fieldsNames);
	}
    
	/**
      *  Method to return describe of one sObject field.
      *  @param  sObjectName sObject record.
      *  @param  fieldsName sObject FieldSet name.
      *  @return - field DescribeFieldResult.
     */
	public static Map<String,Schema.DescribeFieldResult> getsObjectFieldsDescribe(String sObjectName , String fieldsName) {
		return getsObjectFieldsDescribe(sObjectName , new List<String>{fieldsName});
	}
    
    public static Object readObjectValue(sObject obj, String path) {
    	String[] parts = path.split('\\.');
    	System.debug(path+' --> '+parts);
    	for(Integer c = 0; c < parts.size()-1; c++) {
    		obj = obj.getSObject(parts[c]);
    		if(obj == null) {
    			return null;
    		}
    	} 
    	return obj.get(parts[parts.size()-1]);
    }
    
    /**
      *  Method to return sObject field value.
      *  @param  SObject sObject record.
      *  @param  field sObject field name (including relationship field up to 5 level of hierarchy , like a Contact.Account.Name ).
      *  @return - Object - sObject field value.
     */
	public static Object getFieldValue(SObject o,String field){
		if(o == null){
			return null;
		}
		if(field.contains('.')){
			String nextField = field.substringAfter('.');
			String relation = field.substringBefore('.');
			return getFieldValue((SObject)o.getSObject(relation),nextField);
		}else{
			return o.get(field);
		}
	}
    
    private static Map<Id, String> recordTypeLabelCache;
    public static String getRecordTypeLabel(ID typeID) {
    	if(recordTypeLabelCache == null) {
    		recordTypeLabelCache = new Map<Id, String>();
    	}
    	String label = recordTypeLabelCache.get(typeID);
    	if(label == null) {
	        List<RecordType> rt = [select toLabel(name) from RecordType where id = :typeID];
	        label = (rt.size() == 0)?null:rt.get(0).name;
	        recordTypeLabelCache.put(typeID, label);
    	}
    	return label;
    }
    
    public static String xssSafeValue(String input) {
        input = removeScript(input);
        input = SFDC_JSENCODE(input);
        input = jsDecodeValidHtml(input);
        if (String.isNotBlank(input)) {
            input = input.replace('\\\'', '&#39;').replace('\\"', '"');
        }
        return input;
    }
    
    public static String removeScript(String input) {
        List<String> EVENT_HANDLERS = new List<String> {
                'javascript:','</iframe','</script','<iframe', '<script', 'onclick','oncontextmenu','ondblclick','onmousedown','onmouseenter','onmouseleave','onmousemove',
                'onmouseover','onmouseout','onmouseup','onkeydown','onkeypress','onkeyup','onabort','onbeforeunload',
                'onerror','onhashchange','onload','onpageshow','onpagehide','onresize','onscroll','onunload','onblur',
                'onchange','onfocus','onfocusin','onfocusout','oninput','oninvalid','onreset','onsearch','onselect',
                'onsubmit','ondrag','ondragend','ondragenter','ondragleave','ondragover','ondragstart','ondrop','oncopy',
                'oncut','onpaste','onafterprint','onbeforeprint','onabort','oncanplay','oncanplaythrough','ondurationchange',
                'onemptied','onended','onerror','onloadeddata','onloadedmetadata','onloadstart','onpause','onplay',
                'onplaying','onprogress','onratechange','onseeked','onseeking','onstalled','onsuspend','ontimeupdate',
                'onvolumechange','onwaiting','animationend','animationiteration','animationstart','transitionend','onerror',
                'onmessage','onopen','onmousewheel','ononline','onoffline','onpopstate','onshow','onstorage','ontoggle',
                'onwheel','ontouchcancel','ontouchend','ontouchmove','ontouchstart'
        };
        String output = input;
        if(output != null) {
            output = removeBadUtfChars(output);
            for (String event : EVENT_HANDLERS) {
                output = output.replaceAll('(?i)' + event, ' ');
            }
        }
        return output;
    }
    
    /*
        The methods SFDC_JSENCODE and REPLACE_CODED_CHARACTERS are taken from the SFDCEncoder class from the Force.com ESAPI library
        The REPLACE_CODED_CHARACTERS is named ENCODED in the Force.com ESAPI library
        More information can be found here: https://github.com/forcedotcom/force-dot-com-esapi
    */
    public static String SFDC_JSENCODE(String input) {
        return REPLACE_CODED_CHARACTERS(input, JS_DECODED, JS_ENCODED);
    }

    public static String SFDC_JSDECODE(String input) {
        return REPLACE_CODED_CHARACTERS(input, JS_ENCODED, JS_DECODED);
    }

    private static String REPLACE_CODED_CHARACTERS(String input, String[] fromArr, String[] toArr) {
        if (input == null || input.length() == 0)
            return input;

        for (Integer i = 0; i < fromArr.size(); ++i) {
            input = input.replace(fromArr[i], toArr[i]);
        }

        return input;
    }
    
    public static String jsDecodeValidHtml(String input) {
        return jsDecodeValidHtml(input, HTML_ATTRIBUTE_WHITELIST);
    }

    /*
        Will ensure that html tags only have the attributes that are listed in the set of strings.
        Any attributes that are not listed will be removed
    */
    public static String jsDecodeValidHtml(String input, Map<String, Set<String>> whiteList) {
        System.debug('\r\rinput: ' + input);
        if (String.isBlank(input)) {
            return null;
        }
        String originalInput = input;
        Map<String, Integer> openingTags = new Map<String, Integer>();
        Map<String, Integer> closingTags = new Map<String, Integer>();
        Set<String> htmlTagsSet = new Set<String>();
        String htmlAttributePattern = '(\\S+)=["\\\']?((?:.(?!["\\\']?\\s+(?:\\S+)=|[>"\\\']))+.)["\\\']?';
        Pattern patternHtmlAttribute = Pattern.compile(htmlAttributePattern);
        for (String htmlTag : whiteList.keySet()) {

            // Loop twice over the same tag (opening and closing)
            for (Integer i = 0; i < 2; i++) {
                if (i == 1) {
                    htmlTag = '\\\\/' + htmlTag;
                }
                String htmlTagPattern = '(?i)\\\\u003C' + htmlTag + '(.*?)u003E';
                System.debug('\r\rhtmlTagPattern: ' + htmlTagPattern);
                Pattern patternHtmlTag = Pattern.compile(htmlTagPattern);
                Matcher htmlTagMatcher = patternHtmlTag.matcher(input);

                while(htmlTagMatcher.find()) {
                    String encodedHtmlTag = htmlTagMatcher.group(0);
                    String decodedHtmlTag = SFDC_JSDECODE(encodedHtmlTag);

                    if (i != 1) {
                        String foundHtmlTag = decodedHtmlTag.substring(1, decodedHtmlTag.indexOfAny(' />'));
                        // Can be that the tag found is not right EG: i is found in img. If so, ignore
                        if(!htmlTag.equalsIgnoreCase(foundHtmlTag)) {
                            continue;
                        }
                        if (!decodedHtmlTag.endsWith('/>')) {
                            // Set the count for an opening tag
                            setTagCount(openingTags, htmlTagsSet, foundHtmlTag.toLowerCase());
                        }
                    }
                    else {
                        String foundHtmlTag = decodedHtmlTag.substring(2, decodedHtmlTag.indexOf('>'));
                        // Set the count for a closing tag
                        setTagCount(closingTags, htmlTagsSet, foundHtmlTag.toLowerCase());
                    }

                    // Validate the attributes in the HTML tag. Remove any that are not allowed
                    Matcher htmlAttributeMatcher = patternHtmlAttribute.matcher(decodedHtmlTag);
                    while(htmlAttributeMatcher.find()) {
                        if(!whiteList.get(htmlTag).contains(htmlAttributeMatcher.group(1)) && !safeHtmlAttributes.contains(htmlAttributeMatcher.group(1))) {
                            decodedHtmlTag = decodedHtmlTag.replaceFirst(htmlAttributeMatcher.group(0), '');
                        }
                    }

                    input = input.replace(encodedHtmlTag, decodedHtmlTag);
                }
            }
        }

        Boolean validHtml = true;
        // Validate that all opening html tags have a closing html tag. If not, return the original input value
        for (String currentTag : htmlTagsSet) {
            if (!openingTags.containsKey(currentTag) || !closingTags.containsKey(currentTag)) {
                validHtml = false;
                break;
            }
            if (openingTags.get(currentTag) != closingTags.get(currentTag)) {
                validHtml = false;
                break;
            }
        }

        // Html is not valid. Return the original input value
        if (!validHtml) {
            return originalInput;
        }

        input = REPLACE_CODED_CHARACTERS(input, JSINHTML_ENCODED, JSINHTML_DECODED);
        System.debug('\r\rfinal input: ' + input);
        return input;
    }
    
    public static String removeBadUtfChars(String input) {
        String output = '';
        if(input != null){
            output = input.replaceAll('[^\\u0009|\\u000A|\\u000D|\\u0020-\\uF7FF|\\uE000-\\uFFFD]', '');
        }
        return output;
    }
    
    private static void setTagCount(Map<String, Integer> tagCountMap, Set<String> htmlTagsSet, String htmlTag) {
        Integer tagCount = 1;
        if (tagCountMap.containsKey(htmlTag)) {
            tagCount = tagCountMap.get(htmlTag) + 1;
        }
        tagCountMap.put(htmlTag, tagCount);
        htmlTagsSet.add(htmlTag);
    }
    
    public static String removeHtml(String input) {
        return input.replaceAll('<.*?>', ' ');
    }
    
    // using describe, check if user has access to the object
    public static String checkIfUserHasObjectLevelSecurity(String objectApiName, String recordId) {

        Schema.SObjectType sObjectTypeObj = Schema.getGlobalDescribe().get(objectApiName);
        if (sObjectTypeObj == null) {
            return 'Invalid ObjectName';
        }
        Schema.DescribeSObjectResult d = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> fieldDescribes = SObjectTypeObj.getDescribe().fields.getMap();

        // returns appropriate error message when a user does not have new or edit access accordingly, returns empty otherwise
        if (String.isEmpty(recordId) && !d.isCreateable() && !(GenericUtils.isCommunityUser && GenericUtils.bypassObjectAccess.contains(objectApiName.toLowerCase()))) {
            return 'Object Not Createable' + ': ' + d.getLabel();
        } else if(String.isNotEmpty(recordId) && !d.isUpdateable() && !(GenericUtils.isCommunityUser && GenericUtils.bypassObjectAccess.contains(objectApiName.toLowerCase()))) {
            return 'Object Not Updateable' + ': ' + d.getLabel();
        }
        return '';
    }
    
    public static String getFieldsetQuery(String objectName,Schema.FieldSetMember[] fieldSet){
        return getFieldsetQuery(objectName, fieldSet, new List<String>());
    }

    public static String getFieldsetQuery(String objectName,Schema.FieldSetMember[] fieldSet,List<String> mandatoryFields){
        return getFieldsetQuery(objectName, fieldSet, mandatoryFields, '', '', '', false);
    }
    
    public static String getFieldsetQuery(String objectName, Schema.FieldSetMember[] fieldSet, List<String> mandatoryFields, String whereClause, String orderBy, String queryLimit, Boolean convertFieldPaths){
        return getFieldsetQuery(objectName, fieldSet, mandatoryFields, whereClause, orderBy, queryLimit, convertFieldPaths, true);
    }

    public static String getFieldsetQuery(String objectName, Schema.FieldSetMember[] fieldSet, List<String> mandatoryFields, String whereClause, String orderBy, String queryLimit, Boolean convertFieldPaths, Boolean addPrefix){
        Set<String> fieldsAlreadyInQuery = new Set<String>();
        fieldsAlreadyInQuery.add('id');
        String query = 'select id';

        for (String field: mandatoryFields) {
            field = field.toLowerCase();
            query += ', '+field;
            fieldsAlreadyInQuery.add(field);
        }

        for(Schema.FieldSetMember fieldsetMember:fieldSet) {

            String field = fieldsetMember.getFieldPath().toLowerCase();
            if (!fieldsAlreadyInQuery.contains(field)){
                query += ', ' + field;
                fieldsAlreadyInQuery.add(field);
            }
            // Add the converted fieldPath (instead of replacing it)
            if (convertFieldPaths) {
                String convertedField = getConvertedFieldPath(fieldsetMember).toLowerCase();
                if (convertedField != field) {
                    if (!fieldsAlreadyInQuery.contains(convertedField)) {
                        query += ', ' + convertedField;
                        fieldsAlreadyInQuery.add(convertedField);
                    }
                }
            }

        }
        query += ' from '+objectName;

        if(String.isNotBlank(whereClause)) {
            query += ' '+whereClause;
        }
        if(String.isNotBlank(orderBy)) {
            query += ' '+orderBy;
        }
        if(String.isNotBlank(queryLimit)) {
            query += ' '+queryLimit;
        }
        return query;
    }
    
    public static Schema.DescribeFieldResult getFieldDescribeResult(Schema.SObjectType objectType, Schema.FieldSetMember member) {
        String fieldPath = member.getFieldPath();

        return getFieldDescribeResult(objectType, fieldPath);
    }

    private static Map<String, Schema.DescribeFieldResult> fieldDescribeResultCache = new Map<String, Schema.DescribeFieldResult>();
    public static Schema.DescribeFieldResult getFieldDescribeResult(Schema.SObjectType objectType, String fieldPath) {
        Schema.DescribeSobjectResult objectDescribe = objectType.getDescribe();
        String key = objectDescribe.getName()+fieldPath;
        Schema.DescribeFieldResult value = fieldDescribeResultCache.get(key);

        if(value == null) {
            List<String> path = fieldPath.split('\\.');
            Schema.SObjectType type = objectType;

            while (path.size() > 1) {
                String lookupName = getLookupName(path.remove(0));
                Schema.DescribeFieldResult describe = null;
                try {
                    describe = type.getDescribe().fields.getMap().get(lookupName).getDescribe();
                }
                catch(Exception e) {
                    describe = type.getDescribe().fields.getMap().get(lookupName).getDescribe();
                }
                type = describe.getReferenceTo()[0];
            }

            Map<String, Schema.SObjectField> objectFields = type.getDescribe().fields.getMap();
            Schema.SObjectField objectField = objectFields.get(path[0]);
            if(objectField == null) {
                objectField = objectFields.get(path[0]);
            }
            value = objectField.getDescribe();

            fieldDescribeResultCache.put(key, value);
        }
        return value;
    }
    
    public static ID getRecordType(String typeName, String objectName) {
        if(typeName == null || typeName == '' || objectName == null || objectName == '') {
            return null;
        }
        Id recordTypeId = [SELECT Id, SobjectType, Name FROM RecordType
                				WHERE SobjectType=: objectName
                           		AND Name=: typeName
                           		AND IsActive = true
                LIMIT 1].id;
        if(recordTypeId != null){
            return recordTypeId;
        }
        return null;
    }
    
    public static String fillField(sObject target, Schema.DescribeFieldResult describe, String name, Object value) {
        if (((target.Id == null) && describe.isCreateable()) || ((target.Id != null) && describe.isUpdateable())) {
            Schema.DisplayType dType = describe.getType();
            try {
                if (value == null || String.isBlank(String.valueOf(value))) {
                    target.put(name, null);
                }
                else {
                    if (dType == Schema.DisplayType.Boolean) {
                        target.put(name, Boolean.valueOf(value));
                    } else if (dType == Schema.DisplayType.Date) {
                        System.debug('value=:'+value);
                        if (String.valueOf(value).contains('Z')) {
                            DateTime dt = isoTime2DateTime(String.valueOf(value));
                            target.put(name, dt.date());
                        } else {
                            String dateValue = String.valueOf(value);
                            // If an exception is thrown, it is because, converting a string to a date via the parse method has failed.
                            // Catch statement contains a second attempt to convert the date via the valueOf function.
                            // If the user selects a date via the calendar, the valueOf function is needed.
                            // If the user manually enters a date, the parse function is needed.
                            try {
                                target.put(name, Date.parse(dateValue));
                            }
                            catch (Exception e) {
                                if (!dateValue.contains(':')) {
                                    dateValue += ' 00:00:00';
                                }
                                target.put(name, Date.valueOf(dateValue));
                            }
                        }
                    } else if (dType == Schema.DisplayType.DateTime) {
                        if (String.valueOf(value).contains('Z')) {
                            target.put(name, isoTime2DateTime(String.valueOf(value)));
                        } else {
                            target.put(name, DateTime.valueOf(value));
                        }
                    } else if (dType == Schema.DisplayType.Double) {
                        target.put(name, Double.valueOf(value));
                    } else if (dType == Schema.DisplayType.Integer) {
                        target.put(name, Integer.valueOf(value));
                    } else if (dType == Schema.DisplayType.Currency) {
                        target.put(name, Double.valueOf(value));
                    } else if (dType == Schema.DisplayType.Percent) {
                        target.put(name, Double.valueOf(value));
                    } else if (dType == Schema.DisplayType.Location) {
                        System.debug('(Geo)location not supported');
                    } else if (dType == Schema.DisplayType.TEXTAREA) {
                        target.put(name, removeScript(String.valueOf(value)));
                    } else {
                        String disarmedValue = disarmString(String.valueOf(value));
                        if(value != disarmedValue) {
                            disarmedValue = truncString((String) disarmedValue,describe.getLength());
                            target.put(name, disarmedValue);
                        }
                        else {
                            target.put(name, value);
                        }
                    }
                }
                return null;
            } catch (Exception e) {
                System.debug('Exception while setting value of ' + name + ' (' + dType + '):\r' + e.getMessage() + '\r' + e.getStackTraceString());
                return (e.getMessage());
            }
        }
        else {
            String error =null;
            if (target.Id == null) {
                error = 'Field not createable';
            }
            else {
                error = 'Field not updateable';
            }
            return error;
        }
    }
    
    public static String truncString(String text,Integer maxLength) {
        return truncString(text,maxLength,'');
    }

    public static String truncString(String text,Integer maxLength,String truncationString) {
        String result = null;
        if (text == null) {
            return '';
        }
        Integer truncationPos = maxLength-truncationString.length();
        if (truncationPos < 0 ) {
            truncationPos = 0;
        }
        if (text.length() > truncationPos) {
            result = text.left(truncationPos)+truncationString;
        } else {
            result = text;
        }
        return result;
    }
    
    public static String disarmString (String input) {
        if (String.isBlank(input)) {
            return input;
        }
        String pattern = '<(?=\\S|$)'; // all < not followed by a space
        String output = input.replaceAll(pattern, '< ');
        return output;
    }
    
    public static DateTime isoTime2DateTime(String isoTime) {
        DateTime val = (DateTime)JSON.deserialize('"'+isoTime+'"',DateTime.class);
        return val;
    }
    
    public static List<String> getPickListValuesIntoList(String sObjectName, Id recordTypeId, String fieldName){
       List<String> pickListValuesList= new List<String>();
        Map<String, Schema.DescribeFieldResult> fieldsDescribe = getsObjectFieldsDescribe(sObjectName, new List<String>{fieldName});
        if(fieldsDescribe.containsKey(fieldName)) {
            Schema.DescribeFieldResult fieldResult = fieldsDescribe.get(fieldName);
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                pickListValuesList.add(pickListVal.getLabel());
            } 
        }    
        return pickListValuesList;
    }
    
    public static void checkCommunityUser() {
        String userType = UserInfo.getUserType();
        if(String.isNotBlank(userType) && (userType == 'High Volume Portal' || userType == 'Partner' || userType == 'CspLitePortal')) {
            GenericUtils.isCommunityUser = true;
        } else {
            GenericUtils.isCommunityUser = false;
        }
    }
    
    //utility method to return help text message on the basis where it needs to be applied from preconfiguration setting
    public static String getHelpTextConfiguration(String helpTextFor) {
        if(String.isNotBlank(helpTextFor)) {
            Map<String, Help_Text_Configuration__mdt> mapOfHelpTextConfigurations;
            if(mapOfHelpTextConfigurations == null) {
                mapOfHelpTextConfigurations = new Map<String, Help_Text_Configuration__mdt>();
                for (Help_Text_Configuration__mdt hTC : [SELECT Id, MasterLabel, Message__c, Active__C 
                                                         FROM Help_Text_Configuration__mdt
                                                         WHERE Active__c = true
                                                        ]) 
                { 
                    mapOfHelpTextConfigurations.put(hTC.MasterLabel.toLowerCase(), hTC);
                }
            }
            if(mapOfHelpTextConfigurations.containsKey(helpTextFor.toLowerCase())) {
                return mapOfHelpTextConfigurations.get(helpTextFor.toLowerCase()).Message__c;
            } else {
                return null;
            }
        } else {
            return null;
        }
    }
}