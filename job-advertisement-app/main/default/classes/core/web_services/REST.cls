@RestResource(urlMapping='/*')
global with sharing class REST {    
    public static final String METHOD_POST = 'Post';
    public static final String METHOD_PUT = 'Put';
    public static final String METHOD_DELETE = 'Delete';
    public static final String METHOD_GET = 'Get';
    
    @HttpGet 
    global static void httpGet() {             
        processRequest(METHOD_GET,RestContext.request, RestContext.response);
        
    }
    
    @HttpPost
    global static void httpPost() {       
        processRequest(METHOD_POST,RestContext.request, RestContext.response);
    } 
    
    @HttpPut   
    global static void httpPut() {      
        processRequest(METHOD_PUT,RestContext.request, RestContext.response);
    }
    
    
    @HttpDelete    
    global static void httpDelete() {
        processRequest(METHOD_DELETE,RestContext.request, RestContext.response);
        
    } 
    
    private static void processRequest(String httpMethod, RestRequest request, RestResponse response){
        try{           
            RestInterface webServiceX = new RestManager().getWebService(request);                        
            if(httpMethod.equals(METHOD_POST)){
                webServiceX.doPost(request, response);                  
            }
            else if(httpMethod.equals(METHOD_PUT)){
                webServiceX.doPut(request, response);
            }
            else if(httpMethod.equals(METHOD_DELETE)){
                webServiceX.doDelete(request, response);
            }
            else{
                webServiceX.doGet(request, response);
            }          
        }
        catch(RestFullException exc){
            RESTUtils.getErrorResponse(response, exc);
        }
        
    }
    
    
    
    
    
}