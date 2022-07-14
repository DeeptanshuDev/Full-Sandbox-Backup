@isTest
public class TriggerHelperForReceivedOrderAndLineTest 
{
    //Test Setup
    @testSetup
    static void TestSetup() 
    {
        List<Account> accs = new List<Account>();
        
        Account acc = new Account();
        acc.Name = 'TestAcc';
        accs.add(acc);
        
        Account acc2 = new Account();
        acc2.Name = 'Rebel Cheer Wholesale';
        accs.add(acc2);
        insert accs;
        
        Datetime invalidDate = DateTime.newInstance(2020, 4, 23);
        Datetime validDate = DateTime.newInstance(2020, 4, 25, 0, 0, 1);
        
        List<SCMC__Received_Order__c> recOrders = new List<SCMC__Received_Order__c>();
        for(Integer i=0; i<5; i++)
        {
            SCMC__Received_Order__c recOrder = new SCMC__Received_Order__c();
            if(i<1)
            {
                recOrder.SCMC__Account_Name__c = accs[0].Name;
            }
            else if(i<2)
            {
                recOrder.SCMC__Account_Name__c = accs[1].Name;
            }
            else if(i<3)
            {
                recOrder.SCMC__Account_Name__c = accs[1].Name;
                recOrder.SCMC__Order_Date__c = invalidDate;
            }
            else if(i<4)
            {
                recOrder.SCMC__Account_Name__c = accs[1].Name;
                recOrder.SCMC__Order_Date__c = validDate;
            }
            else if(i<5)
            {
                recOrder.SCMC__Account_Name__c = accs[0].Name;
                recOrder.SCMC__Order_Date__c = validDate;
            }
            recOrders.add(recOrder);
        }
        insert recOrders;
    }
    
    @isTest
    Static void test_InsertForLine()
    {
        Datetime refDate = DateTime.newInstance(2020, 4, 24);
        List<Account> accTest = [SELECT Id, Name, Account_Number__c FROM Account WHERE Name = 'TestAcc' Limit 1];
        List<Account> accRebel = [SELECT Id, Name, Account_Number__c FROM Account WHERE Name = 'Rebel Cheer Wholesale' Limit 1];
        List<SCMC__Received_Order__c> recOrders = [SELECT Id, Name, SCMC__Account_Name__c, SCMC__Order_Date__c, Related_Account__c, Gym_Name__c  FROM SCMC__Received_Order__c ];
        
        List<SCMC__Received_Order_Line__c> recOrderLines = new List<SCMC__Received_Order_Line__c>();
        for(SCMC__Received_Order__c rec : recOrders)
        {		
            SCMC__Received_Order_Line__c recOrderLine = new SCMC__Received_Order_Line__c();
            if(rec.SCMC__Order_Date__c == null)
            {
                recOrderLine.SCMC__Received_Order__c = rec.Id;
                recOrderLine.Gym_Name__c = accTest[0].Account_Number__c;
            }
            else
            {
                if(rec.SCMC__Account_Name__c == 'Rebel Cheer Wholesale' )
                {
                    if(rec.SCMC__Order_Date__c > refDate)
                    {
                        recOrderLine.SCMC__Received_Order__c = rec.Id;
                        recOrderLine.Gym_Name__c = accTest[0].Account_Number__c;
                    }
                    else
                    {
                        recOrderLine.SCMC__Received_Order__c = rec.Id;
                        //recOrderLine.Gym_Name__c = accTest[0].Account_Number__c;
                    }
                }
                else
                {
                    recOrderLine.SCMC__Received_Order__c = rec.Id;
                    recOrderLine.Gym_Name__c = accTest[0].Account_Number__c;
                }
            }
            recOrderLines.add(recOrderLine);
        }
        
        
        
        test.startTest();
        
        for(SCMC__Received_Order__c recOrd : recOrders)
        {
            System.assertEquals(null, recOrd.Related_Account__c);
            System.assertEquals(null, recOrd.Gym_Name__c);
        }
        
        insert recOrderLines;
        
        List<SCMC__Received_Order__c> recOrdersUpdated = [SELECT Id, SCMC__Account_Name__c, SCMC__Order_Date__c, Related_Account__c, Gym_Name__c FROM SCMC__Received_Order__c ];
        
        
        for(SCMC__Received_Order__c rec : recOrdersUpdated)
        {
            if(rec.SCMC__Order_Date__c == null)
            {
                System.assertEquals(null, rec.Related_Account__c);
                System.assertEquals(null, rec.Gym_Name__c);
                
            }
            else
            {
                if(rec.SCMC__Account_Name__c == 'Rebel Cheer Wholesale' )
                {
                    if(rec.SCMC__Order_Date__c > refDate)
                    {
                        System.assertEquals(accTest[0].id, rec.Related_Account__c);
                        System.assertEquals(accTest[0].Account_Number__c, rec.Gym_Name__c);
                    }
                    else
                    {
                        System.assertEquals(null, rec.Related_Account__c);
                        System.assertEquals(null, rec.Gym_Name__c);
                    }
                }
                else
                {
                    System.assertEquals(null, rec.Related_Account__c);
                    System.assertEquals(null, rec.Gym_Name__c);
                }
            }
        }
        test.stopTest();
    }
    
