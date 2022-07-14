/*
 * Copyright (c) 2011-2016 FinancialForce.com, inc. All rights reserved.
 *
 * Class to start batch process to load catalogs
*/
public with sharing class SCMCLLoadCatalogExtension 
{
    private ApexPages.StandardSetController standardController;
    private Map<String, Schema.SObjectType> globalSchemaDesc  = Schema.getGlobalDescribe() ;
    public String listFilterId {get; set;}
    
    public SCMCLLoadCatalogExtension(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
        this.listFilterId = standardController.getFilterId();
    }
    public pageReference process() 
    { 
        try 
        {
             Database.executeBatch(new SCMCLLoadCatalog(), 100);
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Batch has been started, on completion you will receive the mail.'));   
             return null;
        }
        catch(DmlException e) 
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            return null;
        }
    }
    
    public PageReference goback() {
        String idForNavigation;
        String objectprefix= globalSchemaDesc.get('SCMC__Catalog_Load__c').getDescribe().getKeyPrefix();
        idForNavigation = objectprefix+'?fcf='+listFilterId ;       
        PageReference page = new PageReference('/' + idForNavigation);
        page.setRedirect(true);
        return page;  
    }
}