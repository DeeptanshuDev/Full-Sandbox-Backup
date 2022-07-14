@IsTest
public with sharing class Test_LightningResponseEntity {

    @IsTest
    static void testSuccess() {
        LightningResponseEntity response = LightningResponseEntity.create().setSuccess(true);

        System.assert(response.isSuccess == true, 'response.isSuccess should be `true`, was: ' + response.isSuccess);
        System.assert(response.status == LightningResponseEntity.SUCCESS, 'response.status should be `' + LightningResponseEntity.SUCCESS +'`, was: ' + response.status);
    }

    @IsTest
    static void testShorthandSuccessWithBody() {
        Object body = 'body';
        LightningResponseEntity response = LightningResponseEntity.success(body);

        System.assert(response.isSuccess, 'Expected response success');
        System.assert(response.body.equals(body), 'Expected body to be `' + body + '`, was: ' + body);
    }

    @IsTest
    static void testShorthandSuccessWithMessage() {
        String message = 'message';
        LightningResponseEntity response = LightningResponseEntity.success(message);

        System.assert(response.isSuccess, 'Expected response success');
        System.assert(response.message.equals(message), 'Expected message to be `' + message + '`, was: ' + message);
    }

    @IsTest
    static void testShorthandSuccessWithBodyAndMessage() {
        String message = 'message';
        Object body = 'body';
        LightningResponseEntity response = LightningResponseEntity.success(body, message);

        System.assert(response.isSuccess, 'Expected response success');
        System.assert(response.message.equals(message), 'Expected message to be `' + message + '`, was: ' + message);
        System.assert(response.body.equals(body), 'Expected body to be `' + body + '`, was: ' + body);
    }

    @IsTest
    static void testError() {
        String errorMessage = 'Some error message';
        LightningResponseEntity response = LightningResponseEntity.create().setError(errorMessage);

        System.assert(response.isSuccess == false, 'response.isSuccess should be `false`, was: ' + response.isSuccess);
        System.assert(response.status == LightningResponseEntity.ERROR, 'response.status should be `' + LightningResponseEntity.ERROR +'`, was: ' + response.status);
        System.assert(response.message == errorMessage, 'response.message should be `' + errorMessage + '`, was: ' + response.message);
    }

    @IsTest
    static void testShorthandErrorWithBody() {
        Object body = 'body';
        LightningResponseEntity response = LightningResponseEntity.error(body);

        System.assert(!response.isSuccess, 'Expected response error');
        System.assert(response.body.equals(body), 'Expected body to be `' + body + '`, was: ' + body);
    }

    @IsTest
    static void testShorthandErrorWithMessage() {
        String message = 'message';
        LightningResponseEntity response = LightningResponseEntity.error(message);

        System.assert(!response.isSuccess, 'Expected response error');
        System.assert(response.message.equals(message), 'Expected message to be `' + message + '`, was: ' + message);
    }

    @IsTest
    static void testShorthandErrorWithBodyAndMessage() {
        String message = 'message';
        Object body = 'body';
        LightningResponseEntity response = LightningResponseEntity.error(body, message);

        System.assert(!response.isSuccess, 'Expected response error');
        System.assert(response.message.equals(message), 'Expected message to be `' + message + '`, was: ' + message);
        System.assert(response.body.equals(body), 'Expected body to be `' + body + '`, was: ' + body);
    }

    @IsTest
    static void testWarning() {
        String warningMessage = 'Some warning message';
        LightningResponseEntity response = LightningResponseEntity.create().setWarning(warningMessage);

        System.assert(response.isSuccess == true, 'response.isSuccess should be `true`, was: ' + response.isSuccess);
        System.assert(response.status == LightningResponseEntity.WARNING, 'response.status should be `' + LightningResponseEntity.WARNING +'`, was: ' + response.status);
        System.assert(response.message == warningMessage, 'response.message should be `' + warningMessage + '`, was: ' + response.message);
    }

    @IsTest
    static void testBody() {
        Map<String, String> body = new Map<String, String> {
                'key_1' => 'value_1',
                'key_2' => 'value_2'
        };

        String value1 = null;
        String value2 = null;
        LightningResponseEntity response = null;

        response = LightningResponseEntity.create().setBody(body);
        value1 = ((Map<String, String>)response.body).get('key_1');
        System.assert(value1 == 'value_1', 'Value for `key_1` should be `value_1`, was: ' + value1);

        response = LightningResponseEntity.create(body);
        value2 = ((Map<String, String>)response.body).get('key_2');
        System.assert(value2 == 'value_2', 'Value for `key_2` should be `value_2`, was: ' + value2);

    }
}