    @isTest
    Static void test_DeleteForLine()
    {
        Datetime refDate = DateTime.newInstance(2020, 4, 24);
        List<Account> accTest = [SELECT Id, Name, Account_Number__c FROM Account WHERE Name = 'TestAcc' Limit 1];
        List<Account> accRebel = [SELECT Id, Name, Account_Number__c FROM Account WHERE Name = 'Rebel Cheer Wholesale' Limit 1];
        List<SCMC__Received_Order__c> recOrders = [SELECT Id, Name, SCMC__Account_Name__c, SCMC__Order_Date__c, Related_Account__c, Gym_Name__c  FROM SCMC__Received_Order__c ];
        
        List<SCMC__Received_Order_Line__c> recOrderLines = new List<SCMC__Received_Order_Line__c>();
        for(SCMC__Received_Order__c rec : recOrders)
        {		
            
            if(rec.SCMC__Order_Date__c != null && rec.SCMC__Order_Date__c > refDate && rec.SCMC__Account_Name__c == 'Rebel Cheer Wholesale' )
            {
				for(Integer i=0; i<2; i++)
				{
				SCMC__Received_Order_Line__c recOrderLine = new SCMC__Received_Order_Line__c();
                recOrderLine.SCMC__Received_Order__c = rec.Id;
                recOrderLine.Gym_Name__c = accTest[0].Account_Number__c;
				
				recOrderLines.add(recOrderLine);
				}
            }
            
        }
		
        insert recOrderLines;
        
        List<SCMC__Received_Order_Line__c> recOrderLinesNew = [SELECT Id FROM SCMC__Received_Order_Line__c];
        test.startTest();
        
        
		
		delete recOrderLinesNew[0];
		
        List<SCMC__Received_Order__c> recOrdersUpdated = [SELECT Id, SCMC__Account_Name__c, SCMC__Order_Date__c, Related_Account__c, Gym_Name__c FROM SCMC__Received_Order__c ];
        
        
        for(SCMC__Received_Order__c rec : recOrdersUpdated)
        {
            if(rec.SCMC__Order_Date__c != null && rec.SCMC__Order_Date__c > refDate && rec.SCMC__Account_Name__c == 'Rebel Cheer Wholesale' )
                    {
                        System.assertEquals(accTest[0].id, rec.Related_Account__c);
                        System.assertEquals(accTest[0].Account_Number__c, rec.Gym_Name__c);
                    }
        }
        test.stopTest();
    }
    
