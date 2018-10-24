public class RESTUtils { 
    public static final String ERROR_NO_DATA = 'No data';
    public static final String ERROR_IVALID_TYPE = 'Invalid data type';
    public static final String ERROR_INVALID_CONTENT = 'Invalid data content';
    public static final String ERROR_INVALID_URI = 'Invalid web service URI';
    public static final String ERROR_UNKNOWN_ERROR = 'Unknown error';
    public static final String STATUS_SUCCESS = 'The operation is successful';
    public static final Integer STATUS_CODE_BAD_REQUEST = 400;
    public static final Integer STATUS_CODE_SUCCESS = 200;
    public static final Integer STATUS_CODE_ISE = 500;
    
    public static RestResponse getErrorResponse(RestResponse response, Exception exc) {
        Integer statusCode = STATUS_CODE_ISE;
        String errorMessage = ERROR_UNKNOWN_ERROR;
        if (exc instanceof NoRelevantWebServiceException) {
            statusCode = STATUS_CODE_BAD_REQUEST;
            errorMessage = ERROR_INVALID_URI;
        } else if (exc instanceof ValidationRequestException) {
            statusCode = STATUS_CODE_BAD_REQUEST;
            errorMessage = exc.getMessage();
        }        
        else if(exc instanceof InvalidBodyTypeException){
            statusCode = STATUS_CODE_BAD_REQUEST;
            errorMessage = ERROR_IVALID_TYPE; 
        }
        else if (exc instanceof InvalidBodyContentException){
            statusCode = STATUS_CODE_BAD_REQUEST;
            errorMessage = ERROR_INVALID_CONTENT;
        }
        return fillErrorResponse(response, statusCode, errorMessage);
    }
    
    private static  RestResponse fillErrorResponse(RestResponse response, Integer statusCode, String errorMsg) {
        response.statusCode = statusCode;
        response.responseBody = Blob.valueOf(errorMsg);
        System.debug('*** RestUtils error: '+errorMsg);
        return response;
    }  
    
    
    
    
    
}