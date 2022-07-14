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