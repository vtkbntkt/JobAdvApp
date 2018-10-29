public class ResumeWebService implements RestInterface {
    
    private IresumeService resumeService;
     
    public ResumeWebService(){
        this(new ResumeServiceImpl());
    }

    public ResumeWebService(IresumeService resumeService){
        this.resumeService = resumeService;
     
    }
    
    public void doGet(RestRequest request, RestResponse response){
        Map<String, String> params = request.params;
        String resumes;
        if(params.isEmpty()){
            throw new ValidationRequestException(RESTUtils.ERROR_NO_PARAMS);
        } 
        try{
            resumes = resumeService.getResumesAndJobAdsByResumeCreatedDate(params.get(RESTUtils.PARAMS_CREATED_DATE));
        }
        catch(ResumeServiceImplException exc){
            throw new InvalidParamsException(exc);
        }
        if (resumes==null){
            resumes = RESTUtils.STATUS_NO_RESULTS;
        }
        response.responseBody = Blob.valueOf(resumes);    
    }
        
    public void doPost(RestRequest request, RestResponse response){
       throw new InvalidMethodException();
    }
    
    public void doPut(RestRequest request, RestResponse response){
        throw new InvalidMethodException();
    }
    
    public void doDelete(RestRequest request, RestResponse response){
        throw new InvalidMethodException();    
    }
}
