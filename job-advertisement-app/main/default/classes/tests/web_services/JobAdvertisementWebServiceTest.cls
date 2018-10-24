@isTest
private class JobAdvertisementWebServiceTest { 
    
    @IsTest static void test_doGetCorrectly(){
        //Given 
        Job_Advertisement__c jobAdv = new Job_Advertisement__c(name='Developer');
        insert jobAdv;
        RestRequest request = getRequest(null, REST.METHOD_GET,'.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        new JobAdvertisementWebService().doGet(request, response);
        
        //Then      
        List<Job_Advertisement__c> jobAdsFromResponse = 
            (List<Job_Advertisement__c>)System.JSON.deserialize(response.responseBody.toString(),List<Job_Advertisement__c>.class);
        System.assertEquals(1, jobAdsFromResponse.size());
        System.debug(response.responseBody.toString());
    }
    
    
    
    @IsTest static void test_doPostCorrectly(){
        //Given        
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager"}}';
        RestRequest request = getRequest(json, REST.METHOD_POST, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        new JobAdvertisementWebService().doPost(request, response);
        
        //Then
        List<Job_Advertisement__c> jobAds = [SELECT name FROM Job_Advertisement__c WHERE name='Developer' OR name='Manager'];
        System.assertEquals(2, jobAds.size());        
        Map<String,Job_Advertisement__c> jobAdsFromResponse = Utils.blob2JobAdsWithIds(response.responseBody);
        System.assertEquals(2, jobAdsFromResponse.size());
    }
    
    
    @IsTest static void test_doPostEmptyBody(){
        //Given        
        RestRequest request = getRequest(null, REST.METHOD_POST, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        try{
            new JobAdvertisementWebService().doPost(request, response);
            System.assert(false,'Expected exception');
        }        
        catch(Exception exc){
            //Then
            System.assert(exc instanceof ValidationRequestException);    
        }
        
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_doPostInvalidBodyType(){
        //Given        
        String json = '{"1":{"Name","Developer"},"2":{"Name":"Manager"}}';
        RestRequest request = getRequest(json, REST.METHOD_POST, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        try{
            new JobAdvertisementWebService().doPost(request, response);
            System.assert(false,'Expected exception');
        } 
        catch(Exception exc){
            //Then
            System.assert(exc instanceof InvalidBodyTypeException );
        }
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_doPostInvalidBodyContent(){
        //Given        
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager","Status__c":"Undefined"}}';
        RestRequest request = getRequest(json, REST.METHOD_POST, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        try{
            new JobAdvertisementWebService().doPost(request, response);
            System.assert(false,'Expected exception');
        } 
        catch(Exception exc){
            //Then
            System.assert(exc instanceof InvalidBodyContentException);  
        }                 
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_doPutCorrectly(){
        //Given - test insert  
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager"}}';
        RestRequest request = getRequest(json, REST.METHOD_PUT, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        RestInterface jobAdvertisementWebService = new JobAdvertisementWebService();
        
        //When - test insert
        jobAdvertisementWebService.doPut(request, response);
        
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
        jobAdvertisementWebService.doPut(request, response);
        
        //Then - test update
        jobAds = [SELECT name FROM Job_Advertisement__c ];
        System.assertEquals(3, [SELECT name FROM Job_Advertisement__c ].size());
        System.assertEquals(RESTUtils.STATUS_SUCCESS, response.responseBody.toString());
    }
    
    
    
    @IsTest static void test_doPutEmptyBody(){
        //Given        
        RestRequest request = getRequest(null, REST.METHOD_PUT, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        try{
            new JobAdvertisementWebService().doPut(request, response);
            System.assert(false,'Expected exception');
        }        
        catch(Exception exc){
            //Then
            System.assert(exc instanceof ValidationRequestException);    
        }      
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_doPutInvalidBodyType(){
        //Given        
        String json = '{"1":{"Name","Developer"},"2":{"Name":"Manager"}}';
        RestRequest request = getRequest(json, REST.METHOD_PUT, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        try{
            new JobAdvertisementWebService().doPut(request, response);
            System.assert(false,'Expected exception');
        } 
        catch(Exception exc){
            //Then
            System.assert(exc instanceof InvalidBodyTypeException );
        }        
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    @IsTest static void test_doPutInvalidBodyContent(){
        //Given        
        String json = '{"1":{"Name":"Developer"},"2":{"Name":"Manager","Status__c":"Undefined"}}';
        RestRequest request = getRequest(json, REST.METHOD_PUT, '.../JobAdv/');
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        //When
        try{
            new JobAdvertisementWebService().doPut(request, response);
            System.assert(false,'Expected exception');
        } 
        catch(Exception exc){
            //Then
            System.assert(exc instanceof InvalidBodyContentException);  
        }         
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(0, advNum);
    }
    
    
    @IsTest static void test_doDeleteCorrectly(){
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
        new JobAdvertisementWebService().doDelete(request, response);
        
        //Then        
        List<Job_Advertisement__c> jobAds = [SELECT name FROM Job_Advertisement__c];
        System.assert(jobAds.isEmpty());
        System.assertEquals(RESTUtils.STATUS_SUCCESS, response.responseBody.toString());
    }
    
    
    
    @IsTest static void test_doDeleteEmptyBody(){
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
        try{
            new JobAdvertisementWebService().doDelete(request, response);
            System.assert(false,'Expected exception');
        }
        catch(Exception exc){
            System.assert(exc instanceof ValidationRequestException);  
        }
        
        //Then
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(1, advNum);
    }
    
    @IsTest static void test_doDeleteInvalidBodyType(){
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
        try{
            new JobAdvertisementWebService().doDelete(request, response);
            System.assert(false,'Expected exception');
        }
        catch(Exception exc){
            System.assert(exc instanceof InvalidBodyTypeException);  
        }
        
        //Then
        Integer advNum = [SELECT COUNT() FROM Job_Advertisement__c];
        System.assertEquals(1, advNum);
    }
    
    @IsTest static void test_doDeleteInvalidBodyContent(){
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
        new JobAdvertisementWebService().doDelete(request, response);
        
        //Then        
        List<Job_Advertisement__c> jobAds = [SELECT name FROM Job_Advertisement__c];
        System.assert(jobAds.isEmpty());
        System.assertEquals(RESTUtils.STATUS_SUCCESS, response.responseBody.toString());
        
        //When
        try{
            new JobAdvertisementWebService().doDelete(request, response);
            System.assert(false,'Expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceof InvalidBodyContentException);  
        }             
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