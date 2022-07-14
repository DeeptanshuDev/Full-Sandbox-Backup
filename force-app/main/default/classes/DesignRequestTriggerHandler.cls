public class DesignRequestTriggerHandler {
    
  public void afterUpdate(List<Design_Request__c> newRequests,
    Map<Id, Design_Request__c> oldRequestsMap) {
    CustomItemStatus status = new CustomItemStatus();
    status.setCustomItemStatusFromDesignRequest(newRequests, oldRequestsMap);
  }
    
    /* Added by: Daven Tsai
     * Date 05/11/2022
    */
    public void beforeInsert(List<Design_Request__c> newRequests){
        //Gets set of oppIds for the DRs triggering this
        Set<Id> oppIDList = new Set<Id>();
        for (Design_Request__c req:newRequests){
            if (req.Opportunity__c != null){
                oppIDList.add(req.Opportunity__c);
            }
        }
        //Compares DRs to see if they have the oppIds already assigned. If they do, adds onto the drList
        List <Design_Request__c> drList = [SELECT Id, Opportunity__c FROM Design_Request__c WHERE Design_Request__c.Opportunity__c IN :oppIDList];
        for (Design_Request__c req:newRequests){
            //Checks drList and counts the number of times opps are being used for a DR already. If it's being used already, produces an error.
            Integer count = 0;
            for (Integer i=0; i<drList.size();i++){
                if (req.Opportunity__c == drList[i].Opportunity__c){
                    count++;
                }
            }
            if (count>0){
                req.AddError(System.Label.Restrict_Multiple_DR);
            }
        }
    }
    
    /**
    *
    * @description : sending approval request based on design request field value for update case.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/02/2022 - Deeptanshu Bharti
    *
    **/
    public static void sendingApprovalBasedonDR(List<Design_Request__c> newDR, Map<Id, Design_Request__c> oldMap)
    {
        Integer count = 0;
        List<String> listOfString = new List<String>();
        if(!newDR.isEmpty())
        {
            for(Design_Request__c dr : newDR){
                if(dr.High_Priority_DR__c != NULL)
                {
                    if((dr.High_Priority_DR__c != oldMap.get(dr.Id).High_Priority_DR__c) &&(dr.High_Priority_DR__c == True))
                    {
                        count++;
                        listOfString.add('High Priority DR');
                    }
                }
                
                if(dr.Special_Pricing_DR__c != NULL)
                {
                    if((dr.Special_Pricing_DR__c != oldMap.get(dr.Id).Special_Pricing_DR__c) &&(dr.Special_Pricing_DR__c == True))
                    {
                        count++;
                        listOfString.add('Special Pricing DR');
                    }
                }
                
                if(dr.Special_Ops_DR__c != NULL)
                {
                    if((dr.Special_Ops_DR__c != oldMap.get(dr.Id).Special_Ops_DR__c) &&(dr.Special_Ops_DR__c == True))
                    {
                        count++;
                        listOfString.add('Special Ops DR');
                    }
                }
                
                if(dr.Live_Design_DR__c != NULL)
                {
                    if((dr.Live_Design_DR__c != oldMap.get(dr.Id).Live_Design_DR__c) &&(dr.Live_Design_DR__c == True))
                    {
                        count++;
                        listOfString.add('Live Design DR');
                    }
                }
                
                if(dr.Reveal_Worthy_Design__c != NULL)
                {
                    if((dr.Reveal_Worthy_Design__c != oldMap.get(dr.Id).Reveal_Worthy_Design__c) &&(dr.Reveal_Worthy_Design__c == True))
                    {
                        count++;
                        listOfString.add('Reveal Worthy Design');
                    }
                }
                
                
                if(count>1)
                {
                    fieldUpdateMethod(dr,listOfString);
                    Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                    req2.setComments('Submitting request for '+listOfString+' DR approval.');
                    req2.setObjectId(dr.id);
                    req2.setNextApproverIds(new List<Id>{dr.OwnerId});
                    req2.setProcessDefinitionNameOrId('Multiple_Approval_DR');
                    req2.setSkipEntryCriteria(true);
                    Approval.ProcessResult result = Approval.process(req2);
                    count = 0;
                    sendMail(dr,listOfString);
                }
                else
                {
                     if((dr.High_Priority_DR__c != oldMap.get(dr.Id).High_Priority_DR__c) &&(dr.High_Priority_DR__c == True))
                     {
                         Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                         req1.setComments('Submitting request for High Priority DR approval.');
                         req1.setObjectId(dr.id);
                         req1.setNextApproverIds(new List<Id>{dr.OwnerId});
                         req1.setProcessDefinitionNameOrId('High_Priority_Approval_DR');
                         req1.setSkipEntryCriteria(true);
                         Approval.ProcessResult result = Approval.process(req1);
                         
                     }
                    
                    else if((dr.Special_Pricing_DR__c != oldMap.get(dr.Id).Special_Pricing_DR__c) &&(dr.Special_Pricing_DR__c == True))
                    {
                        Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                        req2.setComments('Submitting request for Special Pricing DR approval.');
                        req2.setObjectId(dr.id);
                        req2.setNextApproverIds(new List<Id>{dr.OwnerId});
                        req2.setProcessDefinitionNameOrId('Special_Pricing_Approval_DR');
                        req2.setSkipEntryCriteria(true);
                        Approval.ProcessResult result = Approval.process(req2);
                    }
                    
                    else if((dr.Special_Ops_DR__c != oldMap.get(dr.Id).Special_Ops_DR__c) &&(dr.Special_Ops_DR__c == True))
                    {
                        Approval.ProcessSubmitRequest req3 = new Approval.ProcessSubmitRequest();
                        req3.setComments('Submitting request for Special Ops DR approval.');
                        req3.setObjectId(dr.id);
                        req3.setNextApproverIds(new List<Id>{dr.OwnerId});
                        req3.setProcessDefinitionNameOrId('Special_Ops_Approval_for_DR');
                        req3.setSkipEntryCriteria(true);
                        Approval.ProcessResult result = Approval.process(req3);
                    }
                    
                    else if((dr.Live_Design_DR__c != oldMap.get(dr.Id).Live_Design_DR__c) &&(dr.Live_Design_DR__c == True))
                    {
                        Approval.ProcessSubmitRequest req3 = new Approval.ProcessSubmitRequest();
                        req3.setComments('Submitting request for Live Design DR approval.');
                        req3.setObjectId(dr.id);
                        req3.setNextApproverIds(new List<Id>{dr.OwnerId});
                        req3.setProcessDefinitionNameOrId('Live_Design_Approval_for_DR');
                        req3.setSkipEntryCriteria(true);
                        Approval.ProcessResult result = Approval.process(req3);
                    }
                    
                    else if((dr.Reveal_Worthy_Design__c != oldMap.get(dr.Id).Reveal_Worthy_Design__c) &&(dr.Reveal_Worthy_Design__c == True))
                    {
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments('Submitting request for Reveal Worthy Design approval.');
                        req1.setObjectId(dr.id);
                        req1.setNextApproverIds(new List<Id>{dr.OwnerId});
                        req1.setProcessDefinitionNameOrId('Reveal_Worthy_Design');
                        req1.setSkipEntryCriteria(true);
                        Approval.ProcessResult result = Approval.process(req1);
                    }
                    
                }
            }
        }
    }
    
    /**
    *
    * @description : sending approval request based on design request field value for insert case.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/02/2022 - Deeptanshu Bharti
    *
    **/
    public static void sendingApprovalBasedonDR2(List<Design_Request__c> newDR, Map<Id, Design_Request__c> oldMap)
    {
        Integer cou = 0;
        List<String> listOfString = new List<String>();
        if(!newDR.isEmpty())
        {
            for(Design_Request__c dr : newDR){
                if(dr.High_Priority_DR__c != NULL)
                {
                    if(dr.High_Priority_DR__c == True)
                    {
                        cou++;
                        listOfString.add('High Priority DR');
                    }
                }
                
                if(dr.Special_Pricing_DR__c != NULL)
                {
                    if(dr.Special_Pricing_DR__c == True)
                    {
                        cou++;
                        listOfString.add('Special Pricing DR');
                    }
                }
                
                if(dr.Special_Ops_DR__c != NULL)
                {
                    if(dr.Special_Ops_DR__c == True)
                    {
                        cou++;
                        listOfString.add('Special Ops DR');
                    }
                }
                
                if(dr.Live_Design_DR__c != NULL)
                {
                    if(dr.Live_Design_DR__c == True)
                    {
                        cou++;
                        listOfString.add('Live Design DR');
                    }
                }
                
                if(dr.Reveal_Worthy_Design__c != NULL)
                {
                    if(dr.Reveal_Worthy_Design__c == True)
                    {
                        cou++;
                        listOfString.add('Reveal Worthy Design');
                    }
                }
                
                if(cou>1)
                {
                    fieldUpdateMethod(dr,listOfString);
                    Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                    req2.setComments('Submitting request for '+listOfString+' DR approval.');
                    req2.setObjectId(dr.id);
                    req2.setNextApproverIds(new List<Id>{dr.OwnerId});
                    req2.setProcessDefinitionNameOrId('Multiple_Approval_DR');
                    req2.setSkipEntryCriteria(true);
                    Approval.ProcessResult result = Approval.process(req2);
                    cou = 0;
                    sendMail(dr,listOfString);
                }
                else
                {
                    if(dr.High_Priority_DR__c == True) 
                    {
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments('Submitting request for High Priority DR approval.');
                        req1.setObjectId(dr.id);
                        req1.setNextApproverIds(new List<Id>{dr.OwnerId});
                        req1.setProcessDefinitionNameOrId('High_Priority_Approval_DR');
                        req1.setSkipEntryCriteria(true);
                        Approval.ProcessResult result = Approval.process(req1);
                        System.debug('the value of ');
                    }
                    
                    else if(dr.Special_Pricing_DR__c == True)
                    {
                        Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                        req2.setComments('Submitting request for Special Pricing DR approval.');
                        req2.setObjectId(dr.id);
                        req2.setNextApproverIds(new List<Id>{dr.OwnerId});
                        req2.setProcessDefinitionNameOrId('Special_Pricing_Approval_DR');
                        req2.setSkipEntryCriteria(true);
                        Approval.ProcessResult result = Approval.process(req2);
                    }
                    
                    else if(dr.Special_Ops_DR__c == True)
                    {
                        Approval.ProcessSubmitRequest req3 = new Approval.ProcessSubmitRequest();
                        req3.setComments('Submitting request for Special Ops DR approval.');
                        req3.setObjectId(dr.id);
                        req3.setNextApproverIds(new List<Id>{dr.OwnerId});
                        req3.setProcessDefinitionNameOrId('Special_Ops_Approval_for_DR');
                        req3.setSkipEntryCriteria(true);
                        Approval.ProcessResult result = Approval.process(req3);
                    }
                    
                    else if(dr.Live_Design_DR__c == True)
                    {
                        Approval.ProcessSubmitRequest req3 = new Approval.ProcessSubmitRequest();
                        req3.setComments('Submitting request for Live Design DR approval.');
                        req3.setObjectId(dr.id);
                        req3.setNextApproverIds(new List<Id>{dr.OwnerId});
                        req3.setProcessDefinitionNameOrId('Live_Design_Approval_for_DR');
                        req3.setSkipEntryCriteria(true);
                        Approval.ProcessResult result = Approval.process(req3);
                    }
                    
                    else if(dr.Reveal_Worthy_Design__c == True)
                    {
                        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                        req1.setComments('Submitting request for Reveal Worthy Design approval.');
                        req1.setObjectId(dr.id);
                        req1.setNextApproverIds(new List<Id>{dr.OwnerId});
                        req1.setProcessDefinitionNameOrId('Reveal_Worthy_Design');
                        req1.setSkipEntryCriteria(true);
                        Approval.ProcessResult result = Approval.process(req1);
                    }
                }
                
                
                
            }
        }
    }
    
    /**
    *
    * @description : update field.
    *
    * @args : Design_Request__c dr, String str
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/02/2022 - Deeptanshu Bharti
    *
    **/
    public static void fieldUpdateMethod(Design_Request__c dr, List<String> str)
    { 
        List<Design_Request__c> listOfDR = new List<Design_Request__c>();
        Design_Request__c obj = [SELECT Id, High_Priority_Approval_DR__c, Special_Ops_DR_Approval__c, Special_Pricing_Approval_For_DR__c, Live_Design_DR_Approval__c FROM Design_Request__c WHERE Id =: dr.Id];
        if(str.contains('High Priority DR'))
        {
            obj.High_Priority_Approval_DR__c = 'Pending';
            
        }
        if(str.contains('Special Ops DR'))
        {
            obj.Special_Ops_DR_Approval__c = 'Pending';
            
        }
        if(str.contains('Special Pricing DR'))
        {
            obj.Special_Pricing_Approval_For_DR__c = 'Pending';
            
        }
        if(str.contains('Live Design DR'))
        {
            obj.Live_Design_DR_Approval__c = 'Pending';
            
        }
        if(str.contains('Reveal Worthy Design'))
        {
            obj.Reveal_Worthy_Approval__c = 'Pending';
            
        }
        listOfDR.add(obj);
        if(listOfDR.size()>0)
        {
            update listOfDR;
            //sendMail(dr,str);
        }
        
    }
    
    /**
    *
    * @description : update field.
    *
    * @args : List<Design_Request__c> newDR, Map<Id, Design_Request__c> oldMap
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/02/2022 - Deeptanshu Bharti
    *
    **/
    public static void updateApproveField(List<Design_Request__c> newDR, Map<Id, Design_Request__c> oldMap)
    {
        Integer c = 0;
        List<String> listOfString = new List<String>();
        for(Design_Request__c dr : newDR)
        {
            if((dr.Multiple_DR_Approval__c==True)&&(dr.High_Priority_Approval_DR__c == 'Pending') && (dr.High_Priority_DR__c ==True))
            {
                dr.High_Priority_Approval_DR__c = 'Approved';
                listOfString.add('High Priority');
                c++;
            }
            if((dr.Multiple_DR_Approval__c==True)&&(dr.Special_Ops_DR_Approval__c == 'Pending') && (dr.Special_Ops_DR__c ==True))
            {
                dr.Special_Ops_DR_Approval__c = 'Approved';
                listOfString.add('Special Ops');
                c++;
            }
            if((dr.Multiple_DR_Approval__c==True)&&(dr.Special_Pricing_Approval_For_DR__c == 'Pending') && (dr.Special_Pricing_DR__c ==True))
            {
                dr.Special_Pricing_Approval_For_DR__c = 'Approved';
                listOfString.add('Special Pricing');
                c++;
            }
            if((dr.Multiple_DR_Approval__c==True)&&(dr.Live_Design_DR_Approval__c == 'Pending') && (dr.Live_Design_DR__c ==True))
            {
                dr.Live_Design_DR_Approval__c = 'Approved';
                listOfString.add('Live Design');
                c++;
            }
            if((dr.Multiple_DR_Approval__c==True)&&(dr.Reveal_Worthy_Approval__c == 'Pending') && (dr.Reveal_Worthy_Design__c ==True))
            {
                dr.Reveal_Worthy_Approval__c = 'Approved';
                listOfString.add('Reveal Worthy Design');
                c++;
            }
            if(c>1)
            {
                sendApproveMail(newDR,listOfString);
            }
            
            dr.Multiple_DR_Approval__c = false;
        }

    }
    
    /**
    *
    * @description : update field on approval rejection for multiple dr.
    *
    * @args : List<Design_Request__c> newDR, Map<Id, Design_Request__c> oldMap
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/02/2022 - Deeptanshu Bharti
    *
    **/
    public static void updateRejectField(List<Design_Request__c> newDR, Map<Id, Design_Request__c> oldMap)
    {
        Integer c = 0;
        List<String> listOfString = new List<String>();
        for(Design_Request__c dr : newDR)
        {
            if((dr.Multiple_DR_Approval_Rejected__c==True)&&(dr.High_Priority_Approval_DR__c == 'Pending') && (dr.High_Priority_DR__c ==True))
            {
                
                dr.High_Priority_Approval_DR__c = 'Rejected';
                c++;
                listOfString.add('High Priority');
            }
            if((dr.Multiple_DR_Approval_Rejected__c==True)&&(dr.Special_Ops_DR_Approval__c == 'Pending') && (dr.Special_Ops_DR__c ==True))
            {
                dr.Special_Ops_DR_Approval__c = 'Rejected';
                c++;
                listOfString.add('Special Ops');
            }
            if((dr.Multiple_DR_Approval_Rejected__c==True)&&(dr.Special_Pricing_Approval_For_DR__c == 'Pending') && (dr.Special_Pricing_DR__c ==True))
            {
                dr.Special_Pricing_Approval_For_DR__c = 'Rejected';
                c++;
                listOfString.add('Special Pricing');
            }
            if((dr.Multiple_DR_Approval_Rejected__c==True)&&(dr.Live_Design_DR_Approval__c == 'Pending') && (dr.Live_Design_DR__c ==True))
            {
                dr.Live_Design_DR_Approval__c = 'Rejected';
                c++;
                listOfString.add('Live Design');
            }
            if((dr.Multiple_DR_Approval_Rejected__c==True)&&(dr.Reveal_Worthy_Approval__c == 'Pending') && (dr.Reveal_Worthy_Design__c ==True))
            {
                dr.Reveal_Worthy_Approval__c = 'Rejected';
                listOfString.add('Reveal Worthy Design');
                c++;
            }
            if(c>1)
            {
                sendRejectMail(newDR,listOfString);
            }
            dr.Multiple_DR_Approval_Rejected__c = false;
            
        }

    }
    
    
    /**
    *
    * @description : this method is used to send email.
    *
    * @args : Design_Request__c dr, List<String> listOfStr
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/02/2022 - Deeptanshu Bharti
    *
    **/
    public static void sendMail(Design_Request__c dr, List<String> listOfStr)
    {
        String sub = getSubject(listOfStr);
        sub = sub.remove(' DR');
        
        User ur = [SELECT Id, Name, Email FROM User WHERE Id =: dr.OwnerId];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Step 2: Set list of people who should get the email
        List<String> sendTo = new List<String>();
        sendTo.add(ur.Email);
        mail.setToAddresses(sendTo);
        
        // Step 3: Set who the email is sent from
        //mail.setReplyTo('sirdavid@bankofnigeria.com');
        //mail.setSenderDisplayName('Official Bank of Nigeria');
        
        /* (Optional) Set list of people who should be CC'ed
        List<String> ccTo = new List<String>();
        ccTo.add('deeptanshu.bharti@fexle.com');
        mail.setCcAddresses(ccTo);*/
        
        // Step 4. Set email contents - you can use variables!
        mail.setSubject('APPROVAL SENT: '+sub +' for '+dr.Name);
        
        
        String body = ' A request to access '+sub+' approval is made for an '+dr.Name +' under Account "'+ dr.Account_Name__c+'".<br><br> The Rebel Robot Team</body></html>';

        mail.setHtmlBody(body);
        
        // Step 5. Add your email to the master list
        mails.add(mail);
        
        Messaging.sendEmail(mails);

    }
    
    /**
    *
    * @description : this method is used to send email for multiple approved approval request.
    *
    * @args : List<Design_Request__c> listOfDr, List<String> listOfStr
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/02/2022 - Deeptanshu Bharti
    *
    **/
    public static void sendApproveMail(List<Design_Request__c> listOfDr, List<String> listOfStr)
    {
        String sub = getSubject(listOfStr);
        sub = sub.remove(' DR');
        
        for(Design_Request__c dr : listOfDr)
        {
            User ur = [SELECT Id, Name, Email FROM User WHERE Id =: dr.OwnerId];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            sendTo.add(ur.Email);
            mail.setToAddresses(sendTo);
            
            // Step 3: Set who the email is sent from
            //mail.setReplyTo('sirdavid@bankofnigeria.com');
            //mail.setSenderDisplayName('Official Bank of Nigeria');
            
            /* (Optional) Set list of people who should be CC'ed
            List<String> ccTo = new List<String>();
            ccTo.add('deeptanshu.bharti@fexle.com');
            mail.setCcAddresses(ccTo);*/
            
            // Step 4. Set email contents - you can use variables!
            mail.setSubject('APPROVED: '+sub +' for '+ dr.Name);
            
            String body = 'The following order has been approved for '+sub+': <br><br>'+dr.Name+'<br><br>Please click this Link '+URL.getCurrentRequestUrl().toExternalForm()+'</body></html>';
            
            mail.setHtmlBody(body);
            
            // Step 5. Add your email to the master list
            mails.add(mail);
            
            Messaging.sendEmail(mails);
        }

    }
    
    /**
    *
    * @description : this method is used to send email for multiple approved approval request.
    *
    * @args : List<Design_Request__c> listOfDr, List<String> listOfStr
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/02/2022 - Deeptanshu Bharti
    *
    **/
    public static void sendRejectMail(List<Design_Request__c> listOfDr, List<String> listOfStr)
    {
        String sub = getSubject(listOfStr);
        sub = sub.remove(' DR');
        for(Design_Request__c dr : listOfDr)
        {
            User ur = [SELECT Id, Name, Email FROM User WHERE Id =: dr.OwnerId];
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            sendTo.add(ur.Email);
            mail.setToAddresses(sendTo);
            
            // Step 3: Set who the email is sent from
            //mail.setReplyTo('sirdavid@bankofnigeria.com');
            //mail.setSenderDisplayName('Official Bank of Nigeria');
            
            /* (Optional) Set list of people who should be CC'ed
            List<String> ccTo = new List<String>();
            ccTo.add('deeptanshu.bharti@fexle.com');
            mail.setCcAddresses(ccTo);*/
            
            // Step 4. Set email contents - you can use variables!
            mail.setSubject('REJECTED: '+sub +' for '+ dr.Name);
            
            String body = '<html><body>Hi,<br><br>';
            body = body+'The following order has been denied for '+sub+': <br><br>'+dr.Name+'<br><br>Please click this Link '+URL.getCurrentRequestUrl().toExternalForm()+'</body></html>';
            
            mail.setHtmlBody(body);
            
            // Step 5. Add your email to the master list
            mails.add(mail);
            
            Messaging.sendEmail(mails);
        }

    }
    
    /**
    *
    * @description : this method is used to style subject for multiple approved mail.
    *
    * @args : List<String> listOfStr
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 06/02/2022 - Deeptanshu Bharti
    *
    **/
	public static String getSubject(List<String> listOfStr)
    {
        integer len = listOfStr.size();
        String sub;
        for(integer i = 0;i<len;i++)
        {
            if(i==0)
            {
                sub = listOfStr[i];
            }
            else
            {
                if(len>2)
                {
                    if(i==len-1)
                    {
                        sub = sub+' and '+listOfStr[i];
                    }
                    else
                    {
                        sub = sub+', '+listOfStr[i];
                    }
                }
                else
                {
                    sub = sub+' and '+listOfStr[i];
                }
            }
        }
        sub = sub.remove(' DR');
        sub = sub+' DR';
        
        return sub;
    }
    
    
}