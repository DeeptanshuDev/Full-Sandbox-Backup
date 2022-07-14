public with sharing class StageDetail {
    
    @AuraEnabled
    public static String getStage(Id id){

        Opportunity str = [SELECT StageName FROM Opportunity WHERE Id =: id];
        System.debug('Stage value is : ' + str);
        String a = '0';
        if(str.StageName == 'Open')
        {
            a = '1';
            System.debug('1 is returned : '+ a);

            
        }
        else if(str.StageName == 'Closed - Balance Due')
        {
            a = '2';
            System.debug('2 is returned: '+a);
           
        }
        else if(str.StageName == 'Closed - Paid')
        {
            a ='3';
            System.debug('3 is returned : '+ a);
            
        }
        else if(str.StageName == 'Closed Lost')
        {
            a ='4';
            System.debug('4 is returned : ' + a);
            
        }
        else if(str.StageName == 'Grey Out')
        {
            a ='5';
            System.debug('5 is returned : '+ a );
            
        }
        return a;
        
    }
}