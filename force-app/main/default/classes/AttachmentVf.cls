public class AttachmentVf {
    public static Id oppIdPage {get;set;}
    public AttachmentVf(ApexPages.StandardController controller) {
        oppIdPage = controller.getId();
    }
    public Attachment myfile;
   

}