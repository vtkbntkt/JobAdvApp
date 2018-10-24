public class JobAdvertisementWebService implements RestInterface {
    
    private JobAdvertisementService service;
     
    public JobAdvertisementWebService(){
        service = new JobAdvertisementService();
    }
    
    public void doGet(RestRequest request, RestResponse response){
        String jobAdsJson = service.getJobAdvertisements();
        response.responseBody = Blob.valueOf(JobAdsJson);      
    }
        
    public void doPost(RestRequest request, RestResponse response){
        List<String> errors = validate(request);
        if(!errors.isEmpty()){
            throw new ValidationRequestException(String.join(errors,','));
        } 
        String jobAdsJson = service.insertJobAdvertisementsByJson(request.requestBody.toString());
        response.responseBody = Blob.valueOf(JobAdsJson);
    }
    
    public void doPut(RestRequest request, RestResponse response){
        List<String> errors = validate(request);
        if(!errors.isEmpty()){
            throw new ValidationRequestException(String.join(errors,','));
        }         
        service.upsertJobAdvertisementsByJson(request.requestBody.toString());
        response.responseBody = Blob.valueOf(RESTUtils.STATUS_SUCCESS);
    }
    
    public void doDelete(RestRequest request, RestResponse response){
        List<String> errors = validate(request);
        if(!errors.isEmpty()){
            throw new ValidationRequestException(String.join(errors,','));
        } 
        service.removeJobAdvertisementByJson(request.requestBody.toString());
        response.responseBody = Blob.valueOf(RESTUtils.STATUS_SUCCESS);      
    }
    
    private List<String> validate(RestRequest request){
        List<String> errors = new List<String>();
        Blob body = request.requestBody;
        if(body==null){
            errors.add(RESTUtils.ERROR_NO_DATA);
        }
        return errors;
    }
    
    
    
}