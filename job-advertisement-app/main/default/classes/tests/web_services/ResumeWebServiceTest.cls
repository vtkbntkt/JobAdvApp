@isTest
private class ResumeWebServiceTest {
    
    @isTest private static void test_doGetCorrectly_RecordList(){
        //Given
        Map<String,String> params = new Map<String,String>();
        params.put('createdDate', '2018-10-10');
        params.put('pageNumber', '1');
        RestRequest request = getRequest('GET',params);
        RestResponse response = new RestResponse();
        RestContext.response = response;
        new ResumeWebService();  

        //When
        Test.startTest();
        new ResumeWebService(new ResumeServiceMock()).doGet(request, response);
        Test.stopTest();

        //Then
        System.assertEquals('ok', response.responseBody.toString());
    }

    @isTest private static void test_doGetCorrectly_RecordNumber(){
        //Given
        Map<String,String> params = new Map<String,String>();
        params.put('createdDate', '2018-10-10');
        RestRequest request = getRequest('GET',params);
        RestResponse response = new RestResponse();
        RestContext.response = response;
        new ResumeWebService();  

        //When
        Test.startTest();
        new ResumeWebService(new ResumeServiceMock()).doGet(request, response);
        Test.stopTest();

        //Then
        System.assertEquals('10', response.responseBody.toString());
    }
    @isTest private static void test_doGetRequestInvalidPageNumberExc(){
        Map<String,String> params = new Map<String,String>();
        params.put('createdDate', '2018-10-10');
        params.put('pageNumber', '$');
        RestRequest request = getRequest('GET',params);
        RestResponse response = new RestResponse();
        RestContext.response = response;
        ResumeServiceMock resumeService = new ResumeServiceMock();
         
        //When
        Test.startTest();
        try{
            new ResumeWebService(new ResumeServiceMock()).doGet(request, response);
            System.assert(false, 'expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf ValidationRequestException);
        }
        
        Test.stopTest();
    }
    @isTest private static void test_doGetRequestNoParamsExc(){
        RestRequest request = getRequest('GET',null);
        RestResponse response = new RestResponse();
        RestContext.response = response;
        ResumeServiceMock resumeService = new ResumeServiceMock();
         
        //When
        Test.startTest();
        try{
            new ResumeWebService(new ResumeServiceMock()).doGet(request, response);
            System.assert(false, 'expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf ValidationRequestException);
        }
        
        Test.stopTest();
    }
    @isTest private static void test_doGetRequestInvalidParamsExc(){
        Map<String,String> params = new Map<String,String>();
        params.put('createdDate', '2018-10-10');
        params.put('pageNumber', '1');
        RestRequest request = getRequest('GET',params);
        RestResponse response = new RestResponse();
        RestContext.response = response;
        ResumeServiceMock resumeService = new ResumeServiceMock();
        resumeService.testDataSet.put('exc', new ResumeServiceImplException());  

        //When
        Test.startTest();
        try{
            new ResumeWebService(resumeService).doGet(request, response);
            System.assert(false,'expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf InvalidParamsException);
        }
        Test.stopTest();
    }
    @isTest private static void test_doGetNoResults(){
        Map<String,String> params = new Map<String,String>();
        params.put('createdDate', '2018-10-11');
        params.put('pageNumber', '1');
        RestRequest request = getRequest('GET',params);
        RestResponse response = new RestResponse();
        RestContext.response = response;  

        //When
        Test.startTest();
        new ResumeWebService(new ResumeServiceMock()).doGet(request, response);
        Test.stopTest();

        //Then
        System.assertEquals(RESTUtils.STATUS_NO_RESULTS, response.responseBody.toString());
    }
    @isTest private static void test_doPostExc(){
        //Given
        RestRequest request = getRequest('POST',null);
        RestResponse response = new RestResponse();

        //When
        Test.startTest();
        try{
            new ResumeWebService(new ResumeServiceMock()).doPost(request, response);
            System.assert(false,'expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf InvalidMethodException);
        } 
    }
    @isTest private static void test_doPutExc(){
        //Given
        RestRequest request = getRequest('PUT',null);
        RestResponse response = new RestResponse();

        //When
        Test.startTest();
        try{
            new ResumeWebService(new ResumeServiceMock()).doPut(request, response);
            System.assert(false,'expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf InvalidMethodException);
        } 
        
    }
    @isTest private static void test_doDeleteExc(){
        //Given
        RestRequest request = getRequest('DELETE',null);
        RestResponse response = new RestResponse();

        //When
        Test.startTest();
        try{
            new ResumeWebService(new ResumeServiceMock()).doDelete(request, response);
            System.assert(false,'expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceOf InvalidMethodException);
        } 
    }


    private static RestRequest getRequest(String method, Map<String,String> params){
        RestRequest request = new RestRequest();
        request.httpMethod = method;
        if(params!=null){
            for(String key:params.keySet()){
                request.params.put(key, params.get(key));

            }
            
        }
        RestContext.request = request;
        return request;    
    }

    private class ResumeServiceMock implements IresumeService{
        public Map<String,Object> testDataSet{get;set;}

        public ResumeServiceMock(){
            testDataSet = new Map<String,Object>();
        }

        public String getResumesAndJobAdsByResumeCreatedDate(String createdDate, Integer pageNumber, Integer pageSize){
             if(testDataSet.containsKey('exc')){
                 throw (ResumeServiceImplException)testDataSet.get('exc');
             }
             if(createdDate.equals('2018-10-10')){
                 return 'ok';
             }
             return null;
         }

         public String getResumesAndJobAdsNumberByResumeCreatedDate(String createdDate){
             return '10';
         }

         public void addResumeWithJobAds(Resume__c cv, List<Job_Advertisement__c> jobAds){

         }

         public void attachPhotoToResume(Resume__c cv, String fileId){

         }
         

    }
}