     @isTest
    Static void test_DeleteAllForLine()
    {
        Datetime refDate = DateTime.newInstance(2020, 4, 24);
        List<Account> accTest = [SELECT Id, Name, Account_Number__c FROM Account WHERE Name = 'TestAcc' Limit 1];
        List<SCMC__Received_Order__c> recOrders = [SELECT Id, Name, SCMC__Account_Name__c, SCMC__Order_Date__c, Related_Account__c, Gym_Name__c  FROM SCMC__Received_Order__c ];
        
        List<SCMC__Received_Order_Line__c> recOrderLines = new List<SCMC__Received_Order_Line__c>();
        for(SCMC__Received_Order__c rec : recOrders)
        {	
            if(rec.SCMC__Order_Date__c != null && rec.SCMC__Order_Date__c > refDate && rec.SCMC__Account_Name__c == 'Rebel Cheer Wholesale' )
            {
				for(Integer i=0; i<2; i++)
				{
				SCMC__Received_Order_Line__c recOrderLine = new SCMC__Received_Order_Line__c();
                recOrderLine.SCMC__Received_Order__c = rec.Id;
                recOrderLine.Gym_Name__c = accTest[0].Account_Number__c;
				
				recOrderLines.add(recOrderLine);
				}
            }
            
        }
		
        insert recOrderLines;
        
        List<SCMC__Received_Order_Line__c> recOrderLinesNew = [SELECT Id FROM SCMC__Received_Order_Line__c];
        test.startTest();
        
        
		
		delete recOrderLinesNew;
		
        List<SCMC__Received_Order__c> recOrdersUpdated = [SELECT Id, Related_Account__c, Gym_Name__c FROM SCMC__Received_Order__c ];
        
        
        for(SCMC__Received_Order__c rec : recOrdersUpdated)
        {
            System.assertEquals(null, rec.Related_Account__c);
                System.assertEquals(null, rec.Gym_Name__c);
        }
        test.stopTest();
    }
    
    @isTest
    Static void test_UpdateForLine()
    {
        Datetime refDate = DateTime.newInstance(2020, 4, 24);
        List<Account> accTest = [SELECT Id, Name, Account_Number__c FROM Account WHERE Name = 'TestAcc' Limit 1];
        List<Account> accRebel = [SELECT Id, Name, Account_Number__c FROM Account WHERE Name = 'Rebel Cheer Wholesale' Limit 1];
        List<SCMC__Received_Order__c> recOrders = [SELECT Id, Name, SCMC__Account_Name__c, SCMC__Order_Date__c, Related_Account__c, Gym_Name__c  FROM SCMC__Received_Order__c ];
        
        List<SCMC__Received_Order_Line__c> recOrderLines = new List<SCMC__Received_Order_Line__c>();
        for(SCMC__Received_Order__c rec : recOrders)
        {		
            
            if(rec.SCMC__Order_Date__c != null && rec.SCMC__Order_Date__c > refDate && rec.SCMC__Account_Name__c == 'Rebel Cheer Wholesale' )
            {
                for(Integer i=0; i<2; i++)
                {
                    SCMC__Received_Order_Line__c recOrderLine = new SCMC__Received_Order_Line__c();
                    recOrderLine.SCMC__Received_Order__c = rec.Id;
                    recOrderLine.Gym_Name__c = accTest[0].Account_Number__c;
                    
                    recOrderLines.add(recOrderLine);
                }
            }
            
        }
        
        insert recOrderLines;
        
        List<SCMC__Received_Order_Line__c> recOrderLinesNew = [SELECT Id, Gym_Name__c FROM SCMC__Received_Order_Line__c];
        test.startTest();
        
        for(SCMC__Received_Order_Line__c line : recOrderLinesNew)
        {
            line.Gym_Name__c = accRebel[0].Account_Number__c;
        }
        
        update recOrderLinesNew;
        
        List<SCMC__Received_Order__c> recOrdersUpdated = [SELECT Id, SCMC__Account_Name__c, SCMC__Order_Date__c, Related_Account__c, Gym_Name__c FROM SCMC__Received_Order__c ];
        
        
        for(SCMC__Received_Order__c rec : recOrdersUpdated)
        {
            if(rec.SCMC__Order_Date__c != null && rec.SCMC__Order_Date__c > refDate && rec.SCMC__Account_Name__c == 'Rebel Cheer Wholesale' )
            {
                System.assertEquals(accRebel[0].id, rec.Related_Account__c);
                System.assertEquals(accRebel[0].Account_Number__c, rec.Gym_Name__c);
            }
        }
        test.stopTest();
    }
    
