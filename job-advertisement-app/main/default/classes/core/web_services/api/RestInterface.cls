public interface RestInterface {  
    void doGet(RestRequest request, RestResponse response);
    void doPut(RestRequest request, RestResponse response);
    void doPost(RestRequest request, RestResponse response);
    void doDelete(RestRequest request, RestResponse response);
    
}