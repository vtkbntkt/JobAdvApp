@isTest
private class RESTUtilsTest { 
    
    @IsTest static void test_getErrorResponse_NoRelevantWebServiceException(){
        //Given 
        RestResponse response = new RestResponse();
        Exception exc = new NoRelevantWebServiceException();
        Integer responseCode = 400;
        String responseMsg = 'Invalid web service URI';
        
        //When
        response = RESTUtils.getErrorResponse(response,exc);
        
        //Then
        System.assertEquals(responseCode, response.statusCode); 
        System.assertEquals(responseMsg, response.responseBody.toString());       
    }
    
    @IsTest static void test_getErrorResponse_ValidationRequestException(){
        //Given
        RestResponse response = new RestResponse();
        String responseMsg = 'No data';
        Exception exc = new ValidationRequestException(responseMsg);
        Integer responseCode = 400;
        
        
        //When
        response = RESTUtils.getErrorResponse(response,exc);
        
        //Then    
        System.assertEquals(responseCode, response.statusCode); 
        System.assertEquals(responseMsg, response.responseBody.toString());       
    }
    
    @IsTest static void test_getErrorResponse_InvalidBodyTypeException(){
        //Given
        RestResponse response = new RestResponse();
        Exception exc = new InvalidBodyTypeException();
        Integer responseCode = 400;
        String responseMsg = 'Invalid data type';
        
        //When
        response = RESTUtils.getErrorResponse(response,exc);
        
        //Then    
        System.assertEquals(responseCode, response.statusCode); 
        System.assertEquals(responseMsg, response.responseBody.toString());       
    }
    
    @IsTest static void test_getErrorResponse_InvalidBodyContentException(){
        //Given
        RestResponse response = new RestResponse();
        Exception exc = new InvalidBodyContentException();
        Integer responseCode = 400;
        String responseMsg = 'Invalid data content';
        
        //When
        response = RESTUtils.getErrorResponse(response,exc);
        
        //Then 
        System.assertEquals(responseCode, response.statusCode); 
        System.assertEquals(responseMsg, response.responseBody.toString());      
    }
    
    @IsTest static void test_getErrorResponse_UnknownException(){
        //Given
        RestResponse response = new RestResponse();
        Exception exc = new JsonException();
        Integer responseCode = 500;
        String responseMsg = 'Unknown error';
        
        //When
        response = RESTUtils.getErrorResponse(response,exc);
        
        //Then 
        System.assertEquals(responseCode, response.statusCode); 
        System.assertEquals(responseMsg, response.responseBody.toString());
       
    }
    
}