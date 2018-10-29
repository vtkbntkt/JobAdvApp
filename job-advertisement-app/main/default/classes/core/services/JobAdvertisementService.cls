public class JobAdvertisementService {
     
    public String getJobAdvertisements(){
        List<Job_Advertisement__c> jobAds = 
            [SELECT id, Description__c, Education__c, Email__c, 
             Manager_name__c,Phone__c,  Salary_from__c, Salary_to__c, Location__c, Skills_Required__c,Status__c,Name
             FROM Job_Advertisement__c];
       return JSON.serialize(jobAds); 
    }
    
    public String insertJobAdvertisementsByJson(String httpBody){       
        Map<String, Job_Advertisement__c> jobAds = new Map<String, Job_Advertisement__c>();
        try{
            jobAds = Utils.blob2JobAdsWithIds(httpBody);
            insert jobAds.values();
        }
        catch(JsonException exc){
            throw new InvalidBodyTypeException();
        }
        catch (DmlException exc){
            throw new InvalidBodyContentException();
        }       
        return JSON.serialize(jobAds);
    }
    
    public void upsertJobAdvertisementsByJson(String httpBody){
        Map<String, Job_Advertisement__c> jobAds = new Map<String, Job_Advertisement__c>();
        try{
            jobAds = Utils.blob2JobAdsWithIds(httpBody);
            upsert jobAds.values(); 
        }
        catch(JsonException exc){
            throw new InvalidBodyTypeException();
        }
        catch (DmlException exc){
            throw new InvalidBodyContentException();
        }         
    }
    
    public void removeJobAdvertisementByJson(String httpBody){
        Map<String, Job_Advertisement__c> jobAds = new Map<String, Job_Advertisement__c>();
        try{
            jobAds = Utils.blob2JobAdsWithIds(httpBody);
            delete jobAds.values(); 
        }
        catch(JsonException exc){
            throw new InvalidBodyTypeException();
        }
        catch (DmlException exc){
            throw new InvalidBodyContentException();
        }  
        
    }
    
    
    
    
    
}