/**
*  Description     :   Test class for vf page controller class UploadAthletesController.
*            
*  Create By       :   
*
*  Created Date    :   31-07-2020
*
*  Revision Log    :   V_1.0 - Created - 31-07-2020
*
*  Coverage        :   
*
**/
@isTest(seeAllData = false)
public class Test_UploadAthletesController
{    
    @isTest
    private static void test_importCSVFile() 
    {
        Account acc = new Account(Name = 'Test Acc');
        insert acc;
        
        //Setting vf page reference
        Test.setCurrentPageReference(Page.FF_Add_Athlete_To_Team);
        System.currentPageReference().getParameters().put('Id', acc.Id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(acc);
        UploadAthletesController ctrl = new UploadAthletesController(stdCtrl);
        
        String csvHeader = 'First Name, Last Name, Gender, Preferred Phone\n';
        List<String> conDatas = new List<String>();
        conDatas.add('Test, Con1, Male,Phone');
        conDatas.add('Test, Con2, Female,Phone');
        
        String csvString = csvHeader + String.join(conDatas,'\n');
        
        //Start Test
        Test.startTest();
        
        ctrl.csvFileBody = Blob.valueOf(csvString);
        
        ctrl.back();
        ctrl.importCSVFile();
        
        //Asserts
       	List<Contact> cons = [SELECT Id FROM Contact];
        System.assertEquals(2, cons.size());
        
        
        ctrl.csvFileBody = null;
        ctrl.importCSVFile();
        //Stop Test
        Test.stopTest();
        
        
    }
}