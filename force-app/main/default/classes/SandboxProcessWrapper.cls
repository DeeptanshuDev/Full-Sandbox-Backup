/*
Purpose         :   Wrapper class for Create Sandbox Request Wrapper

Created By      :   Abhinav Sharma

Created Date    :   02/21/2020

Current Version :   v1.0

Revision Log    :   V_1.0 Created
*/
public class SandboxProcessWrapper
{
    public Integer size {get;set;} 
    public Integer totalSize {get;set;} 
    public Boolean done {get;set;} 
    public Object queryLocator {get;set;} 
    public String entityTypeName {get;set;} 
    public List<Records> records {get;set;}
    
    public class Attributes 
    {
        public String type_Z {get;set;} // in json: type
        public String url {get;set;} 
    }
    public class Records 
    {
        public Attributes attributes {get;set;} 
        public String Id {get;set;} 
        public String SandboxName {get;set;} 
        public String SandboxOrganization {get;set;} 
        public String Status {get;set;}
        public String SandboxInfoId {get;set;}
    }
}