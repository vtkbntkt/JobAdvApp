public class ResumeWebService implements RestInterface {
    public static final Integer RECORD_LIMIT = 100;
    
    private IresumeService resumeService;
     
    public ResumeWebService(){
        this(new ResumeServiceImpl());
    }

    public ResumeWebService(IresumeService resumeService){
        this.resumeService = resumeService;
     
    }
    
    public void doGet(RestRequest request, RestResponse response){
        Map<String, String> params = request.params;
        String result;
        if(params.isEmpty()){
            throw new ValidationRequestException(RESTUtils.ERROR_NO_PARAMS);
        } 
        try{
            String pageNumber = params.get(RESTUtils.PARAMS_PAGE_NUMBER);
            String createdDate = params.get(RESTUtils.PARAMS_CREATED_DATE);
            if (pageNumber!=null){
                Integer pageNumberInt = Integer.valueOf(pageNumber);
                result = resumeService.getResumesAndJobAdsByResumeCreatedDate(createdDate, pageNumberInt, RECORD_LIMIT);
            }
            else{
                result = resumeService.getResumesAndJobAdsNumberByResumeCreatedDate(createdDate);
            }
        }
        catch(ResumeServiceImplException exc){
            throw new InvalidParamsException(exc);
        }
        catch(TypeException exc){
            throw new ValidationRequestException(RESTUtils.ERROR_IVALID_PARAMS);
        }
        if (result==null){
            result = RESTUtils.STATUS_NO_RESULTS;
        }
        response.responseBody = Blob.valueOf(result);    
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
