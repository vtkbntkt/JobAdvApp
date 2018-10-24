public class RestManager {
    
    private Map<String, RestInterface> webServices = new Map<String, RestInterface>();
    
     
    public RestManager() {
        webServices.put(WebServiceConstants.WEBSERVICE_JOB_ADVERTISEMENT, new JobAdvertisementWebService());
    }
    
    public RestInterface getWebService(RestRequest request) {
        String webServiceName  = getWebServiceName(request.requestURI);
        RestInterface webServiceX = webServices.get(webServiceName);
        if (webServiceX == null) {
            throw new NoRelevantWebServiceException();
        }
        return webServiceX;
    }
    
    private String getWebServiceName(String uri){
        String name = uri.substring(uri.indexOf('/')+1);
        Integer slashIndex = name.indexOf('/');
        if(slashIndex>0){
            return name.substring(0,slashIndex);
        }
        return name;
    }
    
}