    @isTest
    Static void test_UpdateForOrder_BlankAccNum()
    {
        Datetime refDate = DateTime.newInstance(2020, 4, 24);
        List<Account> accTest = [SELECT Id, Name, Account_Number__c FROM Account WHERE Name = 'TestAcc' Limit 1];
        List<Account> accRebel = [SELECT Id, Name, Account_Number__c FROM Account WHERE Name = 'Rebel Cheer Wholesale' Limit 1];
        List<SCMC__Received_Order__c> recOrders = [SELECT Id, Name, SCMC__Account_Name__c, SCMC__Order_Date__c, Related_Account__c, Gym_Name__c  FROM SCMC__Received_Order__c ];
        
        List<SCMC__Received_Order_Line__c> recOrderLines = new List<SCMC__Received_Order_Line__c>();
        for(SCMC__Received_Order__c rec : recOrders)
        {		
            
            if(rec.SCMC__Order_Date__c != null && rec.SCMC__Order_Date__c > refDate && rec.SCMC__Account_Name__c == 'Rebel Cheer Wholesale' )
            {
                SCMC__Received_Order_Line__c recOrderLine = new SCMC__Received_Order_Line__c();
                System.Debug('hello');
                recOrderLine.SCMC__Received_Order__c = rec.Id;
                recOrderLine.Gym_Name__c = accTest[0].Account_Number__c;
                recOrderLines.add(recOrderLine);
                
                 rec.SCMC__Account_Name__c = null;
            }
        }
        System.assert(recOrderLines.size() > 0);
        insert recOrderLines;
        
        test.startTest();
        
        update recOrders;
        
        List<SCMC__Received_Order__c> recOrdersUpdated = [SELECT Id, SCMC__Account_Name__c, SCMC__Order_Date__c, Related_Account__c, Gym_Name__c FROM SCMC__Received_Order__c ];
        
        for(SCMC__Received_Order__c rec : recOrdersUpdated)
        {
            System.assertEquals(null, rec.Related_Account__c);
            System.assertEquals(null, rec.Gym_Name__c);
        }
        test.stopTest();
    }
    
    @isTest
    Static void test_UpdateForOrder_BlankDate()
    {
        Datetime refDate = DateTime.newInstance(2020, 4, 24);
        List<Account> accTest = [SELECT Id, Name, Account_Number__c FROM Account WHERE Name = 'TestAcc' Limit 1];
        List<Account> accRebel = [SELECT Id, Name, Account_Number__c FROM Account WHERE Name = 'Rebel Cheer Wholesale' Limit 1];
        List<SCMC__Received_Order__c> recOrders = [SELECT Id, Name, SCMC__Account_Name__c, SCMC__Order_Date__c, Related_Account__c, Gym_Name__c  FROM SCMC__Received_Order__c ];
        
        List<SCMC__Received_Order_Line__c> recOrderLines = new List<SCMC__Received_Order_Line__c>();
        for(SCMC__Received_Order__c rec : recOrders)
        {		
            
            if(rec.SCMC__Order_Date__c != null && rec.SCMC__Order_Date__c > refDate && rec.SCMC__Account_Name__c == 'Rebel Cheer Wholesale' )
                    {
                        SCMC__Received_Order_Line__c recOrderLine = new SCMC__Received_Order_Line__c();
                        recOrderLine.SCMC__Received_Order__c = rec.Id;
                        recOrderLine.Gym_Name__c = accTest[0].Account_Number__c;
						recOrderLines.add(recOrderLine);
                        
						rec.SCMC__Order_Date__c = null;
                    }
            
        }
        System.assert(recOrderLines.size() > 0);
        
        insert recOrderLines;
        
        test.startTest();
        
        update recOrders;
        List<SCMC__Received_Order__c> recOrdersUpdated = [SELECT Id, SCMC__Account_Name__c, SCMC__Order_Date__c, Related_Account__c, Gym_Name__c FROM SCMC__Received_Order__c ];
        
        
        for(SCMC__Received_Order__c rec : recOrdersUpdated)
        {
            System.assertEquals(null, rec.Related_Account__c);
            System.assertEquals(null, rec.Gym_Name__c);
        }
        test.stopTest();
    }
}