/*
	Description  : Input Location controller class.
	Created By   : Abhinav Sharma
*/
public with sharing class InputLocation {

    private static String googleMapsAPIKey;
    private static String GET_PREDICTIONS_URL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    private static String GET_PLACES_URL = 'https://maps.googleapis.com/maps/api/place/details/json';

    // Google Maps API Place Autocomplete
    // Documentation: https://developers.google.com/places/web-service/autocomplete

    @AuraEnabled
    public static LightningResponseEntity getPredictions(String input, String types, String components, String sessionToken) {
        if(String.isEmpty(sessionToken)) {
            sessionToken = String.valueOf(Crypto.getRandomLong());
        }
        String url = GET_PREDICTIONS_URL + '?' +
            'input='+ EncodingUtil.urlEncode(input, 'UTF-8') +
            '&language=' + UserInfo.getLanguage() +
            '&session_token=' + sessionToken;
        if(String.isNotBlank(components)) {
            url += components; // country:uk
        }
        if(String.isNotBlank(types)) {
            url += '&types=' + types;
        }
        url += '&key=' + getGoogleMapsAPIKey();

        String jsonResponse = makeAPICall(url);
        PredictionWrapper predictionWrapper = (PredictionWrapper) System.JSON.deserialize(jsonResponse, PredictionWrapper.class);
        predictionWrapper.sessionToken = sessionToken;
        for (Predictions prediction : predictionWrapper.predictions) {
            prediction.description = GenericUtils.xssSafeValue(prediction.description);
        }
        LightningResponseEntity lightningResponseEntity = LightningResponseEntity.create(predictionWrapper);
        return lightningResponseEntity;
    }

    @AuraEnabled
    public static LightningResponseEntity getPlaceDetails(String placeId, String sessionToken) {
        if(String.isEmpty(sessionToken)) {
            sessionToken = '';
        }
        String url = GET_PLACES_URL + '?' +
            'placeid=' + EncodingUtil.urlEncode(placeId, 'UTF-8')+
            '&language=' + UserInfo.getLanguage() +
            '&key=' + getGoogleMapsAPIKey() +
            '&session_token=' + sessionToken;

        String jsonResponse = makeAPICall(url);
        PlaceWrapper placeWrapper = (PlaceWrapper) System.JSON.deserialize(jsonResponse, PlaceWrapper.class);
        LightningResponseEntity lightningResponseEntity = LightningResponseEntity.create(placeWrapper);

        return lightningResponseEntity;
    }

    private static string makeAPICall(string url) {
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        httpRequest.setMethod('GET');
        httpRequest.setEndpoint(url);
        httpRequest.setTimeout(120000);
        httpResponse = http.send(httpRequest);

        if (httpResponse.getStatusCode() == 200){
            System.debug(httpResponse.getBody());
            return httpResponse.getBody();
        } else {
            System.debug(httpResponse.getStatusCode());
            System.debug(httpResponse.getBody());
            throw new AuraHandledException(httpResponse.getBody());
        }
    }

    private static string getGoogleMapsAPIKey() {
        if(googleMapsAPIKey != null) {
            return googleMapsAPIKey;
        }
        return 'vctrfgb45t76';
    }

    public class PredictionWrapper {
        @AuraEnabled public List<Predictions> predictions;
        @AuraEnabled public String sessionToken;
    }

    public class Matched_substrings {
        public Integer length;
        public Integer offset;
    }

    public String status;
    public List<Predictions> predictions;

    public class Predictions {
        @AuraEnabled public String description;
        @AuraEnabled public String id;
        @AuraEnabled public List<Matched_substrings> matched_substrings;
        @AuraEnabled public String place_id;
        @AuraEnabled public String reference;
        @AuraEnabled public List<Terms> terms;
        @AuraEnabled public List<String> types;
    }

    public class Terms {
        @AuraEnabled public Integer offset;
        @AuraEnabled public String value;
    }

    public class PlaceWrapper {
        // @AuraEnabled public List<Html_attributions> html_attributions;
        @AuraEnabled public Result result;
        @AuraEnabled public String status;
    }

    public class Address_components {
        @AuraEnabled public String long_name;
        @AuraEnabled public String short_name;
        @AuraEnabled public List<String> types;
    }

    public class Geometry {
        @AuraEnabled public Location location;
        public Viewport viewport;
    }

    public class Photos {
        public Integer height;
        public List<String> html_attributions;
        public String photo_reference;
        public Integer width;
    }

    public class Viewport {
        public Location northeast;
        public Location southwest;
    }

    public class Html_attributions {
    }

    public class Location {
        @AuraEnabled public Double lat;
        @AuraEnabled public Double lng;
    }

    public class Result {
        @AuraEnabled public Geometry geometry;
        @AuraEnabled public List<Address_components> address_components;
        public String adr_address;
        @AuraEnabled public String formatted_address;
        public String icon;
        public String id;
        public String name;
        public List<Photos> photos;
        public String place_id;
        public String reference;
        public String scope;
        public List<String> types;
        public String url;
        public Integer utc_offset;
        public String vicinity;
    }

}