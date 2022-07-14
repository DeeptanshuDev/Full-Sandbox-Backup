/*
	Description  : Lightning Response Entity controller class
	Created By   : Abhinav Sharma
*/
public with sharing class LightningResponseEntity {
    
    public static final String SUCCESS = 'success';
    public static final String WARNING = 'warning';
    public static final String ERROR = 'error';
    
    @AuraEnabled public String status;
    @AuraEnabled public Boolean isSuccess;
    @AuraEnabled public String message;
    @AuraEnabled public Object body;
    
    public LightningResponseEntity() {
        this.status = SUCCESS;
        this.isSuccess = true;
    }
    
    public static LightningResponseEntity create() {
        return new LightningResponseEntity();
    }
    
    public static LightningResponseEntity create(Object body) {
        return LightningResponseEntity.create().setBody(body);
    }
    
    public LightningResponseEntity setSuccess(Boolean isSuccess) {
        this.status = isSuccess ? SUCCESS : ERROR;
        this.isSuccess = isSuccess;
        return this;
    }
    
    public LightningResponseEntity setError(String errorMessage) {
        this.status = ERROR;
        this.isSuccess = false;
        return this.setMessage(errorMessage);
    }
    
    public LightningResponseEntity setWarning(String warningMessage) {
        this.status = WARNING;
        return this.setMessage(warningMessage);
    }
    
    public LightningResponseEntity setMessage(String message) {
        this.message = message;
        return this;
    }
    
    public LightningResponseEntity setBody(Object body) {
        this.body = body;
        return this;
    }
    
    public static LightningResponseEntity success(Object body) {
        return LightningResponseEntity.create(body);
    }
    
    public static LightningResponseEntity success(String successMessage) {
        return LightningResponseEntity.create().setMessage(successMessage);
    }
    
    public static LightningResponseEntity success(Object body, String successMessage) {
        return LightningResponseEntity.create(body).setMessage(successMessage);
    }
    
    public static LightningResponseEntity error(Object body) {
        return LightningResponseEntity.create(body).setSuccess(false);
    }
    
    public static LightningResponseEntity error(String errorMessage) {
        return LightningResponseEntity.create().setError(errorMessage);
    }
    
    public static LightningResponseEntity error(Object body, String errorMessage) {
        return LightningResponseEntity.create(body).setError(errorMessage);
    }
    
}