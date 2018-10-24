public class WrappedCV {    
    public Resume__c cv{get;set;}  
    public transient String photoName{get; set;}
    public transient String photoSize{get; set;}
    public transient String photoContentType{get; set;}
    public transient String photoAsString{get;set;}
    
    public WrappedCV(){ 
      cv = new Resume__c();  
    }
    
    public void clearPhotoDetails(){
     photoName = null;   
     photoSize = null;
     photoContentType = null;   
     photoAsString = null;  
    }

}