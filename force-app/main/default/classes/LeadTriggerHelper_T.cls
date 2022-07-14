@isTest(seeAlldata = false)
public class LeadTriggerHelper_T {
    @isTest
    private static void updateLeadOnConvert()
    {
        Lead lead = new Lead(LastName='Test Lead', Company ='Testing company',
                             Status = 'Open', Phone = '1029384756',
                             Type__c = 'Other', LeadSource ='Email');
        insert lead;
        test.startTest();
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(lead.id);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        Lead testLead = [SELECT Id,Lead_Source__c FROM Lead WHERE Id = :lead.id];
        System.assertEquals('Email', testLead.Lead_Source__c);
        test.stopTest();
    }
}