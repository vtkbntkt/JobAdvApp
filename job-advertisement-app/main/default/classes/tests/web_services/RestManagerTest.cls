@isTest
private class RestManagerTest { 
    
    @IsTest static void test_getWebServiceCorrectly(){
        //Given - case 1    
        String URI = '/JobAdv/';
        RestRequest request = new RestRequest();
        request.requestURI =URI; 
        RestManager restManager = new RestManager();
        RestInterface webServiceX;
        
        //When
        webServiceX = restManager.getWebService(request);
        
        //Then
        System.assert(webServiceX instanceof JobAdvertisementWebService);
        
        
        //Given - case 2       
        URI = '/JobAdv/params?...';
        request.requestURI =URI; 
        
        //When
        webServiceX = restManager.getWebService(request);
        
        //Then
        System.assert(webServiceX instanceof JobAdvertisementWebService);
        
        
        //Given  - case 3      
        URI = '/JobAdv';
        request.requestURI =URI; 
        
        //When
        webServiceX = restManager.getWebService(request);
        
        //Then
        System.assert(webServiceX instanceof JobAdvertisementWebService);        
    }
    
    @IsTest static void test_getWebServiceCorrectlyExc(){
        //Given        
        String URI = '';
        RestRequest request = new RestRequest();
        request.requestURI =URI; 
        RestManager restManager = new RestManager();
        RestInterface webServiceX;
        
        //When
        try{
            webServiceX = restManager.getWebService(request);
            System.assert(false, 'Expected exception');
        }
        catch(Exception exc){
            //Then
            System.assert(exc instanceof NoRelevantWebServiceException);
        }        
    }
    
}