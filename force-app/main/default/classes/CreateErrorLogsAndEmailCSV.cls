public class CreateErrorLogsAndEmailCSV {
    
    private static final String HTTP_START_DATE = 'startDate';
    
    public CreateErrorLogsAndEmailCSV() {
        
        Date todayDate = Date.today() - 1;
        String formatedTodayDate = todayDate.month() + '-' + todayDate.day() + '-' + todayDate.year();
        system.debug('formatedTodayDate: ' + formatedTodayDate);
        String accesstoken = '';
        if(!Test.isRunningTest()) {
            accesstoken = Constants.HTTP_BEARER + Constants.CHAR_SPACE + FF_GetAccessToken.getAccessToken();            
        }
        
        HttpCalloutService service;
        HttpRequest request;
        HTTPResponse response;
        service = new HTTPCalloutService('FF3_0_Create_Error_Logs');
        service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
        service.setURLParameter(HTTP_START_DATE, formatedTodayDate);
        
        request = service.getRequest();

        if(Test.isRunningTest()) {
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setHeader('Content-Type', 'text/json');
            response.setBody('[{"modified_at":"2021-09-28T18:13:39.144Z","order_size_id":"b2d0b51d-5870-49ce-9c1f-b01fd65a5279","created_at":"2021-09-28T18:13:39.144Z"}, {"modified_at":"2021-09-28T18:13:39.144Z","order_size_id":"b2d0b51d-5870-49ce-9c1f-b01fd65a5279","created_at":"2021-09-28T18:13:39.144Z"}]');
            
        } else {
            response = service.sendRequest(request);
        }
        
        if(response != null && response.getStatusCode() == 200 && String.isNotBlank(response.getBody())) {
            //System.debug('ResponseBody: ' + response.getBody());
            
            createCSVData(response.getBody());
            
            /*List<Object> entryList = (List<Object>) JSON.deserializeUntyped(response.getBody());
            if(entryList != null && entryList.size() > 0) {
                createCSVData(entryList);
            }*/
        }
    }
    
    @future
    public static void createCSVData(String ResponseBody) {
        List<Object> entryList = (List<Object>) JSON.deserializeUntyped(ResponseBody);
        
        if(entryList != null && entryList.size() > 0) {
            List<Map<String, Object>> mapList = new List<Map<String, Object>>();
            Set<String> keySet = new Set<String>();
            
            for (Object entry : entryList) {
                Map<String, Object> m = (Map<String, Object>)(entry);
                keySet.addAll(m.keySet());
                for(String key : keySet) {
                    //System.debug(key + ': ' + m.get(key));
                    if(m.get(key) != null) {
                        String newValue = ((String)m.get(key)).replace(',',';');
                        m.put(key, newValue);
                    }
                    //System.debug(key + 'New: ' + m.get(key));
                }
                mapList.add(m);
                //System.debug('maplist: ' + mapList);
            }
            
            List<String> keys = new List<String>(keySet);
            keys.sort();
            
            List<List<String>> csvLines = new List<List<String>>();
            
            for (Integer i = 0; i <= mapList.size(); i++) {
                csvLines.add(new List<String>());
            }
            
            for (String key : keys) {
                csvLines.get(0).add('"' + key + '"');
                
                for (Integer i = 1; i <= mapList.size(); i++) {
                    csvLines.get(i).add('"' + (String)(mapList.get(i - 1).get(key)) + '"');
                }
            }
            
            String csvFile = createCSVFile(csvLines);
            
            if(String.isNotBlank(csvFile)) {
                //System.debug('csvFileString: ');
                sendCSVEmail(csvFile);
            }
        }
		        
    }
    
    public static String createCSVFile(List<List<String>> csvLines) {
        String csvFile = '';
        for (List<String> csvLine : csvLines) {
            String line = '';
            for (Integer i = 0; i < csvLine.size() - 1; i++) {
                line += csvLine.get(i) + ',';
            }
            line += csvLine.get(csvLine.size() - 1);
            csvFile += line + '\n';
        }
        return csvFile;
    }
    
    public static void sendCSVEmail(String csvFileString) {
        
        Date todayDate = Date.today();
        String formatedTodayDate = todayDate.month() + '-' + todayDate.day() + '-' + todayDate.year();
        String csvName = 'ErrorLog_' + formatedTodayDate + '.csv';
        
        List<Messaging.EmailFileAttachment> csvAttachmentList = new List<Messaging.EmailFileAttachment>();
        Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        Blob csvBlob = blob.valueOf(csvFileString);
        csvAttachment.setFileName(csvName);
        csvAttachment.setBody(csvBlob);
        csvAttachmentList.add(csvAttachment);
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> toAddresses = getEmailAddressesFromPublicFroup();
        /*List<String> toAddresses = new List<String>();
        String emailAddress = 'shubham.sharma@fexle.com';
        toAddresses.add(emailAddress);*/
        system.debug('toAddresses: ' + toAddresses);
        String subject = csvName;
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody('Hi Team, <br> <br> Please find the attached Error log file for Fit Freedom. <br> <br> Thanks');
        email.setFileAttachments(csvAttachmentList);
        emails.add(email);
        
        Messaging.SendEmailResult[] r = Messaging.sendEmail(emails);
        //system.debug('SendEmailResult: ' + r);
    }
    
    private static List<String> getEmailAddressesFromPublicFroup() {
        
        List<String> idList = new List<String>();
        List<String> mailToAddresses = new List<String>();
        List<Group> gr = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE DeveloperName = 'Error_Log_Receivers'];
        
        if(gr != null && gr.size() > 0) {
            Group g = gr[0];
            for (GroupMember gm : g.groupMembers) {
                idList.add(gm.userOrGroupId);
            }
            
            User[] usr = [SELECT email FROM user WHERE id IN :idList];
            
            for(User u : usr) {
                mailToAddresses.add(u.email);
            }
        }
        return mailToAddresses;
    }
}