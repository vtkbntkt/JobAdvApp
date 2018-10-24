public class ResumeServiceImpl implements IresumeService {
     
    public void addResumeWithJobAds(Resume__c cv, List<Job_Advertisement__c> jobAds){
       Savepoint savePoint = Database.setSavepoint();
        try{
           upsert cv cv.email__c;
           insert prepareSentResumes(jobAds,cv);           
        }
        catch(DMLException exc){
            Database.rollback(savePoint);
            throw new ResumeServiceImplException(exc.getMessage(),exc);
        }
    }

    public void attachPhotoToResume(Resume__c cv, String fileId){
        try{
            cv.PhotoFileId__c = fileId;
            update cv;
        }
        catch(DMLException exc){
            throw new ResumeServiceImplException(exc.getMessage(),exc);
        }
    }
    
    private List<SentResume__c> prepareSentResumes(List<Job_Advertisement__c> jobAds, Resume__c cv ){
       List<SentResume__c> sentResumes = new List<SentResume__c>();
        Id cvId = cv.id;
        for(Job_Advertisement__c jobAdv:jobAds){
            sentResumes.add(new SentResume__c(Job_Advertisement__c=jobAdv.id, Resume__c = cvId));
        }
        return sentResumes;
    }
    
    
   
    
    

}