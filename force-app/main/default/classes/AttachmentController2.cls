public class AttachmentController2 {
    
    public transient String base64;
    public transient List<String>fileDetails;
    public Opportunity c;
    Id recordId;
    Integer i = 0;
    public String soDescription { get; set; }
    public String soPromoCode { get; set; }
    public Integer fileLen {get; set;}
    public String getBase64()
    {
        return base64;
    }
    public void setbase64(String base64)
    {
        this.base64 = base64;
    }
    public String fileName {get; set;}
    public AttachmentController2(ApexPages.StandardController std)
    {
        c = (Opportunity)std.getRecord();
        Opportunity opp = [SELECT Id, Name, Promo_Code__c FROM Opportunity WHERE Id =: c.Id];
        soPromoCode = opp.Promo_Code__c;
    }
    public void saveFiles()
    {
        system.debug('fileDetails'+ fileDetails);
         system.debug('fileName[0]'+ fileName);
         system.debug('fileLen[0]'+ fileLen);
         system.debug('base64[0]'+ base64);
       
        Attachment a = new Attachment(parentId = c.Id, Body =  EncodingUtil.base64Decode(base64), name = fileName);
        insert a;
        i++;
    }
    public PageReference  saveMethod()
    {
        if(c.Id != NULL)
        {
            
            Opportunity opp = [SELECT Id,SO_De__c,SO_Needed__c FROM Opportunity WHERE Id =: c.Id];
            
            opp.SO_De__c = soDescription;
            opp.Promo_Code__c = soPromoCode;
            opp.SO_Needed__c = true;
            update opp;
            
        }
        
       	
        if(i>0)
        {
            postChatter(c.Id, i);
        }
        else
        {
         	postChatter(c.Id, 0);   
        }
        PageReference reRend = new PageReference('/' + c.Id );
        reRend.setRedirect(true);
        return reRend;
    }
    
    public pagereference redirect(){
        
        PageReference reRend = new PageReference('/' + c.Id );
        reRend.setRedirect(true);
        return reRend;
    }
    
    @AuraEnabled
    public static void updateDescription(ID recId, String texts, String text2)
    {

        Opportunity opp = [SELECT Id,SO_De__c,SO_Needed__c,Promo_Code__c FROM Opportunity WHERE Id =: recId];
        opp.SO_De__c = texts;
        opp.Promo_Code__c = text2;
        opp.SO_Needed__c = true;
        update opp;
            
        
    } 
      @AuraEnabled 
      public static void postChatter(String oppId, Integer fileCount){
          
          System.debug('file count is : ' + fileCount);
          List<Opportunity> opp = [SELECT Id,SO_De__c FROM Opportunity where Id =: oppId];
          system.debug('opp[0].SO_De__c--'+opp[0].SO_De__c);
          FeedItem post = new FeedItem();
          post.ParentId = oppId; //eg. Opportunity id, custom object id..
          if(opp[0].SO_De__c != NULL)
          {
              post.Body = opp[0].SO_De__c +'\n'+fileCount + ' attachment(s) has been added.';
              insert post;
          }
          else
          {
              post.Body = fileCount + ' attachment(s) has been added.';
              insert post; 
          }                   
      }
    
    @AuraEnabled
    public static List<String> getPromoCode(ID recId){
        List<String> countries = new List<String>();
		Opportunity opp = [SELECT Id,SO_De__c,SO_Needed__c,Promo_Code__c FROM Opportunity WHERE Id =: recId];
		countries.add(opp.Promo_Code__c);        
        return countries;
    }
    
    
     
    
}