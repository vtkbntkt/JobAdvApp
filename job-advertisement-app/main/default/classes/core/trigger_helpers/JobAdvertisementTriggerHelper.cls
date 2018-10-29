public class JobAdvertisementTriggerHelper {
    
    public static void manageSentResumesRemoval(Map<Id, Job_Advertisement__c> oldJobAds, Map<Id, Job_Advertisement__c> newJobAds){
        Map<String, Set<String>> fieldValues = new Map<String, Set<String>>();
        fieldValues.put('Status__c',new Set<String>{'Archive'});
        TriggerUtils.RecordFilter filter = new TriggerUtils.RecordFilter (oldJobAds, newJobAds, fieldValues,'Status__c');        
        List<Job_Advertisement__c> jobAds = filter.getFilteredList();    
        if(!jobAds.isEmpty()){
            Map<Id, Job_Advertisement__c> jobAdvMap = new Map<Id, Job_Advertisement__c>(jobAds);
            try{
                deleteSentResume(new List<Id>(jobAdvMap.keySet()));
            }
            catch(DMLException exc){
                throw new SentResumeRemovalException('Error to remove sent resumes',exc);
            } 
        } 
    }

    private static void deleteSentResume(List<Id> jobAdvId){
        List<SentResume__c> sentResumes = [SELECT id FROM SentResume__c WHERE Job_Advertisement__c IN :jobAdvId];
        if (!sentResumes.isEmpty()){
            delete sentResumes;
        }
    }

    public class SentResumeRemovalException extends Exception{}


}
