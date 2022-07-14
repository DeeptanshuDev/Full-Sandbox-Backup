/**
*   Purpose         :   Class to have the logic to lookup SFDC relationship fields on the basis of FF external ID fields.
*   Created By      :   Ayush Gupta
*   Created Date    :   03/30/2020
*   Revision Log    :   v1.0 - Created - 03/30/2020
**/
public without sharing class ExternalIdFieldMetaDataMapping 
{
    public static Map<String, Id> getTargetObjectRecordIds(String sourceObjectApi, String sourceFieldApi, 
                                                           Set<String> sourceIds)
    {	System.debug('in map external id, sourceObjectApi---'+sourceObjectApi+'--sourceFieldApi--'+sourceFieldApi+'--sourceIds'+sourceIds);
        //Map to Hold Key = ExternalId, Value = LookupField Id(Of Salesforce)
        Map<String, Id> mapExternalIdAndTargetObjId = new Map<String, Id>();
        if(String.isNotBlank(sourceObjectApi) && String.isNotBlank(sourceFieldApi) 
           && sourceIds != null && sourceIds.size() > 0
        )
        {System.debug('in if');
            try
            {
                //Query to get Target Object and Field Api from MetaData
                String metadataQuery = 'Select Target_Object__c, Target_Field__c From External_Id_Field_Mapping__mdt WHERE Source_Object__c =: sourceObjectApi AND Source_Field__c =: sourceFieldApi LIMIT 1' ;
                List<External_Id_Field_Mapping__mdt> mdds = Database.query(metadataQuery);System.debug('mdds--'+mdds);
                if(mdds.size() > 0) 
                {
                	//To Hold Target Object and Field Api
                    String targetObjectApi = mdds[0].Target_Object__c;
                    String targetFieldApi = mdds[0].Target_Field__c;
                	
                    //Query To Get Lookup Field Id and Parent External Id
                	String targetObjectQuery = 'SELECT ID, ' + targetFieldApi + ' FROM ' + targetObjectApi + ' WHERE ' +  targetFieldApi + ' =:  sourceIds';
                    System.debug('Query '+targetObjectQuery);
                    
                    List<Sobject> sobjs = Database.query(targetObjectQuery);System.debug('sobjs--'+sobjs);
                	for(Sobject sobj : sobjs)
                    {
                        
                        mapExternalIdAndTargetObjId.put((String)sobj.get(targetFieldApi), sobj.id);
                    }    
                }
                else 
                {System.debug('in else mdds size 0');
                	throw new customException('External ID fields mapping does not exists');    
                }
            }
            catch(Exception ex)
            {
              
                System.debug('Error = ' + ex.getMessage());
                CustomException cst = new CustomException();
                cst.setMessage(ex.getMessage());
                throw cst;
            }
        }
        return mapExternalIdAndTargetObjId;
    }
    
    /*public static Map<String, Id> oldApproach(String targetObjectApi, Set<String> sourceIds)
    {	
    System.debug('targetObjectApi = ' + targetObjectApi);
    System.debug('sourceIds = ' + sourceIds);
    Map<String, Id> mapExternalIdAndTargetObjId = new Map<String, Id>();
    if(targetObjectApi != null && sourceIds != null && sourceIds.size() > 0){
    try{
    //Query to get Field Api from MetaData
    String metadataQuery = 'Select  External_Id_Field__c From Object_And_Its_Id_Field__mdt WHERE Object_Api__c =: targetObjectApi LIMIT 1' ;
    Object_And_Its_Id_Field__mdt mdd = Database.query(metadataQuery);
    System.debug('mdd = ' + mdd);
    //To Hold Field Api
    String parentFieldApi = mdd.External_Id_Field__c;
    System.debug('parentFieldApi = ' + parentFieldApi);
    if(parentFieldApi == null){
    return mapExternalIdAndTargetObjId;
    }
    //Query To Get Lookup Field Id and Parent External Id
    String targetObjectApiQuery = 'SELECT ID, ' + parentFieldApi + ' FROM ' + targetObjectApi + ' WHERE ' +  parentFieldApi + ' =:  sourceIds';
    List<Sobject> sobjs = Database.query(targetObjectApiQuery);
    System.debug('sobjs = ' + sobjs);
    for(Sobject sobj : sobjs){
    mapExternalIdAndTargetObjId.put( (String)sobj.get(parentFieldApi), sobj.id);
    }
    System.debug('mapExternalIdAndTargetObjId');
    System.debug(mapExternalIdAndTargetObjId);
    }catch(Exception ex){
    }
    }
    System.debug('mapExternalIdAndTargetObjId = ' + mapExternalIdAndTargetObjId);        
    return mapExternalIdAndTargetObjId;
    }*/
}