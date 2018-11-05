public interface IresumeService {    
    void addResumeWithJobAds(Resume__c cv, List<Job_Advertisement__c> jobAds);
    void attachPhotoToResume(Resume__c cv, String fileId);
    String getResumesAndJobAdsByResumeCreatedDate(String createdDate, Integer pageNumber, Integer pageSize);
    String getResumesAndJobAdsNumberByResumeCreatedDate(String createdDate);

}