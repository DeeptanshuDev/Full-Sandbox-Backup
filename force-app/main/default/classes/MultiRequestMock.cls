@isTest
public class MultiRequestMock implements HttpCalloutMock {
    Map<String, HttpCalloutMock> requests;

    public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
        /*System.debug('MultiRequestMock controller');
        System.debug(requests);
        System.debug('MultiRequestMock controller Ends');*/
    }

    public HTTPResponse respond(HTTPRequest req) {
      
        HttpCalloutMock mock = requests.get(req.getEndpoint().substringBefore('?'));
        if (mock != null) {
            return mock.respond(req);
        } else {
            System.debug('MultiRequestMock Exception');
                throw new CustomException('HTTP callout not supported for test methods');
        }
    }

    public void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }
}