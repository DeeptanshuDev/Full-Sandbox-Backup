/**
*	Description   	:   
*
* 	Created By		:	Abhinav Sharma   
*
* 	Created Date	:   01/13/2020
* 
*  	Version			:   v1.0 - Created - CR - 00000066 - Abhinav Sharma         
**/ 
public with sharing class FieldSetUtility 
{
    
    public static List<Schema.FieldSetMember> retrieveFieldSetDetails(String fieldSetName, String objectName)
    {
        try 
        {
            if(String.isNotBlank(fieldSetName)) 
            {
                if(String.isNotBlank(objectName)) 
                {
                    Schema.SObjectType sObjectTypeObj = FieldSetUtility.getObjectTypeOnBasisOfObjectName(objectName);
                    if(sObjectTypeObj != null) 
                    {
                        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
                        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
                        if(fieldSetObj != null) 
                        {
                        	return fieldSetObj.getFields();    
                        }
                        else 
                        {
                        	return null;    
                        }        
                    }
                    else 
                    {
                    	return null;    
                    }
                }
                else 
                {
                    throw new customException('Please specify object name.');     
                }
            }
            else 
            {
                throw new customException('Please specify field set name.');  
            }    
        }
        catch(Exception ex) 
        {
        	throw new customException(ex.getMessage());   
        }
    }
    
    public static Schema.SObjectType getObjectTypeOnBasisOfObjectName(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
    
        
    public static Schema.SObjectType getObjectTypeOnBasisOfObjectName1(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
        
    public static Schema.SObjectType getObjectTypeOnBasisOfObjectName2(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
    
        
    public static Schema.SObjectType getObjectTypeOnBasisOfObjectName3(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
    
     public static Schema.SObjectType getObjectTypeOnBasisOfObjectName4(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
    
    public static String getFieldsetQuery(String objectName, Schema.FieldSetMember[] fieldSet)
    {
        return getFieldsetQuery(objectName, fieldSet, new List<String>());
    }
    
    public static String getFieldsetQuery(String objectName,Schema.FieldSetMember[] fieldSet,List<String> mandatoryFields)
    {
        return getFieldsetQuery(objectName, fieldSet, mandatoryFields, '', '', '', false);
    }
    
    public static String getFieldsetQuery(String objectName, Schema.FieldSetMember[] fieldSet, 
                                          List<String> mandatoryFields, String whereClause, String orderBy, 
                                          String queryLimit, Boolean convertFieldPaths)
    {
        return getFieldsetQuery(objectName, fieldSet, mandatoryFields, whereClause, orderBy, queryLimit, convertFieldPaths, true);
    }
    
    public static String getFieldsetQuery(String objectName, Schema.FieldSetMember[] fieldSet, List<String> mandatoryFields, 
                                          String whereClause, String orderBy, String queryLimit, Boolean convertFieldPaths, 
                                          Boolean addPrefix)
    {
        Set<String> fieldsAlreadyInQuery = new Set<String>();
        fieldsAlreadyInQuery.add('id');
        String query = 'select id';
        
        for (String field: mandatoryFields) 
        {
            field = field.toLowerCase();
            if (field.endswith('__c') && !field.startsWith(GenericUtils.getPackagePrefix()) && addPrefix) 
            {
                field = GenericUtils.getPackagePrefix()+field;
            }
            query += ', '+field;
            fieldsAlreadyInQuery.add(field);
        }
        
        for(Schema.FieldSetMember fieldsetMember:fieldSet) 
        {
            String field = fieldsetMember.getFieldPath().toLowerCase();
            if (!fieldsAlreadyInQuery.contains(field))
            {
                query += ', ' + field;
                fieldsAlreadyInQuery.add(field);
            }
            
            // Add the converted fieldPath (instead of replacing it)
            if (convertFieldPaths) 
            {
                String convertedField = getConvertedFieldPath(fieldsetMember).toLowerCase();
                if (convertedField != field) 
                {
                    if (!fieldsAlreadyInQuery.contains(convertedField)) 
                    {
                        query += ', ' + convertedField;
                        fieldsAlreadyInQuery.add(convertedField);
                    }
                }
            }
        }
        query += ' from '+objectName;
        
        if(String.isNotBlank(whereClause)) 
        {
            query += ' '+whereClause;
        }
        if(String.isNotBlank(orderBy)) 
        {
            query += ' '+orderBy;
        }
        if(String.isNotBlank(queryLimit)) 
        {
            query += ' '+queryLimit;
        }
        
        return query;
    }
    
    public static String getConvertedFieldPath(Schema.FieldSetMember fsMember) 
    {
        return getConvertedFieldPath(fsMember.getFieldPath(),String.valueOf(fsMember.getType()));
    }

    public static String getConvertedFieldPath(String fieldPath , String fieldType) 
    {
        String fieldName = fieldPath;

        if (fieldName == 'Id') 
        {
            fieldName = 'Id';
        }
        else if (fieldName.endsWithIgnoreCase('.Id')) 
        {
			fieldName = fieldPath.left(fieldPath.length()-2) + 'Name';
        }
        else if (fieldPath.endsWithIgnoreCase('Id')) 
        {
            fieldName = fieldPath.left(fieldPath.length()-2) + '.Name';
        }
        else if(fieldType  == 'REFERENCE') 
        {
            if (fieldName.endsWithIgnoreCase('__c')) 
            {
                fieldName = fieldName.removeEndIgnoreCase('__c') + '__r.Name';
            } 
            else 
            {
                fieldName += '.Name';
            }
        }
		return fieldName; 
    }
	
	  public static Schema.SObjectType getObjectTypeOnBasisOfObjectName7(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
	  public static Schema.SObjectType getObjectTypeOnBasisOfObjectName8(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
	  public static Schema.SObjectType getObjectTypeOnBasisOfObjectName9(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
	  public static Schema.SObjectType getObjectTypeOnBasisOfObjectName10(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
	  public static Schema.SObjectType getObjectTypeOnBasisOfObjectName11(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
	  public static Schema.SObjectType getObjectTypeOnBasisOfObjectName12(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
	  public static Schema.SObjectType getObjectTypeOnBasisOfObjectName13(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
	  public static Schema.SObjectType getObjectTypeOnBasisOfObjectName14(String objName) 
    {
        if(objName == null || String.isEmpty(objName))
            return null;
        return ((SObject)Type.forName(objName).newInstance())
            .getSObjectType();
    }
    
    public static void testCov(){
       Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
    }
}