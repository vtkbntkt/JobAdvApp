@isTest
private class RESTTest { 
    
    @IsTest static void test_httpGetCorrectly(){
        //Given 
        Job_Advertisement__c jobAdv = new Job_Advertisement__c(name='Developer');
        insert jobAdv;
        RestRequest request = getRequest(null, REST.METHOD_GET,'.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpGet();
        
        //Then      
        List<Job_Advertisement__c> jobAdsFromResponse = 
            (List<Job_Advertisement__c>)System.JSON.deserialize(response.responseBody.toString(),List<Job_Advertisement__c>.class);
        System.assertEquals(1, jobAdsFromResponse.size());
        System.debug(response.responseBody.toString());
    }
    
    @IsTest static void test_httpGetInvalidUri(){
        RestRequest request = getRequest(null, REST.METHOD_GET,'.../Test/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When      
        REST.httpGet();
        
        //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_INVALID_URI, response.responseBody.toString());     
    }
    
    @IsTest static void test_httpPostCorrectly(){
        //Given        
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager"}}';
        RestRequest request = getRequest(json, REST.METHOD_POST, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpPost();
        
        //Then
        List<Job_Advertisement__c> jobAds = [SELECT name FROM Job_Advertisement__c WHERE name='Developer' OR name='Manager'];
        System.assertEquals(2, jobAds.size());        
        Map<String,Job_Advertisement__c> jobAdsFromResponse = Utils.blob2JobAdsWithIds(response.responseBody);
        System.assertEquals(2, jobAdsFromResponse.size());
    }
    
    @IsTest static void test_httpPostInvalidUri(){
        //Given        
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager"}}';
        RestRequest request = getRequest(json, REST.METHOD_POST, '.../Test/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpPost();
        
        //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_INVALID_URI, response.responseBody.toString());
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_httpPostEmptyBody(){
        //Given        
        RestRequest request = getRequest(null, REST.METHOD_POST, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpPost();
        
        //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_NO_DATA, response.responseBody.toString());
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_httpPostInvalidBodyType(){
        //Given        
        String json = '{"1":{"Name","Developer"},"2":{"Name":"Manager"}}';
        RestRequest request = getRequest(json, REST.METHOD_POST, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpPost();
        
        //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_IVALID_TYPE, response.responseBody.toString());
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
     @IsTest static void test_httpPostInvalidBodyContent(){
        //Given        
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager","Status__c":"Undefined"}}';
        RestRequest request = getRequest(json, REST.METHOD_POST, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpPost();
        
        //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_INVALID_CONTENT, response.responseBody.toString());
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_httpPutCorrectly(){
        //Given - test insert  
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager"}}';
        RestRequest request = getRequest(json, REST.METHOD_PUT, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When - test insert
        REST.httpPut();
        
         //Then - test insert
        List<Job_Advertisement__c> jobAds = [SELECT id, name FROM Job_Advertisement__c WHERE name='Developer' OR name='Manager'];
        System.assertEquals(2, jobAds.size());
        System.assertEquals(RESTUtils.STATUS_SUCCESS, response.responseBody.toString());
        
        //Given - test update
        Map<String,Job_Advertisement__c> newRecords = new Map<String,Job_Advertisement__c>();
        newRecords.put('3',new Job_Advertisement__c(name='Accountant'));
        newRecords.put('4',jobAds.get(0));
        newRecords.put('5',jobAds.get(1));
        json = Utils.jobAdsList2JsonAsString(newRecords);
        request = getRequest(json, REST.METHOD_PUT,'.../JobAdv/');
        
        //When - test update
        REST.httpPut();
        
        //Then - test update
        jobAds = [SELECT name FROM Job_Advertisement__c ];
        System.assertEquals(3, [SELECT name FROM Job_Advertisement__c ].size());
        System.assertEquals(RESTUtils.STATUS_SUCCESS, response.responseBody.toString());
    }
    
    @IsTest static void test_httpPutInvalidUri(){
        //Given        
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager"}}';
        RestRequest request = getRequest(json, REST.METHOD_POST, '.../Invalid/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpPut();
        
        //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_INVALID_URI, response.responseBody.toString());
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_httpPutEmptyBody(){
        //Given        
        RestRequest request = getRequest(null, REST.METHOD_PUT, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpPut();
        
        //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_NO_DATA, response.responseBody.toString());
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_httpPutInvalidBodyType(){
        //Given        
        String json = '{"1":{"Name","Developer"},"2":{"Name":"Manager"}}';
        RestRequest request = getRequest(json, REST.METHOD_PUT, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpPut();
        
        //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_IVALID_TYPE, response.responseBody.toString());
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_httpPutInvalidBodyContent(){
        //Given        
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager","Status__c":"Undefined"}}';
        RestRequest request = getRequest(json, REST.METHOD_PUT, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpPut();
        
        //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_INVALID_CONTENT, response.responseBody.toString());
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_httpDeleteCorrectly(){
        //Given
        Job_Advertisement__c jobAdv = new Job_Advertisement__c(name='Developer');
        insert jobAdv;       
        Map<String,Job_Advertisement__c> records = new Map<String,Job_Advertisement__c>();
        records.put('15',jobAdv);
        String json = 
            Utils.jobAdsList2JsonAsString(records);
        RestRequest request = getRequest(json, REST.METHOD_DELETE,'.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpDelete();
        
        //Then        
        List<Job_Advertisement__c> jobAds = [SELECT name FROM Job_Advertisement__c];
        System.assert(jobAds.isEmpty());
        System.assertEquals(RESTUtils.STATUS_SUCCESS, response.responseBody.toString());
    }
    
    @IsTest static void test_httpDeleteInvalidUri(){
        //Given        
        Job_Advertisement__c jobAdv = new Job_Advertisement__c(name='Developer');
        insert jobAdv;       
        Map<String,Job_Advertisement__c> records = new Map<String,Job_Advertisement__c>();
        records.put('15',jobAdv);
        String json = 
            Utils.jobAdsList2JsonAsString(records);
        RestRequest request = getRequest(json, REST.METHOD_DELETE, '.../Invalid/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpDelete();
        
        //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_INVALID_URI, response.responseBody.toString());
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(1, advNum);
    }
    
     @IsTest static void test_httpDeleteEmptyBody(){
        //Given   
         Job_Advertisement__c jobAdv = new Job_Advertisement__c(name='Developer');
        insert jobAdv;       
        Map<String,Job_Advertisement__c> records = new Map<String,Job_Advertisement__c>();
        records.put('15',jobAdv);
        String json = 
            Utils.jobAdsList2JsonAsString(records);     
        RestRequest request = getRequest(null, REST.METHOD_DELETE, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpDelete();
        
        //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_NO_DATA, response.responseBody.toString());
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(1, advNum);
    }
    
    @IsTest static void test_httpDeleteInvalidBodyType(){
        //Given  
        Job_Advertisement__c jobAdv = new Job_Advertisement__c(name='Developer');
        insert jobAdv;       
        Map<String,Job_Advertisement__c> records = new Map<String,Job_Advertisement__c>();
        records.put('15',jobAdv);
        String json = Utils.jobAdsList2JsonAsString(records);
        json = json.replace(':',',');
        
        RestRequest request = getRequest(json, REST.METHOD_DELETE, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpDelete();
        
        //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_IVALID_TYPE, response.responseBody.toString());
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(1, advNum);
    }
    
     @IsTest static void test_httpDeleteInvalidBodyContent(){
        //Given
        Job_Advertisement__c jobAdv = new Job_Advertisement__c(name='Developer');
        insert jobAdv;       
        Map<String,Job_Advertisement__c> records = new Map<String,Job_Advertisement__c>();
        records.put('15',jobAdv);
        String json = 
            Utils.jobAdsList2JsonAsString(records);
        RestRequest request = getRequest(json, REST.METHOD_DELETE,'.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        REST.httpDelete();
        
        //Then        
        List<Job_Advertisement__c> jobAds = [SELECT name FROM Job_Advertisement__c];
        System.assert(jobAds.isEmpty());
        System.assertEquals(RESTUtils.STATUS_SUCCESS, response.responseBody.toString());
         
         //When
         REST.httpDelete();
         
         //Then
        System.assertEquals(RESTUtils.STATUS_CODE_BAD_REQUEST, response.statusCode);
        System.assertEquals(RESTUtils.ERROR_INVALID_CONTENT, response.responseBody.toString());
    }
   
    
    
    private static RestRequest getRequest(String jsonBody, String method, String requestUri){
        RestRequest request = new RestRequest();
        request.httpMethod = method;
        if(jsonBody!=null){
            request.requestBody = Blob.valueOf(jsonBody);
        }
        request.addHeader('Content-Type', 'application/json');
        request.requestUri = requestUri;
        RestContext.request = request;
        return request;    
    }
    
}