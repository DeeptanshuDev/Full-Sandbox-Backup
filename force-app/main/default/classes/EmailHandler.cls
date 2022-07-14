public class EmailHandler 
{
    public static void sendEmail(String toAddress, String subject, String body, String htmlBody) {
        createEmail(new list<string> { toAddress }, subject, body, htmlBody, true);
    }
    public static Messaging.SingleEmailMessage createEmail(list<string> toAddresses, String subject, String body, String htmlBody, boolean createAndSend) 
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        mail.setHtmlBody(htmlBody);
        if (createAndSend) Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return mail;
    }
}