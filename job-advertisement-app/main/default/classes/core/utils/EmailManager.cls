public class EmailManager {
    
    public static void sendMail(EmailAddress addresses, String subject, String body) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
        mail.setToAddresses(addresses.to);
        mail.setCcAddresses(addresses.cc);
        mail.setCcAddresses(addresses.bcc);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(
            new Messaging.SingleEmailMessage[] { mail });       
        inspectResults(results);
    }
    
    private static void inspectResults(Messaging.SendEmailResult[] results) {
        for (Messaging.SendEmailResult result : results) {
            if (!result.isSuccess()) {
                  System.debug('Email sending errors: ' + result.getErrors()); 
            }
        }       
    }
    
    public class EmailAddress {       
        public List<String> to {get;set;}
        public List<String> cc{get;set;}
        public List<String> bcc{get;set;}      
        public EmailAddress(){
            to = new List<String>();
            cc = new List<String>();
            bcc = new List<String>();
        }       
    }
}
