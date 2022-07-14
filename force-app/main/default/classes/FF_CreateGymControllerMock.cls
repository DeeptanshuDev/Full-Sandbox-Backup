@isTest
global class FF_CreateGymControllerMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"modified_at": "2020-05-28T07:23:39.116Z","gym_id": "b73a1842-9d97-4e9b-9bff-6a1bea35528b","active": true,"created_at": "2020-05-28T07:23:39.116Z","owner_name": "Test Contact","owner": "0d9d09b3-cb73-48f0-9b1f-8fd17fb5f335","location": "Atlanta","gym_type": "All Star","gym_name": "Successful Test","createdAt": "2020-05-28T07:23:39.116Z","team_id": "2cd976ee-a399-4932-b169-a162c4df607c"}');
        response.setStatusCode(200);
        return response; 
    }
}