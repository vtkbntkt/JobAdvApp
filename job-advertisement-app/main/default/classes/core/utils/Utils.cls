public class Utils {
    
    public static String jobAdsList2JsonAsString(Map<String,Job_Advertisement__c> jobAds){       
        return JSON.serialize(jobAds);
    }
     
    public static Map<String,Job_Advertisement__c> blob2JobAdsWithIds(Blob body){
        Map<String,Job_Advertisement__c> jobAds = 
            (Map<String,Job_Advertisement__c>) JSON.deserialize(body.toString(), Map<String,Job_Advertisement__c>.class);
        return jobAds;
    }
    
    public static Map<String,Job_Advertisement__c> blob2JobAdsWithIds(String body){
        Map<String,Job_Advertisement__c> jobAds = 
            (Map<String,Job_Advertisement__c>) JSON.deserialize(body, Map<String,Job_Advertisement__c>.class);
        return jobAds;
    }
    
   
    
    

}