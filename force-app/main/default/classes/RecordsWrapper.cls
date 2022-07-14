public class RecordsWrapper 
{
    public List<SuccessfulRecordWrapper> successWrapper;
    public List<ErredRecordsWrapper> errorWrapper;
    public RecordsWrapper(List<SuccessfulRecordWrapper> successWrapper, List<ErredRecordsWrapper> errorWrapper)
    {
        this.successWrapper = successWrapper;
        this.errorWrapper = errorWrapper;
    }
    
    public class SuccessfulRecordWrapper
    {
        public Id communityUserId;
        public Id relatedContactId;
        public Integer indexCount;
        public SuccessfulRecordWrapper(Id relatedContactId, Id communityUserId, Integer indexCount)
        {
            this.relatedContactId = relatedContactId;
            this.communityUserId = communityUserId;
            this.indexCount = indexCount;
        }
    }
    
    public class ErredRecordsWrapper 
    {
        public string logMessage;
        public Id relatedContactId;
        public Integer indexCount;
        public ErredRecordsWrapper(string logMessage, Id relatedContactId, Integer indexCount) 
        {
            this.logMessage = logMessage;
            this.relatedContactId = relatedContactId;
            this.indexCount = indexCount;
        }
    }
}