@isTest
public class CustomItemRepricingTest {
	
    public static String CRON_EXP = '0 0 0 20 09 ? 2022';
    
    static testMethod Void testScheduledJob(){
        
        Opportunity opp = new Opportunity(Category__c='All Star', Collection__c='Couture',Uniform_Style__c='Set',Prototype_Status__c='Proto',CloseDate=Date.newInstance(2022,11,01) ,StageName='Open',Name='Test');
        insert opp;
        
        List<Custom_Item__c> cItemList = new List<Custom_Item__c>();
        //PW Test1
        Custom_Item__c pw1 = new Custom_Item__c(Category__c='School',Product_Style__c = 'Practicewear',Collection__c='N/A',Style_Category__c='Tops',
                                              Style_Subcategory__c='Bra',Style__c='P101 Sports Bra',Product_Style_Subcategory__c='N/A',Quantity__c=1,Stated_Quantity__c=1,
                                              Price_per_item__c=10,Price__c=10,Pricing_Expiration_Date__c=Date.newInstance(2022, 4, 27),Opportunity__c=opp.id,Category_Subtype__c='School Cheer');
        cItemList.add(pw1);
        //PW Test2
        Custom_Item__c pw2 = new Custom_Item__c(Category__c='School',Product_Style__c = 'Practicewear',Collection__c='N/A',Style_Category__c='Tops',
                                              Style_Subcategory__c='Bra',Style__c='P101 Sports Bra',Product_Style_Subcategory__c='N/A',Quantity__c=1,Stated_Quantity__c=1,
                                              Price_per_item__c=60,Price__c=40,Pricing_Expiration_Date__c=Date.newInstance(2022, 4, 27),Opportunity__c=opp.id,Category_Subtype__c='School Cheer',
                                               Type_of_Discount_CI__c='Early Bird');
        cItemList.add(pw2);
         //PW Test3
        Custom_Item__c pw3 = new Custom_Item__c(Category__c='School',Product_Style__c = 'Practicewear',Collection__c='N/A',Style_Category__c='Tops',
                                              Style_Subcategory__c='Bra',Style__c='P101 Sports Bra',Product_Style_Subcategory__c='N/A',Quantity__c=1,Stated_Quantity__c=1,
                                              Price_per_item__c=50,Price__c=0,Pricing_Expiration_Date__c=Date.newInstance(2022, 4, 27),Opportunity__c=opp.id,Category_Subtype__c='School Cheer',
                                               Type_of_Discount_CI__c='Sponsorship');
        cItemList.add(pw3);
        //PW Test4
        Custom_Item__c pw4 = new Custom_Item__c(Category__c='School',Product_Style__c = 'Practicewear',Collection__c='N/A',Style_Category__c='Tops',
                                              Style_Subcategory__c='Bra',Style__c='P101 Sports Bra',Product_Style_Subcategory__c='N/A',Quantity__c=1,Stated_Quantity__c=1,
                                              Price_per_item__c=60,Price__c=60,Pricing_Expiration_Date__c=Date.newInstance(2022, 4, 27),Opportunity__c=opp.id,Category_Subtype__c='School Cheer',
                                               Type_of_Discount_CI__c='Early Bird');
        cItemList.add(pw4);
        //PW Test5
        Custom_Item__c pw5 = new Custom_Item__c(Category__c='School',Product_Style__c = 'Practicewear',Collection__c='N/A',Style_Category__c='Tops',
                                              Style_Subcategory__c='Bra',Style__c='P101 Sports Bra',Product_Style_Subcategory__c='N/A',Quantity__c=1,Stated_Quantity__c=1,
                                              Price_per_item__c=33,Price__c=9,Pricing_Expiration_Date__c=Date.newInstance(2022, 4, 27),Opportunity__c=opp.id,Category_Subtype__c='School Cheer',
                                               Type_of_Discount_CI__c='Sponsorship', DI_Early_Bird_Price__c =20);
        cItemList.add(pw5);
        //PW Test6
        Custom_Item__c pw6 = new Custom_Item__c(Category__c='School',Product_Style__c = 'Practicewear',Collection__c='N/A',Style_Category__c='Tops',
                                              Style_Subcategory__c='Bra',Style__c='P101 Sports Bra',Product_Style_Subcategory__c='N/A',Quantity__c=1,Stated_Quantity__c=1,
                                              Price_per_item__c=20,Price__c=0,Pricing_Expiration_Date__c=Date.newInstance(2022, 4, 27),Opportunity__c=opp.id,Category_Subtype__c='School Cheer',
                                               Type_of_Discount_CI__c='Sponsorship');
        //PW Test7
        Custom_Item__c pw7 = new Custom_Item__c(Category__c='School',Product_Style__c = 'Practicewear',Collection__c='N/A',Style_Category__c='Tops',
                                              Style_Subcategory__c='Bra',Style__c='P101 Sports Bra',Product_Style_Subcategory__c='N/A',Quantity__c=1,Stated_Quantity__c=1,
                                              Price_per_item__c=30,Price__c=11,Pricing_Expiration_Date__c=Date.newInstance(2022, 4, 27),Opportunity__c=opp.id,Category_Subtype__c='School Cheer',
                                              Type_of_Discount_CI__c='Sponsorship');
        cItemList.add(pw7);
        //UN Test
        Custom_Item__c un = new Custom_Item__c(Category__c='School',Product_Style__c = 'Uniform',Collection__c='Poly',Style_Category__c='Tops',
                                              Style_Subcategory__c='Crop Top',Style__c='U102 - Girls Crop Top',Quantity__c=1,Stated_Quantity__c=1,
                                              Price_per_item__c=100,Price__c=100,Pricing_Expiration_Date__c=Date.newInstance(2022, 4, 27),Opportunity__c=opp.id,Category_Subtype__c='School Cheer');
        cItemList.add(un);
        //Special Test
        Custom_Item__c sp = new Custom_Item__c(Category__c='School',Product_Style__c = 'Uniform',Collection__c='Poly',Style_Category__c='Tops',
                                              Style_Subcategory__c='Crop Top',Style__c='U102 - Girls Crop Top',Quantity__c=1,Stated_Quantity__c=1,
                                              Price_per_item__c=100,Price__c=71,Pricing_Expiration_Date__c=Date.newInstance(2022, 4, 27),Opportunity__c=opp.id,Category_Subtype__c='School Cheer',
                                              Type_of_Discount_CI__c='Wholesale Special');
        cItemList.add(sp);
        //Volume Test
        Custom_Item__c vol = new Custom_Item__c(Category__c='School',Product_Style__c = 'Uniform',Collection__c='Poly',Style_Category__c='Tops',
                                              Style_Subcategory__c='Crop Top',Style__c='U102 - Girls Crop Top',Quantity__c=1,Stated_Quantity__c=1,
                                              Price_per_item__c=200,Price__c=156,Pricing_Expiration_Date__c=Date.newInstance(2022, 4, 27),Opportunity__c=opp.id,Category_Subtype__c='School Cheer',
                                              Type_of_Discount_CI__c='Wholesale Volume');
        cItemList.add(vol);
        
        
        
        insert cItemList;
        
        cItemList[1].Price__c = 40;
        cItemList[6].Price__c = 11;
        update cItemList;
        
        //Retrieve IDs created
        Map<Id,Custom_Item__c> cMap = new Map<Id, Custom_Item__c>(cItemList);
        List<Id> cIds = new List<Id>(cMap.keySet());
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new RepricingScheduler());
        Test.stopTest();
    }
    
}